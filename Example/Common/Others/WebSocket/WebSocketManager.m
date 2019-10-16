//
//  WebSocketManager.m
//  BitInfi
//
//  Created by 黄春晓 on 2018/2/9.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "WebSocketManager.h"
#import "SRWebSocket.h"
#import "WebSocketDataModel.h"
#import "WebSocketModel.h"

//MARK:--------------注释 禁用webSocket， 打来启用WebSocket（webSocket开关）
#define   WEBSOCKET_SWITCH

typedef enum{
    CurrentDataTypeNone = 0,   //无用信息
    CurrentDataTypeContractedList,
    CurrentDataTypeSingleContractId,
} CurrentDataType;
@interface WebSocketManager ()<SRWebSocketDelegate,WebSocketDataModelDelegate>
{
     NSTimeInterval reConnectTime;
}
@property (nonatomic,strong)SRWebSocket * webSocket;
@property (nonatomic,strong)NSTimer *socketTimer;
@property (nonatomic,assign)CurrentDataType dataType;  //当前数据类型
@property (nonatomic,strong)WebSocketDataModel *dataModel; //
//创建一个线程调度队列,以提供给其他各模块执行耗时的代码（主要为数据库操作和数据处理操作）
@property (nonatomic) dispatch_queue_t workQueue;
@property (nonatomic,assign)NSInteger pongMissCount;  //防止发ping未收到Pong消息（超过5次重连）
@property (nonatomic,strong)BKCancellationToken delay;

@property (nonatomic,assign)NSInteger reconnectCount;
@property (nonatomic,strong)BKCancellationToken delayHander;
@end
@implementation WebSocketManager
-(instancetype)init
{
    if (self == [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillResignActive) name:UIApplicationWillResignActiveNotification object:nil];
       _workQueue = dispatch_queue_create("workQueue", NULL);
    }
    return self;
}

- (void)contractDataList{
    _dataType = CurrentDataTypeContractedList;
    NSString *url = [NSString stringWithFormat:@"%@/quotation?commodityId=*",[WebSocketModel sharedInstance].marketWssUrl];
    [self creatWebSocketLinkWithUrlString:url];
}

- (void)singleContractData:(NSString *)symbol{
    _dataType = CurrentDataTypeSingleContractId;
    NSString *url = [NSString stringWithFormat:@"%@/tickdata?symbol=%@",[WebSocketModel sharedInstance].marketWssUrl,symbol];
    [self creatWebSocketLinkWithUrlString:url];
}

- (void)contractOrderBook:(NSString *)symbol{
    _dataType = CurrentDataTypeSingleContractId;
    NSString *url = [NSString stringWithFormat:@"%@/orderbook?symbol=%@",[WebSocketModel sharedInstance].marketWssUrl,symbol];
    
    [self creatWebSocketLinkWithUrlString:url];
}

- (void)multipleContractData:(NSArray *)symbolList{
    NSString *symbols = @"";
    for (NSInteger i =0; i<symbolList.count; i++) {
        symbols = [symbols stringByAppendingFormat:@"%@,",[NDataUtil dataWithArray:symbolList index:i]];
    }
    if (symbols.length>1) {
        symbols = [symbols substringToIndex:symbols.length-1];
    }
    _dataType = CurrentDataTypeSingleContractId;
    NSString *url = [NSString stringWithFormat:@"%@/tickdata?symbol=%@",[WebSocketModel sharedInstance].marketWssUrl,symbols];
    [self creatWebSocketLinkWithUrlString:url];
}


//MARK:-------------- 创建统一接口
-(void)creatWebSocketLinkWithUrlString:(NSString *)urlString
{
#ifdef WEBSOCKET_SWITCH
    if (_webSocket) {
        return;
    }
    _urlString = urlString;
    _webSocket = [[SRWebSocket alloc]initWithURL:[NSURL URLWithString:urlString]];
    _webSocket.delegate = self;
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    queue.maxConcurrentOperationCount = 1;
    [_webSocket setDelegateOperationQueue:queue];
    [_webSocket open];
#endif
}


#pragma mark - 创建定时器,
- (void)connectionCheckTimer
{
    if (_socketTimer == nil){
        dispatch_main_async_safe(^{
            self.socketTimer = [NSTimer scheduledTimerWithTimeInterval:10.0f
                                                            target:self
                                                          selector:@selector(sendPing)
                                                          userInfo:nil
                                                           repeats:YES];
            [[NSRunLoop currentRunLoop]addTimer:self.socketTimer forMode:NSRunLoopCommonModes];
        });
    }
}
//MARK:--------------发送心跳包
-(void)sendPing
{
    _pongMissCount ++;
    if (_pongMissCount > 5) {
        [self reconnect];
        return;
    }
    if (_webSocket.readyState == SR_OPEN) {
        NSDictionary *parameter = @{@"ping":@"123456"};
        [_webSocket sendString:[parameter modelToJSONString] error:NULL];
    }else{
        //连接断开，重新连接
        if (_webSocket.readyState > SR_OPEN)
        {
            [self reconnect];
        }
    }
    
}
/**
 *  闭关socket连接:
 */
-(void) disconnect
{
    [NTimeUtil cancelDelay:_delay];
    //重连时间清除
    reConnectTime = 0;
    if (_webSocket)
    {
        [_webSocket close];
        _webSocket.delegate = nil;
        _webSocket = nil;
    }
    
    if (_socketTimer) {
        [_socketTimer invalidate];
        _socketTimer = nil;
    }
}

/**
 *  重新打开连接
 */
-(void) reconnect
{
    [self disconnect];
    
    _reconnectCount ++;
    WEAK_SELF;
    if (_reconnectCount > 15) {
        _delay = [NTimeUtil run:^{
            //重新建立连接
            [weakSelf creatWebSocketLinkWithUrlString:weakSelf.urlString];
        } delay:15];
    }else if (_reconnectCount > 5) {
        _delay = [NTimeUtil run:^{
            //重新建立连接
            [weakSelf creatWebSocketLinkWithUrlString:weakSelf.urlString];
        } delay:5];
    }else{
        weakSelf.webSocket = nil;
        //重新建立连接
        [weakSelf creatWebSocketLinkWithUrlString:weakSelf.urlString];
    }
}

/**
 *  发送数据
 */
-(void) send:(id)data
{
    
}


//MARK:--------------SRWebSocketDelegate
-(void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    _reconnectCount = 0;
    _pongMissCount = 0;
    //连接成功重连时间清零
    reConnectTime = 0;
    //发送心跳包
    [self connectionCheckTimer];
}

-(void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    dispatch_async(_workQueue, ^{
        //如果是pong包，不处理该数据
        if ([message rangeOfString:@"pong"].location != NSNotFound) {
            self.pongMissCount = 0;
            self.reconnectCount = 0;
            return;
        }
        //解析数据
        [self.dataModel webSocketAnalysisDataType:(WebSocketDataToolType)self.dataType withData:message];
    });
//    NSLog(@"%@---%@",message,[NSThread currentThread]);
}
//链接失败
-(void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"连接失败.....\n%@",error);
    //连接失败了就去重连
    [self reconnect];
}
//链接断开原因
-(void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    //连接失败了就去重连
    [self reconnect];
}
//sendPing的时候，如果网络通的话，则会收到回调，但是必须保证ScoketOpen，否则会crash
-(void)webSocket:(SRWebSocket *)webSocket didReceivePong:(NSData *)pongPayload
{
    
}


//MARK:--------------WebSocketDataModelDelegate
-(void)pushResultData:(NSArray *)dataArry
{
    if (_reciveMessage) {
        _reciveMessage(dataArry);
    }
}

-(void)dealloc
{
    [self disconnect];
    
    if (_dataModel) {
        [_dataModel deleteCurrentData];
        _dataModel.delegate = nil;
        _dataModel = nil;
    }
    [[NSNotificationCenter defaultCenter ]removeObserver:self];
}
//MARK:--------------notify
-(void)appDidBecomeActive
{
    if (_urlString==nil) {
        return;
    }
    if (self.target.window) {    
        [self reconnect];
    }
}
-(void)appWillResignActive
{
    [self disconnect];
}
//MARK:--------------lazy
-(WebSocketDataModel *)dataModel
{
    if (_dataModel ==nil) {
        _dataModel = [[WebSocketDataModel alloc]init];
        _dataModel.delegate = self;
    }
    return _dataModel;
}

@end

//
//  TradeChartsView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/5/10.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "TradeChartsView.h"
#import "DemoChartsModel.h"
#import "WebSocketManager.h"
#import "CFDHqDefine.h"


@interface  TradeChartsView()<UIGestureRecognizerDelegate>

@property (nonatomic,strong)BKCancellationToken delay;
@property (nonatomic,strong)NSMutableDictionary *config;
@property (nonatomic,copy) NSString *symbol;
@property (nonatomic, assign)EChartsLineType lineType;
@property (nonatomic, strong) DemoChartsModel *chartsModel;
@property (nonatomic, strong) WebSocketManager *webSocket;
@property (nonatomic, strong) NSOperationQueue *queue;

@property (nonatomic,assign) BOOL hasLoaded;
@property (nonatomic,assign)  NSInteger nChartLeftPos; //框的x坐标
@property (nonatomic,assign)  NSInteger nChartWidth;//框的宽度
@property (nonatomic,strong)  UITapGestureRecognizer *singleFingerTap;
@property (nonatomic, strong) BKCancellationToken delayKlineHander;
@property (nonatomic,assign)  EChartsType chartsType;
@property(nonatomic,assign)BOOL hasVol;

@end

@implementation TradeChartsView

- (void)dealloc
{
    _mLineView = nil;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initSome];
    }
    return self;
}

- (void)initSome
{
    _nChartLeftPos = 0;
    _nChartWidth = SCREEN_WIDTH;
    _lineType = EChartsLineTypeTradePrice;
    _chartsType = EChartsType_RT;
    self.chartsModel= [[DemoChartsModel alloc] init] ;
    WEAK_SELF;
    _chartsModel.isDataAvailable = ^BOOL(NSString * _Nonnull symbol, EChartsType chartsType, EChartsLineType lineType) {
        if (![symbol isEqualToString:weakSelf.symbol]&&symbol.length>0) {
            return NO;
        }
        if (chartsType!=weakSelf.chartsType) {
            return NO;
        }
        if (lineType!=weakSelf.lineType) {
            return NO;
        }
        return YES;
    };
    _config = [NSMutableDictionary dictionary];
    [self addSubview:self.mLineView];
    
}

- (void)willAppear{
    [self loadKline];
    [self websocketLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)willDisappear{
    
    [_webSocket disconnect];
    _webSocket=nil;
    [_queue cancelAllOperations];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationWillEnterForegroundNotification object:nil];
    
}

//MARK: - LoadData

- (void)websocketLoad{
    if (_webSocket) {
        [_webSocket reconnect];
        return;
    }
    _queue = [[NSOperationQueue alloc] init];
    _webSocket = [[WebSocketManager alloc] init];
    _webSocket.target = self;
    [_webSocket singleContractData:_symbol];
    WEAK_SELF;
    [_webSocket setReciveMessage:^(NSArray *array) {
        NSLog(@"CFDChartsView的websocket收到数据");
        if (weakSelf.hasLoaded==NO) {
            return ;
        }
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:weakSelf selector:@selector(parseSocketData:) object:array];
        weakSelf.queue.maxConcurrentOperationCount = 1;
        [weakSelf.queue addOperation:operation];
    }];
}

- (void)parseSocketData:(NSArray *)array{
    WEAK_SELF;
    for (NSDictionary *dic in array) {
        if ([NDataUtil boolWithDic:dic key:@"S" isEqual:weakSelf.symbol]) {
            weakSelf.chartsModel.baseInfoData.closePrice = [NDataUtil stringWith:dic[@"c"] valid:@"1"];
            weakSelf.chartsModel.baseInfoData.lastPrice = [NDataUtil stringWith:dic[@"t"]];
            weakSelf.chartsModel.baseInfoData.bidp =  [NDataUtil stringWith:dic[@"b"]];
            weakSelf.chartsModel.baseInfoData.askp = [NDataUtil stringWith:dic[@"a"]];
            weakSelf.chartsModel.baseInfoData.volume = [NDataUtil stringWith:dic[@"V"]];
            BOOL hasNewPoint = [weakSelf.chartsModel updateMlineDataWithSocketDic:dic lineType:weakSelf.lineType];
            [weakSelf reloadSocketMlineCharts:hasNewPoint];
        }
    }
}

- (void)loadKline{
    if(_symbol.length>0) {
        WEAK_SELF;
        NSString *symbol = _symbol;
        EChartsType type = self.chartsType;
        EChartsLineType lineType = weakSelf.lineType;
        [self.chartsModel loadKlineData:symbol chartsType:type lineType:lineType success:^{
            weakSelf.hasLoaded = YES;
            [weakSelf updateMlineChartInfo];
        } failure:^{
            [NTimeUtil cancelDelay:weakSelf.delayKlineHander];
            weakSelf.delayKlineHander=[NTimeUtil run:^{
                [weakSelf loadKline];
            } delay:3];
        }];
    }
}

- (void)updateMlineChartInfo
{
    self.mLineView.dotNum = self.chartsModel.baseInfoData.dotNum;
    BOOL isClose = _chartsModel.baseInfoData.openStatusTrade == NSOpenStatusTradeNonTime||[_chartsModel.baseInfoData.tradestatus isEqualToString:@"0"];
    [self reloadCharts:EChartsType_RT isClose:isClose];
}

- (void)changedSymbol:(NSString *)symbol{
    _symbol = symbol;
    [self.chartsModel clearData];
    [self reloadCharts:EChartsType_RT isClose:NO];
    [_webSocket disconnect];
    _webSocket=nil;
    [_queue cancelAllOperations];
    [self.chartsModel clearData];
    _lineType=EChartsLineTypeTradePrice;
    [self clearData];
    _hasLoaded=NO;
    [self loadKline];
    [self websocketLoad];
}

- (void)clearData{
    [_config removeAllObjects];
    [_mLineView clearData];
}

- (void)reloadCharts:(EChartsType)chartsType isClose:(BOOL)isClose{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.isClose = isClose;
        [self reloadMoreCharts:chartsType moreCount:0];
    });
}

- (void)reloadSocketMlineCharts:(BOOL)hasNewPoint{
    if (_chartsType!=EChartsType_RT) {
        return;
    }
    if (![_mLineView.chartView isFocusing]) {
        NSArray *mlineList = [self.chartsModel getMLineDataCopy];
        if (mlineList.count>1) {
            [self configSocketMlineData:mlineList hasNewPoint:hasNewPoint];
        }
    }
}

- (void)reloadMoreCharts:(EChartsType)chartsType moreCount:(NSInteger)moreCount{
    if (_chartsType!=chartsType) {
        return;
    }
    WEAK_SELF;
    if ([self isCanReloadMLine]) {
        NSArray *mlineList = [self.chartsModel getMLineDataCopy];
        if (mlineList.count==0) {
            [self configMlineData:nil];
            [self showLoadView];
        }else{
            _delay=[NTimeUtil run:^{
                [StateUtil hide:weakSelf];
            } delay:0.1];
            [self configMlineData:mlineList];
        }
    }
}

- (void)showLoadView{
    [NTimeUtil cancelDelay:_delay];
    ProgressStateView *stateView = (ProgressStateView *)[StateUtil show:self type:StateTypeProgress];
    stateView.backgroundColor = [GColorUtil C6];
    [stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:0]);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:5]+CMainChartHight+CTimeAixsHight);
    }];
}


//MARK: - 赋值 绘图

- (void)configSocketMlineData:(NSArray *)mlineList hasNewPoint:(BOOL)hasNewPoint{
    [_mLineView configSocketChart:mlineList hasNewPoint:hasNewPoint];
}

- (void)configMlineData:(NSArray *)mlineList{
    
    [_mLineView configChart:mlineList];
}

//MARK: - Getter

- (void)setIsClose:(BOOL)isClose{
    _isClose = isClose;
    _mLineView.isClose = isClose;
}


- (MLineChartView*)mLineView
{
    if (!_mLineView) {
        CGRect rect = CGRectMake(_nChartLeftPos, 0, ceil(_nChartWidth),ceil( CMainChartHight+CTimeAixsHight));
        _mLineView = [[MLineChartView alloc] initWithFrame:rect hasVol:NO];
//        WEAK_SELF;
        _mLineView.hitSwitchH = ^{
//            [weakSelf vChartToHChart];
        };
        _mLineView.disenableScroll = ^(BOOL flag){
//            [weakSelf.delegate disenableScroll:flag];
        };
        _mLineView.isSingleCharts = YES;
    }
    return _mLineView;
}

//是否可以刷分时绘图 （十字线在时不能刷）
- (BOOL)isCanReloadMLine
{
    BOOL bRet = YES;
    if([_mLineView.chartView isFocusing])
        bRet = NO;
    return bRet;
}

@end


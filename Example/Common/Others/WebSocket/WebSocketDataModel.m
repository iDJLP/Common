//
//  WebSocketDataTool.m
//  BitInfi
//
//  Created by 黄春晓 on 2018/2/9.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "WebSocketDataModel.h"

@interface WebSocketDataModel ()
@property (nonatomic,strong) ThreadSafeArray *dataArray;
@property (nonatomic,strong) NSTimer *sendDataTimer;

@end
@implementation WebSocketDataModel

-(instancetype)init
{
    if (self = [super init]) {
        if (_sendDataTimer == nil) {
            dispatch_main_async_safe(^{
                self.sendDataTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(pushData) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:self.sendDataTimer forMode:NSRunLoopCommonModes];
            });
        }
    }
    return self;
}
//MARK:--------------method
//推送数据
-(void)pushData
{
    //无数据则不返回回调
    if (self.dataArray == nil) {
        return;
    }
    if (self.dataArray.count == 0) {
        return;
    }
    
    //中间变量array防止，数据失真
    NSArray *array = [NSArray arrayWithArray:self.dataArray];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(pushResultData:)]) {
        [self.delegate pushResultData:array];
    }
    //清空当前数组中的所有旧元素
    [self.dataArray removeObjectsInArray:array];
}
-(void)webSocketAnalysisDataType:(WebSocketDataToolType)dataType withData:(id)data
{
    switch (dataType) {
        case WebSocketDataTypeContractedList:
            [self contractDataList:data];
            break;
        case WebSocketDataTypeSingleContractId:
            [self contractDataList:data];
            break;
        default:
            break;
    }
}

//删除当前类型的数据
-(void)deleteCurrentData
{
    if (_sendDataTimer ) {
        [_sendDataTimer invalidate];
        _sendDataTimer = nil;
    }
    
    if (_dataArray) {
        [_dataArray removeAllObjects];
    }

}


//合约信息
-(void)contractDataList:(id)data
{
    [self parseDataList:data];
}

//通用的字典数据解析

- (void)parseDataList:(id)data{
    id list = [NDataUtil dictWithJson:data];
    if ([list isKindOfClass:[NSArray class]]) {
        self.dataArray = list;
    }else if ([list isKindOfClass:[NSDictionary class]]){
        if ([list allKeys].count == 0) return;
        [self.dataArray addObject:list];
    }
}


//MARK:--------------lazy

-(void)dealloc
{
    [self deleteCurrentData];
}


-(ThreadSafeArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[ThreadSafeArray alloc]init];
    }
    return _dataArray;
}
@end

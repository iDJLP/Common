//
//  DemoChartsModel.m
//  LiveTrade
//
//  Created by ngw15 on 2019/1/23.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "DemoChartsModel.h"
#import "DCService.h"
#import "NSDate+Additions.h"

@interface DemoChartsModel()


@property (nonatomic,strong) ThreadSafeArray *mlineList;
@property (nonatomic,strong) NSMutableDictionary *klineDic;
@property (nonatomic,strong) dispatch_semaphore_t lock;
@property (nonatomic,strong) NSURLSessionDataTask *kTask;
@property (nonatomic,strong) NSURLSessionDataTask *kAddTask;
@property (nonatomic,strong) NSURLSessionDataTask *kMoreTask;
@end

@implementation DemoChartsModel

- (instancetype)init{
    if(self=[super init]){
        
        _lock=dispatch_semaphore_create(1);
        _baseInfoData = [[CFDBaseInfoModel alloc] init];
        [self clearData];
    }
    return self;
}

//MARK: - Action

- (void)clearData{
    [self cancelTask];
    _mlineList = [[ThreadSafeArray alloc] init];
    _klineDic = [NSMutableDictionary dictionary];
}

- (void)cancelTask{
    [FOWebService cancelTask:_kTask];
    [FOWebService cancelTask:_kAddTask];
    [FOWebService cancelTask:_kMoreTask];
}

//MARK: - DataLoaded

- (void)klineMoreData:(NSString *)symbol chartsType:(EChartsType )chartsType lineType:(EChartsLineType)lineType success:(void(^)(NSInteger))success failure:(dispatch_block_t)failure{
    WEAK_SELF;
    if (chartsType == EChartsType_RT) {
//        _kTask = [DCService demoMLineData:contradId lineType:lineType success:^(id data) {
//            if (![NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
//                return ;
//            }
//            dispatch_async(dispatch_get_global_queue(0, 0), ^{
//                NSDictionary *dic = [NDataUtil dictWith:data[@"data"]];
//                [weakSelf.baseInfoData configNData:dic];
//                NSArray *list = [NDataUtil arrayWith:dic[@"lineData"]];
//                [weakSelf parseMLineData:list];
//                success();
//            });
//        } failure:^(NSError *error) {
//            failure();
//        }];
    }else{
        NSMutableArray *tempKData = [self getKLineData:chartsType];
        CFDKLineData *klineData = [NDataUtil dataWithArray:tempKData index:0];
        NSString *timestemp = klineData.timestemp;
        if (klineData==nil||timestemp.length<=0) {
            return;
        }
        [FOWebService cancelTask:_kMoreTask];
        _kMoreTask = [DCService demoKLineMoreData:symbol endtime:timestemp chartsType:[self returnType:chartsType] lineType:lineType success:^(id data) {
            if (![NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]||weakSelf==nil) {
                return ;
            }
            if (weakSelf.isDataAvailable(symbol,chartsType,lineType)==NO) {
                return;
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSDictionary *dic = [NDataUtil dictWith:data[@"data"]];
                NSArray *list = [NDataUtil arrayWith:dic[@"lineData"]];
                GCD_LOCK();
                NSInteger moreCount = [weakSelf parseMoreKlineData:list endTime:timestemp chartsType:chartsType];
                UN_GCD_LOCK();

                success(moreCount);
            });
            
        } failure:^(NSError *error) {
            if (error.code!=NSURLErrorCancelled) {
                failure();
            }
        }];
    }
}

- (void)addKlineData:(NSString *)symbol chartsType:(EChartsType )chartsType lineType:(EChartsLineType)lineType success:(dispatch_block_t) success failure:(dispatch_block_t)failure{
    WEAK_SELF;
    if (chartsType == EChartsType_RT) {
        _kAddTask = [DCService demoMLineData:symbol lineType:lineType success:^(id data) {
            if (![NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]||weakSelf==nil) {
                failure();
                return ;
            }
            if (weakSelf.isDataAvailable(symbol,chartsType,lineType)==NO) {
                failure();
                return;
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSDictionary *dic = [NDataUtil dictWith:data[@"data"]];
                [weakSelf.baseInfoData configNData:dic];
                NSArray *list = [NDataUtil arrayWith:dic[@"lineData"]];
                [weakSelf parseMLineData:list];
                success();
            });
        } failure:^(NSError *error) {
            failure();
        }];
    }else{
        _kAddTask = [DCService demoKLineAddData:symbol chartsType:[self returnType:chartsType] lineType:lineType success:^(id data) {
            if (![NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]||weakSelf==nil) {
                failure();
                return ;
            }
            if (weakSelf.isDataAvailable(symbol,chartsType,lineType)==NO) {
                failure();
                return;
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSDictionary *dic = [NDataUtil dictWith:data[@"data"]];
                NSArray *list = [NDataUtil arrayWith:dic[@"lineData"]];
                GCD_LOCK();
                [weakSelf parseAddKlineData:list chartsType:chartsType];
                UN_GCD_LOCK();
                success();
            });
            
        } failure:^(NSError *error) {
            failure();
        }];
    }
}

- (void)loadKlineData:(NSString *)symbol chartsType:(EChartsType )chartsType lineType:(EChartsLineType)lineType success:(dispatch_block_t) success failure:(dispatch_block_t)failure{
    WEAK_SELF;
    if (chartsType == EChartsType_RT) {
        _kTask = [DCService demoMLineData:symbol lineType:lineType success:^(id data) {
            if (![NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]||weakSelf==nil) {
                failure();
                return ;
            }
            if (weakSelf.isDataAvailable(symbol,chartsType,lineType)==NO) {
                failure();
                return;
            }
            NSDictionary *dic = [NDataUtil dictWith:data[@"data"]];
            [weakSelf.baseInfoData configNData:dic];
            NSArray *temList = [NDataUtil arrayWith:dic[@"lineData"]];
            [weakSelf parseMLineData:temList];
            success();
        } failure:^(NSError *error) {
            failure();
        }];
    }else{
        _kTask = [DCService demoKLineData:symbol chartsType:[self returnType:chartsType] lineType:lineType success:^(id data) {
            if (![NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]||weakSelf==nil) {
                return ;
            }
            
            if (weakSelf.isDataAvailable(symbol,chartsType,lineType)==NO) {
                return;
            }
            dispatch_async(dispatch_get_global_queue(0, 0), ^{
                NSDictionary *dic = [NDataUtil dictWith:data[@"data"]];
                NSArray *temList = [NDataUtil arrayWith:dic[@"lineData"]];
                GCD_LOCK();
                [weakSelf parseFirstKlineData:temList chartsType:chartsType];
                UN_GCD_LOCK();
                success();
            });

        } failure:^(NSError *error) {
            failure();
        }];
    }
}

- (void)parseFirstKlineData:(NSArray *)list chartsType:(EChartsType)chartsType{
    NSMutableArray *tempKData = [NSMutableArray array];
    CFDKLineData *lastData = nil;
    for (NSInteger i=0; i<list.count; i++) {
        NSDictionary *dataDic = [NDataUtil dictWithArray:list index:i];
        if (dataDic.count>=5) {
            CFDKLineData *kLineData = [[CFDKLineData alloc] init];
            kLineData.timestemp = [NDataUtil stringWith:dataDic[@"startTime"]];
            kLineData.iOpenp = [NDataUtil stringWith:dataDic[@"open"] valid:@"1"];
            kLineData.iHighp = [NDataUtil stringWith:dataDic[@"high"] valid:@"1"];
            kLineData.iLowp = [NDataUtil stringWith:dataDic[@"low"] valid:@"1"];
            kLineData.iPreclose = lastData? lastData.iNowv:kLineData.iOpenp;
            kLineData.iNowv = [NDataUtil stringWith:dataDic[@"close"] valid:@"1"];
            NSString *value = [NDataUtil stringWith:dataDic[@"val"]];
            NSString *vol = [NDataUtil stringWith:dataDic[@"vol"]];
            kLineData.volDic = @{@"value":value,@"vol":vol};
            kLineData.isHttpData = YES;
            [kLineData setITimeTextByChartsType:chartsType];
            [tempKData addObject:kLineData];
            lastData = kLineData;
        }
    }
    [DemoChartsModel calBOLLData:tempKData dotNum:_baseInfoData.dotNum];
    [self setKLineData:tempKData chartsType:chartsType];
}


- (void)parseAddKlineData:(NSArray *)list chartsType:(EChartsType)chartsType{
    NSMutableArray *tempKData = [self getKLineData:chartsType];
    if (tempKData.count<=0) {
        return;
    }
    NSInteger count = 1;
    if (chartsType == EChartsType_KL_1) {
        count = 1;
    }else if (chartsType == EChartsType_KL_3){
        count = 3;
    }else if (chartsType == EChartsType_KL_5){
        count = 5;
    }else if (chartsType == EChartsType_KL_15){
        count = 15;
    }else if (chartsType == EChartsType_KL_30){
        count = 30;
    }else if (chartsType == EChartsType_KL_60){
        count = 60;
    }else if (chartsType == EChartsType_KL_120){
        count = 120;
    }else if (chartsType == EChartsType_KL_240){
        count = 240;
    }else if (chartsType == EChartsType_KL_6H){
        count = 360;
    }else if (chartsType == EChartsType_KL_8H){
        count = 480;
    }else if (chartsType == EChartsType_KL){
        count = 24*60;
    }else if (chartsType == EChartsType_KL_WEEK){
        count = 7*24*60;
    }else if (chartsType == EChartsType_KL_MONTH){
        
    }
    long long times = 60*1000*count;
    __block BOOL isStop = NO;
    for (NSInteger i =list.count-1; i>=0; i--) {
        NSDictionary *dataDic = [NDataUtil dictWithArray:list index:i];
        NSString *timestemp = [NDataUtil stringWith:dataDic[@"startTime"]];
        NSMutableArray *tem = [NSMutableArray array];
        [tempKData enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(CFDKLineData *data, NSUInteger idx, BOOL * _Nonnull stop) {
            CFDKLineData *lastData = [NDataUtil dataWithArray:tempKData index:idx-1];
            if (timestemp.longLongValue/times>data.timestemp.longLongValue/times) {
                CFDKLineData *kLineData = [[CFDKLineData alloc] init];
                kLineData.timestemp = [NDataUtil stringWith:dataDic[@"startTime"]];
                kLineData.iOpenp = [NDataUtil stringWith:dataDic[@"open"] valid:@"1"];
                kLineData.iHighp = [NDataUtil stringWith:dataDic[@"high"] valid:@"1"];
                kLineData.iLowp = [NDataUtil stringWith:dataDic[@"low"] valid:@"1"];
                kLineData.iPreclose = lastData? lastData.iNowv:kLineData.iOpenp;
                kLineData.iNowv = [NDataUtil stringWith:dataDic[@"close"] valid:@"1"];
                NSString *value = [NDataUtil stringWith:dataDic[@"val"]];
                NSString *vol = [NDataUtil stringWith:dataDic[@"vol"]];
                kLineData.volDic = @{@"value":value,@"vol":vol};
                kLineData.isHttpData = YES;
                
                [kLineData setITimeTextByChartsType:chartsType timestemp:timestemp.longLongValue-(timestemp.longLongValue%times)];
                
                NSDictionary *dic = @{@"index":@(idx+1),@"data":kLineData};
                [tem addObject:dic];
                *stop=YES;
            }else if (data.timestemp.longLongValue/times==timestemp.longLongValue/times){
                if (data.isHttpData) {
                    isStop = YES;
                    *stop=YES;
                }else{
                    data.timestemp = [NDataUtil stringWith:dataDic[@"startTime"]];
                    data.iOpenp = [NDataUtil stringWith:dataDic[@"open"] valid:@"1"];
                    data.iHighp = [NDataUtil stringWith:dataDic[@"high"] valid:@"1"];
                    data.iLowp = [NDataUtil stringWith:dataDic[@"low"] valid:@"1"];
                    data.iPreclose = lastData? lastData.iNowv:data.iOpenp;
                    data.iNowv = [NDataUtil stringWith:dataDic[@"close"] valid:@"1"];
                    NSString *value = [NDataUtil stringWith:dataDic[@"val"]];
                    NSString *vol = [NDataUtil stringWith:dataDic[@"vol"]];
                    data.volDic = @{@"value":value,@"vol":vol};
                    data.isHttpData = YES;
                    [data setITimeTextByChartsType:chartsType timestemp:timestemp.longLongValue-(timestemp.longLongValue%times)];
                    *stop=YES;
                }
            }else{
                
            }
        }];
        for (NSDictionary *dic in tem) {
            NSUInteger index = [NDataUtil integerWith:dic[@"index"]];
            id lineData = dic[@"data"];
            if (index<=tempKData.count) {
                [tempKData insertObject:lineData atIndex:index];
            }
        }
        if (isStop) {
            break;
        }
    }
    [DemoChartsModel calBOLLData:tempKData dotNum:_baseInfoData.dotNum];
    [self setKLineData:tempKData chartsType:chartsType];
}

- (NSInteger )parseMoreKlineData:(NSArray *)list endTime:(NSString *)timestemp chartsType:(EChartsType)chartsType{
    NSMutableArray *tempKData = [self getKLineData:chartsType];
    CFDKLineData *firstKLine = [NDataUtil dataWithArray:tempKData index:0];
    if (tempKData.count<=0||firstKLine==nil||timestemp.length<=0||![firstKLine.timestemp isEqualToString:timestemp]) {
        return 0;
    }
    NSMutableArray *moreList = [NSMutableArray array];
    CFDKLineData *lastData = nil;
    for (NSInteger i=0; i<list.count; i++) {
        NSDictionary *dataDic = [NDataUtil dictWithArray:list index:i];
        CFDKLineData *kLineData = [[CFDKLineData alloc] init];
        kLineData.timestemp = [NDataUtil stringWith:dataDic[@"startTime"]];
        kLineData.iOpenp = [NDataUtil stringWith:dataDic[@"open"] valid:@"1"];
        kLineData.iHighp = [NDataUtil stringWith:dataDic[@"high"] valid:@"1"];
        kLineData.iLowp = [NDataUtil stringWith:dataDic[@"low"] valid:@"1"];
        kLineData.iPreclose = lastData? lastData.iNowv:kLineData.iOpenp;
        kLineData.iNowv = [NDataUtil stringWith:dataDic[@"close"] valid:@"1"];
        NSString *value = [NDataUtil stringWith:dataDic[@"val"]];
        NSString *vol = [NDataUtil stringWith:dataDic[@"vol"]];
        kLineData.volDic = @{@"value":value,@"vol":vol};
        kLineData.isHttpData = YES;
        [kLineData setITimeTextByChartsType:chartsType];
        [moreList addObject:kLineData];
        lastData = kLineData;
    }
    firstKLine.iPreclose = lastData.iNowv;
    [tempKData insertObjects:moreList atIndex:0];
    [DemoChartsModel calBOLLData:tempKData dotNum:_baseInfoData.dotNum];
    [self setKLineData:tempKData chartsType:chartsType];
    return moreList.count;
}

- (BOOL )updateKlineDataWithSocketDic:(NSDictionary *)dic chartsType:(EChartsType)chartsType lineType:(EChartsLineType)lineType{
    NSString *timestemp = [NDataUtil stringWith:dic[@"T"]];
    NSMutableArray *klineList = [self getKLineData:chartsType];
    CFDKLineData *lastData = [NDataUtil dataWithArray:klineList index:klineList.count-1];
    if (lastData) {
        NSInteger count = 1;
        if (chartsType == EChartsType_KL_1) {
            count = 1;
        }else if (chartsType == EChartsType_KL_3){
            count = 3;
        }else if (chartsType == EChartsType_KL_5){
            count = 5;
        }else if (chartsType == EChartsType_KL_15){
            count = 15;
        }else if (chartsType == EChartsType_KL_30){
            count = 30;
        }else if (chartsType == EChartsType_KL_60){
            count = 60;
        }else if (chartsType == EChartsType_KL_120){
            count = 120;
        }else if (chartsType == EChartsType_KL_240){
            count = 240;
        }else if (chartsType == EChartsType_KL_6H){
            count = 360;
        }else if (chartsType == EChartsType_KL_8H){
            count = 480;
        }else if (chartsType == EChartsType_KL){
            count = 24*60;
        }else if (chartsType == EChartsType_KL_WEEK){
            count = 7*24*60;
        }else if (chartsType == EChartsType_KL_MONTH){
            
        }
        long long times = 60*1000*count;
        if (timestemp.longLongValue/times==lastData.timestemp.longLongValue/times) {
            lastData.timestemp = timestemp;
            if (lineType==EChartsLineTypeTradePrice) {
                lastData.iNowv = [NDataUtil stringWith:dic[@"t"]];
            }else if (lineType==EChartsLineTypeBidPrice){
                lastData.iNowv = [NDataUtil stringWith:dic[@"b"]];
            }else if (lineType==EChartsLineTypeOfferPrice){
                lastData.iNowv = [NDataUtil stringWith:dic[@"a"]];
            }else if (lineType==EChartsLineTypeMiddlePrice){
                NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithString:[NDataUtil stringWith:dic[@"b"]]];
                NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:[NDataUtil stringWith:dic[@"a"]]];
                NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:@"2"];
                lastData.iNowv = [[b decimalNumberByAdding:a] decimalNumberByDividingBy:num].stringValue;
            }
            lastData.isHttpData = NO;
            [lastData setITimeTextByChartsType:chartsType timestemp:timestemp.longLongValue-(timestemp.longLongValue%times)];
            return NO;
        }else if (timestemp.longLongValue/times>lastData.timestemp.longLongValue/times){
            CFDKLineData *kLineData = [[CFDKLineData alloc] init];
            kLineData.timestemp = [NDataUtil stringWith:dic[@"T"]];
            kLineData.iOpenp =
            kLineData.iPreclose = lastData.iNowv;
            if (lineType==EChartsLineTypeTradePrice) {
                kLineData.iNowv = [NDataUtil stringWith:dic[@"t"]];
            }else if (lineType==EChartsLineTypeBidPrice){
                kLineData.iNowv = [NDataUtil stringWith:dic[@"b"]];
            }else if (lineType==EChartsLineTypeOfferPrice){
                kLineData.iNowv = [NDataUtil stringWith:dic[@"a"]];
            }else if (lineType==EChartsLineTypeMiddlePrice){
                NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithString:[NDataUtil stringWith:dic[@"b"]]];
                NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:[NDataUtil stringWith:dic[@"a"]]];
                NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:@"2"];
                kLineData.iNowv = [[b decimalNumberByAdding:a] decimalNumberByDividingBy:num].stringValue;
            }
            NSString *vol = [NDataUtil stringWith:dic[@"v"]];
            NSString *value = [GUIUtil decimalMultiply:vol num:[NDataUtil stringWith:dic[@"t"]]];
            kLineData.volDic = @{@"value":value,@"vol":vol};
            kLineData.isHttpData = NO;
            [kLineData setITimeTextByChartsType:chartsType timestemp:timestemp.longLongValue-(timestemp.longLongValue%times)];
            [klineList addObject:kLineData];
            return YES;
        }
    }
    return NO;
}

- (void)parseMLineData:(NSArray *)list
{
    NSLog(@"nice:enter");
    NSMutableArray *tempKData = [self mlineList];
    if (tempKData.count<=0) {
        [self parseFirstMlineData:list];
    }else{
        
        [self parseAddMlineData:list];
    }
    NSLog(@"nice:out");
}


- (void)parseFirstMlineData:(NSArray *)list{
    CFDMLineData *lastLineData = nil;
    NSMutableArray *tempKData = [self mlineList];
    for (NSInteger i=0; i<list.count; i++) {
        NSDictionary *dataDic = [NDataUtil dictWithArray:list index:i];
        if (dataDic.count>=5) {
            CFDMLineData *lineData = [[CFDMLineData alloc] init];
            lineData.timestemp = [NDataUtil stringWith:dataDic[@"startTime"]];
            lineData.iOpenp = [NDataUtil stringWith:dataDic[@"open"] valid:@"1"];
            lineData.iHighp = [NDataUtil stringWith:dataDic[@"high"] valid:@"1"];
            lineData.iLowp = [NDataUtil stringWith:dataDic[@"low"] valid:@"1"];
            lineData.iPreclose = lastLineData?lastLineData.iNowv:lineData.iOpenp;
            lineData.iNowv = [NDataUtil stringWith:dataDic[@"close"] valid:@"1"];
            NSString *value = [NDataUtil stringWith:dataDic[@"val"]];
            NSString *vol = [NDataUtil stringWith:dataDic[@"vol"]];
            lineData.volDic = @{@"value":value,@"vol":vol};
            
            NSString *raise = [[NSDecimalNumber decimalNumberWithString:lineData.iNowv] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:lineData.iPreclose]].stringValue;
            NSString *raiseRate = [[NSDecimalNumber decimalNumberWithString:raise] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:lineData.iPreclose]].stringValue;
            NSInteger rate = [raiseRate floatValue]*10000;
            lineData.iUpdown =  raise;
            lineData.iUpdownRate =  [NSString stringWithFormat:@"%.2f%%",(float)(rate/100.0)];
            lineData.isHttpData = YES;
            [tempKData addObject:lineData];
            lastLineData = lineData;
        }
    }
}


- (void)parseAddMlineData:(NSArray *)list{
    ThreadSafeArray *tempKData = self.mlineList;
    
    __block BOOL isStop = NO;
    for (NSInteger i =list.count-1; i>=0; i--) {
        NSDictionary *dataDic = [NDataUtil dictWithArray:list index:i];
        NSString *timestemp = [NDataUtil stringWith:dataDic[@"startTime"]];
        NSMutableArray *tem = [NSMutableArray array];
        NSInteger count = tempKData.count;
        [tempKData enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(CFDKLineData *data, NSUInteger idx, BOOL * _Nonnull stop) {
            CFDKLineData *lastData = nil;
            if (idx-1>=0&&count>idx-1) {
                lastData = [tempKData objectAtIndex_unLock:idx-1];
            }
            if (timestemp.longLongValue/60000>data.timestemp.longLongValue/60000) {
                CFDMLineData *lineData = [[CFDMLineData alloc] init];
                lineData.timestemp = [NDataUtil stringWith:dataDic[@"startTime"]];
                lineData.iHighp = [NDataUtil stringWith:dataDic[@"high"] valid:@"1"];
                lineData.iLowp = [NDataUtil stringWith:dataDic[@"low"] valid:@"1"];
                lineData.iOpenp = [NDataUtil stringWith:dataDic[@"open"]];
                
                lineData.iPreclose =lastData? lastData.iNowv:lineData.iOpenp;
                lineData.iNowv = [NDataUtil stringWith:dataDic[@"close"] valid:@"1"];
                NSString *value = [NDataUtil stringWith:dataDic[@"val"]];
                NSString *vol = [NDataUtil stringWith:dataDic[@"vol"]];
                lineData.volDic = @{@"value":value,@"vol":vol};
                NSString *raise = [[NSDecimalNumber decimalNumberWithString:lineData.iNowv] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:lineData.iPreclose]].stringValue;
                NSString *raiseRate = [[NSDecimalNumber decimalNumberWithString:raise] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:lineData.iPreclose]].stringValue;
                NSInteger rate = [raiseRate floatValue]*10000;
                lineData.iUpdown =  raise;
                lineData.iUpdownRate =  [NSString stringWithFormat:@"%.2f%%",(float)(rate/100.0)];
                lineData.isHttpData = YES;
                NSDictionary *dic = @{@"index":@(idx+1),@"data":lineData};
                [tem addObject:dic];
                *stop=YES;
            }else if (data.timestemp.longLongValue/60000==timestemp.longLongValue/60000){
                if (data.isHttpData&&idx!=count-1) {
                    isStop = YES;
                    *stop=YES;
                }else{
                    data.timestemp = [NDataUtil stringWith:dataDic[@"startTime"]];
                    data.iHighp = [NDataUtil stringWith:dataDic[@"high"] valid:@"1"];
                    data.iLowp = [NDataUtil stringWith:dataDic[@"low"] valid:@"1"];
                    data.iOpenp = [NDataUtil stringWith:dataDic[@"open"] valid:@"1"];
                    data.iNowv = [NDataUtil stringWith:dataDic[@"close"] valid:@"1"];
                    NSString *raise = [[NSDecimalNumber decimalNumberWithString:data.iNowv] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:data.iPreclose]].stringValue;
                    NSString *raiseRate = [[NSDecimalNumber decimalNumberWithString:raise] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:data.iPreclose]].stringValue;
                    NSInteger rate = [raiseRate floatValue]*10000;
                    data.iUpdown =  raise;
                    data.iUpdownRate =  [NSString stringWithFormat:@"%.2f%%",(float)(rate/100.0)];
                    NSString *value = [NDataUtil stringWith:dataDic[@"val"]];
                    NSString *vol = [NDataUtil stringWith:dataDic[@"vol"]];
                    data.volDic = @{@"value":value,@"vol":vol};
                    data.isHttpData = YES;
                    *stop=YES;
                }
            }else{
                
            }
        }];
        for (NSDictionary *dic in tem) {
            NSUInteger index = [NDataUtil integerWith:dic[@"index"]];
            id lineData = dic[@"data"];
            if (index<=tempKData.count) {
                [tempKData insertObject:lineData atIndex:index];
            }
        }
        if (isStop) {
            break;
        }
    }
}

- (BOOL)updateMlineDataWithSocketDic:(NSDictionary *)dic lineType:(EChartsLineType)lineType{
    NSString *timestemp = [NDataUtil stringWith:dic[@"T"]];
    NSMutableArray *mlineList = [self mlineList];
    CFDKLineData *lastData = [NDataUtil dataWithArray:mlineList index:mlineList.count-1];
    if (lastData) {
        if (timestemp.longLongValue/60000==lastData.timestemp.longLongValue/60000) {
            lastData.timestemp = timestemp;
            if (lineType==EChartsLineTypeTradePrice) {
                lastData.iNowv = [NDataUtil stringWith:dic[@"t"]];
            }else if (lineType==EChartsLineTypeBidPrice){
                lastData.iNowv = [NDataUtil stringWith:dic[@"b"]];
            }else if (lineType==EChartsLineTypeOfferPrice){
                lastData.iNowv = [NDataUtil stringWith:dic[@"a"]];
            }else if (lineType==EChartsLineTypeMiddlePrice){
                NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithString:[NDataUtil stringWith:dic[@"b"]]];
                NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:[NDataUtil stringWith:dic[@"a"]]];
                NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:@"2"];
                lastData.iNowv = [[b decimalNumberByAdding:a] decimalNumberByDividingBy:num].stringValue;
            }
            NSString *raise = [[NSDecimalNumber decimalNumberWithString:lastData.iNowv] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:lastData.iPreclose]].stringValue;
            NSString *raiseRate = [[NSDecimalNumber decimalNumberWithString:raise] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:lastData.iPreclose]].stringValue;
            NSInteger rate = [raiseRate floatValue]*10000;
            lastData.iUpdown =  raise;
            lastData.iUpdownRate =  [NSString stringWithFormat:@"%.2f%%",(float)(rate/100.0)];
            lastData.isHttpData = NO;
            return NO;
        }else if (timestemp.longLongValue/60000>lastData.timestemp.longLongValue/60000){
            
            CFDMLineData *lineData = [[CFDMLineData alloc] init];
            lineData.timestemp = [NDataUtil stringWith:dic[@"T"]];
            lineData.iOpenp = lastData.iNowv;
            lineData.iPreclose = lastData? lastData.iNowv:lineData.iOpenp;
            if (lineType==EChartsLineTypeTradePrice) {
                lineData.iNowv = [NDataUtil stringWith:dic[@"t"]];
            }else if (lineType==EChartsLineTypeBidPrice){
                lineData.iNowv = [NDataUtil stringWith:dic[@"b"]];
            }else if (lineType==EChartsLineTypeOfferPrice){
                lineData.iNowv = [NDataUtil stringWith:dic[@"a"]];
            }else if (lineType==EChartsLineTypeMiddlePrice){
                NSDecimalNumber *b = [NSDecimalNumber decimalNumberWithString:[NDataUtil stringWith:dic[@"b"]]];
                NSDecimalNumber *a = [NSDecimalNumber decimalNumberWithString:[NDataUtil stringWith:dic[@"a"]]];
                NSDecimalNumber *num = [NSDecimalNumber decimalNumberWithString:@"2"];
                lineData.iNowv = [[b decimalNumberByAdding:a] decimalNumberByDividingBy:num].stringValue;
            }
            NSString *raise = [[NSDecimalNumber decimalNumberWithString:lineData.iNowv] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:lineData.iPreclose]].stringValue;
            NSString *raiseRate = [[NSDecimalNumber decimalNumberWithString:raise] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:lineData.iPreclose]].stringValue;
            NSInteger rate = [raiseRate floatValue]*10000;
            lineData.iUpdown =  raise;
            lineData.iUpdownRate =  [NSString stringWithFormat:@"%.2f%%",(float)(rate/100.0)];
            NSString *vol = [NDataUtil stringWith:dic[@"v"]];
            NSString *value = [GUIUtil decimalMultiply:vol num:[NDataUtil stringWith:dic[@"t"]]];
            lineData.volDic = @{@"value":value,@"vol":vol};
            lineData.isHttpData = NO;
            
            [mlineList addObject:lineData];
            return YES;
        }
    }
    return NO;
}



//MARK: - Getter Setter
- (void)setKLineData:(NSMutableArray *)data chartsType:(EChartsType)chartsType{
    NSString *key = @"";
    switch (chartsType) {
        case EChartsType_KL:{
            key = KLineData_Day;
        }
            break;
        case EChartsType_KL_1:{
            key = KLineData_1;
        }
            break;
        case EChartsType_KL_3:{
            key = KLineData_3;
        }
            break;
        case EChartsType_KL_5:{
            key = KLineData_5;
        }
            break;
        case EChartsType_KL_15:{
            key = KLineData_15;
        }
            break;
        case EChartsType_KL_30:{
            key = KLineData_30;
        }
            break;
        case EChartsType_KL_60:{
            key = KLineData_60;
        }
            break;
        case EChartsType_KL_240:{
            key = KLineData_240;
        }
            break;
        case EChartsType_KL_WEEK:{
            key = KLineData_Week;
        }
            break;
        case EChartsType_KL_MONTH:{
            key = KLineData_Month;
        }
            break;
        default:
            break;
    }
    [_klineDic setObject:data forKey:key];
}

- (NSMutableArray *)getKLineData:(EChartsType)chartsType{
    
    NSMutableArray *kLineList = nil;
    NSDictionary *dict = _klineDic;
    switch (chartsType) {
        case EChartsType_KL:{
            kLineList = dict[KLineData_Day];
        }
            break;
        case EChartsType_KL_1:{
            kLineList = dict[KLineData_1];
        }
            break;
        case EChartsType_KL_3:{
            kLineList = dict[KLineData_3];
        }
            break;
        case EChartsType_KL_5:{
            kLineList = dict[KLineData_5];
        }
            break;
        case EChartsType_KL_15:{
            kLineList = dict[KLineData_15];
        }
            break;
        case EChartsType_KL_30:{
            kLineList = dict[KLineData_30];
        }
            break;
        case EChartsType_KL_60:{
            kLineList = dict[KLineData_60];
        }
            break;
        case EChartsType_KL_240:{
            kLineList = dict[KLineData_240];
        }
            break;
        case EChartsType_KL_WEEK:{
            kLineList = dict[KLineData_Week];
        }
            break;
        case EChartsType_KL_MONTH:{
            kLineList = dict[KLineData_Month];
        }
            break;
        default:
            break;
    }
    return kLineList;
}

- (NSMutableArray *)getKLineDataCopy:(EChartsType)chartsType{
     return [self getKLineData:chartsType];
}

- (NSMutableArray *)getMLineDataCopy{
    return self.mlineList;
}

///计算移动平均值，period：天数 5，10，30
+ (void)calMA:(NSArray <CFDKLineData *>*)list dotNum:(NSInteger)dotNum{

    NSInteger period_5 = 5;
    NSInteger period_10 = 10;
    NSInteger period_30 = 30;
    NSMutableArray *tem_5 = [NSMutableArray array];
    NSMutableArray *tem_10 = [NSMutableArray array];
    NSMutableArray *tem_30 = [NSMutableArray array];
    NSString *format = [self stringFormatByDotNum:dotNum];
    [list enumerateObjectsUsingBlock:^(CFDKLineData * _Nonnull lineData, NSUInteger i, BOOL * _Nonnull stop) {
        [tem_5 addObject:lineData.iNowv];
        if (tem_5.count>period_5) {
            [tem_5 removeObjectAtIndex:0];
        }
        CGFloat ma_5 = [self getAverFromList:tem_5];
        NSString *MA5 = [NSString stringWithFormat:format,ma_5];
        
        [tem_10 addObject:lineData.iNowv];
        if (tem_10.count>period_10) {
            [tem_10 removeObjectAtIndex:0];
        }
        CGFloat ma_10 = [self getAverFromList:tem_10];
        NSString *MA10 = [NSString stringWithFormat:format,ma_10];
        
        [tem_30 addObject:lineData.iNowv];
        if (tem_30.count>period_30) {
            [tem_30 removeObjectAtIndex:0];
        }
        CGFloat ma_30 = [self getAverFromList:tem_30];
        NSString *MA30 = [NSString stringWithFormat:format,ma_30];
        
        NSString *MA5Str = i<5?@"-1":MA5;
        NSString *MA10Str = i<10?@"-1":MA10;
        NSString *MA30Str = i<30?@"-1":MA30;
        lineData.MADic = @{@"MA5":MA5Str,@"MA10":MA10Str,@"MA30":MA30Str};
    }];
}

+ (void)calBOLLData:(NSArray <CFDKLineData *>*)list dotNum:(NSInteger)dotNum{
    
    NSMutableArray *tem_20 = [NSMutableArray array];
    NSMutableArray *sum_20 = [NSMutableArray array];
    NSInteger period = 20;
    NSString *format = [self stringFormatByDotNum:dotNum];
    [list enumerateObjectsUsingBlock:^(CFDKLineData * _Nonnull lineData, NSUInteger idx, BOOL * _Nonnull stop) {
        [tem_20 addObject:lineData.iNowv];
        if (tem_20.count>period) {
            [tem_20 removeObjectAtIndex:0];
        }
        CGFloat ma = [self getAverFromList:tem_20];
        CGFloat sum = (lineData.iNowv.floatValue-ma)*(lineData.iNowv.floatValue-ma);
        [sum_20 addObject:@(sum)];
        if (sum_20.count>period) {
            [sum_20 removeObjectAtIndex:0];
            CGFloat md = sqrt([self getAverFromList:sum_20]);
            CGFloat mb = ma;
            CGFloat up = mb+2*md;
            CGFloat dn = mb-2*md;
            lineData.BOLLDic = @{@"mb":[NSString stringWithFormat:format,mb],@"up":[NSString stringWithFormat:format,up],@"dn":[NSString stringWithFormat:format,dn]};
        }
    }];
    
}
+ (void)calMACDData:(NSArray <CFDKLineData *>*)list dotNum:(NSInteger)dotNum{
    __block CGFloat ema_12 = [list firstObject].iNowv.floatValue;
    __block CGFloat ema_26 = [list firstObject].iNowv.floatValue;
    NSInteger period_12 = 12;
    NSInteger period_26 = 26;
    NSInteger period_9 = 9;
    __block CGFloat dea_9 = 0;
    NSString *format = [self stringFormatByDotNum:dotNum];
    [list enumerateObjectsUsingBlock:^(CFDKLineData * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger num_short = idx>=period_12?period_12:idx+1;
        NSInteger num_long = idx>=period_26?period_26:idx+1;
        ema_12 = 2.0/(num_short+1)*obj.iNowv.floatValue+(num_short-2.0)/(num_short+1)*ema_12;
        ema_26 = 2.0/(num_long+1)*obj.iNowv.floatValue+(num_long-2.0)/(num_long+1)*ema_26;
        CGFloat dif = ema_12-ema_26;
        dea_9 = 2.0/(period_9+1)*dif+8.0/(period_9+1)*dea_9;
        CGFloat bar =  2*(dif-dea_9);
        NSString *dif_str = [NSString stringWithFormat:format,dif];
        NSString *dea_9_str = [NSString stringWithFormat:format,dea_9];
        NSString *bar_str = [NSString stringWithFormat:format,bar];
        NSString *ema_12_str = [NSString stringWithFormat:format,ema_12];
        NSString *ema_26_str = [NSString stringWithFormat:format,ema_26];
//        if (idx>=50) {
            obj.MACDDic = @{@"dif":dif_str,@"dea":dea_9_str,@"bar":bar_str,@"ema_12":ema_12_str,@"ema_26":ema_26_str};
//        }
    }];
}

+ (void)calKDJData:(NSArray <CFDKLineData *>*)list dotNum:(NSInteger)dotNum{
    __block CGFloat rsa = 0;
    __block CGFloat k = 50;
    __block CGFloat d = 50;
    __block CGFloat j = 50;
    NSMutableArray *tem = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(CFDKLineData * _Nonnull lineData, NSUInteger i, BOOL * _Nonnull stop) {
        if (tem.count<9) {
            [tem addObject:lineData.iNowv];
        }else{
            [tem removeObjectAtIndex:0];
            [tem addObject:lineData.iNowv];
            NSDictionary *dic = [self getMaxMinFromList:tem];
            CGFloat max = [dic[@"max"] floatValue];
            CGFloat min = [dic[@"min"] floatValue];
            if (i!=0) {
                rsa = (lineData.iNowv.floatValue-min)/(max-min)*100;
                k = 2/3.0*k+1/3.0*rsa;
                d = 2/3.0*d+1/3.0*k;
                j = 3*k-2*d;
            }
            lineData.KDJDic = @{@"rsa":@(rsa),@"k":[NSString stringWithFormat:@"%.3f",k],@"d":[NSString stringWithFormat:@"%.3f",d],@"j":[NSString stringWithFormat:@"%.3f",j]};
        }
    }];
}

+ (void)calRSIData:(NSArray <CFDKLineData *>*)list dotNum:(NSInteger)dotNum{
    NSMutableArray *tem_6 = [NSMutableArray array];
    NSMutableArray *tem_12 = [NSMutableArray array];
    NSMutableArray *tem_24 = [NSMutableArray array];
    __block CGFloat preClose = [list firstObject].iNowv.floatValue;
    NSString *format = [self stringFormatByDotNum:dotNum];
    [list enumerateObjectsUsingBlock:^(CFDKLineData * _Nonnull lineData, NSUInteger i, BOOL * _Nonnull stop) {
        NSString *dif= [NSString stringWithFormat:format,lineData.iNowv.floatValue-preClose];
        preClose = lineData.iNowv.floatValue;
        NSString *rsi_6 = @"0";
        NSString *rsi_12= @"0";
        NSString *rsi_24= @"0";
        if (tem_6.count<6+1) {
            [tem_6 addObject:dif];
        }else{
            [tem_6 removeObjectAtIndex:0];
            [tem_6 addObject:dif];
            rsi_6 = [self RSIFromList:tem_6];
        }
        if (tem_12.count<12+1) {
            [tem_12 addObject:dif];
        }else{
            [tem_12 removeObjectAtIndex:0];
            [tem_12 addObject:dif];
            rsi_12 =[self RSIFromList:tem_12];
        }
        if (tem_24.count<24+1) {
            [tem_24 addObject:dif];
        }else{
            [tem_24 removeObjectAtIndex:0];
            [tem_24 addObject:dif];
            rsi_24 =[self RSIFromList:tem_24];
        }
        lineData.RSIDic = @{@"rsi1":rsi_6,@"rsi2":rsi_12,@"rsi3":rsi_24};
    }];
}

+ (NSString *)RSIFromList:(NSArray *)list{
    __block CGFloat a = 0;
    __block CGFloat b = 0;
    [list enumerateObjectsUsingBlock:^(NSString *dif, NSUInteger i, BOOL * _Nonnull stop) {
        CGFloat d = dif.floatValue;
        if (d>0) {
            a += d;
        }else{
            b += d;
        }
    }];
    b = b*-1;
    CGFloat rsi = a/(a+b)*100;
    return [NSString stringWithFormat:@"%.3f",rsi];
}

+ (void)calWRData:(NSArray <CFDKLineData *>*)list dotNum:(NSInteger)dotNum{
    
    NSMutableArray *tem_10 = [NSMutableArray array];
    NSMutableArray *tem_6 = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(CFDKLineData * _Nonnull lineData, NSUInteger i, BOOL * _Nonnull stop) {
        CGFloat wr_10 = 0;
        CGFloat wr_6 = 0;
        if (tem_10.count<10) {
            [tem_10 addObject:lineData.iNowv];
        }else{
            [tem_10 removeObjectAtIndex:0];
            [tem_10 addObject:lineData.iNowv];
            NSDictionary *dic = [self getMaxMinFromList:tem_10];
            CGFloat max_10 = [dic[@"max"] floatValue];
            CGFloat min_10 = [dic[@"min"] floatValue];
            wr_10 = (max_10-lineData.iNowv.floatValue)/(max_10-min_10)*100;
            
        }
        if (tem_6.count<6) {
            [tem_6 addObject:lineData.iNowv];
        }else{
            [tem_6 removeObjectAtIndex:0];
            [tem_6 addObject:lineData.iNowv];
            NSDictionary *dic = [self getMaxMinFromList:tem_6];
            CGFloat max_6 = [dic[@"max"] floatValue];
            CGFloat min_6 = [dic[@"min"] floatValue];
            wr_6 = (max_6-lineData.iNowv.floatValue)/(max_6-min_6)*100;
            
        }
        lineData.WRDic = @{@"wr1":[NSString stringWithFormat:@"%.3f",wr_10],@"wr2":[NSString stringWithFormat:@"%.3f",wr_6]};
    }];
}

+ (void)calBIASData:(NSArray <CFDKLineData *>*)list dotNum:(NSInteger)dotNum{
    NSMutableArray *tem_24 = [NSMutableArray array];
    NSMutableArray *tem_12 = [NSMutableArray array];
    NSMutableArray *tem_6 = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(CFDKLineData * _Nonnull lineData, NSUInteger i, BOOL * _Nonnull stop) {
        CGFloat bias_24 = 0;
        CGFloat bias_12 = 0;
        CGFloat bias_6 = 0;
        if (tem_24.count<24) {
            [tem_24 addObject:lineData.iNowv];
        }else{
            CGFloat aver = [self getAverFromList:tem_24];
            bias_24 = (lineData.iNowv.floatValue- aver)/aver*100;
            [tem_24 removeObjectAtIndex:0];
            [tem_24 addObject:lineData.iNowv];
        }
        if (tem_12.count<12) {
            [tem_12 addObject:lineData.iNowv];
        }else{
            CGFloat aver = [self getAverFromList:tem_12];
            bias_12 = (lineData.iNowv.floatValue- aver)/aver*100;
            [tem_12 removeObjectAtIndex:0];
            [tem_12 addObject:lineData.iNowv];
            
        }
        if (tem_6.count<6) {
            [tem_6 addObject:lineData.iNowv];
        }else{
            CGFloat aver = [self getAverFromList:tem_6];
            bias_6 = (lineData.iNowv.floatValue- aver)/aver*100;
            [tem_6 removeObjectAtIndex:0];
            [tem_6 addObject:lineData.iNowv];
            
        }
        lineData.BIASDic = @{@"bias1":[NSString stringWithFormat:@"%.3f",bias_6],@"bias2":[NSString stringWithFormat:@"%.3f",bias_12],@"bias3":[NSString stringWithFormat:@"%.3f",bias_24]};
    }];
}

+ (void)calCCIData:(NSArray <CFDKLineData *>*)list dotNum:(NSInteger)dotNum{
    NSMutableArray *tem_14 = [NSMutableArray array];
    
    __block CGFloat avedev = list[0].iNowv.floatValue;
    [list enumerateObjectsUsingBlock:^(CFDKLineData * _Nonnull lineData, NSUInteger i, BOOL * _Nonnull stop) {
        [tem_14 addObject:lineData.iNowv];
        if (tem_14.count>14) {   
            [tem_14 removeObjectAtIndex:0];
            CGFloat typ = (lineData.iNowv.floatValue+lineData.iHighp.floatValue+lineData.iLowp.floatValue)/3.0;
            CGFloat ma = [self getAverFromList:tem_14];
            avedev = avedev*13/14.0+(ABS(lineData.iNowv.floatValue-ma))/14.0;
            CGFloat cci_14 = (typ-ma)/(avedev*0.015);
            lineData.CCiDic = @{@"cci":[NSString stringWithFormat:@"%.3f",cci_14]};
        }
    }];
}

+ (NSDictionary *)getMaxMinFromList:(NSArray *)tem{
    NSString *max = [NSString stringWithFormat:@"%lf",CGFLOAT_MIN];
    NSString *min = [NSString stringWithFormat:@"%lf",CGFLOAT_MAX];
    for (NSString *close in tem) {
        if (max.floatValue<close.floatValue) {
            max = close;
        }
        if(min.floatValue>close.floatValue){
            min= close;
        }
    }
    return @{@"max":max,@"min":min};
}

+ (CGFloat)getAverFromList:(NSArray *)tem{
    if (tem.count==0) {
        return 1;
    }
    CGFloat sum =0;
    for (NSString *close in tem) {
        sum += close.floatValue;
    }
    return sum/tem.count;
}

- (NSString *)returnType:(EChartsType)chartsType
{
    NSString  *type = @"";
    switch (chartsType) {
        case EChartsType_RT:
        case EChartsType_KL_1:
        {
            type = @"1m";
            break;
        }
        case EChartsType_KL_3:
        {
            type = @"3m";
            break;
        }
        case EChartsType_KL_5:
        {
            type = @"5m";
            break;
        }
        case EChartsType_KL_15:
        {
            type = @"15m";
            break;
        }
        case EChartsType_KL_30:
        {
            type = @"30m";
            break;
        }
        case EChartsType_KL_60:
        {
            type = @"1h";
            break;
        }
        case EChartsType_KL_240:
        {
            type = @"4h";
            break;
        }
        case EChartsType_KL:{
            type=@"1d";
            break;
        }
        default:{
            type=@"";
        }
    }
    return type;
}

+ (NSString *)stringFormatByDotNum:(NSInteger)dotNum{
    switch (dotNum) {
        case 0:
            return @"%.0f";
            break;
        case 1:
            return @"%.1f";
            break;
        case 2:
            return @"%.2f";
            break;
        case 3:
            return @"%.3f";
            break;
        case 4:
            return @"%.4f";
            break;
        case 5:
            return @"%.5f";
            break;
            
        default:
            return @"%.2f";
            break;
    }
    return @"%.2f";
}

@end


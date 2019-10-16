//
//  DemoChartsModel.h
//  LiveTrade
//
//  Created by ngw15 on 2019/1/23.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoChartsModel : NSObject

@property (nonatomic,copy) BOOL(^isDataAvailable)(NSString *symbol,EChartsType chartsType, EChartsLineType lineYype);
@property (nonatomic,strong) CFDBaseInfoModel *baseInfoData;

- (NSMutableArray *)getKLineDataCopy:(EChartsType)chartsType;
- (NSMutableArray *)getMLineDataCopy;

- (ThreadSafeArray *)mlineList;
- (void)clearData;
- (void)loadKlineData:(NSString *)contradId chartsType:(EChartsType )chartsType lineType:(EChartsLineType)lineType success:(dispatch_block_t) success failure:(dispatch_block_t)failure;
- (void)addKlineData:(NSString *)contradId chartsType:(EChartsType )chartsType lineType:(EChartsLineType)lineType success:(dispatch_block_t) success failure:(dispatch_block_t)failure;
- (void)klineMoreData:(NSString *)contradId chartsType:(EChartsType )chartsType lineType:(EChartsLineType)lineType success:(void(^)(NSInteger))success failure:(dispatch_block_t)failure;
- (BOOL)updateKlineDataWithSocketDic:(NSDictionary *)dic chartsType:(EChartsType)chartsType lineType:(EChartsLineType)lineType;
- (BOOL)updateMlineDataWithSocketDic:(NSDictionary *)dic lineType:(EChartsLineType)lineType;

- (void)cancelTask;
+ (NSString *)stringFormatByDotNum:(NSInteger)dotNum;

+ (void)calMA:(NSArray <CFDKLineData *>*)list dotNum:(NSInteger)dotNum;
+ (void)calBOLLData:(NSArray <CFDKLineData *>*)list dotNum:(NSInteger)dotNum;
+ (void)calMACDData:(NSArray <CFDKLineData *>*)list dotNum:(NSInteger)dotNum;
+ (void)calKDJData:(NSArray <CFDKLineData *>*)list dotNum:(NSInteger)dotNum;
+ (void)calRSIData:(NSArray <CFDKLineData *>*)list dotNum:(NSInteger)dotNum;
+ (void)calWRData:(NSArray <CFDKLineData *>*)list dotNum:(NSInteger)dotNum;
+ (void)calBIASData:(NSArray <CFDKLineData *>*)list dotNum:(NSInteger)dotNum;
+ (void)calCCIData:(NSArray <CFDKLineData *>*)list dotNum:(NSInteger)dotNum;

@end

NS_ASSUME_NONNULL_END

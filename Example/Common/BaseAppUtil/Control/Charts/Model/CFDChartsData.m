//
//  CFDMLineDataStruct.m
//  MyKLineView
//
//  Created by Han on 13-9-25.
//  Copyright (c) 2013年 Han. All rights reserved.
//

#import "CFDChartsData.h"
#import "NSDate+Additions.h"

@interface CFDBaseInfoModel ()



@end

@implementation CFDBaseInfoModel

- (id)init
{
    if (self =[super init]) {
        _iStockcode = @"";
        _iStockname = @"";
        _dotNum = 2;
        
        [self defaultData];
    }
    return self;
}

- (void)defaultData{
    self.iStockname=@"--";
    self.contractId=@"--";
    self.symbol=@"--";
    self.otherContractId=@"--";
    self.iStockcode=@"--";
    self.askp=@"--";
    self.bidp=@"--";
    self.highPrice=@"--";
    self.openPrice=@"--";
    self.lowPrice=@"--";
    self.closePrice=@"--";
    self.lastPrice=@"--";
    self.raise=@"--";
    self.raisRate=@"--";
    self.volume=@"--";
    self.spread=@"--";
    self.speed=@"--";
    self.rate=@"--";
    self.tradestatus=@"--";
    self.tradestatusText=@"--";
}

- (NSString *)priceFomatter:(NSString *)price{
    return [GUIUtil notRoundingString:price afterPoint:_dotNum];
}

- (void)setLastPrice:(NSString *)lastPrice{
    lastPrice = [self priceFomatter:lastPrice];
    _lastPrice = lastPrice;
    if ([lastPrice floatValue]>[_highPrice floatValue]) {
        _highPrice = lastPrice;
    }else if ([lastPrice floatValue]<[_lowPrice floatValue]) {
        _lowPrice = lastPrice;
    }
    self.raise = [GUIUtil decimalSubtract:lastPrice num:_closePrice];
    _raisRate = [GUIUtil decimalPercentDivide:_raise num:_closePrice];
    if (self.raise.floatValue>=0) {
        _raise = [@"+" stringByAppendingString:self.raise];
        _raisRate = [@"+" stringByAppendingString:self.raisRate];
    }
}

- (void)setRaise:(NSString *)raise{
    _raise = [self priceFomatter:raise];
}

- (void)setBidp:(NSString *)bidp{
    _bidp = [self priceFomatter:bidp];
}

- (void)setAskp:(NSString *)askp{
    _askp = [self priceFomatter:askp];
}

- (void)setHighPrice:(NSString *)highPrice{
    _highPrice = [self priceFomatter:highPrice];
}

- (void)setLowPrice:(NSString *)lowPrice{
    _lowPrice = [self priceFomatter:lowPrice];
}

- (void)setOpenPrice:(NSString *)openPrice{
    _openPrice = [self priceFomatter:openPrice];
}
- (void)setClosePrice:(NSString *)closePrice{
    _closePrice = [self priceFomatter:closePrice];
}

+ (CFDBaseInfoModel *)configData:(NSDictionary *)dict{
    CFDBaseInfoModel *model = [[self alloc] init];
    [model configNData:dict];
    return model;
}

- (void)configNData:(NSDictionary *)dict{
    _dotNum = [NDataUtil stringWithDict:dict keys:@[@"decimalplace",@"dotNum",@"hqDotnum"] valid:@"2"].integerValue;
    _bidp = [self priceFomatter:[NDataUtil stringWith:dict[@"bidPrice"]]];
    _askp = [self priceFomatter:[NDataUtil stringWith:dict[@"askPrice"]]];
    _iStockname = [NDataUtil stringWith:dict[@"name"]];
    _contractId = [NDataUtil stringWith:dict[@"contractId"] valid:@"0"];
    _symbol = [NDataUtil stringWith:dict[@"symbol"] valid:@"0"];
    _highPrice = [self priceFomatter:[NDataUtil stringWith:dict[@"high"] valid:@"0"]];
    _openPrice = [self priceFomatter:[NDataUtil stringWith:dict[@"open"] valid:@"0"]];
    _lowPrice = [self priceFomatter:[NDataUtil stringWith:dict[@"low"] valid:@"0"]];
    _closePrice = [self priceFomatter:[NDataUtil stringWith:dict[@"close"] valid:@"1"]];
    if ([_closePrice floatValue]==0) {
        _closePrice = @"1";
    }
    _lastPrice = [self priceFomatter:[NDataUtil stringWith:dict[@"tradePrice"] valid:@"0"]];
    _tradestatus = [NDataUtil stringWith:dict[@"status"]];
    _openStatusTrade = [NDataUtil integerWith:dict[@"status"]]==1?NSOpenStatusTradeTime:NSOpenStatusTradeNonTime;
    _tradestatusText = [NDataUtil stringWith:dict[@"statusText"]];
    _raise =  [NDataUtil stringWith:dict[@"upDown"] valid:@"0"];
    _raisRate =  [NDataUtil stringWith:dict[@"upDownRate"] valid:@"0"];
    _volume = [NDataUtil stringWith:dict[@"volume"]];
    _speed = [NDataUtil stringWith:dict[@"changeSpeed"]];
    _spread = [NDataUtil stringWith:dict[@"fluctuate"]];
}

- (CFDBaseInfoModel *)updateSocketDic:(NSDictionary *)dic{
    CFDBaseInfoModel *model = [[CFDBaseInfoModel alloc] init];
    model.iStockname = self.iStockname;
    model.contractId = self.contractId;
    model.symbol = self.symbol;
    model.iStockcode = self.iStockcode;
    model.dotNum = self.dotNum;
    model.highPrice = self.highPrice;
    model.openPrice = self.openPrice;
    model.lowPrice = self.lowPrice;
    model.spread =self.spread;
    model.speed =self.speed;
    model.rate = self.rate;
    model.tradestatus =self.tradestatus;
    model.tradestatusText = self.tradestatusText;
    model.openStatusTrade = self.openStatusTrade;
    
    model.closePrice = [NDataUtil stringWith:dic[@"c"] valid:@"1"];
    model.lastPrice = [NDataUtil stringWith:dic[@"t"]];
    model.bidp =  [NDataUtil stringWith:dic[@"b"]];
    model.askp = [NDataUtil stringWith:dic[@"a"]];
    model.volume = [NDataUtil stringWith:dic[@"V"]];
    return model;
}


@end

@interface CFDLineData ()
@property(nonatomic,strong)NSDateFormatter *formatter;
@end

@implementation CFDLineData

- (instancetype)init
{
    self = [super init];
    if (self) {
        _formatter = [[NSDateFormatter alloc] init];
    }
    return self;
}

- (void)setINowv:(NSString *)iNowv{
    _iNowv = iNowv;
    self.isRed = [ChartsUtil compare:self.iNowv.floatValue withFloat:[self.iOpenp floatValue]] != NSOrderedAscending;
    [self nowPriceChanged];
}

- (void)setTimestemp:(NSString *)timestemp{
    _timestemp = timestemp;
    self.iTimes = [NSDate klineDateByTimestemp:[timestemp longLongValue]/1000];
}

- (void)setITimes:(NSString *)iTimes{
    _iTimes =iTimes;
    [self setITimeTextByChartsType:EChartsType_UNKOWN];
}

- (void)setITimeTextByChartsType:(EChartsType)chartstype timestemp:(long long)timestemp{
    self.iTimes = [NSDate klineDateByTimestemp:timestemp/1000];
    [self setITimeTextByChartsType:chartstype];
}

- (void)setITimeTextByChartsType:(EChartsType)chartstype{
    
    if (chartstype == EChartsType_KL||
        chartstype == EChartsType_KL_WEEK||
        chartstype == EChartsType_KL_MONTH) {
        _iTimeText = [self dateStrFromTime_day:_iTimes];
        _iCursorTimeText = _iTimeText;
        [_formatter setDateFormat:@"yyyy-MM-dd"];
        _formatTimestemp = [[_formatter dateFromString:_iCursorTimeText] timeIntervalSince1970]*1000;
    }else if (chartstype==EChartsType_RT){
        _iTimeText = [self dateStringFromTime_miu:_iTimes];
        _iCursorTimeText = _iTimeText;
    }else if (chartstype==EChartsType_KL_3){
        _iTimeText = [self dateStringFromTime_miu:_iTimes];
        _iCursorTimeText = [self cursorDateStringFromTime_miu:_iTimes];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        _formatTimestemp = [[_formatter dateFromString:_iCursorTimeText] timeIntervalSince1970]*1000;
    }else if (chartstype==EChartsType_KL_5){
        _iTimeText = [self dateStringFromTime_miu:_iTimes];
        _iCursorTimeText = [self cursorDateStringFromTime_miu:_iTimes];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        _formatTimestemp = [[_formatter dateFromString:_iCursorTimeText] timeIntervalSince1970]*1000;
    }else if (chartstype==EChartsType_KL_15){
        _iTimeText = [self dateStringFromTime_miu:_iTimes];
        _iCursorTimeText = [self cursorDateStringFromTime_miu:_iTimes];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        _formatTimestemp = [[_formatter dateFromString:_iCursorTimeText] timeIntervalSince1970]*1000;
    }else if (chartstype==EChartsType_KL_30){
        _iTimeText = [self dateStringFromTime_miu:_iTimes];
        _iCursorTimeText = [self cursorDateStringFromTime_miu:_iTimes];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        _formatTimestemp = [[_formatter dateFromString:_iCursorTimeText] timeIntervalSince1970]*1000;
    }else if (chartstype==EChartsType_KL_60){
        _iTimeText = [self dateStringFromTime_miu:_iTimes];
        _iCursorTimeText = [self cursorDateStringFromTime_miu:_iTimes];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        _formatTimestemp = [[_formatter dateFromString:_iCursorTimeText] timeIntervalSince1970]*1000;
    }else if (chartstype==EChartsType_KL_240){
        _iTimeText = [self dateStringFromTime_miu:_iTimes];
        _iCursorTimeText = [self cursorDateStringFromTime_miu:_iTimes];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        _formatTimestemp = [[_formatter dateFromString:_iCursorTimeText] timeIntervalSince1970]*1000;
    }
    else{
        _iTimeText = [self dateStringFromTime_miu:_iTimes];
        _iCursorTimeText = [self cursorDateStringFromTime_miu:_iTimes];
        [_formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        _formatTimestemp = [[_formatter dateFromString:_iCursorTimeText] timeIntervalSince1970]*1000;
    }
}

- (void)nowPriceChanged{
    
}

//MARK: - Private
//日K，周K，月K下显示的日期
- (NSString *)dateStrFromTime_day:(NSString *)string{
    if (![string isKindOfClass:[NSString class]]||string.length<6) {
        return @"";
    }
    NSString *tem = [NSString stringWithFormat:@"%@-%@-%@",[string substringWithRange:NSMakeRange(string.length-14, 4)],[string substringWithRange:NSMakeRange(string.length-10, 2)],[string substringWithRange:NSMakeRange(string.length-8, 2)]];
    return tem;
}

- (NSString *)dateStringFromTime_miu:(NSString *)string{
    if (![string isKindOfClass:[NSString class]]||string.length<6) {
        return @"";
    }
    NSString *tem = [NSString stringWithFormat:@"%@:%@",[string substringWithRange:NSMakeRange(string.length-6, 2)],[string substringWithRange:NSMakeRange(string.length-4, 2)]];
    return tem;
}

- (NSString *)cursorDateStringFromTime_miu:(NSString *)string{
    if (![string isKindOfClass:[NSString class]]||string.length<14) {
        return @"";
    }
    NSString *tem = [NSString stringWithFormat:@"%@-%@-%@ %@:%@",[string substringWithRange:NSMakeRange(string.length-14, 4)],[string substringWithRange:NSMakeRange(string.length-10, 2)],[string substringWithRange:NSMakeRange(string.length-8, 2)],[string substringWithRange:NSMakeRange(string.length-6, 2)],[string substringWithRange:NSMakeRange(string.length-4, 2)]];
    return tem;
}


@end

@implementation CFDMLineData

- (id)mutableCopyWithZone:(NSZone *)zone{
    CFDMLineData *lineData = [[[self class] allocWithZone:zone] init];
    lineData.timestemp=self.timestemp;
    lineData.iTimes=self.iTimes;
    lineData.iTimeText=self.iTimeText;
    lineData.iCursorTimeText=self.iCursorTimeText;
    lineData.iHighp=self.iHighp;
    lineData.iOpenp=self.iOpenp;
    lineData.iLowp=self.iLowp;
    lineData.iPreclose=self.iPreclose;
    lineData.iNowv=self.iNowv;
    lineData.iUpdown=self.iUpdown;
    lineData.iUpdownRate=self.iUpdownRate;
    lineData.volDic=self.volDic;
    lineData.isRed=self.isRed;
    lineData.isHttpData=self.isHttpData;
    return lineData;
}

- (void)nowPriceChanged{
    if ([ChartsUtil compare:[self.iNowv floatValue] withFloat:[self.iHighp floatValue]]==NSOrderedDescending) {
        self.iHighp = self.iNowv;
    }
    if ([ChartsUtil compare:[self.iNowv floatValue] withFloat:[self.iLowp floatValue]]==NSOrderedAscending){
        self.iLowp = self.iNowv;
    }
    NSString *raise = [[NSDecimalNumber decimalNumberWithString:self.iNowv] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:self.iPreclose]].stringValue;
    NSDecimalNumber *raiseRateDec = [[[NSDecimalNumber decimalNumberWithString:raise] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:self.iPreclose]] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    NSString *raiseRate = [GUIUtil notRounding:raiseRateDec afterPoint:2];
    self.iUpdown =  raise;
    self.iUpdownRate =  [NSString stringWithFormat:@"%@%%",raiseRate];
}

@end

@implementation CFDKLineData

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.iHighp = [NSString stringWithFormat:@"%.2f",CGFLOAT_MIN];
        self.iLowp = [NSString stringWithFormat:@"%.2f",CGFLOAT_MAX];
    }
    return self;
}

- (id)mutableCopyWithZone:(NSZone *)zone{
    CFDKLineData *lineData = [[[self class] allocWithZone:zone] init];
    lineData.timestemp=self.timestemp;
    lineData.iTimes=self.iTimes;
    lineData.iTimeText=self.iTimeText;
    lineData.iCursorTimeText=self.iCursorTimeText;
    lineData.iHighp=self.iHighp;
    lineData.iOpenp=self.iOpenp;
    lineData.iLowp=self.iLowp;
    lineData.iPreclose=self.iPreclose;
    lineData.iNowv=self.iNowv;
    lineData.iUpdown=self.iUpdown;
    lineData.iUpdownRate=self.iUpdownRate;
    lineData.volDic=self.volDic;
    lineData.isRed=self.isRed;
    lineData.isHttpData=self.isHttpData;
    lineData.MADic=self.MADic;
    lineData.MACDDic=self.MACDDic;
    lineData.KDJDic=self.KDJDic;
    lineData.RSIDic=self.RSIDic;
    return lineData;
}

- (void)nowPriceChanged{
    if ([ChartsUtil compare:[self.iNowv floatValue] withFloat:[self.iHighp floatValue]]==NSOrderedDescending) {
        self.iHighp = self.iNowv;
    }
    if ([ChartsUtil compare:[self.iNowv floatValue] withFloat:[self.iLowp floatValue]]==NSOrderedAscending){
        self.iLowp = self.iNowv;
    }
    NSString *raise = [[NSDecimalNumber decimalNumberWithString:self.iNowv] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:self.iPreclose]].stringValue;
    NSDecimalNumber *raiseRateDec = [[[NSDecimalNumber decimalNumberWithString:raise] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:self.iPreclose]] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:@"100"]];
    NSString *raiseRate = [GUIUtil notRounding:raiseRateDec afterPoint:2];
    self.iUpdown =  raise;
    self.iUpdownRate =  [NSString stringWithFormat:@"%@%%",raiseRate];
}


@end




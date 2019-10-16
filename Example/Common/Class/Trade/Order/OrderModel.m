//
//  OrderModel.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "OrderModel.h"

@interface OrderModel()


@end

@implementation OrderModel

- (instancetype)initWithSymbol:(NSString *)symbol{
    if (self = [super init]) {
        [self defaultData];
        _symbol = symbol;
    }
    return self;
}

- (void)defaultData{
    _isLoaded = NO;
    
    _delegateAmount=@"";
    _margin=@"--";
    _pry=@"";
    _slPrecent=@"";
    _tpPrecent=@"";
    _fee=@"";
    _contractname=@"";
    _lastPrice=@"";
    _cantrade=@"";
    _balance=@"";
    _perFee=@"-1";
    _minfloat=@"";
    _scale=@"";
    _maxBuyAmount=@"";
    _amountFloat = @"1";
    _perValue = @"";
    _pryList=nil;
    _slPrecentList=nil;
    _tpPrecentList=nil;
    
    _delegateValue = @"--";
}

- (void)configData:(NSDictionary *)dic{
    
    _contractname=[NDataUtil stringWith:dic[@"contractname"]];
    _openPrice=
    _lastPrice=[NDataUtil stringWith:dic[@"nowpx"]];
    _cantrade=[NDataUtil stringWith:dic[@"cantrade"]];
    _balance=[NDataUtil stringWith:dic[@"balance"]];
    _perFee=[NDataUtil stringWith:dic[@"perrmbfee"]];
    _minfloat=[NDataUtil stringWith:dic[@"minfloat"]];
    _dotNum = log10f(_minfloat.floatValue);
    _dotNum = ABS(_dotNum);
    _scale=[NDataUtil stringWith:dic[@"contractSize"]];
    _maxBuyAmount = [NDataUtil stringWith:dic[@"maxbuyvol"] valid:@"100"];
    _amountFloat = [NDataUtil stringWith:dic[@"volPoint"] valid:@"1"];
    _perValue = [NDataUtil stringWith:dic[@"perProfit"] valid:@"1"];
    _marketOrderTip = [NDataUtil stringWith:dic[@"marketOrderTip"]];
    _limitOrderTip = [NDataUtil stringWith:dic[@"limitOrderTip"]];
    NSMutableArray *temPryList = [NSMutableArray array];
    NSArray *pryList=[NDataUtil arrayWith:dic[@"pryBarMultiple"]];;
    for (NSInteger i=0; i<pryList.count; i++) {
        NSString *pry = [NDataUtil stringWith:pryList[i]];
        NSString *pryText = [NSString stringWithFormat:@"%@%@",pry,CFDLocalizedString(@"倍")];
        [temPryList addObject:@{@"data":pry,@"showText":pryText}];
    }
    _pryList = temPryList;
    
    NSArray *slList=[NDataUtil arrayWith:dic[@"stoplossPrecentLevel"]];;
    NSArray *tpList=[NDataUtil arrayWith:dic[@"stopprofitPrecentLevel"]];;
    _slPrecentList = [OrderModel pickerData:slList];
    _tpPrecentList = [OrderModel pickerData:tpList];
    
    if (_isLoaded==NO) {
        _isLoaded = YES;
        _ordertype = @"2";
        _delegateAmount=@"1";
        
        _pry = [NDataUtil stringWith:dic[@"defaultPrybar"]];
        _slPrecent = [NDataUtil stringWith:dic[@"defaultStoplossPrecent"]];
        _tpPrecent = [NDataUtil stringWith:dic[@"defaultStopprofitPrecent"]];
    }
    [self calData];
}

- (void)calData{
    
    if (_isLoaded==NO) {
        return;
    }
    NSString *price = _openPrice;
    NSString *value = [GUIUtil decimalMultiply:_delegateAmount num:price];
    _delegateValue = [GUIUtil decimalMultiply:_scale num:value];
    _delegateValue = [GUIUtil notRoundingString:_delegateValue afterPoint:4];
    _margin = [GUIUtil decimalDivide:_delegateValue num:_pry];
    _margin = [GUIUtil notRoundingString:_margin afterPoint:4];
    _fee = [GUIUtil decimalMultiply:_delegateAmount num:_perFee];
}

- (NSDictionary *)calSLData:(NSString *)slPrencet{
    NSString *slValue = [GUIUtil decimalMultiply:_margin num:slPrencet];
    NSString *slPoint = [GUIUtil decimalDivide:slValue num:_perValue];
    slPoint = [GUIUtil decimalDivide:slPoint num:_delegateAmount];
    slPoint = [NSString stringWithFormat:@"%ld",(long)slPoint.integerValue];
    NSString *difPrice = [GUIUtil decimalMultiply:slPoint num:_minfloat];
    return @{@"value":slValue,@"point":slPoint,@"difPrice":difPrice,@"openPrice":_openPrice};
}

- (NSDictionary *)calTPData:(NSString *)slPrencet{
    NSString *tpValue = [GUIUtil decimalMultiply:_margin num:slPrencet];
    NSString *tpPoint = [GUIUtil decimalDivide:tpValue num:_perValue];
    tpPoint = [GUIUtil decimalDivide:tpPoint num:_delegateAmount];
    tpPoint = [NSString stringWithFormat:@"%ld",(long)tpPoint.integerValue];
    NSString *difPrice = [GUIUtil decimalMultiply:tpPoint num:_minfloat];
    return @{@"value":tpValue,@"point":tpPoint,@"difPrice":difPrice,@"openPrice":_openPrice};
}

- (void)changedSymbol:(NSString *)symbol{
    if (![_symbol isEqualToString:symbol]) {
        [self defaultData];
        _symbol = symbol;
    }
}

- (void)changedPrice:(NSString *)price{
    if (![_openPrice isEqualToString:price]&&price.length>0) {
        NSLog(@"openPrice:%@",price);
        _openPrice = price;
        [self calData];
        _priceChangedHander();
    }
}

- (void)changedOrdertype:(BOOL)isMarket{
    self.ordertype = isMarket?@"2":@"1";
}

+ (NSArray *)pickerData:(NSArray *)list{
    NSMutableArray *temtpList = [NSMutableArray array];
    for (NSInteger i=0; i<list.count; i++) {
        NSString *tp = [NDataUtil stringWith:list[i]];
        NSString *tpText = [NSString stringWithFormat:@"%@%%",[GUIUtil decimalMultiply:tp num:@"100"]];
        [temtpList addObject:@{@"data":tp,@"showText":tpText}];
    }
    return temtpList;
}

+ (NSDictionary *)calSLData:(NSString *)slPrencet data:(NSDictionary *)dic{
    NSString *margin = [NDataUtil stringWith:dic[@"margin"]];
    NSString *quantity = [NDataUtil stringWith:dic[@"quantity"]];
    NSString *perValue = [NDataUtil stringWith:dic[@"perProfit"]];
    NSString *minfloat = [NDataUtil stringWith:dic[@"minfloat"]];
    NSString *buyPrice = [NDataUtil stringWith:dic[@"buyprice"]];
    NSString *slValue = [GUIUtil decimalMultiply:margin num:slPrencet];
    NSString *slPoint = [GUIUtil decimalDivide:slValue num:perValue];
    slPoint = [GUIUtil decimalDivide:slPoint num:quantity];
    slPoint = [NSString stringWithFormat:@"%ld",(long)slPoint.integerValue];
    NSString *difPrice = [GUIUtil decimalMultiply:slPoint num:minfloat];
    return @{@"value":slValue,@"point":slPoint,@"difPrice":difPrice,@"openPrice":buyPrice};
}

+ (NSDictionary *)calTPData:(NSString *)slPrencet data:(NSDictionary *)dic{
    
    NSString *margin = [NDataUtil stringWith:dic[@"margin"]];
    NSString *quantity = [NDataUtil stringWith:dic[@"quantity"]];
    NSString *perValue = [NDataUtil stringWith:dic[@"perProfit"]];
    NSString *minfloat = [NDataUtil stringWith:dic[@"minfloat"]];
    NSString *buyPrice = [NDataUtil stringWith:dic[@"buyprice"]];
    NSString *tpValue = [GUIUtil decimalMultiply:margin num:slPrencet];
    NSString *tpPoint = [GUIUtil decimalDivide:tpValue num:perValue];
    tpPoint = [GUIUtil decimalDivide:tpPoint num:quantity];
    tpPoint = [NSString stringWithFormat:@"%ld",(long)tpPoint.integerValue];
    NSString *difPrice = [GUIUtil decimalMultiply:tpPoint num:minfloat];
    return @{@"value":tpValue,@"point":tpPoint,@"difPrice":difPrice,@"openPrice":buyPrice};
}

@end

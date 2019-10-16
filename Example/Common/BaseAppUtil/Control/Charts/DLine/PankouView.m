//
//  PankouView.m
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "PankouView.h"
#import "SinglePankouLayer.h"

@interface PankouView ()

@property (nonatomic,strong) NSMutableArray <SinglePankouLayer *>*buyLayerList;
@property (nonatomic,strong) NSMutableArray <SinglePankouLayer *>*sellLayerList;

@end

@implementation PankouView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _singleHeight = [GUIUtil fit:25];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    _buyLayerList = [NSMutableArray array];
    _sellLayerList = [NSMutableArray array];
    for (int i=0; i<20; i++) {
        SinglePankouLayer *buyLayer = self.singleBuyPankou;
        buyLayer.position = CGPointMake(0, i*_singleHeight);
        [buyLayer setSNText:[NSString stringWithFormat:@"%d",i+1]];
        [self.layer addSublayer:buyLayer];
        [self.buyLayerList addObject:buyLayer];
    }
    for (int i=0; i<20; i++) {
        SinglePankouLayer *sellLayer = self.singleSellPankou;
        sellLayer.position = CGPointMake(self.width/2, i*_singleHeight);
        [sellLayer setSNText:[NSString stringWithFormat:@"%d",i+1]];
        [self.layer addSublayer:sellLayer];
        [self.sellLayerList addObject:sellLayer];
    }
}

- (void)configData:(NSArray *)data maxVol:(NSString *)maxVol{
    NSDictionary *buyDic = [NDataUtil dataWithArray:data index:0];
    NSArray *buyList = [NDataUtil arrayWith:buyDic[@"data"]];
    if (buyList.count>20) {
        buyList = [buyList subarrayWithRange:NSMakeRange(0, 20)];
    }
    NSDictionary *sellDic = [NDataUtil dataWithArray:data index:1];
    NSArray *sellList = [NDataUtil arrayWith:sellDic[@"data"]];
    if (sellList.count>20) {
        sellList = [sellList subarrayWithRange:NSMakeRange(0, 20)];
    }
    for (NSInteger i = 0; i<_buyLayerList.count; i++) {
        SinglePankouLayer *layer = [NDataUtil dataWithArray:_buyLayerList index:i];
        NSDictionary *data = [NDataUtil dictWithArray:buyList index:i];
        if (data) {
            [layer configData:data maxVol:maxVol];
            layer.hidden = NO;
        }else{
            layer.hidden = YES;
        }
    }
    for (NSInteger i = 0; i<_sellLayerList.count; i++) {
        SinglePankouLayer *layer = [NDataUtil dataWithArray:_sellLayerList index:i];
        NSDictionary *data = [NDataUtil dictWithArray:sellList index:i];
        [layer configData:data maxVol:maxVol];
        if (data) {
            [layer configData:data maxVol:maxVol];
            layer.hidden = NO;
        }else{
            layer.hidden = YES;
        }
    }
}

- (SinglePankouLayer *)singleBuyPankou{
    SinglePankouLayer *pankou = [[SinglePankouLayer alloc] init];
    pankou.bounds = CGRectMake(0, 0, self.width/2, _singleHeight);
    pankou.priceType = SinglePankouPriceTypeRight;
    pankou.degreeType = SinglePankouDegreeTypeRight;
    [pankou setDegreeBG:[GColorUtil colorWithColorType:C11_ColorType alpha:0.1]];
    [pankou setPriceColor:[GColorUtil C11]];
    [pankou setVolColor:[GColorUtil C22]];
    [pankou setFontSize:[GUIUtil fitFontSize:12]];
    return pankou;
}

- (SinglePankouLayer *)singleSellPankou{
    SinglePankouLayer *pankou = [[SinglePankouLayer alloc] init];
    pankou.bounds = CGRectMake(0, 0, self.width/2, _singleHeight);
    pankou.priceType = SinglePankouPriceTypeLeft;
    pankou.degreeType = SinglePankouDegreeTypeLeft;
    [pankou setDegreeBG:[GColorUtil colorWithColorType:C12_ColorType alpha:0.1]];
    [pankou setPriceColor:[GColorUtil C12]];
    [pankou setVolColor:[GColorUtil C22]];
    [pankou setFontSize:[GUIUtil fitFontSize:12]];
    return pankou;
}


@end

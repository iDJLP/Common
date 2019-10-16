//
//  Pankou5View.m
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "Pankou5View.h"
#import "SinglePankouLayer.h"

@interface Pankou5View ()

@property (nonatomic,strong) NSMutableArray <SinglePankouLayer *>*buyLayerList;
@property (nonatomic,strong) NSMutableArray <SinglePankouLayer *>*sellLayerList;

@end

@implementation Pankou5View

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _singleHeight = [GUIUtil fit:30];
        [self setupUI];
        [self addNotic];
    }
    return self;
}

- (instancetype)initWithSingle:(CGFloat)singleHeight{
    if (self = [super init]) {
        _singleHeight = singleHeight;
        [self setupUI];
        [self addNotic];
    }
    return self;
}

- (void)setupUI{
    _buyLayerList = [NSMutableArray array];
    _sellLayerList = [NSMutableArray array];
    for (int i=0; i<5; i++) {
        SinglePankouLayer *buyLayer = self.singleBuyPankou;
        buyLayer.position = CGPointMake(0, i*_singleHeight);
        [self.layer addSublayer:buyLayer];
        [self.buyLayerList addObject:buyLayer];
    }
    CGFloat height = _singleHeight*5+[GUIUtil fit:30];
    for (int i=0; i<5; i++) {
        SinglePankouLayer *sellLayer = self.singleSellPankou;
        sellLayer.position = CGPointMake(0, height+i*_singleHeight);
        [self.layer addSublayer:sellLayer];
        [self.sellLayerList addObject:sellLayer];
    }
}

- (void)configData:(NSArray *)data maxVol:(NSString *)maxVol{
    NSArray *buyList = [NDataUtil arrayWithArray:data index:0];
    NSArray *sellList = [NDataUtil arrayWithArray:data index:1];
//    for (NSInteger i = 0; i<_buyLayerList.count; i++) {
//        SinglePankouLayer *layer = [NDataUtil dataWithArray:_buyLayerList index:i];
//        NSDictionary *data = [NDataUtil dictWithArray:buyList index:i];
//        if (data) {
//            [layer configData:data maxVol:maxVol];
//            layer.hidden = NO;
//        }else{
//            layer.hidden = YES;
//        }
//    }
//    for (NSInteger i=_sellLayerList.count-1; i>=0; i--) {
//        SinglePankouLayer *layer = [NDataUtil dataWithArray:_sellLayerList index:i];
//        NSDictionary *data = [NDataUtil dictWithArray:sellList index:sellList.count];
//        if (data) {
//            [layer configData:data maxVol:maxVol];
//            layer.hidden = NO;
//        }else{
//            layer.hidden = YES;
//        }
//    }
    for (NSInteger i = 0; i<_buyLayerList.count; i++) {
        SinglePankouLayer *layer = [NDataUtil dataWithArray:_buyLayerList index:_buyLayerList.count-(i+1)];
        NSDictionary *data = [NDataUtil dictWithArray:buyList index:buyList.count-(i+1)];
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
    pankou.bgColor = C6_ColorType;
    pankou.bounds = CGRectMake(0, 0, [GUIUtil fit:125], _singleHeight);
    pankou.priceType = SinglePankouPriceTypeLeft;
    pankou.degreeType = SinglePankouDegreeTypeRight;
    [pankou setDegreeBG:[GColorUtil colorWithColorType:C12_ColorType alpha:0.1]];
    [pankou setPriceColor:[GColorUtil C12]];
    [pankou setVolColor:[GColorUtil C22]];
    [pankou setFontSize:[GUIUtil fitFontSize:12]];
    [pankou showSN:NO];
    return pankou;
}

- (SinglePankouLayer *)singleSellPankou{
    SinglePankouLayer *pankou = [[SinglePankouLayer alloc] init];
    pankou.bgColor = C6_ColorType;
    pankou.bounds = CGRectMake(0, 0, [GUIUtil fit:125], _singleHeight);
    pankou.priceType = SinglePankouPriceTypeLeft;
    pankou.degreeType = SinglePankouDegreeTypeRight;
    [pankou setDegreeBG:[GColorUtil colorWithColorType:C11_ColorType alpha:0.1]];
    [pankou setPriceColor:[GColorUtil C11]];
    [pankou setVolColor:[GColorUtil C22]];
    [pankou setFontSize:[GUIUtil fitFontSize:12]];
    [pankou showSN:NO];
    return pankou;
}

- (void)themeChangedAction{
    [self base_themeChangedAction];
    for (SinglePankouLayer *buyLayer in self.buyLayerList) {
        [buyLayer setDegreeBG:[GColorUtil colorWithColorType:C12_ColorType alpha:0.1]];
        [buyLayer setPriceColor:[GColorUtil C12]];
    }
    for (SinglePankouLayer *sellLayer in self.sellLayerList) {
        [sellLayer setDegreeBG:[GColorUtil colorWithColorType:C11_ColorType alpha:0.1]];
        [sellLayer setPriceColor:[GColorUtil C11]];
    }
}

- (void)addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
    [center addObserver:self
               selector:@selector(themeChangedAction)
                   name:ThemeDidChangedNotification
                 object:nil];
}


@end


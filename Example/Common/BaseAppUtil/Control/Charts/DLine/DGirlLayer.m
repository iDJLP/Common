//
//  DGirlLayer.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/30.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "DGirlLayer.h"

@interface DGirlLayer ()

@property (nonatomic,strong)CALayer *buyLayer;
@property (nonatomic,strong)CALayer *sellLayer;

@property (nonatomic,strong)CATextLayer *buyTextLayer;
@property (nonatomic,strong)CATextLayer *sellTextLayer;

@property (nonatomic,strong)CATextLayer *vol1TextLayer;
@property (nonatomic,strong)CATextLayer *vol2TextLayer;
@property (nonatomic,strong)CATextLayer *vol3TextLayer;
@property (nonatomic,strong)CATextLayer *vol4TextLayer;
@property (nonatomic,strong)CATextLayer *vol5TextLayer;

@property (nonatomic,strong)CATextLayer *leftTextLayer;
@property (nonatomic,strong)CATextLayer *centerTextLayer;
@property (nonatomic,strong)CATextLayer *rightTextLayer;

@end

@implementation DGirlLayer

- (instancetype)init{
    if (self = [super init]) {
        [self addSublayer:self.buyLayer];
        [self addSublayer:self.buyTextLayer];
        [self addSublayer:self.sellLayer];
        [self addSublayer:self.sellTextLayer];
        
        [self addSublayer:self.vol1TextLayer];
        [self addSublayer:self.vol2TextLayer];
        [self addSublayer:self.vol3TextLayer];
        [self addSublayer:self.vol4TextLayer];
        [self addSublayer:self.vol5TextLayer];
        
        [self addSublayer:self.leftTextLayer];
        [self addSublayer:self.centerTextLayer];
        [self addSublayer:self.rightTextLayer];
    }
    return self;
}

- (void)layoutSublayers{
    [super layoutSublayers];
    [self autoLayout];
}

- (void)autoLayout{
    CGFloat rightPadding = [GUIUtil fit:5];
    {
        _buyLayer.frame = CGRectMake([GUIUtil fit:151], [GUIUtil fit:14], [GUIUtil fit:7], [GUIUtil fit:7]);
        _sellLayer.frame = CGRectMake([GUIUtil fit:193], [GUIUtil fit:14], [GUIUtil fit:7], [GUIUtil fit:7]);
        _buyTextLayer.frame = CGRectMake([GUIUtil fit:163], [GUIUtil fit:10], [GUIUtil fit:30], [GUIUtil fit:20]);
        _sellTextLayer.frame = CGRectMake([GUIUtil fit:205], [GUIUtil fit:10], [GUIUtil fit:30], [GUIUtil fit:20]);
    }
    {
        CGFloat bottomTextWidth = [GUIUtil fit:60];
        CGFloat bottomTextHeight = CTimeAixsHight;
        _leftTextLayer.anchorPoint = CGPointMake(0, 1);
        _centerTextLayer.anchorPoint = CGPointMake(0.5, 1);
        _rightTextLayer.anchorPoint = CGPointMake(1, 1);
        
        _leftTextLayer.size =
        _centerTextLayer.size =
        _rightTextLayer.size = CGSizeMake(bottomTextWidth, bottomTextHeight);
        
        _leftTextLayer.position = CGPointMake(rightPadding, self.height+[GUIUtil fit:6]);
        _centerTextLayer.position = CGPointMake(self.width/2, self.height+[GUIUtil fit:6]);
        _rightTextLayer.position = CGPointMake(self.width-rightPadding, self.height+[GUIUtil fit:6]);
    }
    {
        _vol1TextLayer.anchorPoint =
        _vol2TextLayer.anchorPoint =
        _vol3TextLayer.anchorPoint =
        _vol4TextLayer.anchorPoint =
        _vol5TextLayer.anchorPoint =
        CGPointMake(1, 0.5);
        
        _vol1TextLayer.size =
        _vol2TextLayer.size =
        _vol3TextLayer.size =
        _vol4TextLayer.size =
        _vol5TextLayer.size =
        CGSizeMake([GUIUtil fit:60], [GUIUtil fitFont:10].lineHeight);
        
        CGFloat top = [GUIUtil fit:25];
        CGFloat bottom = self.height-CTimeAixsHight;
        CGFloat padding = (bottom-top)/5;
        _vol1TextLayer.position = CGPointMake(self.width-rightPadding,top);
        _vol2TextLayer.position = CGPointMake(self.width-rightPadding, top+padding);
        _vol3TextLayer.position = CGPointMake(self.width-rightPadding, top+padding*2);
        _vol4TextLayer.position = CGPointMake(self.width-rightPadding, top+padding*3);
        _vol5TextLayer.position = CGPointMake(self.width-rightPadding, top+padding*4);
    }
}

- (void)configViewWithMinPrice:(NSString *)minPrice maxPrice:(NSString *)maxPrice centerPrice:(NSString *)centerPrice maxVol:(NSString *)maxVol{
    _rightTextLayer.string = maxPrice;
    _centerTextLayer.string = centerPrice;
    _leftTextLayer.string = minPrice;
    
    _vol1TextLayer.string = maxVol;
    _vol2TextLayer.string = [GUIUtil decimalMultiply:[GUIUtil decimalDivide:maxVol num:@"5"] num:@"4"];
    _vol3TextLayer.string = [GUIUtil decimalMultiply:[GUIUtil decimalDivide:maxVol num:@"5"] num:@"3"];
    _vol4TextLayer.string = [GUIUtil decimalMultiply:[GUIUtil decimalDivide:maxVol num:@"5"] num:@"2"];
    _vol5TextLayer.string = [GUIUtil decimalMultiply:[GUIUtil decimalDivide:maxVol num:@"5"] num:@"1"];
}

- (CALayer *)buyLayer{
    if (!_buyLayer) {
        _buyLayer = [[CALayer alloc] init];
        _buyLayer.backgroundColor = [GColorUtil C9].CGColor;
    }
    return _buyLayer;
}
- (CALayer *)sellLayer{
    if (!_sellLayer) {
        _sellLayer = [[CALayer alloc] init];
        _sellLayer.backgroundColor = [GColorUtil C10].CGColor;
    }
    return _sellLayer;
}

- (CATextLayer *)buyTextLayer{
    if (!_buyTextLayer) {
        _buyTextLayer = [[CATextLayer alloc] init];
        _buyTextLayer.foregroundColor = [ChartsUtil C9].CGColor;
        _buyTextLayer.fontSize = [ChartsUtil fitFontSize:10];
        _buyTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _buyTextLayer.alignmentMode=kCAAlignmentLeft;
        _buyTextLayer.string = CFDLocalizedString(@"买盘");
    }
    return _buyTextLayer;
}
- (CATextLayer *)sellTextLayer{
    if (!_sellTextLayer) {
        _sellTextLayer = [[CATextLayer alloc] init];
        _sellTextLayer.foregroundColor = [ChartsUtil C10].CGColor;
        _sellTextLayer.fontSize = [ChartsUtil fitFontSize:10];
        _sellTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _sellTextLayer.alignmentMode=kCAAlignmentLeft;
        _sellTextLayer.string = CFDLocalizedString(@"卖盘");
    }
    return _sellTextLayer;
}

- (CATextLayer *)vol1TextLayer{
    if (!_vol1TextLayer) {
        UIFont *font = [UIFont systemFontOfSize:8];
        _vol1TextLayer = [[CATextLayer alloc] init];
        _vol1TextLayer.foregroundColor = [ChartsUtil C3].CGColor;
        _vol1TextLayer.font = (__bridge CFTypeRef _Nullable)(font.fontName);
        _vol1TextLayer.fontSize = [ChartsUtil fitFontSize:8];
        _vol1TextLayer.contentsScale = [UIScreen mainScreen].scale;
        _vol1TextLayer.alignmentMode=kCAAlignmentRight;
    }
    return _vol1TextLayer;
}
- (CATextLayer *)vol2TextLayer{
    if (!_vol2TextLayer) {
        UIFont *font = [UIFont systemFontOfSize:8];
        _vol2TextLayer = [[CATextLayer alloc] init];
        _vol2TextLayer.foregroundColor = [ChartsUtil C3].CGColor;
        _vol2TextLayer.font = (__bridge CFTypeRef _Nullable)(font.fontName);
        _vol2TextLayer.fontSize = [ChartsUtil fitFontSize:8];
        _vol2TextLayer.contentsScale = [UIScreen mainScreen].scale;
        _vol2TextLayer.alignmentMode=kCAAlignmentRight;
    }
    return _vol2TextLayer;
}
- (CATextLayer *)vol3TextLayer{
    if (!_vol3TextLayer) {
        UIFont *font = [UIFont systemFontOfSize:8];
        _vol3TextLayer = [[CATextLayer alloc] init];
        _vol3TextLayer.foregroundColor = [ChartsUtil C3].CGColor;
        _vol3TextLayer.font = (__bridge CFTypeRef _Nullable)(font.fontName);
        _vol3TextLayer.fontSize = [ChartsUtil fitFontSize:8];
        _vol3TextLayer.contentsScale = [UIScreen mainScreen].scale;
        _vol3TextLayer.alignmentMode=kCAAlignmentRight;
    }
    return _vol3TextLayer;
}
- (CATextLayer *)vol4TextLayer{
    if (!_vol4TextLayer) {
        UIFont *font = [UIFont systemFontOfSize:8];
        _vol4TextLayer = [[CATextLayer alloc] init];
        _vol4TextLayer.foregroundColor = [ChartsUtil C3].CGColor;
        _vol4TextLayer.font = (__bridge CFTypeRef _Nullable)(font.fontName);
        _vol4TextLayer.fontSize = [ChartsUtil fitFontSize:8];
        _vol4TextLayer.contentsScale = [UIScreen mainScreen].scale;
        _vol4TextLayer.alignmentMode=kCAAlignmentRight;
    }
    return _vol4TextLayer;
}
- (CATextLayer *)vol5TextLayer{
    if (!_vol5TextLayer) {
        UIFont *font = [UIFont systemFontOfSize:8];
        _vol5TextLayer = [[CATextLayer alloc] init];
        _vol5TextLayer.foregroundColor = [ChartsUtil C3].CGColor;
        _vol5TextLayer.font = (__bridge CFTypeRef _Nullable)(font.fontName);
        _vol5TextLayer.fontSize = [ChartsUtil fitFontSize:8];
        _vol5TextLayer.contentsScale = [UIScreen mainScreen].scale;
        _vol5TextLayer.alignmentMode=kCAAlignmentRight;
    }
    return _vol5TextLayer;
}

- (CATextLayer *)leftTextLayer{
    if(!_leftTextLayer){
        UIFont *font = [UIFont systemFontOfSize:8];
        _leftTextLayer = [[CATextLayer alloc] init];
        _leftTextLayer.foregroundColor = [ChartsUtil C3].CGColor;
        _leftTextLayer.font = (__bridge CFTypeRef _Nullable)(font.fontName);
        _leftTextLayer.fontSize = [ChartsUtil fitFontSize:8];
        _leftTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _leftTextLayer.alignmentMode=kCAAlignmentLeft;
    }
    return _leftTextLayer;
}
- (CATextLayer *)centerTextLayer{
    if(!_centerTextLayer){
        UIFont *font = [UIFont systemFontOfSize:8];
        _centerTextLayer = [[CATextLayer alloc] init];
        _centerTextLayer.foregroundColor = [ChartsUtil C3].CGColor;
        _centerTextLayer.font = (__bridge CFTypeRef _Nullable)(font.fontName);
        _centerTextLayer.fontSize = [ChartsUtil fitFontSize:8];
        _centerTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _centerTextLayer.alignmentMode=kCAAlignmentCenter;
    }
    return _centerTextLayer;
}
- (CATextLayer *)rightTextLayer{
    if(!_rightTextLayer){
        UIFont *font = [UIFont systemFontOfSize:8];
        _rightTextLayer = [[CATextLayer alloc] init];
        _rightTextLayer.foregroundColor = [ChartsUtil C3].CGColor;
        _rightTextLayer.font = (__bridge CFTypeRef _Nullable)(font.fontName);
        _rightTextLayer.fontSize = [ChartsUtil fitFontSize:8];
        _rightTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _rightTextLayer.alignmentMode=kCAAlignmentRight;
    }
    return _rightTextLayer;
}
@end

//
//  CFDGirlLayer.m
//  LiveTrade
//
//  Created by ngw15 on 2019/2/19.
//  Copyright © 2019 taojinzhe. All rights reserved.
//  时间轴绘制

#import "CFDGirlLayer.h"

@interface  CFDGirlLayer()

@property (nonatomic,strong)CAShapeLayer *girlVLineLayer;
@property (nonatomic,strong)CATextLayer *firstTextLayer;
@property (nonatomic,strong)CATextLayer *secondTextLayer;
@property (nonatomic,strong)CATextLayer *thirdTextLayer;
@property (nonatomic,strong)CATextLayer *fourthTextLayer;

@end

@implementation CFDGirlLayer

- (void)dealloc{
    [self removeNotic];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSublayer:self.girlVLineLayer];
        [self addSublayer:self.dateBgLayer];
        [self addSublayer:self.firstTextLayer];
        [self addSublayer:self.secondTextLayer];
        [self addSublayer:self.thirdTextLayer];
        [self addSublayer:self.fourthTextLayer];
        [self addNotic];
    }
    return self;
}

- (void)layoutSublayers{
    [super layoutSublayers];
    self.girlVLineLayer.frame= self.bounds;
    self.dateBgLayer.frame = CGRectMake(0, self.height, SCREEN_WIDTH, CTimeAixsHight);
}

//（纵轴）时间线的绘制
- (void)drawGirdVLine:(NSArray *)dataList
{
    WEAK_SELF;
    NSString *dateDraw = @"";
    CGFloat y = self.height;
    y = self.height+CTimeAixsHight/2;
    CGMutablePathRef vLinePath = CGPathCreateMutable();
    NSArray *layerList = @[self.firstTextLayer,self.secondTextLayer,self.thirdTextLayer,self.fourthTextLayer];
    CGFloat pointWidth= self.pointWidth();
    for (int i = 0; i < 4; i++) {
        NSInteger index = self.hCount()/3*i;
        if (index==dataList.count) {
            index=dataList.count-1;
        }
        CFDKLineData *kline = [NDataUtil dataWithArray:dataList index:index];
        dateDraw = kline.iTimeText;
        CGFloat x = pointWidth*index;
        
        CGPathMoveToPoint(vLinePath, NULL, x, 0);
        CGPathAddLineToPoint(vLinePath, NULL, x, self.height);
        dispatch_async(dispatch_get_main_queue(), ^{
            CATextLayer *textLayer = layerList[i];
            textLayer.string = [NDataUtil stringWith:dateDraw];
            textLayer.position = CGPointMake(ceil_half(x),ceil_half(y));
        });
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.girlVLineLayer.path = vLinePath;
        CGPathRelease(vLinePath);
    });
}

- (CAShapeLayer *)girlVLineLayer{
    if (!_girlVLineLayer) {
        _girlVLineLayer = [[CAShapeLayer alloc] init];
        _girlVLineLayer.fillColor = [UIColor clearColor].CGColor;
        _girlVLineLayer.strokeColor   = [ChartsUtil C7].CGColor;
        _girlVLineLayer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _girlVLineLayer;
}

- (CALayer *)dateBgLayer{
    if (!_dateBgLayer) {
        _dateBgLayer = [[CALayer alloc] init];
        _dateBgLayer.backgroundColor = [GColorUtil C6].CGColor;
    }
    return _dateBgLayer;
}

- (CATextLayer *)firstTextLayer{
    if (!_firstTextLayer) {
        _firstTextLayer = [[CATextLayer alloc] init];
        _firstTextLayer.fontSize = [ChartsUtil fitFontSize:8];
        _firstTextLayer.foregroundColor = [ChartsUtil C3].CGColor; _firstTextLayer.anchorPoint=CGPointMake(0, 0.5);
        _firstTextLayer.bounds = CGRectMake(0, 0, 40, ceil_half([ChartsUtil fitFont:8].lineHeight));
        _firstTextLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _firstTextLayer;
}
- (CATextLayer *)secondTextLayer{
    if (!_secondTextLayer) {
        _secondTextLayer = [[CATextLayer alloc] init];
        _secondTextLayer.fontSize = [ChartsUtil fitFontSize:8];
        _secondTextLayer.foregroundColor = [ChartsUtil C3].CGColor; _secondTextLayer.anchorPoint=CGPointMake(0.5, 0.5);
        _secondTextLayer.bounds = CGRectMake(0, 0, 40, ceil_half([ChartsUtil fitFont:8].lineHeight));
        _secondTextLayer.contentsScale = [UIScreen mainScreen].scale; _secondTextLayer.alignmentMode=kCAAlignmentCenter;
    }
    return _secondTextLayer;
}
- (CATextLayer *)thirdTextLayer{
    if (!_thirdTextLayer) {
        _thirdTextLayer = [[CATextLayer alloc] init];
        
        _thirdTextLayer.fontSize = [ChartsUtil fitFontSize:8];
        _thirdTextLayer.foregroundColor = [ChartsUtil C3].CGColor;
        _thirdTextLayer.anchorPoint=CGPointMake(0.5, 0.5);
        _thirdTextLayer.bounds = CGRectMake(0, 0, 40, ceil_half([ChartsUtil fitFont:8].lineHeight));
        _thirdTextLayer.contentsScale = [UIScreen mainScreen].scale; _thirdTextLayer.alignmentMode=kCAAlignmentCenter;
    }
    return _thirdTextLayer;
}
- (CATextLayer *)fourthTextLayer{
    if (!_fourthTextLayer) {
        _fourthTextLayer = [[CATextLayer alloc] init];
        _fourthTextLayer.fontSize = [ChartsUtil fitFontSize:8];
        _fourthTextLayer.foregroundColor = [ChartsUtil C3].CGColor; _fourthTextLayer.anchorPoint=CGPointMake(0.5, 0.5);
        _fourthTextLayer.alignmentMode=kCAAlignmentCenter;
        _fourthTextLayer.bounds = CGRectMake(0, 0, 40, ceil_half([ChartsUtil fitFont:8].lineHeight));
        _fourthTextLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _fourthTextLayer;
}

- (void)themeChangedAction{
    _dateBgLayer.backgroundColor = [GColorUtil C6].CGColor;
    _fourthTextLayer.foregroundColor = [ChartsUtil C3].CGColor;
    _thirdTextLayer.foregroundColor = [ChartsUtil C3].CGColor;
    _secondTextLayer.foregroundColor = [ChartsUtil C3].CGColor;
    _firstTextLayer.foregroundColor = [ChartsUtil C3].CGColor;
    _girlVLineLayer.strokeColor   = [ChartsUtil C7].CGColor;
}

- (void)addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
    [center addObserver:self
               selector:@selector(themeChangedAction)
                   name:ThemeDidChangedNotification
                 object:nil];
}

- (void)removeNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

@end

//
//  CFDKlineLayer.m
//  LiveTrade
//
//  Created by ngw15 on 2019/2/19.
//  Copyright © 2019 taojinzhe. All rights reserved.
//  蜡烛图绘制

#import "CFDKlineLayer.h"

@interface CFDKlineLayer ()

@property (nonatomic,strong)CAShapeLayer *kUpThinLayer;
@property (nonatomic,strong)CAShapeLayer *kUpThickLayer;
@property (nonatomic,strong)CAShapeLayer *kDownThinLayer;
@property (nonatomic,strong)CAShapeLayer *kDownThickLayer;

@end

@implementation CFDKlineLayer

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSublayer:self.kUpThinLayer];
        [self addSublayer:self.kUpThickLayer];
        [self addSublayer:self.kDownThinLayer];
        [self addSublayer:self.kDownThickLayer];
    }
    return self;
}

- (void)layoutSublayers{
    [super layoutSublayers];
    self.kUpThinLayer.frame=
    self.kUpThickLayer.frame=
    self.kDownThinLayer.frame=
    self.kDownThickLayer.frame=
    self.bounds;
    
}

- (void)configUpThinPath:(CGPathRef)upThinPath upThickPath:(CGPathRef)upThickPath downThinPath:(CGPathRef)downThinPath downThickPath:(CGPathRef)downThickPath{
    _kUpThinLayer.path = upThinPath;
    _kUpThickLayer.path = upThickPath;
    _kDownThinLayer.path = downThinPath;
    _kDownThickLayer.path = downThickPath;
    CGPathRelease(upThinPath);
    CGPathRelease(upThickPath);
    CGPathRelease(downThinPath);
    CGPathRelease(downThickPath);
}


//MARK: - Getter

- (void)setBarWidth:(CGFloat)barWidth{
    self.kUpThickLayer.lineWidth=
    self.kDownThickLayer.lineWidth = barWidth;
}

//细的线
- (CAShapeLayer *)kUpThinLayer{
    if (!_kUpThinLayer) {
        _kUpThinLayer = [[CAShapeLayer alloc] init];
        _kUpThinLayer.fillColor = [UIColor clearColor].CGColor;
        _kUpThinLayer.strokeColor   = [ChartsUtil C9].CGColor;      //设置划线颜色
        _kUpThinLayer.lineJoin = kCALineJoinRound;
        _kUpThinLayer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _kUpThinLayer;
}

//粗的先
- (CAShapeLayer *)kUpThickLayer{
    if (!_kUpThickLayer) {
        _kUpThickLayer = [[CAShapeLayer alloc] init];
        _kUpThickLayer.fillColor = [UIColor clearColor].CGColor;
        _kUpThickLayer.strokeColor   = [ChartsUtil C9].CGColor;      //设置划线颜色
        _kUpThickLayer.lineJoin = kCALineJoinRound;
        _kUpThickLayer.lineWidth     = [ChartsUtil fit:5];          //设置线宽
        _kUpThickLayer.contentsScale = [[UIScreen mainScreen] scale];
    }
    return _kUpThickLayer;
}

- (CAShapeLayer *)kDownThinLayer{
    if (!_kDownThinLayer) {
        _kDownThinLayer = [[CAShapeLayer alloc] init];
        _kDownThinLayer.fillColor = [UIColor clearColor].CGColor;
        _kDownThinLayer.strokeColor   = [ChartsUtil C10].CGColor;      //设置划线颜色
        _kDownThinLayer.lineJoin = kCALineJoinRound;
        _kDownThinLayer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _kDownThinLayer;
}

- (CAShapeLayer *)kDownThickLayer{
    if (!_kDownThickLayer) {
        _kDownThickLayer = [[CAShapeLayer alloc] init];
        _kDownThickLayer.fillColor = [UIColor clearColor].CGColor;
        _kDownThickLayer.strokeColor   = [ChartsUtil C10].CGColor;      //设置划线颜色
        _kDownThickLayer.lineJoin = kCALineJoinRound;
        _kDownThickLayer.lineWidth     = [ChartsUtil fit:5];          //设置线宽
        _kDownThickLayer.contentsScale = [[UIScreen mainScreen] scale];
    }
    return _kDownThickLayer;
}




@end

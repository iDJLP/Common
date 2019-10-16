//
//  PieRemarkView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/9/29.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "PieRemarkRow.h"

@interface PieRemarkRow ()

@property (nonatomic,strong)CAShapeLayer *lineLayer;
@property (nonatomic,strong)CATextLayer *titleLayer;

@end

@implementation PieRemarkRow

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor].CGColor;
        [self addSublayer:self.lineLayer];
        [self addSublayer:self.titleLayer];
    }
    return self;
}

- (void)configOfRow:(NSDictionary *)dict{

    _lineLayer.strokeColor = [GColorUtil colorWithHexString:[NDataUtil stringWith:dict[@"bgColor"]]].CGColor;
    _titleLayer.string = [NSString stringWithFormat:@"%@%%",[NDataUtil stringWith:dict[@"proportion"] valid:@""]];
    _titleLayer.bounds = CGRectMake(0, 0, [GUIUtil fit:40], [GUIUtil fitFont:12].lineHeight);
}

- (void)updatePosition:(CGFloat)centerAngle{
    CGPoint beginPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    CGFloat x = 0;
    _lineLayer.frame = CGRectMake(0, 0, self.width, self.height);
    if (centerAngle<M_PI_2) {
        beginPoint.x = cos(centerAngle)*_outerRadio+_centerPoint.x;
        beginPoint.y = sin(centerAngle)*_outerRadio+_centerPoint.y;
        endPoint.x = cos(centerAngle)*(_outerRadio+[GUIUtil fit:15])+_centerPoint.x;
        endPoint.y = sin(centerAngle)*(_outerRadio+[GUIUtil fit:15])+_centerPoint.y;
        
        x = endPoint.x+[GUIUtil fit:15];
        _titleLayer.anchorPoint = CGPointMake(0, 0.5);
        _titleLayer.position = CGPointMake(x+[GUIUtil fit:5], endPoint.y);
        _titleLayer.alignmentMode=kCAAlignmentLeft;
    }else if (centerAngle<M_PI){
        
        beginPoint.x = -cos(M_PI-centerAngle)*_outerRadio+_centerPoint.x;
               beginPoint.y = sin(M_PI-centerAngle)*_outerRadio+_centerPoint.y;
               endPoint.x = -cos(M_PI-centerAngle)*(_outerRadio+[GUIUtil fit:15])+_centerPoint.x;
               endPoint.y = sin(M_PI-centerAngle)*(_outerRadio+[GUIUtil fit:15])+_centerPoint.y;
        
        x = endPoint.x-[GUIUtil fit:15];
        _titleLayer.anchorPoint = CGPointMake(1, 0.5);
        _titleLayer.position = CGPointMake(x-[GUIUtil fit:5], endPoint.y);
        _titleLayer.alignmentMode=kCAAlignmentRight;

    }else if (centerAngle<M_PI_2*3){
        beginPoint.x = -cos(centerAngle-M_PI)*_outerRadio+_centerPoint.x;
        beginPoint.y = -sin(centerAngle-M_PI)*_outerRadio+_centerPoint.y;
        endPoint.x = -cos(centerAngle-M_PI)*(_outerRadio+[GUIUtil fit:15])+_centerPoint.x;
        endPoint.y = -sin(centerAngle-M_PI)*(_outerRadio+[GUIUtil fit:15])+_centerPoint.y;
        
        x = endPoint.x-[GUIUtil fit:15];
        _titleLayer.anchorPoint = CGPointMake(1, 0.5);
        _titleLayer.position = CGPointMake(x-[GUIUtil fit:5], endPoint.y);
        _titleLayer.alignmentMode=kCAAlignmentRight;
        
    }else if (centerAngle<M_PI*2){
        beginPoint.x = cos(M_PI*2-centerAngle)*_outerRadio+_centerPoint.x;
        beginPoint.y = -sin(M_PI*2-centerAngle)*_outerRadio+_centerPoint.y;
        endPoint.x = cos(M_PI*2-centerAngle)*(_outerRadio+[GUIUtil fit:15])+_centerPoint.x;
        endPoint.y = -sin(M_PI*2-centerAngle)*(_outerRadio+[GUIUtil fit:15])+_centerPoint.y;
        
        x = endPoint.x+[GUIUtil fit:15];
        _titleLayer.anchorPoint = CGPointMake(0, 0.5);
        _titleLayer.position = CGPointMake(x+[GUIUtil fit:5], endPoint.y);
        _titleLayer.alignmentMode=kCAAlignmentLeft;
        
    }
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, beginPoint.x, beginPoint.y);
    CGPathAddLineToPoint(path, NULL, endPoint.x, endPoint.y);
    CGPathAddLineToPoint(path, NULL, x, endPoint.y);
    _lineLayer.path = path;
    CGPathRelease(path);
}

- (CAShapeLayer *)lineLayer{
    if (!_lineLayer) {
        _lineLayer = [[CAShapeLayer alloc] init];
        _lineLayer.fillColor = [UIColor clearColor].CGColor;
    }
    return _lineLayer;
}

- (CATextLayer *)titleLayer{
    if (!_titleLayer) {
        _titleLayer = [[CATextLayer alloc] init];
        _titleLayer.foregroundColor = [GColorUtil colorWithWhiteColorType:C2_ColorType].CGColor;
        _titleLayer.fontSize = [ChartsUtil fitFontSize:12];
        _titleLayer.contentsScale = [UIScreen mainScreen].scale;
    }
    return _titleLayer;
}

@end

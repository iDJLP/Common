//
//  CFDIndexMALayer.m
//  LiveTrade
//
//  Created by ngw15 on 2019/2/19.
//  Copyright © 2019 taojinzhe. All rights reserved.
//  MACD绘制及计算

#import "CFDIndexMACDLayer.h"

@interface CFDIndexMACDLayer ()

@property (nonatomic,strong)CAShapeLayer *indexBarUpLayer;
@property (nonatomic,strong)CAShapeLayer *indexBarDownLayer;
@property (nonatomic,strong)CAShapeLayer *indexDifLayer;
@property (nonatomic,strong)CAShapeLayer *indexDeaLayer;

@end

@implementation CFDIndexMACDLayer

- (instancetype)init{
    if (self = [super init]) {
        [self addSublayer:self.indexBarUpLayer];
        [self addSublayer:self.indexBarDownLayer];
        [self addSublayer:self.indexDifLayer];
        [self addSublayer:self.indexDeaLayer];
    }
    return self;
}

- (void)layoutSublayers{
    [super layoutSublayers];
    self.indexBarUpLayer.frame =
    self.indexBarDownLayer.frame =
    self.indexDifLayer.frame=
    self.indexDeaLayer.frame=
    self.bounds;
}

- (void)drawIndexMACD:(NSArray <CFDKLineData *>*)dataList{
    CGMutablePathRef difPath = CGPathCreateMutable();
    CGMutablePathRef deaPath = CGPathCreateMutable();
    CGMutablePathRef barUpPath = CGPathCreateMutable();
    CGMutablePathRef barDownPath = CGPathCreateMutable();
    __block CGFloat x = 0.f;
    CGFloat pointWidth= self.pointWidth();
    __block BOOL isDeaStart = NO;
    __block BOOL isDifStart = NO;
    
    __block CGFloat maxDea = CGFLOAT_MIN;
    __block CGFloat minDea = CGFLOAT_MAX;
    //最大值，最小值
    [dataList enumerateObjectsUsingBlock:^(CFDKLineData *cell, NSUInteger i, BOOL * _Nonnull stop) {
        NSDictionary *kMACDDic = cell.MACDDic;
        if (kMACDDic) {
            CGFloat dea = [kMACDDic[@"dea"] floatValue];
            CGFloat dif = [kMACDDic[@"dif"] floatValue];
            CGFloat bar = [kMACDDic[@"bar"] floatValue];
            maxDea = MAX(maxDea, MAX(MAX(dea, dif),bar));
            minDea = MIN(minDea, MIN(MIN(dea, dif),bar));
        }
    }];
    if (ABS(minDea)>maxDea) {
        maxDea = ABS(minDea);
    }else{
        minDea = -maxDea;
    }
    if (minDea==maxDea||maxDea==0||minDea==0) {
        return;
    }
    //绘制分时线与成交量
    [dataList enumerateObjectsUsingBlock:^(CFDKLineData * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *kMACDDic = cell.MACDDic;
        if (kMACDDic==nil) {
            return ;
        }
        CGFloat dea = [kMACDDic[@"dea"] floatValue];
        CGFloat dif = [kMACDDic[@"dif"] floatValue];
        CGFloat bar = [kMACDDic[@"bar"] floatValue];
        x = idx*pointWidth;
        
        dea = (dea-minDea)/(maxDea-minDea);
        dif = (dif-minDea)/(maxDea-minDea);
        if (bar>0) {
            bar= (bar)/(maxDea);
        }else{
            bar=-bar/minDea;
        }
        dea = MAX(0, MIN(1, dea));
        dif = MAX(0, MIN(1, dif));
        
        CGFloat dea_y= (1-dea)*(self.height-1)+(self.frame.size.height-self.height);
        CGFloat dif_y= (1-dif)*(self.height-1)+(self.frame.size.height-self.height);
        CGFloat bar_y= (1-bar)*self.height/2+(self.frame.size.height-self.height);
        
        if([NDataUtil IsInfOrNan:x] ||
           [NDataUtil IsInfOrNan:dea]||
           [NDataUtil IsInfOrNan:dif]||
           [NDataUtil IsInfOrNan:bar])
        {
            return;
        }
        //分时的点
        if (isDeaStart==NO) {
            isDeaStart = YES;
            CGPathMoveToPoint(deaPath, NULL, x, dea_y);
        }else{
            CGPathAddLineToPoint(deaPath, NULL, x,dea_y);
        }
        if (isDifStart==NO) {
            isDifStart = YES;
            CGPathMoveToPoint(difPath, NULL, x, dif_y);
        }else{
            CGPathAddLineToPoint(difPath, NULL, x,dif_y);
        }
        if (bar>0) {
            CGPathMoveToPoint(barUpPath, NULL, x, bar_y);
            CGPathAddLineToPoint(barUpPath, NULL, x, self.height/2+(self.frame.size.height-self.height));
        }else if(bar<0){
            CGPathMoveToPoint(barDownPath, NULL, x, self.height/2+(self.frame.size.height-self.height));
            CGPathAddLineToPoint(barDownPath, NULL, x, bar_y);
        }
    }];
    
   
        WEAK_SELF;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dataList count] >1)
            {
                weakSelf.indexDeaLayer.path = deaPath;
                weakSelf.indexDifLayer.path = difPath;
                weakSelf.indexBarUpLayer.path = barUpPath;
                weakSelf.indexBarDownLayer.path = barDownPath;
                if (weakSelf.bottomAxisHander) {
                    NSDictionary *axisDic = @{@"left1":[NSString stringWithFormat:@"%.2f",maxDea],@"left2":[NSString stringWithFormat:@"%.2f",minDea]};
                    weakSelf.bottomAxisHander(axisDic);
                }
            }else{
                weakSelf.indexDeaLayer.path = nil;
                weakSelf.indexDifLayer.path = nil;
                weakSelf.indexBarUpLayer.path = nil;
                weakSelf.indexBarDownLayer.path = nil;
            }
            CGPathRelease(deaPath);
            CGPathRelease(difPath);
            CGPathRelease(barUpPath);
            CGPathRelease(barDownPath);
        });
    
}

//MARK: - Getter

- (void)setBarWidth:(CGFloat)barWidth{
    self.indexBarUpLayer.lineWidth=
    self.indexBarDownLayer.lineWidth = barWidth;
}

- (CAShapeLayer *)indexBarUpLayer{
    if (!_indexBarUpLayer) {
        _indexBarUpLayer = [[CAShapeLayer alloc] init];
        
        _indexBarUpLayer.fillColor = [UIColor clearColor].CGColor;
        _indexBarUpLayer.strokeColor   = [ChartsUtil C9].CGColor;      //设置划线颜色
        _indexBarUpLayer.lineJoin = kCALineJoinRound;
        _indexBarUpLayer.lineWidth     = [ChartsUtil fit:5];          //设置线宽
    }
    return _indexBarUpLayer;
}

- (CAShapeLayer *)indexBarDownLayer{
    if (!_indexBarDownLayer) {
        _indexBarDownLayer = [[CAShapeLayer alloc] init];
        
        _indexBarDownLayer.fillColor = [UIColor clearColor].CGColor;
        _indexBarDownLayer.strokeColor   = [ChartsUtil C10].CGColor;      //设置划线颜色
        _indexBarDownLayer.lineJoin = kCALineJoinRound;
        _indexBarDownLayer.lineWidth     = [ChartsUtil fit:5];          //设置线宽
    }
    return _indexBarDownLayer;
}

- (CAShapeLayer *)indexDifLayer{
    if (!_indexDifLayer) {
        _indexDifLayer = [[CAShapeLayer alloc] init];
        _indexDifLayer.fillColor = [UIColor clearColor].CGColor;
        _indexDifLayer.strokeColor   = [ChartsUtil C13].CGColor;      //设置划线颜色
        _indexDifLayer.lineCap = @"round";
        _indexDifLayer.lineJoin = kCALineJoinRound;
        _indexDifLayer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
        
    }
    return _indexDifLayer;
}
- (CAShapeLayer *)indexDeaLayer{
    if (!_indexDeaLayer) {
        _indexDeaLayer = [[CAShapeLayer alloc] init];
        _indexDeaLayer.fillColor = [UIColor clearColor].CGColor;
        _indexDeaLayer.strokeColor   = [ChartsUtil C1100].CGColor;      //设置划线颜色
        _indexDeaLayer.lineCap = @"round";
        _indexDeaLayer.lineJoin = kCALineJoinRound;
        _indexDeaLayer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexDeaLayer;
}


@end

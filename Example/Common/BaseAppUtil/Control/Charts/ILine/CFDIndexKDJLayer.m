//
//  CFDIndexMALayer.m
//  LiveTrade
//
//  Created by ngw15 on 2019/2/19.
//  Copyright © 2019 taojinzhe. All rights reserved.
//  KDJ绘制及计算

#import "CFDIndexKDJLayer.h"

@interface CFDIndexKDJLayer ()

@property (nonatomic,strong)CAShapeLayer *indexKLayer;
@property (nonatomic,strong)CAShapeLayer *indexDLayer;
@property (nonatomic,strong)CAShapeLayer *indexJLayer;

@end

@implementation CFDIndexKDJLayer

- (instancetype)init{
    if (self = [super init]) {
        [self addSublayer:self.indexKLayer];
        [self addSublayer:self.indexDLayer];
        [self addSublayer:self.indexJLayer];
    }
    return self;
}

- (void)layoutSublayers{
    [super layoutSublayers];
    self.indexKLayer.frame =
    self.indexDLayer.frame =
    self.indexJLayer.frame =
    self.bounds;
}

- (void)drawIndexKDJ:(NSArray <CFDKLineData *>*)dataList{
    CGMutablePathRef kPath = CGPathCreateMutable();
    CGMutablePathRef dPath = CGPathCreateMutable();
    CGMutablePathRef jPath = CGPathCreateMutable();
    
    CGFloat pointWidth= self.pointWidth();
    __block CGFloat x = 0.f;
    __block BOOL isStart = NO;
    __block CGFloat max = CGFLOAT_MIN;
    __block CGFloat min = CGFLOAT_MAX;
    //最大值，最小值
    [dataList enumerateObjectsUsingBlock:^(CFDKLineData *cell, NSUInteger i, BOOL * _Nonnull stop) {
        NSDictionary *KDJDic = cell.KDJDic;
        if (KDJDic) {
            CGFloat k = [KDJDic[@"k"] floatValue];
            CGFloat d = [KDJDic[@"d"] floatValue];
            CGFloat j = [KDJDic[@"j"] floatValue];
            max = MAX(max, MAX(MAX(k, d),j));
            min = MIN(min, MIN(MIN(k, d),j));
        }
    }];
    if (min==max||
        [NDataUtil IsInfOrNan:min]||
        [NDataUtil IsInfOrNan:max]) {
        return;
    }
    
    [dataList enumerateObjectsUsingBlock:^(CFDKLineData * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *KDJDic = cell.KDJDic;
        if (KDJDic==nil) {
            return ;
        }
        CGFloat k = [KDJDic[@"k"] floatValue];
        CGFloat d = [KDJDic[@"d"] floatValue];
        CGFloat j = [KDJDic[@"j"] floatValue];
        x = idx*pointWidth;
        
        CGFloat k_y= (1-(k-min)/(max-min))*(self.height-1)+(self.frame.size.height-self.height);
        CGFloat d_y= (1-(d-min)/(max-min))*(self.height-1)+(self.frame.size.height-self.height);
        CGFloat j_y= (1-(j-min)/(max-min))*(self.height-1)+(self.frame.size.height-self.height);
        
        if([NDataUtil IsInfOrNan:x] ||
           [NDataUtil IsInfOrNan:k]||
           [NDataUtil IsInfOrNan:d]||
           [NDataUtil IsInfOrNan:j])
        {
            return;
        }
        //分时的点
        if (isStart==NO) {
            isStart = YES;
            CGPathMoveToPoint(kPath, NULL, x, k_y);
            CGPathMoveToPoint(dPath, NULL, x, d_y);
            CGPathMoveToPoint(jPath, NULL, x, j_y);
        }else{
            CGPathAddLineToPoint(kPath, NULL, x,k_y);
            CGPathAddLineToPoint(dPath, NULL, x, d_y);
            CGPathAddLineToPoint(jPath, NULL, x, j_y);
        }
    }];
    
    
        WEAK_SELF;
        dispatch_async(dispatch_get_main_queue(), ^{
            if ([dataList count] >1)
            {
                weakSelf.indexKLayer.path = kPath;
                weakSelf.indexDLayer.path = dPath;
                weakSelf.indexJLayer.path = jPath;
                if (weakSelf.bottomAxisHander) {
                    NSDictionary *axisDic = @{@"left1":[NSString stringWithFormat:@"%.3f",max],@"left2":[NSString stringWithFormat:@"%.3f",min]};
                    weakSelf.bottomAxisHander(axisDic);
                }
            }else{
                weakSelf.indexKLayer.path = nil;
                weakSelf.indexDLayer.path = nil;
                weakSelf.indexJLayer.path = nil;
            }
            CGPathRelease(kPath);
            CGPathRelease(dPath);
            CGPathRelease(jPath);
        });
    
}

//MARK: - Getter

- (CAShapeLayer *)indexKLayer{
    if (!_indexKLayer) {
        _indexKLayer = [[CAShapeLayer alloc] init];
        _indexKLayer.fillColor = [UIColor clearColor].CGColor;
        _indexKLayer.strokeColor   = [ChartsUtil C20].CGColor;      //设置划线颜色
        _indexKLayer.lineCap = @"round";
        _indexKLayer.lineJoin = kCALineJoinRound;
        _indexKLayer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexKLayer;
}
- (CAShapeLayer *)indexDLayer{
    if (!_indexDLayer) {
        _indexDLayer = [[CAShapeLayer alloc] init];
        _indexDLayer.fillColor = [UIColor clearColor].CGColor;
        _indexDLayer.strokeColor   = [ChartsUtil C13].CGColor;      //设置划线颜色
        _indexDLayer.lineCap = @"round";
        _indexDLayer.lineJoin = kCALineJoinRound;
        _indexDLayer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexDLayer;
}
- (CAShapeLayer *)indexJLayer{
    if (!_indexJLayer) {
        _indexJLayer = [[CAShapeLayer alloc] init];
        _indexJLayer.fillColor = [UIColor clearColor].CGColor;
        _indexJLayer.strokeColor   = [ChartsUtil C1100].CGColor;      //设置划线颜色
        _indexJLayer.lineCap = @"round";
        _indexJLayer.lineJoin = kCALineJoinRound;
        _indexJLayer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexJLayer;
}

@end

//
//  CFDIndexBIASLayer.m
//  Chart
//
//  Created by ngw15 on 2019/2/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
// BIAS绘制及计算

#import "CFDIndexBIASLayer.h"

@interface CFDIndexBIASLayer ()

@property (nonatomic,strong)CAShapeLayer *indexBIAS1Layer;
@property (nonatomic,strong)CAShapeLayer *indexBIAS2Layer;
@property (nonatomic,strong)CAShapeLayer *indexBIAS3Layer;

@end

@implementation CFDIndexBIASLayer

- (instancetype)init{
    if (self = [super init]) {
        [self addSublayer:self.indexBIAS1Layer];
        [self addSublayer:self.indexBIAS2Layer];
        [self addSublayer:self.indexBIAS3Layer];
    }
    return self;
}

- (void)layoutSublayers{
    [super layoutSublayers];
    self.indexBIAS1Layer.frame =
    self.indexBIAS2Layer.frame =
    self.indexBIAS3Layer.frame =
    self.bounds;
}

- (void)drawIndexBIAS:(NSArray <CFDKLineData *>*)dataList{
    CGMutablePathRef BIAS1Layer = CGPathCreateMutable();
    CGMutablePathRef BIAS2Layer = CGPathCreateMutable();
    CGMutablePathRef BIAS3Layer = CGPathCreateMutable();
    
    CGFloat pointWidth= self.pointWidth();
    __block CGFloat x = 0.f;
    __block BOOL isStart = NO;
    __block CGFloat max = CGFLOAT_MIN;
    __block CGFloat min = CGFLOAT_MAX;
    //最大值，最小值
    [dataList enumerateObjectsUsingBlock:^(CFDKLineData *cell, NSUInteger i, BOOL * _Nonnull stop) {
        NSDictionary *BIASDic = cell.BIASDic;
        if (BIASDic) {
            CGFloat bias1 = [BIASDic[@"bias1"] floatValue];
            CGFloat bias2 = [BIASDic[@"bias2"] floatValue];
            CGFloat bias3 = [BIASDic[@"bias3"] floatValue];
            max = MAX(max, MAX(MAX(bias1, bias2),bias3));
            min = MIN(min, MIN(MIN(bias1, bias2),bias3));
        }
    }];
    if (min==max||
        [NDataUtil IsInfOrNan:min]||
        [NDataUtil IsInfOrNan:max]) {
        return;
    }
    
    [dataList enumerateObjectsUsingBlock:^(CFDKLineData * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *BIASDic = cell.BIASDic;
        if (BIASDic==nil) {
            return ;
        }
        CGFloat bias1 = [BIASDic[@"bias1"] floatValue];
        CGFloat bias2 = [BIASDic[@"bias2"] floatValue];
        CGFloat bias3 = [BIASDic[@"bias3"] floatValue];
        x = idx*pointWidth;
        
        CGFloat k_y= (1-(bias1-min)/(max-min))*(self.height-1)+(self.frame.size.height-self.height);
        CGFloat d_y= (1-(bias2-min)/(max-min))*(self.height-1)+(self.frame.size.height-self.height);
        CGFloat j_y= (1-(bias3-min)/(max-min))*(self.height-1)+(self.frame.size.height-self.height);
        
        if([NDataUtil IsInfOrNan:x] ||
           [NDataUtil IsInfOrNan:bias1]||
           [NDataUtil IsInfOrNan:bias2]||
           [NDataUtil IsInfOrNan:bias3])
        {
            return;
        }
        //分时的点
        if (isStart==NO) {
            isStart = YES;
            CGPathMoveToPoint(BIAS1Layer, NULL, x, k_y);
            CGPathMoveToPoint(BIAS2Layer, NULL, x, d_y);
            CGPathMoveToPoint(BIAS3Layer, NULL, x, j_y);
        }else{
            CGPathAddLineToPoint(BIAS1Layer, NULL, x,k_y);
            CGPathAddLineToPoint(BIAS2Layer, NULL, x, d_y);
            CGPathAddLineToPoint(BIAS3Layer, NULL, x, j_y);
        }
    }];
    WEAK_SELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if ([dataList count] >1)
        {
            weakSelf.indexBIAS1Layer.path = BIAS1Layer;
            weakSelf.indexBIAS2Layer.path = BIAS2Layer;
            weakSelf.indexBIAS3Layer.path = BIAS3Layer;
            if (weakSelf.bottomAxisHander) {
                NSDictionary *axisDic = @{@"left1":[NSString stringWithFormat:@"%.3f",max],@"left2":[NSString stringWithFormat:@"%.3f",min]};
                weakSelf.bottomAxisHander(axisDic);
            }
        }else{
            weakSelf.indexBIAS1Layer.path = nil;
            weakSelf.indexBIAS2Layer.path = nil;
            weakSelf.indexBIAS3Layer.path = nil;
        }
        CGPathRelease(BIAS1Layer);
        CGPathRelease(BIAS2Layer);
        CGPathRelease(BIAS3Layer);
    });
    
}

//MARK: - Getter

- (CAShapeLayer *)indexBIAS1Layer{
    if (!_indexBIAS1Layer) {
        _indexBIAS1Layer = [[CAShapeLayer alloc] init];
        _indexBIAS1Layer.fillColor = [UIColor clearColor].CGColor;
        _indexBIAS1Layer.strokeColor   = [ChartsUtil C20].CGColor;      //设置划线颜色
        _indexBIAS1Layer.lineCap = @"round";
        _indexBIAS1Layer.lineJoin = kCALineJoinRound;
        _indexBIAS1Layer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexBIAS1Layer;
}
- (CAShapeLayer *)indexBIAS2Layer{
    if (!_indexBIAS2Layer) {
        _indexBIAS2Layer = [[CAShapeLayer alloc] init];
        _indexBIAS2Layer.fillColor = [UIColor clearColor].CGColor;
        _indexBIAS2Layer.strokeColor   = [ChartsUtil C13].CGColor;      //设置划线颜色
        _indexBIAS2Layer.lineCap = @"round";
        _indexBIAS2Layer.lineJoin = kCALineJoinRound;
        _indexBIAS2Layer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexBIAS2Layer;
}
- (CAShapeLayer *)indexBIAS3Layer{
    if (!_indexBIAS3Layer) {
        _indexBIAS3Layer = [[CAShapeLayer alloc] init];
        _indexBIAS3Layer.fillColor = [UIColor clearColor].CGColor;
        _indexBIAS3Layer.strokeColor   = [ChartsUtil C1100].CGColor;      //设置划线颜色
        _indexBIAS3Layer.lineCap = @"round";
        _indexBIAS3Layer.lineJoin = kCALineJoinRound;
        _indexBIAS3Layer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexBIAS3Layer;
}

@end


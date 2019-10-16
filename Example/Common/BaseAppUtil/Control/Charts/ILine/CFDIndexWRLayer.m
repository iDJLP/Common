//
//  CFDIndexWRLayer.m
//  Chart
//
//  Created by ngw15 on 2019/2/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//  WR指标的绘制

#import "CFDIndexWRLayer.h"

@interface CFDIndexWRLayer ()

@property (nonatomic,strong)CAShapeLayer *indexWR1Layer;
@property (nonatomic,strong)CAShapeLayer *indexWR2Layer;

@end

@implementation CFDIndexWRLayer

- (instancetype)init{
    if (self = [super init]) {
        [self addSublayer:self.indexWR1Layer];
        [self addSublayer:self.indexWR2Layer];
    }
    return self;
}

- (void)layoutSublayers{
    [super layoutSublayers];
    self.indexWR1Layer.frame =
    self.indexWR2Layer.frame =
    self.bounds;
}

- (void)drawIndexWR:(NSArray <CFDKLineData *>*)dataList{
    
    CGMutablePathRef wr1Path = CGPathCreateMutable();
    CGMutablePathRef wr2Path = CGPathCreateMutable();
    
    CGFloat pointWidth= self.pointWidth();
    __block CGFloat x = 0.f;
    __block BOOL isStart = NO;
    CGFloat max = 100.0;
    CGFloat min = 0.0;
    [dataList enumerateObjectsUsingBlock:^(CFDKLineData * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *WRDic = cell.WRDic;
        if (WRDic==nil) {
            return ;
        }
        CGFloat wr1 = [WRDic[@"wr1"] floatValue];
        CGFloat wr2 = [WRDic[@"wr2"] floatValue];
        x = idx*pointWidth;
        
        CGFloat wr1_y= (1-(wr1-min)/(max-min))*(self.height-1)+(self.frame.size.height-self.height);
        CGFloat wr2_y= (1-(wr2-min)/(max-min))*(self.height-1)+(self.frame.size.height-self.height);
        
        if([NDataUtil IsInfOrNan:x] ||
           [NDataUtil IsInfOrNan:wr1]||
           [NDataUtil IsInfOrNan:wr2])
        {
            return;
        }
        //分时的点
        if (isStart==NO) {
            isStart = YES;
            CGPathMoveToPoint(wr1Path, NULL, x, wr1_y);
            CGPathMoveToPoint(wr2Path, NULL, x, wr2_y);
        }else{
            CGPathAddLineToPoint(wr1Path, NULL, x,wr1_y);
            CGPathAddLineToPoint(wr2Path, NULL, x, wr2_y);
        }
    }];
    WEAK_SELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([dataList count] >1)
        {
            weakSelf.indexWR1Layer.path = wr1Path;
            weakSelf.indexWR2Layer.path = wr2Path;
            if (weakSelf.bottomAxisHander) {
                NSDictionary *axisDic = @{@"left1":@"100",@"left2":@"0"};
                weakSelf.bottomAxisHander(axisDic);
            }
        }else{
            weakSelf.indexWR1Layer.path = nil;
            weakSelf.indexWR2Layer.path = nil;
        }
        CGPathRelease(wr1Path);
        CGPathRelease(wr2Path);
    }); 
}


//MARK: - Getter

- (CAShapeLayer *)indexWR1Layer{
    if (!_indexWR1Layer) {
        _indexWR1Layer = [[CAShapeLayer alloc] init];
        _indexWR1Layer.fillColor = [UIColor clearColor].CGColor;
        _indexWR1Layer.strokeColor   = [ChartsUtil C1100].CGColor;      //设置划线颜色
        _indexWR1Layer.lineCap = @"round";
        _indexWR1Layer.lineJoin = kCALineJoinRound;
        _indexWR1Layer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexWR1Layer;
}
- (CAShapeLayer *)indexWR2Layer{
    if (!_indexWR2Layer) {
        _indexWR2Layer = [[CAShapeLayer alloc] init];
        _indexWR2Layer.fillColor = [UIColor clearColor].CGColor;
        _indexWR2Layer.strokeColor   = [ChartsUtil C13].CGColor;      //设置划线颜色
        _indexWR2Layer.lineCap = @"round";
        _indexWR2Layer.lineJoin = kCALineJoinRound;
        _indexWR2Layer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexWR2Layer;
}


@end


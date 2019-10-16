//
//  CFDIndexCCILayer.m
//  Chart
//
//  Created by ngw15 on 2019/2/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "CFDIndexCCILayer.h"

@interface CFDIndexCCILayer ()

@property (nonatomic,strong)CAShapeLayer *indexCCILayer;


@end

@implementation CFDIndexCCILayer

- (instancetype)init{
    if (self = [super init]) {
        [self addSublayer:self.indexCCILayer];
    }
    return self;
}

- (void)layoutSublayers{
    [super layoutSublayers];
    self.indexCCILayer.frame =
    self.bounds;
}

- (void)drawIndexCCI:(NSArray <CFDKLineData *>*)dataList{
    
    CGMutablePathRef cciPath = CGPathCreateMutable();
    
    CGFloat pointWidth= self.pointWidth();
    __block CGFloat x = 0.f;
    __block BOOL isStart = NO;
  
    __block CGFloat max = CGFLOAT_MIN;
    __block CGFloat min = CGFLOAT_MAX;
    //最大值，最小值
    [dataList enumerateObjectsUsingBlock:^(CFDKLineData *cell, NSUInteger i, BOOL * _Nonnull stop) {
        NSDictionary *CCiDic = cell.CCiDic;
        if (CCiDic==nil) {
            return ;
        }
        CGFloat cci = [CCiDic[@"cci"] floatValue];
        max = MAX(max, cci);
        min = MIN(min, cci);
    }];
    if (min==max||
        [NDataUtil IsInfOrNan:min]||
        [NDataUtil IsInfOrNan:max]) {
        return;
    }
    
    [dataList enumerateObjectsUsingBlock:^(CFDKLineData * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *CCiDic = cell.CCiDic;
        if (CCiDic==nil) {
            return ;
        }
        CGFloat cci = [CCiDic[@"cci"] floatValue];
        
        x = idx*pointWidth;
        CGFloat cci_y= (1-(cci-min)/(max-min))*(self.height-1)+(self.frame.size.height-self.height);
        
        if([NDataUtil IsInfOrNan:x] ||
           [NDataUtil IsInfOrNan:cci])
        {
            return;
        }
        //分时的点
        if (isStart==NO) {
            isStart = YES;
            CGPathMoveToPoint(cciPath, NULL, x, cci_y);
            
        }else{
            CGPathAddLineToPoint(cciPath, NULL, x,cci_y);
        }
    }];
    WEAK_SELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([dataList count] >1)
        {
            weakSelf.indexCCILayer.path = cciPath;
            if (weakSelf.bottomAxisHander) {
                NSDictionary *axisDic = @{@"left1":[NSString stringWithFormat:@"%.3f",max],@"left2":[NSString stringWithFormat:@"%.3f",min]};
                weakSelf.bottomAxisHander(axisDic);
            }
        }else{
            weakSelf.indexCCILayer.path = nil;
        }
        CGPathRelease(cciPath);
    });
    
}


//MARK: - Getter

- (CAShapeLayer *)indexCCILayer{
    if (!_indexCCILayer) {
        _indexCCILayer = [[CAShapeLayer alloc] init];
        _indexCCILayer.fillColor = [UIColor clearColor].CGColor;
        _indexCCILayer.strokeColor   = [ChartsUtil C1100].CGColor;      //设置划线颜色
        _indexCCILayer.lineCap = @"round";
        _indexCCILayer.lineJoin = kCALineJoinRound;
        _indexCCILayer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexCCILayer;
}


@end



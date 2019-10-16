//
//  CFDIndexMALayer.m
//  LiveTrade
//
//  Created by ngw15 on 2019/2/19.
//  Copyright © 2019 taojinzhe. All rights reserved.
//  成交量绘制及计算

#import "CFDIndexVOLLayer.h"

@interface CFDIndexVOLLayer ()

@property (nonatomic,strong)CAShapeLayer *volUpLayer;
@property (nonatomic,strong)CAShapeLayer *volDownLayer;

@end

@implementation CFDIndexVOLLayer

- (instancetype)init{
    if (self = [super init]) {
        [self addSublayer:self.volUpLayer];
        [self addSublayer:self.volDownLayer];
    }
    return self;
}

- (void)layoutSublayers{
    [super layoutSublayers];
    self.volUpLayer.frame =
    self.volDownLayer.frame =
    self.bounds;
}

//量线的绘制
- (void)drawVolLine:(NSArray *)dataList{
    // 量线
    CGMutablePathRef volUpPath = CGPathCreateMutable();
    CGMutablePathRef volDownPath = CGPathCreateMutable();
    CGFloat pointWidth= self.pointWidth();
    __block NSInteger maxVol = 0;
    [dataList enumerateObjectsUsingBlock:^(CFDKLineData *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSInteger vol = [NDataUtil integerWith:obj.volDic[@"vol"] valid:0];
        maxVol=MAX(maxVol, vol);
    }];
    if (maxVol<=0) {
        return;
    }
    //绘制成交量
    [dataList enumerateObjectsUsingBlock:^(CFDKLineData *cell, NSUInteger i, BOOL * _Nonnull stop) {
        NSInteger vol = [NDataUtil integerWith:cell.volDic[@"vol"] valid:0];
        CGFloat x = (i)*pointWidth;
        //量线top
        CGFloat top = (self.height-2)*(1-vol*1.0/maxVol);
        CGMutablePathRef path = cell.isRed?volUpPath:volDownPath;
        if(![NDataUtil IsInfOrNan:x] &&
           ![NDataUtil IsInfOrNan:top] &&
           ![NDataUtil IsInfOrNan:self.height])
        {
            CGPathMoveToPoint(path, NULL, x, top);
            CGPathAddLineToPoint(path, NULL, x, self.height);
        }
    }];
    WEAK_SELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        CGFloat lineWidth = MIN(self.pointWidth()-[ChartsUtil fitLine]*2, [ChartsUtil fit:5]);
        if (lineWidth<[ChartsUtil fitLine]) {
            lineWidth =[ChartsUtil fitLine];
        }
        weakSelf.volUpLayer.lineWidth =
        weakSelf.volDownLayer.lineWidth = lineWidth;
        weakSelf.volUpLayer.path= volUpPath;
        weakSelf.volDownLayer.path = volDownPath;
        CGPathRelease(volUpPath);
        CGPathRelease(volDownPath);
        [weakSelf showMaxVol:maxVol];
    });
}

- (void)showMaxVol:(NSInteger)maxVol{
    //最大成交量
    NSInteger numCount = 0;
    NSString *volDanWei = @"";
    if (maxVol > 100000000)//yi
    {
        volDanWei = CFDLocalizedString(@"亿手");//亿手
        numCount = 100000000.00;
    }
    else if (maxVol > 10000)//wan
    {
        volDanWei = CFDLocalizedString(@"万手");//万手
        numCount = 10000.00;
    }
    else//shou
    {
        volDanWei = CFDLocalizedString(@"手");//手
        numCount =1.00;
    }
    NSString *amount = [NSString stringWithFormat:@"%.2f",maxVol*1.0/numCount];
    
    if (_bottomAxisHander) {
        NSDictionary *axisDic = @{@"left1":amount,@"left2":[NSString stringWithFormat:@"0（%@）",volDanWei]};
        _bottomAxisHander(axisDic);
    }
}

//MARK: - Getter

- (CAShapeLayer *)volDownLayer{
    if (!_volDownLayer) {
        _volDownLayer = [[CAShapeLayer alloc] init];

        _volDownLayer.strokeColor   = [ChartsUtil C12].CGColor;      //设置划线颜色
    }
    return _volDownLayer;
}

- (CAShapeLayer *)volUpLayer{
    if (!_volUpLayer) {
        _volUpLayer = [[CAShapeLayer alloc] init];

        _volUpLayer.strokeColor   = [ChartsUtil C11].CGColor;      //设置划线颜色
    }
    return _volUpLayer;
}


@end

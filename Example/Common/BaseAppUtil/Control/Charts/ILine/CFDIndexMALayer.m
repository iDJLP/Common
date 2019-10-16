//
//  CFDIndexMALayer.m
//  LiveTrade
//
//  Created by ngw15 on 2019/2/19.
//  Copyright © 2019 taojinzhe. All rights reserved.
//  MA均线绘制及计算

#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]

#import "CFDIndexMALayer.h"

@interface CFDIndexMALayer ()

@property (nonatomic,strong)CAShapeLayer *indexMA5Layer;
@property (nonatomic,strong)CAShapeLayer *indexMA10Layer;
@property (nonatomic,strong)CAShapeLayer *indexMA30Layer;

@end

@implementation CFDIndexMALayer

- (instancetype)init{
    if (self = [super init]) {
        self.masksToBounds = YES;
        [self addSublayer:self.indexMA30Layer];
        [self addSublayer:self.indexMA10Layer];
        [self addSublayer:self.indexMA5Layer]; 
    }
    return self;
}

- (void)layoutSublayers{
    [super layoutSublayers];
    self.indexMA5Layer.width =
    self.indexMA10Layer.width =
    self.indexMA30Layer.width = self.width;
    
    self.indexMA5Layer.height =
    self.indexMA10Layer.height =
    self.indexMA30Layer.height = self.height;
    
    self.indexMA5Layer.top =
    self.indexMA10Layer.top =
    self.indexMA30Layer.top = 0;
    
    self.indexMA5Layer.left =
    self.indexMA10Layer.left =
    self.indexMA30Layer.left = 0;
}

//均线的绘制
- (void)drawMA:(NSArray *)dataList maxPirce:(NSString *)maxPrice minPrice:(NSString *)minPrice{
    
    CGFloat dif = ([maxPrice floatValue]-[minPrice floatValue]);
    CGFloat min = minPrice.floatValue;
    __block CGFloat x = 0.f;
    __block BOOL hasStart_5 = NO;
    __block BOOL hasStart_10 = NO;
    __block BOOL hasStart_30 = NO;
    CGFloat pointWidth= self.pointWidth();
 
    NSMutableArray *points_5 = [NSMutableArray array];
    NSMutableArray *points_10 = [NSMutableArray array];
    NSMutableArray *points_30 = [NSMutableArray array];
    
    //绘制分时线与成交量
    [dataList enumerateObjectsUsingBlock:^(CFDKLineData *cell, NSUInteger i, BOOL * _Nonnull stop) {
        NSDictionary *kMADic = cell.MADic;
        if (kMADic!=nil) {
            CGFloat MA5 = [kMADic[@"MA5"] floatValue];
            CGFloat MA10 = [kMADic[@"MA10"] floatValue];
            CGFloat MA30 = [kMADic[@"MA30"] floatValue];
            x = i*pointWidth;
            //平均线
            CGFloat rate_5 = (MA5-min)/dif;
            CGFloat rate_10 = (MA10-min)/dif;
            CGFloat rate_30 = (MA30-min)/dif;
    
            CGFloat MA5_y= (1-rate_5)*self.height;
            CGFloat MA10_y= (1-rate_10)*self.height;
            CGFloat MA30_y= (1-rate_30)*self.height;
            if(![NDataUtil IsInfOrNan:x] &&
               ![NDataUtil IsInfOrNan:MA5_y]&&
               ![NDataUtil IsInfOrNan:MA10_y]&&
               ![NDataUtil IsInfOrNan:MA30_y])
            {
                if ((rate_5>=0&&rate_5<=1)||hasStart_5==YES) {
                    hasStart_5=YES;
                    [points_5 addObject:@(CGPointMake(x, MA5_y))];
                }
                if ((rate_10>=0&&rate_10<=1)||hasStart_10==YES) {
                    hasStart_10=YES;
                    [points_10 addObject:@(CGPointMake(x, MA10_y))];
                }
                if ((rate_30>=0&&rate_30<=1)||hasStart_30==YES) {
                    hasStart_30=YES;
                    [points_30 addObject:@(CGPointMake(x, MA30_y))];
                }
            }
        }
    }];
    CGMutablePathRef MA5Path = points_5.count>4?[self smoothedPathWithPoints:points_5 andGranularity:3]:CGPathCreateMutable();
    CGMutablePathRef MA10Path = points_10.count>4?[self smoothedPathWithPoints:points_10 andGranularity:3]:CGPathCreateMutable();
    CGMutablePathRef MA30Path = points_30.count>4?[self smoothedPathWithPoints:points_30 andGranularity:3]:CGPathCreateMutable();
    WEAK_SELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.indexMA5Layer.path = MA5Path;
        weakSelf.indexMA10Layer.path = MA10Path;
        weakSelf.indexMA30Layer.path = MA30Path;
        CGPathRelease(MA5Path);
        CGPathRelease(MA10Path);
        CGPathRelease(MA30Path);
    });
}

//MARK: - Getter

//移动平均线MA5
- (CAShapeLayer *)indexMA5Layer{
    if (!_indexMA5Layer) {
        _indexMA5Layer = [[CAShapeLayer alloc] init];
        _indexMA5Layer.fillColor = [UIColor clearColor].CGColor;
        _indexMA5Layer.strokeColor   = [ChartsUtil C13].CGColor;      //设置划线颜色
        _indexMA5Layer.lineCap = @"round";
        _indexMA5Layer.lineJoin = kCALineJoinRound;
        _indexMA5Layer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexMA5Layer;
}


//移动平均线MA10
- (CAShapeLayer *)indexMA10Layer{
    if (!_indexMA10Layer) {
        _indexMA10Layer = [[CAShapeLayer alloc] init];
        _indexMA10Layer.fillColor = [UIColor clearColor].CGColor;
        _indexMA10Layer.strokeColor   = [ChartsUtil C1100].CGColor;      //设置划线颜色
        _indexMA10Layer.lineCap = @"round";
        _indexMA10Layer.lineJoin = kCALineJoinRound;
        _indexMA10Layer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexMA10Layer;
}


//移动平均线MA30
- (CAShapeLayer *)indexMA30Layer{
    if (!_indexMA30Layer) {
        _indexMA30Layer = [[CAShapeLayer alloc] init];
        _indexMA30Layer.fillColor = [UIColor clearColor].CGColor;
        _indexMA30Layer.strokeColor   = [ChartsUtil C20].CGColor;      //设置划线颜色
        _indexMA30Layer.lineCap = @"round";
        _indexMA30Layer.lineJoin = kCALineJoinRound;
        _indexMA30Layer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexMA30Layer;
}

- (CGMutablePathRef )smoothedPathWithPoints:(NSArray *) pointsArray andGranularity:(NSInteger)granularity {
    
    NSMutableArray *points = [pointsArray mutableCopy];
    
    
    CGMutablePathRef smoothedPath = CGPathCreateMutable();
    // Add control points to make the math make sense
    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];
    
    CGPathMoveToPoint(smoothedPath, NULL, POINT(0).x, POINT(0).y);
    for (NSUInteger index = 1; index < points.count - 2; index++) {
        CGPoint p0 = POINT(index - 1);
        CGPoint p1 = POINT(index);
        CGPoint p2 = POINT(index + 1);
        CGPoint p3 = POINT(index + 2);
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++) {
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            CGPathAddLineToPoint(smoothedPath, NULL, pi.x, pi.y);
        }
        // Now add p2
        CGPathAddLineToPoint(smoothedPath, NULL, p2.x, p2.y);
        
    }
    CGPathAddLineToPoint(smoothedPath, NULL, POINT(points.count - 1).x, POINT(points.count - 1).y);
    // finish by adding the last point
    return smoothedPath;
}

@end

//
//  CFDIndexBOLLLayer.m
//  LiveTrade
//
//  Created by ngw15 on 2019/2/19.
//  Copyright © 2019 taojinzhe. All rights reserved.
//  BOLL线绘制及计算

#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]

#import "CFDIndexBOLLLayer.h"

@interface CFDIndexBOLLLayer ()

@property (nonatomic,strong)CAShapeLayer *indexBOLLUpLayer;
@property (nonatomic,strong)CAShapeLayer *indexBOLLMidLayer;
@property (nonatomic,strong)CAShapeLayer *indexBOLLDownLayer;

@end

@implementation CFDIndexBOLLLayer

- (instancetype)init{
    if (self = [super init]) {
        self.masksToBounds = YES;
        [self addSublayer:self.indexBOLLUpLayer];
        [self addSublayer:self.indexBOLLMidLayer];
        [self addSublayer:self.indexBOLLDownLayer];
    }
    return self;
}

- (void)layoutSublayers{
    [super layoutSublayers];
    self.indexBOLLUpLayer.width =
    self.indexBOLLMidLayer.width =
    self.indexBOLLDownLayer.width = self.width;
    
    self.indexBOLLUpLayer.height =
    self.indexBOLLMidLayer.height =
    self.indexBOLLDownLayer.height = self.height;
    
    self.indexBOLLUpLayer.top =
    self.indexBOLLMidLayer.top =
    self.indexBOLLDownLayer.top = 0;
    
    self.indexBOLLUpLayer.left =
    self.indexBOLLMidLayer.left =
    self.indexBOLLDownLayer.left = 0;
}

//均线的绘制
- (void)drawBOOL:(NSArray *)dataList maxPirce:(NSString *)maxPrice minPrice:(NSString *)minPrice{
    __block CGFloat x = 0.f;
    __block BOOL hasStart_mid = NO;
    __block BOOL hasStart_up = NO;
    __block BOOL hasStart_dn = NO;
    CGFloat pointWidth= self.pointWidth();
    NSMutableArray *points_mid = [NSMutableArray array];
    NSMutableArray *points_up = [NSMutableArray array];
    NSMutableArray *points_dn = [NSMutableArray array];
    [dataList enumerateObjectsUsingBlock:^(CFDKLineData *cell, NSUInteger i, BOOL * _Nonnull stop) {
        NSDictionary *kMADic = cell.BOLLDic;
        if (kMADic!=nil) {
            CGFloat mb = [kMADic[@"mb"] floatValue];
            CGFloat up = [kMADic[@"up"] floatValue];
            CGFloat dn = [kMADic[@"dn"] floatValue];
            x = i*pointWidth;
            //平均线
            CGFloat rate_mid = (mb-[minPrice floatValue])/([maxPrice floatValue]-[minPrice floatValue]);
            CGFloat rate_up = (up-[minPrice floatValue])/([maxPrice floatValue]-[minPrice floatValue]);
            CGFloat rate_dn = (dn-[minPrice floatValue])/([maxPrice floatValue]-[minPrice floatValue]);
            CGFloat mid_y= (1-rate_mid)*self.height;
            CGFloat up_y= (1-rate_up)*self.height;
            CGFloat dn_y= (1-rate_dn)*self.height;
            if(![NDataUtil IsInfOrNan:x] &&
               ![NDataUtil IsInfOrNan:mid_y]&&
               ![NDataUtil IsInfOrNan:up_y]&&
               ![NDataUtil IsInfOrNan:dn_y])
            {
                if ((rate_mid>=0&&rate_mid<=1)||hasStart_mid==YES) {
                    hasStart_mid=YES;
                    [points_mid addObject:@(CGPointMake(x, mid_y))];
                }
                if ((rate_up>=0&&rate_up<=1)||hasStart_up==YES) {
                    hasStart_up=YES;
                    [points_up addObject:@(CGPointMake(x, up_y))];
                }
                if ((rate_dn>=0&&rate_dn<=1)||hasStart_dn==YES) {
                    hasStart_dn=YES;
                    [points_dn addObject:@(CGPointMake(x, dn_y))];
                }
            }
        }
    }];
    CGMutablePathRef midPath =[points_mid count] >4?
    [self smoothedPathWithPoints:points_mid andGranularity:3]:
    CGPathCreateMutable();
    CGMutablePathRef upPath = [points_up count] >4?[self smoothedPathWithPoints:points_up andGranularity:3]:CGPathCreateMutable();
    CGMutablePathRef dnPath = [points_dn count] >4?[self smoothedPathWithPoints:points_dn andGranularity:3]:CGPathCreateMutable();
    WEAK_SELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.indexBOLLMidLayer.path = midPath;
        weakSelf.indexBOLLUpLayer.path = upPath;
        weakSelf.indexBOLLDownLayer.path = dnPath;
        CGPathRelease(midPath);
        CGPathRelease(upPath);
        CGPathRelease(dnPath);
    });
}

//MARK: - Getter

//布林线上轨迹
- (CAShapeLayer *)indexBOLLUpLayer{
    if (!_indexBOLLUpLayer) {
        _indexBOLLUpLayer = [[CAShapeLayer alloc] init];
        _indexBOLLUpLayer.fillColor = [UIColor clearColor].CGColor;
        _indexBOLLUpLayer.strokeColor   = [ChartsUtil C13].CGColor;      //设置划线颜色
        _indexBOLLUpLayer.lineCap = @"round";
        _indexBOLLUpLayer.lineJoin = kCALineJoinRound;
        _indexBOLLUpLayer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexBOLLUpLayer;
}


//布林线中轨迹
- (CAShapeLayer *)indexBOLLMidLayer{
    if (!_indexBOLLMidLayer) {
        _indexBOLLMidLayer = [[CAShapeLayer alloc] init];
        _indexBOLLMidLayer.fillColor = [UIColor clearColor].CGColor;
        _indexBOLLMidLayer.strokeColor   = [ChartsUtil C1100].CGColor;      //设置划线颜色
        _indexBOLLMidLayer.lineCap = @"round";
        _indexBOLLMidLayer.lineJoin = kCALineJoinRound;
        _indexBOLLMidLayer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexBOLLMidLayer;
}


//布林线下轨迹
- (CAShapeLayer *)indexBOLLDownLayer{
    if (!_indexBOLLDownLayer) {
        _indexBOLLDownLayer = [[CAShapeLayer alloc] init];
        _indexBOLLDownLayer.fillColor = [UIColor clearColor].CGColor;
        _indexBOLLDownLayer.strokeColor   = [ChartsUtil C20].CGColor;      //设置划线颜色
        _indexBOLLDownLayer.lineCap = @"round";
        _indexBOLLDownLayer.lineJoin = kCALineJoinRound;
        _indexBOLLDownLayer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexBOLLDownLayer;
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

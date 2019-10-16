//
//  CFDKlineLayer.h
//  LiveTrade
//
//  Created by ngw15 on 2019/2/19.
//  Copyright © 2019 taojinzhe. All rights reserved.
//  蜡烛图绘制

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFDKlineLayer : CALayer

@property (nonatomic,assign) CGFloat barWidth;
///标准区域距右的距离
@property (nonatomic,assign)CGFloat lineRight;

- (void)configUpThinPath:(CGPathRef)upThinPath upThickPath:(CGPathRef)upThickPath downThinPath:(CGPathRef)downThinPath downThickPath:(CGPathRef)downThickPath;

@end

NS_ASSUME_NONNULL_END

//
//  CFDIndexMALayer.h
//  LiveTrade
//
//  Created by ngw15 on 2019/2/19.
//  Copyright © 2019 taojinzhe. All rights reserved.
//  MA均线绘制及计算

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFDIndexMALayer : CALayer

@property (nonatomic,copy) CGFloat(^pointWidth)(void);

- (void)drawMA:(NSArray *)dataList maxPirce:(NSString *)maxPrice minPrice:(NSString *)minPrice;

@end

NS_ASSUME_NONNULL_END

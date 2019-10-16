//
//  CFDIndexVOLLayer.h
//  LiveTrade
//
//  Created by ngw15 on 2019/2/19.
//  Copyright © 2019 taojinzhe. All rights reserved.
//  成交量绘制及计算

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFDIndexVOLLayer : CALayer

@property (nonatomic,assign) CGFloat height;
@property (nonatomic,copy) CGFloat(^getBarWidth)(void);
@property (nonatomic,copy) CGFloat(^pointWidth)(void);
@property (nonatomic,copy) void (^bottomAxisHander)(NSDictionary *dic);
- (void)drawVolLine:(NSArray *)dataList;

@end

NS_ASSUME_NONNULL_END

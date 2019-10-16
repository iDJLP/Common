//
//  CFDIndexRSILayer.h
//  LiveTrade
//
//  Created by ngw15 on 2019/2/19.
//  Copyright © 2019 taojinzhe. All rights reserved.
//  RSI绘制及计算

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFDIndexRSILayer : CALayer

@property (nonatomic,assign) CGFloat height;
@property (nonatomic,copy) void (^bottomAxisHander)(NSDictionary *dic);
@property (nonatomic,copy) CGFloat(^pointWidth)(void);
- (void)drawIndexRSI:(NSArray <CFDKLineData *>*)dataList;
@end

NS_ASSUME_NONNULL_END

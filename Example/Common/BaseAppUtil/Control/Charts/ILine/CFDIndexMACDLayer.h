//
//  CFDIndexMACDLayer.h
//  LiveTrade
//
//  Created by ngw15 on 2019/2/19.
//  Copyright © 2019 taojinzhe. All rights reserved.
//  MACD绘制及计算

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFDIndexMACDLayer : CALayer

@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat barWidth;
@property (nonatomic,copy) CGFloat(^pointWidth)(void);
@property (nonatomic,copy) void (^bottomAxisHander)(NSDictionary *dic);
- (void)drawIndexMACD:(NSArray <CFDKLineData *>*)dataList;

@end

NS_ASSUME_NONNULL_END

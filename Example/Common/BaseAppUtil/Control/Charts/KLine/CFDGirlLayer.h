//
//  CFDGirlLayer.h
//  LiveTrade
//
//  Created by ngw15 on 2019/2/19.
//  Copyright © 2019 taojinzhe. All rights reserved.
//  时间轴绘制

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFDGirlLayer : CALayer

@property (nonatomic,strong)CALayer *dateBgLayer;
@property (nonatomic,copy) CGFloat(^pointWidth)(void);
@property (nonatomic,copy) NSInteger(^hCount)(void);

- (void)drawGirdVLine:(NSArray *)dataList;
@end

NS_ASSUME_NONNULL_END

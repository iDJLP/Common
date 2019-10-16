//
//  CFDTopIndexLayer.h
//  Chart
//
//  Created by ngw15 on 2019/3/15.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFDTopIndexLayer : CALayer

@property(nonatomic,copy)CGFloat (^getPointWidth)(void);

- (void)drawTopIndex:(EIndexTopType)type showDataList:(NSArray *)dataList maxPrice:(NSString *)maxPrice minPrice:(NSString *)minPrice;
- (void)showIndexTop:(EIndexTopType)topType;

@end

NS_ASSUME_NONNULL_END

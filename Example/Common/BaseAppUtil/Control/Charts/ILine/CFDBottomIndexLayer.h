//
//  CFDBottomIndexLayer.h
//  Chart
//
//  Created by ngw15 on 2019/3/15.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFDBottomIndexLayer : CALayer

@property (nonatomic,copy) void (^bottomAxisHander)(NSDictionary *dic);
@property(nonatomic,copy)CGFloat (^getPointWidth)(void);
@property(nonatomic,copy)CGFloat (^getBarWidth)(void);

- (void)setIndexDrawHeight:(CGFloat)height;
- (void)showIndex:(EIndexType)indexType;
- (void)showBottomIndex:(EIndexType)type showDataList:(NSArray *)dataList;

@end

NS_ASSUME_NONNULL_END

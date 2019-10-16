//
//  PieChartView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/9/26.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PieChartView : BaseView

@property (nonatomic,copy) void(^selectedHander)(NSInteger index);
@property (nonatomic,copy) void(^deSelectedHander)(void);
@property (nonatomic,assign) CGPoint centerPoint;
@property (nonatomic,assign) CGFloat innerRadius;
@property (nonatomic,assign) CGFloat outerRadius;

- (void)updateList:(NSArray *)dataList;
- (void)setSelectedIndex:(NSInteger)index;
@end

NS_ASSUME_NONNULL_END

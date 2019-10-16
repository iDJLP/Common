//
//  MarketCell.h
//  Chart
//
//  Created by ngw15 on 2019/3/12.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseCell.h"
#import "BaseView.h"
#import "CFDChartsData.h"

NS_ASSUME_NONNULL_BEGIN

@interface MarketView : BaseView

+ (CGFloat)heightOfView;

@property (nonatomic,copy) void(^sortChangedHander)(NSString *sortType) ;

@end

@interface MarketCell : BaseCell

+ (CGFloat)heightOfCell;
- (void)configCell:(CFDBaseInfoModel *)model;

@end

NS_ASSUME_NONNULL_END

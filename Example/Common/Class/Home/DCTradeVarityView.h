//
//  DCTradeVarityCell.h
//  qzh_ftox
//
//  Created by ngw15 on 2018/3/27.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

@protocol DCTradeVarityProtocol

- (void)tradeVarityChanged:(CFDBaseInfoModel *)model;

@end

@interface DCTradeVarityView : BaseView

@property (nonatomic,weak)id<DCTradeVarityProtocol> delegate;
@property (nonatomic, assign) BOOL isNeedScroll;
@property (nonatomic,copy) void(^selectedRow)(CFDBaseInfoModel *model);
+ (CGFloat)heightOfView;

- (instancetype)initWithSelectedEnabled:(BOOL)enabled;
- (void)selectedTradeVarity:(CFDBaseInfoModel *)dict;
- (void)separatViewHidden;
- (void)willAppear;
- (void)willDisAppear;
- (void)refreshData;
@end

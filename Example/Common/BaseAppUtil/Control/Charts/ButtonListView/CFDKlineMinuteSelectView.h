//
//  KlineMinuteSelectView.h
//  niuguwang
//
//  Created by zhangchangqing on 16/9/9.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//  最右侧可展开的视图

#import <UIKit/UIKit.h>

@interface CFDKlineMinuteSelectView : UIView
@property (nonatomic,assign)NSInteger index;
@property(nonatomic,copy)void(^setSelectMinuteBtn)(NSInteger index ,NSDictionary *config);
- (instancetype)initWithTitles:(NSArray <NSDictionary *>*)titles frame:(CGRect)frame;

@end

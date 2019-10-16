//
//  CFDKLineVButton.h
//  nntj_ftox
//
//  Created by zhangchangqing on 2017/10/11.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//  分时，1分，5分这类button视图

#import <UIKit/UIKit.h>

@interface CFDKLineVButton : UIView
@property (nonatomic , copy) void(^setKlineTypeBlock)(NSInteger,NSDictionary *);

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles;

- (void)resetSelectedBtn;
- (void)changedSelected:(NSInteger)index title:(NSString *)title;
- (void)clickedButtonList:(NSInteger)index;
//选择哪个k线
-(void)setSelected:(NSInteger)index;
@end

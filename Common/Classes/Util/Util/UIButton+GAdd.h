//
//  UIButton+GAdd.h
//  按钮扩展
//
//  1.防止重复点击
//  2.调整点击热区
//
//  Created by BrightLi on 2016/12/9.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ClickButtonBlock)(id sender);

@interface UIButton (GAdd)
// 是否检查重复点击
@property(nonatomic,assign) BOOL g_checkRepeatClick;

// 点击事件回调块
- (void) g_clickBlock:(ClickButtonBlock) block;
//MARK:- 设置上下左右边界
- (void) g_clickEdgeWithTop:(CGFloat) top
                     bottom:(CGFloat) bottom
                       left:(CGFloat) left
                      right:(CGFloat) right;
- (CGRect) enlargedRect;

- (void) setBackgroundImageWith:(UIColor *)color forState:(UIControlState)state;

- (void) setBackgroundImageWith:(UIColor *)color forState:(UIControlState)state radius:(CGFloat)radius;

@end

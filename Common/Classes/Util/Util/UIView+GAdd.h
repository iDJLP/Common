//
//  UView+GAdd.h
//  niuguwang
//
//  Created by BrightLi on 2016/12/16.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LineDirection) {
    LineTop = 1,
    LineLeft = 2,
    LineRight = 4,
    LineBottom = 8
};

@interface UIView (GAdd)

typedef void (^ClickViewBlock)(UITapGestureRecognizer *tap);

// 是否检查重复点击
@property(nonatomic,assign) BOOL g_checkRepeatClick;
// MARK:- 点击事件回调块
- (void) g_clickBlock:(ClickViewBlock) block;
// 判断View是否显示在屏幕上
- (BOOL) isDisplayedInScreen;
// 设置圆角
- (void) radius:(UIColor *)color radius:(CGFloat) radius;

- (void)addLineWith:(LineDirection)ineDirection;

- (void)addLineWith:(LineDirection)lineDirection rect:(CGRect)rect;

- (void)addLineWith:(LineDirection)lineDirection lineWidth:(CGFloat)lineWidth;

- (void)addLineWith:(LineDirection)lineDirection rect:(CGRect)rect lineWidth:(CGFloat)lineWidth;

- (void)readyAddLine;

+ (UIViewController *)getPresentCurrentVC;
+ (UIViewController *)getPushCurrentVC;

- (UIImage *)convertToImage;

@end

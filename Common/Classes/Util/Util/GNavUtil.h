//
//  GNavUtil.h
//  niuguwang
//
//  Created by BrightLi on 2017/10/26.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GNavUtil:NSObject

//添加导航栏底线（细）
+ (void)addLine:(UIViewController *)target;
// 隐藏导航栏底线
+ (void) hideLine:(UIViewController *) target;
// 可用于设置左侧返回关闭按钮
+ (void) leftIcon:(UIViewController *)target
             icon:(NSString *) icon
       secondIcon:(NSString *) secondIcon
              gap:(NSInteger) gap
          onClick:(void (^)(void)) onClick
    onClickSecond:(void (^)(void)) onClickSecond;

// 隐藏或显示关闭按钮
+ (void) leftSecondHidden:(UIViewController *)target
                   hidden:(BOOL) hidden;

// 创建导航栏返回按钮
+ (void) leftBack:(UIViewController *) target;

// 创建导航栏返回按钮
+ (void) leftIcon:(UIViewController *) target
             icon:(NSString *) icon
          onClick:(void (^)(void)) onClick;

// 创建导航栏右侧文本按钮
+ (UILabel *) rightTitle:(UIViewController *) target
                   title:(NSString *)title
                   color:(ColorType)color
                 onClick:(void (^)(void)) onClick;

// 创建导航栏右侧双图标按钮
+ (void) rightIcon:(UIViewController *) target
              icon:(NSString *)icon
        secondIcon:(NSString *) secondIcon
               gap:(NSInteger) gap
           onClick:(void (^)(void)) onClick
     onClickSecond:(void (^)(void)) onClickSecond;

// 创建导航栏右侧图标按钮
+ (void) rightIcon:(UIViewController *) target
                           icon:(NSString *)icon
                        onClick:(void (^)(void)) onClick;

//取navBar 下的横线
+(UIImageView *)findHairlineImageViewUnder:(UIView *)view;

@end;

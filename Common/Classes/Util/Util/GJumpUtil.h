//
//  NJumpUtil.h
//  niuguwang
//
//  Created by BrightLi on 2016/9/28.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface GJumpUtil : NSObject

+ (void) pushVC:(UIViewController *)target
       animated:(BOOL) animated;
+ (void) popAnimated:(BOOL) animated;
+ (BOOL) isTopVC:(Class) cls;
// 弹出视图
+ (void) presentVC:(UINavigationController *)target
           current:(UIViewController *) current
          animated:(BOOL) animated;
// 获得根视图
+ (UITabBarController *) rootTabC;
+ (UINavigationController *) rootNavC;
+ (UIWindow *)window;
// 跳到应用设置
+ (void) jumpToAppSetting;
// 呼叫电话
+ (void) callPhone:(UIViewController *)current
             phone:(NSString *)phone;

// 更新app
+ (void) updateApp:(NSString *)plist;

@end

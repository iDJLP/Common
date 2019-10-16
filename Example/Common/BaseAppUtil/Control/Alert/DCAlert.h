//
//  DCAlert.h
//  niuguwang
//
//  Created by ngw15 on 2018/4/6.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCAlert : NSObject

/**
 title:标题 可没有
 detail:内容 暂只支持string
 sureTitle:确认
 sureHander:事件
 */
+ (void)showAlert:(NSString *)title
           detail:(id)detail
        sureTitle:(NSString *)sure
       sureHander:(dispatch_block_t)sureHander;

+ (void)showAlert:(NSString *)title
           detail:(id)detail
        sureTitle:(NSString *)sure
       sureHander:(dispatch_block_t)sureHander
      cancelTitle:(NSString *)cancelTitle
     cancelHander:(dispatch_block_t)cancelHander;

+ (void)showAlert:(NSString *)title
           detail:(id)detail
        sureTitle:(NSString *)sure
       sureHander:(dispatch_block_t)sureHander
         tinColor:(UIColor *)tinColor;

/**
 title:标题 可没有
 detail:内容 暂只支持string
 sureTitle:确认
 sureHander:事件
 cancelTitle:取消
 cancelHander:事件
 tinColor:主题色 确认按钮的颜色
 isBigAlert:弹窗宽度，默认NO
 */
+ (void)showAlert:(NSString *)title
           detail:(id)detail
        sureTitle:(NSString *)sure
       sureHander:(dispatch_block_t)sureHander
      cancelTitle:(NSString *)cancel
     cancelHander:(dispatch_block_t)cancelHander
       isBigAlert:(BOOL)isBig
         tinColor:(UIColor *)tinColor;

+ (void)showAlert:(NSString *)title
           detail:(id)detail
        sureTitle:(NSString *)sure
       sureHander:(dispatch_block_t)sureHander
      cancelTitle:(NSString *)cancel
     cancelHander:(dispatch_block_t)cancelHander
       isBigAlert:(BOOL)isBig
         tinColor:(UIColor *)tinColor
              tag:(NSInteger)tag;

+ (void)hide;

@end

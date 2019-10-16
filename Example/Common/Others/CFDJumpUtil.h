//
//  CFDJumpUtil.h
//  NWinBoom
//
//  Created by ngw15 on 2018/9/6.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WebVC.h"

@interface CFDJumpUtil : NSObject

//MARK: - Login
+ (void)jumpToLogin;
+ (void)jumpToLogin:(dispatch_block_t)hander;
+ (void)jumpToRegister:(dispatch_block_t)hander;
+ (void)jumpToHomeFucs:(NSDictionary *)dict;

//MARK: - Web
+ (void)jumpToWeb:(NSString *)title link:(NSString *)link type:(WebVCType)type animated:(BOOL)animated;
+ (void)jumpToWeb:(NSString *)title link:(NSString *)link animated:(BOOL)animated;
+ (void)jumpToWeb:(NSString *)title link:(NSString *)link canGoBack:(BOOL)canGoBack animated:(BOOL)animated;
+ (void)jumpToWeb:(NSString *)title link:(NSString *)link type:(WebVCType)type canGoBack:(BOOL)canGoBack animated:(BOOL)animated;
+ (void)jumpToService;

//MARK: - User

+ (void)jumpToRealName;
+ (void)jumpToBindBank;
+ (void)jumpToDeposit:(NSString *)type;
+ (void)jumpToDrawl:(NSString *)type;
+ (void)jumpAlterPwd;

+ (void)jumpToSystemNotic;
+ (void)jumpToMineVC;
+ (void)jumpToHomeVC;
+ (void)jumpToTradeVC:(NSString *)symbol;
+ (void)jumpToTradeVC:(NSString *)symbol isBuy:(BOOL)isBuy;
//MARK: - Charts
+ (void)jumpToCharts:(NSString *)symbol;
@end

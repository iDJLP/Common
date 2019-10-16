//
//  FTDeviceInfoUtils.h
//  niuguwang
//
//  Created by jly on 2017/4/26.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FTDeviceInfoUtils : NSObject

+ (NSString *)cpu;
/***操作系统*/
+ (NSString *)os;
/***制作商*/
+ (NSString *)manufacturer;
/***网络类型*/
+ (NSString *)networktype;
/***手机运营商*/
+ (NSString *)mobileoperatorname;
/***手机型号*/
+ (NSString *)mobilemode;

/***ip地址*/
+ (NSString *)deviceIPAdress;
/** 是否越狱*/
+ (BOOL)isjailbroken;
@end

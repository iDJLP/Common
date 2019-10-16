//
//  CFDApp.h
//  NWinBoom
//
//  Created by ngw15 on 2018/9/6.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFDApp : NSObject

@property (nonatomic,assign)BOOL hasLastVersionApp;
@property (nonatomic,assign)BOOL hasNew;
@property (nonatomic,assign)NSInteger marketNewCount;
@property (nonatomic,assign)NSInteger sysNewCount;
@property (nonatomic,assign)NSInteger tradeNewCount;

//是否检测了token
@property (nonatomic,assign)BOOL isLoadToken;

//是白色主题
@property (nonatomic,assign)BOOL isWhiteTheme;

//是红涨绿跌
@property (nonatomic,assign)BOOL isRed;
@property (nonatomic,copy)NSString *updateAppUrl;
@property (nonatomic,copy)NSString *serviceLink;

+ (instancetype)sharedInstance;
- (void)preLoad;
- (void)checkUnReadNotice;
- (void)loadService:(void (^)(NSString *serviceLink))hander;
+ (void)loadService:(void (^)(NSString *serviceLink))hander;

+ (BOOL)sendVaildPhoneCode:(UILabel *)remarkLabel mobile:(NSString *)mobile smsType:(int)smsType ccode:(NSString *)ccode;

@end

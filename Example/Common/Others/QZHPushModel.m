//
//  QZHPushModel.m
//  niuguwang
//
//  Created by A on 2017/6/29.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "QZHPushModel.h"
#import <UserNotifications/UserNotifications.h>
#import "CFDLocation.h"
#import "DCPushAlert.h"

@implementation QZHPushModel

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static QZHPushModel * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[QZHPushModel alloc] init];
    });
    return sharedInstance;
}

+ (void) launch
{
    [self launch:[UIApplication sharedApplication]];
}

+ (void) launch:(UIApplication *)application
{
    [[self sharedInstance] launch:application];
}

- (void) launch:(UIApplication *) application
{
    // iOS10
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert) completionHandler:^(BOOL granted, NSError * _Nullable error) {
            if (!error) {
                if(granted){
                    BLYLogInfo(@"注册通知成功");
                }else{
                    BLYLogInfo(@"注册通知失败");
                }
            }else{
                BLYLogInfo(@"注册通知错误%@",error);
            }
            [[CFDLocation sharedInstance] startLocation];
        }];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            BLYLogInfo(@"%@",settings);
        }];
    } else {
        // Fallback on earlier versions
    }
    UIUserNotificationSettings *settings=[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];
}

+ (void)showAlert:(NSDictionary *)userInfo
{
    
    PushType pushType=[NDataUtil integerWith:userInfo[@"type"] valid:PushJumpNone];
    NSDictionary * apsDict = [NDataUtil dictWith:[userInfo objectForKey:@"aps"]];
    NSDictionary * alertDict = [NDataUtil dictWith:[apsDict objectForKey:@"alert"]];

    [DCAlert showAlert:[alertDict objectForKey:@"title"] detail:[alertDict objectForKey:@"body"] sureTitle:@"确认" sureHander:^{
        if (pushType == PushJumpSettlement) {
            [CFDJumpUtil jumpToTradeVC:@""];
        }else{
            
        }
    } cancelTitle:@"取消" cancelHander:^{
        
    } isBigAlert:NO tinColor:nil];
    
}

- (void)showHangqingAlert:(NSDictionary *)userInfo
{
    NSDictionary * apsDict = [NDataUtil dictWith:[userInfo objectForKey:@"aps"]];
    NSDictionary * alertDict = [NDataUtil dictWith:[apsDict objectForKey:@"alert"]];
    [DCAlert showAlert:[alertDict objectForKey:@"title"] detail:[alertDict objectForKey:@"body"] sureTitle:@"去看看" sureHander:^{
        NSString *contradId = [NDataUtil stringWith:userInfo[@"objectid"] valid:@""];
        [CFDJumpUtil jumpToCharts:contradId];
    } cancelTitle:@"取消" cancelHander:^{
        
    } isBigAlert:NO tinColor:nil];
    
    
}

+ (void) receive:(UIApplication *)application dict:(NSDictionary *) userInfo
{
    BLYLogInfo(@"收到推送:%@",userInfo);
    NSLog(@"%@",userInfo);
    
    if([UIApplication sharedApplication].applicationState == UIApplicationStateActive)
    {
        PushType pushType=[NDataUtil integerWith:userInfo[@"type"] valid:PushJumpNone];
        if (pushType == PushJumpNotice) {
            WEAK_SELF;
            NSDictionary * apsDict = [NDataUtil dictWith:[userInfo objectForKey:@"aps"]];
            NSDictionary * info = [NDataUtil dictWith:[apsDict objectForKey:@"alert"]];
            [DCPushAlert showContent:[NDataUtil stringWith:info[@"body"]] title:[NDataUtil stringWith:info[@"title"]] tapAction:^{
                [weakSelf remoteReceive:userInfo];
            }];
        } else if (pushType == PushJumpSettlement) {
            [[self sharedInstance] showAlert:userInfo];
        }
        else if (pushType== PushJumpHangqing)
        {
            [[self sharedInstance]showHangqingAlert:userInfo];
        }else{
            WEAK_SELF;
            NSDictionary * apsDict = [NDataUtil dictWith:[userInfo objectForKey:@"aps"]];
            NSDictionary * info = [NDataUtil dictWith:[apsDict objectForKey:@"alert"]];
            [DCPushAlert showContent:[NDataUtil stringWith:info[@"body"]] title:[NDataUtil stringWith:info[@"title"]] tapAction:^{
                [weakSelf remoteReceive:userInfo];
            }];
        }
    } else {
        [self remoteReceive:userInfo];
    }
}

#pragma mark 跳转方法

+ (void) remoteReceive:(NSDictionary *)userInfo
{
    
    PushType pushType=[NDataUtil integerWith:userInfo[@"type"] valid:PushJumpNone];
    if (pushType == PushJumpNotice) {
        [CFDJumpUtil jumpToSystemNotic];
    } else if (pushType == PushJumpSettlement){
        [CFDJumpUtil jumpToTradeVC:@""];
    } else if (pushType == PushJumpNewsInfo){

    }else if (pushType== PushJumpHangqing)
    {
        NSString *symbol = [NDataUtil stringWith:userInfo[@"objectid"] valid:@""];
        [CFDJumpUtil jumpToCharts:symbol];
    }
}

@end

//
//  CFDApp.m
//  NWinBoom
//
//  Created by ngw15 on 2018/9/6.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "CFDApp.h"
#import "WebSocketModel.h"
#import "CFDLocation.h"
#import "DCService.h"
#import "DomainUtil.h"
#import "FCUpdateAlert.h"
#import "CFDWelcomeAlert.h"
#import "SDWebImageManager.h"
#import "MJMonitorRunloop.h"

@implementation CFDApp

// GCD单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static CFDApp * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[CFDApp alloc] init];
    });
    return sharedInstance;
}

- (void)preLoad{
    _isWhiteTheme = [NLocalUtil boolForKey:@"isWhiteTheme"];
    _isRed=[NLocalUtil boolForKey:@"app_isRed"];
    [[SDWebImageManager sharedManager].imageCache clearDiskOnCompletion:nil];
    [[FTConfig sharedInstance] load:@"ftconfig"];
    [DomainUtil loadList];
    [Bugly startWithAppId:[[FTConfig sharedInstance] buglyAppId]];
    [BuglyLog initLogger:0 consolePrint:YES];
    [[CFDLocation sharedInstance] getIpInfo];
    [[WebSocketModel sharedInstance] preload];
    [FCUpdateAlert show];
    [NNetState launch];
    [self checkUnReadNotice];
    WEAK_SELF;
    [NTimeUtil startTimer:@"CFDApp_token" interval:600 repeats:YES action:^{
        [weakSelf updateUserToken];
    }];
#if DEBUG
//    [[MJMonitorRunloop sharedInstance] startMonitor];
//    [MJMonitorRunloop sharedInstance].callbackWhenStandStill = ^{
//        NSLog(@"nice");
//    };
#endif
}

- (void)updateUserToken{
    if (![UserModel isLogin]) {
        return;
    }
    WEAK_SELF;
    [DCService updateUserToken:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"0"]) {
            weakSelf.isLoadToken = YES;
            NSDictionary *dic = [NDataUtil dictWith:data[@"data"]];
            [UserModel sharedInstance].userToken = [NDataUtil stringWith:dic[@"usertoken"]];
        }else if (weakSelf.isLoadToken==NO&&[NDataUtil boolWithDic:data key:@"status" isEqual:@"-1"]){
            [[UserModel sharedInstance] logout];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)checkUnReadNotice{
    if (![UserModel isLogin]) {
        [CFDApp sharedInstance].hasNew = NO;
        return;
    }
    [DCService hasUnReadNotice:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [CFDApp sharedInstance].marketNewCount = [NDataUtil integerWith:data[@"mktdataCount"] valid:0];
            [CFDApp sharedInstance].tradeNewCount = [NDataUtil integerWith:data[@"tradeCount"] valid:0];
            [CFDApp sharedInstance].sysNewCount = [NDataUtil integerWith:data[@"sysNoticeCount"] valid:0];
            NSArray *list = [NDataUtil arrayWith:data[@"noticedatalist"]];
            NSDictionary *noticDic = [NDataUtil dictWithArray:list index:0];
            if ([NDataUtil boolWithDic:noticDic key:@"isnew" isEqual:@"1"]) {
                [self showNoticAlert:noticDic];
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)showNoticAlert:(NSDictionary *)noticDic{
    NSString *title = [NDataUtil stringWith:noticDic[@"noticetitle"]];
    NSString *detail = [NDataUtil stringWith:noticDic[@"noticecontent"]];
    [CFDWelcomeAlert showAlert:title detail:detail sureTitle:@"知道了"  sureHander:^{
        [DCService setReadNotice:^(id data) {
            
        } failure:^(NSError *error) {
            
        }];
    }];
}

- (BOOL)hasNew{
    return _sysNewCount>0||_tradeNewCount>0||_marketNewCount>0;
}

- (void)loadService:(void (^)(NSString *serviceLink))hander{
    WEAK_SELF;
    _serviceLink.length>0?
    hander(weakSelf.serviceLink):
    [DCService getCustomerService:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            NSArray *list = [NDataUtil arrayWith:data[@"data"]];
            NSString *serviceLink = @"";
            for (NSDictionary *dic in list) {
                if ([NDataUtil boolWithDic:dic key:@"type" isEqual:@"3"]) {
                    serviceLink = [NDataUtil stringWith:dic[@"content"]];
                }
            }
            weakSelf.serviceLink = serviceLink;
            hander(weakSelf.serviceLink);
        }
        
    } failure:^(NSError *error) {
        
    }];
}

+ (void)loadService:(void (^)(NSString *serviceLink))hander{
    [[CFDApp sharedInstance] loadService:hander];
}

+ (BOOL)sendVaildPhoneCode:(UILabel *)remarkLabel mobile:(NSString *)mobile smsType:(int)smsType ccode:(NSString *)ccode{
    if ([NDataUtil isMobilePhone:mobile]==NO) {
        return NO;
    }
    if ([UserModel isLogin]) {
        BOOL flag = [[UserModel sharedInstance].mobilePhone isEqualToString:mobile];
        if (flag==NO) {
            return NO;
        }
    }
    [DCService postgetVerifyCodeMobile:mobile smsType:smsType ccode:ccode sucess:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"result" isEqual:@"1"]) {
            [HUDUtil showInfo:CFDLocalizedString(@"验证码发送成功")];
            NSString *timerTag = [NSString stringWithFormat:@"vaild_phone_%d",smsType];
            [NTimeUtil startTimer:timerTag interval:1 repeatCounts:60 action:^(NSInteger index) {
                remarkLabel.font = [GUIUtil fitFont:16];
                remarkLabel.text = [NSString stringWithFormat:@"%d%@",(int)(60-index),CFDLocalizedString(@"秒")];
            } finishAction:^{
                remarkLabel.userInteractionEnabled = YES;
                remarkLabel.text = CFDLocalizedString(@"发送验证码");
            }];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"message"] valid:[FTConfig webTips]]];
            remarkLabel.userInteractionEnabled = YES;
        }
    } failure:^(NSError *error) {
        remarkLabel.userInteractionEnabled = YES;
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
    return YES;
}

@end

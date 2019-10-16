//
//  CFDJumpUtil.m
//  NWinBoom
//
//  Created by ngw15 on 2018/9/6.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "CFDJumpUtil.h"
#import "DCLoginVC.h"

#import "DepositVC.h"
#import "DrawlVC.h"
#import "WebVC.h"
#import "BindVC.h"
#import "ChartsVC.h"
#import "DCForgetPwdVC.h"
#import "TradeVC.h"
#import "QZHMessageVC.h"
#import "NNTJTrainingVC.h"
#import "MineVC.h"
#import "HomeVC.h"

@implementation CFDJumpUtil

+ (void)jumpToLogin{
    [DCLoginVC jumpTo:nil];
}

+ (void)jumpToLogin:(dispatch_block_t)hander{
    [DCLoginVC jumpTo:hander];
}

+ (void)jumpToRegister:(dispatch_block_t)hander{
    [DCLoginVC jumpToRegister:hander];
}

///skipType: 1 跳原生  url：helpercenter
//                     jumptocharts_BTCUSDT
//jumptotrade
//jumptoDeposit
//jumptoDrawl
+ (void)jumpToHomeFucs:(NSDictionary *)dict{
    NSInteger skipType = [[NDataUtil stringWithDict:dict keys:@[@"skipType",@"skiptype"] valid:@"0"] integerValue];
    NSString *action = [NDataUtil stringWithDict:dict keys:@[@"openurl",@"url",@"adjumpurl"] valid:@""];
    switch (skipType) {
        case 1:
        {
            NSArray *params = @[];
            if ([action containsString:@"_"]) {
                params = [action componentsSeparatedByString:@"_"];
                action = [params firstObject];
                params = [params subarrayWithRange:NSMakeRange(1, params.count-1)];
            }
            if ([action isEqualToString:@"helpercenter"]){
                [NNTJTrainingVC jumpTo];
            }else if ([action isEqualToString:@"jumptocharts"]){
                if (params.count>0) {
                    [CFDJumpUtil jumpToCharts:[params firstObject]];
                }
            }else if ([action isEqualToString:@"jumptotrade"]){
                [CFDJumpUtil jumpToTradeVC:[NDataUtil dataWithArray:params index:0]];
            }else if ([action isEqualToString:@"jumptoDeposit"]){
                [CFDJumpUtil jumpToDeposit:@"USDT"];
            }else if ([action isEqualToString:@"jumptoDrawl"]){
                [CFDJumpUtil jumpToDrawl:@"USDT"];
            }
        }
            break;
        case 2:{
            [CFDJumpUtil jumpToWeb:[NDataUtil stringWith:dict[@"title"]] link:action animated:YES];
        }
            break;
        case 3:{
            
        }
            break;
        case 4:{
            if (![UserModel isLogin]) {
                [CFDJumpUtil jumpToLogin];
                return;
            }
            NSString *url = action;
            NSString *lastStr = @"";
            NSArray *list = [url componentsSeparatedByString:@"#"];
            if (list.count>1) {
                url = [list firstObject];
                lastStr = [list lastObject];
                url = [NSString stringWithFormat:@"%@?%@#%@",url,[DCService paramsWithHead:HttpBaseHead],lastStr];
            }else{
                url = [NSString stringWithFormat:@"%@?%@",url,[DCService paramsWithHead:HttpBaseHead]];
            }
            [CFDJumpUtil jumpToWeb:[NDataUtil stringWith:dict[@"title"]] link:url animated:YES];
        }
            break;
        default:
            break;
    }
}

+ (void)jumpToService{
    [CFDApp loadService:^(NSString *serviceLink) {
        
        [CFDJumpUtil jumpToWeb:CFDLocalizedString(@"客服") link:serviceLink animated:YES];
    }];
}

//MARK: - Web

+ (void)jumpToWeb:(NSString *)title link:(NSString *)link type:(WebVCType)type animated:(BOOL)animated;{
    [self jumpToWeb:title link:link type:type canGoBack:NO animated:animated];
}

+ (void)jumpToWeb:(NSString *)title link:(NSString *)link animated:(BOOL)animated{
    [self jumpToWeb:title link:link canGoBack:NO animated:animated];
}

+ (void)jumpToWeb:(NSString *)title link:(NSString *)link canGoBack:(BOOL)canGoBack animated:(BOOL)animated{
    [self jumpToWeb:title link:link type:WebVCTypeDefault canGoBack:canGoBack animated:animated];
}

+ (void)jumpToWeb:(NSString *)title link:(NSString *)link type:(WebVCType)type canGoBack:(BOOL)canGoBack animated:(BOOL)animated{
    [WebVC jumpTo:title link:link type:type canGoBack:canGoBack animated:animated];
}

//MARK: - User

+ (void)jumpToRealName{
    [BindVC jumpTo:BindTypeIdAuth];
}

+ (void)jumpAlterPwd{
    [DCForgetPwdVC jumpTo:[GJumpUtil rootNavC].topViewController successHander:^{
        
    }];
}

+ (void)jumpToBindBank{
    [BindVC jumpTo:BindTypeBank];
}

+ (void)jumpToDeposit:(NSString *)type
{
    if (![UserModel isLogin]) {
        [self jumpToLogin:^{
        }];
        return ;
    }
    [DepositVC jumpTo:type];
}

+ (void)jumpToDrawl:(NSString *)type
{
    if (![UserModel isLogin]) {
        [self jumpToLogin:^{
        }];
        return ;
    }
    [DrawlVC jumpTo:type];
}

+ (void)jumpToSystemNotic{
    QZHMessageVC *messageVC = [QZHMessageVC new];
    messageVC.messageType = QZHMessageType_system;
    [GJumpUtil pushVC:messageVC animated:YES];
}

+ (void)jumpToMineVC{
    MainTabBarVC * tabC =(MainTabBarVC *)[GJumpUtil rootTabC];
    [(UINavigationController *)tabC.selectedViewController popViewControllerAnimated:NO];
    [tabC selectedItemWithClassString:NSStringFromClass([MineVC class])];
}
+ (void)jumpToHomeVC{
    MainTabBarVC * tabC =(MainTabBarVC *)[GJumpUtil rootTabC];
    [(UINavigationController *)tabC.selectedViewController popViewControllerAnimated:NO];
    [tabC selectedItemWithClassString:NSStringFromClass([HomeVC class])];
}

+ (void)jumpToTradeVC:(NSString *)symbol{
    [TradeVC jumpTo:symbol];
}

+ (void)jumpToTradeVC:(NSString *)symbol isBuy:(BOOL)isBuy{
    [TradeVC jumpTo:symbol isBuy:isBuy];
}

//MARK: - Charts
+ (void)jumpToCharts:(NSString *)symbol{
    [ChartsVC jumpTo:symbol];
}


@end

//
//  NJumpUtil.m
//  niuguwang
//
//  Created by BrightLi on 2016/9/28.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "GJumpUtil.h"
#import "Macros.h"
#import "AppDelegate.h"


@implementation GJumpUtil

+ (void) pushVC:(UIViewController *)target
       animated:(BOOL) animated{
    if ([NNetState isDisnet]) {
        [HUDUtil showInfo:CFDLocalizedString(@"网络异常,请检查您的网络设置")];
        return;
    }
    [[GJumpUtil rootNavC] pushViewController:target animated:animated];
}

+ (void) popAnimated:(BOOL) animated{
    [[GJumpUtil rootNavC] popViewControllerAnimated:animated];
}
+ (void) presentVC:(UINavigationController *)target
           current:(UIViewController *) current
          animated:(BOOL) animated
{
    if(!current){
        current=[self rootTabC];
    }
    [current presentViewController:target animated:animated completion:nil];
}
// 获得根视图
+ (UIViewController *) rootTabC
{
    return [[[UIApplication sharedApplication] delegate] window].rootViewController;
}
+ (UINavigationController *) rootNavC{
    return [self rootTabC].selectedViewController;
}

+ (UIWindow *)window{
    return [[[UIApplication sharedApplication] delegate] window];
}

// 是顶部视图？
+ (BOOL) isTopVC:(Class) cls
{
    UINavigationController *current=[GJumpUtil rootNavC];
    UIViewController *topVC=current.topViewController;
    if([topVC isKindOfClass:cls]){
        return YES;
    }
    return NO;
}

// 跳到应用设置
+ (void) jumpToAppSetting
{
    NSURL *url=[NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if( [[UIApplication sharedApplication] canOpenURL:url] ) {
        if(IS_IOS_10){
            [[UIApplication sharedApplication] openURL:url
                                               options:@{}
                                     completionHandler:^(BOOL success){
                                     }];
        }else{
            [[UIApplication sharedApplication] openURL:url];
        }
        return;
    }
}

+ (void)updateApp:(NSString *)plist{

    if ([plist hasPrefix:@"http://"]||[plist hasPrefix:@"https://"]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:plist]];
    }
//    plist =@"https://winbi.oss-cn-hangzhou.aliyuncs.com/ios/biying.plist";
//    if ([plist hasPrefix:@"http"]&&[plist hasSuffix:@".plist"]) {
//        NSString *url = [NSString stringWithFormat:@"itms-services://?action=download-manifest&url=%@",plist];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
//    }
}

// 呼叫电话
+ (void) callPhone:(UIViewController *)current
             phone:(NSString *)phone
{
    if(phone.length<1){
        return;
    }
    if(!current){
        current=[GJumpUtil rootTabC];
    }
    NSString *iOSVersion = [[UIDevice currentDevice] systemVersion];
    if ([iOSVersion compare:@"10.2" options:NSNumericSearch] == NSOrderedDescending || [iOSVersion compare:@"10.2" options:NSNumericSearch] == NSOrderedSame)
    {
        NSString *phoneUrl = [NSString stringWithFormat:@"tel://%@",phone];
        UIApplication * app = [UIApplication sharedApplication];
        if ([app canOpenURL:[NSURL URLWithString:phoneUrl]]) {
            [app openURL:[NSURL URLWithString:phoneUrl]];
        }
        return;
    }
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:phone message: nil preferredStyle:UIAlertControllerStyleAlert];
    // 设置popover指向的item
    alert.popoverPresentationController.barButtonItem = current.navigationItem.leftBarButtonItem;
    // 添加按钮
    [alert addAction:[UIAlertAction actionWithTitle:CFDLocalizedString(@"呼叫") style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        NSLog(@"点击了呼叫按钮10.2下");
        NSString *phoneUrl = [NSString stringWithFormat:@"tel://%@",phone];
        UIApplication * app = [UIApplication sharedApplication];
        if ([app canOpenURL:[NSURL URLWithString:phoneUrl]]) {
            [app openURL:[NSURL URLWithString:phoneUrl]];
        }
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:CFDLocalizedString(@"取消") style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        NSLog(@"点击了取消按钮");
    }]];
    [current presentViewController:alert animated:YES completion:nil];
}

@end

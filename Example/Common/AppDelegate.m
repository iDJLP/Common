//
//  AppDelegate.m
//  Chart
//
//  Created by ngw15 on 2019/2/20.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "AppDelegate.h"
#import "MainTabBarVC.h"
#import "QZHPushModel.h"
#import "GuidePageManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [NSafe fixed];
    [[CFDApp sharedInstance] preLoad];
    [self setRootVC];
//    [self setGuidePage];
    [QZHPushModel launch:application];
    if(launchOptions)
    {
        [QZHPushModel receive:application dict:launchOptions];
    }
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    // Override point for customization after application launch.
    return YES;
}

-(void)setRootVC{
    self.window = [[UIWindow alloc]  initWithFrame:CGRectMake(0, 0, SCREEN_MIN_LENGTH, SCREEN_MAX_LENGTH)];
    MainTabBarVC *tabBarController = [[MainTabBarVC alloc]init];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    if (@available(iOS 11.0, *)) {
        UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;//UIScrollView也适用
        UITableView.appearance.estimatedRowHeight = 0;
        UITableView.appearance.estimatedSectionHeaderHeight = 0;
        UITableView.appearance.estimatedSectionFooterHeight = 0;
        UITableView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}

-(void)setGuidePage{
    NSArray *guideArr;
    if (IS_IPHONE_X) {
        guideArr = @[@"glw_guide_58_1",@"glw_guide_58_2",@"glw_guide_58_3"];
    }else if (IS_IPHONE_6P){
        guideArr = @[@"glw_guide_55_1",@"glw_guide_55_2",@"glw_guide_55_3"];
    }else if (IS_IPHONE_6){
        guideArr = @[@"glw_guide_47_1",@"glw_guide_47_2",@"glw_guide_47_3"];
    }else if (IS_IPHONE_5){
        guideArr = @[@"glw_guide_40_1",@"glw_guide_40_2",@"glw_guide_40_3"];
    }else{
        guideArr = @[@"glw_guide_35_1",@"glw_guide_35_2",@"glw_guide_35_3"];
    }
    [GuidePageManager shareManagerWithPicArr:guideArr];
}
-(void)GuidePageDidLoadFinished{
    //    [self.marketTabVC showNoviceRecommended];
    //    [self.marketTabVC updateData];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


//MARK: - Push

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)pToken
{
    [[FTConfig sharedInstance] initWithDeviceToken:pToken];
}

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [application registerForRemoteNotifications];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [QZHPushModel receive:application dict:userInfo];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    completionHandler(UIBackgroundFetchResultNoData);
    [QZHPushModel receive:application dict:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"Regist fail%@",error);
}

//当程序从后台将要重新回到前台时候调用
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    NSLog(@"applicationWillEnterForeground");
    [DCService deviceSynctype:[UserModel isLogin]?@1:@0 success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end

//
//  BaseNC.m
//  globalwin
//
//  Created by 张洪林 on 2018/7/30.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "BaseNC.h"

@interface BaseNC ()

@end

@implementation BaseNC

+ (void)initialize{
    [self themeConfig];
}

+ (void)themeConfig{
    if ([CFDApp sharedInstance].isWhiteTheme) {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    }else{
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    UIColor *navBgColor = [GColorUtil C6];
    UINavigationBar *bar = [UINavigationBar appearance];
    [bar setBackgroundImage:[UIImage imageWithColor:navBgColor] forBarMetrics:UIBarMetricsDefault];
    [bar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[GColorUtil C2], NSForegroundColorAttributeName,[GUIUtil fitBoldFont:18], NSFontAttributeName,nil]];
    bar.translucent = NO;
}
- (void)dealloc{
    [self removeNotic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addNotic];
    // Do any additional setup after loading the view.
}

- (void)themeChangedAction{
    [BaseNC themeConfig];
}

- (void)addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
    [center addObserver:self
               selector:@selector(themeChangedAction)
                   name:ThemeDidChangedNotification
                 object:nil];
}

- (void)removeNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

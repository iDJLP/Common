//
//  GNetStatus.m
//  niuguwang
//
//  Created by BrightLi on 2017/11/8.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "GNetStatus.h"

@implementation GNetStatus

+ (instancetype) sharedInstance
{
    static dispatch_once_t onceToken;
    static GNetStatus * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[GNetStatus alloc] init];
    });
    return sharedInstance;
}

// 获得状态栏的网络状态
+ (NetworkStatus) statusBarNet
{
    GNetStatus *status=[GNetStatus sharedInstance];
    [status update];
    return status.type;
}

// 初始化
- (instancetype) init
{
    if (self = [super init])
    {
        _type= NotReachable;
        _operator=@"";
    }
    return self;
}

// 更新状态栏上的网络状态
- (void) update
{
    return;
    UIApplication *app=[UIApplication sharedApplication];
    __block NetworkStatus type=NotReachable;
    id statusBar=[app valueForKeyPath:@"statusBar"];
    BOOL iPhoneX=[statusBar isKindOfClass:NSClassFromString(@"UIStatusBar_Modern")];
    // 是否为iPhoneX手机
    if (iPhoneX) {
        // 是否开启飞行模式
        BOOL airPlance=[[app valueForKeyPath:@"statusBar.statusBar.currentData.airplaneModeEntry.enabled"] boolValue];
        if(airPlance){
            type=NotReachable;
        }else{
            // 是否开启WIFI网络
            BOOL wifiEnabled=[[app valueForKeyPath:@"statusBar.statusBar.currentData.wifiEntry.enabled"] boolValue];
            if(wifiEnabled){
                type=ReachableViaWiFi;
            }else{
                // 是否开启蜂窝网络
                BOOL wwanEnabled=[[app valueForKeyPath:@"statusBar.statusBar.currentData.cellularEntry.enabled"] boolValue];
                if(wwanEnabled){
                    // 0-无网络 3-2G 4-3G 5-4G
                    NSInteger wwanType=[[app valueForKeyPath:@"statusBar.statusBar.currentData.cellularEntry.type"] integerValue];
                    if(wwanType==0){
                        type=NotReachable;
                    }else if(wwanType==3){
                        type=ReachableViaWWAN;
                    }else if(wwanType==4){
                        type=ReachableViaWWAN;
                    }else if(wwanType==5){
                        type=ReachableViaWWAN;
                    }else{
                        type=NotReachable;
                    }
                    // 运营商名称
                    _operator=[app valueForKeyPath:@"statusBar.statusBar.currentData.cellularEntry.string"];
                }else{
                    type=NotReachable;
                }
            }
        }
        if(_type!=type){
            _type=type;
        }
        return;
    }
    NSArray *list = [[app valueForKeyPath:@"statusBar.foregroundView"] subviews];
    [list enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if([obj isKindOfClass:NSClassFromString(@"UIStatusBarAirplaneModeItemView")]){
            type=NotReachable;
        }else if ([obj isKindOfClass:NSClassFromString(@"UIStatusBarDataNetworkItemView")]) {
            // 0-无网络 1-2G 2-3G 3-4G 5-WIFI
            NSInteger netType = [[obj valueForKeyPath:@"dataNetworkType"] integerValue];
            if(netType==0){
                type=NotReachable;
            }else if(netType==1){
                type=ReachableViaWWAN;
            }else if(netType==2){
                type=ReachableViaWWAN;
            }else if(netType==3){
                type=ReachableViaWWAN;
            }else if(netType==5){
                type=ReachableViaWiFi;
            }else{
                type=NotReachable;
            }
            *stop=YES;
        }
    }];
    if(_type!=type){
        _type=type;
    }
}

@end

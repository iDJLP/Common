//
//  NNetState.m
//  niuguwang
//
//  Created by BrightLi on 2017/8/9.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "NNetState.h"
#import "GNetStatus.h"
#import "GLog.h"
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SystemConfiguration/CaptiveNetwork.h>
#import <objc/runtime.h>

@import CoreTelephony;

NSString *kNetStateChangedNoti=@"kNetStateChangedNoti";

@implementation NNetState

+ (instancetype) sharedInstance
{
    static dispatch_once_t onceToken;
    static NNetState * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[NNetState alloc] init];
    });
    return sharedInstance;
}

+ (void) launch
{
    [[self sharedInstance] launch];
}

+ (NetworkStatus) status
{
    return [NNetState sharedInstance].status;
}

+ (BOOL) isWiFi
{
    return ([NNetState status]==ReachableViaWiFi);
}

+ (BOOL) isWWAN
{
    return ([NNetState status]==ReachableViaWWAN);
}

// 是否为飞行模式
+ (BOOL) isAirplane
{
    CTTelephonyNetworkInfo *networkInfo;
    if(!networkInfo){
        networkInfo=[[CTTelephonyNetworkInfo alloc] init];
    }
    BOOL isAirplane=(networkInfo.currentRadioAccessTechnology==nil);
    return isAirplane;
}


+ (BOOL) isDisnet
{
    return [[self sharedInstance] isDisnet];
}

- (instancetype)init
{
    if (self = [super init]) {
    }
    return self;
}

- (void) launch
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reachabilityChanged:) name:kReachabilityChangedNotification object:nil];
    _reachability = [Reachability reachabilityWithHostName:@"www.apple.com"];
    _status = [_reachability currentReachabilityStatus];
    [_reachability startNotifier];
}

- (void) reachabilityChanged:(NSNotification *)notification
{
    Reachability *reachability = (Reachability *)notification.object;
    _status = [reachability currentReachabilityStatus];
    if(_task){
        [NTimeUtil cancelDelay:_task];
    }
    WEAK_SELF;
    [NTimeUtil run:^{
        weakSelf.type=[GNetStatus statusBarNet];
        [GLog output:[NNetState info],nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:kNetStateChangedNoti object:weakSelf];
    } delay:1];
}

// 获得当前WIFI连接名称
+ (NSString *)currentWiFi
{
    NSString *ssid = @"未知";
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    for (NSString *ifname in ifs) {
        NSDictionary *info = (__bridge id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifname);
        if (info[@"SSID"])
        {
            ssid = info[@"SSID"];
            break;
        }
    }
    return ssid;
}
// 网络信息
+ (NSString *) info
{
    NNetState *state=[NNetState sharedInstance];
    NSString *info=[NSString stringWithFormat:@"手机网络:%zd 状态条网络:%zd",state.status,state.type];
    return info;
}

// 是否断网-如果状态条存在网络状态不算断网
- (BOOL) isDisnet
{
    if(_status == NotReachable && _type == NotReachable){
        return YES;
    }
    return NO;
}

@end

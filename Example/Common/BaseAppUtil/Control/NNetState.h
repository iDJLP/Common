//
//  NNetState.h
//  niuguwang
//
//  Created by BrightLi on 2017/8/9.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//
#import "NTimeUtil.h"
#import "Reachability.h"
//#import "SEngine.h"

extern NSString *kNetStateChangedNoti;

@interface NNetState : NSObject

@property (nonatomic,strong) Reachability *reachability;
@property (nonatomic,assign) NetworkStatus status;
@property (nonatomic,assign) NetworkStatus type;
@property (nonatomic,strong) BKCancellationToken task;

+ (instancetype) sharedInstance;
+ (void) launch;
// 获得当前WIFI连接名称
+ (NSString *)currentWiFi;
// 是否连接了WiFi
+ (BOOL) isWiFi;
// 是否连接了蜂窝网络
+ (BOOL) isWWAN;
// 是否断网-如果状态条存在网络状态不算断网
+ (BOOL) isDisnet;
// 网络信息
+ (NSString *) info;

@end

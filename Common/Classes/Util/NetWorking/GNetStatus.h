//
//  GNetStatus.h
//  niuguwang
//
//  Created by BrightLi on 2017/11/8.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"

@interface GNetStatus:NSObject

@property(nonatomic,assign) NetworkStatus type;
@property(nonatomic,copy) NSString *operator;

// 单例
+ (instancetype) sharedInstance;
// 获得状态栏的网络状态
+ (NetworkStatus) statusBarNet;

@end

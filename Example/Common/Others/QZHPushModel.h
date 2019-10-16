//
//  QZHPushModel.h
//  niuguwang
//
//  Created by A on 2017/6/29.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

//推送类型
typedef NS_ENUM(NSInteger,PushType) {
    PushJumpNone = 0 ,//无
    PushJumpNotice = 1 ,//系统通知提醒
    PushJumpSettlement = 2,//交易提醒
    PushJumpNewsInfo = 3 ,//新闻资讯提醒
    PushJumpHangqing = 5 ,//行情提醒
};

@interface QZHPushModel : NSObject

// 启动
+ (void) launch:(UIApplication *)application;
// 启动
+ (void) launch;
// 接收通知
+ (void) receive:(UIApplication *)application dict:(NSDictionary *) userInfo;

+ (void) remoteReceive:(NSDictionary *)userInfo;

@end

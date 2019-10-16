//
//  DCHUD.h
//  niuguwang
//
//  Created by ngw15 on 2018/4/20.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTimeUtil.h"

@interface HUDUtil : NSObject

@property (nonatomic,copy)BKCancellationToken showTask;
@property (nonatomic,copy)BKCancellationToken hideTask;

+ (instancetype)sharedInstance;

+ (void)showInfo:(NSString *)string isHL:(BOOL)isHL;

+ (void)showError:(NSError *)error;
+ (void)showInfo:(NSString *)string;

+ (void)showInfo:(NSString *)string tinColor:(UIColor *)color;

+ (void)showProgress:(NSString *)string;

+ (void)showProgress:(NSString *)string delay:(CGFloat)delay;

+ (void)hide;

@end

//
//  NDebug.h
//  Test
//
//  Created by BrightLi on 2017/6/13.
//  Copyright © 2017年 BrightLi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol GLogDelegate <NSObject>

- (void) log:(NSString *) info;

@end

@interface GLog : NSObject<GLogDelegate>

@property(nonatomic,weak) id<GLogDelegate> delegate;

// GCD单例
+ (instancetype) sharedInstance;
// 发生异常时的堆栈日志
+ (void) stackLog:(NSException *)exception;
// 堆栈日志输出
+ (void) stackInfo:(NSString *) format, ... NS_FORMAT_FUNCTION(1,2);
// 异常打印
+ (void) error:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
// 输出到日志
+ (void) output:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
// 调试
+ (void) debug:(NSString *) info;

@end

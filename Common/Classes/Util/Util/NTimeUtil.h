//
//  NTimeUtil.h
//  计时工具类
//
//  Created by 李明 on 16/3/16.
//  Copyright © 2016年 李明. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef id <NSObject, NSCopying> BKCancellationToken;

@interface NTimeUtil:NSObject

@property (nonatomic,strong) NSMutableDictionary *timerList;

@property (nonatomic,strong) NSDateFormatter *formatter;

// GCD单例
+ (instancetype) sharedInstance;
+ (void) start;
+ (void) start:(NSString *)key;

+ (double) end;
+ (double) end:(NSString *)key;
// 计时结束
+ (double) end:(NSString *)key
       timeout:(unsigned int) timeout;
// 延后执行
+ (void) perform:(NSObject *)target
      method:(SEL) method
      object:(id) object
       delay:(NSTimeInterval) delay;
// 取消执行
+ (void) cancelPerform:(NSObject *)target
         method:(SEL) method
         object:(id) obejct;
// 是否已启动计时器
+ (BOOL) hasTimer:(NSString *)timerName;
// 启动计时器
+ (void) startTimer:(NSString *)timerName
           interval:(NSTimeInterval)interval
            repeats:(BOOL) repeats
             action:(void (^)(void))action;
/**
 启动计时器
 count：计时的次数
 action：每次触发的回调 count：第count次触发
 finishAction：计时器结束后的回调
 */
+ (void) startTimer:(NSString *)timerName
           interval:(NSTimeInterval)interval
       repeatCounts:(NSInteger)count
             action:(void (^)(NSInteger index))action
       finishAction:(dispatch_block_t)finishHander;
// 启动启动时器
+ (void) startBgTimer:(NSString *)timerName
             interval:(NSTimeInterval)interval
              repeats:(BOOL) repeats
               action:(void (^)(void))action;
// 停止计时器
+ (void) stopTimer:(NSString *) timerName;
// 停止所有计时器
+ (void) cancelAll;

// 延后执行
+ (BKCancellationToken) run:(dispatch_block_t) block
                      delay:(NSTimeInterval) delay;
// 取消执行
+ (void) cancelDelay:(BKCancellationToken) block;

/**转换字符串为"yyyy-MM-dd HH:mm:ss"格式到NSDate*/
+ (NSDate *) dencodeTime:(NSString *) dateString;

/**转换NSDate格式到NString*/
+ (NSString *) encodeTime:(NSDate *) date format:(NSString *) format;

/**某天到某天相差的天数  时间格式 1970-01-01*/
+ (NSString *) timeSince:(NSDate *)sinceDate to:(NSDate *)toDate;

/* 根据时间戳来显示时间 */
+ (NSString *) setTimeWithTimestamp:(NSString *)timestamp;

+ (BOOL)isweekday:(NSDate *)date;
@end

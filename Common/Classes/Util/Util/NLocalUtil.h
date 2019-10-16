
//
//  NLocalUtil.h
//  niuguwang
//
//  Created by 李明 on 16/8/18.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

@interface NLocalUtil : NSObject

// 读取本地数组
+ (NSArray *) arrayForKey:(NSString *)key;
// 读取字符串
+ (NSString *) stringForKey:(NSString *)key;
// 读取字符串数组
+ (NSArray *) stringArrayForKey:(NSString *)key;
// 读取布尔值
+ (BOOL) boolForKey:(NSString *)key;
// 保存整数
+ (void) setInt:(NSInteger) value forKey:(NSString *)key;
// 保存布尔值
+ (void) setBool:(BOOL) value forKey:(NSString *)key;
// 保存字符串
+ (void) setString:(NSString *) value forKey:(NSString *) key;
// 保存对象
+ (void) setObject:(id) value forKey:(NSString *) key;
// 读取整数
+ (NSInteger) intForKey:(NSString *)key
                  valid:(NSInteger) valid;
// 读取对象
+ (id) objectForKey:(NSString *)key;
// 是否有Key
+ (BOOL) hasKey:(NSString *) key;
// 保存元素到本地数组中
+ (void) addToArray:(NSString *)key target:(id) target;
// 删除数据
+ (void) removeForKey:(NSString *)key;

@end

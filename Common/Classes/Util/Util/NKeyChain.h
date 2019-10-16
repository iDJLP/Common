//
//  NKeyChain.h
//  niuguwang
//
//  Created by 李明 on 16/3/21.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NKeyChain:NSObject

// 保存字符串
+ (void) setString:(NSString *) data forKey:(NSString *)key;
// 保存BOOL到KeyChain
+ (void) setBool:(BOOL) value forKey:(NSString *) key;
+ (void) setInt:(NSInteger) value forKey:(NSString *) key;
+ (NSString *) stringForKey:(NSString *) key;
+ (BOOL) boolForKey:(NSString *) key;
+ (NSInteger) intForKey:(NSString *) key valid:(NSInteger) valid;
+ (void) setObject:(id) data forKey:(NSString *)key;
+ (NSArray *) arrayForKey:(NSString *) key;
+ (void) removeForKey:(NSString *)service;

@end

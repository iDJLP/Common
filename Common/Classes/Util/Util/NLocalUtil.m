//
//  NLocalUtil.m
//  niuguwang
//
//  Created by 李明 on 16/8/18.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "NLocalUtil.h"

@implementation NLocalUtil

// 获得本地数组
+ (NSArray *) arrayForKey:(NSString *)key
{
    if(key.length<1){
        return nil;
    }
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    return [def arrayForKey:key];
}
// 读取布尔值
+ (BOOL) boolForKey:(NSString *)key
{
    if(key.length<1){
        return NO;
    }
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    return [def boolForKey:key];
}
// 读取字符串数组
+ (NSArray *) stringArrayForKey:(NSString *)key
{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    return [def stringArrayForKey:key];
}
// 保存整数
+ (void) setInt:(NSInteger) value forKey:(NSString *)key
{
    if(key.length<1){
        return;
    }
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setInteger:value forKey:key];
    [def synchronize];
}
// 保存布尔值
+ (void) setBool:(BOOL) value forKey:(NSString *)key
{
    if(key.length<1){
        return;
    }
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setBool:value forKey:key];
    [def synchronize];
}
// 保存对象
+ (void) setObject:(id)value forKey:(NSString *) key
{
    if(key.length<1){
        return;
    }
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    if ([value isKindOfClass:NSDictionary.class]) {
        NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
        [[value allKeys] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (![[value objectForKey:obj] isKindOfClass:NSNull.class]) {
                [tempDic setObject:[value objectForKey:obj] forKey:obj];
            }
        }];
        value = tempDic;
    }
    [def setObject:value forKey:key];
    
    [def synchronize];
}
// 保存字符串
+ (void) setString:(NSString *) value forKey:(NSString *)key
{
    if(key.length<1){
        return;
    }
    if(value.length<1){
        value=@"";
    }
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def setObject:value forKey:key];
    [def synchronize];
}
// 读取整数
+ (NSInteger) intForKey:(NSString *)key
                  valid:(NSInteger) valid
{
    if(key.length<1){
        return valid;
    }
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if([def objectForKey:key]==nil){
        return valid;
    }
    NSInteger result=[def integerForKey:key];
    return result;
}
// 读取字符串
+ (NSString *) stringForKey:(NSString *)key
{
    if(key.length<1){
        return @"";
    }
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if([def objectForKey:key]==nil){
        return @"";
    }
    NSString *result=[def stringForKey:key];
    if(result==nil){
        return @"";
    }
    return result;
}
// 读取对象
+ (id) objectForKey:(NSString *)key
{
    if(key.length<1){
        return nil;
    }
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    return [def objectForKey:key];
}
// 是否有Key
+ (BOOL) hasKey:(NSString *) key{
    if(key.length<1){
        return NO;
    }
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    return ([def objectForKey:key]!=nil);
}
// 保存元素到本地数组中
+ (void) addToArray:(NSString *)key target:(id)target
{
    NSArray *result=[self arrayForKey:key];
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    if(result==nil){
        result=@[target];
        [def setObject:result forKey:key];
        [def synchronize];
    }else{
        NSMutableArray *save=[[NSMutableArray alloc] initWithArray:result];
        [save addObject:target];
        [def setObject:result forKey:key];
        [def synchronize];
    }
}

+ (void) removeForKey:(NSString *)key
{
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    [def removeObjectForKey:key];
    [def synchronize];
    return;
}

@end

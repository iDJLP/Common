//
//  NKeyChain.m
//  niuguwang
//
//  Created by 李明 on 16/3/21.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "NKeyChain.h"
#import "GLog.h"

@implementation NKeyChain

#pragma mark - 公共方法

// 保存数据到KeyChain
+ (void) setString:(NSString *) data forKey:(NSString *) key;
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

// 保存数据到KeyChain
+ (void) setObject:(id) data forKey:(NSString *) key;
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:data] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}

// 从KeyChain中加载数据
+ (NSString *) stringForKey:(NSString *) key
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            [GLog output:@"Unarchive of %@ failed: %@", key, e];
        } @finally {
        }
    }
    if (keyData!=nil){
        CFRelease(keyData);
    }
    return ret;
}
+ (void) setInt:(NSInteger) value forKey:(NSString *) key
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithInteger:value]] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}
// 保存BOOL到KeyChain
+ (void) setBool:(BOOL) value forKey:(NSString *) key;
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
    [keychainQuery setObject:[NSKeyedArchiver archivedDataWithRootObject:[NSNumber numberWithBool:value]] forKey:(id)kSecValueData];
    SecItemAdd((CFDictionaryRef)keychainQuery, NULL);
}
// 获得BOOL值
+ (BOOL) boolForKey:(NSString *) key
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            [GLog output:@"Unarchive of %@ failed: %@", key, e];
        } @finally {
        }
    }
    if (keyData!=nil){
        CFRelease(keyData);
    }
    if(!ret){
        return NO;
    }
    return [ret boolValue];
}
+ (NSInteger) intForKey:(NSString *) key valid:(NSInteger) valid
{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            [GLog output:@"Unarchive of %@ failed: %@", key, e];
        } @finally {
        }
    }
    if (keyData!=nil){
        CFRelease(keyData);
    }
    if(!ret){
        return valid;
    }
    return [ret integerValue];
}

+ (NSArray *) arrayForKey:(NSString *) key{
    id ret = nil;
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    [keychainQuery setObject:(id)kCFBooleanTrue forKey:(id)kSecReturnData];
    [keychainQuery setObject:(id)kSecMatchLimitOne forKey:(id)kSecMatchLimit];
    CFDataRef keyData = NULL;
    if (SecItemCopyMatching((CFDictionaryRef)keychainQuery, (CFTypeRef *)&keyData) == noErr) {
        @try {
            ret = [NSKeyedUnarchiver unarchiveObjectWithData:(__bridge NSData *)keyData];
        } @catch (NSException *e) {
            NSLog(@"Unarchive of %@ failed: %@", key, e);
        } @finally {
        }
    }
    if (keyData!=nil){
        CFRelease(keyData);
    }
    return ret;
}

// 从KeyChain中删除数据
+ (void) removeForKey:(NSString *) key
{
    NSMutableDictionary *keychainQuery = [self getKeychainQuery:key];
    SecItemDelete((CFDictionaryRef)keychainQuery);
}

#pragma mark - 私有方法

+ (NSMutableDictionary *) getKeychainQuery:(NSString *) key {
    return [NSMutableDictionary dictionaryWithObjectsAndKeys:
            (id)kSecClassGenericPassword,(id)kSecClass,
            key, (id)kSecAttrService,
            key, (id)kSecAttrAccount,
            (id)kSecAttrAccessibleAfterFirstUnlock,(id)kSecAttrAccessible,
            nil];
}

@end

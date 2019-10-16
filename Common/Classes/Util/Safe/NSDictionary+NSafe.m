//
//  NSDictionary+NSafe.m
//  niuguwang
//
//  Created by BrightLi on 2017/5/15.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "NSDictionary+NSafe.h"
#import "NSafe.h"

@implementation NSDictionary(NSafe)

+ (void) fixed
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSafe swizzleMethod:NSClassFromString(@"__NSPlaceholderDictionary")
                    original:@selector(initWithObjects:forKeys:count:)
                    swizzled:@selector(n_initWithObjects:forKeys:count:)];
    });
}

- (instancetype)n_initWithObjects:(const id[])objects forKeys:(const id <NSCopying>[])keys count:(NSUInteger)cnt
{
    id instance = nil;
    @try {
        instance = [self n_initWithObjects:objects forKeys:keys count:cnt];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
        //处理错误的数据，然后重新初始化一个字典
        NSUInteger index = 0;
        id _Nonnull __unsafe_unretained newObjects[cnt];
        id _Nonnull __unsafe_unretained newkeys[cnt];
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newkeys[index] = keys[i];
                index++;
            }
        }
        instance = [self n_initWithObjects:newObjects forKeys:newkeys count:index];
    }
    @finally {
        return instance;
    }
}

@end

@implementation NSMutableDictionary(NSafe)

+ (void) fixed
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls=NSClassFromString(@"__NSDictionaryM");
        [NSafe swizzleMethod:cls
                    original:@selector(setObject:forKey:)
                    swizzled:@selector(n_setObject:forKey:)];
    });
}

- (void)n_setObject:(id)obj forKey:(id<NSCopying>)key
{
    @synchronized (self) {
        @try {
            [self n_setObject:obj forKey:key];
        }
        @catch (NSException *exception) {
            [GLog stackLog:exception];
        }
    }
}

@end

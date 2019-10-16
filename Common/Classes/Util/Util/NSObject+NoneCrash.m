//
//  NSObject+NoneCrash.m
//  niuguwang
//
//  Created by wei on 15/7/7.
//  Copyright (c) 2015年 taojinzhe. All rights reserved.
//

#import "NSObject+NoneCrash.h"

@implementation NSArray (NoneCrash)

- (id)objectAtIndexSafe:(NSUInteger)index
{
    if (index >= [self count]) {
        return nil;
    }
    
    id value = [self objectAtIndex:index];
    if (value == [NSNull null]) {
        return nil;
    }
    return value;
}

@end



@implementation NSMutableArray (NoneCrash)
- (void)addObjectSafe:(id)anObject {
    if (anObject) {
        [self addObject:anObject];
    }
}

- (void)insertObjectSafe:(id)anObject atIndex:(NSUInteger)index {
    if (anObject && index <= self.count) {
        [self insertObject:anObject atIndex:index];
    }
}
@end


@implementation NSObject (NoneCrash)

- (NSString *)ngwStringValue {
    
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    }
    return @"";
}

@end

@implementation NSDictionary (NoneCrash)
- (id)objectForKeySafe:(NSString*)strKey
{
    id value = [self  objectForKey:strKey];
/*    加 了[value isEqualToString:@"<null>"] 对非nsstring会有问题
    {
        if ([value isKindOfClass: [NSNull class]] || value==nil || value==NULL || [value isEqualToString:@"<null>"])
        {
            return @"";
        }
    }*/
    if ([value isKindOfClass: [NSNull class]] || value==nil || value==NULL)
    {
        return @"";
    }
    return value;
}

- (NSString *)stringForKey:(NSString *)key {
    
    NSString * value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    }
    return @"";
}

- (NSArray *)arrayForKey:(NSString *)key {
    
    NSArray * value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    }
    
    return [NSArray array];
}

@end

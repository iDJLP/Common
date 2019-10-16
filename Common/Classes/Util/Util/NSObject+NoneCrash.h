//
//  NSObject+NoneCrash.h
//  niuguwang
//
//  Created by wei on 15/7/7.
//  Copyright (c) 2015年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (NoneCrash)
- (id)objectAtIndexSafe:(NSUInteger)index;
@end

@interface NSMutableArray (NoneCrash)
- (void)addObjectSafe:(id)anObject;
- (void)insertObjectSafe:(id)anObject atIndex:(NSUInteger)index;
@end

@interface NSObject (NoneCrash)

- (NSString *)ngwStringValue;

@end


@interface NSDictionary (NoneCrash)
- (id)objectForKeySafe:(NSString*)strKey;
- (NSString *)stringForKey:(NSString *)key;
- (NSArray *)arrayForKey:(NSString *)key;
@end
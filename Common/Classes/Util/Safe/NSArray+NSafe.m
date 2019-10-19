//
//  NSArray+NSafe.m
//  niuguwang
//
//  Created by BrightLi on 2017/5/15.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "NSArray+NSafe.h"
#import "NSafe.h"

@implementation NSArray(NSafe)

+ (void) fixed
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSafe swizzleMethod:NSClassFromString(@"NSArray")
                    original:@selector(objectsAtIndexes:)
                    swizzled:@selector(n_objectAtIndexes:)];
        [NSafe swizzleMethod:NSClassFromString(@"NSArray")
                    original:@selector(subarrayWithRange:)
                    swizzled:@selector(n_subarrayWithRange:)];
        [NSafe swizzleMethod:NSClassFromString(@"__NSArrayI")
                    original:@selector(objectAtIndex:)
                    swizzled:@selector(n_objectAtIndex:)];
        [NSafe swizzleMethod:NSClassFromString(@"__NSArrayI")
                    original:@selector(objectAtIndexedSubscript:)
                    swizzled:@selector(n_objectAtIndexedSubscript:)];
        [NSafe swizzleMethod:NSClassFromString(@"__NSArrayI")
                    original:@selector(getObjects:range:)
                    swizzled:@selector(n_getObjects:range:)];
        [NSafe swizzleMethod:NSClassFromString(@"__NSPlaceholderArray")
                    original:@selector(initWithObjects:count:)
                    swizzled:@selector(n_initWithObjects:count:)];
        float ios=[[[UIDevice currentDevice] systemVersion] floatValue];
        // iOS10以上，单个元素的数组类型是 __NSSingleObjectArrayI
        if(ios>10.0f){
            [NSafe swizzleMethod:NSClassFromString(@"__NSSingleObjectArrayI")
                        original:@selector(objectAtIndex:)
                        swizzled:@selector(n_objectAtIndex1:)];
        }
        // iOS9以上,空数组类型是 __NSArray0
        if(ios>=9.0f){
            [NSafe swizzleMethod:NSClassFromString(@"__NSArray0")
                        original:@selector(objectAtIndex:)
                        swizzled:@selector(n_objectAtIndex0:)];
        }
    });
}

-(id) n_initWithObjects:(const id [])objects
                  count:(NSUInteger)cnt
{
    id object=nil;
    @try {
        object = [self n_initWithObjects:objects count:cnt];
    }
    @catch (NSException *exception) {
        [GLog stackLog:exception];
    }
    @finally {
        return object;
    }
}
- (id) n_objectAtIndex:(NSUInteger)index
{
    if(index>=self.count){
        [GLog stackInfo:@"[__NSArrayI objectAtIndex:]索引[%zd]越界[%zd]",
                      index,self.count];
        return nil;
    }
    return  [self n_objectAtIndex:index];
}
- (id) n_objectAtIndexedSubscript:(NSUInteger) index
{
    if(index>=self.count){
        [GLog stackInfo:@"[__NSArrayI objectAtIndexedSubscript:]索引[%zd]越界[%zd]",
         index,self.count];
        return nil;
    }
    return  [self n_objectAtIndexedSubscript:index];
}
// __NSSingleObjectArrayI 只有一个元素
- (id) n_objectAtIndex1:(NSUInteger)index
{
    if(index>=self.count){
        [GLog stackInfo:@"[__NSSingleObjectArrayI objectAtIndex:]索引[%zd]越界[%zd]",
                      index,self.count];
        return nil;
    }
    return [self n_objectAtIndex1:index];
}
// __NSArray0 没有元素，也不可以改变
- (id) n_objectAtIndex0:(NSUInteger)index
{
    [GLog stackInfo:@"[__NSArray0 objectAtIndex:] 无效的索引:%zd",index];
    return nil;
}

- (NSArray *) n_subarrayWithRange:(NSRange )range
{
    if(range.location+range.length<=self.count){
        return [self n_subarrayWithRange:range];
    }else if(range.location<self.count){
        return [self n_subarrayWithRange:NSMakeRange(range.location, self.count-range.location)];
    }
    [GLog stackInfo:@"[NSArray subarrayWithRange:] 索引超出范围:{%zd,%zd}",
                  range.location,range.length];
    return nil;
}

- (void) n_getObjects:(__unsafe_unretained id _Nonnull *)objects
                range:(NSRange)range
{
    @try {
        [self n_getObjects:objects range:range];
    } @catch (NSException *exception) {
        [GLog stackLog:exception];
    } @finally {
    }
}

- (NSArray *) n_objectAtIndexes:(NSIndexSet *)indexes
{
    if(!indexes || [self count]<1){
        return [[NSArray alloc] init];
    }
    __block NSMutableArray *result=[[NSMutableArray alloc] init];
#if __has_feature(objc_arc)
    __weak typeof(self) weakSelf=self;
#else
    __block typeof(self) weakSelf=self;
#endif
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        if(idx<[self count]){
            [result addObject:[weakSelf objectAtIndex:idx]];
        }
    }];
    return [result copy];
}

@end

//
//  NSMutableArray+NSafe.m
//  niuguwang
//
//  Created by BrightLi on 2017/5/15.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "NSMutableArray+NSafe.h"
#import "NSafe.h"

@implementation NSMutableArray(NSafe)

#if __has_feature(objc_arc)
//#error NSMutableArray+NSafe必须是MRC.请使用编译参数: -fno-objc-arc
#endif

+ (void) fixed
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls=NSClassFromString(@"__NSArrayM");
        [NSafe swizzleMethod:cls
                    original:@selector(addObject:)
                    swizzled:@selector(n_addObject:)];
        [NSafe swizzleMethod:cls
                    original:@selector(objectAtIndex:)
                    swizzled:@selector(n_objectAtIndex:)];
        [NSafe swizzleMethod:cls
                    original:@selector(setObject:atIndexedSubscript:)
                    swizzled:@selector(n_setObject:atIndexedSubscript:)];
        [NSafe swizzleMethod:cls
                    original:@selector(removeObjectAtIndex:)
                    swizzled:@selector(n_removeObjectAtIndex:)];
        [NSafe swizzleMethod:cls
                    original:@selector(insertObject:atIndex:)
                    swizzled:@selector(n_insertObject:atIndex:)];
        [NSafe swizzleMethod:cls
                    original:@selector(replaceObjectAtIndex:withObject:)
                    swizzled:@selector(n_replaceObjectAtIndex:withObject:)];
        [NSafe swizzleMethod:cls
                    original:@selector(getObjects:range:)
                    swizzled:@selector(n_getObjects:range:)];
    });
}

- (void) n_addObject:(id)anObject
{
    if(!anObject){
        [GLog stackInfo:@"[__NSArrayM addObject:]不能加入空值",nil];
        return;
    }
    [self n_addObject:anObject];
}
// 访问下标
- (id) n_objectAtIndex:(NSUInteger)index
{
    if (index <self.count){
        return [self n_objectAtIndex:index];
    }
    [GLog stackInfo:@"[__NSArrayM objectAtIndex:]索引[%zd]出界[%zd]",index,self.count];
    return nil;
}

- (void) n_setObject:(id)obj atIndexedSubscript:(NSUInteger)index
{
    if(!obj){
        [GLog stackInfo:@"[__NSArrayM setObject:atIndexedSubscript:]:不能设置空值",nil];
        return;
    }
    if(index>self.count){
        [GLog stackInfo:@"[__NSArrayM setObject:atIndexedSubscript:]索引[%zd]出界[%zd]",
                      index,self.count];
        return;
    }
    [self n_setObject:obj atIndexedSubscript:index];
}

- (void) n_insertObject:(id)anObject atIndex:(NSUInteger)index
{
    if (!anObject) {
        [GLog stackInfo:@"[__NSArrayM n_insertObject:atIndex:]插入不能为空值"];
        return;
    }
    if(index>self.count){
        [GLog stackInfo:@"[__NSArrayM n_insertObject:atIndex:]索引[%zd]出界[%zd]",
                                        index,anObject];
        return;
    }
    [self n_insertObject:anObject atIndex:index];
}

- (void) n_removeObjectAtIndex:(NSUInteger)index
{
    if(index>=self.count){
        [GLog stackInfo:@"[__NSArrayM removeObjectAtIndex:]索引[%zd]出界[%zd]",
                      index,self.count];
        return;
    }
    [self n_removeObjectAtIndex:index];
}
// 替换元素检查
- (void) n_replaceObjectAtIndex:(NSUInteger)index
                     withObject:(id)anObject
{
    if (!anObject) {
        [GLog stackInfo:@"[__NSArrayM n_replaceObjectAtIndex:withObject:]替换不能为空值"];
        return;
    }
    if (index >= self.count) {
        [GLog stackInfo:@"[__NSArrayM n_replaceObjectAtIndex:withObject:]索引[%zd]出界[%zd]",
                      index,anObject];
        return;
    }
    [self n_replaceObjectAtIndex:index withObject:anObject];
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

@end


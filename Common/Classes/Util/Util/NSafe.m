//
//  NSafe.m
//  安全类
//
//  Created by BrightLi on 2016/12/22.
//  Copyright © 2016年 TJZ. All rights reserved.
//

#import "NSafe.h"
#import <objc/runtime.h>



@implementation MyAssertHandler

//处理OC的断言
- (void) handleFailureInMethod:(SEL)selector object:(id)object file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format,...
{
    NSString *info=[NSString stringWithFormat:@"NSAssert-OC断言:方法 %@ 对象 %@ #%@#%li", NSStringFromSelector(selector), object, fileName, (long)line];
    [GLog output:@"%@",info];
}
//处理C的断言
- (void) handleFailureInFunction:(NSString *)functionName file:(NSString *)fileName lineNumber:(NSInteger)line description:(NSString *)format,...
{
    NSString *info=[NSString stringWithFormat:@"NSCAssert-C断言:方法 %@ %@#%li", functionName, fileName, (long)line];
    [GLog output:@"%@",info];
}
@end

@interface UIView (NSafe)
// 检查是否在主线程中操作
+(void) checkMainQueue;

@end

@implementation UIView(NSafe)

// 检查是否在主线程中操作
+(void) checkMainQueue
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSafe swizzleMethod:[self class]
                    original:@selector(setNeedsLayout)
                    swizzled:@selector(n_setNeedsLayout)];
        [NSafe swizzleMethod:[self class]
                    original:@selector(setNeedsDisplay)
                    swizzled:@selector(n_setNeedsDisplay)];
        [NSafe swizzleMethod:[self class]
                    original:@selector(setNeedsDisplayInRect:)
                    swizzled:@selector(n_setNeedsDisplayInRect:)];
        [NSafe swizzleMethod:[self class]
                    original:@selector(setNeedsUpdateConstraints)
                    swizzled:@selector(n_setNeedsUpdateConstraints)];
    });
}

- (void) n_setNeedsLayout
{
    if(![NSafe isMainQueue]){
        [GLog stackInfo:@"UIKit必须在主线程操作:%@",self.class];
#if DEBUG
        NSAssert(YES,@"UIKit必须在主线程操作");
#endif
        WEAK_SELF;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf n_setNeedsLayout];
        });
    }else{
        [self n_setNeedsLayout];
    }
}

- (void) n_setNeedsDisplay
{
    if(![NSafe isMainQueue]){
        [GLog stackInfo:@"UIKit必须在主线程操作:%@", self.class];
#if DEBUG
        NSAssert(YES,@"UIKit必须在主线程操作");
#endif
        WEAK_SELF;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf n_setNeedsDisplay];
        });
    }else{
        [self n_setNeedsDisplay];
    }
}

- (void) n_setNeedsDisplayInRect:(CGRect)rect
{
    if(![NSafe isMainQueue]){
        [GLog stackInfo:@"UIKit必须在主线程操作:%@", self.class];
#if DEBUG
        NSAssert(YES,@"UIKit必须在主线程操作");
#endif
        WEAK_SELF;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf n_setNeedsDisplayInRect:rect];
        });
    }else{
        [self n_setNeedsDisplayInRect:rect];
    }
}

-(void) n_setNeedsUpdateConstraints
{
    if(![NSafe isMainQueue]){
        [GLog stackInfo:@"UIKit必须在主线程操作:%@", self.class];
#if DEBUG
        NSAssert(YES,@"UIKit必须在主线程操作");
#endif
        WEAK_SELF;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf n_setNeedsUpdateConstraints];
        });
    }else{
        [self n_setNeedsUpdateConstraints];
    }
}

@end

@implementation NSafe

+ (void) swizzleMethod:(Class) cls
              original:(SEL) original
              swizzled:(SEL) swizzled
{
    Method originalMethod = class_getInstanceMethod(cls, original);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzled);
    if(!originalMethod||!swizzledMethod){
        return;
    }
    BOOL success=class_addMethod(cls,original,method_getImplementation(swizzledMethod),method_getTypeEncoding(swizzledMethod));
    if(success){
        class_replaceMethod(cls,swizzled,method_getImplementation(originalMethod),method_getTypeEncoding(originalMethod));
    }else{
        method_exchangeImplementations(originalMethod,swizzledMethod);
    }
}

// 修正闪退
+ (void) fixed
{
    dispatch_queue_t currentQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(currentQueue, ^{
        [NSObject fixed];
        [NSArray fixed];
        [NSMutableArray fixed];
        [NSMutableDictionary fixed];
        [NSDictionary fixed];
        [NSMutableDictionary fixed];
        [NSString fixed];
        [NSMutableString fixed];
        [NSAttributedString fixed];
        [NSMutableAttributedString fixed];
        [NSSet fixed];
        [UINavigationController fixed];
        [UIView checkMainQueue];
        [GLog output:@"启动数据安全"];
#if DEBUG
        [UIApplication fixed];
#endif
    });
     
}
// 更安全的主线程检查
+ (BOOL) isMainQueue
{
    static const void* mainQueueKey = @"mainQueue";
    static void* mainQueueContext = @"mainQueue";
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_queue_set_specific(dispatch_get_main_queue(), mainQueueKey, mainQueueContext, nil);
    });
    return dispatch_get_specific(mainQueueKey) == mainQueueContext;
}

@end

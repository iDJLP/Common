//
//  NSSafe.h
//  安全类
//
//  Created by BrightLi on 2016/12/22.
//  Copyright © 2016年 TJZ. All rights reserved.
//

//void (^SafeAssertCallback)(const char *, int, NSString *, ...);

#import "NSObject+NSafe.h"
#import "NSArray+NSafe.h"
#import "NSMutableArray+NSafe.h"
#import "NSDictionary+NSafe.h"
#import "NSString+NSafe.h"
#import "NSSet+NSafe.h"
#import "Util.h"

@interface MyAssertHandler : NSAssertionHandler
@end

@interface NSafe : NSObject

+ (void) swizzleMethod:(Class) cls
              original:(SEL) original
              swizzled:(SEL) swizzled;
// 修正闪退
+ (void) fixed;
// 更安全的主线程检查
+ (BOOL) isMainQueue;

@end



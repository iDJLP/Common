//
//  NSSet+NSafe.m
//  niuguwang
//
//  Created by BrightLi on 2017/6/15.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "NSSet+NSafe.h"
#import "NSafe.h"
#import "Util.h"

@implementation NSSet(NSafe)

+ (void) fixed
{
    static dispatch_once_t onceToken;
    //__NSPlaceholderSet initWithObjects:count:

    dispatch_once(&onceToken, ^{
        [NSafe swizzleMethod:NSClassFromString(@"__NSPlaceholderSet")
                    original:@selector(initWithObjects:count:)
                    swizzled:@selector(n_initWithObjects:count:)];
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

@end

//
//  GDevice.h
//  niuguwang
//
//  Created by BrightLi on 2017/11/7.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifdef NS_ASSUME_NONNULL_BEGIN
NS_ASSUME_NONNULL_BEGIN
#endif

@interface GDevice : NSObject

+ (NSString *) platformSystem;
+ (NSString *) platformFull;
+ (NSString *) platformSimple;

@end

#ifdef NS_ASSUME_NONNULL_END
NS_ASSUME_NONNULL_END
#endif

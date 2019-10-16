//
//  PhoneVerifyAlert.h
//  Bitmixs
//
//  Created by ngw15 on 2019/5/17.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PhoneVerifyAlert : NSObject

+ (void)showAlert:(dispatch_block_t)sureHander key1:(NSString *)key1 key2:(NSString *)key2 googleCode:(NSString *)googleCode;
+ (void)hide;

@end

NS_ASSUME_NONNULL_END

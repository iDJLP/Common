//
//  AuthAlert.h
//  Bitmixs
//
//  Created by ngw15 on 2019/5/17.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AuthAlert : NSObject

+ (void)showAlert:(dispatch_block_t)sureHander;
+ (void)showAlert:(dispatch_block_t)sureHander closeHander:(dispatch_block_t)closeHander;
+ (void)hide;

@end

NS_ASSUME_NONNULL_END

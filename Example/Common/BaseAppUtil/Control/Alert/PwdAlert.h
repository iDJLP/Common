//
//  PwdAlert.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/28.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PwdAlert : NSObject

+ (void)showAlert:(dispatch_block_t)sureHander;
+ (void)hide;

@end

NS_ASSUME_NONNULL_END

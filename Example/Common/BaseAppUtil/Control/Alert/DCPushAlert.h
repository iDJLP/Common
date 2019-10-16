//
//  DCPushAlert.h
//  LiveTrade
//
//  Created by ngw15 on 2019/1/4.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCPushAlert : NSObject

+ (void)showContent:(NSString *)content title:(NSString *)title tapAction:(dispatch_block_t)tapHandler;
+ (void)hide;

@end

NS_ASSUME_NONNULL_END

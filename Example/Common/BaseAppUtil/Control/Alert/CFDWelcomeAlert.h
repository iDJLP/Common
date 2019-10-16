//
//  CFDWelcomeAlert.h
//  LiveTrade
//
//  Created by ngw15 on 2018/11/19.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFDWelcomeAlert : NSObject

+ (void)showAlert:(NSString *)title
           detail:(id)detail
        sureTitle:(NSString *)sure
       sureHander:(dispatch_block_t)sureHander;
+ (void)hide;

@end

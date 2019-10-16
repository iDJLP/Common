//
//  DCLoginVC.h
//  niuguwang
//
//  Created by ngw15 on 2018/3/29.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCLoginVC : UIViewController

+ (void)jumpTo:(dispatch_block_t)loginSucessBlock;

+ (void)jumpToRegister:(dispatch_block_t)loginSucessBlock;

@end

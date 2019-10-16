//
//  DCRegisterVC.h
//  niuguwang
//
//  Created by ngw15 on 2018/3/30.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCRegisterVC : UIViewController

+ (void)jumpTo:(UIViewController *)current successHander:(dispatch_block_t)successHander;

@end

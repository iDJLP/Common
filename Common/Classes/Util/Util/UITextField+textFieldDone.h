//
//  UITextField+textFieldDone.h
//  niuguwang
//
//  Created by jly on 2017/6/23.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (textFieldDone)

- (void)addToolbar;
- (void)addToolBarDoneAndSwitch:(void (^)(BOOL))hander nextEnable:(BOOL)nextEnable prevEnable:(BOOL)prevEnable;

@end

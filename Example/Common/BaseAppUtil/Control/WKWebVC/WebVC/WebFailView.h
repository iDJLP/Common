//
//  WebFailView.h
//  globalwin
//
//  Created by ngw15 on 2018/8/7.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebVC.h"

@interface WebFailView : UIView

- (instancetype)initWithType:(WebVCType)type onReload:(dispatch_block_t)reloadHander;

@end

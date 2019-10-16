//
//  MessageVC.h
//  niuguwang
//
//  Created by A on 2017/6/30.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    QZHMessageType_system,
    QZHMessageType_market,
    QZHMessageType_trade,
} QZHMessageType;

@interface QZHMessageVC : NBaseVC

@property (nonatomic,assign)QZHMessageType messageType;

@end

//
//  CFDAlertFrequencyVC.h
//  qzh_ftox
//
//  Created by jly on 2017/11/24.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlertFrequencyVC : NBaseVC

////提醒级别 1 仅提醒一次 2 每日提醒 3 每次提醒
@property (nonatomic,copy)NSString *alertrate;

@property (nonatomic,copy)void (^setAlertrateBlock)(NSString *);
@end

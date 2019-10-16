//
//  QRCodeVC.h
//  qzh_ftox
//
//  Created by ngw15 on 2018/4/18.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBaseVC.h"

@interface QRCodeVC : NBaseVC
+ (void)jumpToFetchAddress:(void(^)(NSString *address))hander;
@end

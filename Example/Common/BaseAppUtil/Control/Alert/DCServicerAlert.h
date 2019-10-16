//
//  DCServicerAlert.h
//  LiveTrade
//
//  Created by ngw15 on 2018/11/8.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCServicerAlert : NSObject

+ (void)showAlert:(NSDictionary *)dict
     cancelHander:(dispatch_block_t)cancelHander;

@end

//
//  FCUpdateAlert.h
//  newfcox
//
//  Created by ngw15 on 2018/4/26.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FCUpdateAlert : NSObject

+ (void)show;
+(void)checkVersion:(void(^)(NSDictionary *))hander failure:(dispatch_block_t)failure;

@end

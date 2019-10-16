//
//  NUDID.h
//  ngw-os
//
//  Created by 李明 on 16/3/27.
//  Copyright © 2016年 李明. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NUDID : NSObject

// 获得设备唯一ID
+ (NSString *) deviceId;
// 获得IDFA
+ (NSString *) idfa;

@end

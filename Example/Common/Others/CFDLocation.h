//
//  QZHLocation.h
//  niuguwang
//
//  Created by ngw15 on 2018/3/1.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CFDLocation : NSObject

@property (nonatomic,copy) NSString *ipUrl;

@property (nonatomic,copy) NSString *locationInfo;
@property (nonatomic,copy) NSString *ipInfo;

+ (instancetype)sharedInstance;

- (void)startLocation;

- (void)getIpInfo;

@end

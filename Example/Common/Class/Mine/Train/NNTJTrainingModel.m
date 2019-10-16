//
//  NNTJTrainingModel.m
//  niuguwang
//
//  Created by A on 2017/8/2.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "NNTJTrainingModel.h"
#import "DCService.h"

@implementation NNTJTrainingModel

// GCD单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static NNTJTrainingModel * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[NNTJTrainingModel alloc] init];
    });
    return sharedInstance;
}

- (void)postInvestmentCamp:(NSString *)category
                   success:(void (^)(id))success
                   failure:(void (^)(id))failure
{
    [DCService postInvestmentCamp:category success:^(id data) {
        if ([data isKindOfClass:[NSDictionary class]]) {
            
            if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
                if (success) {
                    success(data);
                }
            } else {
                if (failure) {
                    failure([FTConfig webTips]);
                }
            }
        } else {
            if (failure) {
                failure([FTConfig webTips]);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end

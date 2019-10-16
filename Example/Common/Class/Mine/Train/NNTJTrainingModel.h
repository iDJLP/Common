//
//  NNTJTrainingModel.h
//  niuguwang
//
//  Created by A on 2017/8/2.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NNTJTrainingModel : NSObject

+ (instancetype)sharedInstance;

//列表
- (void)postInvestmentCamp:(NSString *)category
                   success:(void (^)(id))success
                   failure:(void (^)(id))failure;

@end

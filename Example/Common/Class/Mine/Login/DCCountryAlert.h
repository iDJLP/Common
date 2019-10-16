//
//  DCCountryAlert.h
//  Bitmixs
//
//  Created by ngw15 on 2019/6/5.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCCountryAlert : NSObject

+ (void)showAlert:(NSString *)countryId selectedHander:(void (^)(NSDictionary *dic))selectedHander;

@end

NS_ASSUME_NONNULL_END

//
//  CurrenttypeSelectedSheet.h
//  Bitmixs
//
//  Created by ngw15 on 2019/10/11.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CurrenttypeSelectedSheet : NSObject

+ (void)showAlert:(NSString *)title
         selected:(NSString *)selected
       sureHander:(void(^)(NSDictionary *))sureHander;
+ (void)loadVarityLogo:(NSString *)selected success:(void (^)(NSString *imgName))hander;

@end

NS_ASSUME_NONNULL_END

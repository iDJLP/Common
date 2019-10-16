//
//  Popover.h
//  Bitmixs
//
//  Created by ngw15 on 2019/9/10.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Popover : NSObject

+ (void)showAlert:(NSArray *)list
             point:(CGPoint)point
       sureHander:(void (^)(NSDictionary *dict))sureHander;

@end

NS_ASSUME_NONNULL_END

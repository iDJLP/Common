//
//  AddressSelectedSheet.h
//  Bitmixs
//
//  Created by ngw15 on 2019/10/11.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressSelectedSheet : NSObject

+ (void)showAlert:(NSString *)title
  selected:(NSString *)selected
      type:(NSString *)type
       sureHander:(void(^)(NSDictionary *))sureHander;

@end

NS_ASSUME_NONNULL_END

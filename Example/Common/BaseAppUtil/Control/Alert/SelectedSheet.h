//
//  SelectedSheet.h
//  Bitmixs
//
//  Created by ngw15 on 2019/6/11.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectedSheet : NSObject

+ (void)showAlert:(NSString *)title
         dataList:(NSArray *)dataList
       sureHander:(void(^)(NSDictionary *))sureHander;

@end

NS_ASSUME_NONNULL_END

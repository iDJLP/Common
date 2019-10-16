//
//  Calculator1View.h
//  Bitmixs
//
//  Created by ngw15 on 2019/9/11.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface Calculator1View : UIScrollView

- (void)willAppear;

- (void)configView:(NSDictionary *)dict;
- (void)updatePrice:(NSDictionary *)price;
- (UITextField *)firstRespondField;
@end

NS_ASSUME_NONNULL_END

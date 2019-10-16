//
//  SecurityVerifyView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/5/17.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface SecurityVerifyView : BaseView

@property (nonatomic,copy)dispatch_block_t pwdChangedHander;

- (NSString *)pwdText;

- (void)becomeFirstRespond;

@end

NS_ASSUME_NONNULL_END

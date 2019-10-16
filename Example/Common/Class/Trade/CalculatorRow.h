//
//  CalculatorRow.h
//  Bitmixs
//
//  Created by ngw15 on 2019/9/11.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalculatorRow : BaseView

@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,copy)dispatch_block_t textChangedHander;
@property (nonatomic,assign) BOOL isRightLabel;
@property (nonatomic,copy) NSString *minFloat;
- (void)configView:(NSDictionary *)config;

- (UITextField *)firstRespondField;

- (NSString *)text;

@end

NS_ASSUME_NONNULL_END

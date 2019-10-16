//
//  CalculatorVC.h
//  Bitmixs
//
//  Created by ngw15 on 2019/9/10.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "NBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface CalculatorVC : NBaseVC

+ (CalculatorVC *)jumpTo:(NSDictionary *)config;

- (void)updatePrice:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

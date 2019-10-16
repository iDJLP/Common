//
//  TradeVC.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/18.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "NBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface TradeVC : NBaseVC

+ (void)jumpTo:(NSString *)symbol;
+ (void)jumpTo:(NSString *)symbol isBuy:(BOOL)isBuy;

@end

NS_ASSUME_NONNULL_END

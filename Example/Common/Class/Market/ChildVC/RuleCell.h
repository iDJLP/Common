//
//  RuleCell.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/26.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface RuleCell : BaseCell

+ (CGFloat)heightOfCell:(NSDictionary *)dict;
- (void)configOfCell:(NSDictionary *)dict isSingle:(BOOL)isSingle;

@end

NS_ASSUME_NONNULL_END

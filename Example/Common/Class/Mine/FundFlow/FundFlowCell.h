//
//  FundFlowCell.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/20.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FundFlowCell : BaseCell

+ (CGFloat)heightOfCell:(NSDictionary *)dict;

- (void)configCell:(NSDictionary *)model;

@end

NS_ASSUME_NONNULL_END

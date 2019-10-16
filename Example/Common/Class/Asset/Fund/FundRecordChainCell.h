//
//  FundRecordChainCell.h
//  Bitmixs
//
//  Created by ngw15 on 2019/4/26.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FundRecordChainCell : BaseCell

+ (CGFloat)heightOfCell;
- (void)configCell:(NSDictionary *)model;

@end

NS_ASSUME_NONNULL_END

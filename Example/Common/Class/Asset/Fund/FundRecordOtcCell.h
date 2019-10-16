//
//  FundRecordOtcCell.h
//  Bitmixs
//
//  Created by ngw15 on 2019/4/26.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface FundRecordOtcCell : BaseCell

+ (CGFloat)heightOfCell;

@property (nonatomic,copy) dispatch_block_t reloadHander;

- (void)configCell:(NSDictionary *)model;


@end

NS_ASSUME_NONNULL_END

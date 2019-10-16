//
//  AssetDetailCell.h
//  Bitmixs
//
//  Created by ngw15 on 2019/6/12.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetDetailCell : BaseCell

+ (CGFloat)heightOfCell;
- (void)configOfCell:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

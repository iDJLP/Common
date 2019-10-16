//
//  AddressCell.h
//  Bitmixs
//
//  Created by ngw15 on 2019/10/9.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface AddressCell : BaseCell

+ (CGFloat)heightOfCell;
- (void)configCell:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

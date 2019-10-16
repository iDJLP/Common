//
//  PosHisCell.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/25.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "TableView.h"
#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PosHisCell : BaseCell

@property (nonatomic,copy)dispatch_block_t reloadDataHander;

+ (CGFloat)heightOfCell:(NSMutableDictionary *)dict;
- (void)configCell:(NSMutableDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

//
//  PosCell.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/23.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseCell.h"
#import "OrderKeyBoardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PosCell : BaseCell

@property (nonatomic,copy)OrderKeyBoardView *(^setterSLTPHaner)(OrderKeyBoardType type,NSDictionary *dic);
@property (nonatomic,copy)void (^closePosAction)(NSMutableDictionary *);
@property (nonatomic,copy)dispatch_block_t reloadDataHander;

+ (CGFloat)heightOfCell:(NSMutableDictionary *)dict;
- (void)configCell:(NSMutableDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

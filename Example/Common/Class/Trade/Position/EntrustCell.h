//
//  EntrustCell.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/24.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseCell.h"
#import "OrderKeyBoardView.h"

NS_ASSUME_NONNULL_BEGIN

@interface EntrustCell : BaseCell

@property (nonatomic,copy)void(^setterSLTPHaner)(OrderKeyBoardType type,NSDictionary *dic);
@property (nonatomic,copy)void (^closePosAction)(NSMutableDictionary *);
@property (nonatomic,copy)dispatch_block_t reloadDataHander;

+ (CGFloat)heightOfCell:(NSMutableDictionary *)dict;
- (void)configCell:(NSMutableDictionary *)dict;

@end

NS_ASSUME_NONNULL_END

//
//  NNTJOfferRemindCell.h
//  nntj_ftox
//
//  Created by jly on 2017/10/18.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

@interface QZHOfferRemindCell : BaseCell

@property (nonatomic,strong)UISwitch *swich;
@property (nonatomic,strong)UITextField *tx;
@property (nonatomic,strong)UIImageView *chooseImage;
@property (nonatomic,strong)UILabel     *chooseTitle;
@property (nonatomic,copy)dispatch_block_t reloadCell;

+ (CGFloat)heightOfCell:(NSDictionary *)dic;
- (void)updateData:(NSDictionary *)dic;
@end

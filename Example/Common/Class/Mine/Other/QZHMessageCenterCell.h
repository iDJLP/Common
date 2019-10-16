//
//  QZHMessageCenterCell.h
//  qzh_ftox
//
//  Created by jly on 2017/11/17.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseCell.h"

@interface QZHMessageCenterCell : BaseCell

- (void)updateData:(id)data;
- (void)showRedDot:(NSString *)count;
@end

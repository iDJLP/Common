//
//  QZHMessageCell.h
//  niuguwang
//
//  Created by A on 2017/7/4.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QZHMessageVC.h"
#import "BaseCell.h"

@interface QZHMessageCell : BaseCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)config:(NSDictionary *)dict type:(QZHMessageType)type;
+ (CGFloat)heightWithModel:(NSDictionary *)dic;

@end

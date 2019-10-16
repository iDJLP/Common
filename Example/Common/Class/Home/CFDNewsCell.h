//
//  QZHNewsCell.h
//  niuguwang
//
//  Created by jly on 2017/6/27.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "BaseCell.h"

@interface CFDNewsCell : BaseCell

+ (CGFloat)heightOfCell;
- (void)updateCell:(NSDictionary *)data;
@end

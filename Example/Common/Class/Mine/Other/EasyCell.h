//
//  EasyCell.h
//  niuguwang
//
//  Created by jly on 16/11/3.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//
#import "BaseCell.h"

@interface EasyCell : BaseCell

@property (nonatomic,strong)UILabel *leftLabel;
@property (nonatomic,strong)UILabel *rightLabel;

- (void)reloadData:(NSString *)leftText rightText:(NSString *)rightText showArrow:(BOOL)showArrow;
@end

//
//  CFDAlertFrequencyCell.m
//  niuguwang
//
//  Created by jly on 2017/11/24.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "AlertFrequencyCell.h"

@interface AlertFrequencyCell ()


@property (nonatomic,strong)UIView *line;

@end
@implementation AlertFrequencyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.hasPressEffect = YES;
        [self setupUI];
        [self setLayout];
    }
    return self;
}


- (void)setupUI
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.row];
    [self.contentView addSubview:self.line];
}

- (void)setLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.equalTo(self);
    }];
    [self.row mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.equalTo(self);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.height.mas_equalTo(.5);
    }];
}


- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = [GUIUtil fitBoldFont:16];
        _titleLabel.textColor = [GColorUtil C2];
    }
    return _titleLabel;
}

- (UIImageView *)row
{
    if(!_row)
    {
        _row = [UIImageView new];
        _row.image = [GColorUtil imageNamed:@"public_icon_selyes"];
    }
    return _row;
}

- (UIView *)line
{
    if(!_line)
    {
        _line = [UIView new];
        _line.backgroundColor = [GColorUtil C7];
    }
    return _line;
}
@end

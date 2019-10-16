//
//  FTOLyMyCell.m
//  niuguwang
//
//  Created by jly on 16/11/2.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "MineCell.h"

@interface MineCell ()


@end
@implementation MineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.hasPressEffect = YES;
        [self setupFTOCellSubViews];
        [self setupFTOCellLayout];
    }
    return self;
}


- (void)setupFTOCellSubViews
{
    [self.contentView addSubview:self.myImageView];
    [self.contentView addSubview:self.myTitleLabel];
    [self.contentView addSubview:self.rowImageView];
    [self.contentView addSubview:self.newLabel];
    [self.contentView addSubview:self.line];
}

- (void)setupFTOCellLayout
{
    __weak typeof(self)weakSelf = self;
   [self.myImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.left.mas_equalTo([GUIUtil fit:15]);
       make.centerY.equalTo(weakSelf.contentView);
       make.size.mas_equalTo([GUIUtil fitWidth:28 height:28]);
   }];
    
    [self.myTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:60]);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [self.rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [self.newLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rowImageView.mas_left).offset([GUIUtil fit:-10]);
        make.centerY.equalTo(weakSelf.contentView);
        make.size.mas_equalTo([GUIUtil fitWidth:8 height:8]);
    }];
    
    [weakSelf.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.mas_equalTo([GUIUtil fitLine]);
        make.left.equalTo(@0);
    }];

}

#pragma mark ----init

- (UIImageView *)myImageView
{
    if(!_myImageView)
    {
        _myImageView = [UIImageView new];
    }
    
    return _myImageView;
}

- (BaseLabel *)myTitleLabel
{
    if(!_myTitleLabel)
    {
        _myTitleLabel           = [BaseLabel new];
        _myTitleLabel.txColor = C2_ColorType;
        _myTitleLabel.font      = [GUIUtil fitFont:16];
    }
    return _myTitleLabel;
}

- (BaseImageView *)rowImageView
{
    if(!_rowImageView)
    {
        _rowImageView = [BaseImageView new];
        _rowImageView.imageName = @"public_icon_more";
    }
    return _rowImageView;
}

- (UIImageView *)newLabel
{
    if(!_newLabel)
    {
        _newLabel = [UIImageView new];
        _newLabel.image = [[UIImage imageWithColor:[UIColor redColor] size:CGSizeMake(8, 8)] imageByRoundCornerRadius:4];
        _newLabel.hidden = YES;
    }
    return _newLabel;
}

- (BaseView *)line {
    if (!_line) {
        
        _line = [[BaseView alloc] init];
        _line.bgColor = C7_ColorType;
    }
    return _line;
}

@end

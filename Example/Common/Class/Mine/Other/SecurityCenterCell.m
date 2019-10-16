//
//  SecurityCenterCell.m
//  Bitmixs
//
//  Created by ngw15 on 2019/5/17.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "SecurityCenterCell.h"

@interface SecurityCenterCell ()


@end
@implementation SecurityCenterCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.hasPressEffect = YES;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}


- (void)setupUI
{
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.arrowImgView];
    [self.contentView addSubview:self.line];
}

- (void)autoLayout
{
    __weak typeof(self)weakSelf = self;
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImgView.mas_left).mas_offset([GUIUtil fit:-5]);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [self.arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.equalTo(weakSelf.contentView);
    }];
    
    [weakSelf.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.bottom.equalTo(@0);
        make.height.mas_equalTo([GUIUtil fitLine]);
        make.left.equalTo(@0);
    }];
    
}

#pragma mark ----init

- (BaseImageView *)arrowImgView
{
    if(!_arrowImgView)
    {
        _arrowImgView = [[BaseImageView alloc] init];
        _arrowImgView.imageName = @"public_icon_more";
    }
    
    return _arrowImgView;
}

- (BaseLabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel           = [BaseLabel new];
        _titleLabel.txColor = C2_ColorType;
        _titleLabel.font      = [GUIUtil fitFont:14];
    }
    return _titleLabel;
}


- (BaseLabel *)remarkLabel
{
    if(!_remarkLabel)
    {
        _remarkLabel = [BaseLabel new];
        _remarkLabel.txColor = C13_ColorType;
        _remarkLabel.font      = [GUIUtil fitFont:14];
    }
    return _remarkLabel;
}

- (BaseView *)line {
    if (!_line) {
        
        _line = [[BaseView alloc] init];
        _line.bgColor = C7_ColorType;
    }
    return _line;
}

@end


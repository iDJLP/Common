//
//  Easy.m
//  niuguwang
//
//  Created by jly on 16/11/3.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "EasyCell.h"

@interface EasyCell ()

@property (nonatomic,strong)UIImageView *rowImageView;
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)MASConstraint *masRight;
@end
@implementation EasyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.hasPressEffect = YES;
        [self setupLYStyleSubviews];
        [self setupLYStyleLayout];
    }
    return self;
}

- (void)setupLYStyleSubviews
{
    [self.contentView addSubview:self.leftLabel];
    [self.contentView addSubview:self.rightLabel];
    [self.contentView addSubview:self.rowImageView];
    [self.contentView addSubview:self.line];
}

- (void)setupLYStyleLayout
{
    __weak typeof(self)weakSelf = self;
    [self.leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.equalTo(weakSelf);
    }];
    
    [self.rowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.equalTo(weakSelf);
    }];
    
    [self.rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.rowImageView.mas_left).offset(-5).priority(750);
        self.masRight =make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.equalTo(weakSelf);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
}

- (void)updateDatas:(NSDictionary *)dic
{
    self.leftLabel.text = [NDataUtil stringWith:dic[@"left"]];
    self.rightLabel.text= [NDataUtil stringWith:dic[@"right"]];
}

- (void)reloadData:(NSString *)leftText rightText:(NSString *)rightText showArrow:(BOOL)showArrow
{
    self.leftLabel.text = leftText;
    self.rightLabel.text=rightText;
    
    _rowImageView.hidden = !showArrow;
    if (showArrow) {
        [_masRight deactivate];
    }else{
        [_masRight activate];
    }
}
#pragma mark --- init
- (UILabel *)leftLabel
{
    if(!_leftLabel)
    {
        _leftLabel = [UILabel new];
        _leftLabel.font = [GUIUtil fitFont:16];
        _leftLabel.textColor = [GColorUtil C2];
        
    }
    return _leftLabel;
}

- (UILabel *)rightLabel
{
    if(!_rightLabel)
    {
        _rightLabel = [UILabel new];
        _rightLabel.font = [GUIUtil fitFont:16];
        _rightLabel.textColor = [GColorUtil C2];
        
    }
    return _rightLabel;
}

- (UIImageView *)rowImageView
{
    if(!_rowImageView)
    {
        _rowImageView = [UIImageView new];
        _rowImageView.image = [GColorUtil imageNamed:@"public_icon_more"];
        
    }
    return _rowImageView;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [GColorUtil C7];
    }
    return _line;
}

@end

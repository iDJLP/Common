//
//  AddressListCell.m
//  Bitmixs
//
//  Created by ngw15 on 2019/10/9.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "AddressListCell.h"

@interface AddressListCell ()

@property (nonatomic,strong) UIImageView *logoImgView;
@property (nonatomic,strong) UIImageView *arrowImgView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *remarkLabel;

@end

@implementation AddressListCell

+ (CGFloat)heightOfCell{
    
    return [GUIUtil fit:70];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.logoImgView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.arrowImgView];
}

- (void)autoLayout{
    [_logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.mas_equalTo(0);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:50]);
        make.bottom.equalTo(self.contentView.mas_centerY).mas_offset([GUIUtil fit:-2]);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:50]);
        make.top.equalTo(self.contentView.mas_centerY).mas_offset([GUIUtil fit:3]);
    }];
    [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)configCell:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _titleLabel.text = [NDataUtil stringWith:dict[@"label"]];
    _remarkLabel.text = [NDataUtil stringWith:dict[@"address"]];
    NSString *type = [NDataUtil stringWith:dict[@"currentType"]];
    if ([type isEqualToString:@"USDT"]) {
        _logoImgView.image = [UIImage imageNamed:@"assets_popicon_usdt"];
    }else if ([type isEqualToString:@"BTC"]){
        _logoImgView.image = [UIImage imageNamed:@"assets_popicon_btc"];
    }else if ([type isEqualToString:@"ETH"]){
        _logoImgView.image = [UIImage imageNamed:@"assets_popicon_eth"];
    }
}
//MARK:Getter


- (UIImageView *)logoImgView{
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] init];
    }
    return _logoImgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [GColorUtil C2];
        _titleLabel.font = [GUIUtil fitFont:16];
    }
    return _titleLabel;
}

- (UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.textColor = [GColorUtil C3];
        _remarkLabel.font = [GUIUtil fitFont:12];
    }
    return _remarkLabel;
}

- (UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] init];
        _arrowImgView.image = [GColorUtil imageNamed:@"public_icon_more"];
    }
    return _arrowImgView;
}

@end


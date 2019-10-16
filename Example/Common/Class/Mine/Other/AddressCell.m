//
//  AddressCell.m
//  Bitmixs
//
//  Created by ngw15 on 2019/10/9.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "AddressCell.h"

@interface AddressCell ()

@property (nonatomic,strong) CAGradientLayer *fillLayer;
@property (nonatomic,strong) UIImageView *logoImgView;
@property (nonatomic,strong) UIImageView *arrowImgView;
@property (nonatomic,strong) UILabel *remarkLabel;

@end

@implementation AddressCell

+ (CGFloat)heightOfCell{
    
    return [GUIUtil fit:80];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self.contentView.layer addSublayer:self.fillLayer];
    [self.contentView addSubview:self.logoImgView];
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.arrowImgView];
}

- (void)autoLayout{
    _fillLayer.frame = CGRectMake([GUIUtil fit:15], [GUIUtil fit:10], [GUIUtil fit:345], [GUIUtil fit:60]);
    [_logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:27]);
        make.centerY.mas_equalTo(0);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:75]);
        make.centerY.mas_equalTo(0);
    }];
    [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-30]);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)configCell:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _logoImgView.image = [UIImage imageNamed:dict[@"logo"]];
    _remarkLabel.text = [NDataUtil stringWith:dict[@"title"]];
    NSString *type = [NDataUtil stringWith:dict[@"type"]];
    if ([type isEqualToString:@"USDT"]) {
        _fillLayer.colors = @[(__bridge id)[GColorUtil colorWithHex:0x00C982].CGColor,(__bridge id)[GColorUtil colorWithHex:0x14DF97].CGColor];
        _fillLayer.locations = @[@(0),@(1)];
        _fillLayer.startPoint = CGPointMake(1, 0);
        _fillLayer.endPoint = CGPointMake(0, 0);
    }else if ([type isEqualToString:@"BTC"]){
        _fillLayer.colors = @[(__bridge id)[GColorUtil colorWithHex:0xFF9422].CGColor,(__bridge id)[GColorUtil colorWithHex:0xFFBE70].CGColor];
        _fillLayer.locations = @[@(0),@(1)];
        _fillLayer.startPoint = CGPointMake(1, 0);
        _fillLayer.endPoint = CGPointMake(0, 0);
    }else if ([type isEqualToString:@"ETH"]){
        _fillLayer.colors = @[(__bridge id)[GColorUtil colorWithHex:0xB440FF].CGColor,(__bridge id)[GColorUtil colorWithHex:0xCF75FF].CGColor];
        _fillLayer.locations = @[@(0),@(1)];
        _fillLayer.startPoint = CGPointMake(1, 0);
        _fillLayer.endPoint = CGPointMake(0, 0);
    }
}
//MARK:Getter

- (CAGradientLayer *)fillLayer{
    if (!_fillLayer) {
        _fillLayer =  [[CAGradientLayer alloc] init];
        _fillLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TOP_BAR_HEIGHT);

        _fillLayer.cornerRadius = [GUIUtil fit:7];
        _fillLayer.masksToBounds = YES;
    }
    return _fillLayer;
}

- (UIImageView *)logoImgView{
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] init];
    }
    return _logoImgView;
}

- (UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.textColor = [GColorUtil colorWithHex:0xffffff];
        _remarkLabel.font = [GUIUtil fitBoldFont:16];
    }
    return _remarkLabel;
}

- (UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"public_icon_more_light"]];
    }
    return _arrowImgView;
}

@end

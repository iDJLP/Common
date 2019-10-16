//
//  MarketCell.m
//  Chart
//
//  Created by ngw15 on 2019/3/12.
//  Copyright © 2019 taojinzhe. All rights reserved.
//  

#import "MarketCell.h"
#import "BaseLabel.h"
#import "BaseImageView.h"

@interface MarketView ()

@property (nonatomic,strong)BaseLabel *leftLabel;
@property (nonatomic,strong)BaseLabel *centerLabel;
@property (nonatomic,strong)BaseLabel *rightLabel;
@property (nonatomic,strong)BaseImageView *remarkImgView;
@property (nonatomic,copy) NSString *sortType;
@end

@implementation MarketView

+ (CGFloat)heightOfView{
    return [GUIUtil fit:34];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupUI];
        [self autoLayout];
        _sortType = @"1";
        WEAK_SELF;
        [self g_clickBlock:^(UITapGestureRecognizer *tap) {
            CGPoint point = [tap locationInView:self];
            if (point.x>SCREEN_WIDTH/3*2) {
                [weakSelf sortAction];
            }
        }];
    }
    return self;
}

- (void)setupUI{
    self.bgColor = C6_ColorType;
    [self addSubview:self.leftLabel];
    [self addSubview:self.centerLabel];
    [self addSubview:self.rightLabel];
    [self addSubview:self.remarkImgView];
}

- (void)autoLayout{
    [_leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.mas_equalTo(0);
    }];
    [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo([GUIUtil fit:160]);
    }];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.remarkImgView.mas_left).mas_offset([GUIUtil fit:-5]);
        make.centerY.mas_equalTo(0);
    }];
    [_remarkImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)sortAction{
    _sortType = [GUIUtil decimalAdd:_sortType num:@"1"];
    if (_sortType.integerValue==4) {
        _sortType = @"1";
    }
    if (_sortType.integerValue==1) {
        _remarkImgView.image = [GColorUtil imageNamed:@"market_icon_applies3"];
    }else if (_sortType.integerValue==2){
        _remarkImgView.image = [GColorUtil imageNamed:@"market_icon_applies2"];
    }else{
        _remarkImgView.image = [GColorUtil imageNamed:@"market_icon_applies1"];
        
    }
    _sortChangedHander(_sortType);
}

- (BaseLabel *)leftLabel{
    if (!_leftLabel) {
        _leftLabel = [[BaseLabel alloc] init];
        _leftLabel.txColor = C3_ColorType;
        _leftLabel.font = [GUIUtil fitFont:12];
        _leftLabel.numberOfLines = 1;
        _leftLabel.textBlock = CFDLocalizedStringBlock(@"交易品种");
    }
    return _leftLabel;
}

- (BaseLabel *)centerLabel{
    if (!_centerLabel) {
        _centerLabel = [[BaseLabel alloc] init];
        _centerLabel.txColor = C3_ColorType;
        _centerLabel.font = [GUIUtil fitFont:12];
        _centerLabel.numberOfLines = 1;
        _centerLabel.textBlock = CFDLocalizedStringBlock(@"最新价");
    }
    return _centerLabel;
}

- (BaseLabel *)rightLabel{
    if (!_rightLabel) {
        _rightLabel = [[BaseLabel alloc] init];
        _rightLabel.txColor = C3_ColorType;
        _rightLabel.font = [GUIUtil fitFont:12];
        _rightLabel.numberOfLines = 1;
        _rightLabel.textBlock = CFDLocalizedStringBlock(@"涨跌幅");
    }
    return _rightLabel;
}

- (BaseImageView *)remarkImgView{
    if (!_remarkImgView) {
        _remarkImgView = [[BaseImageView alloc] init];
        _remarkImgView.imageName = @"market_icon_applies3";
    }
    return _remarkImgView;
}


@end

@interface MarketCell ()

@property (nonatomic,strong)BaseLabel *nameLabel;
@property (nonatomic,strong)BaseLabel *detailLabel;
@property (nonatomic,strong)BaseLabel *remarkLabel;
@property (nonatomic,strong)BaseLabel *priceLabel;
@property (nonatomic,strong)BaseLabel *priceRMBLabel;
@property (nonatomic,strong)BaseView  *upDownView;
@property (nonatomic,strong)BaseLabel *upDownLabel;
@property (nonatomic,strong)BaseView *lineView;
@end

@implementation MarketCell

+ (CGFloat)heightOfCell{
    CGFloat height = [GUIUtil fit:10]+[GUIUtil fitFont:16].lineHeight +[GUIUtil fit:2]+[GUIUtil fitFont:12].lineHeight+[GUIUtil fit:8];
    return ceil(height);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.hasPressEffect = YES;
        
        self.bgColorType = C6_ColorType;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.detailLabel];
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.priceLabel];
    [self.contentView addSubview:self.priceRMBLabel];
    [self.contentView addSubview:self.upDownView];
    [self.contentView addSubview:self.upDownLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)autoLayout{
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.mas_equalTo([GUIUtil fit:10]);
    }];
    [_detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).mas_offset([GUIUtil fit:5]);
        make.baseline.equalTo(self.nameLabel);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel);
        make.top.equalTo(self.nameLabel.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.width.mas_equalTo([GUIUtil fit:150]);
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(self.nameLabel);
        make.left.mas_equalTo([GUIUtil fit:160]);
    }];
    [_priceRMBLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.baseline.equalTo(self.remarkLabel);
        make.left.equalTo(self.priceLabel);
    }];
    [_upDownView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo([GUIUtil fitWidth:80 height:32]);
    }];
    [_upDownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.upDownView);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
}

- (void)configCell:(CFDBaseInfoModel *)model{
    _nameLabel.text = model.iStockname;
    _detailLabel.text = @"";
    _remarkLabel.text = [NSString stringWithFormat:@"24H%@ %@",CFDLocalizedString(@"量"),model.volume];
    _priceLabel.text = model.lastPrice;
    NSString *cnyText= [GUIUtil notRoundingString:[GUIUtil decimalMultiply:model.lastPrice num:model.rate] afterPoint:2];
     _priceRMBLabel.text=  [NSString stringWithFormat:@"≈¥%@",cnyText];
    _upDownLabel.text = [NDataUtil stringWith:model.raisRate];
    _upDownView.backgroundColor = [GColorUtil colorWithProfitString:[NDataUtil stringWith:model.raisRate]];
}



//MARK: - Getter

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[BaseLabel alloc] init];
        _nameLabel.txColor = C2_ColorType;
        _nameLabel.font = [GUIUtil fitBoldFont:16];
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}

- (BaseLabel *)detailLabel{
    if (!_detailLabel) {
        _detailLabel = [[BaseLabel alloc] init];
        _detailLabel.txColor = C4_ColorType;
        _detailLabel.font = [GUIUtil fitFont:10];
        _detailLabel.numberOfLines = 1;
    }
    return _detailLabel;
}

- (BaseLabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[BaseLabel alloc] init];
        _remarkLabel.txColor = C3_ColorType;
        _remarkLabel.font = [GUIUtil fitFont:12];
        _remarkLabel.numberOfLines = 1;
        _remarkLabel.adjustsFontSizeToFitWidth = YES;
        _remarkLabel.minimumScaleFactor=0.5;
    }
    return _remarkLabel;
}

- (BaseLabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[BaseLabel alloc] init];
        _priceLabel.txColor = C2_ColorType;
        _priceLabel.font = [GUIUtil fitBoldFont:16];
        _priceLabel.numberOfLines = 1;
    }
    return _priceLabel;
}

- (BaseLabel *)priceRMBLabel{
    if (!_priceRMBLabel) {
        _priceRMBLabel = [[BaseLabel alloc] init];
        _priceRMBLabel.txColor = C3_ColorType;
        _priceRMBLabel.font = [GUIUtil fitFont:12];
        _priceRMBLabel.numberOfLines = 1;
    }
    return _priceRMBLabel;
}

- (BaseView *)upDownView{
    if (!_upDownView) {
        _upDownView = [[BaseView alloc] init];
        _upDownView.layer.masksToBounds = YES;
        _upDownView.layer.cornerRadius = 2;
    }
    return _upDownView;
}

- (BaseLabel *)upDownLabel{
    if (!_upDownLabel) {
        _upDownLabel = [[BaseLabel alloc] init];
        _upDownLabel.txColor = C5_ColorType;
        _upDownLabel.font = [GUIUtil fitBoldFont:14];
        _upDownLabel.numberOfLines = 1;
    }
    return _upDownLabel;
}

- (BaseView *)lineView{
    if (!_lineView) {
        _lineView = [[BaseView alloc] init];
        _lineView.bgColor = C7_ColorType;
    }
    return _lineView;
}

@end

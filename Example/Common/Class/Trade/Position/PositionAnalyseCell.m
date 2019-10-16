//
//  PositionAnalyseCell.m
//  Bitmixs
//
//  Created by ngw15 on 2019/9/30.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "PositionAnalyseCell.h"

@interface PositionAnalyseSectionView ()

@property (nonatomic,strong)UILabel *left1Label;
@property (nonatomic,strong)UILabel *left2Label;
@property (nonatomic,strong)UILabel *right1Label;

@end

@implementation PositionAnalyseSectionView

+ (CGFloat)heightOfView{
    return [GUIUtil fit:35];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [GColorUtil colorWithWhiteColorType:C6_ColorType];
    [self addSubview:self.left1Label];
    [self addSubview:self.left2Label];
    [self addSubview:self.right1Label];
}

- (void)autoLayout{
    [self.left1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:40]);
        make.centerY.mas_equalTo(0);
    }];
    [self.left2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).mas_offset([GUIUtil fit:190]);
        make.centerY.mas_equalTo(0);
    }];
    [self.right1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.mas_equalTo(0);
    }];
}

- (UILabel *)left1Label{
    if (!_left1Label) {
        _left1Label = [[UILabel alloc] init];
        _left1Label.textColor = GColorUtil.C4;
        _left1Label.font = [GUIUtil fitFont:10];
        _left1Label.numberOfLines = 1;
        _left1Label.text = CFDLocalizedString(@"品种");
    }
    return _left1Label;
}

- (UILabel *)left2Label{
    if (!_left2Label) {
        _left2Label = [[UILabel alloc] init];
        _left2Label.textColor = GColorUtil.C4;
        _left2Label.font = [GUIUtil fitFont:10];
        _left2Label.numberOfLines = 1;
        _left2Label.text =  CFDLocalizedString(@"交易数量(手)");
    }
    return _left2Label;
}

- (UILabel *)right1Label{
    if (!_right1Label) {
        _right1Label = [[UILabel alloc] init];
        _right1Label.textColor = GColorUtil.C4;
        _right1Label.font = [GUIUtil fitFont:10];
        _right1Label.numberOfLines = 1;
        _right1Label.text = CFDLocalizedString(@"占比");
    }
    return _right1Label;
}

@end


@interface PositionAnalyseCell ()

@property (nonatomic,strong) UIView *markView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *amountLabel;
@property (nonatomic,strong) UILabel *rateLabel;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) NSDictionary *config;
@end

@implementation PositionAnalyseCell

+ (CGFloat)heightOfCell{
    return [GUIUtil fit:35];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.hasPressEffect = NO;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.markView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.amountLabel];
    [self.contentView addSubview:self.rateLabel];
    [self.contentView addSubview:self.lineView];
}

- (void)autoLayout{
    [_markView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.size.mas_equalTo([GUIUtil fitWidth:10 height:10]);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:40]);
        make.centerY.mas_equalTo(0);
    }];
    [_amountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).mas_offset([GUIUtil fit:190]);
        make.centerY.mas_equalTo(0);
    }];
    [_rateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo([GUIUtil fit:-15]);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
}

- (void)configOfCell:(NSDictionary *)dict isSingle:(BOOL)isSingle{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _config = dict;
    self.contentView.backgroundColor = !isSingle? [GColorUtil colorWithWhiteColorType:C8_ColorType]:[GColorUtil colorWithWhiteColorType:C6_ColorType];
    _titleLabel.text = [NDataUtil stringWith:dict[@"name"]];
    _rateLabel.text = [NSString stringWithFormat:@"%@%%",[NDataUtil stringWith:dict[@"proportion"]]];
    _amountLabel.text = [NDataUtil stringWith:dict[@"quantity"]];
    _markView.backgroundColor = [GColorUtil colorWithHexString:[NDataUtil stringWith:dict[@"bgColor"]]];
}

- (void)updateSelected:(BOOL)flag{
    UIColor *color = [GColorUtil colorWithHexString:[NDataUtil stringWith:_config[@"bgColor"]]];
    if (!flag) {
        color = [GColorUtil colorWithWhiteColorType:C2_ColorType];
    }
    _titleLabel.textColor =
    _amountLabel.textColor =
    _rateLabel.textColor = color;
}

//MARK:Getter

- (UIView *)markView{
    if (!_markView) {
        _markView = [[UIView alloc] init];
        _markView.layer.cornerRadius = [GUIUtil fit:5];
        _markView.layer.masksToBounds = YES;
    }
    return _markView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
        _titleLabel.font = [GUIUtil fitFont:12];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UILabel *)amountLabel{
    if (!_amountLabel) {
        _amountLabel = [[UILabel alloc] init];
        _amountLabel.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
        _amountLabel.font = [GUIUtil fitFont:12];
        _amountLabel.numberOfLines = 1;
    }
    return _amountLabel;
}

- (UILabel *)rateLabel{
    if (!_rateLabel) {
        _rateLabel = [[UILabel alloc] init];
        _rateLabel.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
        _rateLabel.font = [GUIUtil fitFont:12];
        _rateLabel.numberOfLines = 1;
    }
    return _rateLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [GColorUtil colorWithWhiteColorType:C8_ColorType];
    }
    return _lineView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    
}

@end

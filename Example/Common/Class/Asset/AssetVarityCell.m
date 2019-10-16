//
//  AssetVarityCell.m
//  Bitmixs
//
//  Created by ngw15 on 2019/6/13.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "AssetVarityCell.h"

@interface AssetVarityCell()

@property (nonatomic,strong)UIImageView *markImgView;
@property (nonatomic,strong)BaseLabel *titleLabel;

@property (nonatomic,strong)BaseLabel *title1Label;
@property (nonatomic,strong)BaseLabel *text1Label;
@property (nonatomic,strong)BaseLabel *value1Label;

@property (nonatomic,strong)BaseLabel *title2Label;
@property (nonatomic,strong)BaseLabel *text2Label;
@property (nonatomic,strong)BaseLabel *value2Label;

@property (nonatomic,strong)BaseLabel *title3Label;
@property (nonatomic,strong)BaseLabel *text3Label;
@property (nonatomic,strong)BaseLabel *value3Label;

@property (nonatomic,strong)BaseView *lineView;
@property (nonatomic,strong)NSDictionary *config;

@end

@implementation AssetVarityCell

+ (CGFloat)heightOfCell{
    CGFloat height = [GUIUtil fit:50] + [GUIUtil fitFont:12].lineHeight + [GUIUtil fit:5] + [GUIUtil fitFont:16].lineHeight +[GUIUtil fitFont:12].lineHeight + [GUIUtil fit:15];
    return ceilf(height);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.hasPressEffect = YES;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self.contentView addSubview:self.markImgView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.title1Label];
    [self.contentView addSubview:self.text1Label];
    [self.contentView addSubview:self.value1Label];
    [self.contentView addSubview:self.title2Label];
    [self.contentView addSubview:self.text2Label];
    [self.contentView addSubview:self.value2Label];
    [self.contentView addSubview:self.title3Label];
    [self.contentView addSubview:self.text3Label];
    [self.contentView addSubview:self.value3Label];
    [self.contentView addSubview:self.lineView];
}

- (void)autoLayout{
    [_markImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo([GUIUtil fit:10]);
        make.size.mas_equalTo([GUIUtil fitWidth:50 height:20]);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.markImgView);
    }];
    [_title1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.mas_equalTo([GUIUtil fit:50]);
    }];
    [_text1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title1Label);
        make.top.equalTo(self.title1Label.mas_bottom).mas_offset([GUIUtil fit:3]);
        make.width.mas_equalTo([GUIUtil fit:105]);
    }];
    [_value1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title1Label);
        make.top.equalTo(self.text1Label.mas_bottom).mas_offset([GUIUtil fit:2]);
    }];
    [_title2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:145]);
        make.top.mas_equalTo([GUIUtil fit:50]);
    }];
    [_text2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title2Label);
        make.top.equalTo(self.title2Label.mas_bottom).mas_offset([GUIUtil fit:3]);
        make.width.mas_equalTo([GUIUtil fit:105]);
    }];
    [_value2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title2Label);
        make.top.equalTo(self.text2Label.mas_bottom).mas_offset([GUIUtil fit:2]);
    }];
    [_title3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:268]);
        make.top.mas_equalTo([GUIUtil fit:50]);
    }];
    [_text3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title3Label);
        make.top.equalTo(self.title3Label.mas_bottom).mas_offset([GUIUtil fit:3]);
        make.width.mas_equalTo([GUIUtil fit:100]);
    }];
    [_value3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.title3Label);
        make.top.equalTo(self.text3Label.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.width.mas_equalTo([GUIUtil fit:95]);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
}

- (void)configOfView:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    _config = dict;
    [GUIUtil imageViewWithUrl:_markImgView url:[NDataUtil stringWith:dict[@"icon"]]];
    _titleLabel.text = [NDataUtil stringWith:dict[@"currencyType"]];
    _text1Label.text = [NDataUtil stringWith:dict[@"totalEquity"]];
    _value1Label.text = [NSString stringWithFormat:@"≈%@CNY",[NDataUtil stringWith:dict[@"totalEquityCNY"]]];
    _text2Label.text = [NDataUtil stringWith:dict[@"profit"]];
    _value2Label.text = [NSString stringWithFormat:@"≈%@CNY",[NDataUtil stringWith:dict[@"profitCNY"]]];
    if ([_text2Label.text floatValue]>0) {
        _value2Label.txColor =
        _text2Label.txColor = C9_ColorType;
    }else if ([_text2Label.text floatValue]<0){
        _value2Label.txColor =
        _text2Label.txColor = C10_ColorType;
    }else{
        _value2Label.txColor =
        _text2Label.txColor = C2_ColorType;
    }
    _text3Label.text = [NDataUtil stringWith:dict[@"canUseMoney"]];
    _value3Label.text = [NSString stringWithFormat:@"≈%@CNY",[NDataUtil stringWith:dict[@"canUseMoneyCNY"]]];
}
//MARK:Getter

- (UIImageView *)markImgView{
    if(!_markImgView){
        _markImgView = [[UIImageView alloc] init];
    }
    return _markImgView;
}
- (BaseLabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.txColor = C5_ColorType;
        _titleLabel.font = [GUIUtil fitBoldFont:14];
    }
    return _titleLabel;
}
- (BaseLabel *)title1Label{
    if(!_title1Label){
        _title1Label = [[BaseLabel alloc] init];
        _title1Label.txColor = C2_ColorType;
        _title1Label.font = [GUIUtil fitFont:12];
        _title1Label.textBlock = CFDLocalizedStringBlock(@"总权益");
    }
    return _title1Label;
}
- (BaseLabel *)text1Label{
    if(!_text1Label){
        _text1Label = [[BaseLabel alloc] init];
        _text1Label.txColor = C2_ColorType;
        _text1Label.font = [GUIUtil fitFont:16];
        _text1Label.text = @"--";
        _text1Label.adjustsFontSizeToFitWidth = YES;
        _text1Label.minimumScaleFactor = 0.5;
    }
    return _text1Label;
}
- (BaseLabel *)value1Label{
    if(!_value1Label){
        _value1Label = [[BaseLabel alloc] init];
        _value1Label.txColor = C2_ColorType;
        _value1Label.font = [GUIUtil fitFont:12];
    }
    return _value1Label;
}
- (BaseLabel *)title2Label{
    if(!_title2Label){
        _title2Label = [[BaseLabel alloc] init];
        _title2Label.txColor = C2_ColorType;
        _title2Label.font = [GUIUtil fitFont:12];
        _title2Label.textBlock = CFDLocalizedStringBlock(@"浮动盈亏");
    }
    return _title2Label;
}
- (BaseLabel *)text2Label{
    if(!_text2Label){
        _text2Label = [[BaseLabel alloc] init];
        _text2Label.txColor = C2_ColorType;
        _text2Label.font = [GUIUtil fitFont:16];
        _text2Label.text = @"--";
        _text2Label.adjustsFontSizeToFitWidth = YES;
        _text2Label.minimumScaleFactor = 0.5;
    }
    return _text2Label;
}
- (BaseLabel *)value2Label{
    if(!_value2Label){
        _value2Label = [[BaseLabel alloc] init];
        _value2Label.txColor = C2_ColorType;
        _value2Label.font = [GUIUtil fitFont:12];
    }
    return _value2Label;
}
- (BaseLabel *)title3Label{
    if(!_title3Label){
        _title3Label = [[BaseLabel alloc] init];
        _title3Label.txColor = C2_ColorType;
        _title3Label.font = [GUIUtil fitFont:12];
        _title3Label.textBlock = CFDLocalizedStringBlock(@"可用余额");
    }
    return _title3Label;
}
- (BaseLabel *)text3Label{
    if(!_text3Label){
        _text3Label = [[BaseLabel alloc] init];
        _text3Label.txColor = C2_ColorType;
        _text3Label.font = [GUIUtil fitFont:16];
        _text3Label.text = @"--";
        _text3Label.adjustsFontSizeToFitWidth = YES;
        _text3Label.minimumScaleFactor = 0.5;
    }
    return _text3Label;
}
- (BaseLabel *)value3Label{
    if(!_value3Label){
        _value3Label = [[BaseLabel alloc] init];
        _value3Label.txColor = C2_ColorType;
        _value3Label.font = [GUIUtil fitFont:12];
        _value3Label.text = @"--";
        _value3Label.adjustsFontSizeToFitWidth = YES;
        _value3Label.minimumScaleFactor = 0.5;
    }
    return _value3Label;
}
- (BaseView *)lineView{
    if(!_lineView){
        _lineView = [[BaseView alloc] init];
        _lineView.bgColor = C7_ColorType;
    }
    return _lineView;
}

@end


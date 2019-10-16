//
//  NNTJOfferRemindTitleCell.m
//  nntj_ftox
//
//  Created by jly on 2017/10/18.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "QZHOfferRemindTitleCell.h"

@interface QZHOfferRemindTitleCell ()

@property (nonatomic,strong)UIImageView *logoImg;
@property (nonatomic,strong)UILabel *stockName;
@property (nonatomic,strong)UILabel *priceTitle;
@property (nonatomic,strong)UILabel *priceText;
@property (nonatomic,strong)UILabel *raiseTitle;
@property (nonatomic,strong)UILabel *raiseText;
@property (nonatomic,strong)UIView  *line;

@end
@implementation QZHOfferRemindTitleCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initSubviews];
        [self initLayout];
    }
    return self;
}

- (void)initSubviews
{
    [self.contentView addSubview:self.logoImg];
    [self.contentView addSubview:self.stockName];
    [self.contentView addSubview:self.priceTitle];
    [self.contentView addSubview:self.priceText];
    [self.contentView addSubview:self.raiseTitle];
    [self.contentView addSubview:self.raiseText];
    [self.contentView addSubview:self.line];
}
- (void)initLayout
{
    [self.logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo([GUIUtil fitWidth:38 height:38]);
    }];
    [self.stockName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.logoImg);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.width.mas_equalTo([GUIUtil fit:80]);
    }];
    
    [self.priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-145]);
        make.bottom.mas_equalTo([GUIUtil fit:-15]);
    }];
    [self.priceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceTitle);
        make.bottom.equalTo(self.priceTitle.mas_top).mas_offset([GUIUtil fit:-5]);
    }];
    [self.raiseTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.bottom.equalTo(self.priceTitle);
    }];
    [self.raiseText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.raiseTitle);
        make.bottom.equalTo(self.raiseTitle.mas_top).mas_offset([GUIUtil fit:-5]);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
}

- (void)updateData:(NSDictionary *)dict{
    NSString *stockname = [NDataUtil stringWith:dict[@"name"]];
    NSString *symbol = [NDataUtil stringWith:dict[@"code"]];
    NSString *nowv = [NDataUtil stringWith:dict[@"nowv"]];
    NSString *updownRate = [NDataUtil stringWith:dict[@"updownRate"]];
    UIColor *color = [GColorUtil colorWithProfitString:updownRate];
    
//    [GUIUtil imageViewWithUrl:_logoImg url:[FTConfig contradImg:symbol] placeholder:nil completedBlock:^(UIImage *image, NSError *error, NSInteger cacheType, NSURL *imageURL) {
    
//    }];
    self.stockName.text = stockname;
    _priceText.text = nowv;
    _raiseText.text = updownRate;
    _raiseText.textColor =
    _priceText.textColor = color;
}


#pragma mark -----setter and getter

- (UIImageView *)logoImg{
    if (!_logoImg) {
        _logoImg = [[UIImageView alloc] init];
    }
    return _logoImg;
}

- (UILabel *)stockName
{
    if(!_stockName)
    {
        _stockName = [UILabel new];
        _stockName.textColor = [GColorUtil C2];
        _stockName.font      = [GUIUtil fitFont:18];
        _stockName.minimumScaleFactor=0.5;
        _stockName.adjustsFontSizeToFitWidth=YES;
    }
    return _stockName;
}

- (UILabel *)priceTitle
{
    if(!_priceTitle)
    {
        _priceTitle = [UILabel new];
        _priceTitle.textColor = [GColorUtil C3];
        _priceTitle.font      = [GUIUtil fitFont:16];
        _priceTitle.text = CFDLocalizedString(@"最新价");
    }
    return _priceTitle;
}

- (UILabel *)priceText
{
    if(!_priceText)
    {
        _priceText = [UILabel new];
        _priceText.textColor = [GColorUtil C3];
        _priceText.font      = [GUIUtil fitBoldFont:16];
    }
    return _priceText;
}

- (UILabel *)raiseTitle
{
    if(!_raiseTitle)
    {
        _raiseTitle = [UILabel new];
        _raiseTitle.textColor = [GColorUtil C3];
        _raiseTitle.font      = [GUIUtil fitFont:16];
        _raiseTitle.text = CFDLocalizedString(@"涨跌幅");
    }
    return _raiseTitle;
}

- (UILabel *)raiseText
{
    if(!_raiseText)
    {
        _raiseText = [UILabel new];
        _raiseText.textColor = [GColorUtil C3];
        _raiseText.font      = [GUIUtil fitBoldFont:16];
    }
    return _raiseText;
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

// 改变范围文本颜色
+ (NSMutableAttributedString *) changeColor:(NSString *)text
                                      range:(NSRange)range
                                      color:(UIColor *)color
                                       font:(UIFont *)font
{
    if(text.length<1){
        return nil;
    }
    if (range.location != NSNotFound) {
        NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:text];
        range.location = MIN(MAX(range.location, 0), text.length-1);
        range.length = MIN(MAX(range.location+range.length, 0), text.length)-range.location;
        //修改部分字体颜色
        [attString addAttribute:NSForegroundColorAttributeName value:color range:range];
        [attString addAttribute:NSFontAttributeName value:font range:range];
        return attString;
    }
    return nil;
}


@end

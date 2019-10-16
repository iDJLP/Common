//
//  NNTJOfferRemindCell.m
//  nntj_ftox
//
//  Created by jly on 2017/10/18.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "QZHOfferRemindCell.h"

@interface QZHOfferRemindCell () <UITextFieldDelegate>

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIView *txBg;
@property (nonatomic,strong)UIView *line;
@property (nonatomic,strong)UILabel *remarkLabel;

@property (nonatomic,strong)NSMutableDictionary *config;
@end
@implementation QZHOfferRemindCell

+ (CGFloat)heightOfCell:(NSDictionary *)dic{
    NSString *remark = [NDataUtil stringWith:dic[@"remark"]];
    CGFloat height = [GUIUtil fit:20]*2+[GUIUtil fitBoldFont:16].lineHeight;
    if (remark.length<=0) {
        return ceil(height);
    }
    CGFloat width = SCREEN_WIDTH-[GUIUtil fit:15+35];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc]initWithString:remark attributes:@{NSFontAttributeName:[GUIUtil fitBoldFont:12]}];
    attStr.lineSpacing = 5;
    height += [GUIUtil sizeWith:attStr width:width].height+[GUIUtil fit:5];
    return ceil(height);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self initSubViews];
        [self initLayout];
    }
    return self;
}

- (void)initSubViews
{
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.txBg];
    [self.txBg addSubview:self.tx];
    [self.contentView addSubview:self.swich];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.chooseImage];
    [self.contentView addSubview:self.chooseTitle];
    [self.contentView addSubview:self.remarkLabel];
}

- (void)initLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.mas_equalTo([GUIUtil fit:20]);
        make.width.mas_equalTo([GUIUtil fit:150]);
    }];
    
    [self.txBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:173]);
        make.centerY.equalTo(self.titleLabel);
        make.width.mas_equalTo([GUIUtil fit:126]);
        make.height.mas_equalTo([GUIUtil fit:28]);
    }];
    
    [self.tx mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo([GUIUtil fit:-10]);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.chooseImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.equalTo(self.titleLabel);
    }];
    
    [self.chooseTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.chooseImage.mas_left).mas_offset([GUIUtil fit:-10]);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.swich mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.equalTo(self.titleLabel);
    }];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.mas_equalTo([GUIUtil fit:-35]);
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset([GUIUtil fit:15]);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.right.mas_equalTo(0);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
}

- (void)updateData:(NSMutableDictionary *)dic
{
    _config = dic;
    self.titleLabel.text   = [NDataUtil stringWith:dic[@"title"] valid:@""];
    self.swich.on = [dic[@"swich"]boolValue];
    self.tx.text = self.swich.on == YES?[NDataUtil stringWith:dic[@"price"] valid:@""]:@"";
    self.tx.placeholder = self.swich.on == NO?[NDataUtil stringWith:dic[@"placeholder"] valid:@""]:@"";
    _tx.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_tx.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
    self.remarkLabel.text = [NDataUtil stringWith:dic[@"remark"]];
    self.remarkLabel.hidden=self.remarkLabel.text.length<=0;
    
    
}
#pragma mark ----
- (UILabel *)titleLabel
{
    if(!_titleLabel)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = [GUIUtil fitBoldFont:16];
        _titleLabel.textColor = [GColorUtil C2];
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.minimumScaleFactor = 0.5;
    }
    return _titleLabel;
}

- (UILabel *)remarkLabel
{
    if(!_remarkLabel)
    {
        _remarkLabel = [UILabel new];
        _remarkLabel.font = [GUIUtil fitBoldFont:12];
        _remarkLabel.textColor = [GColorUtil C14];
        _remarkLabel.numberOfLines=0;
    }
    return _remarkLabel;
}

- (UIView *)txBg
{
    if(!_txBg)
    {
        _txBg = [UIView new];
    }
    return _txBg;
}
- (UITextField *)tx
{
    if(!_tx)
    {
        _tx = [UITextField new];
        _tx.font = [GUIUtil fitBoldFont:16];
        _tx.delegate = self;
        _tx.textColor = [GColorUtil C2];
        _tx.keyboardType = UIKeyboardTypeDecimalPad;
        _tx.delegate = self;
        _tx.placeholder = @" ";
        _tx.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_tx.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
        [_tx addTarget:self action:@selector(txAction:) forControlEvents:UIControlEventEditingChanged];
        [_tx addToolbar];
    }
    return _tx;
}

- (UISwitch *)swich
{
    if(!_swich)
    {
        _swich = [UISwitch new];
        _swich.onTintColor = [GColorUtil C13];
        [_swich setOn:NO];
        [_swich addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];   // 开关事件切换通知
        _swich.transform = CGAffineTransformMakeScale(37/51.0f, 23/31.0f);
    }
    return _swich;
}

- (UIImageView *)chooseImage
{
    if(!_chooseImage)
    {
        _chooseImage = [UIImageView new];
        [_chooseImage setImage:[GColorUtil imageNamed:@"trade_popup_more"]];
       
    }
    return _chooseImage;
}
- (UILabel *)chooseTitle
{
    if(!_chooseTitle)
    {
        _chooseTitle = [UILabel new];
        _chooseTitle.font = [GUIUtil fitBoldFont:15];
        _chooseTitle.textColor = [GColorUtil C3];
    }
    return _chooseTitle;
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
- (void)switchAction:(UISwitch *)swich
{
    if(swich.on == NO)
    {
      [_tx resignFirstResponder];
        _tx.text = @"";

        [_config setObject:@"" forKey:@"remark"];
    }else
    {
        [_tx becomeFirstResponder];
    }
    [_config setObject:_tx.text forKey:@"price"];
    [_config setObject:@(swich.on) forKey:@"swich"];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    _swich.on = YES;
    [_config setObject:@(YES) forKey:@"swich"];
    
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField.text.length == 0){
        _swich.on = NO;
        [_config setObject:@(NO) forKey:@"swich"];
    }
    if(self.remarkLabel.hidden==NO){
        self.remarkLabel.hidden = NO;
        [_config setObject:@"" forKey:@"remark"];
        if (_reloadCell) {
            _reloadCell();
        }
    }
}
- (void)txAction:(UITextField *)textField
{
    
    [_config setObject:textField.text forKey:@"price"];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end

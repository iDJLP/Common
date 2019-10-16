//
//  FundRecordOtcCell.m
//  Bitmixs
//
//  Created by ngw15 on 2019/4/26.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "FundRecordOtcCell.h"

@interface FundRecordOtcCell ()

@property (nonatomic,strong)UIView *bgView;
@property (nonatomic,strong) UILabel *orderNoText;
@property (nonatomic,strong) UILabel *orderNoTitle;
@property (nonatomic,strong) UILabel *statusText;
@property (nonatomic,strong) UILabel *statusTitle;
@property (nonatomic,strong) UILabel *amountText;
@property (nonatomic,strong) UILabel *amountTitle;
@property (nonatomic,strong) UILabel *valueText;
@property (nonatomic,strong) UILabel *valueTitle;
@property (nonatomic,strong) UILabel *dateText;
@property (nonatomic,strong) UILabel *dateTitle;
@property (nonatomic,strong) UILabel *remainText;
@property (nonatomic,strong) UILabel *remainTitle;
@property (nonatomic,strong) UIImageView *arrowImgView;
@property (nonatomic,assign) NSInteger remainTime;
@property (nonatomic,strong) NSTimer *timer;
@end

@implementation FundRecordOtcCell

+ (CGFloat)heightOfCell{
    CGFloat height = [GUIUtil fit:15] + [GUIUtil fit:15] + [GUIUtil fitFont:14].lineHeight+[GUIUtil fit:2] + [GUIUtil fitFont:12].lineHeight + [GUIUtil fit:12] + [GUIUtil fitFont:14].lineHeight+[GUIUtil fit:2] + [GUIUtil fitFont:12].lineHeight + [GUIUtil fit:12] + [GUIUtil fitFont:14].lineHeight+[GUIUtil fit:2] + [GUIUtil fitFont:12].lineHeight + [GUIUtil fit:15];
    return ceil(height);
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.hasPressEffect = YES;
        self.bgColorType = C8_ColorType;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    
    [self.contentView addSubview:self.bgView];
    [self.bgView addSubview:self.orderNoText];
    [self.bgView addSubview:self.orderNoTitle];
    [self.bgView addSubview:self.statusText];
    [self.bgView addSubview:self.statusTitle];
    [self.bgView addSubview:self.dateText];
    [self.bgView addSubview:self.dateTitle];
    [self.bgView addSubview:self.remainText];
    [self.bgView addSubview:self.remainTitle];
    [self.bgView addSubview:self.amountText];
    [self.bgView addSubview:self.amountTitle];
    [self.bgView addSubview:self.valueText];
    [self.bgView addSubview:self.valueTitle];
    [self.bgView addSubview:self.arrowImgView];
}

- (void)autoLayout{
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.top.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.orderNoText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.orderNoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNoText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.orderNoText);
    }];
    [self.statusText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:182]);
    }];
    [self.statusTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.statusText);
    }];
    [self.amountText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNoTitle.mas_bottom).mas_offset([GUIUtil fit:12]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.amountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.amountText);
    }];
    [self.valueText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountText);
        make.left.mas_equalTo([GUIUtil fit:182]);
    }];
    [self.valueTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.valueText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.valueText);
    }];
    [self.dateText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.valueTitle.mas_bottom).mas_offset([GUIUtil fit:12]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.dateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.dateText);
        make.bottom.mas_equalTo([GUIUtil fit:-15]);
    }];
    [self.remainText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateText);
        make.left.mas_equalTo([GUIUtil fit:182]);
    }];
    [self.remainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remainText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.remainText);
    }];
    [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-7]);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)configCell:(NSDictionary *)dic{
    NSInteger status = [NDataUtil integerWith:dic[@"status"]];
    BOOL isDeposit = [NDataUtil boolWithDic:dic key:@"priceArrow" isEqual:@"BUY"];
    if (isDeposit==NO) {
        _amountTitle.text = CFDLocalizedString(@"卖出数量");
    }
    _remainTitle.hidden = _remainText.hidden = YES;
    NSString *statusText = @"";
    if (isDeposit) {
        _valueTitle.text = CFDLocalizedString(@"CNY支付金额");
        if (status==0) {
            statusText = CFDLocalizedString(@"失败");
            _statusText.textColor = [GColorUtil C14];
            _remainTitle.hidden = _remainText.hidden = YES;
            [_timer invalidate];
            _timer = nil;
        }else if (status==1){
            statusText = CFDLocalizedString(@"成功");
            _statusText.textColor = [GColorUtil C24];
            _remainTitle.hidden = _remainText.hidden = YES;
            [_timer invalidate];
            _timer = nil;
        }else if (status==2){
            statusText = CFDLocalizedString(@"交易中");
            _statusText.textColor = [GColorUtil C13];
            _remainTitle.hidden = _remainText.hidden = NO;
            _remainTime = [NDataUtil integerWith:dic[@"validTime"] valid:-1];
            if (_remainTime==0) {
                _remainTime=-1;
                self.remainTitle.hidden = self.remainText.hidden = YES;
                [_timer invalidate];
                _timer = nil;
            }else{
                [self configRemainTime];
            }
        }
    }else{
        _valueTitle.text = CFDLocalizedString(@"CNY到账金额");
        if (status==1){
            statusText = CFDLocalizedString(@"成功");
            _statusText.textColor = [GColorUtil C24];
        }else if (status==2){
            statusText = CFDLocalizedString(@"失败");
            _statusText.textColor = [GColorUtil C14];
        }else{
            statusText = CFDLocalizedString(@"处理中");
            _statusText.textColor = [GColorUtil C13];
        }
    }
    _orderNoText.text = [NDataUtil stringWith:dic[@"showCoinCode"]];
    
    NSString *amountTitle = isDeposit?CFDLocalizedString(@"购买数量"):CFDLocalizedString(@"卖出数量");
    _amountTitle.text = [NSString stringWithFormat:@"%@%@",[NDataUtil stringWith:dic[@"showCoinCode"]],amountTitle];
    _amountText.text = [NDataUtil stringWith:dic[@"ordermoney"]];
    _dateText.text = [NDataUtil stringWith:dic[@"tradetime"]];
    _valueText.text = [NDataUtil stringWith:dic[@"ordermoneyrmb"]];
    _statusText.text = statusText;
}

- (void)configRemainTime{
    WEAK_SELF;
    weakSelf.remainTime++;
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        weakSelf.remainTime--;
        weakSelf.remainText.text = [NSString stringWithFormat:CFDLocalizedString(@"%d分%d秒"),(int)weakSelf.remainTime/60,(int)weakSelf.remainTime%60];
        if (weakSelf.remainTime==0) {
            if (weakSelf.reloadHander) {
                weakSelf.reloadHander();
            }
            [timer invalidate];
            timer = nil;
            weakSelf.remainTitle.hidden = weakSelf.remainText.hidden = YES;
        }else if (weakSelf.remainTime<0){
            weakSelf.remainTitle.hidden = weakSelf.remainText.hidden = YES;
            [timer invalidate];
            timer = nil;
        }
    } repeats:YES];
    
}


//MARK: - Getter

- (UIView *)bgView{
    if (!_bgView) {
        _bgView = [[UIView alloc] init];
        _bgView.backgroundColor = [GColorUtil C15];
        _bgView.layer.cornerRadius = 4;
        _bgView.layer.masksToBounds = YES;
    }
    return _bgView;
}

- (UILabel *)orderNoText{
    if(!_orderNoText){
        _orderNoText = [[UILabel alloc] init];
        _orderNoText.textColor = [GColorUtil C2];
        _orderNoText.font = [GUIUtil fitFont:14];
        _orderNoText.text = @"--";
    }
    return _orderNoText;
}
- (UILabel *)orderNoTitle{
    if(!_orderNoTitle){
        _orderNoTitle = [[UILabel alloc] init];
        _orderNoTitle.textColor = [GColorUtil C3];
        _orderNoTitle.font = [GUIUtil fitFont:12];
        _orderNoTitle.text = CFDLocalizedString(@"币种");
    }
    return _orderNoTitle;
}
- (UILabel *)statusText{
    if(!_statusText){
        _statusText = [[UILabel alloc] init];
        _statusText.textColor = [GColorUtil C2];
        _statusText.font = [GUIUtil fitFont:14];
    }
    return _statusText;
}
- (UILabel *)statusTitle{
    if(!_statusTitle){
        _statusTitle = [[UILabel alloc] init];
        _statusTitle.textColor = [GColorUtil C3];
        _statusTitle.font = [GUIUtil fitFont:12];
        _statusTitle.text = CFDLocalizedString(@"状态");
    }
    return _statusTitle;
}
- (UILabel *)dateText{
    if(!_dateText){
        _dateText = [[UILabel alloc] init];
        _dateText.textColor = [GColorUtil C2];
        _dateText.font = [GUIUtil fitFont:14];
        _dateText.text = @"--";
    }
    return _dateText;
}
- (UILabel *)dateTitle{
    if(!_dateTitle){
        _dateTitle = [[UILabel alloc] init];
        _dateTitle.textColor = [GColorUtil C3];
        _dateTitle.font = [GUIUtil fitFont:12];
        _dateTitle.text = CFDLocalizedString(@"时间");
    }
    return _dateTitle;
}
- (UILabel *)amountText{
    if(!_amountText){
        _amountText = [[UILabel alloc] init];
        _amountText.textColor = [GColorUtil C2];
        _amountText.font = [GUIUtil fitFont:14];
        _amountText.text = @"--";
    }
    return _amountText;
}
- (UILabel *)amountTitle{
    if(!_amountTitle){
        _amountTitle = [[UILabel alloc] init];
        _amountTitle.textColor = [GColorUtil C3];
        _amountTitle.font = [GUIUtil fitFont:12];
        _amountTitle.text = CFDLocalizedString(@"购买数量");
    }
    return _amountTitle;
}
- (UILabel *)valueText{
    if(!_valueText){
        _valueText = [[UILabel alloc] init];
        _valueText.textColor = [GColorUtil C2];
        _valueText.font = [GUIUtil fitFont:14];
        _valueText.text = @"--";
    }
    return _valueText;
}
- (UILabel *)valueTitle{
    if(!_valueTitle){
        _valueTitle = [[UILabel alloc] init];
        _valueTitle.textColor = [GColorUtil C3];
        _valueTitle.font = [GUIUtil fitFont:12];
        _valueTitle.text = CFDLocalizedString(@"CNY支付金额");
    }
    return _valueTitle;
}
- (UILabel *)remainText{
    if(!_remainText){
        _remainText = [[UILabel alloc] init];
        _remainText.textColor = [GColorUtil C13];
        _remainText.font = [GUIUtil fitFont:14];
        _remainText.text = @"--";
        _remainText.hidden = YES;
    }
    return _remainText;
}
- (UILabel *)remainTitle{
    if(!_remainTitle){
        _remainTitle = [[UILabel alloc] init];
        _remainTitle.textColor = [GColorUtil C3];
        _remainTitle.font = [GUIUtil fitFont:12];
        _remainTitle.text = CFDLocalizedString(@"倒计时");
        _remainTitle.hidden = YES;
    }
    return _remainTitle;
}
- (UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"public_icon_more"]];
    }
    return _arrowImgView;
}


@end

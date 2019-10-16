//
//  ChainTradeView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/4/25.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "ChainTradeView.h"

@interface ChainTradeView()

@property (nonatomic,strong) UILabel *orderNoText;
@property (nonatomic,strong) UILabel *orderNoTitle;
@property (nonatomic,strong) UILabel *statusText;
@property (nonatomic,strong) UILabel *statusTitle;
@property (nonatomic,strong) UILabel *dateText;
@property (nonatomic,strong) UILabel *dateTitle;
@property (nonatomic,strong) UILabel *amountText;

@property (nonatomic,strong) UIImageView *arrowImgView;

@end

@implementation ChainTradeView

+ (CGFloat)heightOfView{
    CGFloat height = [GUIUtil fit:15] + [GUIUtil fitFont:14].lineHeight+[GUIUtil fit:2] + [GUIUtil fitFont:12].lineHeight + [GUIUtil fit:12] + [GUIUtil fitFont:14].lineHeight+[GUIUtil fit:2] + [GUIUtil fitFont:12].lineHeight + [GUIUtil fit:15];
    return ceil(height);
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [GColorUtil C15];
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.orderNoText];
    [self addSubview:self.orderNoTitle];
    [self addSubview:self.dateText];
    [self addSubview:self.dateTitle];
    [self addSubview:self.amountText];
    [self addSubview:self.amountTitle];
    [self addSubview:self.statusText];
    [self addSubview:self.statusTitle];
    [self addSubview:self.arrowImgView];
}


- (void)autoLayout{
    
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
    [self.dateText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNoTitle.mas_bottom).mas_offset([GUIUtil fit:12]);
        make.left.mas_equalTo([GUIUtil fit:182]);
        
    }];
    [self.dateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.dateText);
    }];
    
    [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-7]);
        make.centerY.mas_equalTo(0);
    }];
}

- (void)configView:(NSDictionary *)dic{
    NSInteger status = [NDataUtil integerWith:dic[@"status"]];
    BOOL isDeposit = [NDataUtil boolWithDic:dic key:@"priceArrow" isEqual:@"BUY"];
    NSString *statusText = @"";
    if (isDeposit) {
        if (status==0) {
            statusText = CFDLocalizedString(@"失败");
            _statusText.textColor = [GColorUtil C14];
        }else if (status==1){
            statusText = CFDLocalizedString(@"成功");
            _statusText.textColor = [GColorUtil C24];
        }else if (status==2){
            statusText = CFDLocalizedString(@"确认中");
            _statusText.textColor = [GColorUtil C13];
        }
    }else{
        if (status==1){
            statusText = CFDLocalizedString(@"成功");
            _statusText.textColor = [GColorUtil C24];
        }else if (status==2){
            statusText = CFDLocalizedString(@"失败");
            _statusText.textColor = [GColorUtil C14];
        }else{
            statusText = CFDLocalizedString(@"确认中");
            _statusText.textColor = [GColorUtil C13];
        }
    }
    _orderNoText.text = [NDataUtil stringWith:dic[@"showCoinCode"]];
    
    NSString *amountTitle = isDeposit?CFDLocalizedString(@"购买数量"):CFDLocalizedString(@"卖出数量");
    _amountTitle.text = [NSString stringWithFormat:@"%@%@",[NDataUtil stringWith:dic[@"showCoinCode"]],amountTitle];
    _statusText.text = statusText;
    _statusTitle.text = CFDLocalizedString(@"状态");
    _dateText.text = [NDataUtil stringWithDict:dic keys:@[@"tradetime",@"createTime"] valid:@""];
    _amountText.text = [NDataUtil stringWithDict:dic keys:@[@"ordermoney",@"amount"] valid:@""];
}

//MARK: - Getter

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
- (UILabel *)statusText{
    if(!_statusText){
        _statusText = [[UILabel alloc] init];
        _statusText.textColor = [GColorUtil C2];
        _statusText.font = [GUIUtil fitFont:14];
        _statusText.text = @"--";
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

- (UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"public_icon_more"]];
    }
    return _arrowImgView;
}

@end

//
//  OtcTradeView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/4/25.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "OtcTradeView.h"
#import "MarkView.h"
#import "FundRecordVC.h"

@interface OtcTradeView ()

@property (nonatomic,strong) UILabel *orderNoText;
@property (nonatomic,strong) UILabel *orderNoTitle;
@property (nonatomic,strong) UILabel *dateText;
@property (nonatomic,strong) UILabel *dateTitle;
@property (nonatomic,strong) UILabel *amountText;
@property (nonatomic,strong) UILabel *amountTitle;
@property (nonatomic,strong) UILabel *valueText;
@property (nonatomic,strong) UILabel *valueTitle;
@property (nonatomic,strong) MarkView *payType1Text;
@property (nonatomic,strong) MarkView *payType2Text;
@property (nonatomic,strong) MarkView *payType3Text;
@property (nonatomic,strong) UILabel *payTypeTitle;
@property (nonatomic,strong) UILabel *accountText;
@property (nonatomic,strong) UILabel *accountTitle;
@property (nonatomic,strong) UIButton *accountBtn;
@property (nonatomic,strong) UILabel *payeeText;
@property (nonatomic,strong) UILabel *payeeTitle;
@property (nonatomic,strong) UIButton *payeeBtn;
@property (nonatomic,strong) UILabel *remarkText;
@property (nonatomic,strong) UILabel *remarkTitle;
@property (nonatomic,strong) UIButton *remarkBtn;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UILabel *sureTitle;

@property (nonatomic,strong) UIButton *moreBtn;

@property (nonatomic,strong) NSDictionary *config;
@property (nonatomic,assign) NSInteger index;
@end

@implementation OtcTradeView

+ (CGFloat)heightOfView{
    CGFloat height = [GUIUtil fit:15] + [GUIUtil fitFont:14].lineHeight+[GUIUtil fit:2] + [GUIUtil fitFont:12].lineHeight + [GUIUtil fit:12] + [GUIUtil fitFont:14].lineHeight+[GUIUtil fit:2] + [GUIUtil fitFont:12].lineHeight + [GUIUtil fit:13];
    
    CGFloat bottomH = ([GUIUtil fit:13] + [GUIUtil fitFont:12].lineHeight)*4+[GUIUtil fit:15] + [GUIUtil fit:35]+[GUIUtil fit:15];
    height += bottomH;
    return ceil(height);
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [GColorUtil C15];
        _index = -1;
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
    [self addSubview:self.valueText];
    [self addSubview:self.valueTitle];
    [self addSubview:self.lineView];
    [self addSubview:self.payType1Text];
    [self addSubview:self.payType2Text];
    [self addSubview:self.payType3Text];
    
    [self addSubview:self.payTypeTitle];
    [self addSubview:self.accountText];
    [self addSubview:self.accountTitle];
    [self addSubview:self.accountBtn];
    [self addSubview:self.payeeText];
    [self addSubview:self.payeeTitle];
    [self addSubview:self.payeeBtn];
    [self addSubview:self.remarkText];
    [self addSubview:self.remarkTitle];
    [self addSubview:self.remarkBtn];
    [self addSubview:self.cancelBtn];
    [self addSubview:self.sureBtn];
    [self addSubview:self.sureTitle];
    [self addSubview:self.moreBtn];
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
    [self.dateText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:182]);
    }];
    [self.dateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.dateText);
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
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
        make.top.equalTo(self.valueTitle.mas_bottom).mas_offset([GUIUtil fit:13]);
    }];
    [self.payType1Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payTypeTitle);
        make.left.equalTo(self.payTypeTitle.mas_right).mas_offset([GUIUtil fit:-2]);
    }];
    [self.payType2Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payTypeTitle);
        make.left.equalTo(self.payType1Text.mas_right).mas_offset([GUIUtil fit:5]);
    }];
    [self.payType3Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payTypeTitle);
        make.left.equalTo(self.payType2Text.mas_right).mas_offset([GUIUtil fit:5]);
    }];
    [self.payTypeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.valueTitle.mas_bottom).mas_offset([GUIUtil fit:26]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.accountText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accountTitle);
        make.left.equalTo(self.accountTitle.mas_right).mas_offset([GUIUtil fit:-2]);
    }];
    [self.accountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payTypeTitle.mas_bottom).mas_offset([GUIUtil fit:12]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accountTitle);
        make.right.mas_equalTo([GUIUtil fit:-15]);
    }];
    [self.payeeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payeeTitle);
        make.left.equalTo(self.payeeTitle.mas_right).mas_offset([GUIUtil fit:-2]);
    }];
    [self.payeeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTitle.mas_bottom).mas_offset([GUIUtil fit:12]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.payeeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payeeTitle);
        make.right.mas_equalTo([GUIUtil fit:-15]);
    }];
    [self.remarkText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.remarkTitle);
        make.left.equalTo(self.remarkTitle.mas_right).mas_offset([GUIUtil fit:-2]);
    }];
    [self.remarkTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payeeTitle.mas_bottom).mas_offset([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.remarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.remarkTitle);
        make.right.mas_equalTo([GUIUtil fit:-15]);
    }];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountTitle);
        make.top.equalTo(self.remarkTitle.mas_bottom).mas_offset([GUIUtil fit:15]);
        make.size.mas_equalTo([GUIUtil fitWidth:150 height:35]);
    }];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.size.mas_equalTo([GUIUtil fitWidth:150 height:35]);
        make.top.equalTo(self.cancelBtn);
        make.bottom.mas_equalTo([GUIUtil fit:-15-55]);
    }];
    [_sureTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.equalTo(self.sureBtn);
    }];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo([GUIUtil fit:-15]);
        make.height.mas_equalTo([GUIUtil fit:44]);
    }];
}

//MARK: - Action

- (void)copyText:(UIButton *)btn{
    NSArray *list = [NDataUtil arrayWith:_config[@"receivables"]];
    NSDictionary *dic = [NDataUtil dictWithArray:list index:_index];
    NSString *text = @"";
    if (btn==_accountBtn) {
        text = [NDataUtil stringWith:dic[@"receivablesNum"]];
    }else if (btn==_payeeBtn){
        text = [NDataUtil stringWith:dic[@"receivablesName"]];
    }else if (btn==_remarkBtn){
        text = [NDataUtil stringWith:_config[@"postScript"]];
    }
    if (text.length>0) {
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = text;
        [HUDUtil showInfo:CFDLocalizedString(@"复制成功")];
    }else{
        if (btn!=_remarkBtn) {
            [HUDUtil showInfo:CFDLocalizedString(@"请刷新重试")];
        }
    }
}

- (void)cancelHander{
    WEAK_SELF;
    [HUDUtil showProgress:@""];
    [DCService getpayCancelOrder:[NDataUtil stringWith:_config[@"orderid"]] logId:[NDataUtil stringWith:_config[@"logid"]] success:^(id data) {
        
        [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            weakSelf.refreshData();
        }
        
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

- (void)cancelAction{
    WEAK_SELF;
    [DCAlert showAlert:@"" detail:CFDLocalizedString(@"确定取消订单") sureTitle:CFDLocalizedString(@"确定") sureHander:^{
        [weakSelf cancelHander];
    } cancelTitle:CFDLocalizedString(@"取消") cancelHander:^{
        
    }];
    
}

- (void)sureAction{
    WEAK_SELF;
    [DCService getpayConfirmOrder:[NDataUtil stringWith:_config[@"orderid"]] logId:[NDataUtil stringWith:_config[@"logid"]] success:^(id data) {
        [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            weakSelf.refreshData();
        }
        
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

- (void)moreAction{
    [FundRecordVC jumpTo:0];
}

- (void)configView:(NSDictionary *)dic{
    _config = dic;
    _orderNoText.text = [NDataUtil stringWith:dic[@"showCoinCode"]];
    _amountTitle.text = [NSString stringWithFormat:@"%@%@",[NDataUtil stringWith:dic[@"showCoinCode"]],CFDLocalizedString(@"购买数量")];
    _amountText.text = [NDataUtil stringWith:dic[@"amount"]];
    _dateText.text = [NDataUtil stringWith:dic[@"createTime"]];
    _valueText.text = [NDataUtil stringWith:dic[@"amountrmb"]];
    [self selectedIndex:_index==-1?0:_index];
    NSInteger status = [NDataUtil integerWith:dic[@"paystatus"]];
    if (status==0||status==5||status==2){
        if (status==0||status==5) {
            _cancelBtn.hidden = _sureBtn.hidden = NO;
            _sureTitle.hidden = YES;
        }else{
            _sureTitle.hidden = NO;
            _cancelBtn.hidden = _sureBtn.hidden = YES;
        }
    }else{
        _cancelBtn.hidden = _sureBtn.hidden = _sureTitle.hidden = YES;
    }
}

- (void)selectedIndex:(NSInteger)index{
    
    _index = index;
    NSArray *typeList = [NDataUtil arrayWith:_config[@"receivables"]];
    if (typeList.count==3) {
        NSDictionary *dic1 = typeList[0];
        NSDictionary *dic2 = typeList[1];
        NSDictionary *dic3 = typeList[2];
        _payType1Text.text = [NDataUtil stringWith:dic1[@"receivablesMode"]];
        _payType2Text.text = [NDataUtil stringWith:dic2[@"receivablesMode"]];
        _payType3Text.text = [NDataUtil stringWith:dic3[@"receivablesMode"]];
        _payType3Text.hidden =
        _payType2Text.hidden = NO;
        if (index==0) {
            [self configAccountInfo:dic1];
            _payType1Text.textColor = [GColorUtil C13];
            _payType1Text.layer.borderColor = GColorUtil.C13.CGColor;
            _payType2Text.textColor = [GColorUtil C2];
            _payType2Text.layer.borderColor = GColorUtil.C2.CGColor;
            _payType3Text.textColor = [GColorUtil C2];
            _payType3Text.layer.borderColor = GColorUtil.C2.CGColor;
        }else if(index==1){
            [self configAccountInfo:dic2];
            _payType1Text.textColor = [GColorUtil C2];
            _payType1Text.layer.borderColor = GColorUtil.C2.CGColor;
            _payType3Text.textColor = [GColorUtil C2];
            _payType3Text.layer.borderColor = GColorUtil.C2.CGColor;
            _payType2Text.textColor = [GColorUtil C13];
            _payType2Text.layer.borderColor = GColorUtil.C13.CGColor;
        }else{
            [self configAccountInfo:dic3];
            _payType1Text.textColor = [GColorUtil C2];
            _payType1Text.layer.borderColor = GColorUtil.C2.CGColor;
            _payType2Text.textColor = [GColorUtil C2];
            _payType2Text.layer.borderColor = GColorUtil.C2.CGColor;
            _payType3Text.textColor = [GColorUtil C13];
            _payType3Text.layer.borderColor = GColorUtil.C13.CGColor;
        }
    }else if (typeList.count==2) {
        NSDictionary *dic1 = typeList[0];
        NSDictionary *dic2 = typeList[1];
        _payType1Text.text = [NDataUtil stringWith:dic1[@"receivablesMode"]];
        _payType2Text.text = [NDataUtil stringWith:dic2[@"receivablesMode"]];
        _payType2Text.hidden = NO;
        _payType3Text.hidden = YES;
        if (index==0) {
            [self configAccountInfo:dic1];
            _payType1Text.textColor = [GColorUtil C13];
            _payType1Text.layer.borderColor = GColorUtil.C13.CGColor;
            _payType2Text.textColor = [GColorUtil C2];
            _payType2Text.layer.borderColor = GColorUtil.C2.CGColor;
        }else{
            [self configAccountInfo:dic2];
            _payType1Text.textColor = [GColorUtil C2];
            _payType1Text.layer.borderColor = GColorUtil.C2.CGColor;
            _payType2Text.textColor = [GColorUtil C13];
            _payType2Text.layer.borderColor = GColorUtil.C13.CGColor;
        }
    }else if (typeList.count==1){
        NSDictionary *dic1 = typeList[0];
        _payType1Text.text = [NDataUtil stringWith:dic1[@"receivablesMode"]];
        _payType3Text.hidden =
        _payType2Text.hidden = YES;
        [self configAccountInfo:dic1];
        _payType1Text.textColor = [GColorUtil C13];
        _payType1Text.layer.borderColor = GColorUtil.C13.CGColor;
    }else{
        return;
    }
    _remarkText.text = [NDataUtil stringWith:_config[@"postScript"] valid:@"--"];
    
}

- (void)configAccountInfo:(NSDictionary *)dic{
    
    _accountText.text = [NDataUtil stringWith:dic[@"receivablesNum"]];
    _payeeText.text = [NDataUtil stringWith:dic[@"receivablesName"]];
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
- (MarkView *)payType1Text{
    if(!_payType1Text){
        _payType1Text = [[MarkView alloc] init];
        _payType1Text.textColor = [GColorUtil C2];
        _payType1Text.font = [GUIUtil fitFont:10];
        _payType1Text.hPadding = [GUIUtil fit:5];
        _payType1Text.vPadding = [GUIUtil fit:2];
        _payType1Text.layer.borderWidth = 1;
        _payType1Text.layer.cornerRadius = 4;
        _payType1Text.layer.masksToBounds = YES;
        WEAK_SELF;
        [_payType1Text g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf selectedIndex:0];
        }];
    }
    return _payType1Text;
}
- (MarkView *)payType2Text{
    if(!_payType2Text){
        _payType2Text = [[MarkView alloc] init];
        _payType2Text.textColor = [GColorUtil C2];
        _payType2Text.font = [GUIUtil fitFont:10];
        _payType2Text.hPadding = [GUIUtil fit:5];
        _payType2Text.vPadding = [GUIUtil fit:2];
        _payType2Text.layer.borderWidth = 1;
        _payType2Text.layer.cornerRadius = 4;
        _payType2Text.layer.masksToBounds = YES;
        WEAK_SELF;
        [_payType2Text g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf selectedIndex:1];
        }];
    }
    return _payType2Text;
}
- (MarkView *)payType3Text{
    if(!_payType3Text){
        _payType3Text = [[MarkView alloc] init];
        _payType3Text.textColor = [GColorUtil C2];
        _payType3Text.font = [GUIUtil fitFont:10];
        _payType3Text.hPadding = [GUIUtil fit:5];
        _payType3Text.vPadding = [GUIUtil fit:2];
        _payType3Text.layer.borderWidth = 1;
        _payType3Text.layer.cornerRadius = 4;
        _payType3Text.layer.masksToBounds = YES;
        WEAK_SELF;
        [_payType3Text g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf selectedIndex:2];
        }];
    }
    return _payType3Text;
}
- (UILabel *)payTypeTitle{
    if(!_payTypeTitle){
        _payTypeTitle = [[UILabel alloc] init];
        _payTypeTitle.textColor = [GColorUtil C2];
        _payTypeTitle.font = [GUIUtil fitFont:12];
        _payTypeTitle.text = CFDLocalizedString(@"收款方式：");
    }
    return _payTypeTitle;
}
- (UILabel *)accountText{
    if(!_accountText){
        _accountText = [[UILabel alloc] init];
        _accountText.textColor = [GColorUtil C2];
        _accountText.font = [GUIUtil fitFont:12];
        _accountText.text = @"--";
    }
    return _accountText;
}
- (UILabel *)accountTitle{
    if(!_accountTitle){
        _accountTitle = [[UILabel alloc] init];
        _accountTitle.textColor = [GColorUtil C2];
        _accountTitle.font = [GUIUtil fitFont:14];
        _accountTitle.text = CFDLocalizedString(@"收款账号：");
    }
    return _accountTitle;
}
- (UIButton *)accountBtn{
    if(!_accountBtn){
        _accountBtn = [[UIButton alloc] init];
        [_accountBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        _accountBtn.titleLabel.font = [GUIUtil fitFont:12];
        [_accountBtn setTitle:CFDLocalizedString(@"复制") forState:UIControlStateNormal];
        [_accountBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
        [_accountBtn addTarget:self action:@selector(copyText:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accountBtn;
}
- (UILabel *)payeeText{
    if(!_payeeText){
        _payeeText = [[UILabel alloc] init];
        _payeeText.textColor = [GColorUtil C2];
        _payeeText.font = [GUIUtil fitFont:14];
        _payeeText.text = @"--";
    }
    return _payeeText;
}
- (UILabel *)payeeTitle{
    if(!_payeeTitle){
        _payeeTitle = [[UILabel alloc] init];
        _payeeTitle.textColor = [GColorUtil C2];
        _payeeTitle.font = [GUIUtil fitFont:14];
        _payeeTitle.text = CFDLocalizedString(@"收款人：");
    }
    return _payeeTitle;
}
- (UIButton *)payeeBtn{
    if(!_payeeBtn){
        _payeeBtn = [[UIButton alloc] init];
        [_payeeBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        _payeeBtn.titleLabel.font = [GUIUtil fitFont:12];
        [_payeeBtn setTitle:CFDLocalizedString(@"复制") forState:UIControlStateNormal];
        [_payeeBtn addTarget:self action:@selector(copyText:) forControlEvents:UIControlEventTouchUpInside];
        [_payeeBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _payeeBtn;
}
- (UILabel *)remarkText{
    if(!_remarkText){
        _remarkText = [[UILabel alloc] init];
        _remarkText.textColor = [GColorUtil C2];
        _remarkText.font = [GUIUtil fitFont:14];
        _remarkText.text = @"--";
    }
    return _remarkText;
}
- (UILabel *)remarkTitle{
    if(!_remarkTitle){
        _remarkTitle = [[UILabel alloc] init];
        _remarkTitle.textColor = [GColorUtil C2];
        _remarkTitle.font = [GUIUtil fitFont:12];
        _remarkTitle.text = CFDLocalizedString(@"附言：");
    }
    return _remarkTitle;
}
- (UIButton *)remarkBtn{
    if(!_remarkBtn){
        _remarkBtn = [[UIButton alloc] init];
        [_remarkBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        _remarkBtn.titleLabel.font = [GUIUtil fitFont:12];
        [_remarkBtn setTitle:CFDLocalizedString(@"复制") forState:UIControlStateNormal];
        [_remarkBtn addTarget:self action:@selector(copyText:) forControlEvents:UIControlEventTouchUpInside];
        [_remarkBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _remarkBtn;
}
- (UIButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.titleLabel.font = [GUIUtil fitFont:14];
        _cancelBtn.layer.cornerRadius = [GUIUtil fit:4];
        _cancelBtn.layer.borderColor = [GColorUtil C3].CGColor;
        _cancelBtn.layer.borderWidth = [GUIUtil fitLine];
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn setTitleColor:[GColorUtil C3] forState:UIControlStateNormal];
        [_cancelBtn setTitle:CFDLocalizedString(@"取消订单") forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _cancelBtn;
}
- (UIButton *)sureBtn{
    if(!_sureBtn){
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.titleLabel.font = [GUIUtil fitFont:14];
        _sureBtn.layer.cornerRadius = [GUIUtil fit:4];
        _sureBtn.layer.borderColor = [GColorUtil C13].CGColor;
        _sureBtn.layer.borderWidth = [GUIUtil fitLine];
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        [_sureBtn setTitle:CFDLocalizedString(@"确认已付款") forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _sureBtn;
}
- (UILabel *)sureTitle{
    if(!_sureTitle){
        _sureTitle = [[UILabel alloc] init];
        _sureTitle.textColor = [GColorUtil C3];
        _sureTitle.font = [GUIUtil fitFont:14];
        _sureTitle.text = CFDLocalizedString(@"已确认付款，等待卖家确认");
    }
    return _sureTitle;
}

- (UIButton *)moreBtn{
    if(!_moreBtn){
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.titleLabel.font = [GUIUtil fitFont:14];
        [_moreBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        [_moreBtn setTitle:CFDLocalizedString(@"查看更多记录") forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreBtn;
}

@end

//
//  ChainDrawlView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/28.
//  Copyright © 2019 taojinzhe. All rights reserved.
//


#import "ChainDrawlView.h"
#import "QRCodeVC.h"
#import "AuthAlert.h"
#import "PwdAlert.h"
#import "CurrenttypeSelectedSheet.h"
#import "AddressSelectedSheet.h"

@interface ChainDrawlView ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIView *varityView;
@property (nonatomic,strong) UILabel *varityTitle;
@property (nonatomic,strong) UILabel *varityText;
@property (nonatomic,strong) UIImageView *varityArrowImg;
@property (nonatomic,strong) UIView *balanceView;
@property (nonatomic,strong) UILabel *balanceTitle;
@property (nonatomic,strong) UILabel *balanceText;
@property (nonatomic,strong) UILabel *balanceUnit;
@property (nonatomic,strong) UILabel *enableSellTitle;
@property (nonatomic,strong) UILabel *enableSellText;
@property (nonatomic,strong) UILabel *enableSellUnit;
@property (nonatomic,strong) UILabel *feeTitle;
@property (nonatomic,strong) UILabel *feeText;

@property (nonatomic,strong) UILabel *addressTitle;
@property (nonatomic,strong) UITextField *addressText;
@property (nonatomic,strong) UIButton *addressBtn;
@property (nonatomic,strong) UIButton *addressMoreBtn;

@property (nonatomic,strong) UIView *addressLine;
@property (nonatomic,strong) UILabel *usdtTitle;
@property (nonatomic,strong) UITextField *usdtText;
@property (nonatomic,strong) UIButton *usdtBtn;
@property (nonatomic,strong) UIView *usdtLine;

@property (nonatomic,strong) UILabel *remarkLabel;
@property (nonatomic,strong) UIButton *commitBtn;
@property (nonatomic,strong) UIView *spaceView;
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,copy) NSString *minAmount;
@property (nonatomic,copy) NSString *maxAmount;
@property (nonatomic,assign) BOOL isLoaded;

@end

@implementation ChainDrawlView

-(void)dealloc{
    [self removeNotic];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self autoLayout];
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
        _tap.delegate = self;
        [self addGestureRecognizer:_tap];
        [self addNotic];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.varityView];
    [self.varityView addSubview:self.varityTitle];
    [self.varityView addSubview:self.varityText];
    [self.varityView addSubview:self.varityArrowImg];
    [self addSubview:self.balanceView];
    [self addSubview:self.balanceTitle];
    [self addSubview:self.balanceText];
    [self addSubview:self.balanceUnit];
    [self addSubview:self.enableSellTitle];
    [self addSubview:self.enableSellText];
    [self addSubview:self.enableSellUnit];
    [self addSubview:self.feeTitle];
    [self addSubview:self.feeText];
    
    [self addSubview:self.addressTitle];
    [self addSubview:self.addressText];
    [self addSubview:self.addressBtn];
    [self addSubview:self.addressMoreBtn];
    [self addSubview:self.addressLine];
    [self addSubview:self.usdtTitle];
    [self addSubview:self.usdtText];
    [self addSubview:self.usdtBtn];
    [self addSubview:self.usdtLine];
    [self  addSubview:self.remarkLabel];
    [self  addSubview:self.commitBtn];
    [self  addSubview:self.spaceView];
}

- (void)autoLayout{
    [_varityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:60]);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [_varityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:60]);
    }];
    [_varityText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.varityArrowImg.mas_left).mas_offset([GUIUtil fit:-15]);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:60]);
    }];
    [_varityArrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.mas_equalTo(self.varityText);
    }];
    [_balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.varityView.mas_bottom).mas_offset([GUIUtil fit:5]);
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:30]);
    }];
    [_balanceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceView).mas_offset([GUIUtil fit:14]);
        make.left.mas_equalTo([GUIUtil  fit:30]);
    }];
    CGFloat left = [[FTConfig sharedInstance].lang isEqualToString:@"en"]?[GUIUtil  fit:160]:[GUIUtil  fit:115];
    [_balanceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.centerY.equalTo(self.balanceTitle);
        
    }];
    [_balanceUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-30]);
        make.centerY.equalTo(self.balanceTitle);
    }];
    [_enableSellTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceTitle.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.left.mas_equalTo([GUIUtil  fit:30]);
    }];
    [_enableSellText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(left);
        make.centerY.equalTo(self.enableSellTitle);
    }];
    [_enableSellUnit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-30]);
        make.centerY.equalTo(self.enableSellTitle);
    }];
    [_feeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.enableSellTitle.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.left.mas_equalTo([GUIUtil  fit:30]);
        make.bottom.equalTo(self.balanceView).mas_offset([GUIUtil fit:-14]);
    }];
    [_feeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.feeTitle);
        make.left.mas_equalTo(left);
    }];
    
    [_addressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceView.mas_bottom).mas_offset([GUIUtil fit:25]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [_addressText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressTitle.mas_bottom).mas_offset([GUIUtil fit:5]);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.height.mas_equalTo([GUIUtil fit:45]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:100]);
    }];
    [_addressBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.addressMoreBtn.mas_left).mas_offset([GUIUtil fit:-15]);
        make.centerY.equalTo(self.addressText);
    }];
    [_addressMoreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-15]);
        make.centerY.equalTo(self.addressText);
    }];
    [_addressLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fitLine]);
        make.bottom.equalTo(self.addressText);
    }];
    [_usdtTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.addressText.mas_bottom).mas_offset([GUIUtil fit:25]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [_usdtText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usdtTitle.mas_bottom).mas_offset([GUIUtil fit:5]);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.height.mas_equalTo([GUIUtil fit:45]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:100]);
    }];
    [_usdtBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-15]);
        make.centerY.equalTo(self.usdtText);
    }];
    [_usdtLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fitLine]);
        make.bottom.equalTo(self.usdtText);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil  fit:15]*2);
        make.top.equalTo(self.usdtText.mas_bottom).mas_offset([GUIUtil  fit:25]);
    }];
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil  fit:15]*2);
        make.top.equalTo(self.remarkLabel.mas_bottom).mas_offset([GUIUtil  fit:40]);
        make.height.mas_equalTo([GUIUtil  fit:45]);
    }];
    [_spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_greaterThanOrEqualTo([GUIUtil fit:40]);
        make.top.equalTo(self.commitBtn.mas_bottom);
        make.bottom.mas_equalTo(-1).priority(500);
    }];
}

- (void)willAppear{
    [self configVC:@{}];
    [[UserModel sharedInstance] getUserIndex:^{
        
    } failure:^{
        
    }];
    if (_isLoaded==NO) {
        [self loadData];
    }
}

- (void)refreshData{
    [self loadData];
    [[UserModel sharedInstance] getUserIndex:^{
        
    } failure:^{
        
    }];
}

- (void)loadData{
    WEAK_SELF;
    NSString *type = _type.copy;
    [DCService getAvailData:_type isOTC:NO priceArrow:NO success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]&&[type isEqualToString:weakSelf.type]) {
            weakSelf.isLoaded = YES;
            [weakSelf configInfo:data[@"data"]];
        }
        [HUDUtil hide];
    } failure:^(NSError *error) {
        [HUDUtil hide];
    }];
}

- (void)configInfo:(NSDictionary *)config{
    if (config.count<=0) {
        return;
    }
    _balanceText.text = [NDataUtil stringWith:config[@"totalamount"] valid:@"--"];
    _enableSellText.text = [NDataUtil stringWith:config[@"amount"] valid:@"--"];
    _feeText.text = [NDataUtil stringWith:config[@"walletfeetext"] valid:@"--"];
    NSString *remark = [NDataUtil stringWith:config[@"randomamountdesc"]];
    if ([remark containsString:@"<br/>"]) {
        remark = [remark stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\r\n"];
    }
    _remarkLabel.text = remark;
    _minAmount = [NDataUtil stringWith:config[@"minWarnValue"]];
    _maxAmount = [NDataUtil stringWith:config[@"maxWarnValue"]];
    
    self.usdtText.placeholder = [NSString stringWithFormat:@"%@%@%@",CFDLocalizedString(@"输入提币数量，最少"),_minAmount,_type];
    _usdtText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_usdtText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType]}];
    [self currentyChanged];
}

- (void)configVC:(NSDictionary *)config{
   

    
}

- (void)currentyChanged{
    _varityText.text =
    _balanceUnit.text = 
    _enableSellUnit.text = _type;
    
}

- (void)hidenKeyboard{
    [_usdtText resignFirstResponder];
    [_addressText resignFirstResponder];
}

- (void)addressChanged{
    
}

- (void)usdtTextChanged{
    if (_usdtText.text.length>0) {
        _usdtText.font = [GUIUtil fitFont:20];
    }else{
        _usdtText.font = [GUIUtil fitFont:14];
    }
}

- (void)commitAction{
    if ([_addressText.text length]<=0) {
        [HUDUtil showInfo:CFDLocalizedString(@"请输入提币地址")];
        return;
    }
    
    if ([GUIUtil compareFloat:_usdtText.text with:_enableSellText.text]==NSOrderedDescending) {
        [HUDUtil showInfo:CFDLocalizedString(@"余额不足")];
        return;
    }
    
    if ([GUIUtil compareFloat:_usdtText.text with:_minAmount]==NSOrderedAscending) {
        [HUDUtil showInfo:[NSString stringWithFormat:@"%@%@%@",CFDLocalizedString(@"最小提现金额不能小于"),_minAmount,_type]];
        return;
    }
    if ([GUIUtil compareFloat:_usdtText.text with:_maxAmount]==NSOrderedDescending) {
        [HUDUtil showInfo:[NSString stringWithFormat:@"%@%@%@",CFDLocalizedString(@"最大提现金额不能大于"),_maxAmount,_type]];
        return;
    }
    WEAK_SELF;
    if ([UserModel sharedInstance].openGoogleAuth) {
        [AuthAlert showAlert:^{
            [weakSelf commitOrder];
        }];
    }else{
        [PwdAlert showAlert:^{
            [weakSelf commitOrder];
        }];
    }
}

- (void)commitOrder{
    
    NSString *amount = _usdtText.text;
    WEAK_SELF;
    [HUDUtil showProgress:@""];
    [DCService commitChainDrawl:amount address:_addressText.text currenttype:_type success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:CFDLocalizedString(@"提现提交成功")]];
            weakSelf.usdtText.text = @"";
            [weakSelf usdtTextChanged];
            [weakSelf loadData];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSInteger _decLength = 8;
    if ([string isEqualToString:@"."]) {
        NSInteger l = textField.text.length-range.location;
        if (l>_decLength) {
            return NO;
        }
    }
    NSRange ran = [textField.text rangeOfString:@"."];
    BOOL flag = ran.location != NSNotFound&&(ran.length+ran.location<=textField.text.length);
    BOOL pointFlag = [string isEqualToString:@"."];
    NSInteger pointNum =textField.text.length-_decLength;
    NSInteger ranNum = ran.length+ran.location;
    BOOL decFlag = (ran.location == NSNotFound)||(ranNum-pointNum>0); //小数点后是否没到两位
    BOOL numFlag = ([string integerValue]>0&&[string integerValue]<=9)||[string isEqualToString:@"0"];
    if (textField == _usdtText){
        BOOL isReturn = NO;
        if (!flag&&pointFlag){
            isReturn = YES;
        }else if (numFlag&&decFlag) {
            isReturn = YES;
        }
        if (isReturn) {
            //限制长度9位;
            NSInteger strLength = textField.text.length - range.length + string.length;
            return (strLength <= 10+_decLength);
        }else{
            return NO;
        }
    }
    return YES;
}

- (void)allAction{
    _usdtText.text = _enableSellText.text;
    [self usdtTextChanged];
}

- (void)addressSelectedAction{
    [_usdtText resignFirstResponder];
    [_addressText resignFirstResponder];
    WEAK_SELF;
    [AddressSelectedSheet showAlert:CFDLocalizedString(@"请选择出金地址") selected:weakSelf.addressText.text type:_type sureHander:^(NSDictionary * _Nonnull dict) {
        weakSelf.addressText.text = [NDataUtil stringWith:dict[@"address"]];
        [weakSelf addressChanged];
    }];
}

- (void)addressAction{
    WEAK_SELF;
    [QRCodeVC jumpToFetchAddress:^(NSString *address) {
        weakSelf.addressText.text = address;
        [weakSelf addressChanged];
    }];
}

- (void)addNotic{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)removeNotic{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notic{
    if (_usdtText.isFirstResponder||_addressText.isFirstResponder) {
        CGRect textFieldRect = [[GJumpUtil window] convertRect:self.usdtText.frame fromView:self];
        CGFloat textFieldBottom = CGRectGetMaxY(textFieldRect);
        CGFloat keyboardFrameH = [[[notic userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height; //获得键盘
        BOOL flag = textFieldBottom+keyboardFrameH>SCREEN_HEIGHT;
        if (flag) {
            CGFloat duration = [[[notic userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]; //获得键盘时间
            WEAK_SELF;
            [UIView animateWithDuration:duration animations:^{
                CGFloat top = -(textFieldBottom+keyboardFrameH-SCREEN_HEIGHT);
                weakSelf.transform = CGAffineTransformMakeTranslation(0, top);
            }];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notic{
    CGFloat duration = [[[notic userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]; //获得键盘时间
    WEAK_SELF;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.transform = CGAffineTransformIdentity;
    }];
}


//MARK:Getter


- (UIView *)varityView{
    if (!_varityView) {
        _varityView = [[UIView alloc] init];
        _varityView.backgroundColor = [GColorUtil C6];
        WEAK_SELF;
        [_varityView g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf endEditing:YES];
            [CurrenttypeSelectedSheet showAlert:CFDLocalizedString(@"请选择币种") selected:weakSelf.type sureHander:^(NSDictionary * _Nonnull dic) {
                weakSelf.type = [NDataUtil stringWith:dic[@"currency"]];
                [weakSelf configInfo:nil];
                weakSelf.addressText.text = @""; weakSelf.usdtText.placeholder = [NSString stringWithFormat:@"%@--%@",CFDLocalizedString(@"输入提币数量，最少"),weakSelf.type];
                weakSelf.usdtText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:weakSelf.usdtText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType]}];
                weakSelf.usdtText.text = @"";
                [weakSelf usdtTextChanged];
                [weakSelf currentyChanged];
                [HUDUtil showProgress:@""];
                [weakSelf loadData];
            }];
        }];
    }
    return _varityView;
}

- (UILabel *)varityTitle{
    if(!_varityTitle){
        _varityTitle = [[UILabel alloc] init];
        _varityTitle.textColor = [GColorUtil C2];
        _varityTitle.font = [GUIUtil  fitBoldFont:16];
        _varityTitle.text = CFDLocalizedString(@"币种");
    }
    return _varityTitle;
}

- (UILabel *)varityText{
    if(!_varityText){
        _varityText = [[UILabel alloc] init];
        _varityText.textColor = [GColorUtil C2];
        _varityText.font = [GUIUtil  fitBoldFont:16];
    }
    return _varityText;
}

- (UIImageView *)varityArrowImg{
    if (!_varityArrowImg) {
        _varityArrowImg=[[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"market_icon_under_blue_down"]];
    }
    return _varityArrowImg;
}

- (UIView *)balanceView{
    if (!_balanceView) {
        _balanceView = [UIView new];
        _balanceView.backgroundColor = [GColorUtil C16];
        _balanceView.layer.cornerRadius = 4;
        _balanceView.layer.masksToBounds = YES;
    }
    return _balanceView;
}
- (UILabel *)balanceTitle{
    if (!_balanceTitle) {
        _balanceTitle = [UILabel new];
        _balanceTitle.textColor = [GColorUtil C3];
        _balanceTitle.font = [GUIUtil fitFont:14];
        _balanceTitle.text = CFDLocalizedString(@"总余额");
    }
    return _balanceTitle;
}
- (UILabel *)balanceText{
    if (!_balanceText) {
        _balanceText = [UILabel new];
        _balanceText.textColor = [GColorUtil C2];
        _balanceText.font = [GUIUtil fitBoldFont:14];
    }
    return _balanceText;
}
- (UILabel *)balanceUnit{
    if (!_balanceUnit) {
        _balanceUnit = [UILabel new];
        _balanceUnit.textColor = [GColorUtil C2];
        _balanceUnit.font = [GUIUtil fitBoldFont:14];
//        _balanceUnit.text = @"USDT";
    }
    return _balanceUnit;
}
- (UILabel *)enableSellTitle{
    if (!_enableSellTitle) {
        _enableSellTitle = [UILabel new];
        _enableSellTitle.textColor = [GColorUtil C3];
        _enableSellTitle.font = [GUIUtil fitFont:14];
        _enableSellTitle.text = CFDLocalizedString(@"可提金额");
    }
    return _enableSellTitle;
}
- (UILabel *)enableSellText{
    if (!_enableSellText) {
        _enableSellText = [UILabel new];
        _enableSellText.textColor = [GColorUtil C2];
        _enableSellText.font = [GUIUtil fitBoldFont:14];
    }
    return _enableSellText;
}
- (UILabel *)enableSellUnit{
    if (!_enableSellUnit) {
        _enableSellUnit = [UILabel new];
        _enableSellUnit.textColor = [GColorUtil C2];
        _enableSellUnit.font = [GUIUtil fitBoldFont:14];
//        _enableSellUnit.text = @"USDT";
    }
    return _enableSellUnit;
}
- (UILabel *)feeTitle{
    if (!_feeTitle) {
        _feeTitle = [UILabel new];
        _feeTitle.textColor = [GColorUtil C3];
        _feeTitle.font = [GUIUtil fitFont:14];
        _feeTitle.text = CFDLocalizedString(@"手续费");
    }
    return _feeTitle;
}
- (UILabel *)feeText{
    if (!_feeText) {
        _feeText = [UILabel new];
        _feeText.textColor = [GColorUtil C2];
        _feeText.font = [GUIUtil fitBoldFont:14];
        
    }
    return _feeText;
}

- (UILabel *)addressTitle{
    if(!_addressTitle){
        _addressTitle = [[UILabel alloc] init];
        _addressTitle.textColor = [GColorUtil C2];
        _addressTitle.font = [GUIUtil  fitFont:14];
        _addressTitle.text = CFDLocalizedString(@"提币地址");
    }
    return _addressTitle;
}

- (UITextField *)addressText{
    if(!_addressText){
        _addressText = [[UITextField alloc] init];
        _addressText.textColor = [GColorUtil C2];
        _addressText.font = [GUIUtil  fitFont:14];
        _addressText.textAlignment = NSTextAlignmentLeft;
        _addressText.placeholder = CFDLocalizedString(@"输入地址或点击右方图标扫码");
        _addressText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_addressText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType]}];
        WEAK_SELF;
        [_addressText addTarget:weakSelf action:@selector(addressChanged) forControlEvents:UIControlEventEditingChanged];
        _addressText.adjustsFontSizeToFitWidth = YES;
        _addressText.minimumFontSize = 0.5;
        [_addressText addToolbar];
    }
    return _addressText;
}

- (UIButton *)addressBtn{
    if (!_addressBtn) {
        _addressBtn = [[UIButton alloc] init];
        _addressBtn.titleLabel.font = [GUIUtil fitFont:12];
        [_addressBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        [_addressBtn setImage:[GColorUtil imageNamed:@"mine_icon_scan"] forState:UIControlStateNormal];
        [_addressBtn addTarget:self action:@selector(addressAction) forControlEvents:UIControlEventTouchUpInside];
        [_addressBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _addressBtn;
}

- (UIButton *)addressMoreBtn{
    if (!_addressMoreBtn) {
        _addressMoreBtn = [[UIButton alloc] init];
        _addressMoreBtn.titleLabel.font = [GUIUtil fitFont:12];
        [_addressMoreBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        [_addressMoreBtn setImage:[GColorUtil imageNamed:@"public_icon_more"] forState:UIControlStateNormal];
        [_addressMoreBtn addTarget:self action:@selector(addressSelectedAction) forControlEvents:UIControlEventTouchUpInside];
        [_addressMoreBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _addressMoreBtn;
}



- (UIView *)addressLine{
    if (!_addressLine) {
        _addressLine = [[UIView alloc] init];
        _addressLine.backgroundColor = [GColorUtil C7];
    }
    return _addressLine;
}

- (UILabel *)usdtTitle{
    if(!_usdtTitle){
        _usdtTitle = [[UILabel alloc] init];
        _usdtTitle.textColor = [GColorUtil C2];
        _usdtTitle.font = [GUIUtil  fitFont:14];
        _usdtTitle.text = CFDLocalizedString(@"提币数量");
    }
    return _usdtTitle;
}

- (UITextField *)usdtText{
    if(!_usdtText){
        _usdtText = [[UITextField alloc] init];
        _usdtText.textColor = [GColorUtil C2];
        _usdtText.font = [GUIUtil  fitFont:14];
        _usdtText.keyboardType = UIKeyboardTypeDecimalPad;
        _usdtText.textAlignment = NSTextAlignmentLeft;
        _usdtText.placeholder = @"--";
        _usdtText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_usdtText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType]}];
        WEAK_SELF;
        [_usdtText addTarget:weakSelf action:@selector(usdtTextChanged) forControlEvents:UIControlEventEditingChanged];
        _usdtText.delegate = weakSelf;
        _usdtText.adjustsFontSizeToFitWidth = YES;
        _usdtText.minimumFontSize = 0.5;
        [_usdtText addToolbar];
    }
    return _usdtText;
}

- (UIButton *)usdtBtn{
    if (!_usdtBtn) {
        _usdtBtn = [[UIButton alloc] init];
        _usdtBtn.titleLabel.font = [GUIUtil fitFont:12];
        [_usdtBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        [_usdtBtn setTitle:CFDLocalizedString(@"全部出金") forState:UIControlStateNormal];
        [_usdtBtn addTarget:self action:@selector(allAction) forControlEvents:UIControlEventTouchUpInside];
        [_usdtBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _usdtBtn;
}

- (UIView *)usdtLine{
    if (!_usdtLine) {
        _usdtLine = [[UIView alloc] init];
        _usdtLine.backgroundColor = [GColorUtil C7];
    }
    return _usdtLine;
}

- (UILabel *)remarkLabel{
    if(!_remarkLabel){
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.textColor = [GColorUtil C3];
        _remarkLabel.font = [GUIUtil  fitFont:14];
        _remarkLabel.text = CFDLocalizedString(@"最优价实时变动，订单成交后的价格可能与当前页面显示价格存在少量差异，价格以成交订单页面为准");
        _remarkLabel.numberOfLines = 0;
    }
    return _remarkLabel;
}
- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc] init];
        [_commitBtn setBackgroundImage:[UIImage imageWithColor:[GColorUtil colorWithHex:0x1882D4]] forState:UIControlStateNormal];
        [_commitBtn setBackgroundImage:[UIImage imageWithColor:[GColorUtil colorWithHex:0x1882D4]] forState:UIControlStateHighlighted];
        [_commitBtn setTitle:CFDLocalizedString(@"提交订单") forState:UIControlStateNormal];
        _commitBtn.layer.cornerRadius = 2;
        _commitBtn.layer.masksToBounds = YES;
        _commitBtn.enabled = YES;
        [_commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

- (UIView *)spaceView{
    if (!_spaceView) {
        _spaceView = [[UIView alloc] init];
        _spaceView.backgroundColor = [UIColor clearColor];
    }
    return _spaceView;
}


@end

//
//  PhoneVerifyAlert.m
//  Bitmixs
//
//  Created by ngw15 on 2019/5/17.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "PhoneVerifyAlert.h"

@interface PhoneVerifyView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *remarkLabel;
@property (nonatomic,strong) UITextField *pwdField;
@property (nonatomic,strong) UILabel *codeVerifyLabel;
@property (nonatomic,strong) UIView *textFieldLine;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) dispatch_block_t sureHander;
@property (nonatomic,strong) UIColor *tinColor;

@property (nonatomic,copy) NSString *key1;
@property (nonatomic,copy) NSString *key2;
@property (nonatomic,copy) NSString *googleCode;

@end

@implementation PhoneVerifyView

- (void)dealloc{
    [self removeNotic];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [GColorUtil colorWithHex:0x000000 alpha:0.4];
        _tinColor = [GColorUtil C13];
        [self setupUI];
        [self autoLayout];
        [self addNotic];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.pwdField];
    [self.contentView addSubview:self.codeVerifyLabel];
    [self.contentView addSubview:self.textFieldLine];
    [self.contentView addSubview:self.sureBtn];
    [self addSubview:self.closeBtn];
    [self.contentView addSubview:self.line];
    [self.pwdField addToolbar];
}

- (void)autoLayout{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo([GUIUtil fit:-10]);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo([GUIUtil fit:300]);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:25]);
        make.centerX.mas_equalTo(0);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.centerX.mas_equalTo(0);
    }];
    [_pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.right.equalTo(self.codeVerifyLabel.mas_left).mas_offset([GUIUtil fit:-5]);
        make.top.equalTo(self.remarkLabel.mas_bottom).mas_offset([GUIUtil fit:25]).priority(750);
        make.height.mas_equalTo([GUIUtil fit:35]);
    }];
    [_codeVerifyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-25]);
        make.height.mas_equalTo([GUIUtil fit:35]);
        make.centerY.equalTo(self.pwdField);
    }];
    [_textFieldLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.right.mas_equalTo([GUIUtil fit:-25]);
        make.bottom.equalTo(self.pwdField);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.sureBtn.mas_top);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).mas_offset([GUIUtil fit:7]);
        make.right.equalTo(self.contentView).mas_offset([GUIUtil fit:-7]);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdField.mas_bottom).mas_offset([GUIUtil fit:25]);
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.right.mas_equalTo([GUIUtil fit:-25]);
        make.height.mas_equalTo([GUIUtil fit:44]);
        make.bottom.mas_equalTo([GUIUtil fit:0]);
    }];
    // 保证codeVerifyLabel水平方向不被压缩
    [_codeVerifyLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
}

//MARK: - Action

- (void)setTinColor:(UIColor *)tinColor{
    if (tinColor) {
        _tinColor = tinColor;
        [_sureBtn setTitleColor:_tinColor forState:UIControlStateNormal];
    }
}

- (void)sureAction{
    WEAK_SELF;
    if (_pwdField.text.length<=0) {
        [HUDUtil showInfo:CFDLocalizedString(@"请输入验证码")];
        return;
    }else if ([NDataUtil isNumber:_pwdField.text]==NO) {
        NSString *errorText = CFDLocalizedString(@"验证码格式错误");
        [HUDUtil showInfo:errorText];
        return;
    }
    [self.pwdField resignFirstResponder];
    [HUDUtil showProgress:@""];
    [DCService operateGoogleAuth:self.key1.length>0 key1:weakSelf.key1 key2:weakSelf.key2 emsCode:_pwdField.text googleCode:weakSelf.googleCode success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [HUDUtil showInfo:CFDLocalizedString(@"操作成功")];
            [weakSelf removeFromSuperview];
            if(weakSelf.sureHander){
                weakSelf.sureHander();
            }
            
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"message"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

- (void)cancelAction{
    [self removeFromSuperview];
}

- (void)hidenKeyboard{
    [_pwdField resignFirstResponder];
}

- (void)addNotic{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];}

- (void)removeNotic{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow:(NSNotification *)notic{
    if (_pwdField.isFirstResponder) {
        CGFloat textFieldBottom = CGRectGetMaxY(self.contentView.frame);
        CGFloat keyboardFrameH = [[[notic userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height; //获得键盘
        BOOL flag = textFieldBottom+keyboardFrameH>SCREEN_HEIGHT;
        if (flag) {
            CGFloat duration = [[[notic userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]; //获得键盘时间
            WEAK_SELF;
            [UIView animateWithDuration:duration animations:^{
                weakSelf.top = -(textFieldBottom+keyboardFrameH-SCREEN_HEIGHT);
            }];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notic{
    CGFloat duration = [[[notic userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]; //获得键盘时间
    WEAK_SELF;
    [UIView animateWithDuration:duration animations:^{
        weakSelf.top = 0;
    }];
}

//MARK: - Getter

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [GColorUtil C5];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = CFDLocalizedString(@"短信验证码");
        _titleLabel.font =[GUIUtil fitFont:16];
        _titleLabel.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
    }
    return _titleLabel;
}

-(UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        NSMutableString *phone = [UserModel sharedInstance].mobilePhone.mutableCopy;
        if (phone.length==11) {
            [phone replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }else{
            phone=@"--".mutableCopy;
        }
        _remarkLabel.text = [NSString stringWithFormat:CFDLocalizedString(@"向%@发送验证码"),phone];
        _remarkLabel.font =[GUIUtil fitFont:12];
        _remarkLabel.textColor = [GColorUtil C3];
    }
    return _remarkLabel;
}

- (UITextField *)pwdField{
    if (!_pwdField) {
        _pwdField = [[UITextField alloc] init];
        _pwdField.font =[GUIUtil fitFont:13];
        _pwdField.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
        _pwdField.placeholder = CFDLocalizedString(@"请输入验证码");
        _pwdField.keyboardType = UIKeyboardTypeNumberPad;
        _pwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_pwdField.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType]}];
    }
    return _pwdField;
}


- (UILabel *)codeVerifyLabel{
    if (!_codeVerifyLabel) {
        _codeVerifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [GUIUtil fit:100], 30)];
        _codeVerifyLabel.text = CFDLocalizedString(@"发送验证码");
        _codeVerifyLabel.font =[GUIUtil fitFont:14];
        _codeVerifyLabel.textColor = [GColorUtil C13];
        _codeVerifyLabel.userInteractionEnabled = YES;
        _codeVerifyLabel.textAlignment = NSTextAlignmentRight;
        WEAK_SELF;
        [_codeVerifyLabel g_clickBlock:^(UITapGestureRecognizer *tap) {
            [CFDApp sendVaildPhoneCode:weakSelf.codeVerifyLabel mobile:[UserModel sharedInstance].mobilePhone smsType:26 ccode:[UserModel sharedInstance].ccode];
            [weakSelf.pwdField becomeFirstResponder];
            weakSelf.codeVerifyLabel.userInteractionEnabled = NO;
        }];
    }
    return _codeVerifyLabel;
}

- (UIView *)textFieldLine{
    if (!_textFieldLine) {
        _textFieldLine = [[UIView alloc] init];
        _textFieldLine.backgroundColor = [GColorUtil colorWithWhiteColorType:C7_ColorType];
    }
    return _textFieldLine;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [GColorUtil colorWithWhiteColorType:C7_ColorType];
    }
    return _line;
}
- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[GColorUtil imageNamed_whiteTheme:@"nav_icon_close"] forState:UIControlStateNormal];
        [_closeBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
        [_closeBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        _closeBtn.alpha = 0.8;
    }
    return _closeBtn;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:CFDLocalizedString(@"确定") forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [GUIUtil fitFont:16];
        [_sureBtn setTitleColor:_tinColor forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end

@implementation PhoneVerifyAlert

+ (void)showAlert:(dispatch_block_t)sureHander key1:(nonnull NSString *)key1 key2:(nonnull NSString *)key2 googleCode:(nonnull NSString *)googleCode{
    UIWindow *window = [GJumpUtil window];
    PhoneVerifyView *view = [[PhoneVerifyView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.sureHander = sureHander;
    view.key1 = key1;
    view.key2 = key2;
    view.googleCode = googleCode;
    view.tag = 4112;
    [window addSubview:view];
    view.contentView.transform = CGAffineTransformIdentity;
}


+ (void)hide{
    UIWindow *window = [GJumpUtil window];
    PhoneVerifyView *view = [window viewWithTag:4112];
    [view cancelAction];
    [view removeFromSuperview];
}


@end





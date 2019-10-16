//
//  PwdAlert.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/28.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "PwdAlert.h"


@interface PwdAlertView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong) UITextField *pwdField;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) dispatch_block_t sureHander;
@property (nonatomic,strong) UIColor *tinColor;

@end

@implementation PwdAlertView

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
    [self.contentView addSubview:self.pwdField];
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
    [_pwdField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.right.mas_equalTo([GUIUtil fit:-25]);
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset([GUIUtil fit:25]).priority(750);
        make.height.mas_equalTo([GUIUtil fit:35]);
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
        make.top.equalTo(self.pwdField.mas_bottom).mas_offset([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.right.mas_equalTo([GUIUtil fit:-25]);
        make.height.mas_equalTo([GUIUtil fit:44]);
        make.bottom.mas_equalTo([GUIUtil fit:0]);
    }];
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
        [HUDUtil showInfo:CFDLocalizedString(@"请输入账户密码")];
        return;
    }else if ([NDataUtil checkPassWord:_pwdField.text]==NO) {
        NSString *errorText = CFDLocalizedString(@"密码格式错误");
        [HUDUtil showInfo:errorText];
        return;
    }
    [self.pwdField resignFirstResponder];
    [HUDUtil showProgress:@""];
    [DCService checkpwd:_pwdField.text success:^(id data) {
        [HUDUtil hide];
        if ([NDataUtil boolWithDic:data key:@"result" isEqual:@"1"]) {
            NSDictionary *dic = [NDataUtil dictWith:data[@"userInfo"]];
            if ([NDataUtil boolWithDic:dic key:@"validpassword" isEqual:@"1"]) {
                [weakSelf removeFromSuperview];
                if(weakSelf.sureHander){
                    weakSelf.sureHander();
                }
                return ;
            }
        }
        [DCAlert showAlert:@"" detail:CFDLocalizedString(@"密码错误") sureTitle:CFDLocalizedString(@"重新输入") sureHander:^{
            
        } cancelTitle:CFDLocalizedString(@"忘记密码") cancelHander:^{
            [CFDJumpUtil jumpAlterPwd];
            [PwdAlert hide];
            [DCAlert hide];
        }];
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
        _titleLabel.text = CFDLocalizedString(@"安全验证");
        _titleLabel.font =[GUIUtil fitFont:16];
        _titleLabel.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
    }
    return _titleLabel;
}

- (UITextField *)pwdField{
    if (!_pwdField) {
        _pwdField = [[UITextField alloc] init];
        _pwdField.font =[GUIUtil fitFont:14];
        _pwdField.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
        _pwdField.placeholder = CFDLocalizedString(@"请输入账户密码");
        _pwdField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_pwdField.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType]}];
        _pwdField.secureTextEntry = YES;
        _pwdField.rightViewMode = UITextFieldViewModeAlways;
        UIButton *eyeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [eyeBtn setImage:[GColorUtil imageNamed_whiteTheme:@"login_icon_eye_close"] forState:UIControlStateNormal];
        [eyeBtn setImage:[GColorUtil imageNamed_whiteTheme:@"login_icon_eye_open"] forState:UIControlStateSelected];
        [eyeBtn addTarget:self action:@selector(eyeAction:) forControlEvents:UIControlEventTouchUpInside];
        _pwdField.rightView = eyeBtn;
    }
    return _pwdField;
}

- (void)eyeAction:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    _pwdField.secureTextEntry = !sender.selected;
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

@implementation PwdAlert



+ (void)showAlert:(dispatch_block_t)sureHander{
    UIWindow *window = [GJumpUtil window];
    PwdAlertView *view = [[PwdAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.sureHander = sureHander;
    view.tag = 4112;
    [window addSubview:view];
    view.contentView.transform = CGAffineTransformIdentity;
}


+ (void)hide{
    UIWindow *window = [GJumpUtil window];
    PwdAlertView *view = [window viewWithTag:4112];
    [view cancelAction];
    [view removeFromSuperview];
}


@end



//
//  DCForgetPwdVC.m
//  qzh_ftox
//
//  Created by ngw15 on 2018/4/2.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "DCForgetPwdVC.h"
#import "DCCountryAlert.h"

@interface DCForgetPwdVC()<UIGestureRecognizerDelegate,UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIView *navView;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIView *phoneView;
@property (nonatomic,strong) UILabel *phoneTitle;
@property (nonatomic,strong) UITextField *phoneText;
@property (nonatomic,strong) UIView *phoneLine;

@property (nonatomic,strong) UILabel *pwdTitle;
@property (nonatomic,strong) UITextField *pwdText;
@property (nonatomic,strong) UIButton *pwdShowBtn;
@property (nonatomic,strong) UIView *pwdLine;

@property (nonatomic,strong) UILabel *againTitle;
@property (nonatomic,strong) UITextField *againText;
@property (nonatomic,strong) UIButton *againShowBtn;
@property (nonatomic,strong) UIView *againLine;

@property (nonatomic,strong) UILabel *vaildTitle;
@property (nonatomic,strong) UITextField *vaildText;
@property (nonatomic,strong) UILabel *vaildRemark;
@property (nonatomic,strong) UIView *vaildVLine;
@property (nonatomic,strong) UIView *vaildLine;

@property (nonatomic,strong) UILabel *errorLabel;
@property (nonatomic,strong) UIButton *registerBtn;

@property (nonatomic,strong) MASConstraint *masNextBtnTop;
@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,assign) NSInteger type;

@property (nonatomic,copy) dispatch_block_t successHander;
@end

@implementation DCForgetPwdVC

+ (void)jumpTo:(UIViewController *)current successHander:(dispatch_block_t)successHander{
    DCForgetPwdVC *target  = [[DCForgetPwdVC alloc] init];
    target.successHander = successHander;
    [current.navigationController pushViewController:target animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self addNotic];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_phoneText becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hidenKeyboard];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self removeNotic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeTop;
    [self setupUserInteraction];
    [self autoLayout];
    //给这个UITextField的对象添加UIToolbar
    [_phoneText addToolbar];
    [_pwdText addToolbar];
    [_againText addToolbar];
    [_vaildText addToolbar];
    // Do any additional setup after loading the view.
}

- (void)setupUserInteraction{
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.navView];
    [self.scrollView addSubview:self.lineView];
    [self.scrollView addSubview:self.phoneView];
    [self.scrollView addSubview:self.errorLabel];
    [self.scrollView addSubview:self.registerBtn];
    
}

- (void)autoLayout{

    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(STATUS_BAR_HEIGHT+[GUIUtil fit:128]);
    }];

    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.navView.mas_bottom);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fit:15]);
    }];
    [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo([GUIUtil fit:0]);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    
    [_errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.equalTo(self.phoneView.mas_bottom).mas_offset([GUIUtil fit:10]);
    }];
    
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        self.masNextBtnTop = make.top.equalTo(self.phoneView.mas_bottom).mas_offset([GUIUtil fit:40]);
        make.top.equalTo(self.errorLabel.mas_bottom).mas_offset([GUIUtil fit:20]).priority(250);
        make.left.mas_equalTo([GUIUtil fit:33]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:66]);
        make.height.mas_equalTo([GUIUtil fit:44]);
    }];
}

- (void)addNotic{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)removeNotic{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Action

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeAction{
    if (self.navigationController!=[GJumpUtil rootNavC]) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self backAction];
    }
}


- (void)againPwdAction{
    _againShowBtn.selected = !_againShowBtn.isSelected;
    _againText.secureTextEntry = !_againShowBtn.isSelected;
}

- (void)showPwdAction{
    _pwdShowBtn.selected = !_pwdShowBtn.isSelected;
    _pwdText.secureTextEntry = !_pwdShowBtn.isSelected;
}
- (void)sureAction:(UIButton *)btn{
    
    NSString *typeStr = _phoneText.text;
    NSString *code = _vaildText.text;
    NSString *pwd = _pwdText.text;
    NSString *again = _againText.text;
    
    NSString *errorText = @"";
    if([UserModel isLogin]&&![[UserModel sharedInstance].mobilePhone isEqualToString:_phoneText.text]){
        errorText = CFDLocalizedString(@"手机号输入错误");
    }else if([NDataUtil checkPassWord:pwd]==NO){
        errorText = CFDLocalizedString(@"密码格式错误");
    }
    else if ([pwd isEqualToString:again]==NO) {
        errorText = CFDLocalizedString(@"密码输入不一致");
    }else if ([NDataUtil isNumber:code]==NO&&code.length!= 4){
        errorText = CFDLocalizedString(@"验证码错误");
    }
    if(errorText.length!=0){
        _errorLabel.hidden = NO;
        [_masNextBtnTop deactivate];
        _errorLabel.text = errorText;
        return;
    }
    WEAK_SELF;
    _registerBtn.enabled = NO;

    [HUDUtil showProgress:@""];
    [DCService postgetresetpasswordMobile:typeStr code:code ccode:@"" newpwd:pwd sucess:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"result" isEqual:@"1"]) {
            [HUDUtil showInfo:CFDLocalizedString(@"重置成功")];
            [weakSelf backAction];
        }else{
            weakSelf.errorLabel.hidden = YES;
            [weakSelf.masNextBtnTop activate];
            weakSelf.errorLabel.text = @"";
            weakSelf.registerBtn.enabled = YES;
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"message"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        weakSelf.errorLabel.hidden = YES;
        [weakSelf.masNextBtnTop activate];
        weakSelf.errorLabel.text = @"";
        weakSelf.registerBtn.enabled = YES;
        [HUDUtil  showInfo:[FTConfig webTips]];
    }];
   
}

- (void)hidenKeyboard{
    [self.view endEditing:YES];
    [self.againText resignFirstResponder];
    [self.vaildText resignFirstResponder];
    [self.pwdText resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    BOOL flag = _phoneText.isFirstResponder || _pwdText.isFirstResponder||
    _againText.isFirstResponder||
    _vaildText.isFirstResponder;
    if (gestureRecognizer == _tap&&flag == NO) {
        return NO;
    }
    return YES;
}

- (void)keyboardWillShow:(NSNotification *)notic{
    if (_vaildText.isFirstResponder) {
        UITextField *textField = _vaildText;
        CGFloat textFieldBottom = [self.view convertPoint:CGPointMake(0, textField.bottom) fromView:_phoneView].y;
        
        CGFloat keyboardFrameH = [[[notic userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height; //获得键盘
        BOOL flag = textFieldBottom+keyboardFrameH>SCREEN_HEIGHT;
        if (flag) {
            CGFloat duration = [[[notic userInfo] objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue]; //获得键盘时间
            WEAK_SELF;
            [UIView animateWithDuration:duration animations:^{
                weakSelf.scrollView.contentOffset = CGPointMake(0,textFieldBottom+keyboardFrameH-SCREEN_HEIGHT);
            }];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notic{
    [self.scrollView setContentOffset:CGPointMake(0,0) animated:YES];
}

#pragma mark - getter

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = YES;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.contentSize = CGSizeMake(0, 0);
        _scrollView.userInteractionEnabled = YES;
        _scrollView.backgroundColor = [GColorUtil C6];
        
        WEAK_SELF;
        _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
        _tap.delegate = weakSelf;
        [_scrollView addGestureRecognizer:_tap];
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _scrollView;
}

- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] init];
        _navView.backgroundColor = [GColorUtil C6];
        [_navView addSubview:self.backBtn];
        [_navView addSubview:self.titleLabel];
        WEAK_SELF;
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:20]);
            make.centerY.equalTo(weakSelf.navView.mas_top).mas_offset(STATUS_BAR_HEIGHT+22);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backBtn.mas_bottom).mas_offset([GUIUtil fit:36]);
            make.left.mas_equalTo([GUIUtil fit:20]);
        }];
    }
    return _navView;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc] init];
        [_backBtn setImage:[GColorUtil imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
        [_backBtn setImage:[GColorUtil imageNamed:@"nav_icon_back"] forState:UIControlStateHighlighted];
        [_backBtn addTarget:self
                     action:@selector(backAction)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _backBtn;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [GColorUtil C2];
        _titleLabel.font = [GUIUtil fitBoldFont:24];
        _titleLabel.text = CFDLocalizedString(@"找回登录密码");
    }
    return _titleLabel;
}

-(UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [GColorUtil colorWithHex:0xf4f5f6];
        _lineView.hidden = YES;
    }
    return _lineView;
}


- (UIView *)phoneView{
    if (!_phoneView) {
        _phoneView = [[UIView alloc] init];
        
        [_phoneView addSubview:self.phoneTitle];
        [_phoneView addSubview:self.phoneText];
        [_phoneView addSubview:self.phoneLine];
        
        [_phoneView addSubview:self.pwdTitle];
        [_phoneView addSubview:self.pwdText];
        [_phoneView addSubview:self.pwdLine];
        
        [_phoneView addSubview:self.againTitle];
        [_phoneView addSubview:self.againText];
        [_phoneView addSubview:self.againLine];
        
        [_phoneView addSubview:self.vaildTitle];
        [_phoneView addSubview:self.vaildText];
        [_phoneView addSubview:self.vaildRemark];
        [_phoneView addSubview:self.vaildVLine];
        [_phoneView addSubview:self.vaildLine];
        
        [_phoneTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.top.mas_equalTo([GUIUtil fit:5]);
        }];
        [_phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.top.equalTo(self.phoneTitle.mas_bottom).mas_offset([GUIUtil fit:5]);
            make.height.mas_equalTo([GUIUtil fit:40]);
            make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:80]);
        }];
        [_phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.phoneText.mas_bottom).mas_offset([GUIUtil fit:-3]);
            make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:66]);
            make.left.mas_equalTo([GUIUtil fit:20]);
            make.height.mas_equalTo([GUIUtil fitLine]);
        }];
        
        [_pwdTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.top.equalTo(self.phoneLine.mas_bottom).mas_offset([GUIUtil fit:15]);
        }];
        [_pwdText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.top.equalTo(self.pwdTitle.mas_bottom).mas_offset([GUIUtil fit:5]);
            make.height.mas_equalTo([GUIUtil fit:40]);
            make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:80]);
        }];
        [_pwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.pwdText.mas_bottom).mas_offset([GUIUtil fit:-3]);
            make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:66]);
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.height.mas_equalTo([GUIUtil fitLine]);
        }];
        
        [_againTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.top.equalTo(self.pwdLine.mas_bottom).mas_offset([GUIUtil fit:15]);
        }];
        [_againText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.againTitle.mas_bottom).mas_offset(([GUIUtil fit:5]));
            make.height.mas_equalTo([GUIUtil fit:40]);
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:80]);
        }];
        [_againLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.againText.mas_bottom).mas_offset([GUIUtil fit:-5]);
            make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:66]);
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.height.mas_equalTo([GUIUtil fitLine]);
        }];
        
        [_vaildTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.top.equalTo(self.againLine.mas_bottom).mas_offset([GUIUtil fit:15]);
        }];
        [_vaildText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.vaildTitle.mas_bottom).mas_offset(([GUIUtil fit:5]));
            make.height.mas_equalTo([GUIUtil fit:40]);
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:80]);
        }];
        [_vaildRemark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.vaildLine.mas_right).mas_offset([GUIUtil fit:-10]);
            make.centerY.equalTo(self.vaildText);
        }];
        [_vaildVLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.vaildRemark).mas_offset([GUIUtil fit:-10]);
            make.width.mas_equalTo([GUIUtil fitLine]);
            make.centerY.equalTo(self.vaildText);
            make.height.mas_equalTo([GUIUtil fit:20]);
            make.left.mas_lessThanOrEqualTo(SCREEN_WIDTH+[GUIUtil fit:-91]);
        }];
        [_vaildLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.vaildText.mas_bottom).mas_offset([GUIUtil fit:-5]);
            make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:66]);
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.height.mas_equalTo([GUIUtil fitLine]);
            make.bottom.mas_equalTo([GUIUtil fit:-10]);
        }];
    }
    return _phoneView;
}

- (UILabel *)phoneTitle{
    if (!_phoneTitle) {
        _phoneTitle = [[UILabel alloc] init];
        _phoneTitle.textColor = [GColorUtil C2];
        _phoneTitle.font = [GUIUtil fitFont:14];
        _phoneTitle.text = CFDLocalizedString(@"手机号");
    }
    return _phoneTitle;
}

- (UITextField *)phoneText{
    if (!_phoneText) {
        _phoneText = [[UITextField alloc] init];
        _phoneText.textColor = [GColorUtil C2];
        _phoneText.font = [GUIUtil fitFont:14];
        _phoneText.returnKeyType = UIReturnKeyDone;
        _phoneText.delegate = self;
        _phoneText.autocorrectionType = UITextAutocorrectionTypeNo;
        _phoneText.keyboardType = UIKeyboardTypePhonePad;
        _phoneText.placeholder = CFDLocalizedString(@"请输入手机号");
        _phoneText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_phoneText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType]}];
        _phoneText.rightViewMode = UITextFieldViewModeAlways;
        if ([UserModel isLogin]) {
            _phoneText.text = [UserModel sharedInstance].mobilePhone;
        }
    }
    return _phoneText;
}

- (UIView *)phoneLine{
    if (!_phoneLine) {
        _phoneLine = [[UIView alloc] init];
        _phoneLine.backgroundColor = [GColorUtil C7];
    }
    return _phoneLine;
}

- (UILabel *)pwdTitle{
    if (!_pwdTitle) {
        _pwdTitle = [[UILabel alloc] init];
        _pwdTitle.textColor = [GColorUtil C2];
        _pwdTitle.font = [GUIUtil fitFont:14];
        _pwdTitle.text = CFDLocalizedString(@"登录密码");
    }
    return _pwdTitle;
}

- (UITextField *)pwdText{
    if (!_pwdText) {
        _pwdText = [[UITextField alloc] init];
        _pwdText.textColor = [GColorUtil C2];
        _pwdText.font = [GUIUtil fitFont:14];
        _pwdText.returnKeyType = UIReturnKeyDone;
        _pwdText.secureTextEntry = YES;
        _pwdText.delegate = self;
        _pwdText.autocorrectionType = UITextAutocorrectionTypeNo;
        _pwdText.placeholder = CFDLocalizedString(@"6~32位数字、字母或符号的组合");
        _pwdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_pwdText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType],NSFontAttributeName:[GUIUtil fitFont:14]}];
        _pwdText.rightView = self.pwdShowBtn;
        _pwdText.rightViewMode = UITextFieldViewModeAlways;
    }
    return _pwdText;
}

- (UIButton *)pwdShowBtn{
    if (_pwdShowBtn == nil) {
        _pwdShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _pwdShowBtn.frame = CGRectMake(0, 0, 20, 20);
        [_pwdShowBtn setImage:[GColorUtil imageNamed:@"login_icon_eye_close"] forState:UIControlStateNormal];
        [_pwdShowBtn setImage:[GColorUtil imageNamed:@"login_icon_eye_open"] forState:UIControlStateSelected];
        [_pwdShowBtn addTarget:self action:@selector(showPwdAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pwdShowBtn;
}

- (UIView *)pwdLine{
    if (!_pwdLine) {
        _pwdLine = [[UIView alloc] init];
        _pwdLine.backgroundColor = [GColorUtil C7];
    }
    return _pwdLine;
}

- (UILabel *)againTitle{
    if (!_againTitle) {
        _againTitle = [[UILabel alloc] init];
        _againTitle.textColor = [GColorUtil C2];
        _againTitle.font = [GUIUtil fitFont:14];
        _againTitle.text = CFDLocalizedString(@"再次输入");
    }
    return _againTitle;
}

- (UITextField *)againText{
    if (!_againText) {
        _againText = [[UITextField alloc] init];
        _againText.textColor = [GColorUtil C2];
        _againText.font = [GUIUtil fitFont:14];
        _againText.returnKeyType = UIReturnKeyDone;
        _againText.secureTextEntry = YES;
        _againText.delegate = self;
        _againText.autocorrectionType = UITextAutocorrectionTypeNo;
        _againText.placeholder = CFDLocalizedString(@"请确认密码");
        _againText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_againText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType]}];
        _againText.rightView = self.againShowBtn;
        _againText.rightViewMode = UITextFieldViewModeAlways;
    }
    return _againText;
}

- (UIButton *)againShowBtn{
    if (_againShowBtn == nil) {
        _againShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _againShowBtn.frame = CGRectMake(0, 0, 20, 20);
        [_againShowBtn setImage:[GColorUtil imageNamed:@"login_icon_eye_close"] forState:UIControlStateNormal];
        [_againShowBtn setImage:[GColorUtil imageNamed:@"login_icon_eye_open"] forState:UIControlStateSelected];
        [_againShowBtn addTarget:self action:@selector(againPwdAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _againShowBtn;
}

- (UIView *)againLine{
    if (!_againLine) {
        _againLine = [[UIView alloc] init];
        _againLine.backgroundColor = [GColorUtil C7];
    }
    return _againLine;
}

- (UILabel *)vaildTitle{
    if (!_vaildTitle) {
        _vaildTitle = [[UILabel alloc] init];
        _vaildTitle.textColor = [GColorUtil C2];
        _vaildTitle.font = [GUIUtil fitFont:14];
        _vaildTitle.text = CFDLocalizedString(@"短信验证码");
    }
    return _vaildTitle;
}

- (UITextField *)vaildText{
    if (!_vaildText) {
        _vaildText = [[UITextField alloc] init];
        _vaildText.textColor = [GColorUtil C2];
        _vaildText.font = [GUIUtil fitFont:14];
        _vaildText.returnKeyType = UIReturnKeyDone;
        _vaildText.delegate = self;
        _vaildText.keyboardType = UIKeyboardTypeNumberPad;
        _vaildText.autocorrectionType = UITextAutocorrectionTypeNo;
        _vaildText.placeholder = CFDLocalizedString(@"请输入短信验证码");
        _vaildText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_vaildText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType]}];
    }
    return _vaildText;
}

- (UILabel *)vaildRemark{
    if (!_vaildRemark) {
        _vaildRemark = [[UILabel alloc] init];
        _vaildRemark.text = CFDLocalizedString(@"发送验证码");
        _vaildRemark.font =[GUIUtil fitFont:14];
        _vaildRemark.textColor = [GColorUtil C22];
        WEAK_SELF;
        [_vaildRemark g_clickBlock:^(UITapGestureRecognizer *tap) {
            BOOL flag = [CFDApp sendVaildPhoneCode:weakSelf.vaildRemark mobile:weakSelf.phoneText.text smsType:22 ccode:@""];
            if (flag==NO) {
                weakSelf.errorLabel.hidden = NO;
                [weakSelf.masNextBtnTop deactivate];
                weakSelf.errorLabel.text = CFDLocalizedString(@"手机号输入错误");
                return;
            }
            [weakSelf.vaildText becomeFirstResponder];
            weakSelf.errorLabel.hidden = YES;
            [weakSelf.masNextBtnTop activate];
            weakSelf.vaildRemark.userInteractionEnabled = NO;
        }];
    }
    return _vaildRemark;
}

- (UIView *)vaildVLine{
    if (!_vaildVLine) {
        _vaildVLine = [[UIView alloc] init];
        _vaildVLine.backgroundColor = [GColorUtil C7];
    }
    return _vaildVLine;
}

- (UIView *)vaildLine{
    if (!_vaildLine) {
        _vaildLine = [[UIView alloc] init];
        _vaildLine.backgroundColor = [GColorUtil C7];
    }
    return _vaildLine;
}


- (UILabel *)errorLabel{
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.textColor = [GColorUtil C14];
        _errorLabel.font = [GUIUtil fitFont:14];
        _errorLabel.hidden = YES;
        _errorLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _errorLabel;
}

- (UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [[UIButton alloc] init];
        [_registerBtn setTitle:CFDLocalizedString(@"确定") forState:UIControlStateNormal];
        [_registerBtn setBackgroundImage:[UIImage imageWithColor:[GColorUtil C13] size:CGSizeMake(SCREEN_WIDTH-[GUIUtil fit:60], [GUIUtil fit:44])] forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[GColorUtil C2_black] forState:UIControlStateNormal];
        _registerBtn.layer.cornerRadius = 5;
        _registerBtn.layer.masksToBounds = YES;
        [_registerBtn addTarget:self action:@selector(sureAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}


@end




//
//  DCLoginVC.m
//  niuguwang
//
//  Created by ngw15 on 2018/3/29.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "DCLoginVC.h"
#import "DCRegisterVC.h"
#import "DCForgetPwdVC.h"
#import "AuthAlert.h"

@interface DCLoginVC()<UIGestureRecognizerDelegate,UITextFieldDelegate>

/*
 **登录action
 */
@property (nonatomic, copy)  void(^loginSucessBlock)(void);

@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) UILabel *registerLabel;
@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *accountTitle;
@property (nonatomic,strong) UITextField *accountText;
@property (nonatomic,strong) UIButton *cleanBtn;
@property (nonatomic,strong) UIView *accountline;

@property (nonatomic,strong) UILabel *pwdTitle;
@property (nonatomic,strong) UITextField *pwdText;
@property (nonatomic,strong) UIView *pwdLine;
@property (nonatomic,strong) UIButton *showPwdBtn;
@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UILabel *forgetPWLabel;//忘记密码

@property (nonatomic,strong) UILabel *errorLabel;
@property (nonatomic,strong) MASConstraint *masNextBtnTop;
@property (nonatomic,assign) BOOL isKeyboardShow; //键盘是否正在显示，用户收起键盘
@property (nonatomic,strong) UITapGestureRecognizer *tap;

@end

@implementation DCLoginVC

+ (void)jumpTo:(dispatch_block_t)loginSucessBlock{
    if ([UserModel isLogin]) {
        if (loginSucessBlock) {
            loginSucessBlock();
        }
        return;
    }
    DCLoginVC *loginVC  = [[DCLoginVC alloc] init];
    loginVC.loginSucessBlock = loginSucessBlock;
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    UIViewController *rootVC = [[[UIApplication sharedApplication].delegate window] rootViewController];
    [rootVC presentViewController:navC animated:YES completion:nil];
}

+ (void)jumpToRegister:(dispatch_block_t)loginSucessBlock{
    if ([UserModel isLogin]) {
        if (loginSucessBlock) {
            loginSucessBlock();
        }
        return;
    }
    DCLoginVC *loginVC  = [[DCLoginVC alloc] init];
    loginVC.loginSucessBlock = loginSucessBlock;
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:loginVC];
    [DCRegisterVC jumpTo:loginVC successHander:loginSucessBlock];
    UIViewController *rootVC = [[[UIApplication sharedApplication].delegate window] rootViewController];
    [rootVC presentViewController:navC animated:YES completion:nil];
}

- (void)loadView{
    WEAK_SELF;
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.scrollEnabled = NO;
    scrollView.bounces = YES;
    scrollView.alwaysBounceVertical = YES;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.contentSize = CGSizeMake(0, 0);
    scrollView.userInteractionEnabled = YES;
    self.view = scrollView;
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    _tap.delegate = weakSelf;
    [scrollView addGestureRecognizer:_tap];
    if (@available(iOS 11.0, *)) {
        scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES  animated:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self addNotic];
    [_accountText becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hidenKeyboard];
    [self removeNotic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self setupUserInteraction];
    [self autoLayout];
    //给这个UITextField的对象添加UIToolbar
    [_accountText addToolbar];
    [_pwdText addToolbar];
    // Do any additional setup after loading the view.
}

- (void)setupUserInteraction{
    self.view.backgroundColor = [GColorUtil C6];
    [self.view addSubview:self.bgImg];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.accountTitle];
    [self.view addSubview:self.accountText];
    [self.view addSubview:self.accountline];
    
    [self.view addSubview:self.pwdTitle];
    [self.view addSubview:self.pwdText];
    [self.view addSubview:self.pwdLine];

    [self.view addSubview:self.errorLabel];
    [self.view addSubview:self.loginBtn];
    [self.view addSubview:self.registerLabel];
    [self.view addSubview:self.forgetPWLabel];
}

- (void)autoLayout{
    [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.equalTo(self.view);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:20]);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT+[GUIUtil fit:25]);
    }];
    [_registerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_left).mas_offset(SCREEN_WIDTH-[GUIUtil fit:20]);
        make.centerY.equalTo(self.closeBtn);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:80]+STATUS_BAR_HEIGHT);
        make.left.mas_equalTo([GUIUtil fit:40]);
    }];
    [_accountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:40]);
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset([GUIUtil fit:35]);
    }];
    [_accountText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:40]);
        make.top.equalTo(self.accountTitle.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.height.mas_equalTo([GUIUtil fit:40]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:80]);
    }];
    [_accountline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.accountText.mas_bottom).mas_offset([GUIUtil fit:-3]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:66]);
        make.left.mas_equalTo([GUIUtil fit:40]);
        make.height.mas_equalTo(0.5);
    }];
    [_pwdTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:40]);
        make.top.equalTo(self.accountline.mas_bottom).mas_offset([GUIUtil fit:15]);
    }];
    [_pwdText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdTitle.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.height.mas_equalTo([GUIUtil fit:40]);
        make.left.mas_equalTo([GUIUtil fit:40]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:86]);
    }];
    [_pwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pwdText.mas_bottom).mas_offset([GUIUtil fit:-3]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:66]);
        make.left.mas_equalTo([GUIUtil fit:40]);
        make.height.mas_equalTo(0.5);
    }];
    [_loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        self.masNextBtnTop = make.top.equalTo(self.pwdLine.mas_bottom).mas_offset([GUIUtil fit:40]);
        make.top.equalTo(self.errorLabel.mas_bottom).mas_offset([GUIUtil fit:20]).priority(250);
        make.left.mas_equalTo([GUIUtil fit:40]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:80]);
        make.height.mas_equalTo([GUIUtil fit:44]);
    }];

    [_errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pwdLine.mas_bottom).mas_offset([GUIUtil fit:12]);
        make.left.mas_equalTo([GUIUtil fit:40]);
    }];
    [_forgetPWLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.loginBtn.mas_right);
        make.top.equalTo(self.loginBtn.mas_bottom).mas_offset([GUIUtil fit:10]);
    }];
}

#pragma mark - Action

- (void)showPwdAction{
     _showPwdBtn.selected = !_showPwdBtn.isSelected;
    _pwdText.secureTextEntry = !_showPwdBtn.isSelected;
}

- (void)closeAction{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginAction:(UIButton *)btn{

    NSString *errorText = @"";
    if ([NDataUtil isMobilePhone:_accountText.text]==NO) {
        errorText = CFDLocalizedString(@"手机号输入错误");
    }else if ([NDataUtil checkPassWord:_pwdText.text]==NO) {
        errorText = CFDLocalizedString(@"密码格式错误");
    }
    if (errorText.length>0) {
        _errorLabel.hidden = NO;
        [_masNextBtnTop deactivate];
        _errorLabel.text = errorText;
        return;
    }
    WEAK_SELF;
    _loginBtn.enabled = NO;
    [HUDUtil showProgress:@""];
    [DCService postloginMobile:_accountText.text password:_pwdText.text success:^(id loginData) {
        if ([NDataUtil boolWithDic:loginData key:@"result" isEqual:@"1"]) {
            NSDictionary *loginUserInfo = loginData[@"userInfo"];
            [UserModel sharedInstance].userToken=[NDataUtil stringWith:loginUserInfo[@"userToken"] valid:@""];
            [DCService postgetUserIndex:^(id data) {
                if ([NDataUtil boolWithDic:data key:@"result" isEqual:@"1"]) {
                    NSDictionary *userInfo = data[@"userInfo"];
                    [weakSelf successLogin:userInfo loginData:loginUserInfo];
                }else{
                    [UserModel sharedInstance].userToken=@"";
                    [weakSelf failLogin];
                    [HUDUtil showInfo:[NDataUtil stringWith:data[@"message"] valid:[FTConfig webTips]]];
                }
            } failure:^(NSError *error) {
                [UserModel sharedInstance].userToken=@"";
                [weakSelf failLogin];
                [HUDUtil showInfo:[FTConfig webTips]];
            }];
        }else{
            [weakSelf failLogin];
            [HUDUtil showInfo:[NDataUtil stringWith:loginData[@"message"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [weakSelf failLogin];
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
    
}

- (void)failLogin{
    self.errorLabel.hidden = YES;
    [self.masNextBtnTop activate];
    self.errorLabel.text = @"";
    self.loginBtn.enabled = YES;
}

- (void)successLogin:(NSDictionary *)userInfo loginData:(NSDictionary *)loginData{
    WEAK_SELF;
    [UserModel sharedInstance].openGoogleAuth = [NDataUtil boolWith:userInfo[@"googleAuthenStatus"]];
    if ([UserModel sharedInstance].openGoogleAuth) {
        [HUDUtil hide];
        [AuthAlert showAlert:^{
            [[UserModel sharedInstance]login:loginData];
            [[UserModel sharedInstance]storeUserPhoneNum:weakSelf.accountText.text];
            [[UserModel sharedInstance] dataWithMyTab:userInfo];
            [HUDUtil showInfo:CFDLocalizedString(@"登录成功")];
            weakSelf.loginBtn.enabled = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNoti object:weakSelf];
            [weakSelf closeAction];
            if(weakSelf.loginSucessBlock){
                weakSelf.loginSucessBlock();
            }
           
        } closeHander:^{
            [UserModel sharedInstance].userToken=@"";
            [weakSelf failLogin];
        }];
    }else{
        [[UserModel sharedInstance]login:loginData];
        [[UserModel sharedInstance]storeUserPhoneNum:weakSelf.accountText.text];
        [[UserModel sharedInstance] dataWithMyTab:userInfo];
        [HUDUtil showInfo:CFDLocalizedString(@"登录成功")];
        weakSelf.loginBtn.enabled = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNoti object:weakSelf];
        [weakSelf closeAction];
        if(weakSelf.loginSucessBlock){
            weakSelf.loginSucessBlock();
        }
    }
}

- (void)registerAction{
    [DCRegisterVC jumpTo:self successHander:_loginSucessBlock];
}

/** 忘记密码点击事件 */
- (void)forgetPwdAction
{
    [DCForgetPwdVC jumpTo:self successHander:_loginSucessBlock];
}

- (void)cleanAction{
    _accountText.text = @"";
}

- (void)hidenKeyboard{
    [self.accountText resignFirstResponder];
    [self.pwdText resignFirstResponder];
//    [self.view endEditing:YES];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{

    BOOL flag = (_accountText.isFirstResponder||_pwdText.isFirstResponder);
 if(gestureRecognizer==self.navigationController.interactivePopGestureRecognizer) {
        if(self.navigationController.viewControllers.count==1){
            return NO;
        }
    }else if (gestureRecognizer == _tap&&flag==NO) {
        return NO;
    }
    return YES;
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notic{
    _isKeyboardShow = YES;
}

- (void)keyboardWillHide:(NSNotification *)notic{
    _isKeyboardShow = NO;
}

#pragma mark - getter

- (UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"dc_login_bg"]];
        if(IS_IPHONE_X)
            _bgImg.image = [GColorUtil imageNamed:@"dc_bg_x"];
        else
            _bgImg.image = [GColorUtil imageNamed:@"dc_login_bg"];
    }
    return _bgImg;
}

- (UIButton *)closeBtn
{
    if (_closeBtn == nil) {
        _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeBtn setImage:[GColorUtil imageNamed:@"nav_icon_close"] forState:UIControlStateNormal];
        [_closeBtn setImage:[GColorUtil imageNamed:@"nav_icon_close"] forState:UIControlStateHighlighted];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
        [_cleanBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _closeBtn;
}

- (UILabel *)registerLabel{
    if (!_registerLabel) {
        _registerLabel = [[UILabel alloc] init];
        _registerLabel.textColor = [GColorUtil C2];
        _registerLabel.font = [GUIUtil fitFont:18];
        _registerLabel.text = CFDLocalizedString(@"注册新帐号");
        WEAK_SELF;
        [_registerLabel g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf registerAction];
        }];
    }
    return _registerLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [GColorUtil C2];
        _titleLabel.font = [GUIUtil fitBoldFont:24];
        _titleLabel.text=CFDLocalizedString(@"登录_login");
    }
    return _titleLabel;
}

- (UILabel *)accountTitle{
    if (!_accountTitle) {
        _accountTitle = [[UILabel alloc] init];
        _accountTitle.textColor = [GColorUtil C2];
        _accountTitle.font = [GUIUtil fitFont:14];
        _accountTitle.text = CFDLocalizedString(@"手机号");
    }
    return _accountTitle;
}

- (UITextField *)accountText{
    if (!_accountText) {
        _accountText = [[UITextField alloc] init];
        _accountText.textColor = [GColorUtil C2];
        _accountText.font = [GUIUtil fitFont:16];
        _accountText.returnKeyType = UIReturnKeyDone;
        _accountText.delegate = self;
        _accountText.keyboardType = UIKeyboardTypeNumberPad;
        _accountText.autocorrectionType = UITextAutocorrectionTypeNo;
        _accountText.placeholder = CFDLocalizedString(@"请输入手机号");
        _accountText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_accountText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
        _accountText.rightView = self.cleanBtn;
        _accountText.clearButtonMode = UITextFieldViewModeWhileEditing;
    }
    return _accountText;
}

- (UIButton *)cleanBtn
{
    if (_cleanBtn == nil) {
        _cleanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cleanBtn.frame = CGRectMake(0, 0, 20, 20);
        [_cleanBtn setImage:[GColorUtil imageNamed:@"login_icon_close"] forState:UIControlStateNormal];
        [_cleanBtn setImage:[GColorUtil imageNamed:@"login_icon_close"] forState:UIControlStateSelected];
        [_cleanBtn addTarget:self action:@selector(cleanAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cleanBtn;
}

- (UIView *)accountline{
    if (!_accountline) {
        _accountline = [[UIView alloc] init];
        _accountline.backgroundColor = [GColorUtil C7];
    }
    return _accountline;
}


- (UILabel *)pwdTitle{
    if (!_pwdTitle) {
        _pwdTitle = [[UILabel alloc] init];
        _pwdTitle.textColor = [GColorUtil C2];
        _pwdTitle.font = [GUIUtil fitFont:14];
        _pwdTitle.text = CFDLocalizedString(@"密码");
    }
    return _pwdTitle;
}

- (UITextField *)pwdText{
    if (!_pwdText) {
        _pwdText = [[UITextField alloc] init];
        _pwdText.font = [GUIUtil fitFont:16];
        _pwdText.returnKeyType = UIReturnKeyDone;
        _pwdText.delegate = self;
        _pwdText.secureTextEntry = YES;
        _pwdText.autocorrectionType = UITextAutocorrectionTypeNo;
        _pwdText.placeholder = CFDLocalizedString(@"请输入密码");
        _pwdText.textColor = [GColorUtil C2];
        _pwdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_pwdText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
        _pwdText.rightView = self.showPwdBtn;
        _pwdText.rightViewMode = UITextFieldViewModeAlways;
    }
    return _pwdText;
}
- (UIButton *)showPwdBtn
{
    if (_showPwdBtn == nil) {
        _showPwdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _showPwdBtn.frame = CGRectMake(0, 0, 20, 20);
        [_showPwdBtn setImage:[GColorUtil imageNamed:@"login_icon_eye_close"] forState:UIControlStateNormal];
        [_showPwdBtn setImage:[GColorUtil imageNamed:@"login_icon_eye_open"] forState:UIControlStateSelected];
        [_showPwdBtn addTarget:self action:@selector(showPwdAction) forControlEvents:UIControlEventTouchUpInside];
        _showPwdBtn.selected = NO;
    }
    return _showPwdBtn;
}

- (UIView *)pwdLine{
    if (!_pwdLine) {
        _pwdLine = [[UIView alloc] init];
        _pwdLine.backgroundColor = [GColorUtil C7];
    }
    return _pwdLine;
}

- (UIButton *)loginBtn{
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        [_loginBtn setTitle:CFDLocalizedString(@"登录") forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[UIImage imageWithColor:[GColorUtil C13] size:CGSizeMake(SCREEN_WIDTH-[GUIUtil fit:60], [GUIUtil fit:44])] forState:UIControlStateNormal];
        [_loginBtn setTitleColor:[GColorUtil C2_black] forState:UIControlStateNormal];
        
        _loginBtn.layer.cornerRadius = 5;
        _loginBtn.layer.masksToBounds = YES;
        [_loginBtn addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UILabel *)errorLabel{
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.textColor = [GColorUtil C14];
        _errorLabel.font = [GUIUtil fitFont:14];
        _errorLabel.textAlignment = NSTextAlignmentCenter;
        _errorLabel.text = @"--";
        _errorLabel.hidden = YES;
    }
    return _errorLabel;
}

- (UILabel *)forgetPWLabel{
    if (!_forgetPWLabel) {
        _forgetPWLabel = [[UILabel alloc] init];
        _forgetPWLabel.textColor = [GColorUtil pwdLabelColor];
        _forgetPWLabel.font = [GUIUtil fitFont:14];
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:CFDLocalizedString(@"忘记密码") attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle],NSUnderlineColorAttributeName:[GColorUtil pwdLabelColor]}];
        _forgetPWLabel.attributedText = attStr;
        WEAK_SELF;
        [_forgetPWLabel g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf forgetPwdAction];
        }];
    }
    return _forgetPWLabel;
}


#pragma mark - Private

- (void)addNotic{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];}

- (void)removeNotic{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@synthesize hash;

@end


//
//  DCRegisterVC.m
//  niuguwang
//
//  Created by ngw15 on 2018/3/30.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "DCRegisterVC.h"
#import "DCService.h"
#import "WebVC.h"
#import "DCCountryAlert.h"

@interface DCRegisterVC()<UIGestureRecognizerDelegate,UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) UILabel *loginLabel;
@property (nonatomic,strong) UIButton *closeBtn;

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UIView *phoneView;

@property (nonatomic,strong) UILabel *accountTitle;
@property (nonatomic,strong) UITextField *accountText;
@property (nonatomic,strong) UILabel *accountRemark;
@property (nonatomic,strong) UIImageView *accountRemarkImg;
@property (nonatomic,strong) UIView *accountVLine;
@property (nonatomic,strong) UIView *accountline;

@property (nonatomic,strong) UILabel *vaildTitle;
@property (nonatomic,strong) UITextField *vaildText;
@property (nonatomic,strong) UILabel *vaildRemark;
@property (nonatomic,strong) UIView *vaildVLine;
@property (nonatomic,strong) UIView *vaildLine;

@property (nonatomic,strong) UILabel *pwdTitle;
@property (nonatomic,strong) UITextField *pwdText;
@property (nonatomic,strong) UIView *pwdLine;

@property (nonatomic,strong) UILabel *codeTitle;
@property (nonatomic,strong) UITextField *codeText;
@property (nonatomic,strong) UIView *codeLine;

@property (nonatomic,strong) UILabel *errorLabel;
@property (nonatomic,strong) UIButton *registerBtn;
@property (nonatomic,strong) UILabel *remarkLabel;

@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,copy) NSString *ccode;
@property (nonatomic,strong) MASConstraint *masNextBtnTop;

@property (nonatomic, copy)  dispatch_block_t successHander;

@end

@implementation DCRegisterVC

+ (void)jumpTo:(UIViewController *)current successHander:(dispatch_block_t)successHander{
    DCRegisterVC *target  = [[DCRegisterVC alloc] init];
    target.successHander = successHander;
    target.ccode = @"+86";
    [current.navigationController pushViewController:target animated:YES];
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
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self addNotic];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_accountText becomeFirstResponder];
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
    [self setupUserInteraction];
    [self autoLayout];
    
    //给这个UITextField的对象添加UIToolbar
    [_accountText addToolbar];
    [_pwdText addToolbar];
    [_vaildText addToolbar];
    [_codeText addToolbar];
    // Do any additional setup after loading the view.
}

- (void)setupUserInteraction{
    self.view.backgroundColor = [GColorUtil C6];
    [self.view addSubview:self.bgImg];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.phoneView];
    [self.view addSubview:self.registerBtn];
    [self.view addSubview:self.loginLabel];
    [self.view addSubview:self.errorLabel];
    [self.view addSubview:self.remarkLabel];
}

- (void)autoLayout{
    [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
        make.size.equalTo(self.view);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT+[GUIUtil fit:25]);
    }];
    [_loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:20]);
        make.centerY.equalTo(self.closeBtn);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:80]+STATUS_BAR_HEIGHT);
        make.left.mas_equalTo([GUIUtil fit:40]);
    }];
    [_phoneView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset([GUIUtil fit:30]);
    }];
   
    [_errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:40]);
        make.top.equalTo(self.phoneView.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [_registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        self.masNextBtnTop = make.top.equalTo(self.phoneView.mas_bottom).mas_offset([GUIUtil fit:30]);
        make.top.equalTo(self.errorLabel.mas_bottom).mas_offset([GUIUtil fit:20]).priority(250);
        make.left.mas_equalTo([GUIUtil fit:40]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:80]);
        make.height.mas_equalTo([GUIUtil fit:44]);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.registerBtn.mas_left);
       make.right.equalTo(self.registerBtn.mas_right); make.top.equalTo(self.registerBtn.mas_bottom).mas_offset([GUIUtil fit:10]);
    }];
}

#pragma mark - Action


- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeAction{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)registerAction:(UIButton *)btn{
    NSString *account = @"";
    NSString *pwd = @"";
    NSString *code = @"";
    NSString *yqCode = @"";
    NSString *errorText = @"";
    account = _accountText.text;
    pwd = _pwdText.text;
    code = _vaildText.text;
    yqCode = _codeText.text;
    if (![NDataUtil isMobilePhone:_accountText.text]) {
        errorText = CFDLocalizedString(@"手机号输入错误");
    }
    if ([NDataUtil isNumber:code]==NO||code.length!=4) {
        errorText = CFDLocalizedString(@"验证码错误");
    }
    if([NDataUtil checkPassWord:pwd]==NO){
        errorText = CFDLocalizedString(@"密码格式错误");
    }
    if (yqCode.length<=0) {
        errorText = CFDLocalizedString(@"邀请码不能为空");
    }
    if (errorText.length>0) {
        _errorLabel.hidden = NO;
        [_masNextBtnTop deactivate];
        _errorLabel.text = errorText;
        return;
    }
    _registerBtn.enabled = NO;
    [HUDUtil showProgress:@""];
    [self registerMobile:account code:code password:pwd yqCode:yqCode success:_successHander];
}

- (void)hidenKeyboard{
    [self.view endEditing:YES];
    [self.accountText resignFirstResponder];
    [self.vaildText resignFirstResponder];
    [self.pwdText resignFirstResponder];
    [self.codeText resignFirstResponder];
}

//MARK: - Load

- (void)registerMobile:(NSString *)mobile code:(NSString *)code password:(NSString *)password yqCode:(NSString *)yCode success:(dispatch_block_t)successHander{
    
    [HUDUtil showProgress:@""];
    WEAK_SELF;
    [DCService postregisterMobile:mobile Code:code password:password yqCode:yCode cCode:self.ccode sucess:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"result" isEqual:@"1"]) {
            [HUDUtil showInfo:CFDLocalizedString(@"注册成功")];
            [[UserModel sharedInstance]login:data[@"userInfo"]];
            [[UserModel sharedInstance]storeUserPhoneNum:mobile];
            [[UserModel sharedInstance] getUserIndex:^{
                weakSelf.registerBtn.enabled = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:LoginSuccessNoti object:weakSelf];
                [weakSelf closeAction];
                if (successHander) {
                    successHander();
                }
            } failure:^{
                weakSelf.registerBtn.enabled = YES;
                [weakSelf closeAction];
                if (successHander) {
                    successHander();
                }
            }];
        }else{
            weakSelf.registerBtn.enabled = YES;
            weakSelf.errorLabel.hidden = YES;
            [weakSelf.masNextBtnTop activate];
            weakSelf.errorLabel.text = @"";
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"message"] valid:[FTConfig webTips]]];
        }
       
    } failure:^(NSError *error) {
        weakSelf.registerBtn.enabled = YES;
        [HUDUtil showInfo:[FTConfig webTips]];
        weakSelf.errorLabel.hidden = YES;
        [weakSelf.masNextBtnTop activate];
        weakSelf.errorLabel.text = @"";
    }];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notic{
    NSDictionary *dic = [notic userInfo];
    CGRect keyboardFrame = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]; //获得键盘
    CGFloat bottom = [self.view convertPoint:CGPointMake(0, self.codeLine.bottom) fromView:self.phoneView].y;
    bottom = SCREEN_HEIGHT - bottom;
    CGFloat offset =keyboardFrame.size.height-bottom;
    if (offset>0) {
        [UIView beginAnimations:@"DCRegisterVC" context:NULL];
        [UIView setAnimationDuration:[dic[UIKeyboardAnimationDurationUserInfoKey]floatValue]];
        [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey]integerValue]];
        UIScrollView *scrollView = (UIScrollView *)self.view;
        scrollView.contentOffset = CGPointMake(0, offset);
        self.loginLabel.transform = CGAffineTransformMakeTranslation(0, offset);
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)notic{
    NSDictionary *dic = [notic userInfo];
    CGRect keyboardFrame = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]; //获得键盘
    CGFloat bottom = [self.view convertPoint:CGPointMake(0, self.codeLine.bottom) fromView:self.phoneView].y;
    bottom = SCREEN_HEIGHT - bottom;
    CGFloat offset =keyboardFrame.size.height-bottom;
    if (offset>0) {
        [UIView beginAnimations:@"DCRegisterVC" context:NULL];
        [UIView setAnimationDuration:[dic[UIKeyboardAnimationDurationUserInfoKey]floatValue]];
        [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey]integerValue]];
        UIScrollView *scrollView = (UIScrollView *)self.view;
        scrollView.contentOffset = CGPointMake(0, 0);
        self.loginLabel.transform = CGAffineTransformIdentity;
        [UIView commitAnimations];
    }
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    BOOL flag = (_accountText.isFirstResponder||_pwdText.isFirstResponder||_vaildText.isFirstResponder||_codeText.isFirstResponder);
    if (gestureRecognizer == _tap&&flag==NO) {
        return NO;
    }
    return YES;
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
        [_closeBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _closeBtn;
}

- (UILabel *)loginLabel{
    if (!_loginLabel) {
        _loginLabel = [[UILabel alloc] init];
        _loginLabel.textColor = [GColorUtil C2];
        _loginLabel.font = [GUIUtil fitFont:18];
        _loginLabel.text = CFDLocalizedString(@"已有账号");
        WEAK_SELF;
        [_loginLabel g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf backAction];
        }];
    }
    return _loginLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [GColorUtil C2];
        _titleLabel.font = [GUIUtil fitBoldFont:24];
        _titleLabel.text=CFDLocalizedString(@"注册_register");
    }
    return _titleLabel;
}

- (UIView *)phoneView{
    if (!_phoneView) {
        _phoneView = [[UIView alloc] init];
        _phoneView.backgroundColor = [UIColor clearColor];
        
        [_phoneView addSubview:self.accountTitle];
        [_phoneView addSubview:self.accountText];
        [_phoneView addSubview:self.accountRemark];
        [_phoneView addSubview:self.accountRemarkImg];
        [_phoneView addSubview:self.accountVLine];
        [_phoneView addSubview:self.accountline];
        
        [_phoneView addSubview:self.vaildTitle];
        [_phoneView addSubview:self.vaildText];
        [_phoneView addSubview:self.vaildRemark];
        [_phoneView addSubview:self.vaildVLine];
        [_phoneView addSubview:self.vaildLine];
        
        [_phoneView addSubview:self.pwdTitle];
        [_phoneView addSubview:self.pwdText];
        [_phoneView addSubview:self.pwdLine];
        
        [_phoneView addSubview:self.codeTitle];
        [_phoneView addSubview:self.codeText];
        [_phoneView addSubview:self.codeLine];
        
        [_accountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.top.mas_equalTo([GUIUtil fit:5]);
        }];
        [_accountText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.accountVLine.mas_right).mas_offset([GUIUtil fit:10]);
            make.top.equalTo(self.accountTitle.mas_bottom).mas_offset([GUIUtil fit:5]);
            make.height.mas_equalTo([GUIUtil fit:40]);
            make.width.mas_equalTo([GUIUtil fit:230]);
        }];
        [_accountRemark mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:45]);
            make.centerY.equalTo(self.accountText);
        }];
        [_accountRemarkImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.accountRemark.mas_right).mas_offset([GUIUtil fit:7]);
            make.centerY.equalTo(self.accountText);
        }];
        [_accountVLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.accountRemarkImg.mas_right).mas_offset([GUIUtil fit:7]);
            make.width.mas_equalTo([GUIUtil fitLine]);
            make.centerY.equalTo(self.accountText);
            make.height.mas_equalTo([GUIUtil fit:20]);
        }];
        [_accountline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.accountText.mas_bottom).mas_offset([GUIUtil fit:-3]);
            make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:66]);
            make.left.mas_equalTo([GUIUtil fit:20]);
            make.height.mas_equalTo([GUIUtil fitLine]);
        }];
        
        [_vaildTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.top.equalTo(self.accountline.mas_bottom).mas_offset([GUIUtil fit:15]);
        }];
        [_vaildText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.top.equalTo(self.vaildTitle.mas_bottom).mas_offset([GUIUtil fit:5]);
            make.height.mas_equalTo([GUIUtil fit:40]);
            make.width.mas_equalTo([GUIUtil fit:230]);
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
            make.bottom.equalTo(self.vaildText.mas_bottom).mas_offset([GUIUtil fit:-3]);
            make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:66]);
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.height.mas_equalTo(0.5);
        }];
        
        [_pwdTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.top.equalTo(self.vaildLine.mas_bottom).mas_offset([GUIUtil fit:15]);
        }];
        [_pwdText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.pwdTitle.mas_bottom).mas_offset(([GUIUtil fit:5]));
            make.height.mas_equalTo([GUIUtil fit:40]);
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:80]);
        }];
        [_pwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.pwdText.mas_bottom).mas_offset([GUIUtil fit:-5]);
            make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:66]);
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.height.mas_equalTo(0.5);
            
        }];
        
        [_codeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.top.equalTo(self.pwdLine.mas_bottom).mas_offset([GUIUtil fit:15]);
        }];
        [_codeText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.codeTitle.mas_bottom).mas_offset(([GUIUtil fit:5]));
            make.height.mas_equalTo([GUIUtil fit:40]);
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:80]);
        }];
        [_codeLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.codeText.mas_bottom).mas_offset([GUIUtil fit:-5]);
            make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:66]);
            make.left.mas_equalTo([GUIUtil fit:40]);
            make.height.mas_equalTo(0.5);
            make.bottom.mas_equalTo([GUIUtil fit:-10]);
        }];
    }
    return _phoneView;
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
        _accountText.font = [GUIUtil fitFont:14];
        _accountText.returnKeyType = UIReturnKeyDone;
        _accountText.delegate = self;
        _accountText.keyboardType = UIKeyboardTypeNumberPad;
        _accountText.autocorrectionType = UITextAutocorrectionTypeNo;
        _accountText.placeholder = CFDLocalizedString(@"请输入手机号");
        _accountText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_accountText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
    }
    return _accountText;
}

- (UILabel *)accountRemark{
    if (!_accountRemark) {
        _accountRemark = [[UILabel alloc] init];
        _accountRemark.text = @"+86";
        _accountRemark.font =[GUIUtil fitFont:14];
        _accountRemark.textColor = [GColorUtil C2];
        _accountRemark.g_checkRepeatClick = NO;
        WEAK_SELF;
        [_accountRemark g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf.view endEditing:YES];
            [DCCountryAlert showAlert:weakSelf.ccode selectedHander:^(NSDictionary * _Nonnull dic) {
                weakSelf.ccode = [NDataUtil stringWith:dic[@"ccode"]];
                weakSelf.accountRemark.text = weakSelf.ccode;
            }];
        }];
    }
    return _accountRemark;
}

- (UIImageView *)accountRemarkImg{
    if (!_accountRemarkImg) {
        _accountRemarkImg = [[UIImageView alloc] init];
        _accountRemarkImg.image = [GColorUtil imageNamed:@"registered_icon_more"];
        _accountRemarkImg.g_checkRepeatClick = NO;
        WEAK_SELF;
        [_accountRemarkImg g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf.view endEditing:YES];
            [DCCountryAlert showAlert:weakSelf.ccode selectedHander:^(NSDictionary * _Nonnull dic) {
                weakSelf.ccode = [NDataUtil stringWith:dic[@"ccode"]];
                weakSelf.accountRemark.text = weakSelf.ccode;
            }];
        }];
    }
    return _accountRemarkImg;
}

- (UIView *)accountVLine{
    if (!_accountVLine) {
        _accountVLine = [[UIView alloc] init];
        _accountVLine.backgroundColor = [GColorUtil C7];
    }
    return _accountVLine;
}

- (UIView *)accountline{
    if (!_accountline) {
        _accountline = [[UIView alloc] init];
        _accountline.backgroundColor = [GColorUtil C7];
    }
    return _accountline;
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
        _vaildText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_vaildText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
    }
    return _vaildText;
}

- (UILabel *)vaildRemark{
    if (!_vaildRemark) {
        _vaildRemark = [[UILabel alloc] init];
        _vaildRemark.text = CFDLocalizedString(@"发送验证码");
        _vaildRemark.font =[GUIUtil fitFont:14];
        _vaildRemark.textColor = [GColorUtil C2];
        _vaildRemark.userInteractionEnabled = YES;
        _vaildRemark.textAlignment = NSTextAlignmentRight;
        WEAK_SELF;
        [_vaildRemark g_clickBlock:^(UITapGestureRecognizer *tap) {
            BOOL flag = [CFDApp sendVaildPhoneCode:weakSelf.vaildRemark mobile:weakSelf.accountText.text smsType:21 ccode:weakSelf.ccode];
            if (flag==NO) {
                weakSelf.errorLabel.hidden = NO;
                [weakSelf.masNextBtnTop deactivate];
                weakSelf.errorLabel.text = CFDLocalizedString(@"手机号输入错误");
                return ;
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
        _pwdText.textColor = [GColorUtil C2];
        _pwdText.font = [GUIUtil fitFont:14];
        _pwdText.returnKeyType = UIReturnKeyDone;
        _pwdText.delegate = self;
        _pwdText.secureTextEntry = YES;
        _pwdText.autocorrectionType = UITextAutocorrectionTypeNo;
        _pwdText.placeholder = CFDLocalizedString(@"6~32位数字、字母或符号的组合");
        _pwdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_pwdText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
        _pwdText.secureTextEntry = YES;
        _pwdText.rightViewMode = UITextFieldViewModeAlways;
        UIButton *eyeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [eyeBtn setImage:[GColorUtil imageNamed:@"login_icon_eye_close"] forState:UIControlStateNormal];
        [eyeBtn setImage:[GColorUtil imageNamed:@"login_icon_eye_open"] forState:UIControlStateSelected];
        [eyeBtn addTarget:self action:@selector(eyeAction:) forControlEvents:UIControlEventTouchUpInside];
        _pwdText.rightView = eyeBtn;
    }
    return _pwdText;
}

- (void)eyeAction:(UIButton *)sender{
    sender.selected = !sender.isSelected;
    _pwdText.secureTextEntry = !sender.selected;
}


- (UIView *)pwdLine{
    if (!_pwdLine) {
        _pwdLine = [[UIView alloc] init];
        _pwdLine.backgroundColor = [GColorUtil C7];
    }
    return _pwdLine;
}

- (UILabel *)codeTitle{
    if (!_codeTitle) {
        _codeTitle = [[UILabel alloc] init];
        _codeTitle.textColor = [GColorUtil C2];
        _codeTitle.font = [GUIUtil fitFont:14];
        _codeTitle.text = CFDLocalizedString(@"邀请码");
    }
    return _codeTitle;
}

- (UITextField *)codeText{
    if (!_codeText) {
        _codeText = [[UITextField alloc] init];
        _codeText.textColor = [GColorUtil C2];
        _codeText.font = [GUIUtil fitFont:14];
        _codeText.returnKeyType = UIReturnKeyDone;
        _codeText.delegate = self;
        _codeText.autocorrectionType = UITextAutocorrectionTypeNo;
        _codeText.placeholder = CFDLocalizedString(@"请输入邀请码，必填");
        _codeText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_codeText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
    }
    return _codeText;
}


- (UIView *)codeLine{
    if (!_codeLine) {
        _codeLine = [[UIView alloc] init];
        _codeLine.backgroundColor = [GColorUtil C7];
    }
    return _codeLine;
}

- (UIButton *)registerBtn{
    if (!_registerBtn) {
        _registerBtn = [[UIButton alloc] init];
        [_registerBtn setTitle:CFDLocalizedString(@"注册") forState:UIControlStateNormal];
        [_registerBtn setBackgroundImage:[UIImage imageWithColor:[GColorUtil C13] size:CGSizeMake(SCREEN_WIDTH-[GUIUtil fit:60], [GUIUtil fit:44])] forState:UIControlStateNormal];
        [_registerBtn setTitleColor:[GColorUtil C2_black] forState:UIControlStateNormal];
        _registerBtn.layer.cornerRadius = 5;
        _registerBtn.layer.masksToBounds = YES;
        [_registerBtn addTarget:self action:@selector(registerAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
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

- (UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.textColor = [GColorUtil colorWithHex:0xffffff];
        _remarkLabel.font = [GUIUtil fitFont:12];
        _remarkLabel.numberOfLines = 0;
        if ([[FTConfig sharedInstance].lang isEqualToString:@"cn"]) {
            
            NSString *text = @"点击注册即表示您同意《";
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
            NSString *title = [NSString stringWithFormat:@"%@注册协议",[FTConfig sharedInstance].displayName];
            NSAttributedString *str= [[NSAttributedString alloc] initWithString:title attributes:@{NSUnderlineStyleAttributeName:@(1),NSUnderlineColorAttributeName:[GColorUtil C6]}];
            [attStr appendAttributedString:str];
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:@"》"]];
            _remarkLabel.attributedText = attStr;
        }else{
            NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"If you click the \"Sign Up\" button, you will be deemed to agree to the Bitmixs registration agreement."];
            attStr.lineSpacing = [GUIUtil fit:5];
            _remarkLabel.attributedText = attStr;
        }
        WEAK_SELF;
        [_remarkLabel g_clickBlock:^(UITapGestureRecognizer *tap) {
            NSString *url = [NSString stringWithFormat:@"%@?name=%@",[[FTConfig sharedInstance] registrationAgreement],[[[FTConfig sharedInstance] displayName] stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
            [WebVC jumpTo:weakSelf title:CFDLocalizedString(@"注册协议") link:url type:WebVCTypeDefault canGoBack:NO animated:YES];
        }];
    }
    return _remarkLabel;
}

#pragma mark - Private

- (void)textFieldDone
{
    [self.accountText resignFirstResponder];
}

- (void)addNotic{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];}

- (void)removeNotic{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end



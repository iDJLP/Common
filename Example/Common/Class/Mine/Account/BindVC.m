//
//  BindVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BindVC.h"
#import "QZHCheckIDStatusVC.h"

@interface BindVC () <UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (nonatomic,assign) BindType type;
@property (nonatomic,strong) UIView *navView;
@property (nonatomic,strong) UIButton *backBtn;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIView *navline;
@property (nonatomic,strong) UIScrollView *scrollView;

@property (nonatomic,strong) UILabel *firstTitle;
@property (nonatomic,strong) UITextField *firstText;
@property (nonatomic,strong) UIImageView *firstIcon;
@property (nonatomic,strong) UIView *firstLine;

@property (nonatomic,strong) UILabel *secondTitle;
@property (nonatomic,strong) UITextField *secondText;
@property (nonatomic,strong) UILabel *secondRemark;
@property (nonatomic,strong) UIView *secondVLine;
@property (nonatomic,strong) UIView *secondLine;

@property (nonatomic,strong) UILabel *thirdTitle;
@property (nonatomic,strong) UITextField *thirdText;
@property (nonatomic,strong) UILabel *thirdRemark;
@property (nonatomic,strong) UIView *thirdVLine;
@property (nonatomic,strong) UIView *thirdLine;

@property (nonatomic,strong) UILabel *errorLabel;
@property (nonatomic,strong) UIButton *nextBtn;
@property (nonatomic,strong) UIView *remarkView;
@property (nonatomic,strong) UILabel *remarkLabel;

@property (nonatomic,strong) MASConstraint *masFirstTextWidth;
@property (nonatomic,strong) MASConstraint *massecondTextWidth;
@property (nonatomic,strong) MASConstraint *masNextBtnTopThird;
@property (nonatomic,strong) MASConstraint *masNextBtnTopSecond;
@property (nonatomic,strong) MASConstraint *masRemarkTop;
@property (nonatomic,strong) MASConstraint *masFirstTop;
@property (nonatomic,strong) MASConstraint *masErrorTop;

@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,strong) id object;
@property (nonatomic,copy) void(^completeHander)(id data);

@end

@implementation BindVC

+ (void)jumpTo:(BindType)type{
    if ([UserModel isLogin]==NO) {
        [CFDJumpUtil jumpToLogin];
        return;
    }
    [self jumpTo:type object:@"" complete:^(id  _Nonnull data) {
        
    }];
}

+ (void)jumpTo:(BindType)type object:(id)object complete:(void (^)(id))hander{
    BindVC *target = [[BindVC alloc] init];
    target.type = type;
    target.object = object;
    target.completeHander=hander;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [_firstText becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self hidenKeyboard];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUserInteraction];
    [self autoLayout];
    [self configUI];
    //给这个UITextField的对象添加UIToolbar
    [_firstText addToolbar];
    [_secondText addToolbar];
    [_thirdText addToolbar];
    // Do any additional setup after loading the view.
}
- (void)setupUserInteraction{
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.navView];
    
    [self.scrollView addSubview:self.firstTitle];
    [self.scrollView addSubview:self.firstText];
    [self.scrollView addSubview:self.firstIcon];
    [self.scrollView addSubview:self.firstLine];
    
    [self.scrollView addSubview:self.secondTitle];
    [self.scrollView addSubview:self.secondText];
    [self.scrollView addSubview:self.secondRemark];
    [self.scrollView addSubview:self.secondVLine];
    [self.scrollView addSubview:self.secondLine];
    
    [self.scrollView addSubview:self.thirdTitle];
    [self.scrollView addSubview:self.thirdText];
    [self.scrollView addSubview:self.thirdRemark];
    [self.scrollView addSubview:self.thirdVLine];
    [self.scrollView addSubview:self.thirdLine];
    
    [self.scrollView addSubview:self.errorLabel];
    [self.scrollView addSubview:self.nextBtn];
    [self.scrollView addSubview:self.remarkView];
    
}

- (void)configUI{
    WEAK_SELF;
    switch (_type) {
        case BindTypeAlterPhone:
        {
            _titleLabel.text = @"修改绑定手机号码";
            _firstTitle.text = @"新手机号";
            _firstText.placeholder = @"请输入新手机号";
            _firstText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_firstText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
            _secondTitle.text = @"短信验证码";
            _secondText.placeholder = @"请输入验证码";
            _secondText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_secondText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
            [_secondRemark g_clickBlock:^(UITapGestureRecognizer *tap) {
                
                BOOL flag = [CFDApp sendVaildPhoneCode:weakSelf.secondRemark mobile:weakSelf.firstText.text smsType:23 ccode:@"todo"];
                if (flag==NO) {
                    weakSelf.errorLabel.hidden = NO;
                    [weakSelf.masNextBtnTopSecond deactivate];
                    weakSelf.errorLabel.text = @"手机号输入错误";
                    return;
                }
                [weakSelf.secondText becomeFirstResponder];
                weakSelf.errorLabel.hidden = YES;
                [weakSelf.masNextBtnTopSecond activate];
                weakSelf.secondRemark.userInteractionEnabled = NO;
            }];
            _thirdLine.hidden = _thirdTitle.hidden = _thirdVLine.hidden = _thirdRemark.hidden = _thirdText.hidden = YES;
            [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
            [_masNextBtnTopThird deactivate];
            [_masNextBtnTopSecond activate];
            [_masErrorTop deactivate];
        }
            break;
        case BindTypeVaildPhone:
        {
            _titleLabel.text = @"验证原手机号码";
            _firstTitle.text = @"原手机号";
            _firstText.placeholder = @"请输入原手机号";
            _firstText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_firstText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
            _secondTitle.text = @"短信验证码";
            _secondText.placeholder = @"请输入验证码";
            _secondText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_secondText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
            [_secondRemark g_clickBlock:^(UITapGestureRecognizer *tap) {
                BOOL flag = [CFDApp sendVaildPhoneCode:weakSelf.secondRemark mobile:weakSelf.firstText.text smsType:24 ccode:@"todo"];
                if (flag==NO) {
                    weakSelf.errorLabel.hidden = NO;
                    [weakSelf.masNextBtnTopSecond deactivate];
                    weakSelf.errorLabel.text = @"手机号输入错误";
                    return;
                }
                [weakSelf.secondText becomeFirstResponder];
                weakSelf.errorLabel.hidden = YES;
                [weakSelf.masNextBtnTopSecond activate];
                weakSelf.secondRemark.userInteractionEnabled = NO;
            }];
            _thirdLine.hidden = _thirdTitle.hidden = _thirdVLine.hidden = _thirdRemark.hidden = _thirdText.hidden = YES;
            [_nextBtn setTitle:@"下一步" forState:UIControlStateNormal];
            [_masNextBtnTopThird deactivate];
            [_masNextBtnTopSecond activate];
            [_masErrorTop deactivate];
        }
            break;
        case BindTypeAddPhone:
        {
            _titleLabel.text = @"绑定手机号码";
            _firstTitle.text = @"新手机号";
            _firstText.placeholder = @"请输入手机号";
            _firstText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_firstText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
            _secondTitle.text = @"短信验证码";
            _secondText.placeholder = @"请输入短信验证码";
            _secondText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_secondText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
            _thirdTitle.text = @"邮箱验证码";
            _thirdText.placeholder = @"请输入邮箱验证码";
            _thirdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_thirdText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];

            [_secondRemark g_clickBlock:^(UITapGestureRecognizer *tap) {
                BOOL flag = [CFDApp sendVaildPhoneCode:weakSelf.secondRemark mobile:weakSelf.firstText.text smsType:27 ccode:@"todo"];
                if (flag==NO) {
                    weakSelf.errorLabel.hidden = NO;
                    [weakSelf.masNextBtnTopSecond deactivate];
                    weakSelf.errorLabel.text = @"手机号输入错误";
                    return;
                }
                [weakSelf.secondText becomeFirstResponder];
                weakSelf.errorLabel.hidden = YES;
                [weakSelf.masNextBtnTopSecond activate];
                weakSelf.secondRemark.userInteractionEnabled = NO;
            }];
            [_thirdRemark g_clickBlock:^(UITapGestureRecognizer *tap) {
//                BOOL flag = [QZHApp sendVaildEmailCode:weakSelf.thirdRemark email:weakSelf.thirdText.text smsType:37];
//                if (flag==NO) {
//                    weakSelf.errorLabel.hidden = NO;
//                    [_masNextBtnTopSecond deactivate];
//                    weakSelf.errorLabel.text = @"邮箱输入不正确";
//                    return;
//                }
//                [weakSelf.thirdText becomeFirstResponder];
//                weakSelf.errorLabel.hidden = YES;
//                [weakSelf.masNextBtnTopSecond activate];
//                weakSelf.thirdRemark.userInteractionEnabled = NO;
            }];
            [_nextBtn setTitle:@"绑定" forState:UIControlStateNormal];
            [_masNextBtnTopThird activate];
            [_masNextBtnTopSecond deactivate];
        }
            break;
        case BindTypeAddEmail:
        {
            _titleLabel.text = @"绑定邮箱";
            _firstTitle.text = @"邮箱";
            _firstText.placeholder = @"请输入邮箱";
            _firstText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_firstText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
            _secondTitle.text = @"邮箱验证码";
            _secondText.placeholder = @"请输入邮箱验证码";
            _secondText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_secondText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
            _thirdTitle.text = @"短信验证码";
            _thirdText.placeholder = @"请输入短信验证码";
            _thirdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_thirdText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];

            [_secondRemark g_clickBlock:^(UITapGestureRecognizer *tap) {
//                BOOL flag = [CFDApp sendVaildEmailCode:weakSelf.secondRemark email:weakSelf.firstText.text smsType:37];
//                if (flag==NO) {
//                    weakSelf.errorLabel.hidden = NO;
//                    [_masNextBtnTopSecond deactivate];
//                    weakSelf.errorLabel.text = @"邮箱输入不正确";
//                    return;
//                }
//                [weakSelf.secondText becomeFirstResponder];
//                weakSelf.errorLabel.hidden = YES;
//                [weakSelf.masNextBtnTopSecond activate];
//                weakSelf.secondRemark.userInteractionEnabled = NO;
            }];
            [_thirdRemark g_clickBlock:^(UITapGestureRecognizer *tap) {
                BOOL flag = [CFDApp sendVaildPhoneCode:weakSelf.thirdRemark mobile:[UserModel sharedInstance].mobilePhone smsType:27 ccode:@"todo"];
                if (flag==NO) {
                    weakSelf.errorLabel.hidden = NO;
                    [weakSelf.masNextBtnTopSecond deactivate];
                    weakSelf.errorLabel.text = @"手机号输入错误";
                    return;
                }
                [weakSelf.thirdText becomeFirstResponder];
                weakSelf.errorLabel.hidden = YES;
                [weakSelf.masNextBtnTopSecond activate];
                weakSelf.thirdRemark.userInteractionEnabled = NO;
            }];
            [_nextBtn setTitle:@"绑定" forState:UIControlStateNormal];
            [_masNextBtnTopThird activate];
            [_masNextBtnTopSecond deactivate];
        }
            break;
        case BindTypeSetFundPwd:
        case BindTypeAlterFundPwd:
        {
            _titleLabel.text = @"设置资金密码";
            if (_type==BindTypeAlterFundPwd) {
                _titleLabel.text = @"修改资金密码";
            }
            _firstTitle.text = @"资金密码";
            _firstText.placeholder = @"6~32位数字、字母或符号的组合";
            _firstText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_firstText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
            _secondTitle.text = @"再次输入";
            _secondText.placeholder = @"6~32位数字、字母或符号的组合";
            _secondText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_secondText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
            if([UserModel sharedInstance].mobilePhone.length >0){
                _thirdTitle.text = @"短信验证码";
                _thirdText.placeholder = @"请输入短信验证码";
                _thirdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_thirdText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];

                [_thirdRemark g_clickBlock:^(UITapGestureRecognizer *tap) {
                    BOOL flag=[CFDApp sendVaildPhoneCode:weakSelf.thirdRemark mobile:[UserModel sharedInstance].mobilePhone smsType:26 ccode:@"todo"];
                    if (flag==NO) {
                        weakSelf.errorLabel.hidden = NO;
                        [weakSelf.masNextBtnTopSecond deactivate];
                        weakSelf.errorLabel.text = @"手机号输入错误";
                        return;
                    }
                    [weakSelf.thirdText becomeFirstResponder];
                    weakSelf.errorLabel.hidden = YES;
                    [weakSelf.masNextBtnTopSecond activate];
                    weakSelf.thirdRemark.userInteractionEnabled = NO;
                }];
            }else{
                _thirdTitle.text = @"邮箱验证码";
                _thirdText.placeholder = @"请输入邮箱验证码";
                _thirdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_thirdText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];

                [_thirdRemark g_clickBlock:^(UITapGestureRecognizer *tap) {
//                    BOOL flag = [QZHApp sendVaildEmailCode:weakSelf.thirdRemark email:[QZHMyModel sharedInstance].emailNum smsType:36];
//                    if (flag==NO) {
//                        weakSelf.errorLabel.hidden = NO;
//                        [_masNextBtnTopSecond deactivate];
//                        weakSelf.errorLabel.text = @"邮箱输入不正确";
//                        return;
//                    }
//                    [weakSelf.thirdText becomeFirstResponder];
//                    weakSelf.errorLabel.hidden = YES;
//                    [weakSelf.masNextBtnTopSecond activate];
//                    weakSelf.thirdRemark.userInteractionEnabled = NO;
                }];
            }
            
            [_nextBtn setTitle:@"确认" forState:UIControlStateNormal];
            [_masNextBtnTopThird activate];
            [_masNextBtnTopSecond deactivate];
            
            _firstText.secureTextEntry = YES;
            UIButton *eyeBtn1 = self.pwdShowBtn;
            eyeBtn1.tag = 1213+1;
            _firstText.rightView = eyeBtn1;
            _firstText.rightViewMode = UITextFieldViewModeAlways;
            [_masFirstTextWidth deactivate];
            
            _secondText.secureTextEntry = YES;
            UIButton *eyeBtn2 = self.pwdShowBtn;
            eyeBtn2.tag = 1213+2;
            _secondText.rightView = eyeBtn2;
            _secondText.rightViewMode = UITextFieldViewModeAlways;
            _secondVLine.hidden = _secondRemark.hidden = YES;
            [_massecondTextWidth deactivate];
            
            _remarkView.hidden = NO;
            [_masFirstTop deactivate];
            [_masRemarkTop activate];
            _remarkView.backgroundColor = [GColorUtil colorWithColorType:C13_ColorType alpha:0.1];
            _remarkLabel.text = @"注意：您的资金密码将用于交易和提现，建议您设置与登录密码不一致的密码。";
            
        }
            break;
        case BindTypeIdAuth:
        {
            _titleLabel.text = CFDLocalizedString(@"实名认证");
            _firstTitle.text = CFDLocalizedString(@"真实姓名");
            _firstText.placeholder = CFDLocalizedString(@"请输入真实姓名");
            _firstText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_firstText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
            _secondTitle.text = CFDLocalizedString(@"身份证号");
            _secondText.placeholder = CFDLocalizedString(@"请输入身份证号");
            _secondText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_secondText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
            [_nextBtn setTitle:CFDLocalizedString(@"提交") forState:UIControlStateNormal];
            _firstText.keyboardType = UIKeyboardTypeDefault;
            [_masNextBtnTopThird deactivate];
            [_masNextBtnTopSecond activate];
            [_masFirstTop deactivate];
            [_masErrorTop deactivate];
            
            _secondVLine.hidden = _secondRemark.hidden = YES;
            _thirdLine.hidden = _thirdTitle.hidden = _thirdVLine.hidden = _thirdRemark.hidden = _thirdText.hidden = YES;
            
            [_masRemarkTop activate];
            _remarkView.backgroundColor = [GColorUtil colorWithColorType:C13_ColorType alpha:0.1];
            _remarkView.hidden = NO;
            _remarkLabel.text = CFDLocalizedString(@"为了您的资金安全，需验证您的身份才可进行其他操作；认证信息一经验证将不可修改，请务必如实填写。");
        }
            break;
        case BindTypeBank:
        {
            _titleLabel.text = CFDLocalizedString(@"绑定银行卡");
            _firstTitle.text = CFDLocalizedString(@"银行卡");
            _firstText.placeholder = CFDLocalizedString(@"请输入银行卡号");
            _firstText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_firstText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
            _secondTitle.text = CFDLocalizedString(@"银行名称");
            _secondText.placeholder = CFDLocalizedString(@"如工商银行、招商银行");
            _secondText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_secondText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
            [_nextBtn setTitle:CFDLocalizedString(@"提交") forState:UIControlStateNormal];
            _firstText.keyboardType = UIKeyboardTypeDefault;
            [_masNextBtnTopThird deactivate];
            [_masNextBtnTopSecond activate];
            [_masFirstTop deactivate];
            [_masErrorTop deactivate];
            
            _secondVLine.hidden = _secondRemark.hidden = YES;
            _thirdLine.hidden = _thirdTitle.hidden = _thirdVLine.hidden = _thirdRemark.hidden = _thirdText.hidden = YES;
            
            [_masRemarkTop activate];
            _remarkView.backgroundColor = [GColorUtil colorWithColorType:C13_ColorType alpha:0.1];
            _remarkView.hidden = NO;
            _remarkLabel.text = CFDLocalizedString(@"绑定银行卡后，卖币提现的资金将转账至您所绑定的银行卡，如需更换银行卡，请先将银行卡解绑。银行卡开户人必须与您实名认证信息一致。");
        }
            break;
        case BindTypeAddAddress:{
//            NSString *defaultName = @"";
//            __block NSInteger maxNum = 1;
//            if ([_object isKindOfClass:[NSArray class]]) {
//                [_object enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
//                    NSString *name = [NDataUtil stringWith:obj[@"remarks"] valid:@""];
//                    if ([QZHAppUtil checkAddressName:name]) {
//                        NSInteger num = [[[name componentsSeparatedByString:@" "] lastObject] integerValue];
//                        if (maxNum<num+1) {
//                            maxNum = num+1;
//                        }
//                    }
//                }];
//            }
//            defaultName = [NSString stringWithFormat:@"BTC-Address%ld",(long)maxNum];
//            _titleLabel.text = @"添加地址";
//            _firstTitle.text = @"地址";
//            _firstIcon.hidden = NO;
//            _firstText.placeholder = @"请输入或长按粘贴地址";
//
//            [_firstIcon g_clickBlock:^(UITapGestureRecognizer *tap) {
//                [QRCodeVC jumpToFetchAddress:^(NSString *address) {
//                    weakSelf.firstText.text = address;
//                }];
//            }];
//            _secondTitle.text = @"名称";
//            _secondText.placeholder = @"请输入名称";
//            _secondText.text = defaultName;
//            _secondRemark.hidden = _secondVLine.hidden = YES;
//            _thirdLine.hidden = _thirdTitle.hidden = _thirdVLine.hidden = _thirdRemark.hidden = _thirdText.hidden = YES;
//            [_nextBtn setTitle:@"确定" forState:UIControlStateNormal];
//            [_masNextBtnTopThird deactivate];
//            [_masNextBtnTopSecond activate];
//            [_masErrorTop deactivate];
        }
            break;
        default:
            break;
    }
}

- (void)autoLayout{
    
    [_navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(TOP_BAR_HEIGHT);
    }];
    
    [_firstTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:20]);
        _masFirstTop = make.top.mas_equalTo([GUIUtil fit:20]+TOP_BAR_HEIGHT).priority(750);
        make.top.equalTo(_remarkView.mas_bottom).mas_offset([GUIUtil fit:20]);
    }];
    [_firstText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:40]).priority(500);
        make.top.equalTo(_firstTitle.mas_bottom);
        make.height.mas_equalTo([GUIUtil fit:40]);
        _masFirstTextWidth=make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:125]).priority(750);
        make.width.mas_equalTo([GUIUtil fit:304]).priority(700);
    }];
    [_firstIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_firstLine).mas_offset([GUIUtil fit:-10]);
        make.centerY.equalTo(_firstText);
    }];
    [_firstLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_firstText.mas_bottom).mas_offset([GUIUtil fit:-3]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:66]);
        make.left.mas_equalTo([GUIUtil fit:33]);
        make.height.mas_equalTo(0.5);
    }];
    
    [_secondTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:20]);
        make.top.equalTo(_firstLine.mas_bottom).mas_offset([GUIUtil fit:15]);
    }];
    [_secondText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_secondTitle.mas_bottom);
        make.height.mas_equalTo([GUIUtil fit:40]);
        make.left.mas_equalTo([GUIUtil fit:40]);
        _massecondTextWidth = make.width.mas_equalTo([GUIUtil fit:220]).priority(750);
        make.width.mas_equalTo([GUIUtil fit:304]).priority(700);
    }];
    [_secondRemark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_secondLine.mas_right).mas_offset([GUIUtil fit:-10]);
        make.centerY.equalTo(_secondText);
    }];
    [_secondVLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_secondRemark).mas_offset([GUIUtil fit:-10]);
        make.width.mas_equalTo([GUIUtil fitLine]);
        make.centerY.equalTo(_secondText);
        make.height.mas_equalTo([GUIUtil fit:20]);
        make.left.mas_lessThanOrEqualTo(SCREEN_WIDTH+[GUIUtil fit:-91]);
    }];
    [_secondLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_secondText.mas_bottom).mas_offset([GUIUtil fit:-3]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:66]);
        make.left.mas_equalTo([GUIUtil fit:33]);
        make.height.mas_equalTo(0.5);
    }];
    
    [_thirdTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:20]);
        make.top.equalTo(_secondLine.mas_bottom).mas_offset([GUIUtil fit:15]);
    }];
    [_thirdText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:40]);
        make.top.equalTo(_thirdTitle.mas_bottom);
        make.height.mas_equalTo([GUIUtil fit:40]);
        make.width.mas_equalTo([GUIUtil fit:220]);
    }];
    [_thirdRemark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_thirdLine.mas_right).mas_offset([GUIUtil fit:-10]);
        make.centerY.equalTo(_thirdText);
    }];
    [_thirdVLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_thirdRemark).mas_offset([GUIUtil fit:-10]);
        make.width.mas_equalTo([GUIUtil fitLine]);
        make.centerY.equalTo(_thirdText);
        make.height.mas_equalTo([GUIUtil fit:20]);
        make.left.mas_lessThanOrEqualTo(SCREEN_WIDTH+[GUIUtil fit:-91]);
    }];
    [_thirdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_thirdText.mas_bottom).mas_offset([GUIUtil fit:-3]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:66]);
        make.left.mas_equalTo([GUIUtil fit:33]);
        make.height.mas_equalTo(0.5);
    }];
    
    
    
    [_nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        _masNextBtnTopThird=make.top.equalTo(_thirdLine.mas_bottom).mas_offset([GUIUtil fit:40]).priority(750);
        _masNextBtnTopSecond=make.top.equalTo(_secondLine.mas_bottom).mas_offset([GUIUtil fit:40]).priority(650);
        make.top.equalTo(_errorLabel.mas_bottom).mas_offset([GUIUtil fit:16]).priority(600);
        make.left.mas_equalTo([GUIUtil fit:33]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:66]);
        make.height.mas_equalTo([GUIUtil fit:44]);
        make.bottom.mas_equalTo([GUIUtil fit:-60]);
    }];
    
    [_errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        self.masErrorTop = make.top.equalTo(self.thirdLine.mas_bottom).mas_offset([GUIUtil fit:10]).priority(750);
        make.top.equalTo(self.secondLine.mas_bottom).mas_offset([GUIUtil fit:10]).priority(500);
        make.left.mas_equalTo([GUIUtil fit:20]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:66]);
    }];
    [_remarkView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        _masRemarkTop = make.top.mas_equalTo(_navView.mas_bottom).priority(750);
        make.top.equalTo(_nextBtn.mas_bottom).mas_offset([GUIUtil fit:15]).priority(500);
    }];
}

#pragma mark - Action

- (void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)closeAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)nextAction:(UIButton *)btn{
    WEAK_SELF;
    _nextBtn.enabled = NO;
    NSString *errorText = @"";
    switch (_type) {
        case BindTypeVaildPhone:
        {
            if ([NDataUtil isMobilePhone:_firstText.text]==NO) {
                errorText = @"手机号输入错误";
            }else if ([NDataUtil isNumber:_secondText.text]==NO||_secondText.text.length!=4) {
                errorText = @"验证码错误";
            }else{
                
                
            }
        }
            break;
        case BindTypeAlterPhone:{
            if ([NDataUtil isMobilePhone:_firstText.text]==NO) {
                errorText = @"手机号输入错误";
            }else if ([NDataUtil isNumber:_secondText.text]||_secondText.text.length!=4) {
                errorText = @"验证码错误";
            }else{
                
            }
        }
            break;
        case BindTypeAddPhone:{
            if ([NDataUtil isMobilePhone:_firstText.text]==NO) {
                errorText = @"手机号格式错误";
            }else if ([NDataUtil isNumber:_secondText.text]||_secondText.text.length!=4||[NDataUtil isNumber:_thirdText.text]==NO||_thirdText.text.length!=4){
                errorText = @"验证码格式错误";
            }
           
        }
            break;
        case BindTypeAddEmail:{
            
        }
            break;
        case BindTypeSetFundPwd:
        case BindTypeAlterFundPwd:
        {
           
            
        }
            break;
        case BindTypeIdAuth:{
            if (_firstText.text.length<=0) {
                errorText=CFDLocalizedString(@"请输入真实姓名");
            }else if (_secondText.text.length<=0){
                errorText=CFDLocalizedString(@"请输入身份证号");
            }else{
                weakSelf.nextBtn.enabled = NO;
                [DCService postaddidcard:_secondText.text name:_firstText.text success:^(id data) {
                    weakSelf.nextBtn.enabled = YES;
                    if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
                        [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:@""]];
                        [UserModel sharedInstance].isLoaded=NO;
                        [weakSelf backAction];
                        if (weakSelf.completeHander) {
                            weakSelf.completeHander(nil);
                        }
                    }else{
                        weakSelf.errorLabel.hidden = YES;
                        [weakSelf.masNextBtnTopSecond activate];
                        weakSelf.errorLabel.text = @"";
                        QZHCheckIDStatusVC *statusVC = [QZHCheckIDStatusVC new];
                        statusVC.ststus = QZHCheckIDFailure;
                        statusVC.info   = [NDataUtil stringWith:data[@"info"] valid:@"操作成功"];
                        [GJumpUtil pushVC:statusVC animated:YES];
                    }
                } failure:^(NSError *error) {
                    weakSelf.errorLabel.hidden = YES;
                    [weakSelf.masNextBtnTopSecond activate];
                    weakSelf.errorLabel.text = @"";
                    weakSelf.nextBtn.enabled = YES;
                }];
            }
        }
            break;
        case BindTypeBank:{
            if (_firstText.text.length<=0) {
                errorText=CFDLocalizedString(@"请输入银行卡号");
            }else if (_secondText.text.length<=0){
                errorText=CFDLocalizedString(@"请输入银行名称");
            }else{
                weakSelf.nextBtn.enabled = NO;
                [DCService postaddbank:@"USDT" banktypename:_secondText.text bankaccount:_firstText.text success:^(id data) {
                    weakSelf.nextBtn.enabled = YES;
                    if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
                        [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:@"操作成功"]];
                        [UserModel sharedInstance].isLoaded=NO;
                        [weakSelf backAction];
                        if (weakSelf.completeHander) {
                            weakSelf.completeHander(nil);
                        }
                    }else{
                        weakSelf.errorLabel.hidden = YES;
                        [weakSelf.masNextBtnTopSecond activate];
                        weakSelf.errorLabel.text = @"";
                        [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
                    }
                } failure:^(NSError *error) {
                    weakSelf.errorLabel.hidden = YES;
                    [weakSelf.masNextBtnTopSecond activate];
                    weakSelf.errorLabel.text = @"";
                    weakSelf.nextBtn.enabled = YES;
                    [HUDUtil showInfo:[FTConfig webTips]];
                }];
            }
        }
            break;
        case BindTypeAddAddress:{
            if (_firstText.text.length<=0) {
                errorText=@"请输入地址";
            }else if (_secondText.text.length<=0){
                errorText=@"请填写名称";
            }else{
               
            }
        }
        default:
            break;
    }
    if (errorText.length>0) {
        _errorLabel.hidden = NO;
        _errorLabel.text = errorText;
        [_masNextBtnTopSecond deactivate];
        _nextBtn.enabled = YES;
    }
}

- (void)checkVaildPhoneCode:(NSString *)mobile code:(NSString *)code smsType:(int)smsType successHander:(dispatch_block_t)hander{
    
}

- (void)checkVaildEmailCode:(NSString *)email code:(NSString *)code smsType:(NSInteger)smsType successHander:(dispatch_block_t)hander{
    
}

- (void)showPwdAction:(UIButton *)btn{
    btn.selected = !btn.isSelected;
    if (btn.tag == 1213+1) {
        _firstText.secureTextEntry = !btn.selected;
    }else if (btn.tag == 1213+2){
        _secondText.secureTextEntry = !btn.selected;
    }
}

- (void)hidenKeyboard{
    [self.view endEditing:YES];
    [self.secondText resignFirstResponder];
    [self.thirdText resignFirstResponder];
    [self.firstText resignFirstResponder];
}



#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - UIGestureRecognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    BOOL flag = _firstText.isFirstResponder || _secondText.isFirstResponder
    ||_thirdText.isFirstResponder;
    if (gestureRecognizer == _tap&&flag == NO) {
        return NO;
    }
    return YES;
}

#pragma mark - getter

- (UIView *)navView{
    if (!_navView) {
        _navView = [[UIView alloc] init];
        _navView.backgroundColor = [GColorUtil C6];
        [_navView addSubview:self.backBtn];
        [_navView addSubview:self.titleLabel];
        [_navView addSubview:self.navline];
        [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.centerY.mas_equalTo(STATUS_BAR_HEIGHT/2);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backBtn);
            make.centerX.mas_equalTo(0);
        }];
        [_navline mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo([GUIUtil fitLine]);
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
        [_backBtn g_clickEdgeWithTop:20 bottom:20 left:20 right:30];
    }
    return _backBtn;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [GColorUtil C2];
        _titleLabel.font = [GUIUtil fitBoldFont:16];
        _titleLabel.text = @"找回登录密码";
    }
    return _titleLabel;
}

- (UIView *)navline{
    if (!_navline) {
        _navline = [[UIView alloc] init];
        _navline.backgroundColor = [GColorUtil C7];
    }
    return _navline;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = YES;
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.alwaysBounceHorizontal = NO;
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

- (UILabel *)firstTitle{
    if (!_firstTitle) {
        _firstTitle = [[UILabel alloc] init];
        _firstTitle.textColor = [GColorUtil C2];
        _firstTitle.font = [GUIUtil fitFont:12];
        _firstTitle.text = @"登陆密码";
    }
    return _firstTitle;
}

- (UITextField *)firstText{
    if (!_firstText) {
        _firstText = [[UITextField alloc] init];
        _firstText.textColor = [GColorUtil C2];
        _firstText.font = [GUIUtil fitFont:16];
        _firstText.returnKeyType = UIReturnKeyDone;
        _firstText.delegate = self;
        _firstText.autocorrectionType = UITextAutocorrectionTypeNo;
        _firstText.placeholder = @"请输入6~32位数字、字母或符号的组合";
        _firstText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_firstText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
    }
    return _firstText;
}

- (UIImageView *)firstIcon{
    if (!_firstIcon) {
        _firstIcon = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"dc_addAddress_icon"]];
        _firstIcon.hidden = YES;
    }
    return _firstIcon;
}

- (UIView *)firstLine{
    if (!_firstLine) {
        _firstLine = [[UIView alloc] init];
        _firstLine.backgroundColor = [GColorUtil C7];
    }
    return _firstLine;
}

- (UILabel *)secondTitle{
    if (!_secondTitle) {
        _secondTitle = [[UILabel alloc] init];
        _secondTitle.textColor = [GColorUtil C2];
        _secondTitle.font = [GUIUtil fitFont:12];
        _secondTitle.text = @"再次输入";
    }
    return _secondTitle;
}

- (UITextField *)secondText{
    if (!_secondText) {
        _secondText = [[UITextField alloc] init];
        _secondText.textColor = [GColorUtil C2];
        _secondText.font = [GUIUtil fitFont:16];
        _secondText.returnKeyType = UIReturnKeyDone;
        _secondText.delegate = self;
        _secondText.autocorrectionType = UITextAutocorrectionTypeNo;
        _secondText.placeholder = @"请输入6~32位数字、字母或符号的组合";
        _secondText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_secondText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
    }
    return _secondText;
}

- (UILabel *)secondRemark{
    if (!_secondRemark) {
        _secondRemark = [[UILabel alloc] init];
        _secondRemark.text = @"发送验证码";
        _secondRemark.font =[GUIUtil fitFont:16];
        _secondRemark.textColor = [GColorUtil C3];
    }
    return _secondRemark;
}

- (UIView *)secondVLine{
    if (!_secondVLine) {
        _secondVLine = [[UIView alloc] init];
        _secondVLine.backgroundColor = UIColorHex(0xf0f0f0);
    }
    return _secondVLine;
}

- (UIView *)secondLine{
    if (!_secondLine) {
        _secondLine = [[UIView alloc] init];
        _secondLine.backgroundColor = [GColorUtil C7];
    }
    return _secondLine;
}

- (UILabel *)thirdTitle{
    if (!_thirdTitle) {
        _thirdTitle = [[UILabel alloc] init];
        _thirdTitle.textColor = [GColorUtil C2];
        _thirdTitle.font = [GUIUtil fitFont:12];
        _thirdTitle.text = @"短信验证码";
    }
    return _thirdTitle;
}

- (UITextField *)thirdText{
    if (!_thirdText) {
        _thirdText = [[UITextField alloc] init];
        _thirdText.textColor = [GColorUtil C2];
        _thirdText.font = [GUIUtil fitFont:16];
        _thirdText.returnKeyType = UIReturnKeyDone;
        _thirdText.delegate = self;
        _thirdText.keyboardType = UIKeyboardTypeNumberPad;
        _thirdText.autocorrectionType = UITextAutocorrectionTypeNo;
        _thirdText.placeholder = @"请输入短信验证码";
        _thirdText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_thirdText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C4_ColorType]}];
    }
    return _thirdText;
}

- (UILabel *)thirdRemark{
    if (!_thirdRemark) {
        _thirdRemark = [[UILabel alloc] init];
        _thirdRemark.text = @"发送验证码";
        _thirdRemark.font =[GUIUtil fitFont:16];
        _thirdRemark.textColor = [GColorUtil C3];
    }
    return _thirdRemark;
}

- (UIView *)thirdVLine{
    if (!_thirdVLine) {
        _thirdVLine = [[UIView alloc] init];
        _thirdVLine.backgroundColor = UIColorHex(0xf0f0f0);
    }
    return _thirdVLine;
}

- (UIView *)thirdLine{
    if (!_thirdLine) {
        _thirdLine = [[UIView alloc] init];
        _thirdLine.backgroundColor = [GColorUtil C7];
        
    }
    return _thirdLine;
}

- (UIView *)remarkView{
    if (!_remarkView) {
        _remarkView = [[UIView alloc] init];
        _remarkView.hidden = YES;
        [_remarkView addSubview:self.remarkLabel];
        [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.top.mas_equalTo([GUIUtil fit:6]);
            make.width.mas_equalTo([GUIUtil fit:-30]+SCREEN_WIDTH);
            make.right.mas_equalTo([GUIUtil fit:-15]);
            make.bottom.mas_equalTo([GUIUtil fit:-6]);
        }];
    }
    return _remarkView;
}

- (UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.textColor = [GColorUtil C13];
        _remarkLabel.font = [GUIUtil fitFont:11];
        _remarkLabel.numberOfLines = 0;
    }
    return _remarkLabel;
}

- (UILabel *)errorLabel{
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.textColor = [GColorUtil C14];
        _errorLabel.font = [GUIUtil fitFont:12];
        _errorLabel.hidden = YES;
        _errorLabel.numberOfLines = 0;
        _errorLabel.textAlignment = NSTextAlignmentLeft;
        _errorLabel.preferredMaxLayoutWidth = SCREEN_WIDTH-[GUIUtil fit:60];
    }
    
    return _errorLabel;
}

- (UIButton *)nextBtn{
    if (!_nextBtn) {
        _nextBtn = [[UIButton alloc] init];
        [_nextBtn setTitle:@"登录" forState:UIControlStateNormal];
        [_nextBtn setBackgroundImage:[UIImage imageWithColor:[GColorUtil C13] size:CGSizeMake(SCREEN_WIDTH-[GUIUtil fit:60], [GUIUtil fit:44])] forState:UIControlStateNormal];
        [_nextBtn setTitleColor:[GColorUtil C2_black] forState:UIControlStateNormal];
        _nextBtn.backgroundColor = [GColorUtil C13];
        _nextBtn.layer.cornerRadius = 5;
        _nextBtn.layer.masksToBounds = YES;
        [_nextBtn addTarget:self action:@selector(nextAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _nextBtn;
}

- (UIButton *)pwdShowBtn{
    
    UIButton *pwdShowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    pwdShowBtn.frame = CGRectMake(0, 0, 20, 20);
    [pwdShowBtn setImage:[GColorUtil imageNamed:@"dc_eye_close_icon"] forState:UIControlStateNormal];
    [pwdShowBtn setImage:[GColorUtil imageNamed:@"dc_eye_show_icon"] forState:UIControlStateSelected];
    [pwdShowBtn addTarget:self action:@selector(showPwdAction:) forControlEvents:UIControlEventTouchUpInside];
    return pwdShowBtn;
}


@end


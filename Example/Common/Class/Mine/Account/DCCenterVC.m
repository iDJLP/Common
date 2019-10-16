//
//  DCCenterVC.m
//  coinare_ftox
//
//  Created by ngw15 on 2018/8/17.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "DCCenterVC.h"
#import "DCForgetPwdVC.h"

@interface DCCenterVC ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UIImageView *accountImg;
@property (nonatomic,strong) UILabel *accountTitle;
@property (nonatomic,strong) UILabel *phoneTitle;
@property (nonatomic,strong) UILabel *phoneText;
@property (nonatomic,strong) UIButton *pwdBtn;
@property (nonatomic,strong) UIView *phoneLine;
@property (nonatomic,strong) UILabel *idTitle;
@property (nonatomic,strong) UILabel *idText;
@property (nonatomic,strong) UIButton *idBtn;
@property (nonatomic,strong) UIView *idLine;

@property (nonatomic,strong) UIImageView *bankImg;
@property (nonatomic,strong) UILabel *bankTitle;
@property (nonatomic,strong) UILabel *bankNumTitle;
@property (nonatomic,strong) UILabel *bankNumText;
@property (nonatomic,strong) UIView *bankNumLine;
@property (nonatomic,strong) UIButton *bankNumBtn;
@property (nonatomic,strong) UILabel *bankNameTitle;
@property (nonatomic,strong) UILabel *bankNameText;
@property (nonatomic,strong) UIView *bankNameLine;
@property (nonatomic,assign)BOOL isLoaded;
@end

@implementation DCCenterVC

+ (void)jumpTo{
    DCCenterVC *target = [DCCenterVC new];
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CFDLocalizedString(@"账户中心");
    [self setupUI];
    [self autoLayout];
    _scrollView.hidden = YES;
    [StateUtil show:self.view type:StateTypeProgress];
    WEAK_SELF;
    [GUIUtil refreshWithHeader:self.scrollView refresh:^{
        [weakSelf loadData];
    }];
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    self.view.backgroundColor = [GColorUtil C6];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.accountImg];
    [self.scrollView addSubview:self.accountTitle];
    [self.scrollView addSubview:self.phoneTitle];
    [self.scrollView addSubview:self.phoneText];
    [self.scrollView addSubview:self.pwdBtn];
    [self.scrollView addSubview:self.phoneLine];
    [self.scrollView addSubview:self.idTitle];
    [self.scrollView addSubview:self.idText];
    [self.scrollView addSubview:self.idBtn];
    [self.scrollView addSubview:self.idLine];
    
    [self.scrollView addSubview:self.bankImg];
    [self.scrollView addSubview:self.bankTitle];
    [self.scrollView addSubview:self.bankNumTitle];
    [self.scrollView addSubview:self.bankNumText];
    [self.scrollView addSubview:self.bankNumLine];
    [self.scrollView addSubview:self.bankNumBtn];
    [self.scrollView addSubview:self.bankNameTitle];
    [self.scrollView addSubview:self.bankNameText];
    [self.scrollView addSubview:self.bankNameLine];
}

- (void)autoLayout{
    CGFloat left = [GUIUtil fit:115];
    if ([[FTConfig sharedInstance].lang isEqualToString:@"en"]) {
        left = [GUIUtil fit:160];
    }
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    [_accountImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:24]);
        make.centerY.equalTo(self.accountTitle);
    }];
    [_accountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.accountImg.mas_right).mas_offset([GUIUtil fit:10]);
        make.top.mas_equalTo([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [_phoneTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:40]);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.height.mas_equalTo([GUIUtil fit:58]);
    }];
    [_phoneText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTitle);
        make.left.mas_equalTo(left);
        make.height.mas_equalTo([GUIUtil fit:58]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:115]);
    }];
    [_pwdBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneText);
        make.height.equalTo(self.phoneText);
        make.right.equalTo(self.view.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-20]);
    }];
    [_phoneLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.phoneTitle);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    [_idTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.phoneTitle.mas_bottom);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.height.mas_equalTo([GUIUtil fit:58]);
    }];
    [_idText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idTitle);
        make.left.mas_equalTo(left);
        make.height.mas_equalTo([GUIUtil fit:58]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:195]);
    }];
    [_idBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.idText);
        make.height.equalTo(self.idText);
        make.right.equalTo(self.view.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-20]);
    }];
    [_idLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.idTitle);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    
    [_bankImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:24]);
        make.centerY.equalTo(self.bankTitle);
    }];
    [_bankTitle mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.bankImg.mas_right).mas_offset([GUIUtil fit:10]);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.equalTo(self.idText.mas_bottom).mas_offset([GUIUtil fit:40]);
    }];
    [_bankNumTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankTitle.mas_bottom).mas_offset([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.height.mas_equalTo([GUIUtil fit:58]);
    }];
    [_bankNumText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNumTitle);
        make.left.mas_equalTo(left);
        make.height.mas_equalTo([GUIUtil fit:58]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:135]);
    }];
    [_bankNumBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNumText);
        make.height.equalTo(self.bankNumText);
        make.right.equalTo(self.view.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-20]);
    }];
    [_bankNumLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bankNumTitle);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    [_bankNameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNumLine.mas_bottom);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.height.mas_equalTo([GUIUtil fit:58]);
    }];
    [_bankNameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bankNameTitle);
        make.left.mas_equalTo(left);
        make.height.mas_equalTo([GUIUtil fit:58]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:195]);
    }];
    [_bankNameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.bankNameTitle);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
}

- (void)loadData{
    WEAK_SELF;
    [[UserModel sharedInstance] getUserIndex:^{
        weakSelf.isLoaded = YES;
        [StateUtil hide:weakSelf.view];
        [weakSelf.scrollView.mj_header endRefreshing];
        [weakSelf configVC];
    } failure:^{
        if (weakSelf.isLoaded==NO) {
            ReloadStateView *reloadView = (ReloadStateView *)[StateUtil show:weakSelf.view type:StateTypeReload];
            [reloadView setOnReload:^{
                [StateUtil hide:weakSelf.view];
                [weakSelf loadData];
            }];
        }else{
            [StateUtil hide:weakSelf.view];
        }
        [HUDUtil showInfo:[FTConfig webTips]];
        [weakSelf.scrollView.mj_header endRefreshing];
    }];
}

//MARK: - Getter

- (void)configVC{
    _scrollView.hidden = NO;
    if ([UserModel isAuthentic]) {
        _idBtn.hidden = YES;
        _idText.textColor = [GColorUtil C2];
        _idText.text = [UserModel sharedInstance].realName;
        _phoneText.textColor = [GColorUtil C2];
    }else{
        _idBtn.hidden = NO;
        _phoneText.textColor = [GColorUtil C3];
        _idText.textColor = [GColorUtil C3];
        _idText.text = CFDLocalizedString(@"未认证");
    }
    if ([UserModel isBindBankCard]) {
        _bankNumBtn.selected = YES;
        _bankNumText.textColor = [GColorUtil C2];
        _bankNumText.text = [UserModel sharedInstance].bankCard;
        _bankNameText.textColor = [GColorUtil C2];
        _bankNameText.text = [UserModel sharedInstance].bankName;
    }else{
        _bankNumBtn.selected = NO;
        _bankNumText.textColor = [GColorUtil C3];
        _bankNumText.text = CFDLocalizedString(@"未绑定");
        _bankNameText.textColor = [GColorUtil C3];
        _bankNameText.text = @"";
    }
}

- (void)bankAuthAction{
    if (_bankNumBtn.selected) {
        WEAK_SELF;
        [DCAlert showAlert:@"" detail:CFDLocalizedString(@"是否解绑银行卡") sureTitle:CFDLocalizedString(@"确定") sureHander:^{
            [weakSelf unBindBank];
        } cancelTitle:CFDLocalizedString(@"取消") cancelHander:^{
            
        }];
    }else{
        [[UserModel sharedInstance] getIsAuthentic:^(BOOL isAuthentic) {
            if (!isAuthentic) {
                [DCAlert showAlert:@"" detail:CFDLocalizedString(@"您还未进行身份认证，请先进行身份认证") sureTitle:CFDLocalizedString(@"确定") sureHander:^{
                    [CFDJumpUtil jumpToRealName];
                } cancelTitle:CFDLocalizedString(@"取消") cancelHander:^{
                    
                }];
            }else{
                [CFDJumpUtil jumpToBindBank];
            }
        }];
        
    }
}

- (void)unBindBank{
    [HUDUtil showProgress:@""];
    WEAK_SELF;
    [DCService postunbindbankwalletbankid:[UserModel sharedInstance].walletBankId currenttype:@"USDT" success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [HUDUtil showInfo:CFDLocalizedString(@"操作成功")];
            [weakSelf loadData];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
        
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

- (void)idAuthAction{
    [CFDJumpUtil jumpToRealName];
}

- (void)pwdAlertAction{
    [DCForgetPwdVC jumpTo:self successHander:^{
        
    }];
}

//MARK: - Getter

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = YES;
        scrollView.alwaysBounceVertical = YES;
        scrollView.alwaysBounceHorizontal = NO;
        scrollView.userInteractionEnabled = YES;
        scrollView.backgroundColor = [GColorUtil C6];
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _scrollView = scrollView;
    }
    return _scrollView;
}

- (UIImageView *)accountImg{
    if (!_accountImg) {
        _accountImg = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"my_account_a"]];
    }
    return _accountImg;
}
- (UILabel *)accountTitle{
    if(!_accountTitle){
        _accountTitle = [[UILabel alloc] init];
        _accountTitle.textColor = [GColorUtil C3];
        _accountTitle.font = [GUIUtil fitBoldFont:14];
        _accountTitle.text = CFDLocalizedString(@"账号信息");
    }
    return _accountTitle;
}

- (UILabel *)phoneTitle{
    if(!_phoneTitle){
        _phoneTitle = [[UILabel alloc] init];
        _phoneTitle.textColor = [GColorUtil C2];
        _phoneTitle.font = [GUIUtil fitFont:16];
        _phoneTitle.text = CFDLocalizedString(@"手机号");
    }
    return _phoneTitle;
}

- (UILabel *)phoneText{
    if(!_phoneText){
        _phoneText = [[UILabel alloc] init];
        _phoneText.textColor = [GColorUtil C3];
        _phoneText.font = [GUIUtil fitFont:16];
        NSMutableString *phone = [UserModel sharedInstance].mobilePhone.mutableCopy;
        if (phone.length==11) {
           [phone replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }else{
            phone=@"".mutableCopy;
        }
        _phoneText.text = phone;
    }
    return _phoneText;
}

- (UIButton *)pwdBtn{
    if (!_pwdBtn) {
        _pwdBtn = [[UIButton alloc] init];
        [_pwdBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        _pwdBtn.titleLabel.font = [GUIUtil fitFont:14];
        _pwdBtn.titleLabel.numberOfLines = 0;
        [_pwdBtn setTitle:CFDLocalizedString(@"修改密码") forState:UIControlStateNormal];
        _pwdBtn.titleLabel.contentMode = UIViewContentModeCenter;
        [_pwdBtn addTarget:self action:@selector(pwdAlertAction) forControlEvents:UIControlEventTouchUpInside];
        [_pwdBtn g_clickEdgeWithTop:0 bottom:0 left:15 right:15];
    }
    return _pwdBtn;
}

- (UIView *)phoneLine{
    if(!_phoneLine){
        _phoneLine = [[UIView alloc] init];
        _phoneLine.backgroundColor = [GColorUtil C7];
    }
    return _phoneLine;
}

- (UILabel *)idTitle{
    if(!_idTitle){
        _idTitle = [[UILabel alloc] init];
        _idTitle.textColor = [GColorUtil C2];
        _idTitle.font = [GUIUtil fitFont:16];
        _idTitle.text = CFDLocalizedString(@"实名认证");
    }
    return _idTitle;
}

- (UILabel *)idText{
    if(!_idText){
        _idText = [[UILabel alloc] init];
        _idText.textColor = [GColorUtil C3];
        _idText.font = [GUIUtil fitFont:16];
        _idText.text = CFDLocalizedString(@"未认证");
    }
    return _idText;
}

- (UIButton *)idBtn{
    if (!_idBtn) {
        _idBtn = [[UIButton alloc] init];
        [_idBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        _idBtn.titleLabel.font = [GUIUtil fitFont:14];
        [_idBtn setTitle:CFDLocalizedString(@"马上认证") forState:UIControlStateNormal];
        [_idBtn addTarget:self action:@selector(idAuthAction) forControlEvents:UIControlEventTouchUpInside];
        [_idBtn g_clickEdgeWithTop:0 bottom:0 left:15 right:15];
    }
    return _idBtn;
}

- (UIView *)idLine{
    if(!_idLine){
        _idLine = [[UIView alloc] init];
        _idLine.backgroundColor = [GColorUtil C7];
    }
    return _idLine;
}

- (UIImageView *)bankImg{
    if (!_bankImg) {
        _bankImg = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"my_account_bank"]];
    }
    return _bankImg;
}
- (UILabel *)bankTitle{
    if(!_bankTitle){
        _bankTitle = [[UILabel alloc] init];
        _bankTitle.textColor = [GColorUtil C3];
        _bankTitle.font = [GUIUtil fitFont:14];
        _bankTitle.text = CFDLocalizedString(@"收付款银行卡信息");
    }
    return _bankTitle;
}

- (UILabel *)bankNumTitle{
    if(!_bankNumTitle){
        _bankNumTitle = [[UILabel alloc] init];
        _bankNumTitle.textColor = [GColorUtil C2];
        _bankNumTitle.font = [GUIUtil fitFont:16];
        _bankNumTitle.text = CFDLocalizedString(@"尾号");
    }
    return _bankNumTitle;
}

- (UILabel *)bankNumText{
    if(!_bankNumText){
        _bankNumText = [[UILabel alloc] init];
        _bankNumText.textColor = [GColorUtil C3];
        _bankNumText.font = [GUIUtil fitFont:16];
        _bankNumText.text = CFDLocalizedString(@"未绑定");
    }
    return _bankNumText;
}

- (UIButton *)bankNumBtn{
    if (!_bankNumBtn) {
        _bankNumBtn = [[UIButton alloc] init];
        [_bankNumBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        _bankNumBtn.titleLabel.font = [GUIUtil fitFont:14];
        [_bankNumBtn setTitle:CFDLocalizedString(@"马上绑定") forState:UIControlStateNormal];
        [_bankNumBtn setTitle:CFDLocalizedString(@"解除绑定") forState:UIControlStateSelected];
        [_bankNumBtn addTarget:self action:@selector(bankAuthAction) forControlEvents:UIControlEventTouchUpInside];
        [_bankNumBtn g_clickEdgeWithTop:0 bottom:0 left:15 right:15];
    }
    return _bankNumBtn;
}

- (UIView *)bankNumLine{
    if(!_bankNumLine){
        _bankNumLine = [[UIView alloc] init];
        _bankNumLine.backgroundColor = [GColorUtil C7];
    }
    return _bankNumLine;
}

- (UILabel *)bankNameTitle{
    if(!_bankNameTitle){
        _bankNameTitle = [[UILabel alloc] init];
        _bankNameTitle.textColor = [GColorUtil C2];
        _bankNameTitle.font = [GUIUtil fitFont:16];
        _bankNameTitle.text = CFDLocalizedString(@"银行");
    }
    return _bankNameTitle;
}

- (UILabel *)bankNameText{
    if(!_bankNameText){
        _bankNameText = [[UILabel alloc] init];
        _bankNameText.textColor = [GColorUtil C2];
        _bankNameText.font = [GUIUtil fitFont:16];
    }
    return _bankNameText;
}

- (UIView *)bankNameLine{
    if(!_bankNameLine){
        _bankNameLine = [[UIView alloc] init];
        _bankNameLine.backgroundColor = [GColorUtil C7];
    }
    return _bankNameLine;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

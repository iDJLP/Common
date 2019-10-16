//
//  DCChargedView.m
//  ngw
//
//  Created by ngw15 on 2018/12/13.
//  Copyright © 2018 taojinzhe. All rights reserved.
//

#import "OTCDepositView.h"
#import "OtcTradeView.h"
#import "SectionView.h"
#import "FundRecordVC.h"
#import "CurrenttypeSelectedSheet.h"

@interface OTCDepositView ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong) UIView *varityView;
@property (nonatomic,strong) UILabel *varityTitle;
@property (nonatomic,strong) UILabel *varityText;
@property (nonatomic,strong) UIImageView *varityArrowImg;
@property (nonatomic,strong) UIView *toView;
@property (nonatomic,strong) UILabel *desTitle;
@property (nonatomic,strong) UIImageView *usdtImg;
@property (nonatomic,strong) UILabel *usdtTitle;
@property (nonatomic,strong) UITextField *usdtText;
@property (nonatomic,strong) UIView *usdtLine;
@property (nonatomic,strong) UIImageView *toImg;
@property (nonatomic,strong) UIImageView *cnyImg;
@property (nonatomic,strong) UILabel *cnyTitle;
@property (nonatomic,strong) UILabel *cnyText;

@property (nonatomic,strong) UIView *bankView;
@property (nonatomic,strong) UILabel *bankTitle;
@property (nonatomic,strong) UILabel *bankText;
@property (nonatomic,strong) UIImageView *bankArrow;
@property (nonatomic,strong) MASConstraint *masBankTextRight;

@property (nonatomic,strong) UILabel *remarkLabel;
@property (nonatomic,strong) UIButton *commitBtn;

@property (nonatomic,strong) UILabel *hisLabel;
@property (nonatomic,strong) UILabel *remainLabel;
@property (nonatomic,strong) OtcTradeView *tradeView;
@property (nonatomic,strong) UIButton *moreBtn;
@property (nonatomic,strong) UIView *spaceView;

@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,copy)NSString *rate;
@property (nonatomic,strong) NSDictionary *config;
@property (nonatomic,copy) NSString *minAmount;
@property (nonatomic,copy) NSString *maxAmount;
@property (nonatomic,assign) NSInteger remainTime;
@property (nonatomic,copy)NSString *h5payurl;
@end

@implementation OTCDepositView

- (void)dealloc{
    [self removeNotic];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self autoLayout];
        self.backgroundColor = [GColorUtil C6];
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
    [self addSubview:self.desTitle];
    [self addSubview:self.toView];
    [self addSubview:self.usdtImg];
    [self  addSubview:self.usdtTitle];
    [self  addSubview:self.usdtText];
    [self  addSubview:self.toImg];
    [self addSubview:self.cnyImg];
    [self  addSubview:self.cnyTitle];
    [self  addSubview:self.cnyText];
    
    [self  addSubview:self.bankView];
    [self  addSubview:self.bankTitle];
    [self  addSubview:self.bankText];
    [self addSubview:self.bankArrow];
    [self  addSubview:self.remarkLabel];
    [self  addSubview:self.usdtLine];
    [self  addSubview:self.commitBtn];
    [self  addSubview:self.hisLabel];
    [self  addSubview:self.remainLabel];
    [self  addSubview:self.moreBtn];
    [self addSubview:self.tradeView];
    [self  addSubview:self.spaceView];
    
    //给这个UITextField的对象添加UIToolbar
    [_usdtText addToolbar];
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
    [_desTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.top.equalTo(self.varityTitle.mas_bottom);
    }];
    [_toView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.desTitle.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:30]);
    }];
    
    [_usdtImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:30]);
        make.centerY.equalTo(self.usdtTitle);
        make.size.mas_equalTo([GUIUtil fitWidth:25 height:25]);
    }];
    [_usdtTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usdtImg.mas_right).mas_offset([GUIUtil  fit:15]);
        make.top.equalTo(self.desTitle.mas_bottom).mas_offset([GUIUtil  fit:10]);
        make.height.mas_equalTo([GUIUtil fit:65]);
    }];
    [_usdtText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-30]);
        make.width.mas_equalTo([GUIUtil  fit:200]);
        make.centerY.equalTo(self.usdtTitle);
    }];
    [_toImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.usdtTitle.mas_bottom).mas_offset([GUIUtil  fit:0]);
        make.centerX.mas_equalTo(0);
    }];
    [_cnyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:30]);
        make.centerY.equalTo(self.cnyTitle);
    }];
    [_cnyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cnyImg.mas_right).mas_offset([GUIUtil  fit:15]);
        make.top.equalTo(self.usdtTitle.mas_bottom).mas_offset([GUIUtil  fit:0]);
        make.height.mas_equalTo([GUIUtil fit:65]);
        make.bottom.equalTo(self.toView).mas_offset([GUIUtil fit:0]);
    }];
    [_cnyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-30]);
        make.centerY.equalTo(self.cnyTitle);
    }];
    [_usdtLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-15]);
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.top.equalTo(self.toView.mas_bottom).mas_offset([GUIUtil  fit:0]);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:30]);
        make.top.equalTo(self.toView.mas_bottom).mas_offset([GUIUtil  fit:0]);
        make.height.mas_equalTo([GUIUtil  fit:65]);
    }];
    [_bankTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:30]);
        make.centerY.equalTo(self.bankView);
    }];
    [_bankText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bankView);
        make.right.equalTo(self.bankArrow.mas_left).mas_offset([GUIUtil fit:-5]).priority(750);
        self.masBankTextRight = make.right.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-30]);
    }];
    [_bankArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.bankView);
        make.right.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-30]);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:18]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil  fit:18]*2);
        make.top.equalTo(self.bankView.mas_bottom).mas_offset([GUIUtil  fit:20]);
    }];
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil  fit:15]*2);
        make.top.equalTo(self.remarkLabel.mas_bottom).mas_offset([GUIUtil  fit:40]);
        make.height.mas_equalTo([GUIUtil  fit:45]);
    }];
    [_hisLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.top.equalTo(self.commitBtn.mas_bottom).mas_offset([GUIUtil  fit:25]);
    }];
    [_remainLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).mas_equalTo(SCREEN_WIDTH+[GUIUtil fit:-15]);
        make.centerY.equalTo(self.hisLabel);
    }];
    [_moreBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).mas_equalTo(SCREEN_WIDTH+[GUIUtil fit:-15]);
        make.centerY.equalTo(self.hisLabel);
    }];
    [_tradeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.hisLabel.mas_bottom).mas_offset([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.equalTo(self.mas_left).mas_equalTo(SCREEN_WIDTH+[GUIUtil fit:-15]);
    }];
    [_spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.equalTo(self.tradeView.mas_bottom);
        make.bottom.mas_equalTo(-IPHONE_X_BOTTOM_HEIGHT-1).priority(500);
    }];
}

- (void)loadData{
    NSString *type = _type.copy;
    WEAK_SELF;
    [DCService getAvailData:type isOTC:YES priceArrow:YES success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]&&[type isEqualToString:weakSelf.type]) {
            [weakSelf configInfo:data[@"data"]];
        }
        [HUDUtil hide];
    } failure:^(NSError *error) {
        [HUDUtil hide];
    }];
}

- (void)configInfo:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    _maxAmount = [NDataUtil stringWith:dict[@"maxWarnValue"]];
    _minAmount = [NDataUtil stringWith:dict[@"minWarnValue"]];
    _rate=[NDataUtil stringWith:dict[@"exchangetrade"]];
    _desTitle.text = [NSString stringWithFormat:@"%@¥%@/%@",CFDLocalizedString(@"汇率："),_rate,_type];
    _usdtText.placeholder = [NSString stringWithFormat:@"%@%@%@",CFDLocalizedString(@"输入买入数量，最少"),_minAmount,_type];
    _usdtText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_usdtText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType]}];
    [self currentyChanged];
}

//MARK: - Action

- (void)willAppear{
    [self configVC:@{}];
    [self startTimer];
    [self loadData];
    [self loadTradeOrder];
}

- (void)loadTradeOrder{
    WEAK_SELF;
    [DCService getpayOrder:YES success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            if ([NDataUtil stringWith:data[@"logid"]].length<=0) {
                NoDataStateView *stateView = (NoDataStateView *)[StateUtil show:weakSelf.tradeView type:StateTypeNodata];
                [stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self.tradeView);
                   make.bottom.equalTo(self.tradeView).mas_offset([GUIUtil fit:-44-15]); make.left.mas_equalTo([GUIUtil fit:-15]);
                    make.right.mas_equalTo([GUIUtil fit:15]);
                }];
                stateView.title.text = CFDLocalizedString(@"暂无交易订单");
                weakSelf.tradeView.backgroundColor = [GColorUtil C6]; weakSelf.remainLabel.hidden = YES;
            }else{
                NSInteger status = [NDataUtil integerWith:data[@"paystatus"]];
                if (status==2) {
                    weakSelf.remainLabel.hidden = YES;
                }else{
                    weakSelf.remainLabel.hidden = NO;
                    weakSelf.remainTime = [NDataUtil integerWith:data[@"validTime"]];
                    [weakSelf configRemainTime];
                }
                weakSelf.tradeView.backgroundColor = [GColorUtil C15];
                [weakSelf.tradeView configView:[NDataUtil dictWith:data]];
                [StateUtil hide:weakSelf.tradeView];
            }
            return ;
        }
        ReloadStateView *state = (ReloadStateView *)[StateUtil show:weakSelf.tradeView type:StateTypeReload];
        state.onReload = ^{
            [weakSelf loadTradeOrder];
        };
        [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
        ReloadStateView *state = (ReloadStateView *)[StateUtil show:weakSelf.tradeView type:StateTypeReload];
        state.onReload = ^{
            [weakSelf loadTradeOrder];
        };
    }];
}

- (void)autoLoadData{
    WEAK_SELF;
    if (_config.count<=0) {
        [HUDUtil hide];
        return;
    }
    NSString *type = _type.copy;
    [DCService getpaymentRate:[NDataUtil stringWith:_config[@"payid"]] priceCoin:type priceArrow:@"BUY" success:^(id data) {
        [HUDUtil hide];
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]&&type==weakSelf.type){
            NSDictionary *dic = data[@"data"];
            weakSelf.rate = [NDataUtil stringWith:dic[@"exchangerate"] valid:@""];
            [weakSelf autoConfig];
        }
    } failure:^(NSError *error) {
        [HUDUtil hide];
    }];
}

- (void)autoConfig{
    _desTitle.text = [NSString stringWithFormat:@"%@¥%@/%@",CFDLocalizedString(@"汇率："),_rate,_type];
    NSInteger count = [_usdtText.text floatValue]*[_rate floatValue]*100+0.5;
    NSString *cny = [NSString stringWithFormat:@"%.2f",count/100.0];
    _cnyText.text = cny;
}

- (void)configVC:(NSDictionary *)config{
    WEAK_SELF;
    [[UserModel sharedInstance] getIsAuthentic:^(BOOL isAuthentic) {
        if (isAuthentic) {
            weakSelf.bankTitle.text =CFDLocalizedString(@"实名认证:");
            weakSelf.bankText.text = [UserModel sharedInstance].realName;
            weakSelf.bankArrow.hidden = YES;
            [weakSelf.masBankTextRight activate];
            weakSelf.bankText.textColor = [GColorUtil C2];
        }else{
            weakSelf.bankTitle.text =CFDLocalizedString(@"实名认证:");
            weakSelf.bankText.text = CFDLocalizedString(@"马上实名认证");
            weakSelf.bankArrow.hidden = NO;
            [weakSelf.masBankTextRight deactivate];
            weakSelf.bankText.textColor = [GColorUtil C13];
        }
    }];
    _config = config;
}

- (void)configRemainTime{
    WEAK_SELF;
    weakSelf.remainTime++;
    [NTimeUtil startTimer:@"OTCDepositView_RemainTime" interval:1 repeats:YES action:^{
        weakSelf.remainTime--;
        weakSelf.remainLabel.text = [NSString stringWithFormat:CFDLocalizedString(@"倒计时：%ld分%ld秒"),(NSInteger)weakSelf.remainTime/60,(NSInteger)weakSelf.remainTime%60];
        
        if (weakSelf.remainTime==0) {
            [NTimeUtil stopTimer:@"OTCDepositView_RemainTime"];
            [weakSelf loadTradeOrder];
            weakSelf.remainLabel.hidden = YES;
        }
    }];
}

- (void)startTimer{
    WEAK_SELF;
    [NTimeUtil startTimer:@"DepositVC" interval:3 repeats:YES action:^{
        [weakSelf autoLoadData];
    }];
}

- (void)hidenKeyboard{
    [_usdtText resignFirstResponder];
}

- (void)usdtTextChanged{
    if (_usdtText.text.length>0) {
        _usdtText.font = [GUIUtil fitFont:20];
    }else{
        _usdtText.font = [GUIUtil fitFont:14];
    }
    NSInteger count = [_usdtText.text floatValue]*[_rate floatValue]*100+0.5;
    NSString *cny = [NSString stringWithFormat:@"%.2f",count/100.0];
    _cnyText.text = cny;
}

- (void)commitAction{
    if (_rate.floatValue<=0) {
        [HUDUtil showInfo:CFDLocalizedString(@"汇率有误，请刷新重试")];
        return;
    }
    if ([GUIUtil compareFloat:_usdtText.text with:_minAmount]==NSOrderedAscending) {
        [HUDUtil showInfo:[NSString stringWithFormat:@"%@%@%@",CFDLocalizedString(@"最小买入金额不能小于"),_minAmount,_type]];
        return;
    }
    if ([GUIUtil compareFloat:_usdtText.text with:_maxAmount]==NSOrderedDescending) {
        [HUDUtil showInfo:[NSString stringWithFormat:@"%@%@%@",CFDLocalizedString(@"最大买入金额不能大于"),_maxAmount,_type]];
        return;
    }
    WEAK_SELF;
    [[UserModel sharedInstance] getIsAuthentic:^(BOOL isAuthentic) {
        if (isAuthentic) {
            [weakSelf commitHander];
        }else{
            [DCAlert showAlert:@"" detail:CFDLocalizedString(@"您还未进行身份认证，请先进行身份认证") sureTitle:CFDLocalizedString(@"确定") sureHander:^{
                [CFDJumpUtil jumpToRealName];
            } cancelTitle:CFDLocalizedString(@"取消") cancelHander:^{
                
            }];
        }
    }];
}

- (void)commitHander{
    NSString *userToken=[UserModel userToken];
    FTConfig *conf=[FTConfig sharedInstance];
    NSString* param=[NSString stringWithFormat:@"version=%@&packtype=%@&usertoken=%@",
                     conf.version,conf.packType,userToken];
    param = [param stringByAppendingFormat:@"&payid=%@",[NDataUtil stringWith:_config[@"payid"]]];
    NSString *amount = _usdtText.text;
    NSString *amountrmb = _cnyText.text;
    param = [param stringByAppendingFormat:@"&amount=%@&exchangerate=%@&amountrmb=%@&showCoinCode=%@",amount,_rate,amountrmb,_type];
    NSString *link = [NSString stringWithFormat:@"%@?%@",[NDataUtil stringWith:_config[@"h5payurl"]],param];
    [WebVC jumpTo:CFDLocalizedString(@"充值") link:link animated:YES];
}

- (void)moreAction{
    [FundRecordVC jumpTo];
}

- (void)addNotic{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

- (void)removeNotic{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)appDidBecomeActive{
    [self loadTradeOrder];
}

- (void)keyboardWillShow:(NSNotification *)notic{
    if (_usdtText.isFirstResponder) {
        CGFloat textFieldBottom = CGRectGetMaxY(self.usdtText.frame);
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



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSInteger _decLength = 8;
    if ([_type isEqualToString:@"USDT"]) {
        _decLength = 2;
    }
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

- (void)currentyChanged{
    _varityText.text =
    _usdtTitle.text = _type;
    WEAK_SELF;
    [CurrenttypeSelectedSheet loadVarityLogo:_type success:^(NSString * _Nonnull imgName) {
        [GUIUtil imageViewWithUrl:weakSelf.usdtImg url:imgName];
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
                weakSelf.desTitle.text = [NSString stringWithFormat:@"%@¥--/%@",CFDLocalizedString(@"汇率："),weakSelf.type];
                weakSelf.usdtText.placeholder = [NSString stringWithFormat:@"%@--%@",CFDLocalizedString(@"输入买入数量，最少"),weakSelf.type];
                weakSelf.usdtText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:weakSelf.usdtText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType]}];
                weakSelf.rate = @"";
                weakSelf.usdtText.font = [GUIUtil fitFont:14];
                weakSelf.usdtText.text = @"";
                [HUDUtil showProgress:@""];
                [weakSelf currentyChanged];
                [weakSelf autoLoadData];
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
        _varityText.text = @"USDT";
    }
    return _varityText;
}

- (UIImageView *)varityArrowImg{
    if (!_varityArrowImg) {
        _varityArrowImg=[[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"market_icon_under_blue_down"]];
    }
    return _varityArrowImg;
}

- (UIView *)toView{
    if (!_toView) {
        _toView = [[UIView alloc] init];
        _toView.backgroundColor = [GColorUtil C16];
        _toView.layer.cornerRadius = 4;
        _toView.layer.masksToBounds = YES;
    }
    return _toView;
}
- (UILabel *)desTitle{
    if(!_desTitle){
        _desTitle = [[UILabel alloc] init];
        _desTitle.textColor = [GColorUtil C2];
        _desTitle.font = [GUIUtil  fitBoldFont:14];
    }
    return _desTitle;
}

- (UIImageView *)usdtImg{
    if (!_usdtImg) {
        _usdtImg=[[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"mina_icon_usdt_blue"]];
    }
    return _usdtImg;
}

- (UILabel *)usdtTitle{
    if(!_usdtTitle){
        _usdtTitle = [[UILabel alloc] init];
        _usdtTitle.textColor = [GColorUtil C2];
        _usdtTitle.font = [GUIUtil  fitBoldFont:16];
        _usdtTitle.text = @"USDT";
    }
    return _usdtTitle;
}

- (UITextField *)usdtText{
    if(!_usdtText){
        _usdtText = [[UITextField alloc] init];
        _usdtText.textColor = [GColorUtil C2];
        _usdtText.font = [GUIUtil  fitFont:14];
        _usdtText.keyboardType = UIKeyboardTypeDecimalPad;
        _usdtText.textAlignment = NSTextAlignmentRight;
        _usdtText.placeholder = @" ";
        _usdtText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_usdtText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType]}];
        WEAK_SELF;
        [_usdtText addTarget:weakSelf action:@selector(usdtTextChanged) forControlEvents:UIControlEventEditingChanged];
        _usdtText.delegate = self;
        [_usdtText addToolbar];
    }
    return _usdtText;
}
- (UIView *)usdtLine{
    if (!_usdtLine) {
        _usdtLine = [[UIView alloc] init];
        _usdtLine.backgroundColor = [GColorUtil C7];
    }
    return _usdtLine;
}
- (UIImageView *)toImg{
    if (!_toImg) {
        _toImg = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"mine_line_long"]];
    }
    return _toImg;
}
- (UIImageView *)cnyImg{
    if (!_cnyImg) {
        _cnyImg=[[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"mina_icon_cny"]];
    }
    return _cnyImg;
}
- (UILabel *)cnyTitle{
    if(!_cnyTitle){
        _cnyTitle = [[UILabel alloc] init];
        _cnyTitle.textColor = [GColorUtil C2];
        _cnyTitle.font = [GUIUtil  fitBoldFont:16];
        _cnyTitle.text = @"CNY";
    }
    return _cnyTitle;
}
- (UILabel *)cnyText{
    if(!_cnyText){
        _cnyText = [[UILabel alloc] init];
        _cnyText.textColor = [GColorUtil C2];
        _cnyText.font = [GUIUtil  fitFont:14];
        _cnyText.text = @"0.00";
        _cnyText.textAlignment = NSTextAlignmentRight;
    }
    return _cnyText;
}

- (UIView *)bankView{
    if (!_bankView) {
        _bankView = [[UIView alloc] init];
        _bankView.backgroundColor = [GColorUtil C16];
        _bankView.layer.cornerRadius = 4;
        _bankView.layer.masksToBounds = YES;
        [_bankView g_clickBlock:^(UITapGestureRecognizer *tap) {
            [[UserModel sharedInstance] getIsAuthentic:^(BOOL isAuthentic) {
                if (!isAuthentic) {
                    [CFDJumpUtil jumpToRealName];
                }
            }];
        }];
    }
    return _bankView;
}
- (UILabel *)bankTitle{
    if(!_bankTitle){
        _bankTitle = [[UILabel alloc] init];
        _bankTitle.textColor = [GColorUtil C2];
        _bankTitle.font = [GUIUtil  fitFont:16];
    }
    return _bankTitle;
}
- (UILabel *)bankText{
    if(!_bankText){
        _bankText = [[UILabel alloc] init];
        _bankText.textColor = [GColorUtil C13];
        _bankText.font = [GUIUtil  fitFont:16];
    }
    return _bankText;
}
- (UIImageView *)bankArrow{
    if (!_bankArrow) {
        _bankArrow = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"public_icon_more"]];
    }
    return _bankArrow;
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
        [_commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}
- (UILabel *)hisLabel{
    if(!_hisLabel){
        _hisLabel = [[UILabel alloc] init];
        _hisLabel.textColor = [GColorUtil C2];
        _hisLabel.font = [GUIUtil  fitFont:14];
        _hisLabel.text = CFDLocalizedString(@"交易中OTC订单");
    }
    return _hisLabel;
}

- (UILabel *)remainLabel{
    if(!_remainLabel){
        _remainLabel = [[UILabel alloc] init];
        _remainLabel.textColor = [GColorUtil C13];
        _remainLabel.font = [GUIUtil  fitFont:12];
    }
    return _remainLabel;
}

- (UIButton *)moreBtn{
    if (!_moreBtn) {
        _moreBtn = [[UIButton alloc] init];
        _moreBtn.backgroundColor = [UIColor clearColor];
        _moreBtn.titleLabel.font = [GUIUtil  fitFont:12];
        [_moreBtn setTitle:CFDLocalizedString(@"查看更多记录") forState:UIControlStateNormal];
        [_moreBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        [_moreBtn addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
        _moreBtn.hidden = YES;
    }
    return _moreBtn;
}

- (OtcTradeView *)tradeView{
    if (!_tradeView) {
        _tradeView = [[OtcTradeView alloc] init];
        WEAK_SELF;
        _tradeView.refreshData = ^{
            [weakSelf loadTradeOrder];
        };
    }
    return _tradeView;
}

- (UIView *)spaceView{
    if (!_spaceView) {
        _spaceView = [[UIView alloc] init];
        _spaceView.backgroundColor = [UIColor clearColor];
    }
    return _spaceView;
}

@end

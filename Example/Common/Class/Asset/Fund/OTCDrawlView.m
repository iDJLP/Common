//
//  OTCDrawlView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/28.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "OTCDrawlView.h"
#import "AuthAlert.h"
#import "PwdAlert.h"
#import "CurrenttypeSelectedSheet.h"

@interface OTCDrawlView ()<UITextFieldDelegate,UIGestureRecognizerDelegate>

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

@property (nonatomic,strong) UIView *toView;
@property (nonatomic,strong) UILabel *desTitle;
@property (nonatomic,strong) UIImageView *usdtImg;
@property (nonatomic,strong) UILabel *usdtTitle;
@property (nonatomic,strong) UITextField *usdtText;
@property (nonatomic,strong) UIButton *usdtBtn;
@property (nonatomic,strong) UIImageView *toImg;
@property (nonatomic,strong) UIImageView *cnyImg;
@property (nonatomic,strong) UILabel *cnyTitle;
@property (nonatomic,strong) UILabel *cnyText;
@property (nonatomic,strong) UIView *toLine;

@property (nonatomic,strong) UIView *nameView;
@property (nonatomic,strong) UILabel *nameTitle;
@property (nonatomic,strong) UILabel *nameText;
@property (nonatomic,strong) UIImageView *nameArrow;
@property (nonatomic,strong) UIView *nameLine;
@property (nonatomic,strong) MASConstraint *masNameTextRight;

@property (nonatomic,strong) UIView *bankView;
@property (nonatomic,strong) UILabel *bankTitle;
@property (nonatomic,strong) UILabel *bankText;
@property (nonatomic,strong) UIImageView *bankArrow;
@property (nonatomic,strong) MASConstraint *masBankTextRight;

@property (nonatomic,strong) UILabel *remarkLabel;
@property (nonatomic,strong) UIButton *commitBtn;

@property (nonatomic,strong) UIView *spaceView;

@property (nonatomic,strong) UITapGestureRecognizer *tap;
@property (nonatomic,copy)NSString *rate;
@property (nonatomic,strong) NSDictionary *config;
@property (nonatomic,copy) NSString *maxAmount;
@property (nonatomic,copy) NSString *minAmount;
@property (nonatomic,assign) BOOL isLoaded;

@end

@implementation OTCDrawlView

- (void)dealloc{
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
    
    [self addSubview:self.toView];
    [self addSubview:self.desTitle];
    [self addSubview:self.usdtImg];
    [self  addSubview:self.usdtTitle];
    [self  addSubview:self.usdtText];
    [self addSubview:self.usdtBtn];
    [self  addSubview:self.toImg];
    [self addSubview:self.cnyImg];
    [self  addSubview:self.cnyTitle];
    [self  addSubview:self.cnyText];
    [self addSubview:self.nameView];
    [self addSubview:self.nameTitle];
    [self addSubview:self.nameText];
    [self addSubview:self.nameArrow];
    [self  addSubview:self.toLine];
    [self addSubview:self.nameLine];
    [self  addSubview:self.bankView];
    [self  addSubview:self.bankTitle];
    [self  addSubview:self.bankText];
    [self addSubview:self.bankArrow];
    [self  addSubview:self.remarkLabel];
    
    [self  addSubview:self.commitBtn];
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
    [_balanceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.varityView.mas_bottom).mas_offset([GUIUtil fit:5]);
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:30]);
    }];
    CGFloat left = [GUIUtil fit:115];
    if ([[FTConfig sharedInstance].lang isEqualToString:@"en"]) {
        left = [GUIUtil fit:155];
    }
    [_balanceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.balanceView).mas_offset([GUIUtil fit:14]);
        make.left.mas_equalTo([GUIUtil  fit:30]);
    }];
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
    
    [_desTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.top.equalTo(self.balanceView.mas_bottom).mas_offset([GUIUtil fit:25]);
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
    [_usdtBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.usdtTitle).mas_offset([GUIUtil fit:50]);
        make.right.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-30]);
        make.height.mas_equalTo([GUIUtil fit:30]);
    }];
    [_toImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.usdtBtn.mas_bottom).mas_offset([GUIUtil  fit:0]);
        make.centerX.mas_equalTo(0);
    }];
    [_cnyImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:30]);
        make.centerY.equalTo(self.cnyTitle);
    }];
    [_cnyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.cnyImg.mas_right).mas_offset([GUIUtil  fit:15]);
        make.top.equalTo(self.usdtBtn.mas_bottom).mas_offset([GUIUtil  fit:0]);
        make.height.mas_equalTo([GUIUtil fit:65]);
        make.bottom.equalTo(self.toView).mas_offset([GUIUtil fit:0]);
    }];
    [_cnyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-30]);
        make.centerY.equalTo(self.cnyTitle);
    }];
    [_toLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-15]);
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.top.equalTo(self.toView.mas_bottom).mas_offset([GUIUtil  fit:0]);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    [_nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:30]);
        make.top.equalTo(self.toView.mas_bottom).mas_offset([GUIUtil  fit:0]);
        make.height.mas_equalTo([GUIUtil  fit:65]);
    }];
    [_nameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil  fit:30]);
        make.centerY.equalTo(self.nameView);
    }];
    [_nameText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameView);
        make.right.equalTo(self.nameArrow.mas_left).mas_offset([GUIUtil fit:-5]).priority(750);
        self.masNameTextRight = make.right.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-30]);
    }];
    [_nameArrow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameView);
        make.right.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-30]);
        make.size.mas_equalTo([GUIUtil fitWidth:12 height:12]);
    }];
    [_nameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-15]);
        make.left.mas_equalTo([GUIUtil  fit:15]);
        make.bottom.equalTo(self.nameView.mas_bottom).mas_offset([GUIUtil  fit:0]);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    [_bankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:30]);
        make.top.equalTo(self.nameView.mas_bottom).mas_offset([GUIUtil  fit:0]);
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
        make.size.mas_equalTo([GUIUtil fitWidth:12 height:12]);
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
    [_spaceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_greaterThanOrEqualTo([GUIUtil fit:40]);
        make.top.equalTo(self.commitBtn.mas_bottom);
        make.bottom.mas_equalTo(-1).priority(500);
    }];
}

//MARK: - Action

- (void)willAppear{
    [self configVC:@{}];
    [[UserModel sharedInstance] getUserIndex:^{
        
    } failure:^{
        
    }];
    [self startTimer];
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
    [DCService getAvailData:type isOTC:YES priceArrow:NO success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]&&[type isEqualToString:weakSelf.type]) {
            weakSelf.isLoaded = YES;
            [weakSelf configInfo:data[@"data"]];
        }
        [HUDUtil hide];
    } failure:^(NSError *error) {
        [HUDUtil hide];
    }];
}

- (void)autoLoadData{
    WEAK_SELF;
    if (_config.count<=0) {
        return;
    }
    NSString *type = _type.copy;
    [DCService getpaymentRate:[NDataUtil stringWith:_config[@"payid"]] priceCoin:type priceArrow:@"SELL" success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]&&[type isEqualToString:self.type]){
            NSDictionary *dic = data[@"data"];
            weakSelf.rate = [NDataUtil stringWith:dic[@"exchangerate"] valid:@""];
            [weakSelf autoConfig];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)autoConfig{
    _desTitle.text = [NSString stringWithFormat:@"%@¥%@/%@",CFDLocalizedString(@"当前最优价格："),_rate,_type];
    NSInteger count = [_usdtText.text floatValue]*[_rate floatValue]*100+0.5;
    NSString *cny = [NSString stringWithFormat:@"%.2f",count/100.0];
    _cnyText.text = cny;
}

- (void)configInfo:(NSDictionary *)config{
    
    _balanceText.text = [NDataUtil stringWith:config[@"totalamount"] valid:@"--"];
    _enableSellText.text = [NDataUtil stringWith:config[@"amount"] valid:@"--"];
    _feeText.text = [NDataUtil stringWith:config[@"walletfeetext"] valid:@"--"];
    _rate = [NDataUtil stringWith:config[@"exchangetrade"] valid:@""];
    _desTitle.text = [NSString stringWithFormat:@"%@¥%@/%@",CFDLocalizedString(@"当前最优价格："),_rate,_type];
    _maxAmount = [NDataUtil stringWith:config[@"maxWarnValue"]];
    _minAmount = [NDataUtil stringWith:config[@"minWarnValue"]];
    _usdtText.placeholder = [NSString stringWithFormat:@"%@%@%@",CFDLocalizedString(@"输入买入数量，最少"),_minAmount,_type];
    _usdtText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_usdtText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType]}];
    NSString *remark = [NDataUtil stringWith:config[@"randomamountdesc"]];
    if ([remark containsString:@"<br/>"]) {
        remark = [remark stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\r\n"];
    }
    _remarkLabel.text = remark;
    [self currentyChanged];
}

- (void)configVC:(NSDictionary *)config{
    WEAK_SELF;
    [[UserModel sharedInstance] getIsAuthentic:^(BOOL isAuthentic) {
        if (isAuthentic) {
            weakSelf.nameTitle.text =CFDLocalizedString(@"实名认证:");
            weakSelf.nameText.text = [UserModel sharedInstance].realName;
            weakSelf.nameArrow.hidden = YES;
            [weakSelf.masNameTextRight activate];
            weakSelf.nameText.textColor = [GColorUtil C2];
        }else{
            weakSelf.nameTitle.text =CFDLocalizedString(@"实名认证:");
            weakSelf.nameText.text =  CFDLocalizedString(@"马上实名认证");
            weakSelf.nameArrow.hidden = NO;
            [weakSelf.masNameTextRight deactivate];
            weakSelf.nameText.textColor = [GColorUtil C13];
        }
        if ([UserModel sharedInstance].walletBankId.length==0) {
            weakSelf.bankTitle.text =CFDLocalizedString(@"到账银行卡:");
            weakSelf.bankText.text = CFDLocalizedString(@"马上绑定");
            weakSelf.bankArrow.hidden = NO;
            [weakSelf.masBankTextRight deactivate];
            weakSelf.bankText.textColor = [GColorUtil C13];
        }else{
            weakSelf.bankTitle.text =CFDLocalizedString(@"到账银行卡:");
            weakSelf.bankText.text = [NSString stringWithFormat:@"%@(%@)",[UserModel sharedInstance].bankName,[UserModel sharedInstance].bankCard];
            weakSelf.bankArrow.hidden = YES;
            [weakSelf.masBankTextRight activate];
            weakSelf.bankText.textColor = [GColorUtil C2];
        }
    }];
    _config = config;
}

- (void)startTimer{
    WEAK_SELF;
    [NTimeUtil startTimer:@"DrawlVC" interval:3 repeats:YES action:^{
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
//    if (_usdtText.text.length<=0) {
//        [HUDUtil showInfo:CFDLocalizedString(@"请输入买入数量")];
//        return;
//    }
    if (_rate.floatValue<=0) {
        [HUDUtil showInfo:CFDLocalizedString(@"汇率有误，请刷新重试")];
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
    [[UserModel sharedInstance] getIsAuthentic:^(BOOL isAuthentic) {
        if (!isAuthentic) {
            [DCAlert showAlert:@"" detail:CFDLocalizedString(@"您还未进行身份认证，请先进行身份认证") sureTitle:CFDLocalizedString(@"确定") sureHander:^{
                [CFDJumpUtil jumpToRealName];
            } cancelTitle:CFDLocalizedString(@"取消") cancelHander:^{
                
            }];
        }else if (![UserModel isBindBankCard]){
            [DCAlert showAlert:@"" detail:CFDLocalizedString(@"您还未进行绑定银行卡，请先绑定银行卡") sureTitle:CFDLocalizedString(@"确定") sureHander:^{
                [CFDJumpUtil jumpToBindBank];
            } cancelTitle:CFDLocalizedString(@"取消") cancelHander:^{
                
            }];
        }else{
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
    }];
   
}

- (void)commitOrder{
    NSString *amount = _usdtText.text;
    NSString *amountrmb = _cnyText.text;
    WEAK_SELF;
    [HUDUtil showProgress:@""];
    [DCService commitOTCDrawl:amount exchangetrade:_rate amountrmb:amountrmb currenttype:_type success:^(id data) {
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

- (void)allAction{
    
    NSInteger decLength = 8;
    if ([_type isEqualToString:@"USDT"]) {
        decLength = 2;
    }
    NSString *text = [GUIUtil notRoundingDownString:_enableSellText.text afterPoint:decLength];
    _usdtText.text = text;
    [self usdtTextChanged];
}

- (void)addNotic{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];}

- (void)removeNotic{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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

- (void)currentyChanged{
    _varityText.text =
    _usdtTitle.text = 
    _enableSellUnit.text =
    _balanceUnit.text = _type;
    WEAK_SELF;
    [CurrenttypeSelectedSheet loadVarityLogo:_type success:^(NSString * _Nonnull imgName) {
        [GUIUtil imageViewWithUrl:weakSelf.usdtImg url:imgName];
    }];
}


//MARK:- Getter

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
                weakSelf.desTitle.text = [NSString stringWithFormat:@"%@¥--/%@",CFDLocalizedString(@"汇率："),weakSelf.type];
                weakSelf.usdtText.placeholder = [NSString stringWithFormat:@"%@--%@",CFDLocalizedString(@"输入买入数量，最少"),weakSelf.type];
                weakSelf.usdtText.attributedPlaceholder = [[NSAttributedString alloc] initWithString:weakSelf.usdtText.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType]}];
                weakSelf.usdtText.text = @"";
                weakSelf.usdtText.font = [GUIUtil fitFont:14];
                [weakSelf currentyChanged];
                [weakSelf autoLoadData];
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
        _balanceUnit.text = @"USDT";
    }
    return _balanceUnit;
}
- (UILabel *)enableSellTitle{
    if (!_enableSellTitle) {
        _enableSellTitle = [UILabel new];
        _enableSellTitle.textColor = [GColorUtil C3];
        _enableSellTitle.font = [GUIUtil fitFont:14];
        _enableSellTitle.text = CFDLocalizedString(@"可卖金额");
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
        _enableSellUnit.text = @"USDT";
    }
    return _enableSellUnit;
}
- (UILabel *)feeTitle{
    if (!_feeTitle) {
        _feeTitle = [UILabel new];
        _feeTitle.textColor = [GColorUtil C3];
        _feeTitle.font = [GUIUtil fitFont:14];
        _feeTitle.text = CFDLocalizedString(@"卖出手续费");
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
        _usdtText.placeholder = @"  ";
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
    }
    return _usdtBtn;
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

- (UIView *)toLine{
    if (!_toLine) {
        _toLine = [[UIView alloc] init];
        _toLine.backgroundColor = [GColorUtil C7];
    }
    return _toLine;
}

- (UIView *)nameView{
    if (!_nameView) {
        _nameView = [[UIView alloc] init];
        _nameView.backgroundColor = [GColorUtil C16];
        [_nameView g_clickBlock:^(UITapGestureRecognizer *tap) {
            [[UserModel sharedInstance] getIsAuthentic:^(BOOL isAuthentic) {
                if (!isAuthentic) {
                    [CFDJumpUtil jumpToRealName];
                }
            }];
        }];
    }
    return _nameView;
}
- (UILabel *)nameTitle{
    if(!_nameTitle){
        _nameTitle = [[UILabel alloc] init];
        _nameTitle.textColor = [GColorUtil C2];
        _nameTitle.font = [GUIUtil  fitFont:16];
    }
    return _nameTitle;
}
- (UILabel *)nameText{
    if(!_nameText){
        _nameText = [[UILabel alloc] init];
        _nameText.textColor = [GColorUtil C13];
        _nameText.font = [GUIUtil  fitFont:16];
    }
    return _nameText;
}
- (UIImageView *)nameArrow{
    if (!_nameArrow) {
        _nameArrow = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"public_icon_more"]];
    }
    return _nameArrow;
}

- (UIView *)nameLine{
    if (!_nameLine) {
        _nameLine = [[UIView alloc] init];
        _nameLine.backgroundColor = [GColorUtil C7];
    }
    return _nameLine;
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
                    [DCAlert showAlert:@"" detail:CFDLocalizedString(@"您还未进行身份认证，请先进行身份认证") sureTitle:CFDLocalizedString(@"确定") sureHander:^{
                        [CFDJumpUtil jumpToRealName];
                    } cancelTitle:CFDLocalizedString(@"取消") cancelHander:^{
                        
                    }];
                }else if ([UserModel sharedInstance].bankCard.length<=0) {
                    [CFDJumpUtil jumpToBindBank];
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
//        _commitBtn.enabled = NO;
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

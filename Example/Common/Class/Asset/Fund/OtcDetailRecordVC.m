//
//  OtcDetailRecordVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/4/25.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "OtcDetailRecordVC.h"
#import "MarkView.h"

@interface OtcDetailRecordVC ()

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong) UILabel *orderNoText;
@property (nonatomic,strong) UILabel *orderNoTitle;
@property (nonatomic,strong) UILabel *statusText;
@property (nonatomic,strong) UILabel *statusTitle;
@property (nonatomic,strong) UILabel *amountText;
@property (nonatomic,strong) UILabel *amountTitle;
@property (nonatomic,strong) UILabel *valueText;
@property (nonatomic,strong) UILabel *valueTitle;
@property (nonatomic,strong) UILabel *rateText;
@property (nonatomic,strong) UILabel *rateTitle;
@property (nonatomic,strong) UILabel *feeText;
@property (nonatomic,strong) UILabel *feeTitle;
@property (nonatomic,strong) UILabel *dateText;
@property (nonatomic,strong) UILabel *dateTitle;
@property (nonatomic,strong) UILabel *remainText;
@property (nonatomic,strong) UILabel *remainTitle;
@property (nonatomic,strong) MarkView *payType1Text;
@property (nonatomic,strong) MarkView *payType2Text;
@property (nonatomic,strong) MarkView *payType3Text;
@property (nonatomic,strong) UILabel *payTypeText;
@property (nonatomic,strong) UILabel *payTypeTitle;
@property (nonatomic,strong) UILabel *accountText;
@property (nonatomic,strong) UILabel *accountTitle;
@property (nonatomic,strong) UIButton *accountBtn;
@property (nonatomic,strong) UILabel *payeeText;
@property (nonatomic,strong) UILabel *payeeTitle;
@property (nonatomic,strong) UIButton *payeeBtn;
@property (nonatomic,strong) UILabel *remarkText;
@property (nonatomic,strong) UILabel *remarkTitle;
@property (nonatomic,strong) UIButton *remarkBtn;
@property (nonatomic,strong) UIView *lineView;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UILabel *sureTitle;
@property (nonatomic,strong) NSDictionary *config;

@property (nonatomic,strong) MASConstraint *masContentBottom;
@property (nonatomic,strong) MASConstraint *masDateTextTop;
@property (nonatomic,strong) NSString *logId;
@property (nonatomic,strong) NSString *txtId;
@property (nonatomic,assign) BOOL isDeposit;
@property (nonatomic,assign) NSInteger remainTime;
@property (nonatomic,assign) NSInteger index;

@end

@implementation OtcDetailRecordVC

+ (void)jumpTo:(NSString *)logid txtId:(NSString *)txtId isDeposit:(BOOL)isDeposit;{
    OtcDetailRecordVC *target = [[OtcDetailRecordVC alloc] init];
    target.logId = logid;
    target.txtId = txtId;
    target.isDeposit = isDeposit;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = CFDLocalizedString(@"详细信息");
    self.view.backgroundColor = [GColorUtil C6];
    _index = -1;
    [self setupUI];
    [self autoLayout];
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
    WEAK_SELF;
    [GUIUtil refreshWithHeader:_scrollView refresh:^{
        [weakSelf loadData];
    }];
}

- (void)setupUI{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.orderNoText];
    [self.contentView addSubview:self.orderNoTitle];
    [self.contentView addSubview:self.statusText];
    [self.contentView addSubview:self.statusTitle];
    [self.contentView addSubview:self.rateText];
    [self.contentView addSubview:self.rateTitle];
    [self.contentView addSubview:self.feeText];
    [self.contentView addSubview:self.feeTitle];
    [self.contentView addSubview:self.dateText];
    [self.contentView addSubview:self.dateTitle];
    [self.contentView addSubview:self.amountText];
    [self.contentView addSubview:self.amountTitle];
    [self.contentView addSubview:self.valueText];
    [self.contentView addSubview:self.valueTitle];
    [self.contentView addSubview:self.remainText];
    [self.contentView addSubview:self.remainTitle];
    [self.contentView addSubview:self.lineView];
    [self.contentView addSubview:self.payTypeText];
    [self.contentView addSubview:self.payType1Text];
    [self.contentView addSubview:self.payType2Text];
    [self.contentView addSubview:self.payType3Text];
    [self.contentView addSubview:self.payTypeTitle];
    [self.contentView addSubview:self.accountText];
    [self.contentView addSubview:self.accountTitle];
    [self.contentView addSubview:self.accountBtn];
    [self.contentView addSubview:self.payeeText];
    [self.contentView addSubview:self.payeeTitle];
    [self.contentView addSubview:self.payeeBtn];
    [self.contentView addSubview:self.remarkText];
    [self.contentView addSubview:self.remarkTitle];
    [self.contentView addSubview:self.remarkBtn];
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.sureBtn];
    [self.contentView addSubview:self.sureTitle];
}

- (void)autoLayout{
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.equalTo(self.scrollView.mas_left).mas_offset(SCREEN_WIDTH+[GUIUtil fit:-15]);
        make.top.mas_equalTo([GUIUtil fit:15]);
        make.bottom.mas_equalTo([GUIUtil fit:-15]);
    }];
    [self.orderNoText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.orderNoTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNoText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.orderNoText);
    }];
    [self.statusText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:182]);
    }];
    [self.statusTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.statusText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.statusText);
    }];
    [self.amountText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.orderNoTitle.mas_bottom).mas_offset([GUIUtil fit:12]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.amountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.amountText);
    }];
    [self.valueText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountText);
        make.left.mas_equalTo([GUIUtil fit:182]);
    }];
    [self.valueTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.valueText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.valueText);
    }];
    [self.rateText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.valueTitle.mas_bottom).mas_offset([GUIUtil fit:12]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.rateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rateText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.rateText);
    }];
    [self.feeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rateText);
        make.left.mas_equalTo([GUIUtil fit:182]);
        make.height.mas_equalTo([GUIUtil fitFont:14].lineHeight);
    }];
    [self.feeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feeText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.feeText);
        make.height.mas_equalTo([GUIUtil fitFont:12].lineHeight);
    }];
    [self.dateText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.valueTitle.mas_bottom).mas_offset([GUIUtil fit:12]).priority(750);
        self.masDateTextTop = make.top.equalTo(self.feeTitle.mas_bottom).mas_offset([GUIUtil fit:12]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.dateTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.dateText);
    }];
    [self.remainText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateText);
        make.left.mas_equalTo([GUIUtil fit:182]);
    }];
    [self.remainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remainText.mas_bottom).mas_offset([GUIUtil fit:2]);
        make.left.equalTo(self.remainText);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
        make.top.equalTo(self.dateTitle.mas_bottom).mas_offset([GUIUtil fit:13]);
    }];
    [self.payType1Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payTypeTitle);
        make.left.equalTo(self.payTypeTitle.mas_right).mas_offset([GUIUtil fit:-2]);
    }];
    [self.payType2Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payTypeTitle);
        make.left.equalTo(self.payType1Text.mas_right).mas_offset([GUIUtil fit:5]);
    }];
    [self.payType3Text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payTypeTitle);
        make.left.equalTo(self.payType2Text.mas_right).mas_offset([GUIUtil fit:5]);
    }];
    [self.payTypeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payTypeTitle);
        make.left.equalTo(self.payTypeTitle.mas_right).mas_offset([GUIUtil fit:-2]);
    }];
    [self.payTypeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.dateTitle.mas_bottom).mas_offset([GUIUtil fit:26]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.accountText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accountTitle);
        make.left.equalTo(self.accountTitle.mas_right).mas_offset([GUIUtil fit:-2]);
    }];
    [self.accountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payTypeTitle.mas_bottom).mas_offset([GUIUtil fit:12]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.accountBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.accountTitle);
        make.right.mas_equalTo([GUIUtil fit:-15]);
    }];
    [self.payeeText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payeeTitle);
        make.left.equalTo(self.payeeTitle.mas_right).mas_offset([GUIUtil fit:-2]);
    }];
    [self.payeeTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.accountTitle.mas_bottom).mas_offset([GUIUtil fit:12]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [self.payeeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.payeeTitle);
        make.right.mas_equalTo([GUIUtil fit:-15]);
    }];
    [self.remarkText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.remarkTitle);
        make.left.equalTo(self.remarkTitle.mas_right).mas_offset([GUIUtil fit:-2]);
    }];
    [self.remarkTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.payeeTitle.mas_bottom).mas_offset([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:15]);
        self.masContentBottom = make.bottom.mas_equalTo([GUIUtil fit:-15]);
    }];
    [self.remarkBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.remarkTitle);
        make.right.mas_equalTo([GUIUtil fit:-15]);
    }];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.accountTitle);
        make.top.equalTo(self.remarkTitle.mas_bottom).mas_offset([GUIUtil fit:15]);
        make.size.mas_equalTo([GUIUtil fitWidth:150 height:35]);
    }];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.size.mas_equalTo([GUIUtil fitWidth:150 height:35]);
        make.top.equalTo(self.cancelBtn);
        make.bottom.mas_equalTo([GUIUtil fit:-15]).priority(750);
    }];
    [_sureTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.equalTo(self.sureBtn);
    }];
    [self.masDateTextTop deactivate];
}

- (void)loadData{
    WEAK_SELF;
    [DCService getOtcOrderDetail:_logId txtId:_txtId isDeposit:_isDeposit success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [weakSelf configView:[NDataUtil dictWith:data[@"data"]]];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"message"] valid:[FTConfig webTips]]];
        }
        [weakSelf.scrollView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
        [weakSelf.scrollView.mj_header endRefreshing];
    }];
}


//MARK: - Action

- (void)copyText:(UIButton *)btn{
    
    NSArray *list = [NDataUtil arrayWith:_config[@"receivables"]];
    NSDictionary *dic = [NDataUtil dictWithArray:list index:_index];
    NSString *text = @"";
    if (btn==_accountBtn) {
        text = [NDataUtil stringWith:dic[@"receivablesNum"]];
    }else if (btn==_payeeBtn){
        text = [NDataUtil stringWith:dic[@"receivablesName"]];
    }else if (btn==_remarkBtn){
        text = [NDataUtil stringWith:_config[@"postScript"]];
    }
    if (text.length>0) {
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = text;
        [HUDUtil showInfo:CFDLocalizedString(@"复制成功")];
    }else{
        if (btn!=_remarkBtn) {
            [HUDUtil showInfo:CFDLocalizedString(@"请刷新重试")];
        }
    }
}

- (void)cancelHander{
    WEAK_SELF;
    [HUDUtil showProgress:@""];
    [DCService getpayCancelOrder:[NDataUtil stringWith:_config[@"payCenterOrderId"]] logId:[NDataUtil stringWith:_config[@"logid"]] success:^(id data) {
        [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [weakSelf loadData];
        }
        
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

- (void)cancelAction{
    WEAK_SELF;
    [DCAlert showAlert:@"" detail:CFDLocalizedString(@"确定取消订单") sureTitle:CFDLocalizedString(@"确定" )sureHander:^{
        [weakSelf cancelHander];
    } cancelTitle:CFDLocalizedString(@"取消") cancelHander:^{
        
    }];
    
}

- (void)sureAction{
    WEAK_SELF;
    [DCService getpayConfirmOrder:[NDataUtil stringWith:_config[@"payCenterOrderId"]] logId:[NDataUtil stringWith:_config[@"logid"]] success:^(id data) {
        [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [weakSelf loadData];
        }
        
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

- (void)configView:(NSDictionary *)dic{
    _config = dic;
    _orderNoText.text = [NDataUtil stringWith:dic[@"showcoincode"]];
    _amountText.text = [NDataUtil stringWith:dic[@"orderAmount"]];
    _dateText.text = [NDataUtil stringWith:dic[@"createTime"]];
    _valueText.text = [NDataUtil stringWith:dic[@"realPaymentAmount"]];
    _payType1Text.hidden =
    _payType2Text.hidden =
    _payType3Text.hidden = NO;
    if (_isDeposit) {
        [self selectedIndex:_index==-1?0:_index];
    }else{
        _payTypeText.text = [NDataUtil stringWith:dic[@"receivablesMode"]];
        _accountText.text = [NDataUtil stringWith:dic[@"receivablesNum"]];
        _payeeText.text = [NDataUtil stringWith:dic[@"receivablesName"]];
        _remarkText.text =[NDataUtil stringWith:dic[@"postScript"]];
    }
    _remarkText.text = dic[@"postScript"];
    NSInteger status = [NDataUtil integerWith:dic[@"paystatus"]];
    NSString *statusText = @"";
    if (status==4) {
        statusText = CFDLocalizedString(@"失败");
        _cancelBtn.hidden = _sureBtn.hidden = YES;
        [_masContentBottom activate];
        _statusText.textColor = [GColorUtil C14];
        _remainTitle.hidden = _remainText.hidden = YES;
        [NTimeUtil stopTimer:@"OtcDetailRecordVC_RemainTime"];
    }else if (status==1){
        statusText = CFDLocalizedString(@"成功");
        _cancelBtn.hidden = _sureBtn.hidden = YES;
        [_masContentBottom activate];
        _statusText.textColor = [GColorUtil C24];
        _remainTitle.hidden = _remainText.hidden = YES;
        [NTimeUtil stopTimer:@"OtcDetailRecordVC_RemainTime"];
    }else if (status==0||status==5||status==2){
        [_masContentBottom deactivate];
        if (_isDeposit) {
            _remainTitle.hidden =
            _remainText.hidden = NO;
            _payType1Text.hidden =
            _payType2Text.hidden =
            _payType3Text.hidden =NO;
            _remainTime = [NDataUtil integerWith:dic[@"validTime"] valid:-1];
            if (_remainTime==0) {
                _remainTime=-1;
            }
            [self configRemainTime];
            statusText = CFDLocalizedString(@"交易中");
        }else{
            _remainTitle.hidden = _remainText.hidden = YES;
            [NTimeUtil stopTimer:@"OtcDetailRecordVC_RemainTime"];
            statusText = CFDLocalizedString(@"处理中");
        }
        
        _statusText.textColor = [GColorUtil C13];
        if (status==0||status==5) {
            _cancelBtn.hidden = _sureBtn.hidden = NO;
            _sureTitle.hidden = YES;
        }else{
            _sureTitle.hidden = NO;
            _remainTitle.hidden = _remainText.hidden = YES;
            _cancelBtn.hidden = _sureBtn.hidden = YES;
        }
    }
    if (_isDeposit==NO) {
        [_masContentBottom activate];
        _sureTitle.hidden =
        _cancelBtn.hidden = _sureBtn.hidden = YES;
        _rateText.hidden = _rateTitle.hidden =
        _feeText.hidden = _feeTitle.hidden = NO;
        _feeText.text = [NDataUtil stringWith:dic[@"fee"]];
        _rateText.text = [NDataUtil stringWith:dic[@"exchangeRate"]];
        [self.masDateTextTop activate];
    }
    _statusText.text = statusText;
}
- (void)selectedIndex:(NSInteger)index{
    if (_index==index) {
        return;
    }
    _index = index;
    NSArray *typeList = [NDataUtil arrayWith:_config[@"receivables"]];
    if ((typeList.count==3)) {
        NSDictionary *dic1 = typeList[0];
        NSDictionary *dic2 = typeList[1];
        NSDictionary *dic3 = typeList[2];
        _payType1Text.text = [NDataUtil stringWith:dic1[@"receivablesMode"]];
        _payType2Text.text = [NDataUtil stringWith:dic2[@"receivablesMode"]];
        _payType3Text.text = [NDataUtil stringWith:dic3[@"receivablesMode"]];
        _payType3Text.hidden =
        _payType2Text.hidden = NO;
        if (index==0) {
            [self configAccountInfo:dic1];
            _payType1Text.textColor = [GColorUtil C13];
            _payType1Text.layer.borderColor = GColorUtil.C13.CGColor;
            _payType2Text.textColor = [GColorUtil C2];
            _payType2Text.layer.borderColor = GColorUtil.C2.CGColor;
            _payType3Text.textColor = [GColorUtil C2];
            _payType3Text.layer.borderColor = GColorUtil.C2.CGColor;
        }else if(index==1){
            [self configAccountInfo:dic2];
            _payType1Text.textColor = [GColorUtil C2];
            _payType1Text.layer.borderColor = GColorUtil.C2.CGColor;
            _payType2Text.textColor = [GColorUtil C13];
            _payType2Text.layer.borderColor = GColorUtil.C13.CGColor;
            _payType3Text.textColor = [GColorUtil C2];
            _payType3Text.layer.borderColor = GColorUtil.C2.CGColor;
        }else{
            [self configAccountInfo:dic3];
            _payType1Text.textColor = [GColorUtil C2];
            _payType1Text.layer.borderColor = GColorUtil.C2.CGColor;
            _payType2Text.textColor = [GColorUtil C2];
            _payType2Text.layer.borderColor = GColorUtil.C2.CGColor;
            _payType3Text.textColor = [GColorUtil C13];
            _payType3Text.layer.borderColor = GColorUtil.C13.CGColor;
        }
    } else if (typeList.count==2) {
        NSDictionary *dic1 = typeList[0];
        NSDictionary *dic2 = typeList[1];
        _payType1Text.text = [NDataUtil stringWith:dic1[@"receivablesMode"]];
        _payType2Text.text = [NDataUtil stringWith:dic2[@"receivablesMode"]];
        _payType2Text.hidden = NO;
        _payType3Text.hidden = YES;
        if (index==0) {
            [self configAccountInfo:dic1];
            _payType1Text.textColor = [GColorUtil C13];
            _payType1Text.layer.borderColor = GColorUtil.C13.CGColor;
            _payType2Text.textColor = [GColorUtil C2];
            _payType2Text.layer.borderColor = GColorUtil.C2.CGColor;
        }else{
            [self configAccountInfo:dic2];
            _payType1Text.textColor = [GColorUtil C2];
            _payType1Text.layer.borderColor = GColorUtil.C2.CGColor;
            _payType2Text.textColor = [GColorUtil C13];
            _payType2Text.layer.borderColor = GColorUtil.C13.CGColor;
        }
    }else if (typeList.count==1){
        NSDictionary *dic1 = typeList[0];
        _payType1Text.text = [NDataUtil stringWith:dic1[@"receivablesMode"]];
        _payType3Text.hidden =
        _payType2Text.hidden = YES;
        [self configAccountInfo:dic1];
        _payType1Text.textColor = [GColorUtil C13];
        _payType1Text.layer.borderColor = GColorUtil.C13.CGColor;
    }else{
        return;
    }
    _remarkText.text = [NDataUtil stringWith:_config[@"postScript"] valid:@"--"];
    
}

- (void)configAccountInfo:(NSDictionary *)dic{
    
    _accountText.text = [NDataUtil stringWith:dic[@"receivablesNum"]];
    _payeeText.text = [NDataUtil stringWith:dic[@"receivablesName"]];
}

- (void)configRemainTime{
    WEAK_SELF;
    weakSelf.remainTime++;
    [NTimeUtil startTimer:@"OtcDetailRecordVC_RemainTime" interval:1 repeats:YES action:^{
        weakSelf.remainTime--;
        weakSelf.remainText.text = [NSString stringWithFormat:CFDLocalizedString(@"%d分%d秒"),(int)weakSelf.remainTime/60,(int)weakSelf.remainTime%60];
        if (weakSelf.remainTime==0) {
            [NTimeUtil stopTimer:@"OtcDetailRecordVC_RemainTime"];
            [weakSelf loadData];
            weakSelf.remainTitle.hidden = weakSelf.remainText.hidden = YES;
        }else if (weakSelf.remainTime<0){
            [NTimeUtil stopTimer:@"OtcDetailRecordVC_RemainTime"];
            weakSelf.remainTitle.hidden = weakSelf.remainText.hidden = YES;
        }
    }];
}

- (void)appDidBecomeActive{
    [self loadData];
}

//MARK: - Getter

- (UIScrollView *)scrollView{
    if(!_scrollView){
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.backgroundColor = [GColorUtil C6];
    }
    return _scrollView;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [GColorUtil C15];
        _contentView.layer.cornerRadius = 4;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UILabel *)orderNoText{
    if(!_orderNoText){
        _orderNoText = [[UILabel alloc] init];
        _orderNoText.textColor = [GColorUtil C2];
        _orderNoText.font = [GUIUtil fitFont:14];
        _orderNoText.text = @"--";
    }
    return _orderNoText;
}
- (UILabel *)orderNoTitle{
    if(!_orderNoTitle){
        _orderNoTitle = [[UILabel alloc] init];
        _orderNoTitle.textColor = [GColorUtil C3];
        _orderNoTitle.font = [GUIUtil fitFont:12];
        _orderNoTitle.text = CFDLocalizedString(@"币种");
    }
    return _orderNoTitle;
}
- (UILabel *)statusText{
    if(!_statusText){
        _statusText = [[UILabel alloc] init];
        _statusText.textColor = [GColorUtil C2];
        _statusText.font = [GUIUtil fitFont:14];
        _statusText.text = @"--";
    }
    return _statusText;
}
- (UILabel *)statusTitle{
    if(!_statusTitle){
        _statusTitle = [[UILabel alloc] init];
        _statusTitle.textColor = [GColorUtil C3];
        _statusTitle.font = [GUIUtil fitFont:12];
        _statusTitle.text = CFDLocalizedString(@"状态");
    }
    return _statusTitle;
}
- (UILabel *)rateText{
    if(!_rateText){
        _rateText = [[UILabel alloc] init];
        _rateText.textColor = [GColorUtil C2];
        _rateText.font = [GUIUtil fitFont:14];
        _rateText.text = @"--";
        _rateText.hidden = YES;
    }
    return _rateText;
}
- (UILabel *)rateTitle{
    if(!_rateTitle){
        _rateTitle = [[UILabel alloc] init];
        _rateTitle.textColor = [GColorUtil C3];
        _rateTitle.font = [GUIUtil fitFont:12];
        _rateTitle.text = CFDLocalizedString(@"汇率");
        _rateTitle.hidden = YES;
    }
    return _rateTitle;
}
- (UILabel *)feeText{
    if(!_feeText){
        _feeText = [[UILabel alloc] init];
        _feeText.textColor = [GColorUtil C2];
        _feeText.font = [GUIUtil fitFont:14];
        _feeText.text = @"--";
        _feeText.hidden = YES;
    }
    return _feeText;
}
- (UILabel *)feeTitle{
    if(!_feeTitle){
        _feeTitle = [[UILabel alloc] init];
        _feeTitle.textColor = [GColorUtil C3];
        _feeTitle.font = [GUIUtil fitFont:12];
        _feeTitle.text = CFDLocalizedString(@"手续费");
        _feeTitle.hidden = YES;
    }
    return _feeTitle;
}
- (UILabel *)dateText{
    if(!_dateText){
        _dateText = [[UILabel alloc] init];
        _dateText.textColor = [GColorUtil C2];
        _dateText.font = [GUIUtil fitFont:14];
        _dateText.text = @"--";
    }
    return _dateText;
}

- (UILabel *)dateTitle{
    if(!_dateTitle){
        _dateTitle = [[UILabel alloc] init];
        _dateTitle.textColor = [GColorUtil C3];
        _dateTitle.font = [GUIUtil fitFont:12];
        _dateTitle.text = CFDLocalizedString(@"时间");
    }
    return _dateTitle;
}
- (UILabel *)amountText{
    if(!_amountText){
        _amountText = [[UILabel alloc] init];
        _amountText.textColor = [GColorUtil C2];
        _amountText.font = [GUIUtil fitFont:14];
        _amountText.text = @"--";
    }
    return _amountText;
}
- (UILabel *)amountTitle{
    if(!_amountTitle){
        _amountTitle = [[UILabel alloc] init];
        _amountTitle.textColor = [GColorUtil C3];
        _amountTitle.font = [GUIUtil fitFont:12];
        _amountTitle.text = CFDLocalizedString(@"数量");
    }
    return _amountTitle;
}
- (UILabel *)valueText{
    if(!_valueText){
        _valueText = [[UILabel alloc] init];
        _valueText.textColor = [GColorUtil C2];
        _valueText.font = [GUIUtil fitFont:14];
        _valueText.text = @"--";
    }
    return _valueText;
}
- (UILabel *)valueTitle{
    if(!_valueTitle){
        _valueTitle = [[UILabel alloc] init];
        _valueTitle.textColor = [GColorUtil C3];
        _valueTitle.font = [GUIUtil fitFont:12];
        _valueTitle.text = CFDLocalizedString(@"CNY支付金额");
    }
    return _valueTitle;
}
- (UILabel *)remainText{
    if(!_remainText){
        _remainText = [[UILabel alloc] init];
        _remainText.textColor = [GColorUtil C13];
        _remainText.font = [GUIUtil fitFont:14];
        _remainText.text = @"--";
        _remainText.hidden = YES;
    }
    return _remainText;
}
- (UILabel *)remainTitle{
    if(!_remainTitle){
        _remainTitle = [[UILabel alloc] init];
        _remainTitle.textColor = [GColorUtil C3];
        _remainTitle.font = [GUIUtil fitFont:12];
        _remainTitle.text = CFDLocalizedString(@"倒计时");
        _remainTitle.hidden = YES;
    }
    return _remainTitle;
}
- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [GColorUtil C7];
    }
    return _lineView;
}
- (MarkView *)payType1Text{
    if(!_payType1Text){
        _payType1Text = [[MarkView alloc] init];
        _payType1Text.textColor = [GColorUtil C2];
        _payType1Text.font = [GUIUtil fitFont:10];
        _payType1Text.hPadding = [GUIUtil fit:5];
        _payType1Text.vPadding = [GUIUtil fit:2];
        _payType1Text.layer.borderWidth = 1;
        _payType1Text.layer.cornerRadius = 4;
        _payType1Text.layer.masksToBounds = YES;
        WEAK_SELF;
        [_payType1Text g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf selectedIndex:0];
        }];
    }
    return _payType1Text;
}
- (MarkView *)payType2Text{
    if(!_payType2Text){
        _payType2Text = [[MarkView alloc] init];
        _payType2Text.textColor = [GColorUtil C2];
        _payType2Text.font = [GUIUtil fitFont:10];
        _payType2Text.hPadding = [GUIUtil fit:5];
        _payType2Text.vPadding = [GUIUtil fit:2];
        _payType2Text.layer.borderWidth = 1;
        _payType2Text.layer.cornerRadius = 4;
        _payType2Text.layer.masksToBounds = YES;
        WEAK_SELF;
        [_payType2Text g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf selectedIndex:1];
        }];
    }
    return _payType2Text;
}
- (MarkView *)payType3Text{
    if(!_payType3Text){
        _payType3Text = [[MarkView alloc] init];
        _payType3Text.textColor = [GColorUtil C2];
        _payType3Text.font = [GUIUtil fitFont:10];
        _payType3Text.hPadding = [GUIUtil fit:5];
        _payType3Text.vPadding = [GUIUtil fit:2];
        _payType3Text.layer.borderWidth = 1;
        _payType3Text.layer.cornerRadius = 4;
        _payType3Text.layer.masksToBounds = YES;
        WEAK_SELF;
        [_payType3Text g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf selectedIndex:2];
        }];
    }
    return _payType3Text;
}
- (UILabel *)payTypeText{
    if(!_payTypeText){
        _payTypeText = [[UILabel alloc] init];
        _payTypeText.textColor = [GColorUtil C2];
        _payTypeText.font = [GUIUtil fitFont:12];
        _payTypeText.text = @"";
    }
    return _payTypeText;
}
- (UILabel *)payTypeTitle{
    if(!_payTypeTitle){
        _payTypeTitle = [[UILabel alloc] init];
        _payTypeTitle.textColor = [GColorUtil C2];
        _payTypeTitle.font = [GUIUtil fitFont:12];
        _payTypeTitle.text = CFDLocalizedString(@"收款方式：");
    }
    return _payTypeTitle;
}
- (UILabel *)accountText{
    if(!_accountText){
        _accountText = [[UILabel alloc] init];
        _accountText.textColor = [GColorUtil C2];
        _accountText.font = [GUIUtil fitFont:12];
        _accountText.text = @"--";
    }
    return _accountText;
}
- (UILabel *)accountTitle{
    if(!_accountTitle){
        _accountTitle = [[UILabel alloc] init];
        _accountTitle.textColor = [GColorUtil C2];
        _accountTitle.font = [GUIUtil fitFont:12];
        _accountTitle.text = CFDLocalizedString(@"收款账号：");
    }
    return _accountTitle;
}
- (UIButton *)accountBtn{
    if(!_accountBtn){
        _accountBtn = [[UIButton alloc] init];
        [_accountBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        _accountBtn.titleLabel.font = [GUIUtil fitFont:12];
        [_accountBtn setTitle:CFDLocalizedString(@"复制") forState:UIControlStateNormal];
        [_accountBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
        [_accountBtn addTarget:self action:@selector(copyText:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _accountBtn;
}
- (UILabel *)payeeText{
    if(!_payeeText){
        _payeeText = [[UILabel alloc] init];
        _payeeText.textColor = [GColorUtil C2];
        _payeeText.font = [GUIUtil fitFont:12];
        _payeeText.text = @"--";
    }
    return _payeeText;
}
- (UILabel *)payeeTitle{
    if(!_payeeTitle){
        _payeeTitle = [[UILabel alloc] init];
        _payeeTitle.textColor = [GColorUtil C2];
        _payeeTitle.font = [GUIUtil fitFont:12];
        _payeeTitle.text = CFDLocalizedString(@"收款人：");
    }
    return _payeeTitle;
}
- (UIButton *)payeeBtn{
    if(!_payeeBtn){
        _payeeBtn = [[UIButton alloc] init];
        [_payeeBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        _payeeBtn.titleLabel.font = [GUIUtil fitFont:12];
        [_payeeBtn setTitle:CFDLocalizedString(@"复制") forState:UIControlStateNormal];
        [_payeeBtn addTarget:self action:@selector(copyText:) forControlEvents:UIControlEventTouchUpInside];
        [_payeeBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _payeeBtn;
}
- (UILabel *)remarkText{
    if(!_remarkText){
        _remarkText = [[UILabel alloc] init];
        _remarkText.textColor = [GColorUtil C2];
        _remarkText.font = [GUIUtil fitFont:12];
        _remarkText.text = @"--";
    }
    return _remarkText;
}
- (UILabel *)remarkTitle{
    if(!_remarkTitle){
        _remarkTitle = [[UILabel alloc] init];
        _remarkTitle.textColor = [GColorUtil C2];
        _remarkTitle.font = [GUIUtil fitFont:12];
        _remarkTitle.text = CFDLocalizedString(@"附言：");
    }
    return _remarkTitle;
}
- (UIButton *)remarkBtn{
    if(!_remarkBtn){
        _remarkBtn = [[UIButton alloc] init];
        [_remarkBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        _remarkBtn.titleLabel.font = [GUIUtil fitFont:12];
        [_remarkBtn setTitle:CFDLocalizedString(@"复制") forState:UIControlStateNormal];
        [_remarkBtn addTarget:self action:@selector(copyText:) forControlEvents:UIControlEventTouchUpInside];
        [_remarkBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _remarkBtn;
}
- (UIButton *)cancelBtn{
    if(!_cancelBtn){
        _cancelBtn = [[UIButton alloc] init];
        _cancelBtn.titleLabel.font = [GUIUtil fitFont:14];
        _cancelBtn.layer.cornerRadius = [GUIUtil fit:4];
        _cancelBtn.layer.borderColor = [GColorUtil C3].CGColor;
        _cancelBtn.layer.borderWidth = [GUIUtil fitLine];
        _cancelBtn.layer.masksToBounds = YES;
        [_cancelBtn setTitleColor:[GColorUtil C3] forState:UIControlStateNormal];
        [_cancelBtn setTitle:CFDLocalizedString(@"取消订单") forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
        _cancelBtn.hidden = YES;
    }
    return _cancelBtn;
}
- (UIButton *)sureBtn{
    if(!_sureBtn){
        _sureBtn = [[UIButton alloc] init];
        _sureBtn.titleLabel.font = [GUIUtil fitFont:14];
        _sureBtn.layer.cornerRadius = [GUIUtil fit:4];
        _sureBtn.layer.borderColor = [GColorUtil C13].CGColor;
        _sureBtn.layer.borderWidth = [GUIUtil fitLine];
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        [_sureBtn setTitle:CFDLocalizedString(@"确认已付款") forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
        [_sureBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
        _sureBtn.hidden = YES;
    }
    return _sureBtn;
}
- (UILabel *)sureTitle{
    if(!_sureTitle){
        _sureTitle = [[UILabel alloc] init];
        _sureTitle.textColor = [GColorUtil C3];
        _sureTitle.font = [GUIUtil fitFont:14];
        _sureTitle.text = CFDLocalizedString(@"已确认付款，等待卖家确认");
        _sureTitle.hidden = YES;
    }
    return _sureTitle;
}

@end

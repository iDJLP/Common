//
//  ChoiceTransferView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/8/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "ChoiceTransferView.h"

@interface ChoiceTransferView ()
@property (nonatomic,strong) BaseBtn *bgBtn;
@property (nonatomic,strong) BaseView *contentView;
@property (nonatomic,strong) BaseLabel *varityTitle;
@property (nonatomic,strong) ChoiceRow *varityRow;
@property (nonatomic,strong) BaseLabel *statusTitle;
@property (nonatomic,strong) ChoiceRow *statusRow;
@property (nonatomic,strong) BaseBtn *resetBtn;
@property (nonatomic,strong) BaseBtn *sureBtn;
@property (nonatomic,assign) BOOL isLoaded;
@property (nonatomic,strong) MASConstraint *masContentTop;
@end

@implementation ChoiceTransferView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=  [super initWithFrame:frame]) {
        
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.bgBtn];
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.varityTitle];
    [self.contentView addSubview:self.varityRow];
    [self.contentView addSubview:self.statusTitle];
    [self.contentView addSubview:self.statusRow];
    [self.contentView addSubview:self.resetBtn];
    [self.contentView addSubview:self.sureBtn];
}

- (void)autoLayout{
    [_bgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        self.masContentTop = make.top.mas_equalTo(0);
        make.bottom.equalTo(self.mas_top).priority(500);
    }];
    [_varityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.width.mas_equalTo([GUIUtil fit:80]);
        make.top.equalTo(self.varityRow.mas_top).mas_offset([GUIUtil fit:3]);
    }];
    [_varityRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:100]);
        make.top.mas_equalTo([GUIUtil fit:18]);
        make.width.mas_equalTo([GUIUtil fit:55+14]*4-[GUIUtil fit:14]);
    }];
    [_statusTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.width.mas_equalTo([GUIUtil fit:85]);
        make.top.equalTo(self.statusRow.mas_top).mas_offset([GUIUtil fit:3]);
    }];
    [_statusRow mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:100]);
        make.top.equalTo(self.varityRow.mas_bottom).mas_offset([GUIUtil fit:21]);
        make.width.mas_equalTo([GUIUtil fit:55+14]*4-[GUIUtil fit:14]);
    }];
    [_resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([GUIUtil fitWidth:165 height:44]);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.equalTo(self.statusRow.mas_bottom).mas_offset([GUIUtil fit:30]);
    }];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([GUIUtil fitWidth:165 height:44]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.top.equalTo(self.statusRow.mas_bottom).mas_offset([GUIUtil fit:30]);
        make.bottom.mas_equalTo([GUIUtil fit:-15]);
    }];
}

- (void)willAppear:(NSString *)parmas{
    if (!_isLoaded) {
        [self loadView];
    }else if (parmas.length>0) {
        
        NSString *currency = @"";
        NSString *orderstatus = @"";
        NSArray *tem = [parmas componentsSeparatedByString:@"&"];
        for (NSString *string in tem) {
            if (string.length>0) {
                NSArray *tem1 = [string componentsSeparatedByString:@"="];
                if ([[NDataUtil stringWith:tem1[0]] isEqualToString:@"fromCurrency"]) {
                    currency = [NDataUtil dataWithArray:tem1 index:1];
                }else if ([[NDataUtil stringWith:tem1[0]] isEqualToString:@"toCurrency"]) {
                    orderstatus = [NDataUtil dataWithArray:tem1 index:1];
                }
            }
        }
        ChoiceBtn *currencyBtn = nil;
        ChoiceBtn *orderstatusBtn = nil;
        for (ChoiceBtn *btn in _varityRow.btnList) {
            if ([btn.config isEqualToString:currency]) {
                currencyBtn = btn;
            }
        }
        for (ChoiceBtn *btn in _statusRow.btnList) {
            if ([btn.config isEqualToString:orderstatus]) {
                orderstatusBtn = btn;
            }
        }
        [_varityRow.selectedList removeAllObjects];
        [_statusRow.selectedList removeAllObjects];
        if (currencyBtn) {
            [_varityRow.selectedList addObject:currencyBtn];
        }else{
            [_varityRow.selectedList addObject:_varityRow.btnList[0]];
        }
        if (orderstatusBtn) {
            [_statusRow.selectedList addObject:orderstatusBtn];
        }else{
            [_statusRow.selectedList addObject:_statusRow.btnList[0]];
        }
        [_varityRow selectedChanged];
        [_statusRow selectedChanged];
    }else{
        [_varityRow.selectedList removeAllObjects];
        [_statusRow.selectedList removeAllObjects];
        [_varityRow.selectedList addObject:_varityRow.btnList[0]];
        [_statusRow.selectedList addObject:_statusRow.btnList[0]];
        [_varityRow selectedChanged];
        [_statusRow selectedChanged];
    }
    [self showAction];
}

- (void)loadView{
    if (_isLoaded==NO) {
        [StateUtil show:self.contentView type:StateTypeProgress];
    }
    WEAK_SELF;
    [DCService getOrderfilter:^(id data) {
        [StateUtil hide:weakSelf.contentView];
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            weakSelf.isLoaded = YES;
            NSDictionary *dic = [NDataUtil dictWith:data[@"data"]];
            [weakSelf.varityRow configView:[NDataUtil arrayWith:dic[@"currency"]]];
            [weakSelf.statusRow configView:[NDataUtil arrayWith:dic[@"currency"]]];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"message"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [StateUtil hide:weakSelf.contentView];
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
    
}

- (void)showAction{
    self.hidden = NO;
    [self.masContentTop activate];
    self.bgBtn.alpha = 0.2;
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        self.bgBtn.alpha = 1;
    }];
}

- (void)closeAction{
    
    [self.masContentTop deactivate];
    [UIView animateWithDuration:0.25 animations:^{
        [self layoutIfNeeded];
        self.bgBtn.alpha = 0.2;
    } completion:^(BOOL finished) {
        self.hidden = YES;
        self.bgBtn.alpha = 1;
    }];
}

- (void)resetAction{
    [_varityRow.selectedList removeAllObjects];
    [_statusRow.selectedList removeAllObjects];
    [_varityRow.selectedList addObject:_varityRow.btnList[0]];
    [_statusRow.selectedList addObject:_statusRow.btnList[0]];
    [_varityRow selectedChanged];
    [_statusRow selectedChanged];
    [self sureAction];
}

- (void)sureAction{
    NSString *currency = @"";
    NSString *status = @"";
    for (ChoiceBtn *btn in _varityRow.selectedList) {
        id config = btn.config;
        NSString *title = @"";
        if ([config isKindOfClass:[NSDictionary class]]) {
            title = [NDataUtil stringWithDict:config keys:@[@"statusdesc"] valid:@""];
        }else if ([config isKindOfClass:[NSString class]]){
            title = config;
            if ([title isEqualToString:@"全部"]) {
                title = @"all";
            }
        }
        currency = [currency stringByAppendingFormat:@"%@,",title];
    }
    for (ChoiceBtn *btn in _statusRow.selectedList) {
        id config = btn.config;
        NSString *title = @"";
        if ([config isKindOfClass:[NSDictionary class]]) {
            title = [NDataUtil stringWithDict:config keys:@[@"statusdesc"] valid:@""];
        }else if ([config isKindOfClass:[NSString class]]){
            title = config;
            if ([title isEqualToString:@"全部"]) {
                title = @"all";
            }
        }
        status = [status stringByAppendingFormat:@"%@,",title];
    }
    if (currency.length>1) {
        currency = [currency substringToIndex:currency.length-1];
    }
    if (status.length>1) {
        status = [status substringToIndex:status.length-1];
    }
    [self closeAction];
    if (_loadDataHander) {
        NSString *params = [NSString stringWithFormat:@"&fromCurrency=%@&toCurrency=%@",currency,status];
        _loadDataHander(params);
    }
}

//MARK: - Getter

- (BaseBtn *)bgBtn{
    if (!_bgBtn) {
        _bgBtn = [[BaseBtn alloc] init];
        _bgBtn.backgroundColor = [UIColor clearColor];
        [_bgBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgBtn;
}

- (BaseView *)contentView{
    if (!_contentView) {
        _contentView = [[BaseView alloc] init];
        _contentView.bgColor = C6_ColorType;
    }
    return _contentView;
}

- (BaseLabel *)varityTitle{
    if (!_varityTitle) {
        _varityTitle = [[BaseLabel alloc] init];
        _varityTitle.txColor = C2_ColorType;
        _varityTitle.font = [GUIUtil fitFont:14];
        _varityTitle.text = CFDLocalizedString(@"兑出币种：");
    }
    return _varityTitle;
}

- (ChoiceRow *)varityRow{
    if (!_varityRow) {
        _varityRow = [[ChoiceRow alloc] init];
        _varityRow.numberOfChoices = NO;
    }
    return _varityRow;
}

- (BaseLabel *)statusTitle{
    if (!_statusTitle) {
        _statusTitle = [[BaseLabel alloc] init];
        _statusTitle.txColor = C2_ColorType;
        _statusTitle.font = [GUIUtil fitFont:14];
        _statusTitle.text = CFDLocalizedString(@"换为币种：");
    }
    return _statusTitle;
}

- (ChoiceRow *)statusRow{
    if (!_statusRow) {
        _statusRow = [[ChoiceRow alloc] init];
        _statusRow.numberOfChoices = NO;
    }
    return _statusRow;
}

- (BaseBtn *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [[BaseBtn alloc] init];
        [_resetBtn setTitle:CFDLocalizedString(@"重置") forState:UIControlStateNormal];
        [_resetBtn setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
        _resetBtn.layer.borderWidth = [GUIUtil fitLine];
        _resetBtn.layer.borderColor = [GColorUtil C13].CGColor;
        _resetBtn.layer.cornerRadius = [GUIUtil fit:2];
        _resetBtn.layer.masksToBounds = YES;
        [_resetBtn addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _resetBtn;
}

- (BaseBtn *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[BaseBtn alloc] init];
        [_sureBtn setTitle:CFDLocalizedString(@"确定") forState:UIControlStateNormal];
        _sureBtn.bgColor = C13_ColorType;
        [_sureBtn setTitleColor:[GColorUtil C5] forState:UIControlStateNormal];
        _sureBtn.layer.borderWidth = [GUIUtil fitLine];
        _sureBtn.layer.borderColor = [GColorUtil C13].CGColor;
        _sureBtn.layer.cornerRadius = [GUIUtil fit:2];
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end


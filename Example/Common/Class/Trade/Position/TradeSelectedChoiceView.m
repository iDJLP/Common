//
//  TradeSelectedChoiceView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/10/12.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "TradeSelectedChoiceView.h"

@interface TradeSelectedChoiceView ()

@property (nonatomic,strong) BaseBtn *bgBtn;
@property (nonatomic,strong) BaseView *contentView;
@property (nonatomic,strong) BaseLabel *varityTitle;
@property (nonatomic,strong) ChoiceRow *varityRow;
@property (nonatomic,strong) BaseLabel *statusTitle;
@property (nonatomic,strong) ChoiceRow *statusRow;
@property (nonatomic,strong) BaseBtn *resetBtn;
@property (nonatomic,strong) BaseBtn *sureBtn;

@property (nonatomic,strong) ChoiceBtn *currentRespondBtn;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic,assign) BOOL isLoaded;
@property (nonatomic,strong) MASConstraint *masContentTop;
@property (nonatomic,strong)NSDateFormatter *formatter;
@end

@implementation TradeSelectedChoiceView

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
    [self.contentView addSubview:self.textField];
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

- (void)willAppear:(NSDictionary *)parmas{
   
    if (!_isLoaded) {
        [self loadView];
    }else if (parmas.count>0) {
        NSString *symbol = [NDataUtil stringWith:parmas[@"symbol"]];//
        NSString *timetype = [NDataUtil stringWith:parmas[@"timetype"]];//
        ChoiceBtn *currencyBtn = nil;
        ChoiceBtn *orderstatusBtn = nil;
        for (ChoiceBtn *btn in _varityRow.btnList) {
            if ([NDataUtil boolWithDic:btn.config key:@"val" isEqual:symbol]) {
                currencyBtn = btn;
            }
        }
        for (ChoiceBtn *btn in _statusRow.btnList) {
            if ([NDataUtil boolWithDic:btn.config key:@"statuscode" isEqual:timetype]) {
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
    [DCService getSymbolfilterlistr:^(id data) {
        [StateUtil hide:weakSelf.contentView];
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            weakSelf.isLoaded = YES;
            NSDictionary *dic = [NDataUtil dictWith:data[@"data"]];
            [weakSelf.varityRow configView:[NDataUtil arrayWith:dic[@"symbols"]]];
            NSDictionary *dic1 = @{@"statuslists":@[@{@"statusdesc":CFDLocalizedString(@"全部"),@"statuscode":@"0"},@{@"statusdesc":CFDLocalizedString(@"当天"),@"statuscode":@"1"},@{@"statusdesc":CFDLocalizedString(@"7天"),@"statuscode":@"2"},@{@"statusdesc":CFDLocalizedString(@"30天"),@"statuscode":@"3"}]};
            [weakSelf.statusRow configView:[NDataUtil arrayWith:dic1[@"statuslists"]]];
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
    if (_textField.isFirstResponder) {
        [_textField resignFirstResponder];
        return;
    }
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
    NSString *currencyText = @"";
    NSString *status = @"";
    NSString *statusText = @"";
    for (ChoiceBtn *btn in _varityRow.selectedList) {
        id config = btn.config;
        NSString *title = @"";
        NSString *text = @"";
        if ([config isKindOfClass:[NSDictionary class]]) {
            title = [NDataUtil stringWithDict:config keys:@[@"val"] valid:@""];
            text = [NDataUtil stringWithDict:config keys:@[@"desc"] valid:@""];
        }else if ([config isKindOfClass:[NSString class]]){
            title = config;
        }
        currency = [currency stringByAppendingFormat:@"%@,",title];
        currencyText = [currencyText stringByAppendingFormat:@"%@,",text];
    }
    for (ChoiceBtn *btn in _statusRow.selectedList) {
        id config = btn.config;
        NSString *title = @"";
        NSString *text = @"";
        if ([config isKindOfClass:[NSDictionary class]]) {
            title = [NDataUtil stringWithDict:config keys:@[@"statuscode"] valid:@""];
            text = [NDataUtil stringWithDict:config keys:@[@"statusdesc"] valid:@""];
        }else if ([config isKindOfClass:[NSString class]]){
            title = config;
        }
        status = [status stringByAppendingFormat:@"%@,",title];
        statusText = [statusText stringByAppendingFormat:@"%@,",text];
    }
    if (currency.length>1) {
        currency = [currency substringToIndex:currency.length-1];
        currencyText = [currencyText substringToIndex:currencyText.length-1];
    }
    if (status.length>1) {
        status = [status substringToIndex:status.length-1];
        statusText = [statusText substringToIndex:statusText.length-1];
    }
    [self closeAction];
    NSString *timetype = status;;
    NSDictionary *params = @{@"symbol":currency,@"symbolText":currencyText,@"timetype":timetype,@"timetypeText":statusText};
    _loadDataHander(params);
}

- (void)dateAction:(ChoiceBtn *)sender{
    _currentRespondBtn = sender;
    
    NSString *string = [_currentRespondBtn titleForState:UIControlStateNormal];
    if (string.length>4) {
        NSDate *date = [self.formatter dateFromString:string];
        self.datePicker.date = date;
    }
    [self.textField becomeFirstResponder];
}

- (void)dateChange{
    
    
    NSString *dateStr = [self.formatter  stringFromDate:_datePicker.date];
    
    [_currentRespondBtn setTitle:dateStr forState:UIControlStateNormal];
    [self dateBtnChanged:_currentRespondBtn];
}

- (void)dateBtnChanged:(ChoiceBtn *)sender{
    [_statusRow.selectedList removeAllObjects];
    [_statusRow selectedChanged];
    sender.selected = YES;
}

//MARK: - Getter

- (NSDateFormatter *)formatter{
    if (!_formatter) {
        _formatter = [[NSDateFormatter alloc] init];
        //设置时间格式
        _formatter.dateFormat = @"yyyy-MM-dd";
    }
    return _formatter;
}

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
        _varityTitle.text = CFDLocalizedString(@"合约：");
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
        _statusTitle.text = CFDLocalizedString(@"日期：");
        _statusTitle.numberOfLines = 2;
        _statusTitle.textAlignment = NSTextAlignmentLeft;
    }
    return _statusTitle;
}

- (ChoiceRow *)statusRow{
    if (!_statusRow) {
        _statusRow = [[ChoiceRow alloc] init];
        _statusRow.numberOfChoices = NO;
        
        _statusRow.selectedChangedHander = ^{

        };
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

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
        _textField.hidden = YES;
        //设置时间输入框的键盘框样式为时间选择器
        _textField.inputView = self.datePicker;
        [_textField addTarget:self action:@selector(dateChange) forControlEvents:UIControlEventEditingDidEnd];
        [_textField addToolbar];
    }
    return _textField;
}

- (UIDatePicker *)datePicker{
    if (!_datePicker) {
        _datePicker = [[UIDatePicker alloc] init];
        //设置地区:
        if ([[FTConfig sharedInstance].lang isEqualToString:@"en"]) {
            
            _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"en"];
        }else{
//            zh-中国
            _datePicker.locale = [NSLocale localeWithLocaleIdentifier:@"zh"];
        }
        
        
        //设置日期模式(Displays month, day, and year depending on the locale setting)
        _datePicker.datePickerMode = UIDatePickerModeDate;
        // 设置当前显示时间
        [_datePicker setDate:[NSDate date] animated:YES];
        // 设置显示最大时间（此处为当前时间）
        [_datePicker setMaximumDate:[NSDate date]];
        
        //监听DataPicker的滚动
        [_datePicker addTarget:self action:@selector(dateChange) forControlEvents:UIControlEventValueChanged];
        
    }
    return _datePicker;
}

@end



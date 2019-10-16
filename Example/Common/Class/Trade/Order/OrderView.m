//
//  OrderView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "OrderView.h"
#import "InputView.h"
#import "OrderKeyBoardView.h"
#import "BaseLabel.h"
#import "BaseBtn.h"

@interface OrderView ()

@property (nonatomic,strong) OrderModel *model;
@property (nonatomic,strong) BaseBtn *buyBtn;
@property (nonatomic,strong) BaseBtn *sellBtn;
@property (nonatomic,strong) BaseBtn *marketBtn;
@property (nonatomic,strong) BaseBtn *helpMarketBtn;
@property (nonatomic,strong) BaseBtn *limitBtn;
@property (nonatomic,strong) BaseBtn *helpLimitBtn;
@property (nonatomic,strong) InputView *priceView;
@property (nonatomic,strong) InputView *amountView;
@property (nonatomic,strong) InputView *pryView;
@property (nonatomic,strong) InputView *tpView;
@property (nonatomic,strong) InputView *slView;
@property (nonatomic,strong) BaseLabel *balanceLabel;
@property (nonatomic,strong) BaseLabel *entrustValueLabel;
@property (nonatomic,strong) BaseLabel *marginLabel;
@property (nonatomic,strong) BaseBtn *commitBtn;
@property (nonatomic,strong) OrderKeyBoardView *keyBoard1View;
@property (nonatomic,strong) OrderKeyBoardView *keyBoardView;
@property (nonatomic,assign) BOOL enableEdit;
@property (nonatomic,copy) dispatch_block_t endRefreshHander;
@end

@implementation OrderView

+ (CGSize)sizeOfView{
    CGFloat width = [GUIUtil fit:240];
    CGFloat height = [GUIUtil fit:40]+[GUIUtil fit:40] + ([InputView sizeOfView].height +[GUIUtil fit:10])*5+([GUIUtil fitFont:12].lineHeight+[GUIUtil fit:5])*3+[GUIUtil fit:40];
    return CGSizeMake(width, ceil(height));
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithSymbol:(NSString *)symbol{
    if (self = [super init]) {
        WEAK_SELF;
        _model = [[OrderModel alloc] initWithSymbol:symbol];
        _model.priceChangedHander = ^{
            [weakSelf updateViewPriceChanged];
        };
        _enableEdit = YES;
        self.backgroundColor = [GColorUtil C6];
        [self setupUI];
        [self autoLayout];
        [self tradeTypeAction:_marketBtn];
        [self changeTradeTypeAction:self.buyBtn];
        [self addNotic];
        [self themeChangedAction];
    }
    return self;
}

- (void)willAppear{
    [self loadData];
    [self startTimer];
}

- (void)refreshData:(dispatch_block_t)endRefreshHander{
    if (!_endRefreshHander) {
        _endRefreshHander = endRefreshHander;
    }
    [self loadData];
}

- (void)setupUI{
    [self addSubview:self.buyBtn];
    [self addSubview:self.sellBtn];
    [self addSubview:self.marketBtn];
    [self addSubview:self.helpMarketBtn];
    [self addSubview:self.limitBtn];
    [self addSubview:self.helpLimitBtn];
    [self addSubview:self.priceView];
    [self addSubview:self.amountView];
    [self addSubview:self.pryView];
    [self addSubview:self.tpView];
    [self addSubview:self.slView];
    [self addSubview:self.balanceLabel];
    [self addSubview:self.entrustValueLabel];
    [self addSubview:self.marginLabel];
    [self addSubview:self.commitBtn];

}

- (void)autoLayout{
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.mas_equalTo(0);
        make.size.mas_equalTo([GUIUtil fitWidth:113 height:30]);
    }];
    [self.sellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.buyBtn.mas_right).mas_offset([GUIUtil fit:-8]);
        make.top.equalTo(self.buyBtn);
        make.size.mas_equalTo([GUIUtil fitWidth:113 height:30]);
    }];
    [self.marketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:0]);
        make.top.equalTo(self.buyBtn.mas_bottom);
        make.size.mas_equalTo([GUIUtil fitWidth:100 height:40]);
    }];
    [self.helpMarketBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.marketBtn.mas_right).mas_offset([GUIUtil fit:-12]);
        make.centerY.equalTo(self.marketBtn);
    }];
    [self.limitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:113]);
        make.top.equalTo(self.marketBtn);
        make.size.mas_equalTo([GUIUtil fitWidth:100 height:40]);
    }];
    [self.helpLimitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.limitBtn.mas_right).mas_offset([GUIUtil fit:-12]);
        make.centerY.equalTo(self.limitBtn);
    }];
    [self.priceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.marketBtn.mas_bottom);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo([InputView sizeOfView]);
    }];
    [self.amountView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceView.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo([InputView sizeOfView]);
    }];
    [self.pryView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.amountView.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo([InputView sizeOfView]);
    }];
    [self.tpView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pryView.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo([InputView sizeOfView]);
    }];
    [self.slView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tpView.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo([InputView sizeOfView]);
    }];
    [self.balanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.equalTo(self.slView.mas_bottom).mas_offset([GUIUtil fit:10]);
    }];
    [self.entrustValueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.equalTo(self.balanceLabel.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.marginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.equalTo(self.entrustValueLabel.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [self.commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.height.mas_equalTo([GUIUtil fit:30]);
        make.right.equalTo(self.slView);
        make.top.equalTo(self.marginLabel.mas_bottom).mas_offset([GUIUtil fit:8]);
    }];
}

//MARK: - LoadData

- (void)loadData{
    if (_model.symbol.length<=0) {
        return;
    }
    WEAK_SELF;
    NSString *symbol = _model.symbol;
    [DCService getBuyPage:symbol success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]&&[symbol isEqualToString:weakSelf.model.symbol]) {
            [weakSelf.model configData:data[@"data"]];
            [weakSelf configView];
        }else{
            [NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]];
        }
        if (weakSelf.endRefreshHander) {        
            weakSelf.endRefreshHander();
        }
    } failure:^(NSError *error) {
        if (weakSelf.endRefreshHander) {
            weakSelf.endRefreshHander();
        }
    }];
}

- (void)loadBalance:(BOOL)isAuto{
    WEAK_SELF;
    [DCService postgetUserProfit:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            NSDictionary *dic = [NDataUtil dictWith:data[@"data"]];
            weakSelf.model.balance = [NDataUtil stringWith:dic[@"canusedamount"]];
            weakSelf.balanceLabel.text = [NSString stringWithFormat:@"%@  %@USDT",CFDLocalizedString(@"可用余额") ,weakSelf.model.balance];
        }else{
            if (isAuto==NO) {
                [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
            }
        }
    } failure:^(NSError *error) {
        if (isAuto==NO) {
            [HUDUtil showInfo:[FTConfig webTips]];
        }
    }];
}

- (void)configView{
    if (_model.isLoaded==NO) {
        _entrustValueLabel.text = [NSString stringWithFormat:@"%@  %@",CFDLocalizedString(@"委托价值"),@"--"];
        _marginLabel.text = [NSString stringWithFormat:@"%@  %@",CFDLocalizedString(@"预估保证金"),@"--"];
        [_pryView configView:@{@"title":CFDLocalizedString(@"杠杆"),@"text":@"--"}];
        [_amountView configView:@{@"title":CFDLocalizedString(@"数量"),@"text":@""}];
        [_tpView configView:@{@"title":CFDLocalizedString(@"止盈"),@"text":@"--"}];
        [_slView configView:@{@"title":CFDLocalizedString(@"止损"),@"text":@"--"}];
        return;
    }
    if (_updateHeaderViewHander) {    
        _updateHeaderViewHander(_model);
    }
    BOOL isMarket = [_model.ordertype isEqualToString:@"2"];
    _marketBtn.selected = isMarket;
    _limitBtn.selected = !isMarket;
    _priceView.minFloat = _model.minfloat;
    _amountView.minFloat = _model.amountFloat;
    if (isMarket) {
        [_priceView configView:@{@"title":CFDLocalizedString(@"价格"),@"placeholder":CFDLocalizedString(@"市场最优价成交")}];
    }else{
        [_priceView configView:@{@"title":CFDLocalizedString(@"价格"),@"text":[NDataUtil stringWith:_model.openPrice]}];
    }
    [_amountView configView:@{@"title":CFDLocalizedString(@"数量"),@"text":_model.delegateAmount}];
    NSString *pryText = [NSString stringWithFormat:@"%@%@",_model.pry,CFDLocalizedString(@"倍")];
    [_pryView configView:@{@"title":CFDLocalizedString(@"杠杆"),@"text":pryText}];
    NSString *tpText = [NSString stringWithFormat:@"%@%%",[GUIUtil decimalMultiply:_model.tpPrecent num:@"100"]];
    [_tpView configView:@{@"title":CFDLocalizedString(@"止盈"),@"text":tpText}];
    NSString *slText = [NSString stringWithFormat:@"%@%%",[GUIUtil decimalMultiply:_model.slPrecent num:@"100"]];
    [_slView configView:@{@"title":CFDLocalizedString(@"止损"),@"text":slText}];
    _balanceLabel.text = [NSString stringWithFormat:@"%@  %@USDT",CFDLocalizedString(@"可用余额"),_model.balance];
    _entrustValueLabel.text = [NSString stringWithFormat:@"%@  %@USDT",CFDLocalizedString(@"委托价值"),_model.delegateValue];
    _marginLabel.text = [NSString stringWithFormat:@"%@  %@USDT",CFDLocalizedString(@"预估保证金"),_model.margin];
}

- (void)updateViewPriceChanged{
    if ([_model.ordertype isEqualToString:@"1"]&&_enableEdit) {
        [_priceView configView:@{@"title":CFDLocalizedString(@"价格"),@"text":[NDataUtil stringWith:_model.openPrice]}];
    }
    NSString *tpText = [NSString stringWithFormat:@"%@%%",[GUIUtil decimalMultiply:_model.tpPrecent num:@"100"]];
    [_tpView configView:@{@"title":CFDLocalizedString(@"止盈"),@"text":tpText}];
    NSString *slText = [NSString stringWithFormat:@"%@%%",[GUIUtil decimalMultiply:_model.slPrecent num:@"100"]];
    [_slView configView:@{@"title":CFDLocalizedString(@"止损"),@"text":slText}];
    _entrustValueLabel.text = [NSString stringWithFormat:@"%@  %@USDT",CFDLocalizedString(@"委托价值"),_model.delegateValue];
    _marginLabel.text = [NSString stringWithFormat:@"%@  %@USDT",CFDLocalizedString(@"预估保证金"),_model.margin];
    if ([self isFirstRespond]) {
        [_keyBoardView changedPrice:_model.openPrice];
    }
}

//MARK: - Action

- (void)startTimer{
    WEAK_SELF;
    [NTimeUtil startTimer:@"TradeVC_order" interval:5 repeats:YES action:^{
        [weakSelf loadBalance:YES];
    }];
}

- (BOOL)isFirstRespond{
    return _priceView.textField.isFirstResponder||
    _amountView.textField.isFirstResponder||
    _pryView.textField.isFirstResponder||
    _slView.textField.isFirstResponder||
    _tpView.textField.isFirstResponder;
}

- (void)changedSymbol:(NSString *)symbol{
    if (![_model.symbol isEqualToString:symbol]&&symbol.length>0) {
        [_model changedSymbol:symbol];
        [self configView];
        [self loadData];
    }
}

- (void)changedPrice:(NSDictionary *)dic{
    if ([_model.ordertype isEqualToString:@"1"]&&!_enableEdit) {
        return;
    }
    NSString *symbol = [NDataUtil stringWith:dic[@"symbol"] valid:@""];
    NSString *price = [_model.bstype isEqualToString:@"1"]?[NDataUtil stringWith:dic[@"askPrice"] valid:@""]:[NDataUtil stringWith:dic[@"bidPrice"] valid:@""];
    if ([symbol isEqualToString:_model.symbol]&&_model&&price.length>0) {
        [_model changedPrice:price];
    }
}

- (void)helpMarketAction{
    [DCAlert showAlert:CFDLocalizedString(@"市价单说明") detail:_model.marketOrderTip sureTitle:CFDLocalizedString(@"知道了") sureHander:^{
        
    }];
}
- (void)helpLimitAction{
    [DCAlert showAlert:CFDLocalizedString(@"限价单说明") detail:_model.limitOrderTip sureTitle:CFDLocalizedString(@"知道了") sureHander:^{
        
    }];
}

- (void)tradeTypeAction:(UIButton *)sender{
    if (sender.isSelected) {
        return;
    }
    if (sender==_marketBtn) {
        _limitBtn.selected = NO;
        _marketBtn.selected = YES;
        [_model changedOrdertype:YES];
        if (_priceView.textField.isFirstResponder) {
            [_priceView.textField resignFirstResponder];
        }
    }else if (sender==_limitBtn){
        _enableEdit = YES;
        _marketBtn.selected = NO;
        _limitBtn.selected = YES;
        _model.openPrice = _model.lastPrice;
        [_model changedOrdertype:NO];
    }
    [self configView];
}

- (void)changeTradeType:(BOOL)isBuy{
    if (isBuy) {
        [self changeTradeTypeAction:_buyBtn];
    }else{
        [self changeTradeTypeAction:_sellBtn];
    }
}

- (void)changeTradeTypeAction:(UIButton *)sender{
    if (sender.isSelected) {
        return;
    }
    _enableEdit = YES;
    sender.selected = YES;
    if (sender == _buyBtn) {
        _model.bstype = @"1";
        _sellBtn.selected = NO;
        _commitBtn.backgroundColor = [GColorUtil C11];
        _commitBtn.textBlock = CFDLocalizedStringBlock(@"提交买入");
        
    }else if (sender == _sellBtn){
        _model.bstype = @"2";
        _buyBtn.selected = NO;
        _commitBtn.backgroundColor = [GColorUtil C12];
        _commitBtn.textBlock = CFDLocalizedStringBlock(@"提交卖出");
    }
    [_model calData];
    [self configView];
}

- (void)tradeAction:(UIButton *)sender{
    [self endEditing:YES];
    if ([UserModel isLogin]==NO) {
        [CFDJumpUtil jumpToLogin];
        return;
    }
    WEAK_SELF;
    if ([GUIUtil decimalSubtract:weakSelf.model.balance num:weakSelf.model.margin].floatValue<0) {
        [DCAlert showAlert:@"" detail:CFDLocalizedString(@"可用余额不足，请入金后下单") sureTitle:CFDLocalizedString(@"立即入金") sureHander:^{
            [CFDJumpUtil jumpToDeposit:@"USDT"];
        } cancelTitle:CFDLocalizedString(@"取消") cancelHander:^{
            
        }];
    }else{
        NSString *content = @"";
        if ([weakSelf.model.ordertype isEqualToString:@"2"]) {
            content = [NSString stringWithFormat:CFDLocalizedString(@"确定市价%@%@手%@吗？"),[weakSelf.model.bstype isEqualToString:@"1"]?CFDLocalizedString(@"买入"):CFDLocalizedString(@"卖出"),weakSelf.model.delegateAmount,weakSelf.model.contractname];
        }else{
            content = [NSString stringWithFormat:CFDLocalizedString(@"确定限价%@%@手%@吗？"),[weakSelf.model.bstype isEqualToString:@"1"]?CFDLocalizedString(@"买入"):CFDLocalizedString(@"卖出"),weakSelf.model.delegateAmount,weakSelf.model.contractname];
        }
        [DCAlert showAlert:@"" detail:content sureTitle:CFDLocalizedString(@"确定") sureHander:^{
            [weakSelf orderAction];
        } cancelTitle:CFDLocalizedString(@"取消") cancelHander:^{
            
        }];   
    }
    
}

- (void)orderAction{
    if (_model.isLoaded==NO||![_model.cantrade isEqualToString:@"1"]) {
        return;
    }
    if (_model.delegateAmount.integerValue<=0) {
        [HUDUtil showInfo:CFDLocalizedString(@"请输入委托数量")];
        return;
    }
    if ([_model.ordertype isEqualToString:@"1"]&&_model.openPrice.length<=0) {
        [HUDUtil showInfo:CFDLocalizedString(@"请输入委托价格")];
        return;
    }
    if (_model.perFee.floatValue<0) {
        [HUDUtil showInfo:CFDLocalizedString(@"参数错误，请刷新再试")];
        return;
    }
    WEAK_SELF;
    [HUDUtil showProgress:@""];
    BOOL isMarket = _marketBtn.isSelected;
    [DCService orderSymbol:_model.symbol bstype:_model.bstype ordertype:_model.ordertype price:_model.openPrice quantity:_model.delegateAmount pry:_model.pry slPrecent:_model.slPrecent tpPrecent:_model.tpPrecent tradefee:_model.fee margin:_model.margin success:^(id data) {
        
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [HUDUtil showInfo:CFDLocalizedString(@"下单成功")];
            if (isMarket) {
                weakSelf.reloadPosHander();
            }else{
                weakSelf.reloadEntrustHander();
            }
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

//MARK: - Getter

- (BaseBtn *)marketBtn{
    if (!_marketBtn) {
        _marketBtn = [[BaseBtn alloc] init];
        _marketBtn.titleLabel.font = [GUIUtil fitFont:14];
        [_marketBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_marketBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        _marketBtn.txColor = C2_ColorType;
        _marketBtn.textBlock = CFDLocalizedStringBlock(@"市价单");
        [_marketBtn  setImage:[GColorUtil imageNamed:@"public_icon_selno"] forState:UIControlStateNormal];
        [_marketBtn  setImage:[GColorUtil imageNamed:@"public_icon_selyes"] forState:UIControlStateSelected];
        [_marketBtn addTarget:self action:@selector(tradeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _marketBtn;
}

- (BaseBtn *)helpMarketBtn{
    if (!_helpMarketBtn) {
        _helpMarketBtn = [[BaseBtn alloc] init];
        _helpMarketBtn.imageName = @"public_icon_shape";
        [_helpMarketBtn addTarget:self action:@selector(helpMarketAction) forControlEvents:UIControlEventTouchUpInside];
        [_helpMarketBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _helpMarketBtn;
}
- (BaseBtn *)limitBtn{
    if (!_limitBtn) {
        _limitBtn = [[BaseBtn alloc] init];
        _limitBtn.titleLabel.font = [GUIUtil fitFont:14];
        [_limitBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [_limitBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 5)];
        _limitBtn.txColor = C2_ColorType;
        _limitBtn.textBlock = CFDLocalizedStringBlock(@"限价单");
        [_limitBtn  setImage:[GColorUtil imageNamed:@"public_icon_selno"] forState:UIControlStateNormal];
        [_limitBtn  setImage:[GColorUtil imageNamed:@"public_icon_selyes"] forState:UIControlStateSelected];
        [_limitBtn addTarget:self action:@selector(tradeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _limitBtn;
}
- (BaseBtn *)helpLimitBtn{
    if (!_helpLimitBtn) {
        _helpLimitBtn = [[BaseBtn alloc] init];
        _helpLimitBtn.imageName = @"public_icon_shape";
        [_helpLimitBtn addTarget:self action:@selector(helpLimitAction) forControlEvents:UIControlEventTouchUpInside];
        [_helpLimitBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _helpLimitBtn;
}
- (InputView *)priceView{
    if (!_priceView) {
        _priceView = [[InputView alloc] initWithType:InputTypeNone];
        [_priceView configView:@{@"title":CFDLocalizedString(@"价格"),@"placeholder":CFDLocalizedString(@"市场最优价成交")}];
        [_priceView.textField addToolbar];
        WEAK_SELF;
        _priceView.textChangedHander = ^{
            weakSelf.model.openPrice = weakSelf.priceView.textField.text;
            [weakSelf.model calData];
            [weakSelf updateViewPriceChanged];
            weakSelf.enableEdit = NO;
        };
        _priceView.enableBecomeFirstRespondHander = ^BOOL{
            return weakSelf.model.isLoaded&&[weakSelf.model.ordertype isEqualToString:@"1"];
        };
    }
    return _priceView;
}
- (InputView *)amountView{
    if (!_amountView) {
        _amountView = [[InputView alloc] initWithType:InputTypeAddSub];
        [_amountView configView:@{@"title":CFDLocalizedString(@"数量")}];
        [_amountView.textField addToolbar];
        WEAK_SELF;
        _amountView.textChangedHander = ^{
            weakSelf.model.delegateAmount = weakSelf.amountView.textField.text;
            [weakSelf.model calData];
            [weakSelf configView];
        };
        _amountView.enableBecomeFirstRespondHander = ^BOOL{
            return weakSelf.model.isLoaded;
        };
    }
    return _amountView;
}
- (InputView *)pryView{
    if (!_pryView) {
        _pryView = [[InputView alloc] initWithType:InputTypeSelected];
        [_pryView configView:@{@"title":CFDLocalizedString(@"杠杆")}];
        _pryView.textField.inputView = self.keyBoard1View;
        
        WEAK_SELF;
        _pryView.enableBecomeFirstRespondHander = ^BOOL{
            [weakSelf.keyBoard1View configView:OrderKeyBoardTypePryBr list:weakSelf.model.pryList selData:weakSelf.model.pry price:weakSelf.model.openPrice];
            weakSelf.keyBoard1View.dotnum = weakSelf.model.dotNum;
            weakSelf.keyBoard1View.height = [OrderKeyBoardView heightOfView:OrderKeyBoardTypePryBr];
            weakSelf.pryView.textField.inputView = weakSelf.keyBoard1View;
            return weakSelf.model.isLoaded;
        };
    }
    return _pryView;
}
- (InputView *)tpView{
    if (!_tpView) {
        _tpView = [[InputView alloc] initWithType:InputTypeSelected];
        [_tpView configView:@{@"title":CFDLocalizedString(@"止盈")}];
        _tpView.textField.inputView = self.keyBoardView;
        WEAK_SELF;
        _tpView.enableBecomeFirstRespondHander = ^BOOL{
            [weakSelf.keyBoardView configView:OrderKeyBoardTypeTP list:weakSelf.model.tpPrecentList selData:weakSelf.model.tpPrecent price:weakSelf.model.openPrice];
            weakSelf.keyBoardView.dotnum = weakSelf.model.dotNum;
            weakSelf.keyBoardView.height = [OrderKeyBoardView heightOfView:OrderKeyBoardTypeTP];
            weakSelf.keyBoardView.bstype = weakSelf.model.bstype;
            weakSelf.tpView.textField.inputView = weakSelf.keyBoardView;
            return weakSelf.model.isLoaded;
        };
    }
    return _tpView;
}
- (InputView *)slView{
    if (!_slView) {
        _slView = [[InputView alloc] initWithType:InputTypeSelected];
        [_slView configView:@{@"title":CFDLocalizedString(@"止损")}];
        _slView.textField.inputView = self.keyBoardView;
        WEAK_SELF;
        _slView.enableBecomeFirstRespondHander = ^BOOL{
            [weakSelf.keyBoardView configView:OrderKeyBoardTypeSl list:weakSelf.model.slPrecentList selData:weakSelf.model.slPrecent price:weakSelf.model.openPrice];
            weakSelf.keyBoardView.dotnum = weakSelf.model.dotNum;
            weakSelf.keyBoardView.height = [OrderKeyBoardView heightOfView:OrderKeyBoardTypeSl];
            weakSelf.keyBoardView.bstype = weakSelf.model.bstype;
            weakSelf.slView.textField.inputView = weakSelf.keyBoardView;
            return weakSelf.model.isLoaded;
        };
    }
    return _slView;
}
- (BaseLabel *)balanceLabel{
    if (!_balanceLabel) {
        _balanceLabel = [[BaseLabel alloc] init];
        _balanceLabel.txColor = C3_ColorType;
        _balanceLabel.font = [GUIUtil fitFont:12];
        _balanceLabel.text = [NSString stringWithFormat:@"%@  --USDT",CFDLocalizedString(@"可用余额")];
    }
    return _balanceLabel;
}
- (BaseLabel *)entrustValueLabel{
    if (!_entrustValueLabel) {
        _entrustValueLabel = [[BaseLabel alloc] init];
        _entrustValueLabel.txColor = C3_ColorType;
        _entrustValueLabel.font = [GUIUtil fitFont:12];
        _entrustValueLabel.text = [NSString stringWithFormat:@"%@  --",CFDLocalizedString(@"委托价值")];
        
    }
    return _entrustValueLabel;
}
- (BaseLabel *)marginLabel{
    if (!_marginLabel) {
        _marginLabel = [[BaseLabel alloc] init];
        _marginLabel.txColor = C3_ColorType;
        _marginLabel.font = [GUIUtil fitFont:12];
        _marginLabel.text = [NSString stringWithFormat:@"%@  --",CFDLocalizedString(@"预估保证金")];
    }
    return _marginLabel;
}
- (BaseBtn *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [[BaseBtn alloc] init];
        _buyBtn.titleLabel.font = [GUIUtil fitFont:14];
        _buyBtn.textBlock = CFDLocalizedStringBlock(@"买入");
        _buyBtn.txColor = C5_ColorType;
        
        [_buyBtn addTarget:self action:@selector(changeTradeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buyBtn;
}
- (BaseBtn *)sellBtn{
    if (!_sellBtn) {
        _sellBtn = [[BaseBtn alloc] init];
        _sellBtn.titleLabel.font = [GUIUtil fitFont:14];
        _sellBtn.textBlock = CFDLocalizedStringBlock(@"卖出");
        _sellBtn.txColor = C5_ColorType;
        
        [_sellBtn addTarget:self action:@selector(changeTradeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sellBtn;
}

- (BaseBtn *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [[BaseBtn alloc] init];
        _commitBtn.titleLabel.font = [GUIUtil fitFont:12];
        [_commitBtn setTitle:@"--" forState:UIControlStateNormal];
        _commitBtn.txColor = C5_ColorType;
        [_commitBtn addTarget:self action:@selector(tradeAction:) forControlEvents:UIControlEventTouchUpInside];
        _commitBtn.layer.cornerRadius = 2;
        _commitBtn.layer.masksToBounds = YES;
    }
    return _commitBtn;
}

- (OrderKeyBoardView *)keyBoardView{
    if (!_keyBoardView) {
        _keyBoardView = [[OrderKeyBoardView alloc] init];
        _keyBoardView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [OrderKeyBoardView heightOfView:OrderKeyBoardTypeSl]);
        WEAK_SELF;
        _keyBoardView.didSelelectedRow = ^(NSDictionary * _Nonnull dic, OrderKeyBoardType type) {
            if (type==OrderKeyBoardTypeTP) {
                weakSelf.model.tpPrecent = [NDataUtil stringWith:dic[@"data"]];
            }else if (type==OrderKeyBoardTypeSl){
                weakSelf.model.slPrecent = [NDataUtil stringWith:dic[@"data"]];
            }else if (type==OrderKeyBoardTypePryBr){
                weakSelf.model.pry = [NDataUtil stringWith:dic[@"data"]];
            }
            [weakSelf.model calData];
            [weakSelf configView];
            [weakSelf endEditing:YES];
        };
        _keyBoardView.calSLTPData = ^NSDictionary * _Nonnull(NSString * _Nonnull precent, BOOL isSl) {
            if (isSl) {
                return [weakSelf.model calSLData:precent];
            }else{
                return [weakSelf.model calTPData:precent];
            }
        };
    }
    return _keyBoardView;
}

- (OrderKeyBoardView *)keyBoard1View{
    if (!_keyBoard1View) {
        _keyBoard1View = [[OrderKeyBoardView alloc] init];
        _keyBoard1View.frame = CGRectMake(0, 0, SCREEN_WIDTH, [OrderKeyBoardView heightOfView:OrderKeyBoardTypeSl]);
        WEAK_SELF;
        _keyBoard1View.didSelelectedRow = ^(NSDictionary * _Nonnull dic, OrderKeyBoardType type) {
            if (type==OrderKeyBoardTypePryBr){
                weakSelf.model.pry = [NDataUtil stringWith:dic[@"data"]];
            }
            [weakSelf.model calData];
            [weakSelf configView];
            [weakSelf endEditing:YES];
        };
        _keyBoard1View.calSLTPData = ^NSDictionary * _Nonnull(NSString * _Nonnull precent, BOOL isSl) {
            return @{};
        };
    }
    return _keyBoard1View;
}


- (void)themeChangedAction{
    [self base_themeChangedAction];
    if([CFDApp sharedInstance].isRed){
        _buyBtn.bgImageName = @"trade_btn_buy_gray";
        _buyBtn.bgImageName_sel = @"trade_btn_red";
        _sellBtn.bgImageName = @"trade_btn_gray";
        _sellBtn.bgImageName_sel = @"trade_btn_green";
        
    }else{
        _buyBtn.bgImageName = @"trade_btn_buy_gray";
        _buyBtn.bgImageName_sel = @"trade_btn_buy_green";
        _sellBtn.bgImageName = @"trade_btn_gray";
        _sellBtn.bgImageName_sel = @"trade_btn_sell_red";
    }
    _commitBtn.backgroundColor = _buyBtn.selected?[GColorUtil C11]:[GColorUtil C12];
}

- (void)addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
    [center addObserver:self
               selector:@selector(themeChangedAction)
                   name:ThemeDidChangedNotification
                 object:nil];
}


@end

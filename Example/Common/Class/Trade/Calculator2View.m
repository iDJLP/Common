//
//  Calculator2View.m
//  Bitmixs
//
//  Created by ngw15 on 2019/9/11.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "Calculator2View.h"
#import "CalculatorRow.h"
#import "BaseBtn.h"
#import "SetCountView.h"

@interface Calculator2View ()

@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)CalculatorRow *row1;
@property (nonatomic,strong)CalculatorRow *row2;
@property (nonatomic,strong)CalculatorRow *row3;

@property (nonatomic,strong)UIView *bottomView;
@property (nonatomic,strong)BaseBtn *buyBtn;
@property (nonatomic,strong)BaseBtn *sellBtn;
@property (nonatomic,strong)UILabel *pryTitle;
@property (nonatomic,strong)SetCountView *pryText;
@property (nonatomic,strong)UIView *pryLine;
@property (nonatomic,strong)CalculatorRow *fieldRow1;
@property (nonatomic,strong)CalculatorRow *fieldRow2;
@property (nonatomic,strong)CalculatorRow *fieldRow3;

@property (nonatomic,strong)BaseBtn *resetBtn;
@property (nonatomic,strong)BaseBtn *calculatorBtn;

@property (nonatomic,assign)BOOL enableEdit;
@property (nonatomic,copy)NSString *scale;
@property (nonatomic,copy)NSString *dotNum;
@property (nonatomic,copy)NSString *pry;
@end

@implementation Calculator2View

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _enableEdit = YES;
        self.backgroundColor = [GColorUtil C8];
        self.showsVerticalScrollIndicator = NO;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)willAppear{
    
}

- (void)setupUI{
    [self addSubview:self.topView];
    [self addSubview:self.bottomView];
    [self addSubview:self.resetBtn];
    [self addSubview:self.calculatorBtn];
    [self.topView addSubview:self.row1];
    [self.topView addSubview:self.row2];
    [self.topView addSubview:self.row3];
    
    [self.bottomView addSubview:self.buyBtn];
    [self.bottomView addSubview:self.sellBtn];
    [self.bottomView addSubview:self.pryTitle];
    [self.bottomView addSubview:self.pryText];
    [self.bottomView addSubview:self.pryLine];
    [self.bottomView addSubview:self.fieldRow1];
    [self.bottomView addSubview:self.fieldRow2];
    [self.bottomView addSubview:self.fieldRow3];
}

- (void)autoLayout{
    
    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:0]);
        make.top.mas_equalTo([GUIUtil fit:7]);
        make.size.mas_equalTo([GUIUtil fitWidth:375 height:150]);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:0]);
        make.top.equalTo(self.topView.mas_bottom).mas_offset([GUIUtil fit:7]);
        make.size.mas_equalTo([GUIUtil fitWidth:375 height:260]);
    }];
    [self.resetBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.equalTo(self.bottomView.mas_bottom).mas_offset([GUIUtil fit:20]);
        make.size.mas_equalTo([GUIUtil fitWidth:165 height:43]);
    }];
    [self.calculatorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.resetBtn.mas_right).mas_offset([GUIUtil fit:15]);
        make.top.equalTo(self.bottomView.mas_bottom).mas_offset([GUIUtil fit:20]);
        make.size.mas_equalTo([GUIUtil fitWidth:165 height:43]);
        CGFloat height = [GUIUtil fit:50]*7+[GUIUtil fit:60]+[GUIUtil fit:7]*2+[GUIUtil fit:110]+TOP_BAR_HEIGHT+IPHONE_X_BOTTOM_HEIGHT;
        make.bottom.mas_equalTo(-SCREEN_HEIGHT+height-[GUIUtil fit:20]);
    }];
    [self.row1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo([GUIUtil fit:0]);
        make.size.mas_equalTo([GUIUtil fitWidth:375 height:50]);
    }];
    [self.row2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.row1.mas_bottom);
        make.left.mas_equalTo([GUIUtil fit:0]);
        make.size.mas_equalTo([GUIUtil fitWidth:375 height:50]);
    }];
    [self.row3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.row2.mas_bottom);
        make.left.mas_equalTo([GUIUtil fit:0]);
        make.size.mas_equalTo([GUIUtil fitWidth:375 height:50]);
    }];
    
    [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.mas_equalTo([GUIUtil fit:15]);
        make.size.mas_equalTo([GUIUtil fitWidth:177 height:30]);
    }];
    [self.sellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.buyBtn.mas_right).mas_offset([GUIUtil fit:-8]);
        make.top.equalTo(self.buyBtn);
        make.size.mas_equalTo([GUIUtil fitWidth:177 height:30]);
    }];
    [self.pryTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.mas_equalTo([GUIUtil fit:60]);
        make.height.mas_equalTo([GUIUtil fit:50]);
    }];
    [self.pryText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.pryTitle);
        make.right.equalTo(self.mas_left).mas_offset([GUIUtil fit:360]);
        make.height.mas_equalTo([GUIUtil fit:50]);
    }];
    [self.pryLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.bottom.mas_equalTo(self.pryTitle.mas_bottom);
        make.height.mas_equalTo([GUIUtil fitLine]);
        make.width.mas_equalTo([GUIUtil fit:345]);
    }];
    [self.fieldRow1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:0]);
        make.top.mas_equalTo(self.pryTitle.mas_bottom);
        make.size.mas_equalTo([GUIUtil fitWidth:375 height:50]);
    }];
    [self.fieldRow2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:0]);
        make.top.mas_equalTo(self.fieldRow1.mas_bottom);
        make.size.mas_equalTo([GUIUtil fitWidth:375 height:50]);
    }];
    [self.fieldRow3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:0]);
        make.top.mas_equalTo(self.fieldRow2.mas_bottom);
        make.size.mas_equalTo([GUIUtil fitWidth:375 height:50]);
    }];
    
}

- (void)updatePrice:(NSDictionary *)dic{
    return;
    if (_enableEdit) {
        _enableEdit = NO;
        NSString *price = _buyBtn.isSelected?dic[@"bidPrice"]:dic[@"askPrice"];
        NSDictionary *openDic = @{@"title":CFDLocalizedString(@"开仓价格（USDT）"),@"text":price,@"placehoder":CFDLocalizedString(@"请输入开仓价格")};
        [_fieldRow1 configView:openDic];
    }
}
- (void)configView:(NSDictionary *)dict{
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
    _dotNum = [NDataUtil stringWith:dict[@"dotNum"] valid:@"1"];
    _scale = dict[@"scale"];
    NSString *title = [NDataUtil stringWith:dict[@"title"]];
    _pryTitle.text = CFDLocalizedString(@"杠杆倍数_calcutor");
    NSDictionary *typeDic = @{@"title":CFDLocalizedString(@"合约类型"),@"text":title};
    [_row1 configView:typeDic];
    NSString *minfloat = [NDataUtil stringWith:dict[@"minfloat"]];
    _fieldRow1.minFloat = minfloat;
    _fieldRow2.minFloat = @"1";
    _fieldRow3.minFloat = @"0.01";
    NSArray *list = dict[@"pryList"];
    [_pryText updateData:list];
    [self resetAction];
}


- (void)calculatorAction{
    //校验计算的条件
    {
        if (_fieldRow1.text.length<=0) {
            [HUDUtil showInfo:CFDLocalizedString(@"请输入开仓价格")];
            return;
        }
        if (_fieldRow2.text.length<=0) {
            [HUDUtil showInfo:CFDLocalizedString(@"请输入平仓数量")];
            return;
        }
        if (_fieldRow3.text.length<=0) {
            [HUDUtil showInfo:CFDLocalizedString(@"请输入收益率")];
            return;
        }
    }
    //计算
    [self calculatorHander];
}

- (void)calculatorHander{
    NSString *open = _fieldRow1.text;
    NSString *amount = _fieldRow2.text;
    NSString *profitRate = _fieldRow3.text;
    
    NSString *value = [GUIUtil decimalMultiply:amount num:_scale] ;
    NSString *finalValue = [GUIUtil decimalMultiply:open num:value];
    finalValue = [GUIUtil notRoundingString:finalValue afterPoint:4];
    NSString * margin = [GUIUtil decimalDivide:finalValue num:_pry];
    margin = [GUIUtil notRoundingString:margin afterPoint:4];
    
    profitRate = [GUIUtil decimalMultiply:profitRate num:@"0.01"];
    NSString *profit = [GUIUtil decimalMultiply:profitRate num:margin];
    NSString *price = [GUIUtil decimalDivide:profit num:value];
    if (_buyBtn.selected==YES) {
        price = [GUIUtil decimalMultiply:price num:@"-1"];
    }
    NSString *close = [GUIUtil decimalSubtract:open num:price];
    close = [GUIUtil notRoundingString:close afterPoint:[_dotNum integerValue]];
    NSDictionary *marginDic = @{@"title":CFDLocalizedString(@"开仓保证金（USDT）"),@"text":margin};
    NSDictionary *profitDic = @{@"title":CFDLocalizedString(@"平仓价格（USDT）"),@"text":close};
    [_row2 configView:marginDic];
    [_row3 configView:profitDic];
    _enableEdit = NO;
}

- (void)resetAction{
    NSDictionary *marginDic = @{@"title":CFDLocalizedString(@"开仓保证金（USDT）"),@"text":@"",@"placehoder":@"--"};
    NSDictionary *closeDic = @{@"title":CFDLocalizedString(@"平仓价格（USDT）"),@"text":@"",@"placehoder":@"--"};
    NSDictionary *openDic = @{@"title":CFDLocalizedString(@"开仓价格（USDT）"),@"text":@"",@"placehoder":CFDLocalizedString(@"请输入开仓价格")};
    NSDictionary *amountDic = @{@"title":CFDLocalizedString(@"开仓数量（手）"),@"text":@"",@"placehoder":CFDLocalizedString(@"请输入开仓数量")};
    NSDictionary *profitDic = @{@"title":CFDLocalizedString(@"收益率（%）"),@"text":@"",@"placehoder":CFDLocalizedString(@"请输入收益率")};
    [_row2 configView:marginDic];
    [_row3 configView:closeDic];
    [_fieldRow1 configView:openDic];
    [_fieldRow2 configView:amountDic];
    [_fieldRow3 configView:profitDic];
    [_pryText setSelectedIndex:_pryText.dataList.count-1];
    _enableEdit = YES;
}

- (UITextField *)firstRespondField{
    if (_fieldRow1.firstRespondField) {
        return _fieldRow1.firstRespondField;
    }
    if (_fieldRow2.firstRespondField) {
        return _fieldRow2.firstRespondField;
    }
    if (_fieldRow3.firstRespondField) {
        return _fieldRow3.firstRespondField;
    }
    return nil;
}

- (void)changeTradeTypeAction:(UIButton *)sender{
    if (sender.isSelected) {
        return;
    }
    sender.selected = YES;
    if (sender == _buyBtn) {
        _sellBtn.selected = NO;
    }else if (sender == _sellBtn){
        _buyBtn.selected = NO;
    }
    
}

//MARK: - Getter

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [GColorUtil C6];
    }
    return _topView;
}

- (UIView *)bottomView{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [GColorUtil C6];
    }
    return _bottomView;
}

- (BaseBtn *)buyBtn{
    if (!_buyBtn) {
        _buyBtn = [[BaseBtn alloc] init];
        _buyBtn.titleLabel.font = [GUIUtil fitFont:14];
        _buyBtn.textBlock = CFDLocalizedStringBlock(@"买入");
        _buyBtn.txColor = C5_ColorType;
        [_buyBtn addTarget:self action:@selector(changeTradeTypeAction:) forControlEvents:UIControlEventTouchUpInside];
        _buyBtn.selected = YES;
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

- (BaseBtn *)resetBtn{
    if (!_resetBtn) {
        _resetBtn = [[BaseBtn alloc] init];
        _resetBtn.titleLabel.font = [GUIUtil fitFont:16];
        [_resetBtn setTitle:CFDLocalizedString(@"重置") forState:UIControlStateNormal];
        _resetBtn.txColor = C13_ColorType;
        [_resetBtn addTarget:self action:@selector(resetAction) forControlEvents:UIControlEventTouchUpInside];
        _resetBtn.layer.borderWidth = [GUIUtil fitLine]*2;
        _resetBtn.layer.borderColor = [GColorUtil C13].CGColor;
        _resetBtn.layer.cornerRadius = [GUIUtil fit:4];
        _resetBtn.layer.masksToBounds = YES;
    }
    return _resetBtn;
}
- (BaseBtn *)calculatorBtn{
    if (!_calculatorBtn) {
        _calculatorBtn = [[BaseBtn alloc] init];
        _calculatorBtn.backgroundColor = [GColorUtil C13];
        _calculatorBtn.titleLabel.font = [GUIUtil fitFont:14];
        [_calculatorBtn setTitle:CFDLocalizedString(@"计算") forState:UIControlStateNormal];
        _calculatorBtn.txColor = C5_ColorType;
        [_calculatorBtn addTarget:self action:@selector(calculatorAction) forControlEvents:UIControlEventTouchUpInside];
        _calculatorBtn.layer.cornerRadius = [GUIUtil fit:4];
        _calculatorBtn.layer.masksToBounds = YES;
    }
    return _calculatorBtn;
}

- (CalculatorRow *)row1{
    if (!_row1) {
        _row1 = [[CalculatorRow alloc] init];
        _row1.isRightLabel = YES;
    }
    return _row1;
}

- (CalculatorRow *)row2{
    if (!_row2) {
        _row2 = [[CalculatorRow alloc] init];
        _row2.isRightLabel = YES;
    }
    return _row2;
}

- (CalculatorRow *)row3{
    if (!_row3) {
        _row3 = [[CalculatorRow alloc] init];
        _row3.isRightLabel = YES;
    }
    return _row3;
}

- (UILabel *)pryTitle{
    if (!_pryTitle) {
        _pryTitle = [[UILabel alloc] init];
        _pryTitle.textColor = [GColorUtil C2];
        _pryTitle.font = [GUIUtil fitFont:16];
        
    }
    return _pryTitle;
}

- (SetCountView *)pryText{
    if (!_pryText) {
        _pryText = [[SetCountView alloc] init];
        WEAK_SELF;
        _pryText.setCountBlock = ^(NSDictionary *data) {
            weakSelf.pry = [NDataUtil stringWith:data[@"data"]];
        };
    }
    return _pryText;
}

- (UIView *)pryLine{
    if (!_pryLine) {
        _pryLine = [[UIView alloc] init];
        _pryLine.backgroundColor = [GColorUtil C7];
    }
    return _pryLine;
}

- (CalculatorRow *)fieldRow1{
    if (!_fieldRow1) {
        _fieldRow1 = [[CalculatorRow alloc] init];
        _fieldRow1.isRightLabel = NO;
        _fieldRow1.textField.keyboardType = UIKeyboardTypeDecimalPad;
        WEAK_SELF;
        [_fieldRow1.textField addToolBarDoneAndSwitch:^void(BOOL isNext) {
            if (isNext) {
                [weakSelf.fieldRow2.textField becomeFirstResponder];
            }
        } nextEnable:YES prevEnable:NO];
        _fieldRow1.textChangedHander = ^{
            weakSelf.enableEdit = NO;
        };
    }
    return _fieldRow1;
}

- (CalculatorRow *)fieldRow2{
    if (!_fieldRow2) {
        _fieldRow2 = [[CalculatorRow alloc] init];
        _fieldRow2.textField.keyboardType = UIKeyboardTypeNumberPad;
        _fieldRow2.isRightLabel = NO;
        WEAK_SELF;
        [_fieldRow2.textField addToolBarDoneAndSwitch:^void(BOOL isNext) {
            if (isNext) {
                [weakSelf.fieldRow3.textField becomeFirstResponder];
            }else{
                [weakSelf.fieldRow1.textField becomeFirstResponder];
            }
        } nextEnable:YES prevEnable:YES];
    }
    return _fieldRow2;
}

- (CalculatorRow *)fieldRow3{
    if (!_fieldRow3) {
        _fieldRow3 = [[CalculatorRow alloc] init];
        _fieldRow3.textField.keyboardType = UIKeyboardTypeDecimalPad;

        _fieldRow3.isRightLabel = NO;
        WEAK_SELF;
        [_fieldRow3.textField addToolBarDoneAndSwitch:^void(BOOL isNext) {
            if (isNext==NO) {
                [weakSelf.fieldRow2.textField becomeFirstResponder];
            }
        } nextEnable:NO prevEnable:YES];
    }
    return _fieldRow3;
}

@end

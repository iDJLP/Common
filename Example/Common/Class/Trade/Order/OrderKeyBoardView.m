//
//  OrderKeyBoardView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/22.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "OrderKeyBoardView.h"
#import "BaseLabel.h"
#import "BaseImageView.h"
#import "BaseView.h"
#import "BaseBtn.h"
#import "BasePickerView.h"

@interface OrderKeyBoardView ()<UIPickerViewDelegate,UIPickerViewDataSource>

@property (nonatomic,strong)BaseLabel *nameLabel;
@property (nonatomic,strong)BaseLabel *profitLabel;
@property (nonatomic,strong)BaseView *nameLine;
@property (nonatomic,strong)BaseLabel *titleLabel;
@property (nonatomic,strong)BaseLabel *remarkLabel;
@property (nonatomic,strong) BasePickerView *pickerView;
@property (nonatomic,strong)BaseLabel *pointText;
@property (nonatomic,strong)BaseLabel *pointTitle;
@property (nonatomic,strong)BaseLabel *priceText;
@property (nonatomic,strong)BaseLabel *priceTitle;
@property (nonatomic,strong)BaseLabel *minusPriceText;
@property (nonatomic,strong)BaseLabel *minusPriceTitle;
@property (nonatomic,strong)BaseLabel *valueText;
@property (nonatomic,strong)BaseLabel *valueTitle;
@property (nonatomic,strong)BaseView *lineView;
@property (nonatomic,strong)BaseBtn *commitBtn;

@property (nonatomic,strong) NSArray *pickerList;
@property (nonatomic,assign) OrderKeyBoardType type;
@property (nonatomic,strong) NSDictionary *calDic;

@property (nonatomic,strong) MASConstraint *masTitleTop;
@end

@implementation OrderKeyBoardView

+ (CGFloat)heightOfView:(OrderKeyBoardType)type{
    CGFloat height = [GUIUtil fit:45]+[GUIUtil fit:5]+[GUIUtil fit:174]+[GUIUtil fit:10]+[GUIUtil fit:50]+IPHONE_X_BOTTOM_HEIGHT;
    if (type==OrderKeyBoardTypeSl||type==OrderKeyBoardTypeTP) {
        height += [GUIUtil fit:20]+[GUIUtil fitFont:12].lineHeight+[GUIUtil fit:5]+[GUIUtil fitFont:12].lineHeight;
    }
    return ceil(height);
}

- (void)dealloc{
    [self removeNotic];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.bgColor = C15_ColorType;
        [self setupUI];
        [self autoLayout];
        [self addNotic];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.nameLabel];
    [self addSubview:self.profitLabel];
    [self addSubview:self.nameLine];
    [self addSubview:self.titleLabel];
    [self addSubview:self.remarkLabel];
    [self addSubview:self.pickerView];
    [self addSubview:self.pointText];
    [self addSubview:self.pointTitle];
    [self addSubview:self.priceText];
    [self addSubview:self.priceTitle];
    [self addSubview:self.minusPriceText];
    [self addSubview:self.minusPriceTitle];
    [self addSubview:self.valueText];
    [self addSubview:self.valueTitle];
    [self addSubview:self.commitBtn];
    [self addSubview:self.lineView];
}

- (void)autoLayout{
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:45]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [_profitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:45]);
    }];
    [_nameLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.nameLabel);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        self.masTitleTop = make.top.mas_equalTo(0);
        make.top.mas_equalTo([GUIUtil fit:45]).priority(750);
        make.height.mas_equalTo([GUIUtil fit:45]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.height.mas_equalTo([GUIUtil fit:45]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
    }];
    [_pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel).mas_offset([GUIUtil fit:40]);
        make.height.mas_equalTo([GUIUtil fit:195]);
        make.left.mas_equalTo([GUIUtil fit:0]);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [_pointText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pickerView.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [_pointTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pointText.mas_bottom).mas_offset([GUIUtil fit:5]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [_priceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pointText);
        make.centerX.mas_equalTo(0);
    }];
    [_priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pointTitle);
        make.centerX.equalTo(self.priceText);
    }];
    [_minusPriceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pointText);
        make.centerX.mas_equalTo(0);
    }];
    [_minusPriceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pointTitle);
        make.centerX.equalTo(self.minusPriceText);
    }];
    [_valueText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pointText);
        make.right.mas_equalTo([GUIUtil fit:-15]);
    }];
    [_valueTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pointTitle);
        make.right.equalTo(self.valueText);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.commitBtn.mas_top);
        make.height.mas_equalTo([GUIUtil fit:5]);
    }];
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-IPHONE_X_BOTTOM_HEIGHT);
        make.height.mas_equalTo([GUIUtil fit:40]);
        make.left.right.mas_equalTo([GUIUtil fit:0]);
    }];
}

- (void)addNotic{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
}

- (void)removeNotic{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)keyboardWillShow{
    if (self.window!=nil) {
        UIView *bg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        bg.backgroundColor = [GColorUtil colorWithBlackColorType:C6_ColorType alpha:0.2];
        bg.tag = OtherTagKeyboard;
        bg.alpha=0;
        __weak typeof(bg) weakBg = bg;
        [bg g_clickBlock:^(UITapGestureRecognizer *tap) {
            [[GJumpUtil window] endEditing:YES];
            [UIView animateWithDuration:0.25 animations:^{
                weakBg.alpha=0;
            } completion:^(BOOL finished) {
                [weakBg removeFromSuperview];
            }];
        }];
        [[GJumpUtil window] addSubview:bg];
        [UIView animateWithDuration:0.25 animations:^{
            weakBg.alpha=1;
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)keyboardWillHide{
    UIView *bg = [[GJumpUtil window] viewWithTag:OtherTagKeyboard];
    __weak typeof(bg) weakBg = bg;
    [UIView animateWithDuration:0.25 animations:^{
        weakBg.alpha=0;
    } completion:^(BOOL finished) {
        [weakBg removeFromSuperview];
    }];
}

- (void)configView:(OrderKeyBoardType)type list:(NSArray *)dataList selData:(NSString *)data price:(NSString *)price{
    _pickerList = dataList;
    _type = type;
    if (type==OrderKeyBoardTypePryBr) {
        _titleLabel.text = CFDLocalizedString(@"选择杠杆倍数");
        _remarkLabel.hidden = NO;
        _valueText.text =
        _pointText.text =
        _priceText.text =
        _minusPriceText.text =
        _pointTitle.text =
        _priceTitle.text =
        _minusPriceTitle.text =
        _valueTitle.text = @"";
    }else if (type==OrderKeyBoardTypeTP){
        _remarkLabel.hidden = YES;
        _titleLabel.text = CFDLocalizedString(@"选择止盈比例");
        _pointTitle.text = CFDLocalizedString(@"止盈点数");
        _priceTitle.text = CFDLocalizedString(@"买入止盈价位");
        _minusPriceTitle.text = CFDLocalizedString(@"卖出止盈价位");
        _valueTitle.text = CFDLocalizedString(@"止盈金额");
        _pointText.textColor = [GColorUtil C11];
        _minusPriceText.textColor = [GColorUtil C11];
        _priceText.textColor = [GColorUtil C11];
        _valueText.textColor = [GColorUtil C11];
    }else if (type==OrderKeyBoardTypeSl){
        if ([data hasPrefix:@"-"]) {
            data = [data substringFromIndex:1];
        }
        _remarkLabel.hidden = YES;
        _titleLabel.text = CFDLocalizedString(@"选择止损比例");
        _pointTitle.text = CFDLocalizedString(@"止损点数");
        _priceTitle.text = CFDLocalizedString(@"买入止损价位");
        _minusPriceTitle.text = CFDLocalizedString(@"卖出止损价位");
        _valueTitle.text = CFDLocalizedString(@"止损金额");
        _pointText.textColor = [GColorUtil C12];
        _minusPriceText.textColor = [GColorUtil C12];
        _priceText.textColor = [GColorUtil C12];
        _valueText.textColor = [GColorUtil C12];
    }
    
    [_pickerView reloadAllComponents];
    NSInteger index = 0;
    for (NSDictionary *dic in dataList) {
        NSString *d = [NDataUtil stringWith:dic[@"data"]];
        if ([GUIUtil decimalSubtract:d num:data].floatValue==0) {
            index=[dataList indexOfObject:dic];
            break;
        }
    }
    [_pickerView selectRow:index inComponent:0 animated:NO];
    [self pickerView:_pickerView didSelectRow:index inComponent:0];
    _remarkLabel.text = [NSString stringWithFormat:@"%@%@%%",CFDLocalizedString(@"保证金率"),[GUIUtil decimalMultiply:@"100" num:[GUIUtil decimalDivide:@"1" num:data]]];
    if (_type==OrderKeyBoardTypeSl||_type==OrderKeyBoardTypeTP) {
        _calDic = _calSLTPData(data,_type==OrderKeyBoardTypeSl);
        [self updateView:_calDic];
    }
}

- (void)setConfig:(NSDictionary *)dict isEntrust:(BOOL)flag{
    _config = dict;
    if (flag==NO) {
        [_masTitleTop deactivate];
        BOOL isBuy = [NDataUtil boolWithDic:dict key:@"direction" isEqual:@"1"];
        NSString *contractname = [NDataUtil stringWith:dict[@"contractname"]];
        NSString *orderType = isBuy?CFDLocalizedString(@"买入"):CFDLocalizedString(@"卖出");
        
        NSString *quantity = [NDataUtil stringWith:dict[@"quantity"]];
        NSString *q = [GUIUtil equalValue:quantity with:@"1"]?CFDLocalizedString(@"手"):CFDLocalizedString(@"手_复数");
        NSString *str = [NSString stringWithFormat:@"%@   %@   %@%@",contractname,orderType,quantity,q];
        NSString *profit =[NDataUtil stringWith:dict[@"profit"]];
        NSString *profitNum = [NDataUtil stringWith:dict[@"profitnum"]];
        NSString *p = [GUIUtil equalValue:profitNum with:@"1"]?CFDLocalizedString(@"点"):CFDLocalizedString(@"点_复数");
        NSString *profitStr = [NSString stringWithFormat:@"%@(%@%@)",profit,profitNum,p];
        _nameLabel.text = str;
        _profitLabel.text = profitStr;
        _profitLabel.textColor = profit.floatValue>0?[GColorUtil C11]:[GColorUtil C12];
    }
}

- (void)changedProfit:(NSDictionary *)dict{
    NSString *profit =[NDataUtil stringWith:dict[@"profit"]];
    NSString *profitNum = [NDataUtil stringWith:dict[@"profitnum"]];
    NSString *p = [GUIUtil equalValue:profitNum with:@"1"]?CFDLocalizedString(@"点"):CFDLocalizedString(@"点_复数");
    NSString *profitStr = [NSString stringWithFormat:@"%@(%@%@)",profit,profitNum,p];
    _profitLabel.text = profitStr;
    _profitLabel.textColor = profit.floatValue>0?[GColorUtil C11]:[GColorUtil C12];
}

- (void)changedPrice:(NSString *)price{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSDictionary *dic = self.pickerList[[self.pickerView selectedRowInComponent:0]];
        NSString *data = [NDataUtil stringWith:dic[@"data"]];
        if (self.type==OrderKeyBoardTypeSl||self.type==OrderKeyBoardTypeTP) {
            self.calDic = self.calSLTPData(data,self.type==OrderKeyBoardTypeSl);
            [self updateView:self.calDic];
        }
    });
    
}

- (void)updateView:(NSDictionary *)dic{
    _pointText.text = dic[@"point"];
    _priceText.text = dic[@"price"];
    NSString *openPrice  = dic[@"openPrice"];
    _minusPriceText.text = dic[@"minusPrice"];
    _valueText.text = dic[@"value"];
    self.valueText.text = [GUIUtil notRoundingString:self.valueText.text afterPoint:4];
    NSString *difPrice = dic[@"difPrice"];
    if (self.type == OrderKeyBoardTypeSl) {
        self.priceText.text = [GUIUtil decimalSubtract:openPrice num:difPrice];
        self.minusPriceText.text = [GUIUtil decimalAdd:openPrice num:difPrice];
        self.priceText.text = [GUIUtil notRoundingString:self.priceText.text afterPoint:_dotnum];
        self.minusPriceText.text = [GUIUtil notRoundingString:self.minusPriceText.text afterPoint:_dotnum];
    }else if (self.type==OrderKeyBoardTypeTP){
        self.priceText.text = [GUIUtil decimalAdd:openPrice num:difPrice];
        self.minusPriceText.text = [GUIUtil decimalSubtract:openPrice num:difPrice];
        self.priceText.text = [GUIUtil notRoundingString:self.priceText.text afterPoint:_dotnum];
        self.minusPriceText.text = [GUIUtil notRoundingString:self.minusPriceText.text afterPoint:_dotnum];
    }
}

- (void)setBstype:(NSString *)bstype{
    BOOL isBuy = [bstype isEqualToString:@"1"];
    _priceText.hidden = _priceTitle.hidden = !isBuy;
    _minusPriceText.hidden = _minusPriceTitle.hidden = isBuy;
}

//MARK: - PickerDelegate

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _pickerList.count;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    if (!view){
        view = [[UIView alloc]init];
    }
    //隐藏上下直线
    [self.pickerView.subviews objectAtIndex:1].backgroundColor = [GColorUtil C7];
    [self.pickerView.subviews objectAtIndex:2].backgroundColor = [GColorUtil C7];
    
    NSDictionary *dic = _pickerList[row];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [GColorUtil C15];
    titleLabel.textColor = [GColorUtil C2];
    titleLabel.font = [GUIUtil fitFont:16];
    titleLabel.text = [NDataUtil stringWith:dic[@"showText"]];
    [view addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    return view;
}

//显示的标题字体、颜色等属性

- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *str = [[_pickerList objectAtIndex:row] objectForKey:@"showText"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:str];
    [attributedString addAttributes:@{NSFontAttributeName:[GUIUtil fitBoldFont:16], NSForegroundColorAttributeName:[GColorUtil C11]} range:NSMakeRange(0, [attributedString  length])];
    return attributedString;
    
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    NSDictionary *dic = _pickerList[row];
    return [NDataUtil stringWith:dic[@"showText"]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSDictionary *dic = _pickerList[row];
    NSString *data = [NDataUtil stringWith:dic[@"data"]];
    if (_type==OrderKeyBoardTypeSl||_type==OrderKeyBoardTypeTP) {
        _calDic = _calSLTPData(data,_type==OrderKeyBoardTypeSl);
        [self updateView:_calDic];
    }else{
        _remarkLabel.text = [NSString stringWithFormat:@"%@%@%%",CFDLocalizedString(@"保证金率"),[GUIUtil decimalMultiply:@"100" num:[GUIUtil decimalDivide:@"1" num:data]]];
    }
}

- (void)commitAction{
    NSDictionary *dic = _pickerList[[_pickerView selectedRowInComponent:0]];
    _didSelelectedRow(dic,_type);
}

//MARK: - Getter

- (BaseLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[BaseLabel alloc] init];
        _nameLabel.txColor = C2_ColorType;
        _nameLabel.font = [GUIUtil fitFont:14];
        _nameLabel.numberOfLines = 1;
    }
    return _nameLabel;
}

- (BaseLabel *)profitLabel{
    if (!_profitLabel) {
        _profitLabel = [[BaseLabel alloc] init];
        _profitLabel.txColor = C13_ColorType;
        _profitLabel.font = [GUIUtil fitFont:12];
        _profitLabel.numberOfLines = 1;
    }
    return _profitLabel;
}

- (BaseView *)nameLine{
    if (!_nameLine) {
        _nameLine = [[BaseView alloc] init];
        _nameLine.bgColor = C7_ColorType;
    }
    return _nameLine;
}

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.textColor = [GColorUtil C2];
        _titleLabel.font = [GUIUtil fitFont:14];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (BaseLabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[BaseLabel alloc] init];
        _remarkLabel.textColor = [GColorUtil C13];
        _remarkLabel.font = [GUIUtil fitFont:12];
        _remarkLabel.numberOfLines = 1;
    }
    return _remarkLabel;
}

- (BasePickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[BasePickerView alloc] initWithFrame:CGRectMake(0, [GUIUtil fit:97], SCREEN_WIDTH, [GUIUtil fit:175])];
        _pickerView.bgColor = C15_ColorType;
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
    }
    return _pickerView;
}

- (BaseLabel *)pointText{
    if (!_pointText) {
        _pointText = [[BaseLabel alloc] init];
        _pointText.txColor = C11_ColorType;
        _pointText.font = [GUIUtil fitFont:12];
        _pointText.numberOfLines = 1;
    }
    return _pointText;
}

- (BaseLabel *)pointTitle{
    if (!_pointTitle) {
        _pointTitle = [[BaseLabel alloc] init];
        _pointTitle.txColor = C3_ColorType;
        _pointTitle.font = [GUIUtil fitFont:12];
        _pointTitle.numberOfLines = 1;
    }
    return _pointTitle;
}

- (BaseLabel *)priceText{
    if (!_priceText) {
        _priceText = [[BaseLabel alloc] init];
        _priceText.txColor = C11_ColorType;
        _priceText.font = [GUIUtil fitFont:12];
        _priceText.numberOfLines = 1;
    }
    return _priceText;
}

- (BaseLabel *)priceTitle{
    if (!_priceTitle) {
        _priceTitle = [[BaseLabel alloc] init];
        _priceTitle.txColor = C3_ColorType;
        _priceTitle.font = [GUIUtil fitFont:12];
        _priceTitle.numberOfLines = 1;
    }
    return _priceTitle;
}

- (BaseLabel *)minusPriceText{
    if (!_minusPriceText) {
        _minusPriceText = [[BaseLabel alloc] init];
        _minusPriceText.txColor = C11_ColorType;
        _minusPriceText.font = [GUIUtil fitFont:12];
        _minusPriceText.numberOfLines = 1;
    }
    return _minusPriceText;
}

- (BaseLabel *)minusPriceTitle{
    if (!_minusPriceTitle) {
        _minusPriceTitle = [[BaseLabel alloc] init];
        _minusPriceTitle.txColor = C3_ColorType;
        _minusPriceTitle.font = [GUIUtil fitFont:12];
        _minusPriceTitle.numberOfLines = 1;
    }
    return _minusPriceTitle;
}

- (BaseLabel *)valueText{
    if (!_valueText) {
        _valueText = [[BaseLabel alloc] init];
        _valueText.txColor = C11_ColorType;
        _valueText.font = [GUIUtil fitFont:12];
        _valueText.numberOfLines = 1;
    }
    return _valueText;
}

- (BaseLabel *)valueTitle{
    if (!_valueTitle) {
        _valueTitle = [[BaseLabel alloc] init];
        _valueTitle.txColor = C3_ColorType;
        _valueTitle.font = [GUIUtil fitFont:12];
        _valueTitle.numberOfLines = 1;
    }
    return _valueTitle;
}

- (BaseView *)lineView{
    if (!_lineView) {
        _lineView = [[BaseView alloc] init];
        _lineView.bgColor = C8_ColorType;
    }
    return _lineView;
}

- (BaseBtn *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [[BaseBtn alloc] init];
        _commitBtn.bgColor = C15_ColorType;
        _commitBtn.titleLabel.font = [GUIUtil fitFont:14];
        _commitBtn.textBlock = CFDLocalizedStringBlock(@"确定");
        _commitBtn.txColor = C2_ColorType;
        [_commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _commitBtn;
}

@end

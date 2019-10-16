//
//  CFDOrderUIUtil.m
//  NWinBoom
//
//  Created by ngw15 on 2018/9/13.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "CFDOrderUIUtil.h"
#import "MarkView.h"


@interface CFDCountView ()
@property (nonatomic,strong)NSArray *config;
@property (nonatomic,strong)NSArray *closeConfig;
@property (nonatomic,assign)NSInteger selectTag;
@property (nonatomic,strong)UIColor *tinColor;
@property (nonatomic,strong)NSMutableArray <UIButton *>*btnList;
@property (nonatomic,strong)NSMutableArray <UIButton *>*closeList;
@property (nonatomic,strong)UIButton *selBtn;
@property (nonatomic,strong)MASConstraint *masBottom;
@property (nonatomic,assign)BOOL isUnfold;
@property (nonatomic,assign)BOOL isDisenable;
@end

@implementation CFDCountView

- (id)initWithTinColor:(UIColor *)tinColor
{
    if(self = [super init])
    {
        _tinColor = tinColor;
        _btnList = [NSMutableArray array];
        _closeList = [NSMutableArray array];
        self.selectTag = 0;
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIButton *bottomBtn = nil;
    UIButton *bottomBtn1 = nil;
    for (int i = 0; i < 14; i ++) {
        UIButton *  btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.titleLabel.font=[GUIUtil fitBoldFont:12];
        btn.layer.masksToBounds=YES;
        btn.layer.cornerRadius=1;
        [btn.layer setBorderWidth:[GUIUtil fitLine]]; //边框宽度
        btn.layer.borderColor=[GColorUtil C7].CGColor;
        btn.backgroundColor = [GColorUtil C6];
        [btn setTitleColor:[GColorUtil C3] forState:UIControlStateNormal];
        [btn setTitleColor:_tinColor forState:UIControlStateHighlighted];
        [btn setTitleColor:[GColorUtil C7] forState:UIControlStateDisabled];
        [btn setTitleColor:[GColorUtil C6] forState:UIControlStateSelected];
        [btn g_clickEdgeWithTop:5 bottom:5 left:2 right:2];
        [self addSubview:btn];
        if (i>9) {
            btn.hidden=YES;
            [_closeList addObject:btn];
            bottomBtn1 = btn;
        }else{
            btn.hidden=NO;
            [_btnList addObject:btn];
            bottomBtn = btn;
        }
        WEAK_SELF;
        [btn g_clickBlock:^(UIButton *sender) {
            [weakSelf btnAction:sender];
        }];
    }
    NSArray *list1 = [_btnList subarrayWithRange:NSMakeRange(0, 5)];
    NSArray *list2 = [_btnList subarrayWithRange:NSMakeRange(5, 5)];
    [list1 mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:[GUIUtil fit:5] leadSpacing:[GUIUtil fit:0] tailSpacing:0];
    [list1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:30]);
    }];
    [list2 mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:[GUIUtil fit:5] leadSpacing:[GUIUtil fit:0] tailSpacing:0];
    [list2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:35]);
        make.height.mas_equalTo([GUIUtil fit:30]);
    }];
    [_closeList mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:[GUIUtil fit:5] leadSpacing:[GUIUtil fit:0] tailSpacing:0];
    [_closeList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:30]);
        
    }];
    [bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        self.masBottom = make.bottom.mas_equalTo([GUIUtil fit:-10]);
    }];
    [bottomBtn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo([GUIUtil fit:-5]).priority(750);
    }];
    [_masBottom deactivate];
}

- (NSString *)countText{
    NSArray *tem = _isUnfold?_config:_closeConfig;
    NSString *num = [NDataUtil dataWithArray:tem index:_selectTag];
    num = [num substringToIndex:num.length-1];
    if ([num integerValue]<=0) {
        num = @"1";
    }
    return num;
}

- (void)btnAction:(UIButton *)sender{
    _selBtn.backgroundColor = [GColorUtil C6];
    _selBtn.layer.borderColor=[GColorUtil C7].CGColor;
    _selBtn.selected = NO;
    _selBtn = sender;
    _selBtn.selected=YES;
    if (_isDisenable) {
        [_selBtn setTitleColor:[GColorUtil C5] forState:UIControlStateNormal];
        [_selBtn setTitleColor:[GColorUtil C5] forState:UIControlStateSelected];
    }else{
        [_selBtn setTitleColor:[GColorUtil C3] forState:UIControlStateNormal];
        [_selBtn setTitleColor:[GColorUtil C5] forState:UIControlStateSelected];
    }
    _selBtn.layer.borderColor=_tinColor.CGColor;
    _selBtn.backgroundColor = _tinColor;
    [self countClicked:sender];
}

- (void)updateDefault{
    [self unflodAction:NO];
    UIButton *btn = [NDataUtil dataWithArray:_closeList index:0];
    [self btnAction:btn];
}

- (void)disableActivity{
    self.userInteractionEnabled = NO;
    _isDisenable = YES;
    for (UIButton *btn in _closeList) {
        btn.enabled = !_isDisenable;
        btn.layer.borderColor = [GColorUtil C8].CGColor;
    }
    [self updateDefault];
}

- (void)enableActivity{
    self.userInteractionEnabled = YES;
    _isDisenable = NO;
    for (UIButton *btn in _closeList) {
        btn.enabled = !_isDisenable;
        btn.layer.borderColor = [GColorUtil C7].CGColor;
    }
    [self updateDefault];
}

- (void)unflodAction:(BOOL)flag{
    if (_isUnfold==flag) {
        return;
    }
    _isUnfold = flag;
    self.selectTag=0;
    if (flag) {
        [_masBottom activate];
        for (int i=0; i<_btnList.count; i++) {
            UIButton *btn = _btnList[i];
            if (i>=_config.count) {
                btn.hidden=YES;
                continue;
            }
            btn.hidden=NO;
            [btn setTitle:[NSString stringWithFormat:@"%@",[NDataUtil dataWithArray:_config index:i]] forState:UIControlStateNormal];
            if(i==self.selectTag){
                [self btnAction:btn];
            }
        }
        for (UIButton *btn in _closeList) {
            btn.hidden=YES;
        }
    }else{
        [_masBottom deactivate];
        for (int i=0; i<_closeList.count; i++) {
            UIButton *btn = _closeList[i];
            if (i>=_closeConfig.count) {
                btn.hidden=YES;
                continue;
            }
            btn.hidden=NO;
            [btn setTitle:[NSString stringWithFormat:@"%@",[NDataUtil dataWithArray:_closeConfig index:i]] forState:UIControlStateNormal];
            if(i==self.selectTag){
                [self btnAction:btn];
            }
        }
        for (UIButton *btn in _btnList) {
            btn.hidden=YES;
        }
    }
    if (_unflodHander) {
        _unflodHander(_isUnfold);
    }
}

- (void)updateData:(NSArray *)array withCloseList:(NSArray *)closeList{
    _config = array;
    _closeConfig = closeList;
    [_masBottom deactivate];
    for (int i=0; i<_closeList.count; i++) {
        UIButton *btn = _closeList[i];
        if (i>_closeConfig.count) {
            btn.hidden=YES;
            continue;
        }
        btn.hidden=NO;
        [btn setTitle:[NSString stringWithFormat:@"%@",[NDataUtil dataWithArray:_closeConfig index:i]] forState:UIControlStateNormal];
        if(i==self.selectTag){
           [self btnAction:btn];
        }
    }
    for (UIButton *btn in _btnList) {
        btn.hidden=YES;
    }
}

-(void)countClicked:(id)sender
{
    NSArray *list = _isUnfold?_btnList:_closeList;
    NSArray *config = _isUnfold?_config:_closeConfig;
    NSInteger index = [list indexOfObject:sender];
    NSString *count = [NDataUtil dataWithArray:config index:index];
    if ([count isEqualToString:CFDLocalizedString(@"其他")]) {
        [self unflodAction:YES];
        return;
    }
    _selectTag = index;
    if (self.setCountBlock&&[count floatValue]>0) {
        self.setCountBlock(count);
    }
  
    
}


@end

@interface StopSetter ()

@property (nonatomic,strong)UILabel *lossedTitle;
@property (nonatomic,strong)UIButton *reduceBtn;
@property (nonatomic,strong)UIButton *addBtn;
@property (nonatomic,strong)UISlider *slider;
@property (nonatomic,strong)UILabel *lossesText;

@property (nonatomic,strong)UILabel *profitTitle;
@property (nonatomic,strong)UIButton *reduce1Btn;
@property (nonatomic,strong)UIButton *add1Btn;
@property (nonatomic,strong)UISlider *slider1;
@property (nonatomic,strong)UILabel *profitText;

@property (nonatomic,copy) NSString *slOriginPoint;
@property (nonatomic,copy) NSString *tpOriginPoint;
@property (nonatomic,copy) NSString *slPoint;
@property (nonatomic,copy) NSString *tpPoint;
@end

@implementation StopSetter

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.lossedTitle];
    [self addSubview:self.reduceBtn];
    [self addSubview:self.addBtn];
    [self addSubview:self.slider];
    [self addSubview:self.lossesText];
    
    [self addSubview:self.profitTitle];
    [self addSubview:self.reduce1Btn];
    [self addSubview:self.add1Btn];
    [self addSubview:self.slider1];
    [self addSubview:self.profitText];
    
}

- (void)autoLayout{
    [_lossedTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.mas_equalTo([GUIUtil fit:40]);
    }];
    [_reduceBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:60]);
        make.centerY.equalTo(self.lossedTitle);
        make.size.mas_equalTo([GUIUtil fitWidth:25 height:25]);
    }];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.equalTo(self.lossedTitle);
        make.size.mas_equalTo([GUIUtil fitWidth:25 height:25]);
    }];
    [_slider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reduceBtn.mas_right).mas_offset([GUIUtil fit:15]);
        make.right.equalTo(self.addBtn.mas_left).mas_offset([GUIUtil fit:-15]);
        make.height.mas_equalTo([GUIUtil fit:25]);
        make.centerY.equalTo(self.lossedTitle);
    }];
    [_lossesText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.slider.mas_right);
        make.bottom.equalTo(self.slider.mas_top).mas_offset([GUIUtil fit:-2]);
    }];
    
    [_profitTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.equalTo(self.lossedTitle).mas_offset([GUIUtil fit:60]);
    }];
    [_reduce1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:60]);
        make.centerY.equalTo(self.profitTitle);
        make.size.mas_equalTo([GUIUtil fitWidth:25 height:25]);
    }];
    [_add1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.equalTo(self.profitTitle);
        make.size.mas_equalTo([GUIUtil fitWidth:25 height:25]);
    }];
    [_slider1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reduce1Btn.mas_right).mas_offset([GUIUtil fit:15]);
        make.right.equalTo(self.add1Btn.mas_left).mas_offset([GUIUtil fit:-15]);
        make.height.mas_equalTo([GUIUtil fit:25]);
        make.centerY.equalTo(self.profitTitle);
    }];
    [_profitText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.slider.mas_right);
        make.bottom.equalTo(self.slider1.mas_top).mas_offset([GUIUtil fit:-3]);
    }];
}

//MARK: - Action

- (void)sliderAction:(UISlider *)slider{
    if ([_price floatValue]<=0||[_perProfit floatValue]<=0) {
        return;
    }
    NSDecimalNumber *perPoint = [[NSDecimalNumber decimalNumberWithString:_price] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:_perProfit]];
    CGFloat value = slider.value;
    NSDecimalNumber *point = [[perPoint decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%f",value]]] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"0.3"]];
    NSString *pointStr = [GUIUtil notRounding:point afterPoint:0];
    NSDecimalNumber *amount = [[NSDecimalNumber decimalNumberWithString:pointStr] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:_perProfit]];
    NSString *amountStr = [GUIUtil notRounding:amount afterPoint:2];
    UILabel *label = slider==_slider?_lossesText:_profitText;
    
    if (slider==_slider) {
        _slPoint = pointStr;
        if (_slOriginPoint.length==0) {
            _slOriginPoint = pointStr;
        }
    }else{
        _tpPoint = pointStr;
        if (_tpOriginPoint.length==0) {
            _tpOriginPoint = pointStr;
        }
    }
    
    if (value==0) {
        label.text = CFDLocalizedString(@"不限");
    }else{
        label.text = [NSString stringWithFormat:@"%.2f%%(%@点 %@元)",value*100,pointStr,amountStr];
    }
}

- (void)changedAction:(UIButton *)btn{
    
    NSInteger perPoint = [[NSDecimalNumber decimalNumberWithString:_price] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:_perProfit]].stringValue.integerValue;
    CGFloat value = btn==_reduceBtn||btn==_reduce1Btn ? -1.0/perPoint : 1.0/perPoint;
    UISlider *slider = btn==_reduceBtn||btn==_addBtn?_slider:_slider1;
    slider.value = slider.value +value;
    [self sliderAction:slider];
}

- (NSString *)stopLosses{
    
    NSDecimalNumber *decimal = [[NSDecimalNumber decimalNumberWithString:_slPoint] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)pow(10, _dotnum)]]];
    NSString *d = [GUIUtil notRounding:decimal afterPoint:_dotnum];
    return d;
}

- (NSString *)takeProfit{
    
    NSDecimalNumber *decimal = [[NSDecimalNumber decimalNumberWithString:_tpPoint] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",(long)pow(10, _dotnum)]]];
    NSString *d = [GUIUtil notRounding:decimal afterPoint:_dotnum];
    return d;
}

- (BOOL)hasChanged{
    BOOL flag = [_slOriginPoint isEqualToString:_slPoint]&&
    [_tpOriginPoint isEqualToString:_tpPoint];
    return !flag;
}

- (void)disableActivity{
    self.userInteractionEnabled = NO;

    UIImage *img = [UIImage imageWithColor:[GColorUtil colorWithColorType:C11_ColorType alpha:0.3]];
    [_slider1 setMaximumTrackImage:img forState:UIControlStateNormal];
    [_slider1 setMinimumTrackImage:img forState:UIControlStateNormal];
    [_slider setMaximumTrackImage:img forState:UIControlStateNormal];
    [_slider setMinimumTrackImage:img forState:UIControlStateNormal];
   
}
- (void)enableActivity{
    self.userInteractionEnabled = YES;
    UIImage *img = [UIImage imageWithColor:[GColorUtil colorWithColorType:C11_ColorType alpha:1]];
    [_slider1 setMaximumTrackImage:[GColorUtil imageNamed:@"market_order_pop_takeback"] forState:UIControlStateNormal];
    [_slider1 setMinimumTrackImage:img forState:UIControlStateNormal];
    [_slider setMaximumTrackImage:[GColorUtil imageNamed:@"market_order_pop_takeback"] forState:UIControlStateNormal];
    [_slider setMinimumTrackImage:img forState:UIControlStateNormal];
}

//MARK: - Getter

- (void)setDefaultLossesRatio:(CGFloat)defaultLossesRatio{
    _slider.value = defaultLossesRatio;
    [self sliderAction:_slider];
}

- (void)setDefaultProfitRatio:(CGFloat)defaultProfitRatio{
    _slider1.value = defaultProfitRatio;
    [self sliderAction:_slider1];
}

- (void)setMaxLosses:(CGFloat)maxLosses{
    _maxLosses = maxLosses;
    self.slider.maximumValue = maxLosses;
}

- (void)setMaxProfit:(CGFloat)maxProfit{
    _maxProfit = maxProfit;
    self.slider1.maximumValue = maxProfit;
}

- (UILabel *)lossedTitle{
    if (!_lossedTitle) {
        _lossedTitle = [[UILabel alloc] init];
        _lossedTitle.text=CFDLocalizedString(@"止损");
        _lossedTitle.textColor = [GColorUtil C2];
        _lossedTitle.font = [GUIUtil fitFont:14];
    }
    return _lossedTitle;
}

- (UIButton *)reduceBtn{
    if (!_reduceBtn) {
        _reduceBtn = [[UIButton alloc] init];
        [_reduceBtn setImage:[GColorUtil imageNamed:@"market_order_reduction"] forState:UIControlStateNormal];
        [_reduceBtn addTarget:self action:@selector(changedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduceBtn;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] init];
        [_addBtn setImage:[GColorUtil imageNamed:@"market_order_add"] forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(changedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (UISlider *)slider{
    if (!_slider) {
        _slider = [[UISlider alloc] init];
        _slider.minimumValue=0;
        _slider.maximumValue = 0.75;
        [_slider setThumbImage:[GColorUtil imageNamed:@"market_order_sliding"] forState:UIControlStateNormal];
        [_slider setMaximumTrackImage:[GColorUtil imageNamed:@"market_order_pop_takeback"] forState:UIControlStateNormal];
        _slider.minimumTrackTintColor = [GColorUtil C12];
        [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        _slider.value = 0.5;
    }
    return _slider;
}

- (UILabel *)lossesText{
    if (!_lossesText) {
        _lossesText = [[UILabel alloc] init];
        _lossesText.textColor = [GColorUtil C3];
        _lossesText.font = [GUIUtil fitFont:12];
        _lossesText.text = CFDLocalizedString(@"不限");
    }
    return _lossesText;
}

- (UILabel *)profitTitle{
    if (!_profitTitle) {
        _profitTitle = [[UILabel alloc] init];
        _profitTitle.text=CFDLocalizedString(@"止盈");
        _profitTitle.textColor = [GColorUtil C2];
        _profitTitle.font = [GUIUtil fitFont:14];
    }
    return _profitTitle;
}

- (UIButton *)reduce1Btn{
    if (!_reduce1Btn) {
        _reduce1Btn = [[UIButton alloc] init];
        [_reduce1Btn setImage:[GColorUtil imageNamed:@"market_order_reduction"] forState:UIControlStateNormal];
        [_reduce1Btn addTarget:self action:@selector(changedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reduce1Btn;
}

- (UIButton *)add1Btn{
    if (!_add1Btn) {
        _add1Btn = [[UIButton alloc] init];
        [_add1Btn setImage:[GColorUtil imageNamed:@"market_order_add"] forState:UIControlStateNormal];
        [_add1Btn addTarget:self action:@selector(changedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _add1Btn;
}

- (UISlider *)slider1{
    if (!_slider1) {
        _slider1 = [[UISlider alloc] init];
        _slider1.minimumValue=0;
        _slider1.maximumValue = 0.75;
        [_slider1 setThumbImage:[GColorUtil imageNamed:@"market_order_sliding"] forState:UIControlStateNormal];
        [_slider1 setMaximumTrackImage:[GColorUtil imageNamed:@"market_order_pop_takeback"] forState:UIControlStateNormal];
        _slider1.minimumTrackTintColor = [GColorUtil C11];
        [_slider1 addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
        _slider1.value = 0.5;
    }
    return _slider1;
}

- (UILabel *)profitText{
    if (!_profitText) {
        _profitText = [[UILabel alloc] init];
        _profitText.textColor = [GColorUtil C3];
        _profitText.font = [GUIUtil fitFont:12];
        _profitText.text = CFDLocalizedString(@"不限");
    }
    return _profitText;
}

@end






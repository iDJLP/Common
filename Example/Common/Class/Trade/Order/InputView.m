//
//  InputView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/22.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "InputView.h"

@interface InputView ()<UITextFieldDelegate>

@end

@implementation InputView

+ (CGSize)sizeOfView{
    return [GUIUtil fitWidth:230 height:30];
}

- (void)dealloc{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

- (instancetype)initWithType:(InputType)type{
    if (self = [super init]) {
        _type = type;
        [self setupUI];
        [self autoLayout];
        [self addNotic];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.inputView];
    [self.inputView addSubview:self.textField];
    if (_type==InputTypeAddSub) {
        [self.inputView addSubview:self.addBtn];
        [self.inputView addSubview:self.subBtn];
        [self.inputView addSubview:self.line1];
        [self.inputView addSubview:self.line2];
    }else if (_type==InputTypeSelected){
        [self.inputView addSubview:self.selBtn];
    }
}

- (void)autoLayout{
    [self updateLanguage];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:5]);
        make.top.bottom.mas_equalTo(0);
        make.width.mas_equalTo([GUIUtil fit:120]);
    }];
    if (_type==InputTypeAddSub) {
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo([GUIUtil fitWidth:30 height:30]);
            make.right.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        [_subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo([GUIUtil fitWidth:30 height:30]);
            make.right.equalTo(self.addBtn.mas_left);
            make.top.mas_equalTo(0);
        }];
        [_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.addBtn.mas_left);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo([GUIUtil fit:12]);
            make.width.mas_equalTo([GUIUtil fitLine]);
        }];
        [_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.subBtn.mas_left);
            make.centerY.mas_equalTo(0);
            make.height.mas_equalTo([GUIUtil fit:30]);
            make.width.mas_equalTo([GUIUtil fitLine]);
        }];
    }else if (_type==InputTypeSelected){
        [_selBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-8);
            make.centerY.mas_equalTo(0);
        }];
    }else if (_type==InputTypeNone){
        [_textField mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:5]);
            make.right.mas_equalTo([GUIUtil fit:-5]);
           make.top.bottom.mas_equalTo(0);
        }];
    }
}

- (void)addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(updateLanguage)
                   name:LanguageDidChangedNotification
                 object:nil];
}

- (void)updateLanguage{
    if ([[FTConfig sharedInstance].lang isEqualToString:@"en"]) {
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo([GUIUtil fit:50]);
        }];
        [_inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:70]);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo([GUIUtil fitWidth:160 height:30]);
        }];
    }else{
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.centerY.mas_equalTo(0);
        }];
        [_inputView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:55]);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo([GUIUtil fitWidth:175 height:30]);
        }];
    }
    [self.superview layoutIfNeeded];
}

- (void)configView:(NSDictionary *)dic{
    _titleLabel.text = [NDataUtil stringWith:dic[@"title"]];
    _textField.text = [NDataUtil stringWith:dic[@"text"]];
    _textField.placeholder = [NDataUtil stringWith:dic[@"placeholder"]];
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_textField.placeholder.length>0?_textField.placeholder:@" " attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:_textField.placeColor]}];
}

- (void)countChangedAction:(id)sender{
    BOOL flag = YES;
    if (self.enableBecomeFirstRespondHander) {
         flag = self.enableBecomeFirstRespondHander();
    }
    if (flag==NO) {
        return;
    }
    if (sender==_addBtn) {
        _textField.text = [GUIUtil decimalAdd:_textField.text num:_minFloat];
    }else if (sender==_subBtn){
        NSString *num = [GUIUtil decimalSubtract:_textField.text num:_minFloat];
        if (num.floatValue<0) {
            num=@"0";
        }
        _textField.text = num;
    }
    NSString *text = _textField.text;
    NSInteger index = [InputView decFloat:_minFloat];
    NSInteger currentIndex = [InputView decFloat:text];
    NSInteger dif = _minFloat.floatValue/pow(10, index);
    if (dif!=1&&currentIndex==index&&text.length>0) {
        NSInteger t = [text substringFromIndex:text.length-1].integerValue;
        NSInteger ss = t%dif;
        t = t-ss;
        NSString *preStr = [text substringToIndex:text.length-1];
        preStr = [preStr stringByAppendingString:[NSString stringWithFormat:@"%ld",t]];
        _textField.text = preStr;
    }
    if (_textChangedHander) {
        _textChangedHander();
    }
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (self.enableBecomeFirstRespondHander) {
       return self.enableBecomeFirstRespondHander();
    }
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (_type==InputTypeSelected) {
        return YES;
    }
    if ([string isEqualToString:@""]) {
        return YES;
    }
    NSInteger index = [InputView decFloat:_minFloat];
    NSInteger decLength = 0;
    BOOL hasPoint = YES;
    if (index>=0) {
        decLength = 0;
        hasPoint = NO;
    }else{
        decLength = ABS(index);
    }
    if ([string isEqualToString:@"."]) {
        NSInteger l = textField.text.length-range.location;
        if (l>decLength) {
            return NO;
        }
    }
    NSRange ran = [textField.text rangeOfString:@"."];
    BOOL flag = ran.location != NSNotFound&&(ran.length+ran.location<=textField.text.length);
    BOOL pointFlag = [string isEqualToString:@"."];
    NSInteger pointNum =textField.text.length-decLength;
    NSInteger ranNum = ran.length+ran.location;
    BOOL decFlag = (ran.location == NSNotFound)||(ranNum-pointNum>0); //小数点后是否没到两位
    BOOL numFlag = ([string integerValue]>0&&[string integerValue]<=9)||[string isEqualToString:@"0"];
    if (textField == _textField){
        BOOL isReturn = NO;
        if (!flag&&pointFlag&&hasPoint){
            isReturn = YES;
        }else if (numFlag&&decFlag) {
            isReturn = YES;
        }
        if (isReturn) {
            //限制长度9位;
            NSInteger strLength = textField.text.length - range.length + string.length;
            return (strLength <= 10+decLength);
        }else{
            return NO;
        }
    }
    return YES;
}


//MARK: - Getter

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.txColor = C2_ColorType;
        _titleLabel.font = [GUIUtil fitFont:12];
        _titleLabel.numberOfLines = 1;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.minimumScaleFactor = 0.5;
    }
    return _titleLabel;
}

- (BaseView *)inputView{
    if (!_inputView) {
        _inputView = [[BaseView alloc] init];
        _inputView.bgColor = C6_ColorType;
        _inputView.bgLayerColor = C4_ColorType;
        _inputView.layer.borderWidth = [GUIUtil fitLine];
        WEAK_SELF;
        [_inputView g_clickBlock:^(UITapGestureRecognizer *tap) {
            if (weakSelf.type!=InputTypeNone) {
                [weakSelf.textField becomeFirstResponder];
            }
        }];
    }
    return _inputView;
}

- (BaseTextField *)textField{
    if (!_textField) {
        _textField = [[BaseTextField alloc] init];
        _textField.font = [GUIUtil fitFont:12];
        _textField.delegate = self;
        _textField.placeholder = @" ";
        _textField.txColor = C2_ColorType;
        _textField.placeColor = C4_ColorType;
        _textField.keyboardType = UIKeyboardTypeDecimalPad;
        [_textField addTarget:self action:@selector(countChangedAction:) forControlEvents:UIControlEventEditingChanged];
        [_textField addTarget:self action:@selector(textTapAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _textField;
}

- (BaseBtn *)addBtn{
    if (!_addBtn) {
        _addBtn = [[BaseBtn alloc] init];
        _addBtn.imageName = @"trade_icon_add";
        [_addBtn addTarget:self action:@selector(countChangedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

- (BaseBtn *)subBtn{
    if (!_subBtn) {
        _subBtn = [[BaseBtn alloc] init];
        _subBtn.imageName = @"trade_icon_sub";
        [_subBtn addTarget:self action:@selector(countChangedAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _subBtn;
}

- (BaseView *)line1{
    if (!_line1) {
        _line1 = [[BaseView alloc] init];
        _line1.bgColor = C4_ColorType;
    }
    return _line1;
}

- (BaseView *)line2{
    if (!_line2) {
        _line2 = [[BaseView alloc] init];
        _line2.bgColor = C4_ColorType;
    }
    return _line2;
}

- (UIImageView *)selBtn{
    if (!_selBtn) {
        _selBtn = [[UIImageView alloc] init];
        _selBtn.image = [GColorUtil imageNamed:@"public_icon_under_blue"];
    }
    return _selBtn;
}

+ (NSInteger)decFloat:(NSString *)f{
    if([f containsString:@"."]){
        f = [[f componentsSeparatedByString:@"."] lastObject];
        f = [NSString stringWithFormat:@"0.%@",f];
    }
    NSInteger index = 0;
    if (f.floatValue<1) {
        while (f.floatValue<1&&f.floatValue>0) {
            index--;
            f=[GUIUtil decimalMultiply:f num:@"10"];
        }
    }else if (f.floatValue>10){
        while (f.floatValue>10) {
            index++;
            f=[GUIUtil decimalDivide:f num:@"10"];
        }
    }
    return index;
}

@end


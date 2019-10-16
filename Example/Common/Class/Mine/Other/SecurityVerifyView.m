//
//  SecurityVerifyView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/5/17.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "SecurityVerifyView.h"

@interface SecurityVerifyView ()<UITextFieldDelegate>

@property (nonatomic,strong)BaseLabel *titleLabel;
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)NSMutableArray <BaseLabel *> *pwdList;

@end

@implementation SecurityVerifyView

- (void)dealloc{
    [self removeNotic];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self autoLayout];
        [self addNotic];
    }
    return self;
}

- (void)setupUI{
    self.pwdList = [NSMutableArray array];
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
    WEAK_SELF;
    for (NSInteger i=0; i<6; i++) {
        BaseLabel *label = [[BaseLabel alloc] init];
        label.bgColor = C4_ColorType;
        label.textAlignment = NSTextAlignmentCenter;
        label.txColor = C5_ColorType;
        label.font = [GUIUtil fitFont:16];
        [label g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf.textField becomeFirstResponder];
        }];
        [self addSubview:label];
        [self.pwdList addObject:label];
    }
}

- (void)autoLayout{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:40]);
        make.right.mas_equalTo([GUIUtil fit:-40]);
        make.top.mas_equalTo([GUIUtil fit:20]);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
    }];
    [self.pwdList mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:[GUIUtil fit:14] leadSpacing:[GUIUtil fit:40] tailSpacing:[GUIUtil fit:40]];
    [self.pwdList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo([GUIUtil fit:38]);
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset([GUIUtil fit:30]);
    }];
}

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notic{
    NSDictionary *dic = [notic userInfo];
    CGRect keyboardFrame = [[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue]; //获得键盘
    CGFloat bottom = [self convertPoint:CGPointMake(0, self.titleLabel.bottom) fromView:self].y+[GUIUtil fit:100];
    bottom = SCREEN_HEIGHT - bottom;
    CGFloat offset =keyboardFrame.size.height-bottom;
    if (offset>0) {
        [UIView beginAnimations:@"SecurityVerifyView" context:NULL];
        [UIView setAnimationDuration:[dic[UIKeyboardAnimationDurationUserInfoKey]floatValue]];
        [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey]integerValue]];
        self.transform = CGAffineTransformMakeTranslation(0, offset);
        [UIView commitAnimations];
    }
}

- (void)keyboardWillHide:(NSNotification *)notic{
    NSDictionary *dic = [notic userInfo];
    [UIView beginAnimations:@"SecurityVerifyView" context:NULL];
    [UIView setAnimationDuration:[dic[UIKeyboardAnimationDurationUserInfoKey]floatValue]];
    [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey]integerValue]];
    self.transform = CGAffineTransformIdentity;
    [UIView commitAnimations];
}

//MARK: - Action

- (NSString *)pwdText{
    return _textField.text;
}

- (void)pwdChangedAction{
    
    for (NSInteger i=0; i<_textField.text.length; i++) {
        BaseLabel *label = [NDataUtil dataWithArray:_pwdList index:i];
        label.text = [_textField.text substringWithRange:NSMakeRange(i, 1)];
    }
    for (NSInteger i=_textField.text.length; i<6; i++) {
        BaseLabel *label = [NDataUtil dataWithArray:_pwdList index:i];
        label.text = @"";
    }
    _pwdChangedHander();
}

- (void)becomeFirstRespond{
    [_textField becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length>0&&![NDataUtil isNumber:string]) {
        return NO;
    }
    NSInteger strLength = textField.text.length - range.length + string.length;
    return (strLength <= 6);
}

//MARK: - Getter

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.txColor = C2_ColorType;
        _titleLabel.font = [GUIUtil fitFont:16];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = CFDLocalizedString(@"请输入谷歌验证器中的6位验证码进行验证");
    }
    return _titleLabel;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [_textField addTarget:self action:@selector(pwdChangedAction) forControlEvents:UIControlEventEditingChanged];
        [_textField addToolbar];
        _textField.hidden = YES;
        _textField.delegate = self;
    }
    return _textField;
}

#pragma mark - Private

- (void)addNotic{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];}

- (void)removeNotic{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

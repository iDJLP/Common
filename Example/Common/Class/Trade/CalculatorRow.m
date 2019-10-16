//
//  CalculatorRow.m
//  Bitmixs
//
//  Created by ngw15 on 2019/9/11.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "CalculatorRow.h"
#import "InputView.h"

@interface CalculatorRow ()<UITextFieldDelegate>

@property (nonatomic,strong) UILabel *titleLabel;

@property (nonatomic,strong) UILabel *remarkLabel;
@property (nonatomic,strong) UIView *line;

@end

@implementation CalculatorRow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
    [self addSubview:self.remarkLabel];
    [self addSubview:self.line];
}

- (void)autoLayout{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.mas_equalTo(0);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo([GUIUtil fit:150]);
        make.height.mas_equalTo(self);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.mas_equalTo(0);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
}

- (void)configView:(NSDictionary *)config{
    _titleLabel.text = [NDataUtil stringWith:config[@"title"]];
    _remarkLabel.text = [NDataUtil stringWith:config[@"remark"]];
    _textField.text = [NDataUtil stringWith:config[@"text"]];
    NSString *hoder = [NDataUtil stringWith:config[@"placehoder"]];
    _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:hoder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType]}];
}

- (UITextField *)firstRespondField{
    if (_textField.isFirstResponder) {
        return _textField;
    }
    return nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
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

- (void)setIsRightLabel:(BOOL)isRightLabel{
    _remarkLabel.hidden = YES;
    _textField.hidden = NO;
    if (isRightLabel) {
        _textField.userInteractionEnabled = NO;
    }else{
        _textField.userInteractionEnabled = YES;
    }
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [GColorUtil C2];
        _titleLabel.font = [GUIUtil fitFont:16];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.textColor = [GColorUtil C2];
        _remarkLabel.font = [GUIUtil fitBoldFont:16];
    }
    return _remarkLabel;
}

- (void)textFieldEditChanged{
    if (_textChangedHander) {    
        _textChangedHander();
    }
}

- (NSString *)text{
    return _textField.text;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = [GColorUtil C2];
        _textField.font = [GUIUtil fitFont:16];
        _textField.delegate = self;
        _textField.placeholder = @" ";
        _textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:_textField.placeholder attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:C3_ColorType]}];
        _textField.textAlignment = NSTextAlignmentRight;
        [_textField addTarget:self action:@selector(textFieldEditChanged) forControlEvents:UIControlEventEditingChanged];
    }
    return _textField;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [GColorUtil C7];
    }
    return _line;
}

@end

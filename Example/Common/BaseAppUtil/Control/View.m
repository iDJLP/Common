//
//  View.m
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "View.h"
#import "MarkView.h"
#import "BaseLabel.h"

@interface SingleInfoView ()

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) BaseLabel *keyLabel;
@property (nonatomic,strong) BaseLabel *valueLabel;
@property (nonatomic,strong) MarkView *markView;

@property (nonatomic,strong) MASConstraint *masValueLabelLeft;

@end

@implementation SingleInfoView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype) initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        _padding = [GUIUtil fit:5];
        _leftPadding = [GUIUtil fit:100];
        _alignment = SingleInfoAlignmentSide;
        [self initUI];
        [self addNotic];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.keyLabel];
    [self.contentView addSubview:self.valueLabel];
    [self.contentView addSubview:self.markView];
}

- (void)updateConstraints{
    [super updateConstraints];
    [self layout];
}

- (void)layout{
    
    [self updateLanguage:nil];
}

- (void)addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
    [center addObserver:self
               selector:@selector(updateLanguage:)
                   name:LanguageDidChangedNotification
                 object:nil];
}

- (void)updateLanguage:(NSNotification *)notic{
   
    if ([[FTConfig sharedInstance].lang isEqualToString:@"en"]&&_needChangedStyle) {
        [_valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.top.mas_equalTo(0);
        }];
        [_keyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.valueLabel.mas_bottom).mas_offset([GUIUtil fit:3]);
            make.left.mas_equalTo(0);
            make.bottom.mas_equalTo(0);
        }];
        [_contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }else{
        [_valueLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            self.masValueLabelLeft = make.left.equalTo(self.keyLabel.mas_right).mas_offset(0).priority(1000);
            make.left.equalTo(self.markView.mas_right).mas_offset(5).priority(750);
            make.centerY.equalTo(self.keyLabel);
            if (self.alignment==SingleInfoAlignmentLeft) {
                make.left.equalTo(self.keyLabel.mas_right).mas_offset(+self.padding);
            }else if(self.alignment==SingleInfoAlignmentSide||self.alignment==SingleInfoAlignmentRight||self.alignment==SingleInfoAlignmentCenter){
                make.right.mas_equalTo(0);
            }else if (self.alignment==SingleInfoAlignmentLeftPadding){
                make.left.mas_equalTo(self.leftPadding);
            }
        }];
        [_keyLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            if (self.alignment==SingleInfoAlignmentSide||
                self.alignment==SingleInfoAlignmentLeft||
                self.alignment==SingleInfoAlignmentLeftPadding) {
                make.left.mas_equalTo(0);
            }else if(self.alignment==SingleInfoAlignmentRight){
                make.right.equalTo(self.valueLabel.mas_left).mas_offset(-self.padding);
            }else if (self.alignment==SingleInfoAlignmentCenter){
                make.left.mas_equalTo(0);
                make.right.equalTo(self.valueLabel.mas_left).mas_offset(-self.padding);
            }
            make.top.bottom.mas_equalTo(0);
        }];
        [_markView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.keyLabel.mas_right).mas_offset([GUIUtil fit:-3]);
            make.centerY.equalTo(self.keyLabel);
        }];
        [self.contentView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (self.alignment==SingleInfoAlignmentCenter) {
                make.left.equalTo(self.keyLabel);
                make.right.equalTo(self.valueLabel);
                make.top.equalTo(self.keyLabel);
                make.bottom.equalTo(self.keyLabel);
                make.center.mas_equalTo(0);
            }else{
                make.edges.mas_equalTo(0);
            }
        }];
        // 保证keylabel水平方向不被拉长
        [_keyLabel setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
    }
    // 保证keylabel竖直方向不被压缩
    [_keyLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    // 保证valueLabel竖直方向不被压缩
    [_valueLabel setContentCompressionResistancePriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];
    if (notic) {
        [self.superview layoutIfNeeded];
    }
}

- (void)setKeyColor:(ColorType )colorType{
    _keyLabel.txColor = colorType;
}
- (void)setKeyAlpha:(CGFloat)alpha{
    _keyLabel.txAlpha = alpha;
}
- (void)setValueColor:(ColorType)colorType{
    _valueLabel.txColor = colorType;
}

- (void)setKeyFont:(UIFont *)font{
    _keyLabel.font = font;
}
- (void)setValueFont:(UIFont *)font{
    _valueLabel.font = font;
}

- (void)setValueTheme:(BOOL)isChanged{
    _valueLabel.hasTheme = isChanged;
}

- (void)setKeyTheme:(BOOL)isChanged{
    _keyLabel.hasTheme = isChanged;
}

- (void)configOfInfo:(NSDictionary *)info{
    if (![info isKindOfClass:[NSDictionary class]]) {
        return;
    }
    
    NSString *value = [NDataUtil stringWith:info[@"value"] valid:@""];
    NSString *key = [NDataUtil stringWith:info[@"key"] valid:@""];
    
    if ([info[@"mark"] isKindOfClass:[NSString class]]&&[info[@"mark"] length]>0) {
        _markView.hidden = NO;
        _markView.text = info[@"mark"];
        [_masValueLabelLeft deactivate];
    }else{
        [_masValueLabelLeft deactivate];
        _markView.hidden = YES;
    }
    if (value.length>=1) {
        _valueLabel.text = value;
    }
    _keyLabel.text = key;
    if ([info containsObjectForKey:@"colortype"]) {
        if ([info containsObjectForKey:@"alpha"]) {
            _valueLabel.txAlpha = [info[@"alpha"] floatValue];
        }
         _valueLabel.txColor = [info[@"colortype"] integerValue];
    }else if ([info containsObjectForKey:@"color"]) {
        _valueLabel.textColor = info[@"color"];
    }
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (BaseLabel *)keyLabel{
    if (!_keyLabel) {
        _keyLabel = [[BaseLabel alloc] init];
        _keyLabel.txColor = C3_ColorType;
        _keyLabel.font = [GUIUtil fitFont:12];
        _keyLabel.text = @" ";
        _keyLabel.hasTheme = NO;
    }
    return _keyLabel;
}

- (BaseLabel *)valueLabel{
    if(!_valueLabel){
        _valueLabel = [[BaseLabel alloc] init];
        _valueLabel.txColor = C2_ColorType;
        _valueLabel.textAlignment = NSTextAlignmentRight;
        _valueLabel.font = [GUIUtil fitFont:12];
        _valueLabel.adjustsFontSizeToFitWidth = YES;
        _valueLabel.minimumScaleFactor = 0.3;
        _valueLabel.text = @"--";
        _valueLabel.hasTheme = NO;
    }
    return _valueLabel;
}
- (MarkView *)markView{
    if (!_markView) {
        _markView = [[MarkView alloc] init];
        _markView.hPadding = 1;
        _markView.vPadding = 0;
        _markView.textColor = [GColorUtil C13];
        _markView.font = [GUIUtil fitFont:10];
        _markView.layer.borderColor = GColorUtil.C13.CGColor;
        _markView.layer.borderWidth = [GUIUtil fitLine];
    }
    return _markView;
}

@end

@interface SingleInputView()

@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UITextField *textField;
@property (nonatomic,strong)UIView *lineView;
@end

@implementation SingleInputView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.textField];
    [self addSubview:self.lineView];
}

- (void)autoLayout{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo([GUIUtil fit:120]);
    }];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.titleLabel.mas_right).mas_offset([GUIUtil fit:15]);
        make.centerY.equalTo(self.titleLabel);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
}

- (void)setTitle:(NSString *)title{
    _titleLabel.text = title;
}

- (void)setPlaceholder:(NSString *)placeholder{
    _textField.placeholder = placeholder;
}

- (NSString *)inputText{
    return _textField.text;
}

- (void)inputChanged{
    if (_inputChangedHander) {
        _inputChangedHander();
    }
}


//MARK: - Getter

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [GColorUtil C2];
        _titleLabel.font = [GUIUtil fitFont:16];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] init];
        _textField.textColor = [GColorUtil C2];
        _textField.placeholder = @" ";
        _textField.font = [GUIUtil fitFont:16];
        [_textField addTarget:self action:@selector(inputChanged) forControlEvents:UIControlEventEditingChanged];
        [_textField addToolbar];
    }
    return _textField;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [GColorUtil C7];
    }
    return _lineView;
}

@end


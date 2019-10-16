//
//  MarkView.m
//  niuguwang
//
//  Created by ngw15 on 2017/4/17.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "MarkView.h"

@interface MarkView ()

@property (nonatomic,strong) UILabel *markLabel;

@end

@implementation MarkView

+ (CGSize)sizeOfView:(NSString *)text vPadding:(CGFloat)vPadding hPadding:(CGFloat)hPadding fontSize:(CGFloat)fontSize{
    CGSize size=[text boundingRectWithSize:CGSizeMake(MAXFLOAT,MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil] context:nil].size;
    return CGSizeMake(ceil(size.width+2*hPadding), ceil(size.height+vPadding*2));
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self layout];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.markLabel];
}

- (void)layout{
    [_markLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
}

+ (BOOL)requiresConstraintBasedLayout{
    return YES;
}

- (void)updateConstraints{
    [super updateConstraints];
}

- (void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    _markLabel.textColor = _textColor;
}

- (void)setText:(NSString *)text{
    if ([text isKindOfClass:[NSString class]]&&text.length>0) {
        self.alpha=1;
        _markLabel.textColor = _textColor;
        _text = text;
        _markLabel.font = _font;
        _markLabel.text = text;
        UIFontDescriptor *ctfFont = _font.fontDescriptor;
        NSNumber *fontString = [ctfFont objectForKey:@"NSFontSizeAttribute"];
        CGSize size = [MarkView sizeOfView:text vPadding:_vPadding hPadding:_hPadding fontSize:[fontString floatValue]];
        if (size.width<size.height) {
            size.width = size.height;
        }
        if ([NCheckValid isAllNum:text]&&text.length==1) {
            size.width = size.height;
        }
        self.size=size;
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
        }];
    }else{
        _text = @"";
        self.alpha=0;
    }
}

#pragma mark - Getter

- (UILabel *)markLabel{
    if(_markLabel == nil){
        _markLabel = [[UILabel alloc] init];
    }
    return _markLabel;
}


@end

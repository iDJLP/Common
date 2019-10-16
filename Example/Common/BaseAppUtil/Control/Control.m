//
//  Button.m
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "Control.h"
#import "BaseView.h"

@interface CFDSelectedBtn ()

@property (nonatomic, strong) BaseView *lineView;

@end

@implementation CFDSelectedBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake([GUIUtil fit:10], 2));
        }];
    }
    return self;
}

- (void)setLineColor:(UIColor *)lineColor{
    _lineView.bgColor = Unkown_ColorType;
    _lineView.backgroundColor = lineColor;
}

- (void)setLineType:(CFDSelectedLineType)lineType{
    if (lineType == CFDSelectedLineTypeEqualTitle) {
        [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.titleLabel);
            make.bottom.mas_equalTo(0);
            make.centerX.mas_equalTo(0);
            make.height.mas_equalTo([GUIUtil fit:2]);
        }];
    }else if (lineType == CFDSelectedLineTypeWidthLeft){
        [_lineView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel);
            make.bottom.mas_equalTo(0);
            make.width.mas_equalTo([GUIUtil fit:10]);
            make.height.mas_equalTo([GUIUtil fit:2]);
        }];
    }
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    self.lineView.hidden = !selected;
    if (selected) {
        self.titleLabel.font = _selFont;
    }else{
        self.titleLabel.font = _norFont;
    }
}

- (BaseView *)lineView{
    if (_lineView == nil) {
        _lineView = [BaseView new];
        _lineView.bgColor = C13_ColorType;
        _lineView.hidden = YES;
        
    }
    return _lineView;
}

@end

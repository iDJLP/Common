//
//  ChartsBottomView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/18.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "ChartsBottomView.h"

@interface ChartsBottomBtn:UIButton

@end

@implementation ChartsBottomBtn

- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, contentRect.size.height*10/49.0f, contentRect.size.width, contentRect.size.height*19/49.0f);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(0, contentRect.size.height*29/49.0f, contentRect.size.width, contentRect.size.height*20/49.0f);
}


@end

@interface ChartsBottomView ()

@property (nonatomic,strong)UIButton *tradeBtn;
@property (nonatomic,strong)UIButton *sellBtn;
@property (nonatomic,strong)ChartsBottomBtn *alertBtn;
@end

@implementation ChartsBottomView

+ (CGFloat)heightOfView{
    return [GUIUtil fit:50]+IPHONE_X_BOTTOM_HEIGHT;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [GColorUtil C6];
        [self addSubview:self.tradeBtn];
        [self addSubview:self.sellBtn];
        [self addSubview:self.alertBtn];
        [_tradeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH*1/3.0);
            make.height.mas_equalTo([GUIUtil fit:50]);
        }];
        [_sellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(SCREEN_WIDTH*1/3.0);
           make.top.mas_equalTo(0); make.width.mas_equalTo(SCREEN_WIDTH*1/3.0);
            make.height.mas_equalTo([GUIUtil fit:50]);
        }];
        [_alertBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH*1/3.0);
            make.height.mas_equalTo([GUIUtil fit:50]);
        }];
    }
    return self;
}

- (void)tradeAction{
    _buyHander();
}

- (void)sellAction{
    _sellHander();
}

- (void)alertAction{
    _alertHander();
}

- (UIButton *)tradeBtn{
    if (!_tradeBtn) {
        _tradeBtn = [[UIButton alloc] init];
        _tradeBtn.backgroundColor = [GColorUtil C11];
        _tradeBtn.titleLabel.font = [GUIUtil fitBoldFont:16];
        [_tradeBtn setTitle:CFDLocalizedString(@"买入")  forState:UIControlStateNormal];
        [_tradeBtn setTitleColor:[GColorUtil C5] forState:UIControlStateNormal];
        [_tradeBtn addTarget:self action:@selector(tradeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tradeBtn;
}

- (UIButton *)sellBtn{
    if (!_sellBtn) {
        _sellBtn = [[UIButton alloc] init];
        _sellBtn.backgroundColor = [GColorUtil C12];
        _sellBtn.titleLabel.font = [GUIUtil fitBoldFont:16];
        [_sellBtn setTitle:CFDLocalizedString(@"卖出")  forState:UIControlStateNormal];
        [_sellBtn setTitleColor:[GColorUtil C5] forState:UIControlStateNormal];
        [_sellBtn addTarget:self action:@selector(sellAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sellBtn;
}



- (ChartsBottomBtn *)alertBtn{
    if (!_alertBtn) {
        _alertBtn = [[ChartsBottomBtn alloc] init];
        _alertBtn.backgroundColor = [GColorUtil C8];
        [_alertBtn setImage:[GColorUtil imageNamed:@"market_icon_remind"] forState:UIControlStateNormal];
        _alertBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
        [_alertBtn setTitle:CFDLocalizedString(@"提醒") forState:UIControlStateNormal];
        _alertBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _alertBtn.titleLabel.font = [GUIUtil fitFont:12];
        [_alertBtn setTitleColor:[GColorUtil C3] forState:UIControlStateNormal];
        [_alertBtn addTarget:self action:@selector(alertAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _alertBtn;
}

@end

//
//  CFDWelcomeAlert.m
//  LiveTrade
//
//  Created by ngw15 on 2018/11/19.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "CFDWelcomeAlert.h"

@interface CFDWelcomeView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) UILabel *remarkLabel;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIView *vLine;

@property (nonatomic,strong) dispatch_block_t sureHander;


@property (nonatomic,strong) UIColor *tinColor;
@end

@implementation CFDWelcomeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [GColorUtil colorWithHex:0x000000 alpha:0.4];
        _tinColor = [GColorUtil C13];
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.vLine];
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.sureBtn];
}

- (void)autoLayout{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo([GUIUtil fit:-10]);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo([GUIUtil fit:300]);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:0]);
        make.height.mas_equalTo([GUIUtil fit:55]);
        make.centerX.mas_equalTo(0);
    }];
    [_vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:55]);
        make.left.right.mas_equalTo([GUIUtil fit:0]);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:200]);
        make.top.equalTo(self.vLine.mas_bottom).mas_offset([GUIUtil fit:15]);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.width.mas_equalTo([GUIUtil fit:270]);
        make.top.mas_equalTo([GUIUtil fit:2]);
        make.bottom.mas_equalTo([GUIUtil fit:-2]);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
       make.top.equalTo(self.scrollView.mas_bottom).mas_offset([GUIUtil fit:20]);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom);
        
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:44]);
        make.bottom.mas_equalTo([GUIUtil fit:0]);
    }];
}

//MARK: - Action

- (void)setTinColor:(UIColor *)tinColor{
    if (tinColor) {
        _tinColor = tinColor;
        [_sureBtn setTitleColor:_tinColor forState:UIControlStateNormal];
    }
}

- (void)sureAction{
    [self removeFromSuperview];
    if(self.sureHander){
        self.sureHander();
    }
}

- (void)cancelAction{
    [self removeFromSuperview];
}

//MARK: - Getter

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [GColorUtil colorWithWhiteColorType:C5_ColorType];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font =[GUIUtil fitBoldFont:16];
        _titleLabel.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
    }
    return _titleLabel;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.alwaysBounceVertical = YES;
        _scrollView.alwaysBounceHorizontal = NO;
        _scrollView.showsVerticalScrollIndicator = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.font =[GUIUtil fitFont:16];
        _remarkLabel.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _remarkLabel;
}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [GColorUtil colorWithWhiteColorType:C7_ColorType];
    }
    return _line;
}

- (UIView *)vLine{
    if (!_vLine) {
        _vLine = [[UIView alloc] init];
        _vLine.backgroundColor = [GColorUtil colorWithWhiteColorType:C7_ColorType];
    }
    return _vLine;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:CFDLocalizedString(@"确定") forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [GUIUtil fitFont:16];
        [_sureBtn setTitleColor:_tinColor forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end

@implementation CFDWelcomeAlert


+ (void)showAlert:(NSString *)title
           detail:(id)detail
        sureTitle:(NSString *)sure
       sureHander:(dispatch_block_t)sureHander{
    UIWindow *window = [GJumpUtil window];
    CFDWelcomeView *view = [[CFDWelcomeView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.titleLabel.text = title;
    view.tag = 4442;
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:detail];
    attStr.lineSpacing = [GUIUtil fit:5];
    attStr.color = [GColorUtil colorWithWhiteColorType:C2_ColorType];
    view.remarkLabel.attributedText = attStr;
    view.sureHander = sureHander;
    [view.sureBtn setTitle:sure forState:UIControlStateNormal];
    [window addSubview:view];
    view.contentView.transform = CGAffineTransformIdentity;
}


+ (void)hide{
    UIWindow *window = [GJumpUtil window];
    CFDWelcomeView *view = [window viewWithTag:4442];
    [view cancelAction];
    [view removeFromSuperview];
}

@end


//
//  QZHMyNotLoginView.m
//  niuguwang
//
//  Created by jly on 2017/7/6.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "MineHeaderView.h"
#import "BaseImageView.h"
#import "BaseLabel.h"
#import "BaseBtn.h"

@interface MineHeaderView ()
@property (nonatomic,strong)BaseLabel *titleLabel;
@property (nonatomic,strong)UIButton *changedBtn;
@property (nonatomic,strong)BaseBtn *rightBtn;
@property (nonatomic,strong)UIControl *loginBtn;
@property (nonatomic,strong)BaseImageView *logoImgView;
@property (nonatomic,strong)BaseLabel *loginLabel;
@property (nonatomic,strong)BaseLabel *remarkLabel;
@property (nonatomic,strong)BaseImageView *arrowImgView;
@property (nonatomic,strong)BaseImageView *inviteImgView;
@end

@implementation MineHeaderView

+ (CGFloat)heightOfView{
    return [GUIUtil fit:260]+STATUS_BAR_HEIGHT;
}

- (id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI
{
    self.bgColor = C6_ColorType;
    [self addSubview:self.titleLabel];
    [self addSubview:self.changedBtn];
    [self addSubview:self.rightBtn];
    [self addSubview:self.loginBtn];
    [self addSubview:self.logoImgView];
    [self addSubview:self.loginLabel];
    [self addSubview:self.remarkLabel];
    [self addSubview:self.arrowImgView];
    [self addSubview:self.inviteImgView];
}

-(void)autoLayout
{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(0);
        make.centerY.equalTo(self.mas_top).mas_offset(STATUS_BAR_HEIGHT+22);
    }];
    [self.changedBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.equalTo(self.rightBtn.mas_left).mas_offset([GUIUtil fit:-15]);
    }];
    [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.right.mas_equalTo([GUIUtil fit:-15]);
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:60]+STATUS_BAR_HEIGHT);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo([GUIUtil fitWidth:375 height:70]);
    }];
    [self.loginLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.logoImgView.mas_centerY).mas_offset([GUIUtil fit:0]);
        make.left.equalTo(self.logoImgView.mas_right).mas_offset([GUIUtil fit:15]);
    }];
    [self.remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginLabel.mas_bottom).mas_offset([GUIUtil fit:3]);
        make.left.equalTo(self.loginLabel);
    }];
    
    [self.logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:75]+STATUS_BAR_HEIGHT);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.size.mas_equalTo([GUIUtil fitWidth:45 height:45]);
    }];
    [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.equalTo(self.logoImgView);
    }];
    [_inviteImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logoImgView.mas_bottom).mas_offset([GUIUtil fit:35]);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:90]);
    }];
}

- (void)rightAction{
    [CFDJumpUtil jumpToService];
}

- (void)updateView{
    
    if ([UserModel isLogin]==NO) {
        _loginLabel.textBlock = CFDLocalizedStringBlock(@"请登录/注册");
        _remarkLabel.textBlock = CFDLocalizedStringBlock(@"欢迎来到Bitmixs");
        _arrowImgView.hidden = NO;
    }else{
        NSMutableString *phone = [UserModel sharedInstance].mobilePhone.mutableCopy;
        if (phone.length==11) {
            [phone replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
        }else{
            phone=@"".mutableCopy;
        }
        _loginLabel.text = phone;
        _arrowImgView.hidden = YES;
    }
}

- (void)changedAction{
    [CFDApp sharedInstance].isWhiteTheme = ![CFDApp sharedInstance].isWhiteTheme;
    [NLocalUtil setBool:[CFDApp sharedInstance].isWhiteTheme forKey:@"isWhiteTheme"];
    [[NSNotificationCenter defaultCenter] postNotificationName:ThemeDidChangedNotification object:self];
    _changedBtn.selected = ![CFDApp sharedInstance].isWhiteTheme;
}

#pragma mark ---setter and getter

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.txColor = C2_ColorType;
        _titleLabel.font = [GUIUtil fitBoldFont:18];
        _titleLabel.numberOfLines = 1;
        _titleLabel.textBlock = CFDLocalizedStringBlock(@"我的");
    }
    return _titleLabel;
}

- (UIButton *)changedBtn{
    if (!_changedBtn) {
        _changedBtn = [[UIButton alloc] init];
        [_changedBtn setImage:[GColorUtil imageNamed:@"mine_icon_moon"] forState:UIControlStateNormal];
        [_changedBtn setImage:[GColorUtil imageNamed:@"mine_icon_sun"] forState:UIControlStateSelected];
        [_changedBtn addTarget:self action:@selector(changedAction) forControlEvents:UIControlEventTouchUpInside];
        _changedBtn.selected = ![CFDApp sharedInstance].isWhiteTheme;
        [_changedBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _changedBtn;
}

- (BaseBtn *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[BaseBtn alloc] init];
        _rightBtn.imageName = @"mine_icon_customer";
        [_rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _rightBtn;
}

- (UIControl *)loginBtn
{
    if(!_loginBtn)
    {
        _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginBtn g_clickBlock:^(id sender) {
            if ([UserModel isLogin]==NO) {
                [CFDJumpUtil jumpToLogin];
            }
        }];
        
    }
    return _loginBtn;
}

- (BaseLabel *)loginLabel{
    if (!_loginLabel) {
        _loginLabel = [[BaseLabel alloc] init];
        _loginLabel.txColor = C2_ColorType;
        _loginLabel.font = [GUIUtil fitBoldFont:16];
        _loginLabel.numberOfLines = 1;
        _loginLabel.text = @"请登录/注册";
    }
    return _loginLabel;
}

- (BaseLabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[BaseLabel alloc] init];
        _remarkLabel.txColor = C3_ColorType;
        _remarkLabel.font = [GUIUtil fitBoldFont:10];
        _remarkLabel.numberOfLines = 1;
        _remarkLabel.textBlock=CFDLocalizedStringBlock(@"欢迎来到Bitmixs");
    }
    return _remarkLabel;
}


- (BaseImageView *)logoImgView
{
    if(!_logoImgView)
    {
        _logoImgView = [BaseImageView new];
        _logoImgView.imageName = @"mine_logo";
        
    }
    return _logoImgView;
}

- (BaseImageView *)arrowImgView{
    if(!_arrowImgView)
    {
        _arrowImgView = [BaseImageView new];
        _arrowImgView.imageName = @"public_icon_more";
        
    }
    return _arrowImgView;
}

- (BaseImageView *)inviteImgView{
    if (!_inviteImgView) {
        _inviteImgView = [[BaseImageView alloc] initWithImage:[GColorUtil imageNamed:@"mine_banner"]];
        
        [_inviteImgView g_clickBlock:^(UITapGestureRecognizer *tap) {
            if (![UserModel isLogin]) {
                [CFDJumpUtil jumpToLogin];
                return ;
            }
            NSString *url = @"https://inline.bitmixs.com/return-commission.html";
            
            [CFDJumpUtil jumpToWeb:@"邀请好友赚取高额佣金" link:url animated:YES];
        }];
    }
    return _inviteImgView;
}

@end

//
//  DisnetView.m
//  niuguwang
//
//  Created by BrightLi on 2017/6/19.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "DisnetView.h"

@implementation DisnetUtil :NSObject

@end

@implementation DisnetBar

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initUI];
        [self layout];
    }
    return self;
}

- (void) initUI
{
    self.backgroundColor=[GColorUtil colorWithHex:0xFFFAE7];
    [self addSubview:self.warnIcon];
    [self addSubview:self.label];
    [self addSubview:self.arrowIcon];
}

- (void) layout
{
    [_warnIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(15);
        make.width.mas_equalTo(15);
        make.centerY.mas_equalTo(0);
    }];
    [_arrowIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(6);
        make.centerY.mas_equalTo(0);
    }];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.warnIcon.mas_right).offset(9);
        make.right.mas_equalTo(self.arrowIcon.mas_left).offset(-9);
        make.centerY.mas_equalTo(0);
    }];
    WEAK_SELF;
    [self g_clickBlock:^(UITapGestureRecognizer *tap) {
        [weakSelf clickDisnet];
    }];
}

- (void) clickDisnet
{
//    NAlert *alert=[[NAlert alloc]init];
//    alert.title=@"无法连接网络";
//    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
//    alert.content=[NSString stringWithFormat:@"请确保手机网络畅通,且[%@]的网络权限已开启",appName];
//    alert.sureTitle=@"设置权限";
//    alert.cancelTitle=@"我知道了";
//    alert.showType=NAlertShowSlideInToCenter;
//    alert.hideType=NAlertHideSlideOutToCenter;
//    alert.sureBlock=^{
//        [GJumpUtil jumpToAppSetting];
//    };
//    [alert show];
}

- (UIImageView *) warnIcon
{
    if(!_warnIcon){
        _warnIcon=[[UIImageView alloc] init];
        _warnIcon.image=[UIImage imageNamed:@"icon_network"];
    }
    return _warnIcon;
}

- (UILabel *) label
{
    if(!_label){
        _label=[[UILabel alloc] init];
        _label.textColor=[GColorUtil colorWithHex:0xE98D22];
        _label.font=[GUIUtil fitFont:12];
        _label.text=CFDLocalizedString(@"网络异常,请检查您的网络设置");
    }
    return _label;
}

- (UIImageView *) arrowIcon
{
    if(!_arrowIcon){
        _arrowIcon=[[UIImageView alloc] init];
        _arrowIcon.image=[UIImage imageNamed:@""];
    }
    return _arrowIcon;
}

@end

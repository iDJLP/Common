//
//  StateUtil.m
//  newfcox
//
//  Created by ngw15 on 2018/4/28.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "StateUtil.h"


#define STATE_BASE_TAG 900000

@implementation StateUtil

// 显示状态视图
+ (StateView *) show:(UIView *) target type:(StateType) type isWhiteTheme:(BOOL)isWhiteTheme
{
    if(!target){
        return nil;
    }
    [self hide:target];
    NSInteger tag=STATE_BASE_TAG + type;
    StateView *state=[target viewWithTag:tag];
    if(!state){
        state=[StateUtil viewWithType:type];
        if (type == StateTypeProgress) {
            ProgressStateView *stateView = (ProgressStateView *)state;
            if (isWhiteTheme) {
                stateView.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
            }else{
                stateView.indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
            }
        }
        state.tag=tag;
        [target addSubview:state];
        [state mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.equalTo(target);
        }];
    }
    return state;
}

// 显示状态视图
+ (StateView *) show:(UIView *) target type:(StateType) type
{
    return [self show:target type:type isWhiteTheme:[CFDApp sharedInstance].isWhiteTheme];
}
// 创建状态视图
+(StateView *) viewWithType:(StateType) type
{
    if(type==StateTypeProgress){
        return [[ProgressStateView alloc] init];
    }
    if(type==StateTypeReload){
        return [[ReloadStateView alloc] init];
    }
    if(type==StateTypeChildReload){
        return [[ReloadChildStateView alloc] init];
    }
    return [[NoDataStateView alloc] init];
}
// 关闭状态视图
+ (void) hide:(UIView *) target
{
    if(!target){
        return;
    }
    StateView *state=[target viewWithTag: STATE_BASE_TAG + StateTypeNodata];
    if(state && state.superview==target && [state isKindOfClass:[NoDataStateView class]]){
        [state removeFromSuperview];
    }
    state=[target viewWithTag: STATE_BASE_TAG + StateTypeProgress];
    if(state && state.superview==target && [state isKindOfClass:[ProgressStateView class]]){
        [state removeFromSuperview];
    }
    state=[target viewWithTag: STATE_BASE_TAG + StateTypeReload];
    if(state && state.superview==target && [state isKindOfClass:[ReloadStateView class]]){
        [state removeFromSuperview];
    }
    state=[target viewWithTag: STATE_BASE_TAG + StateTypeChildReload];
    if(state && state.superview==target && [state isKindOfClass:[ReloadChildStateView class]]){
        [state removeFromSuperview];
    }
}

@end

@interface StateView ()


@end

@implementation StateView



@end

@implementation NoDataStateView

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.bgColor = C6_ColorType;
        [self initUI];
        [self layout];
    }
    return self;
}

- (void) initUI
{
    [self addSubview:self.icon];
    [self addSubview:self.title];
}

- (void) layout
{
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.multipliedBy(0.8);
    }];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).mas_offset(10);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
}

- (void)updateTheme:(BOOL)isWhiteTheme{
    if (isWhiteTheme) {
        self.backgroundColor = [GColorUtil colorWithWhiteColorType:C6_ColorType];
        self.title.textColor = [GColorUtil colorWithWhiteColorType:C3_ColorType];
        self.icon.image = [GColorUtil imageNamed_whiteTheme:@"schematic_nothing_light"];
    }else{
        self.backgroundColor = [GColorUtil colorWithBlackColorType:C6_ColorType];
        self.title.textColor = [GColorUtil colorWithBlackColorType:C3_ColorType];
        self.icon.image = [UIImage imageNamed:@"schematic_nothing"];
    }
}

- (BaseImageView *) icon
{
    if(!_icon){
        _icon=[[BaseImageView alloc] init];
        _icon.imageName = @"schematic_nothing";
    }
    return _icon;
}

- (BaseLabel *) title
{
    if(!_title){
        _title=[[BaseLabel alloc] init];
        _title.txColor = C2_ColorType;
        _title.font=[GUIUtil fitFont:12];
        _title.textAlignment=NSTextAlignmentCenter;
        _title.text=CFDLocalizedString(@"暂无数据");
    }
    return _title;
}

@end

@implementation ProgressStateView

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.bgColor = C6_ColorType;
        [self initUI];
        [self layout];
        WEAK_SELF;
        _task=[NTimeUtil run:^{
            weakSelf.indicator.hidden=NO;
            weakSelf.title.hidden=NO;
            [weakSelf.indicator startAnimating];
        } delay:0.5];
    }
    return self;
}

- (void) dealloc
{
    if(_task){
        [NTimeUtil cancelDelay:_task];
        _task=nil;
    }
    [_indicator stopAnimating];
}

- (void) initUI
{
    [self addSubview:self.indicator];
    [self addSubview:self.title];
}

- (void) layout
{
    [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.multipliedBy(0.9).offset([GUIUtil fit:-10]);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(40);
    }];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.indicator.mas_bottom).mas_offset(5);
        make.left.mas_equalTo(15);
        make.right.mas_equalTo(-15);
    }];
}

- (void)updateTheme:(BOOL)isWhiteTheme{
    if (isWhiteTheme) {
        self.backgroundColor = [GColorUtil colorWithWhiteColorType:C6_ColorType];
        self.title.textColor = [GColorUtil colorWithWhiteColorType:C3_ColorType];
    }else{
        self.backgroundColor = [GColorUtil colorWithBlackColorType:C6_ColorType];
        self.title.textColor = [GColorUtil colorWithBlackColorType:C3_ColorType];
    }
}

- (UIActivityIndicatorView *) indicator
{
    if(!_indicator){
        _indicator= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                     UIActivityIndicatorViewStyleWhite];
        _indicator.hidden=YES;
    }
    return _indicator;
}

- (BaseLabel *) title
{
    if(!_title){
        _title=[[BaseLabel alloc] init];
        _title.hidden=YES;
        _title.txColor = C3_ColorType;
        _title.font=[GUIUtil fitFont:12];
        _title.textAlignment=NSTextAlignmentCenter;
        _title.text=CFDLocalizedString(@"正在加载...");
    }
    return _title;
}

@end

@implementation ReloadStateView

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.bgColor = C6_ColorType;
        [self initUI];
    }
    return self;
}

- (void) dealloc
{
}

- (void)updateTheme:(BOOL)isWhiteTheme{
    if (isWhiteTheme) {
        
        self.backgroundColor = [GColorUtil colorWithWhiteColorType:C6_ColorType];
        self.title.textColor = [GColorUtil colorWithWhiteColorType:C3_ColorType];
        self.icon.image = [GColorUtil imageNamed_whiteTheme:@"public_icon_default_nonetwork"];
    }else{
        self.backgroundColor = [GColorUtil colorWithBlackColorType:C6_ColorType];
        self.title.textColor = [GColorUtil colorWithBlackColorType:C3_ColorType];
        self.icon.image = [UIImage imageNamed:@"public_icon_default_nonetwork"];
    }
}

- (void) initUI
{
    self.bgColor = C6_ColorType;
    UIView *hotView=[[UIView alloc] init];
    _icon = [[BaseImageView alloc] init];
    _icon.imageName= @"public_icon_default_nonetwork";
    _title=[[BaseLabel alloc] init];
    _title.text=CFDLocalizedString(@"重新加载");
    _title.txColor=C3_ColorType;
    _title.font=[GUIUtil fitFont:14];
    _title.textAlignment=NSTextAlignmentCenter;
    [hotView addSubview:_icon];
    [hotView addSubview:_title];
    [self addSubview:hotView];
    [hotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.size.mas_equalTo([GUIUtil fitWidth:90 height:70]).priorityHigh();
    }];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).mas_offset([GUIUtil fit:15]);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:14]);
        make.bottom.mas_equalTo([GUIUtil fit:-12]).priorityLow();
    }];
    WEAK_SELF;
    [hotView g_clickBlock:^(UITapGestureRecognizer *tap) {
        if(weakSelf.onReload){
            weakSelf.onReload();
        }
    }];
}

@end

@implementation ReloadChildStateView

- (instancetype) init
{
    self = [super init];
    if (self) {
        self.bgColor = C6_ColorType;
        [self initUI];
    }
    return self;
}

- (void) dealloc
{
}

- (void) initUI
{
    self.bgColor = C6_ColorType;

    UIControl *hotView=[[UIControl alloc] init];
    _icon = [[BaseImageView alloc] init];
    _icon.imageName=@"public_icon_default_nonetwork";
    _title=[[BaseLabel alloc] init];
    _title.text=CFDLocalizedString(@"重新加载");
    _title.txColor=C3_ColorType;
    _title.font=[GUIUtil fitFont:14];
    _title.textAlignment=NSTextAlignmentCenter;
    [hotView addSubview:_icon];
    [hotView addSubview:_title];
    [self addSubview:hotView];
    [hotView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
    }];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo([GUIUtil fit:15]);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        
        make.size.mas_equalTo([GUIUtil fitWidth:90 height:70]).priorityHigh();
    }];
    [_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.icon.mas_bottom).mas_offset([GUIUtil fit:15]);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:14]);
        make.bottom.mas_equalTo([GUIUtil fit:-12]).priorityLow();
    }];
    [hotView addTarget:self action:@selector(hotAction) forControlEvents:UIControlEventTouchUpInside];
}


- (void)hotAction{
    if(self.onReload){
        self.onReload();
    }
}

@end



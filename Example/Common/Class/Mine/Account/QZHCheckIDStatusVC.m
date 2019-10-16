//
//  FCCheckIDStatusVC.m
//  niuguwang
//
//  Created by jly on 2017/4/1.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "QZHCheckIDStatusVC.h"


@interface QZHCheckIDStatusVC ()

@property (nonatomic,strong)UIImageView *IDStatusIView;
@property (nonatomic,strong)UILabel *IDStatusText;
@property (nonatomic,strong)UILabel *IDStatusRemark;
@property (nonatomic,strong)UIButton*sureBtn;

@end

@implementation QZHCheckIDStatusVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CFDLocalizedString(@"实名认证");
    [self initSubviews];
    [self initLayout];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    self.view.backgroundColor = [GColorUtil C6];
    self.navigationItem.leftBarButtonItem = [self backItem];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self checkStatus:_ststus];
    self.IDStatusRemark.text = self.info;
}

- (UIBarButtonItem *)backItem {
        CGFloat iconW=[GUIUtil fit:22];
        UIButton *button= [[UIButton alloc] initWithFrame:CGRectMake(0, 0, iconW, iconW)];
        [button setImage:[GColorUtil imageNamed:@"back"] forState:UIControlStateNormal];
        [button setImage:[GColorUtil imageNamed:@"back"] forState:UIControlStateHighlighted];
        [button g_clickEdgeWithTop:20 bottom:20 left:20 right:20];
        WEAK_SELF;
        [button g_clickBlock:^(id sender) {
            [weakSelf clickBack];
        }];
        return  [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)clickBack
{
       [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)checkStatus:(QZHCheckIDStatus)status
{
   
    switch (status) {
        case QZHCheckIDFailure:
        {
            [self.sureBtn setTitle:CFDLocalizedString(@"重新认证") forState:UIControlStateNormal];
            self.IDStatusText.text   = CFDLocalizedString(@"认证失败");
            self.IDStatusIView.image = [GColorUtil imageNamed:@"approve_failure"];
        }
            break;
 
        case QZHCheckIDSuccess:
        {
            [self.sureBtn setTitle:CFDLocalizedString(@"确认") forState:UIControlStateNormal];
            self.IDStatusText.text   = CFDLocalizedString(@"认证成功");
            self.IDStatusIView.image = [GColorUtil imageNamed:@"approve_succeed"];
        }
            break;
        case QZHWebVCLoadFailue:
        {
            [self.sureBtn setTitle:CFDLocalizedString(@"重新加载") forState:UIControlStateNormal];
            self.IDStatusText.text   = CFDLocalizedString(@"抱歉～加载失败，请您重新加载");
            self.IDStatusIView.image = [GColorUtil imageNamed:@"approve_failure"];
        }
            break;
        default:
            break;
    }
}
- (void)initSubviews
{
    [self.view addSubview:self.IDStatusIView];
    [self.view addSubview:self.IDStatusText];
    [self.view addSubview:self.IDStatusRemark];
    [self.view addSubview:self.sureBtn];
}

- (void)initLayout
{
    
    [self.IDStatusIView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:70]+TOP_BAR_HEIGHT);
        make.centerX.equalTo(self.view);
        
    }];
    
    [self.IDStatusText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.top.mas_equalTo(self.IDStatusIView.mas_bottom).mas_offset([GUIUtil fit:17]);
    }];
    
    [self.IDStatusRemark mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.top.mas_equalTo(self.IDStatusText.mas_bottom).mas_offset([GUIUtil fit:10]);
    }];
    [self.sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.height.mas_equalTo([GUIUtil fit:49]);
        make.top.mas_equalTo(self.IDStatusText.mas_bottom).mas_offset([GUIUtil fit:70]);
    }];
    
    
}
#pragma mark -------init

- (UIImageView *)IDStatusIView
{
    if(!_IDStatusIView)
    {
        _IDStatusIView = [UIImageView new];
        
    }
    return _IDStatusIView;
}

- (UILabel *)IDStatusText
{
    if(!_IDStatusText)
    {
        _IDStatusText = [UILabel new];
        _IDStatusText.textColor = [GColorUtil C2];
        _IDStatusText.font      = [GUIUtil fitFont:18];
        _IDStatusText.textAlignment = NSTextAlignmentCenter;
    }
    return _IDStatusText;
}


- (UILabel *)IDStatusRemark
{
    if(!_IDStatusRemark)
    {
        _IDStatusRemark = [UILabel new];
        _IDStatusRemark.textColor = [GColorUtil C3];
        _IDStatusRemark.font      = [GUIUtil fitFont:12];
        _IDStatusRemark.textAlignment = NSTextAlignmentCenter;
        _IDStatusRemark.numberOfLines = 0;
    }
    return _IDStatusRemark;
}

- (UIButton *)sureBtn
{
    if(!_sureBtn)
    {
        _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sureBtn setTitleColor:[GColorUtil C2_black] forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 2;
        _sureBtn.clipsToBounds = YES;
        _sureBtn.backgroundColor = [GColorUtil C13];
        WEAK_SELF;
        [_sureBtn g_clickBlock:^(id sender) {
            [weakSelf sureAction];
        }];
    }
    return _sureBtn;
}


- (void)sureAction
{
    switch (_ststus) {
        case QZHCheckIDFailure:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
         case QZHCheckIDSuccess:
        {
            [self clickBack];
        }
            break;
        case QZHWebVCLoadFailue:
        {
            if(self.reConfimblock)
                self.reConfimblock();
        }
            break;
        default:
            break;
    }
}

@end

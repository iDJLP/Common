//
//  SecurityClosedVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/5/17.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "SecurityClosedVC.h"
#import "SecurityVerifyView.h"
#import "PhoneVerifyAlert.h"
#import "BaseBtn.h"

@interface SecurityClosedVC ()

@property (nonatomic,strong) SecurityVerifyView *verifyView;
@property (nonatomic,strong) UIButton *commitBtn;

@end

@implementation SecurityClosedVC

+ (void)jumpTo{
    SecurityClosedVC *target = [[SecurityClosedVC alloc] init];
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GColorUtil C6];
    self.title = CFDLocalizedString(@"关闭谷歌二次验证");
    [self setupUI];
    [self autoLayout];
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    [self.view addSubview:self.verifyView];
    [self.view addSubview:self.commitBtn];
}

- (void)autoLayout{
    [_verifyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo([GUIUtil fit:70]);
        make.height.mas_equalTo([GUIUtil fit:200]);
    }];
    [_commitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-IPHONE_X_BOTTOM_HEIGHT);
        make.height.mas_equalTo([GUIUtil fit:49]);
    }];
}

- (void)commitAction{
    WEAK_SELF;
    [HUDUtil showProgress:@""];
    [DCService verifyGoogleAuth:_verifyView.pwdText key:@"" success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [HUDUtil hide];
            [PhoneVerifyAlert showAlert:^{
                [HUDUtil showInfo:CFDLocalizedString(@"操作成功")];
                [UserModel sharedInstance].openGoogleAuth=NO;
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } key1:@"" key2:@"" googleCode:weakSelf.verifyView.pwdText];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"message"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

- (SecurityVerifyView *)verifyView{
    if (!_verifyView) {
        _verifyView = [[SecurityVerifyView alloc] init];
        WEAK_SELF;
        
        _verifyView.pwdChangedHander = ^{
            if (weakSelf.verifyView.pwdText.length==6) {
                weakSelf.commitBtn.enabled = YES;
            }else{
                weakSelf.commitBtn.enabled = NO;
            }
        };
    }
    return _verifyView;
}

- (UIButton *)commitBtn{
    if (!_commitBtn) {
        _commitBtn = [[UIButton alloc] init];
        [_commitBtn setBackgroundImage:[UIImage imageWithColor:[GColorUtil C13] size:[GUIUtil fitWidth:375 height:49]] forState:UIControlStateNormal];
        [_commitBtn setBackgroundImage:[UIImage imageWithColor:[GColorUtil disEnableColor] size:[GUIUtil fitWidth:375 height:49]] forState:UIControlStateDisabled];
        [_commitBtn setTitle:CFDLocalizedString(@"确认_close") forState:UIControlStateNormal];
        [_commitBtn setTitleColor:[GColorUtil C5] forState:UIControlStateNormal];
        [_commitBtn addTarget:self action:@selector(commitAction) forControlEvents:UIControlEventTouchUpInside];
        _commitBtn.enabled = NO;
    }
    return _commitBtn;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

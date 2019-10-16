//
//  SecurityOpenedVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/5/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "SecurityOpenedVC.h"
#import "SecurityStepView.h"
#import "SecurityStepDetailView.h"

@interface SecurityOpenedVC ()

@property (nonatomic,strong)SecurityStepView *stepView;
@property (nonatomic,strong)SecurityStepDetailView *detailView;

@end

@implementation SecurityOpenedVC

+ (void)jumpTo{
    SecurityOpenedVC *target = [[SecurityOpenedVC alloc] init];
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GColorUtil C6];
    self.title = CFDLocalizedString(@"开启谷歌二次验证");
    [self setupUI];
    [self autoLayout];
}

- (void)setupUI{
    [self.view addSubview:self.stepView];
    [self.view addSubview:self.detailView];
}

- (void)autoLayout{
    [_stepView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
    }];
    [_detailView mas_makeConstraints:^(MASConstraintMaker *make) {
         make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.stepView.mas_bottom).mas_offset([GUIUtil fit:0]);
    }];
}

- (SecurityStepView *)stepView{
    if (!_stepView) {
        _stepView = [[SecurityStepView alloc] init];
    }
    return _stepView;
}

- (SecurityStepDetailView *)detailView{
    if (!_detailView) {
        _detailView = [[SecurityStepDetailView alloc] init];
        _detailView.backgroundColor = [GColorUtil C6];
        WEAK_SELF;
        _detailView.stepChangedHander = ^(NSInteger stepIndex) {
            [weakSelf.stepView configOfStep:stepIndex];
        };
    }
    return _detailView;
}

@end

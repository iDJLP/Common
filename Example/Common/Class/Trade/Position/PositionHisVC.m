//
//  PositionHisVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/25.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "PositionHisVC.h"
#import "PosHisView.h"
#import "SectionView.h"
#import "PosHisView.h"
#import "EntrustHisView.h"
#import "CFdScrollView.h"
#import "PostionChoiceView.h"

@interface PositionHisVC ()<UIScrollViewDelegate>
@property (nonatomic,strong)PostionChoiceView *choiceView;
@property (nonatomic,strong)PostionChoiceView *choiceEntrustView;
@property (nonatomic,strong)SectionView *sectionView;
@property (nonatomic,strong)CFDScrollView *hScrollView;
@property (nonatomic,strong)PosHisView *posView;
@property (nonatomic,strong)EntrustHisView *entrustView;
@property (nonatomic,assign)NSInteger selectedIndex;
@end

@implementation PositionHisVC

+(void)jumpTo{
    PositionHisVC *target = [[PositionHisVC alloc] init];
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_posView willAppear];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CFDLocalizedString(@"交易历史") ;
    self.view.backgroundColor = [GColorUtil C6];
    WEAK_SELF;
    [GNavUtil rightTitle:self title:CFDLocalizedString(@"筛选") color:C22_ColorType onClick:^{
        NSString *params = weakSelf.selectedIndex==0?weakSelf.posView.params:weakSelf.entrustView.params;
        if (!weakSelf.choiceView.superview) {
            [weakSelf.view addSubview:weakSelf.choiceView];
        }
        [weakSelf.choiceView willAppear:params isEntrust:weakSelf.selectedIndex==1];
    }];
    [self setupUI];
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    [self.view addSubview:self.sectionView];
    [self.view addSubview:self.hScrollView];
    [_hScrollView addSubview:self.posView];
    [_hScrollView addSubview:self.entrustView];
    [_sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:40]);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [_hScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.sectionView.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [_posView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.equalTo(self.hScrollView);
        make.top.mas_equalTo(0);
    }];
    [_entrustView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.equalTo(self.hScrollView);
        make.top.mas_equalTo(0);
        make.left.equalTo(self.posView.mas_right);
        make.right.mas_equalTo(0);
    }];
}

- (void)changedSelectedIndex:(NSInteger)index{
    _selectedIndex = index;
    if (_selectedIndex==0) {
        [_posView willAppear];
    }else if (_selectedIndex==1){
        [_entrustView willAppear];
    }
    if (_hScrollView.dragging==NO) {
        [_hScrollView setContentOffset:CGPointMake(SCREEN_WIDTH*_selectedIndex, 0) animated:NO];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_hScrollView) {
        NSInteger index = (_hScrollView.contentOffset.x+SCREEN_WIDTH/2)/SCREEN_WIDTH;
        [_sectionView changeSelectedIndex:index];
    }
}

//MARK: - Getter

- (PostionChoiceView *)choiceView{
    if (!_choiceView) {
        _choiceView = [[PostionChoiceView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - TOP_BAR_HEIGHT)];
        _choiceView.backgroundColor = [GColorUtil colorWithHex:0x000000 alpha:0.4];
        WEAK_SELF;
        _choiceView.loadDataHander = ^(NSString * _Nonnull params) {
            if (weakSelf.selectedIndex==0) {
                weakSelf.posView.params = params;
                [weakSelf.posView requestData:YES];
                
            }else{
                weakSelf.entrustView.params = params;
                [weakSelf.entrustView requestData:YES];
            }
        };
    }
    return _choiceView;
}


- (CFDScrollView *)hScrollView{
    if (!_hScrollView) {
        _hScrollView = [[CFDScrollView alloc] init];
        _hScrollView.showsHorizontalScrollIndicator = NO;
        _hScrollView.showsVerticalScrollIndicator = NO;
        _hScrollView.bounces = NO;
        _hScrollView.pagingEnabled = YES;
        _hScrollView.delegate = self;
    }
    return _hScrollView;
}

- (SectionView *)sectionView{
    if (!_sectionView) {
        NSArray *title = @[CFDLocalizedString(@"结算历史"),CFDLocalizedString(@"委托历史")];
        _sectionView = [[SectionView alloc] initWithList:title sectionType:SectionTypeDivideWidth];
        _sectionView.backgroundColor = [GColorUtil C6];
        WEAK_SELF;
        _sectionView.changedSelectedIndex = ^(NSInteger index) {
            [weakSelf changedSelectedIndex:index];
        };
    }
    return _sectionView;
}

- (PosHisView *)posView{
    if (!_posView) {
        _posView = [[PosHisView alloc] init];
        
    }
    return _posView;
}

- (EntrustHisView *)entrustView{
    if (!_entrustView) {
        _entrustView = [[EntrustHisView alloc] init];
    }
    return _entrustView;
}

@end

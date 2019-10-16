//
//  FundFlowVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/20.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "FundFlowVC.h"
#import "FundFlowTableView.h"
#import "CFDScrollView.h"

@interface FundFlowVC ()<UIScrollViewDelegate>

@property (nonatomic,strong)CFDScrollView *scorllView;
@property (nonatomic,strong)FundFlowSectionView *topView;
@property (nonatomic,strong)NSMutableArray <FundFlowTableView *>*tableViewList;
@property (nonatomic,strong)NSArray *list;
@end

@implementation FundFlowVC

+ (void)jumpTo{
    FundFlowVC *target = [[FundFlowVC alloc] init];
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GColorUtil C6];
    self.title = CFDLocalizedString(@"资金明细");
    [self initSubViews];
    [_topView setSelected:0];
}


- (void)initSubViews
{
    [self.view addSubview:self.scorllView];
    _tableViewList = [NSMutableArray array];
    NSMutableArray *tem = [NSMutableArray array];
    for (NSDictionary *dic in self.list) {
        [tem addObject:dic[@"title"]];
        FlowOpType type = [dic[@"type"] integerValue];
        NSInteger index = [_list indexOfObject:dic];
        FundFlowTableView *tableView = self.tableView;
        tableView.type = type;
        [_tableViewList addObject:tableView];
        [_scorllView addSubview:tableView];
        tableView.frame = CGRectMake(index*SCREEN_WIDTH, 0, SCREEN_WIDTH, _scorllView.height);
    }
    _topView = [[FundFlowSectionView alloc]initWithList:tem];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [GUIUtil fit:40]);
    WEAK_SELF;
    _topView.didSelectedHander = ^(NSInteger index) {
        FundFlowTableView *tableView = [NDataUtil dataWithArray:weakSelf.tableViewList index:index];
        if (tableView) {
            [weakSelf.scorllView setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:YES];
            [tableView viewWillAppear];
        }
    };
    [self.view addSubview:self.topView];
}

#pragma mark ---- init

- (CFDScrollView *)scorllView
{
    if(!_scorllView)
    {
        _scorllView = [[CFDScrollView alloc]initWithFrame:CGRectMake(0, [GUIUtil fit:40], SCREEN_WIDTH, SCREEN_HEIGHT - TOP_BAR_HEIGHT  - [GUIUtil fit:40])];
        _scorllView.showsHorizontalScrollIndicator = NO;
        _scorllView.contentSize     = CGSizeMake(SCREEN_WIDTH *self.list.count, SCREEN_HEIGHT - TOP_BAR_HEIGHT-[GUIUtil fit:40]);
        _scorllView.contentOffset   = CGPointMake(0, 0);
        _scorllView.pagingEnabled   = YES;
        _scorllView.delegate        = self;
    }
    return _scorllView;
}

- (FundFlowTableView *)tableView{
    FundFlowTableView *tableView = [[FundFlowTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    return tableView;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    CGFloat offsetX = targetContentOffset->x;
    NSInteger index = offsetX/self.view.frame.size.width+0.5;
    [self.topView setSelected:index];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = scrollView.contentOffset.x/self.view.frame.size.width+0.5;
    [self.topView setSelected:index];
    
}

- (NSArray *)list{
    if (!_list) {
        NSDictionary *dic = @{@"title":CFDLocalizedString(@"全部"),@"type":@(FlowOpTypeAll)};
        NSDictionary *dic1 = @{@"title":CFDLocalizedString(@"充值"),@"type":@(FlowOpTypeDeposit)};
        NSDictionary *dic2 = @{@"title":CFDLocalizedString(@"提现"),@"type":@(FlowOpTypeDrawl)};
        NSDictionary *dic3 = @{@"title":CFDLocalizedString(@"开仓"),@"type":@(FlowOpTypeTrade)};
        NSDictionary *dic4 = @{@"title":CFDLocalizedString(@"结算"),@"type":@(FlowOpTypeSettle)};
        NSDictionary *dic5 = @{@"title":CFDLocalizedString(@"委托"),@"type":@(FlowOpTypeEntrust)};
        NSDictionary *dic6 = @{@"title":CFDLocalizedString(@"撤单"),@"type":@(FlowOpTypeCancel)};
        _list = @[dic,dic1,dic2,dic3,dic4,dic5,dic6];
    }
    return _list;
}

@end

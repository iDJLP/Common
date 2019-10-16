//
//  FundRecordVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/4/25.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "FundRecordVC.h"
#import "FundRecordTableView.h"
#import "CFDScrollView.h"
#import "ChoiceView.h"
#import "ChoiceTransferView.h"

@interface FundRecordVC ()<UIScrollViewDelegate>

@property (nonatomic,strong)CFDScrollView *scorllView;
@property (nonatomic,strong)FundRecordSectionView *topView;
@property (nonatomic,strong)ChoiceView *choiceView;
@property (nonatomic,strong)ChoiceTransferView *choiceTransferView;
@property (nonatomic,strong)NSMutableArray <FundRecordTableView *>*tableViewList;
@property (nonatomic,strong)NSArray *list;
@property (nonatomic,assign)NSInteger index;
@end

@implementation FundRecordVC

+ (void)jumpTo{
    [self jumpTo:0];
}

+ (void)jumpTo:(NSInteger)index{
    FundRecordVC *target = [[FundRecordVC alloc] init];
    target.index = index;
    __weak typeof(target) weakTarget = target;
    [NTimeUtil run:^{
        [weakTarget.topView setSelected:index];
    } delay:0.5];
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GColorUtil C6];
    self.title = CFDLocalizedString(@"资金记录");
    WEAK_SELF;
    [GNavUtil rightTitle:self title:CFDLocalizedString(@"筛选") color:C22_ColorType onClick:^{
        if (weakSelf.index==4) {
            if (!weakSelf.choiceTransferView.superview) {
                [weakSelf.view addSubview:weakSelf.choiceTransferView];
                weakSelf.choiceTransferView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - TOP_BAR_HEIGHT);
            }
            FundRecordTableView *tableView = [NDataUtil dataWithArray:weakSelf.tableViewList index:weakSelf.index];
            [weakSelf.choiceTransferView willAppear:tableView.params];
        }else{
            if (!weakSelf.choiceView.superview) {
                [weakSelf.view addSubview:weakSelf.choiceView];
                weakSelf.choiceView.frame = CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT - TOP_BAR_HEIGHT);
            }
            FundRecordTableView *tableView = [NDataUtil dataWithArray:weakSelf.tableViewList index:weakSelf.index];
            [weakSelf.choiceView willAppear:tableView.params];
        }
    }];
    [self initSubViews];
    [_topView setSelected:_index];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    FundRecordTableView *tableView = [NDataUtil dataWithArray:_tableViewList index:_index];
    [tableView refreshView];
}

- (void)initSubViews
{
    CGFloat topHeight = 0;
    if ([[FTConfig sharedInstance].lang isEqualToString:@"en"]) {
        topHeight = [GUIUtil fit:60];
    }else{
        topHeight = [GUIUtil fit:40];
    }
    self.scorllView.frame = CGRectMake(0, topHeight, SCREEN_WIDTH, SCREEN_HEIGHT - TOP_BAR_HEIGHT  - topHeight);
    _scorllView.contentSize     = CGSizeMake(SCREEN_WIDTH *self.list.count, SCREEN_HEIGHT - TOP_BAR_HEIGHT - topHeight);
    [self.view addSubview:self.scorllView];
  
    _tableViewList = [NSMutableArray array];
    NSMutableArray *tem = [NSMutableArray array];
    for (NSDictionary *dic in self.list) {
        [tem addObject:dic[@"title"]];
        FundRecordType type = [dic[@"type"] integerValue];
        NSInteger index = [_list indexOfObject:dic];
        FundRecordTableView *tableView = self.tableView;
        tableView.type = type;
        [_tableViewList addObject:tableView];
        [_scorllView addSubview:tableView];
        tableView.frame = CGRectMake(index*SCREEN_WIDTH, 0, SCREEN_WIDTH, _scorllView.height);
    }
    _topView = [[FundRecordSectionView alloc]initWithList:tem];
    _topView.frame = CGRectMake(0, 0, SCREEN_WIDTH, topHeight);
    WEAK_SELF;
    _topView.didSelectedHander = ^(NSInteger index) {
        FundRecordTableView *tableView = [NDataUtil dataWithArray:weakSelf.tableViewList index:index];
        if (tableView) {
            weakSelf.index = index;
            [weakSelf.scorllView setContentOffset:CGPointMake(index*SCREEN_WIDTH, 0) animated:YES];
            [tableView viewWillAppear];
        }
    };
    [self.view addSubview:self.topView];
}

#pragma mark ---- init

- (ChoiceView *)choiceView{
    if (!_choiceView) {
        _choiceView = [[ChoiceView alloc] init];
        _choiceView.backgroundColor = [GColorUtil colorWithHex:0x000000 alpha:0.4];
        WEAK_SELF;
        _choiceView.loadDataHander = ^(NSString * _Nonnull params) {
            FundRecordTableView *tableView = [NDataUtil dataWithArray:weakSelf.tableViewList index:weakSelf.index];
            tableView.params = params;
            [tableView refreshView];
        };
    }
    return _choiceView;
}

- (ChoiceTransferView *)choiceTransferView{
    if (!_choiceTransferView) {
        _choiceTransferView = [[ChoiceTransferView alloc] init];
        _choiceTransferView.backgroundColor = [GColorUtil colorWithHex:0x000000 alpha:0.4];
        WEAK_SELF;
        _choiceTransferView.loadDataHander = ^(NSString * _Nonnull params) {
            FundRecordTableView *tableView = [NDataUtil dataWithArray:weakSelf.tableViewList index:weakSelf.index];
            tableView.params = params;
            [tableView refreshView];
        };
    }
    return _choiceTransferView;
}

- (CFDScrollView *)scorllView
{
    if(!_scorllView)
    {
        _scorllView = [[CFDScrollView alloc]init];
        _scorllView.showsHorizontalScrollIndicator = NO;
        _scorllView.contentOffset   = CGPointMake(0, 0);
        _scorllView.pagingEnabled   = YES;
        _scorllView.delegate        = self;
    }
    return _scorllView;
}

- (FundRecordTableView *)tableView{
    FundRecordTableView *tableView = [[FundRecordTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
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
        NSDictionary *dic = @{@"title":CFDLocalizedString(@"OTC买币"),@"type":@(FundRecordTypeOtcDeposit)};
        NSDictionary *dic1 = @{@"title":CFDLocalizedString(@"链上转入"),@"type":@(FundRecordTypeChainDeposit)};
        NSDictionary *dic2 = @{@"title":CFDLocalizedString(@"OTC提现"),@"type":@(FundRecordTypeOtcDrawl)};
        NSDictionary *dic3 = @{@"title":CFDLocalizedString(@"链上转出"),@"type":@(FundRecordTypeChainDrawl)};
        NSDictionary *dic4 = @{@"title":CFDLocalizedString(@"币币兑换"),@"type":@(FundRecordTypeTransfer)};
        _list = @[dic,dic1,dic2,dic3,dic4];
    }
    return _list;
}

@end


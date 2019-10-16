//
//  AddressListVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/10/9.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "AddressListVC.h"
#import "AddressEditVC.h"
#import "AddressListCell.h"

@interface AddressListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)UIButton *addBtn;
@property (nonatomic,strong)NSArray *dataList;

@property (nonatomic,strong)NSString *type;

@end

@implementation AddressListVC

+ (void)jumpTo:(NSString *)type{
    AddressListVC *target = [[AddressListVC alloc] init];
    target.type = type;
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:CFDLocalizedString(@"%@出金地址管理"),_type];
    self.view.backgroundColor = [GColorUtil C8];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.addBtn];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, [GUIUtil fit:-49]-IPHONE_X_BOTTOM_HEIGHT, 0));
    }];
    [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-IPHONE_X_BOTTOM_HEIGHT);
        make.height.mas_equalTo([GUIUtil fit:49]);
    }];
    WEAK_SELF;
    [GUIUtil refreshWithHeader:_tableView refresh:^{
        [weakSelf loadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}

- (void)loadData{
    WEAK_SELF;
    [DCService addresslist:_type success:^(id data) {
        [weakSelf.tableView.mj_header endRefreshing];
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            weakSelf.dataList = [NDataUtil arrayWith:data[@"data"]];
            [weakSelf.tableView reloadData];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

#pragma mark ---tableview Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressListCell"];
    [cell configCell:[NDataUtil dictWithArray:self.dataList index:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [NDataUtil dictWithArray:self.dataList index:indexPath.row];
    [AddressEditVC jumpTo:dict];
}

- (void)addAction{
    [AddressEditVC jumpTo:@{@"currentType":_type}];
}

#pragma mark ----setter and getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-TOP_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = [AddressListCell heightOfCell];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [GUIUtil fit:10])];
        header.backgroundColor = [UIColor clearColor];
        _tableView.tableHeaderView = header;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate =self;
        _tableView.dataSource = self;

        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IPHONE_X_BOTTOM_HEIGHT)];
        _tableView.tableFooterView = view;
        [_tableView registerClass:[AddressListCell class] forCellReuseIdentifier:@"AddressListCell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = [[UIButton alloc] init];
        _addBtn.backgroundColor = [GColorUtil C13];
        [_addBtn setTitle:CFDLocalizedString(@"添加出金地址") forState:UIControlStateNormal];
        [_addBtn addTarget:self action:@selector(addAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addBtn;
}

@end

//
//  AddressVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/10/9.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "AddressVC.h"
#import "AddressListVC.h"
#import "AddressCell.h"


@interface AddressVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *dataList;
@end

@implementation AddressVC

+ (void)jumpTo{
    AddressVC *target = [[AddressVC alloc] init];
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CFDLocalizedString(@"出金地址管理");
    self.view.backgroundColor = [GColorUtil C6];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

#pragma mark ---tableview Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddressCell"];
    [cell configCell:[NDataUtil dictWithArray:self.dataList index:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dict = [NDataUtil dictWithArray:self.dataList index:indexPath.row];
    NSString *type = [NDataUtil stringWith:dict[@"type"]];
    [AddressListVC jumpTo:type];
}

#pragma mark ----setter and getter

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-TOP_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.rowHeight = [AddressCell heightOfCell];
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
        [_tableView registerClass:[AddressCell class] forCellReuseIdentifier:@"AddressCell"];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (NSArray *)dataList{
    if (!_dataList) {
        NSDictionary *dict = @{@"title":[NSString stringWithFormat:CFDLocalizedString(@"%@地址"),@"USDT"],@"logo":@"mine_icon_gold_usdt",@"type":@"USDT"};
        NSDictionary *dict1 = @{@"title":[NSString stringWithFormat:CFDLocalizedString(@"%@地址"),@"BTC"],@"logo":@"mine_icon_gold_btc",@"type":@"BTC"};
        NSDictionary *dict2 = @{@"title":[NSString stringWithFormat:CFDLocalizedString(@"%@地址"),@"ETH"],@"logo":@"mine_icon_gold_eth",@"type":@"ETH"};
        _dataList = @[dict,dict1,dict2];
    }
    return _dataList;
}

@end


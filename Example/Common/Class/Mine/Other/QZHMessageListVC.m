//
//  QZHMessageListVC.m
//  qzh_ftox
//
//  Created by jly on 2017/11/17.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "QZHMessageListVC.h"
#import "QZHMessageCenterCell.h"
#import "QZHMessageVC.h"

@interface QZHMessageListVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;

@end

@implementation QZHMessageListVC

+ (void)jumpTo{
    QZHMessageListVC *target = [[QZHMessageListVC alloc] init];
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CFDLocalizedString(@"消息提醒");
    self.view.backgroundColor = [GColorUtil C6];
    [self.view addSubview:self.tableView];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
#pragma mark ---tableview Delegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QZHMessageCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"QZHMessageCenterCell"];
    if(!cell)
    {
        cell = [[QZHMessageCenterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QZHMessageCenterCell"];
    }
    if(indexPath.row == 0)
    {
        [cell updateData:@{@"image":@"message_system_icon",
                           @"title":CFDLocalizedString(@"系统通知"),
                           @"detail":@"",
                           @"time":@"",
                           }];
        [cell showRedDot:[NSString stringWithFormat:@"%ld",(long)[CFDApp sharedInstance].sysNewCount]];

    }
    else if(indexPath.row == 1)
    {
        [cell updateData:@{@"image":@"message_market_icon",
                           @"title":CFDLocalizedString(@"行情提醒"),
                           @"detail":@"",
                           @"time":@"",
                           }];
        [cell showRedDot:[NSString stringWithFormat:@"%ld",(long)[CFDApp sharedInstance].marketNewCount]];

    }
    else if (indexPath.row == 2)
    {
        [cell updateData:@{@"image":@"message_deal_icon",
                           @"title":CFDLocalizedString(@"交易提醒"),
                           @"detail":@"",
                           @"time":@"",
                           }];
        [cell showRedDot:[NSString stringWithFormat:@"%ld",(long)[CFDApp sharedInstance].tradeNewCount]];

    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [GUIUtil fit:55];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    switch (indexPath.row) {
        case 0:
        {
            [CFDApp sharedInstance].sysNewCount = 0;
            QZHMessageVC *messageVC = [QZHMessageVC new];
            messageVC.messageType = QZHMessageType_system;
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        case 1:
        {
            [CFDApp sharedInstance].marketNewCount = 0;
            QZHMessageVC *messageVC = [QZHMessageVC new];
            messageVC.messageType = QZHMessageType_market;
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
            case 2:
        {
            [CFDApp sharedInstance].tradeNewCount = 0;
            QZHMessageVC *messageVC = [QZHMessageVC new];
            messageVC.messageType = QZHMessageType_trade;
            [self.navigationController pushViewController:messageVC animated:YES];
        }
            break;
        default:
            break;
    }
}
#pragma mark ----setter and getter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, TOP_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-TOP_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.delegate =self;
        _tableView.dataSource = self;

        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;

        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IPHONE_X_BOTTOM_HEIGHT)];
        _tableView.tableFooterView = view;


        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

@end

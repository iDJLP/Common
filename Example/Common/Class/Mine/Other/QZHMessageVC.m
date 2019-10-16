//
//  MessageVC.m
//  niuguwang
//
//  Created by A on 2017/6/30.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "QZHMessageVC.h"
#import "QZHMessageCell.h"


@interface QZHMessageVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) NSInteger page;
@property(nonatomic,strong) NSMutableArray * dataLists;
@property(nonatomic,strong) UITableView * mainTable;
@property(nonatomic,assign) BOOL isLoaded;
@end

@implementation QZHMessageVC

#pragma mark - lifeCyle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;

    switch (_messageType) {
        case QZHMessageType_system:
            self.title = CFDLocalizedString(@"系统通知");
            break;
        case QZHMessageType_market:
            self.title = CFDLocalizedString(@"行情提醒");
            break;
        case QZHMessageType_trade:
            self.title = CFDLocalizedString(@"交易提醒");
            break;
        default:
            break;
    }
    self.view.backgroundColor = [GColorUtil C6];
    
    WEAK_SELF;
    [self initData];
    
    [GUIUtil refreshWithHeader:self.mainTable refresh:^{
        if (weakSelf.isLoaded==NO) {
            [StateUtil show:weakSelf.mainTable type:StateTypeProgress];
        }
        [weakSelf loadData:YES];
        
    }];
    [GUIUtil refreshWithFooter:self.mainTable refresh:^{
        if (weakSelf.isLoaded==NO||(weakSelf.isLoaded==YES&&weakSelf.dataLists.count==0)) {
            [weakSelf.mainTable.mj_footer endRefreshing];
            return;
        }
        [weakSelf loadData:NO];
    }];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_dataLists.count<1){
        [self loadData:YES];
    }
}

// 初始化数据
- (void) initData
{
    _page=1;
    _dataLists = [NSMutableArray array];
}

- (void) clickBack
{
    [GJumpUtil popAnimated:YES];
}

#pragma mark -private

-(void)loadData:(BOOL)isRefresh
{
    NSInteger page = isRefresh?1:_page;
    NSString *messageType = @"";
    WEAK_SELF;
    switch (_messageType) {
        case QZHMessageType_system:
        {
            messageType = @"1";
        }
            break;
        case QZHMessageType_market:
        {
            messageType = @"5";
            
        }
            break;
        case QZHMessageType_trade:
        {
            messageType = @"2";
            
        }
            break;
        default:
            break;
    }
    
    [DCService getMessage:page pagesize:20 type:messageType
                  success:^(id data) {
                      if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
                          weakSelf.isLoaded = YES;
                          NSArray *list = [NDataUtil arrayWith:data[@"data"]];
                          if (list.count>0) {
                              weakSelf.page=page;
                          }
                          if (isRefresh) {
                              weakSelf.dataLists = [NSMutableArray array];
                          }
                          for (NSMutableDictionary *dic in list) {
                              NSString *time = [NDataUtil stringWith:dic[@"sendtime"] valid:@""];
                              time = [time substringWithRange:NSMakeRange(5, 11)];
                              NSDictionary *dataDic = @{@"date":time,@"data":@[dic].mutableCopy};
                              [weakSelf.dataLists addObject:dataDic];
                          }
                          if (weakSelf.dataLists.count<=0) {
                              [StateUtil show:weakSelf.mainTable type:StateTypeNodata];
                          }
                          [self.mainTable reloadData];
                      }else{
                          [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
                          [StateUtil hide:weakSelf.mainTable];
                      }
                      [self.mainTable.mj_header endRefreshing];
                      [self.mainTable.mj_footer endRefreshing];
                  } failure:^(NSError *error) {
                      if (isRefresh) {
                          ReloadStateView *reloadState = (ReloadStateView *)[StateUtil show:weakSelf.mainTable type:StateTypeReload];
                          reloadState.onReload = ^{
                              [weakSelf loadData:YES];
                          };
                      }
                      [HUDUtil showInfo:[FTConfig webTips]];
                      [self.mainTable.mj_header endRefreshing];
                      [self.mainTable.mj_footer endRefreshing];
                      
                  }];
}

#pragma mark - UITableViewDataSourcev

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSDictionary *dics = _dataLists[section];
    NSArray *data = [NDataUtil arrayWith:dics[@"data"]];
    return data.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDictionary *dics = _dataLists[indexPath.section];
    dics = [NDataUtil dataWithArray:dics[@"data"] index:indexPath.row];
    if(dics==nil){
        return QZHMessageCell.new;
    }
    QZHMessageCell *cell = [QZHMessageCell cellWithTableView:tableView];
    [cell config:dics type:self.messageType];
    return cell;
}



#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataLists.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *dics = _dataLists[indexPath.section];
    dics = [NDataUtil dataWithArray:dics[@"data"] index:indexPath.row];
    return [QZHMessageCell heightWithModel:dics];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [GUIUtil fit:47])];
    headerView.backgroundColor = [GColorUtil C6];
    
    UILabel *timeLabel = [[UILabel alloc]init];
    [headerView addSubview:timeLabel];
    timeLabel.textColor = [GColorUtil C3];
    timeLabel.layer.cornerRadius = 12;
    timeLabel.layer.masksToBounds = YES;
    timeLabel.textAlignment = NSTextAlignmentCenter;
    timeLabel.font = [GUIUtil fitFont:12];
    NSDictionary *dic = _dataLists[section];
    NSString *timeString = [dic objectForKey:@"date"];
    timeLabel.text = timeString;
    [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo([GUIUtil fitWidth:87 height:23]);
        make.top.mas_equalTo([GUIUtil fit:12]);
    }];
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  [GUIUtil fit:45];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return  [GUIUtil fit:13];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * v = [UIView new];
    v.backgroundColor = [GColorUtil C6];
    return v;
}

#pragma mark - getters

- (UITableView *)mainTable {
    if (!_mainTable) {
        _mainTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TOP_BAR_HEIGHT) style:UITableViewStyleGrouped];
        _mainTable.dataSource = self;
        _mainTable.delegate = self;
        _mainTable.backgroundView = nil;
        _mainTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        _mainTable.separatorColor=[UIColor clearColor];
        _mainTable.backgroundColor=[GColorUtil C6];
        _mainTable.userInteractionEnabled=YES;
        [self.view addSubview:_mainTable];
        
        _mainTable.estimatedRowHeight = 0;
        _mainTable.estimatedSectionHeaderHeight = 0;
        _mainTable.estimatedSectionFooterHeight = 0;
        
        
        UIView *footer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, IPHONE_X_BOTTOM_HEIGHT)];
        _mainTable.tableFooterView = footer;
        
        if (@available(iOS 11.0, *)) {
            _mainTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        
    }
    return _mainTable;
}

@end

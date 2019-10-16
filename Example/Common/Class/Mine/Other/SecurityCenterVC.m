//
//  SecurityCenterVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/5/17.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "SecurityCenterVC.h"
#import "SecurityCenterCell.h"
#import "SecurityClosedVC.h"
#import "SecurityOpenedVC.h"

@interface SecurityCenterVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSArray *dataArrayLeft;
@property (nonatomic,copy)NSArray *dataArrayRight;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *config;
@property (nonatomic,assign)BOOL isLoaded;
@end

@implementation SecurityCenterVC

+ (void)jumpTo{
    SecurityCenterVC *target = [[SecurityCenterVC alloc] init];
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [GColorUtil C6];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    self.title = CFDLocalizedString(@"安全中心");
    [StateUtil show:self.view type:StateTypeProgress];
    WEAK_SELF;
    [GUIUtil refreshWithHeader:self.tableView refresh:^{
        [weakSelf loadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.dataArrayRight = [UserModel sharedInstance].openGoogleAuth?@[CFDLocalizedString(@"已开启")]:@[CFDLocalizedString(@"未开启")];
    [self.tableView reloadData];
    [self loadData];
}

- (void)loadData{
    WEAK_SELF;
    [[UserModel sharedInstance] getUserIndex:^{
        self.isLoaded = YES;
        [StateUtil hide:self.view];
        [self.tableView.mj_header endRefreshing];
        weakSelf.dataArrayRight = [UserModel sharedInstance].openGoogleAuth?@[CFDLocalizedString(@"已开启")]:@[CFDLocalizedString(@"未开启")];
        [weakSelf.tableView reloadData];
    } failure:^{
        if (weakSelf.isLoaded==NO) {
            ReloadStateView *reloadView = (ReloadStateView *)[StateUtil show:weakSelf.view type:StateTypeReload];
            [reloadView setOnReload:^{
                [StateUtil hide:weakSelf.view];
                [weakSelf loadData];
            }];
        }else{
            [StateUtil hide:weakSelf.view];
        }
        [HUDUtil showInfo:[FTConfig webTips]];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark ----TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    SecurityCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SecurityCenterCell"];
    cell.titleLabel.text = [NDataUtil dataWithArray:self.dataArrayLeft index:indexPath.row];
    cell.remarkLabel.text = [NDataUtil dataWithArray:self.dataArrayRight index:indexPath.row];
    return cell;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataArrayLeft count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  [GUIUtil fit:49];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if ([UserModel sharedInstance].openGoogleAuth) {
        [SecurityClosedVC jumpTo];
    }else{
        [SecurityOpenedVC jumpTo];
    }
}


- (NSArray *)dataArrayLeft
{
    if(!_dataArrayLeft)
    {
        
        _dataArrayLeft = @[CFDLocalizedString(@"谷歌二次验证")];
        
    }
    return _dataArrayLeft;
}

- (UITableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,0, SCREEN_WIDTH, SCREEN_HEIGHT-TOP_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [GColorUtil C6];
        _tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[SecurityCenterCell class] forCellReuseIdentifier:@"SecurityCenterCell"];
    }
    
    return _tableView;
}

@end

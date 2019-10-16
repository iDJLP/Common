//
//  MineVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/18.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "MineVC.h"
#import "MineHeaderView.h"
#import "MineCell.h"
#import "FundFlowVC.h"
#import "DCCenterVC.h"
#import "QZHMessageListVC.h"
#import "QZHSettingVC.h"
#import "SuggestVC.h"
#import "NNTJTrainingVC.h"
#import "BaseTableView.h"
#import "SecurityCenterVC.h"
#import "DisnetView.h"
#import "AddressVC.h"

@interface MineVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong)BaseTableView *tableView;
@property (nonatomic, strong)MineHeaderView *headerView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSMutableArray *imageList;
@property (nonatomic,strong) NSMutableArray *indexList;
@property (nonatomic,strong)DisnetBar *disnetBar;
@end

@implementation MineVC

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    self.view.backgroundColor = [GColorUtil C6];
    [self loadData];
    [self addNotic];
    WEAK_SELF;
    [GUIUtil refreshWithHeader:self.tableView refresh:^{
        [weakSelf loadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self updateView];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)updateView{
    [self.tableView scrollToTop];
    [self.headerView updateView];
    [self reloadTable];
}

- (void)loadData{
    [self loadUserInfo];
}

- (void)loadUserInfo{
    if (![UserModel isLogin]) {
        [self.tableView.mj_header endRefreshing];
        [self updateScrollViewContentSize];
        return;
    }
    WEAK_SELF;
    [[UserModel sharedInstance] getUserIndex:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf updateScrollViewContentSize];
    } failure:^{
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf updateScrollViewContentSize];
    }];
}

- (void)reloadTable
{
    self.dataArray  = [[NSMutableArray alloc]init];
    self.imageList = [[NSMutableArray alloc]init];
    self.indexList = [[NSMutableArray alloc]init];
    
    
    
    [self.dataArray addObject:CFDLocalizedStringBlock(@"账户中心")];
    [self.imageList addObject:@"icon_mine_rules"];
    [self.indexList addObject:@(MineSectionTypeAccount)];
    
    [self.dataArray addObject:CFDLocalizedStringBlock(@"安全中心")];
    [self.imageList addObject:@"icon_mine_security"];
    [self.indexList addObject:@(MineSectionTypeSecurity)];
    
    [self.dataArray addObject:CFDLocalizedStringBlock(@"出金地址管理")];
    [self.imageList addObject:@"icon_mine_gold"];
    [self.indexList addObject:@(MineSectionTypeAddress)];
    
    
    
    [self.dataArray addObject:CFDLocalizedStringBlock(@"资金明细")];
    [self.imageList addObject:@"icon_mine_collection"];
    [self.indexList addObject:@(MineSectionTypeFund)];
    
    [self.dataArray addObject:CFDLocalizedStringBlock(@"消息提醒")];
    [self.imageList addObject:@"icon_mine_news"];
    [self.indexList addObject:@(MineSectionTypeMsg)];
    
    [self.dataArray addObject:CFDLocalizedStringBlock(@"帮助中心")];
    [self.imageList addObject:@"icon_mine_help"];
    [self.indexList addObject:@(MineSectionTypeHelp)];
    
    [self.dataArray addObject:CFDLocalizedStringBlock(@"投诉建议")];
    [self.imageList addObject:@"mine_icon_rules"];
    [self.indexList addObject:@(MineSectionTypeSuggest)];
    
    [self.dataArray addObject:CFDLocalizedStringBlock(@"设置")];
    [self.imageList addObject:@"mine_icon_set"];
    [self.indexList addObject:@(MineSectionTypeSetting)];
    [self.tableView reloadData];
}

- (void)loginSuccess{
    [self.tableView.mj_header endRefreshing];
    [self updateScrollViewContentSize];
    [self reloadTable];
}

//MARK: - TableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 3;
    }else{
        return _dataArray.count-3;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger idx = indexPath.row+indexPath.section*3;
    MineCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MineCell"];
    cell.myTitleLabel.textBlock = [_dataArray objectAtIndex:idx];
    NSString *img = _imageList[idx];
    cell.myImageView.image = [GColorUtil imageNamed:img];
    MineSectionType index = [_indexList[idx] integerValue];
    if (index==MineSectionTypeMsg&&[CFDApp sharedInstance].hasNew) {
        cell.newLabel.hidden = NO;
    } else {
        cell.newLabel.hidden = YES;
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    BaseView *bgView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [GUIUtil fit:7])];
    bgView.bgColor = C7_ColorType;
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [GUIUtil fit:7];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  [GUIUtil fit:57];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WEAK_SELF;
    NSInteger idx = indexPath.row+indexPath.section*3;
    MineSectionType index = [[_indexList objectAtIndex:idx] integerValue];
    switch (index) {
        case MineSectionTypeFund:{
            if(![UserModel isLogin])
            {
                [CFDJumpUtil jumpToLogin:^{
                    [weakSelf loginSuccess];
                }];
                return;
            }
            [FundFlowVC jumpTo];
        }
            break;
        case MineSectionTypeAccount:{
            if(![UserModel isLogin])
            {
                [CFDJumpUtil jumpToLogin:^{
                    [weakSelf loginSuccess];
                }];
                return;
            }
            [DCCenterVC jumpTo];
            
        }
            break;
        case MineSectionTypeMsg:{
            if(![UserModel isLogin])
            {
                [CFDJumpUtil jumpToLogin:^{
                    [weakSelf loginSuccess];
                }];
                return;
            }
            [CFDApp sharedInstance].hasNew = NO;
            [QZHMessageListVC jumpTo];

        }
            break;
        case MineSectionTypeHelp:{
            [NNTJTrainingVC jumpTo];
        }
            break;
        case MineSectionTypeSetting:{
            [QZHSettingVC jumpTo];
        }
            break;
        case MineSectionTypeSuggest:{
            [SuggestVC jumpTo];
        }
            break;
        case MineSectionTypeSecurity:{
            [SecurityCenterVC jumpTo];
        }
            break;
        case MineSectionTypeAddress:{
            [AddressVC jumpTo];
        }
            break;
        default:
            break;
    }
}

//MARK: - 网络变化
- (void) initNet
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStateChange:) name:kNetStateChangedNoti object:nil];
    if([NNetState isDisnet]){
        [self disnet];
    }
}

- (void) netStateChange:(NSNotification *) noti
{
    if([NNetState isDisnet]){
        [self disnet];
    }else{
        [self linkNet];
    }
}
// 断网处理
- (void) disnet
{
    if (!_disnetBar) {
        _disnetBar = [[DisnetBar alloc] init];
        [self.view addSubview:_disnetBar];
        [_disnetBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(TOP_BAR_HEIGHT);
            make.left.mas_equalTo(0); make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo(35);
        }];
    }
    [self.view bringSubviewToFront:_disnetBar];
    _disnetBar.hidden = NO;
}
// 连网处理
- (void) linkNet
{
    if (_disnetBar) {
        _disnetBar.hidden = YES;
    }
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ---- Getter

- (BaseTableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bgColor = C6_ColorType;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[MineCell class] forCellReuseIdentifier:@"MineCell"];
    }
    return _tableView;
}

- (MineHeaderView *)headerView
{
    if(!_headerView)
    {
        _headerView = [[MineHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [MineHeaderView heightOfView])];
        
    }
    return _headerView;
}

//MARK: - Notic

- (void)languageChangedAction{
    [self loadData];
    WEAK_SELF;
    [GUIUtil refreshWithHeader:self.tableView refresh:^{
        [weakSelf loadData];
    }]; 
}

- (void)themeChangedAction{
    WEAK_SELF;
    [GUIUtil refreshWithHeader:self.tableView refresh:^{
        [weakSelf loadData];
    }];   
}

- (void)addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
    [center addObserver:self
               selector:@selector(themeChangedAction)
                   name:ThemeDidChangedNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(languageChangedAction)
                   name:LanguageDidChangedNotification
                 object:nil];
    [center addObserver:self selector:@selector(updateView) name:LoginSuccessNoti object:nil];
    [self initNet];
}

//MARK: - Private

- (void)updateScrollViewContentSize {
    CGRect contentRect = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    for (UIView *view in self.tableView.subviews) {
        if ([view isEqual:self.tableView.mj_header]) {
            continue;
        }
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    contentRect.size.height += [GUIUtil fit:20]; // 增加20间隙
    if (contentRect.size.height < SCREEN_HEIGHT) {
        contentRect.size.height = SCREEN_HEIGHT + 1;
    }
    self.tableView.contentSize = contentRect.size;
}

@end



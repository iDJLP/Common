//
//  SuggestVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "SuggestVC.h"
#import "EasyCell.h"
#import "QZHAboutUsVC.h"


@interface SuggestVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,copy)NSArray *dataArrayLeft;
@property (nonatomic,copy)NSArray *dataArrayRight;
@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSArray *config;
@end

@implementation SuggestVC


+ (void)jumpTo{
    SuggestVC *target = [[SuggestVC alloc] init];
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.mas_equalTo(0);
    }];
    self.view.backgroundColor = [GColorUtil C6];
    self.title = CFDLocalizedString(@"投诉建议");
    [self loadData];
    WEAK_SELF;
    [GUIUtil refreshWithHeader:_tableView refresh:^{
        [weakSelf loadData];
    }];
}

- (void)loadData{
    WEAK_SELF;
    [DCService getSuggestService:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            weakSelf.config = [NDataUtil arrayWith:data[@"data"]];
            [weakSelf.tableView reloadData];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark ----TableView
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellID = @"Easy";
    EasyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if(!cell)
    {
        cell = [[EasyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        
    }
    cell.leftLabel.textColor    = [GColorUtil C2];
    [cell reloadData:self.dataArrayLeft[indexPath.row] rightText:self.dataArrayRight[indexPath.row] showArrow:NO];
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
    switch (indexPath.row) {
            
        case 0:  //关于
        {
         
            
        }
            break;
        case 1:
        {
            NSString *phone = @"";
            for (NSDictionary *dic in _config) {
                if ([NDataUtil boolWithDic:dic key:@"type" isEqual:@"1"]) {
                    phone = [NDataUtil stringWith:dic[@"contact"]];
                }
            }
            [GJumpUtil callPhone:self phone:phone];
        }
            break;
        default:
            break;
            
            
    }
}


- (NSArray *)dataArrayLeft
{
    if(!_dataArrayLeft)
    {
        _dataArrayLeft = @[CFDLocalizedString(@"投诉邮箱"),CFDLocalizedString(@"投诉电话")];
        
    }
    return _dataArrayLeft;
}

- (NSArray *)dataArrayRight
{
    NSString *phone = @"";
    NSString *email = @"";
    for (NSDictionary *dic in _config) {
        if ([NDataUtil boolWithDic:dic key:@"type" isEqual:@"1"]) {
            phone = [NDataUtil stringWith:dic[@"contact"]];
        }else if ([NDataUtil boolWithDic:dic key:@"type" isEqual:@"4"]){
            email = [NDataUtil stringWith:dic[@"contact"]];
        }
    }
    _dataArrayRight = @[email,phone];
    return _dataArrayRight;
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
        
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    
    return _tableView;
}
@end

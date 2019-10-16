//
//  CFDAlertFrequencyVC.m
//  qzh_ftox
//
//  Created by jly on 2017/11/24.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "AlertFrequencyVC.h"
#import "AlertFrequencyCell.h"


@interface AlertFrequencyVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *frequencys;
@property (nonatomic,strong)UIView *footerView;
@property (nonatomic,strong)UILabel *remarkLabel;

@end

@implementation AlertFrequencyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CFDLocalizedString(@"提醒频率");
    self.frequencys = [[NSMutableArray alloc]initWithArray:@[CFDLocalizedString(@"仅一次"),CFDLocalizedString(@"每天一次")]];
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    AlertFrequencyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AlertFrequencyCell"];

    cell.titleLabel.text = [NDataUtil dataWithArray:_frequencys index:indexPath.row];
    if([_alertrate isEqualToString:CFDLocalizedString(@"仅一次")] && indexPath.row == 0)
        cell.row.hidden = NO;
    else if ([_alertrate isEqualToString:CFDLocalizedString(@"每天一次")] && indexPath.row == 1)
        cell.row.hidden = NO;
    else
        cell.row.hidden = YES;
    return cell;
}

#pragma mark - tableView dataSource delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _frequencys.count;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
        return [GUIUtil fit:49];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _alertrate = [NDataUtil dataWithArray:_frequencys index:indexPath.row];
    
    if(indexPath.row == 0){
        _remarkLabel.text = CFDLocalizedString(@"* 当行情多次到达提醒价位时，仅在第一次时提醒。");
    }
    else if (indexPath.row == 1){
        _remarkLabel.text = CFDLocalizedString(@"* 当行情多次到达提醒价位时，仅在每天第一次到达时提醒。");
    }else{
        _remarkLabel.text = @"";
    }
    [_tableView reloadData];
    
    if(self.setAlertrateBlock)
        self.setAlertrateBlock(_alertrate);
}


-(CGFloat )tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return [GUIUtil fit:100];
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return self.footerView;
}
#pragma mark ----- Getter

- (void)setAlertrate:(NSString *)alertrate{
    _alertrate = alertrate;
    if([_alertrate isEqualToString:CFDLocalizedString(@"仅一次")]){
        self.remarkLabel.text = CFDLocalizedString(@"* 当行情多次到达提醒价位时，仅在第一次时提醒。");
    }
    else if ([_alertrate isEqualToString:CFDLocalizedString(@"每天一次")]){
        self.remarkLabel.text = CFDLocalizedString(@"* 当行情多次到达提醒价位时，仅在每天第一次到达时提醒。");
    }else{
        _remarkLabel.text = @"";
    }
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height) style:UITableViewStylePlain];
        _tableView.backgroundColor = [GColorUtil C6];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        [_tableView registerClass:[AlertFrequencyCell class] forCellReuseIdentifier:@"AlertFrequencyCell"];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
    }
    return _tableView;
}

- (UIView *)footerView{
    if (!_footerView) {
        _footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [GUIUtil fit:100])];
        _remarkLabel = [UILabel new];
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.font = [GUIUtil fitFont:12];
        _remarkLabel.textColor = [GColorUtil C3];
        if([_alertrate isEqualToString:CFDLocalizedString(@"仅一次")]){
            _remarkLabel.text = CFDLocalizedString(@"* 当行情多次到达提醒价位时，仅在第一次时提醒。");
        }
        else if ([_alertrate isEqualToString:CFDLocalizedString(@"每天一次")]){
            _remarkLabel.text = CFDLocalizedString(@"* 当行情多次到达提醒价位时，仅在每天第一次到达时提醒。");
        }else{
            _remarkLabel.text = @"";
        }
        [_footerView addSubview:_remarkLabel];
        [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo([GUIUtil fit:15]);
            make.right.mas_equalTo([GUIUtil fit:-15]);
        }];
    }
    return _footerView;
}

@end

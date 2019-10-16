//
//  PositionAnalyseVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/9/27.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "PositionAnalyseVC.h"
#import "PositionAnalyseCell.h"
#import "PieChartView.h"

@interface PositionAnalyseVC ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) CAGradientLayer *fillLayer;
@property (nonatomic,strong) UIButton *titleView;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) PositionAnalyseSectionView *sectionView;
@property (nonatomic,strong) PieChartView *chartView;
@property (nonatomic,strong) NSArray *dataList;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,assign) BOOL isLoaded;
@end

@implementation PositionAnalyseVC

+ (void)jumpTo{
    PositionAnalyseVC *target = [[PositionAnalyseVC alloc] init];
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CFDLocalizedString(@"持仓分析");
    self.bgColorType = C6_ColorType;
    _selectedIndex = -1;
    [self setupUI];
    [self loadData];
    WEAK_SELF;
    [GUIUtil refreshWithWhiteHeader:_tableView refresh:^{
        [weakSelf loadData];
    }];
}

- (void)setupUI{
    [self.view.layer addSublayer:self.fillLayer];
    [self.view addSubview:self.titleView];
    [self.view addSubview:self.tableView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo([GUIUtil fit:18]);
    }];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.top.equalTo(self.titleView.mas_bottom);
        make.bottom.mas_equalTo([GUIUtil fit:-27]-IPHONE_X_BOTTOM_HEIGHT);
    }];
}

- (void)loadData{
    WEAK_SELF;
    [DCService positionAnalysis:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            NSDictionary *dict = data[@"data"];
            weakSelf.dataList=dict[@"list"];
            if (weakSelf.dataList.count<=0) {
                NoDataStateView *state = (NoDataStateView *)[StateUtil show:weakSelf.tableView type:StateTypeNodata];
                [state updateTheme:YES];
                state.title.text = CFDLocalizedString(@"暂无持仓");
                return ;
            }
            weakSelf.isLoaded = YES;
            [StateUtil hide:weakSelf.tableView];
            [weakSelf configView];
        }else{
           [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
            if (weakSelf.isLoaded==NO) {
                ReloadStateView *stateView = (ReloadStateView *)[StateUtil show:weakSelf.tableView type:StateTypeReload];
                [stateView updateTheme:YES];
                stateView.onReload = ^{
                    [weakSelf loadData];
                };
            }
        }
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
        if (weakSelf.isLoaded==NO) {
            ReloadStateView *stateView = (ReloadStateView *)[StateUtil show:weakSelf.tableView type:StateTypeReload];
            [stateView updateTheme:YES];
            stateView.onReload = ^{
                [weakSelf loadData];
            };
        }
    }];
}

- (void)configView{
    [_chartView updateList:_dataList];
    [_tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    PositionAnalyseCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PositionAnalyseCell"];
    [cell configOfCell:[NDataUtil dictWithArray:_dataList index:indexPath.row] isSingle:indexPath.row%2];
    [cell updateSelected:indexPath.row ==_selectedIndex];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [PositionAnalyseSectionView heightOfView];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    [_chartView setSelectedIndex:indexPath.row];
}

//MARK: - Getter

- (UIButton *)titleView{
    if (!_titleView) {
        _titleView = [[UIButton alloc] init];
        [_titleView setBackgroundImage:[UIImage imageNamed:@"position_analysisbg"] forState:UIControlStateNormal];
        _titleView.titleLabel.font = [GUIUtil fitBoldFont:14];
        [_titleView setTitle:CFDLocalizedString(@"各品种持仓占比") forState:UIControlStateNormal];
        _titleView.enabled = NO;
        [_titleView setTitleColor:[GColorUtil C13] forState:UIControlStateNormal];
    }
    return _titleView;
}

- (PositionAnalyseSectionView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[PositionAnalyseSectionView alloc] init];
    }
    return _sectionView;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake([GUIUtil fit:15], [GUIUtil fit:55], [GUIUtil fit:345], SCREEN_HEIGHT - [GUIUtil fit:[GUIUtil fit:55]]- TOP_BAR_HEIGHT-IPHONE_X_BOTTOM_HEIGHT) style:UITableViewStylePlain];
        _tableView.backgroundColor = [GColorUtil C5];
        _tableView.tableFooterView = self.chartView;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[PositionAnalyseCell class] forCellReuseIdentifier:@"PositionAnalyseCell"];
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.layer.cornerRadius = [GUIUtil fit:7];
        _tableView.layer.masksToBounds = YES;
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (PieChartView *)chartView{
    if (!_chartView) {
        _chartView = [[PieChartView alloc] init];
        _chartView.frame = CGRectMake(0, 0, [GUIUtil fit:200], [GUIUtil fit:300]);
        _chartView.centerPoint = CGPointMake(SCREEN_WIDTH/2-[GUIUtil fit:15], [GUIUtil fit:150]);
        _chartView.innerRadius = [GUIUtil fit:40];
        _chartView.outerRadius = [GUIUtil fit:70];
        WEAK_SELF;
        _chartView.selectedHander = ^(NSInteger index) {
            weakSelf.selectedIndex = index;
            [weakSelf.tableView reloadData];
        };
        _chartView.deSelectedHander = ^{
            weakSelf.selectedIndex = -1;
            [weakSelf.tableView reloadData];
        };
    }
    
    return _chartView;
}

- (CAGradientLayer *)fillLayer{
    if (!_fillLayer) {
        _fillLayer =  [[CAGradientLayer alloc] init];
        _fillLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TOP_BAR_HEIGHT);
        _fillLayer.colors = @[(__bridge id)[GColorUtil colorWithHex:0x007AFE].CGColor,(__bridge id)[GColorUtil colorWithHex:0x12A3FF].CGColor];
        _fillLayer.locations = @[@(0),@(1)];
        _fillLayer.startPoint = CGPointMake(0, 0);
        _fillLayer.endPoint = CGPointMake(0, 1);
    }
    return _fillLayer;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

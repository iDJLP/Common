//
//  MarketVC.m
//  Chart
//
//  Created by ngw15 on 2019/3/12.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "MarketVC.h"
#import "ChartsVC.h"
#import "DCService.h"
#import "CFDChartsData.h"
#import "WebSocketManager.h"
#import "MarketCell.h"
#import "DisnetView.h"

@interface MarketVC ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) WebSocketManager *webSocket;
@property (nonatomic,strong)BaseView *bgTopView;
@property (nonatomic,strong)MarketView *sectionView;
@property (nonatomic,strong)ThreadSafeArray *dataList;
@property (nonatomic,strong)ThreadSafeArray *showList;

@property (nonatomic,strong) DisnetBar *disnetBar;

@property (nonatomic,assign)BOOL isLoaded;
@end

@implementation MarketVC

- (void)dealloc{
    [self removeNotic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    WEAK_SELF;
    [GNavUtil rightIcon:self icon:@"mine_icon_customer" onClick:^{
        [CFDJumpUtil jumpToService];
    }];
    self.bgColorType = C6_ColorType;
    self.title = CFDLocalizedString(@"行情");
    [self.view addSubview:self.bgTopView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    _dataList = [ThreadSafeArray array];
    [self loadData:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        if (weakSelf.flodViewHander) {
            weakSelf.flodViewHander();
        }
    }];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    [self addNotic];
    [GUIUtil refreshWithHeader:_tableView refresh:^{
        [weakSelf loadData:YES];
    }];
    // Do any additional setup after loading the view.
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGFloat pointY = [gestureRecognizer locationInView:self.view].y;
    UITableViewCell *cell = [[self.tableView visibleCells] lastObject];
    CGRect rect = [self.view convertRect:cell.frame fromView:self.tableView];
    if(CGRectGetMaxY(rect)>pointY){
        return NO;
    }
    return YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_flodViewHander) {
        self.view.backgroundColor = [GColorUtil colorWithHex:0x000000 alpha:0.4];
    }else{
        self.bgColorType = C6_ColorType;
        
    }
    [self websocketLoad];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_webSocket disconnect];
    _webSocket=nil;
}

- (void)loadData:(BOOL)isRefresh{
    WEAK_SELF;
    if (_isLoaded==NO) {
        [StateUtil show:self.view type:StateTypeProgress];
    }
    [DCService demoContractDataList:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            if (isRefresh) {
                [weakSelf.dataList removeAllObjects];
            }
            [weakSelf parseData:[NDataUtil arrayWith:data[@"data"]]];
            if (weakSelf.webSocket==nil) {
                [weakSelf websocketLoad];
            }
            weakSelf.sectionView.hidden=NO;
            weakSelf.isLoaded = YES;
            [StateUtil hide:weakSelf.view];
        }else{
            ReloadStateView *stateView = (ReloadStateView *)[StateUtil show:weakSelf.view type:StateTypeReload];
            stateView.onReload = ^{
                [weakSelf loadData:YES];
            };
        }
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf updateScrollViewContentSize];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf updateScrollViewContentSize];
        ReloadStateView *stateView = (ReloadStateView *)[StateUtil show:weakSelf.view type:StateTypeReload];
        stateView.onReload = ^{
            [weakSelf loadData:YES];
        };
    }];
}


- (void)websocketLoad{
    if (_dataList.count<=0) {
        return;
    }
    if (_webSocket) {
        [_webSocket reconnect];
        return;
    }
    NSMutableArray *tem = [NSMutableArray array];
    for (NSInteger i = 0; i<_dataList.count; i++) {
        CFDBaseInfoModel *model = [NDataUtil dataWithArray:_dataList index:i];
        [tem addObject:model.symbol];
    }
    _webSocket = [[WebSocketManager alloc] init];
    _webSocket.target = self.view;
    [_webSocket multipleContractData:tem];
    WEAK_SELF;
    [_webSocket setReciveMessage:^(NSArray *array) {
        NSLog(@"MarketVC的websocket收到数据");
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            for (NSDictionary *dic in array) {
                [weakSelf updateSingleContradId:dic isSocket:YES];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.tableView reloadData];
            });
        });
    }];
}

- (void)parseData:(NSArray *)data{
    for (NSDictionary *dic in data) {
        [self updateSingleContradId:dic isSocket:NO];
    }
    _showList = [[ThreadSafeArray alloc] initWithArray:_dataList];
    [self.tableView reloadData];
}

- (void)updateSingleContradId:(NSDictionary *)dic isSocket:(BOOL)isSocket{
    __block BOOL hasContradId = NO;
    NSString *symbol = [NDataUtil stringWithDict:dic keys:@[@"symbol",@"S"] valid:@""];
    NSString *askp = [NDataUtil stringWithDict:dic keys:@[@"askPrice",@"a"] valid:@""];
    NSString *bidp = [NDataUtil stringWithDict:dic keys:@[@"bidPrice",@"b"] valid:@""];
    NSString *name = [NDataUtil stringWithDict:dic keys:@[@"name",@"S"] valid:@""];
    
    NSString *volume = [NDataUtil stringWithDict:dic keys:@[@"volume",@"V"] valid:@""];
    NSString *price = [NDataUtil stringWithDict:dic keys:@[@"tradePrice",@"t"] valid:@""];
    NSString *dotnum = [NDataUtil stringWithDict:dic keys:@[@"decimalplace"] valid:@""];
    NSString *upDownRate = [NDataUtil stringWithDict:dic keys:@[@"upDownRate"] valid:@""];
    NSString *upDown = [NDataUtil stringWithDict:dic keys:@[@"upDown"] valid:@""];
    NSString *rate = [NDataUtil stringWithDict:dic keys:@[@"cnyRate"] valid:@""];
    if ([dic containsObjectForKey:@"c"]&&[dic containsObjectForKey:@"t"]) {
        upDown = [GUIUtil decimalSubtract:dic[@"t"] num:dic[@"c"]];
        upDownRate = [GUIUtil decimalDivide:upDown num:dic[@"c"]];
        if (upDownRate.length<=0) {
            upDownRate = @"+0.00%";
        }else{
            upDownRate = [GUIUtil notRoundingString:upDownRate afterPoint:4];
            if (upDownRate.floatValue>0) {
                upDownRate = [NSString stringWithFormat:@"+%@%%",[GUIUtil decimalMultiply:upDownRate num:@"100"]];
            }else{
                upDownRate = [NSString stringWithFormat:@"%@%%",[GUIUtil decimalMultiply:upDownRate num:@"100"]];
            }
        }
    }
    
    [_dataList enumerateObjectsUsingBlock:^(CFDBaseInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.symbol isEqualToString:symbol]&&obj.symbol.length>0) {
            obj.lastPrice = price;
            obj.raisRate = upDownRate;
            obj.raise = upDown;
            obj.volume = volume;
            hasContradId = YES;
            *stop = YES;
        }
    }];
    if (hasContradId==NO) {
        CFDBaseInfoModel *obj = [[CFDBaseInfoModel alloc] init];
        obj.dotNum = dotnum.integerValue;
        obj.rate = rate;
        obj.symbol = symbol;
        obj.askp = askp;
        obj.bidp = bidp;
        obj.iStockname = name;
        obj.lastPrice = price;
        obj.raisRate = upDownRate;
        obj.raise = upDown;
        obj.volume = volume;
        [_dataList addObject:obj];
    }
}

#pragma mark - tableView dataSource delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.showList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MarketCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MarketCell"];
    CFDBaseInfoModel *model = _showList[indexPath.row];
    [cell configCell:model];
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [MarketView heightOfView];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CFDBaseInfoModel *model = _showList[indexPath.row];
    if (_didSelectedCell) {
        _didSelectedCell(model.symbol);
    }else{
        [ChartsVC jumpTo:model.symbol];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_tableView) {
        if (scrollView.contentOffset.y<0) {
            _bgTopView.height = -scrollView.contentOffset.y;
        }
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
            make.top.mas_equalTo(0);
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

//MARK: - Getter

- (BaseView *)bgTopView{
    if (!_bgTopView ) {
        _bgTopView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [GUIUtil fit:0])];
        _bgTopView.bgColor = C6_ColorType;
    }
    return _bgTopView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.showsHorizontalScrollIndicator = NO;
        [_tableView registerClass:[MarketCell class] forCellReuseIdentifier:@"MarketCell"];
        _tableView.rowHeight = [MarketCell heightOfCell];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _tableView;
}

- (MarketView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[MarketView alloc] init];
        _sectionView.hidden = YES;
        WEAK_SELF;
        _sectionView.sortChangedHander = ^(NSString * _Nonnull sortType) {
            //原始数据
            if (sortType.integerValue==1) {
                weakSelf.showList = [[ThreadSafeArray alloc] initWithArray:weakSelf.dataList];
            }
            //降序
            else if (sortType.integerValue==2){
                [SortUtil quickSort:weakSelf.showList isAscending:NO keyHander:^CGFloat(NSDictionary *dic) {
                    return [[(CFDBaseInfoModel *)dic raisRate] floatValue];
                }];
            }
            //升序
            else{
                [SortUtil quickSort:weakSelf.showList isAscending:YES keyHander:^CGFloat(NSDictionary *dic) {
                    return [[(CFDBaseInfoModel *)dic raisRate] floatValue];
                }];
            }
            [weakSelf.tableView reloadData];
        };
    }
    return _sectionView;
}

//MARK: - Notic

- (void)languageChangedAction{
    self.title = CFDLocalizedString(@"行情");
    WEAK_SELF;
    [GUIUtil refreshWithHeader:_tableView refresh:^{
        [weakSelf loadData:YES];
    }];
    [weakSelf loadData:YES];
}

- (void)themeChangedAction{
    WEAK_SELF;
    [GUIUtil refreshWithHeader:_tableView refresh:^{
        [weakSelf loadData:YES];
    }];
}

- (void)addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(languageChangedAction)
                   name:LanguageDidChangedNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(themeChangedAction)
                   name:ThemeDidChangedNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(languageChangedAction)
                   name:LanguageDidChangedNotification
                 object:nil];
    [self initNet];
}

- (void)removeNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
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

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end


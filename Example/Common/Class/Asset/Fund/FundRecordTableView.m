//
//  FundRecordTableView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/4/26.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "FundRecordTableView.h"
#import "ChainDetailRecordVC.h"
#import "OtcDetailRecordVC.h"
#import "FundRecordOtcCell.h"
#import "FundRecordChainCell.h"
#import "FundRecordTransferCell.h"
#import "Control.h"

@interface FundRecordSectionView ()

@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,strong)NSMutableArray <CFDSelectedBtn *>*btnList;
@end
@implementation FundRecordSectionView

- (instancetype)initWithList:(NSArray *)list
{
    if(self = [super init])
    {
        self.scrollEnabled = NO;
        self.backgroundColor = [GColorUtil C6];
        [self setupBtn:list];
    }
    return self;
}

- (void)setupBtn:(NSArray *)headerData
{
    CGFloat width = [GUIUtil fit:100];
    _btnList = [NSMutableArray array];
    UIButton *btn = nil;
    for(int i=0;i<headerData.count;i++)
    {
        CFDSelectedBtn *button = [self btn:headerData[i]];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(i*width);
            make.width.mas_equalTo(width);
            make.height.equalTo(self);
        }];
        [_btnList addObject:button];
        btn = button;
    }
    
    [btn mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
    }];
}

-(void)setSelected:(NSInteger)selectedIndex{
    if (selectedIndex>=0&&selectedIndex<_btnList.count) {
        CFDSelectedBtn *selectedBtn = [_btnList objectAtIndex:selectedIndex];
        [self buttonAction:selectedBtn];
    }
}

- (void)buttonAction:(CFDSelectedBtn *)btn
{
    CFDSelectedBtn *selectedBtn = [_btnList objectAtIndex:_selectedIndex];
    selectedBtn.selected=NO;
    _selectedIndex = [_btnList indexOfObject:btn];
    btn.selected  = YES;
    [self updateMoveIndex:_selectedIndex];
    if(self.didSelectedHander)
        self.didSelectedHander(_selectedIndex);
}

- (void)updateMoveIndex:(NSInteger)index
{
    if (index>=_btnList.count-3) {
        [self scrollToRightAnimated:YES];
    }else if(index<=3){
        [self scrollToLeftAnimated:YES];
    }
}

- (CFDSelectedBtn *)btn:(NSString *)title{
    CFDSelectedBtn *btn = [[CFDSelectedBtn alloc] init];
    btn.lineType = CFDSelectedLineTypeEqualTitle;
    btn.titleLabel.font = [GUIUtil fitFont:14];
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
    btn.titleLabel.numberOfLines = 2;
    btn.lineColor = [GColorUtil C13];
    btn.norFont = [GUIUtil fitFont:14];
    btn.selFont = [GUIUtil fitFont:14];
    btn.backgroundColor = [GColorUtil C6];
    [btn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[GColorUtil C2] forState:UIControlStateNormal];
    [btn setTitleColor:[GColorUtil C13] forState:UIControlStateSelected];
    return btn;
}

@end

@interface FundRecordTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,assign) BOOL isLoaded;
@end

@implementation FundRecordTableView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        _page=1;
        _params = @"";
        self.backgroundColor = [GColorUtil C6];
        self.delegate   = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.contentInset = UIEdgeInsetsMake(0, 0, -IPHONE_X_BOTTOM_HEIGHT, 0);
        [self registerClass:FundRecordOtcCell.class forCellReuseIdentifier:@"FundRecordOtcCell"];
        [self registerClass:FundRecordChainCell.class forCellReuseIdentifier:@"FundRecordChainCell"];
        [self registerClass:FundRecordTransferCell.class forCellReuseIdentifier:@"FundRecordTransferCell"];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appDidBecomeActive) name:UIApplicationDidBecomeActiveNotification object:nil];
        WEAK_SELF;
        [GUIUtil refreshWithHeader:self refresh:^{
            [weakSelf requestData:YES];
        }];
        //暂无上拉加载更多功能
//        [GUIUtil refreshWithFooter:self refresh:^{
//            if (weakSelf.isLoaded==NO||(weakSelf.isLoaded==YES&&weakSelf.dataList.count==0)) {
//                [weakSelf.mj_footer endRefreshing];
//                return;
//            }
//            [weakSelf requestData:NO];
//        }];
    }
    return self;
}

- (void)viewWillAppear{
    if (!_isLoaded) {
        [self requestData:YES];
    }
}

- (void)refreshView{
    [self requestData:YES];
}

- (void)appDidBecomeActive{
    [self requestData:YES];
}

- (void)requestData:(BOOL)isRefresh
{
    if (_isLoaded==NO) {
        [StateUtil show:self type:StateTypeProgress];
    }
    WEAK_SELF;
    NSInteger page = isRefresh?1:_page+1;
    if (_type == FundRecordTypeOtcDrawl||_type == FundRecordTypeOtcDeposit) {
        [DCService getOtcOrderlist:_type==FundRecordTypeOtcDeposit params:_params success:^(id data) {
            [weakSelf successHander:data refresh:isRefresh page:page];
        } failure:^(NSError *error) {
            [weakSelf failureHander:isRefresh];
        }];
    }else if(_type==FundRecordTypeChainDrawl||_type==FundRecordTypeChainDeposit){
        [DCService getChainOrderlist:_type==FundRecordTypeChainDeposit params:_params success:^(id data) {
            [weakSelf successHander:data refresh:isRefresh page:page];
        } failure:^(NSError *error) {
            [weakSelf failureHander:isRefresh];
        }];
    }else if(_type==FundRecordTypeTransfer){
        [DCService currencyexchangeRecorde:page params:_params success:^(id data) {
            [weakSelf successHander:data refresh:isRefresh page:page];
        } failure:^(NSError *error) {
            [weakSelf failureHander:isRefresh];
        }];
    }
}

- (void)successHander:(NSDictionary *)data refresh:(BOOL)isRefresh page:(NSInteger)page{
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
    if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
        self.isLoaded = YES;
        NSArray *list = data[@"data"];
        if ([list isKindOfClass:[NSDictionary class]]) {
            list = [NDataUtil arrayWith:[(NSDictionary *)list objectForKey:@"flowList"]];
        }
        if (list.count>=0) {
            self.page = page;
        }
        if(isRefresh){
            self.dataList = list.mutableCopy;
            if (self.dataList.count<=0) {
                [StateUtil show:self type:StateTypeNodata];
                [self reloadData];
                return ;
            }
        }else{
            [self.dataList addObjectsFromArray:list];
        }
        [self reloadData];
        [StateUtil hide:self];
    }else{
        [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        if (isRefresh) {
            ReloadStateView *reloadState = (ReloadStateView *)[StateUtil show:self type:StateTypeReload];
            WEAK_SELF;
            reloadState.onReload = ^{
                [weakSelf requestData:YES];
            };
        }
    }
}

- (void)failureHander:(BOOL)isRefresh{
    WEAK_SELF;
    if (isRefresh) {
        ReloadStateView *reloadState = (ReloadStateView *)[StateUtil show:self type:StateTypeReload];
        reloadState.onReload = ^{
            [weakSelf requestData:YES];
        };
    }
    [HUDUtil showInfo:[FTConfig webTips]];
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

#pragma mark ----TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type==FundRecordTypeOtcDeposit||_type==FundRecordTypeOtcDrawl) {
        FundRecordOtcCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FundRecordOtcCell"];
        NSDictionary *dic = [NDataUtil dictWithArray:_dataList index:indexPath.row];
        WEAK_SELF;
        cell.reloadHander = ^{
            [weakSelf reloadData];
        };
        [cell configCell:dic];
        return cell;
    }else if(_type==FundRecordTypeChainDeposit||_type==FundRecordTypeChainDrawl){
        FundRecordChainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FundRecordChainCell"];
        NSDictionary *dic = [NDataUtil dictWithArray:_dataList index:indexPath.row];
        [cell configCell:dic];
        return cell;
    }else if(_type == FundRecordTypeTransfer){
        FundRecordTransferCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FundRecordTransferCell"];
        NSDictionary *dic = [NDataUtil dictWithArray:_dataList index:indexPath.row];
        [cell configOfCell:dic];
        return cell;
    }
    return [UITableViewCell new];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type==FundRecordTypeOtcDeposit||_type==FundRecordTypeOtcDrawl) {
        return  [FundRecordOtcCell heightOfCell];
    }else if(_type==FundRecordTypeChainDeposit||_type==FundRecordTypeChainDrawl){
        return  [FundRecordChainCell heightOfCell];
    }else if (_type == FundRecordTypeTransfer){
        return [FundRecordTransferCell heightOfCell];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [NDataUtil dictWithArray:_dataList index:indexPath.row];
    BOOL isDeposit = [NDataUtil boolWithDic:dic key:@"priceArrow" isEqual:@"BUY"];
    NSString *logid = [NDataUtil stringWith:dic[@"logid"]];
    NSString *txtid = [NDataUtil stringWith:dic[@"txtid"]];
    NSString *currenttype = [NDataUtil stringWith:dic[@"showCoinCode"]];
    if (_type==FundRecordTypeOtcDeposit||_type==FundRecordTypeOtcDrawl) {
        [OtcDetailRecordVC jumpTo:logid txtId:txtid isDeposit:isDeposit];
    }else if(_type==FundRecordTypeChainDeposit||_type==FundRecordTypeChainDrawl){
        NSString *date = [NDataUtil stringWithDict:dic keys:@[@"tradetime",@"createTime"] valid:@""];
        [ChainDetailRecordVC jumpTo:logid txtId:txtid date:date currenttype:currenttype isDeposit:isDeposit];
    }else if (_type == FundRecordTypeTransfer){
        
    }
    
}

@end


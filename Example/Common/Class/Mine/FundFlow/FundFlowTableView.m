//
//  FundFlowTableView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/20.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "FundFlowTableView.h"
#import "FundFlowCell.h"
#import "Control.h"

@interface FundFlowSectionView ()

@property (nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,strong)NSMutableArray <CFDSelectedBtn *>*btnList;
@end
@implementation FundFlowSectionView

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
    CGFloat width = [GUIUtil fit:70];
    _btnList = [NSMutableArray array];
    UIButton *btn = nil;
    for(int i=0;i<headerData.count;i++)
    {
        CFDSelectedBtn *button = [self btn:headerData[i]];
        [self addSubview:button];
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(i*width);
            make.width.mas_equalTo(width);
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


@interface FundFlowTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,assign) BOOL isLoaded;
@end

@implementation FundFlowTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        _page=1;
        self.backgroundColor = [GColorUtil C6];
        self.delegate   = self;
        self.dataSource = self;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.contentInset = UIEdgeInsetsMake(0, 0, -IPHONE_X_BOTTOM_HEIGHT, 0);
        [self registerClass:FundFlowCell.class forCellReuseIdentifier:@"FundFlowCell"];
        WEAK_SELF;
        [GUIUtil refreshWithHeader:self refresh:^{
            [weakSelf requestData:YES];
        }];
        [GUIUtil refreshWithFooter:self refresh:^{
            if (weakSelf.isLoaded==NO||(weakSelf.isLoaded==YES&&weakSelf.dataList.count==0)) {
                [weakSelf.mj_footer endRefreshing];
                return;
            }
            [weakSelf requestData:NO];
        }];
    }
    return self;
}

- (void)viewWillAppear{
    if (!_isLoaded) {
        [self requestData:YES];
    }
}

- (void)requestData:(BOOL)isRefresh
{
    if (_isLoaded==NO) {
        [StateUtil show:self type:StateTypeProgress];
    }
    WEAK_SELF;
    NSInteger page = isRefresh?1:_page+1;
    [DCService postquerymoneyflowoptype:_type page:page pagesize:20 success:^(id data) {
        [weakSelf.mj_header endRefreshing];
        [weakSelf.mj_footer endRefreshing];
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            weakSelf.isLoaded = YES;
            NSDictionary *tempDict = [NDataUtil dictWith:data[@"data"]];
            NSArray *list = [NDataUtil arrayWith:tempDict[@"list"]];
            if (list.count>0) {
                weakSelf.page = page;
            }
            if(isRefresh){
                weakSelf.dataList = list.mutableCopy;
                if (weakSelf.dataList.count<=0) {
                    [StateUtil show:weakSelf type:StateTypeNodata];
                    [weakSelf reloadData];
                    return ;
                }
            }else{
                [weakSelf.dataList addObjectsFromArray:list];
            }
            [weakSelf reloadData];
            [StateUtil hide:weakSelf];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
            if (isRefresh) {
                ReloadStateView *reloadState = (ReloadStateView *)[StateUtil show:weakSelf type:StateTypeReload];
                reloadState.onReload = ^{
                    [weakSelf requestData:YES];
                };
            }
        }
        
    } failure:^(NSError *error) {
        if (isRefresh) {
            ReloadStateView *reloadState = (ReloadStateView *)[StateUtil show:weakSelf type:StateTypeReload];
            reloadState.onReload = ^{
                [weakSelf requestData:YES];
            };
        }
        [HUDUtil showInfo:[FTConfig webTips]];
        [weakSelf.mj_header endRefreshing];
        [weakSelf.mj_footer endRefreshing];
    }];
    
}

#pragma mark ----TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    FundFlowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FundFlowCell"];
    [cell configCell:_dataList[indexPath.row]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  [FundFlowCell heightOfCell:_dataList[indexPath.row]];
}



@end

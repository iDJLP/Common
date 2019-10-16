//
//  PosHisView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "PosHisView.h"
#import "PosHisCell.h"

@interface PosHisView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) NSInteger page;
@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,assign) BOOL isLoaded;
@end

@implementation PosHisView

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
        [self registerClass:PosHisCell.class forCellReuseIdentifier:@"PosHisCell"];
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
        [self addNotic];
    }
    return self;
}

- (void)willAppear{
    if (!_isLoaded) {
        [self requestData:YES];
    }
}

- (void)requestData:(BOOL)isRefresh
{
    if (self.isLoaded==NO) {
        [StateUtil show:self type:StateTypeProgress];
    }
    __weak typeof(self)weakSelf = self;
    NSInteger page = isRefresh?1:_page+1;
    [DCService getQueryPositionHis:_params page:page success:^(id data) {
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
                
                [weakSelf parseData:list];
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


- (void)parseData:(NSArray *)list{
    WEAK_SELF;
    NSMutableArray *tem = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dict = obj.mutableCopy;
        [weakSelf.dataList enumerateObjectsUsingBlock:^(NSMutableDictionary *dic, NSUInteger i, BOOL * _Nonnull s) {
            if ([NDataUtil boolWithDic:dic key:@"transid" isEqual:[NDataUtil stringWith:obj[@"transid"]]]) {
                *s = YES;
                [dict setObject:[NDataUtil stringWith:dic[@"isUnFold"] valid:@"0"] forKey:@"isUnFold"];
            }
        }];
        [tem addObject:dict];
    }];
    weakSelf.dataList = tem;
}

- (void)addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(languageChangedAction) name:LanguageDidChangedNotification object:nil];
}


- (void)languageChangedAction{
    _isLoaded=NO;
    [_dataList removeAllObjects];
    [self requestData:NO];
}

#pragma mark ----TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataList.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WEAK_SELF;
    PosHisCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PosHisCell"];
    [cell configCell:[NDataUtil dataWithArray:_dataList index:indexPath.row]];
    cell.reloadDataHander = ^{
        [weakSelf reloadData];
    };
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return [PosHisCell heightOfCell:[NDataUtil dataWithArray:_dataList index:indexPath.row]];
}



@end

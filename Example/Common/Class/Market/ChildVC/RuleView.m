//
//  RuleView.m
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "RuleView.h"
#import "RuleCell.h"


@interface RuleView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,assign) BOOL isChild;
@property (nonatomic,assign) BOOL isLoaded;
@property (nonatomic,copy)NSString *symobl;

@end

@implementation RuleView

- (instancetype)initWithSymbol:(NSString *)symbol isChild:(BOOL)isChild{
    if (self = [super initWithFrame:CGRectZero style:UITableViewStylePlain]) {
        _symobl = symbol;
        _isChild = isChild;
        self.backgroundColor = [GColorUtil C6];
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        [self registerClass:[RuleCell class] forCellReuseIdentifier:@"RuleCell"];
        StateView *state = [StateUtil show:self type:StateTypeProgress];
        if (_isChild) {
            [state mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.top.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [GUIUtil fit:250]));
            }];
        }
        _dataList = [NSMutableArray array];
    }
    return self;
}

- (void)refreshData{
    [self loadData:NO];
}

- (void)willAppear{
    if (!_isLoaded) {
        [self loadData:NO];
    }
}

- (void)willDisAppear{
    
}

- (void)loadData:(BOOL)isAuto{
    WEAK_SELF;
    [DCService ruleData:_symobl success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            weakSelf.dataList=data[@"data"];
            if (weakSelf.dataList.count<=0) {
                StateView *state = [StateUtil show:weakSelf type:StateTypeNodata];
                if (weakSelf.isChild) {
                    [state mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.top.mas_equalTo(0);
                        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [GUIUtil fit:250]));
                    }];
                }
                [weakSelf reloadData];
                return ;
            }
            [weakSelf reloadData];
            weakSelf.isLoaded = YES;
            [StateUtil hide:weakSelf];
        }else{
            if (!isAuto) {
                [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
                if (weakSelf.isLoaded==NO) {
                    ReloadStateView *stateView = (ReloadStateView *)[StateUtil show:weakSelf type:StateTypeReload];
                    stateView.onReload = ^{
                        [weakSelf loadData:NO];
                    };
                    if (weakSelf.isChild) {
                        [stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                            make.left.top.mas_equalTo(0);
                            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [GUIUtil fit:250]));
                        }];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        if (!isAuto) {
            [HUDUtil showInfo:[FTConfig webTips]];
            if (weakSelf.isLoaded==NO) {
                ReloadStateView *stateView = (ReloadStateView *)[StateUtil show:weakSelf type:StateTypeReload];
                stateView.onReload = ^{
                    [weakSelf loadData:NO];
                };
                if (weakSelf.isChild) {
                    [stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.top.mas_equalTo(0);
                        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [GUIUtil fit:250]));
                    }];
                }
            }
        }
    }];
}

- (void)changedSymbol:(NSString *)symbol{
    if (![_symobl isEqualToString:symbol]&&symbol.length>0) {
        _symobl = symbol;
        [_dataList removeAllObjects];
        [self reloadData];
        [self loadData:NO];
    }
}


//MARK: - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RuleCell *cell=[tableView dequeueReusableCellWithIdentifier:@"RuleCell"];
    [cell configOfCell:[NDataUtil dataWithArray:_dataList index:indexPath.row] isSingle:indexPath.row%2==0];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [RuleCell heightOfCell:[NDataUtil dataWithArray:_dataList index:indexPath.row]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_scrollDelegate scrollViewDidScroll:scrollView];
}


@end

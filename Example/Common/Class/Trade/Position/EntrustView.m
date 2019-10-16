//
//  EntruestView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "EntrustView.h"
#import "EntrustCell.h"

#import "OrderModel.h"

@interface EntrustView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) OrderKeyBoardView *keyBoardView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,strong) UIView *headerView;
@property (nonatomic,strong) UILabel *headerTitle;
@property (nonatomic,assign) BOOL isLoaded;
@end

@implementation EntrustView

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.backgroundColor = [GColorUtil C6];
        self.delegate = self;
        self.dataSource = self;
        self.showsVerticalScrollIndicator = NO;
        self.separatorStyle = UITableViewCellSelectionStyleNone;
        [self registerClass:[EntrustCell class] forCellReuseIdentifier:@"EntrustCell"];
        
        [self addSubview:self.textField];
        _dataList = [NSMutableArray array];
        self.tableHeaderView = self.headerView;
        [self addNotic];
    }
    return self;
}

- (void)willAppear{
    if ([UserModel isLogin]==NO) {
        StateView *stateView = [StateUtil show:self type:StateTypeNodata];
        [stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [GUIUtil fit:250]));
        }];
        [NTimeUtil stopTimer:@"TradeVC_entrust"];
        _dataList = nil;
        [self reloadData];
        return;
    }
    [self loadData:NO];
    [self startTimer];
}

- (void)startTimer{
    WEAK_SELF;
    [NTimeUtil startTimer:@"TradeVC_entrust" interval:5 repeats:YES action:^{
        [weakSelf loadData:YES];
    }];
}

- (void)loadData:(BOOL)isAuto{
    WEAK_SELF;
    if (![UserModel isLogin]) {
        return;
    }
    if (!_isLoaded&&!isAuto) {
        StateView *state = [StateUtil show:self type:StateTypeProgress];
        [state mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [GUIUtil fit:250]));
        }];
    }
    [DCService getQueryEntrust:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            NSDictionary *dic = data[@"data"];
            [weakSelf parseData:dic];
            weakSelf.changedCount(weakSelf.dataList.count);
            if (weakSelf.dataList.count<=0) {
                NoDataStateView *state = (NoDataStateView *)[StateUtil show:weakSelf type:StateTypeNodata];
                state.title.text = CFDLocalizedString(@"暂无委托");
                [state mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.mas_equalTo(0);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [GUIUtil fit:250]));
                }];
                [weakSelf reloadData];
                return ;
            }else{
                weakSelf.headerTitle.text = [NDataUtil stringWith:dic[@"tips"]];
                if (weakSelf.headerTitle.text.length>0) {
                    weakSelf.headerView.hidden = NO;
                    weakSelf.tableHeaderView = weakSelf.headerView;
                }else{
                    weakSelf.tableHeaderView = [UIView new];
                }
                [StateUtil hide:weakSelf];
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
                    [stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                        make.left.top.mas_equalTo(0);
                        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [GUIUtil fit:250]));
                    }];
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
                [stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.mas_equalTo(0);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [GUIUtil fit:250]));
                }];
            }
        }
    }];
}

- (void)parseData:(NSDictionary *)dic{
    WEAK_SELF;
    NSMutableArray *tem = [NSMutableArray array];
    NSArray *list = [NDataUtil arrayWith:dic[@"orderlist"]];
    [list enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableDictionary *dict = obj.mutableCopy;
        [weakSelf.dataList enumerateObjectsUsingBlock:^(NSMutableDictionary *dic, NSUInteger i, BOOL * _Nonnull s) {
            if ([NDataUtil boolWithDic:dic key:@"orderno" isEqual:[NDataUtil stringWith:obj[@"orderno"]]]) {
                *s = YES;
                [dict setObject:[NDataUtil stringWith:dic[@"isUnFold"] valid:@"0"] forKey:@"isUnFold"];
            }
        }];
        [tem addObject:dict];
    }];
    weakSelf.dataList = tem;
}

- (void)closePosAction:(NSDictionary *)dic{
    WEAK_SELF;
    [DCAlert showAlert:@"" detail:CFDLocalizedString(@"确定撤单") sureTitle:CFDLocalizedString(@"确定") sureHander:^{
        [DCService postcancelOrderno:[NDataUtil stringWith:dic[@"orderno"]] success:^(id data) {
            if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
                [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"]]];
                [weakSelf.dataList removeObject:dic];
                [weakSelf reloadData];
            }else{
                [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
            }
        } failure:^(NSError *dic) {
            [HUDUtil showInfo:[FTConfig webTips]];
        }];
    } cancelTitle:CFDLocalizedString(@"取消") cancelHander:^{
        
    }];
}

- (BOOL)isFirstRespond{
    return _textField.isFirstResponder;
}

- (void)addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    [center addObserver:self selector:@selector(languageChangedAction) name:LanguageDidChangedNotification object:nil];
}


- (void)languageChangedAction{
    _isLoaded=NO;
    [_dataList removeAllObjects];
    [self loadData:NO];
}

//MARK: - TableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EntrustCell *cell=[tableView dequeueReusableCellWithIdentifier:@"EntrustCell"];
    [cell configCell:[NDataUtil dataWithArray:_dataList index:indexPath.row]];
    WEAK_SELF;
    cell.closePosAction = ^(NSMutableDictionary *dic){
        [weakSelf closePosAction:dic];
    };
    cell.setterSLTPHaner = ^(OrderKeyBoardType type, NSDictionary * _Nonnull dic) {
        [weakSelf becomeFirstReposd:type config:dic];
    };
    cell.reloadDataHander = ^{
        [weakSelf reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [EntrustCell heightOfCell:[NDataUtil dataWithArray:_dataList index:indexPath.row]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_scrollDelegate scrollViewDidScroll:scrollView];
}

- (void)becomeFirstReposd:(OrderKeyBoardType )type config:(NSDictionary *)dic{
    NSArray *list=nil;
    NSString *precent = @"";
    NSString *openPrice = [NDataUtil stringWith:dic[@"buyprice"]];;
    if (type == OrderKeyBoardTypeSl) {
        list = [NDataUtil arrayWith:dic[@"stoplossPrecentLevel"]];
        list = [OrderModel pickerData:list];
        precent =[NDataUtil stringWith:dic[@"stoplossprecent"]];
    }else{
        list = [NDataUtil arrayWith:dic[@"stopprofitPrecentLevel"]];
        list = [OrderModel pickerData:list];
        precent =[NDataUtil stringWith:dic[@"stopprofitprecent"]];
    }
    CGFloat minfloat = [NDataUtil floatWith:dic[@"minfloat"] valid:0];
    NSInteger dotNum = log10f(minfloat);
    self.keyBoardView.dotnum = ABS(dotNum);
    [self.keyBoardView setConfig:dic isEntrust:YES];
    [_keyBoardView configView:type list:list selData:precent price:openPrice];
    _keyBoardView.height = [OrderKeyBoardView heightOfView:type];
    _keyBoardView.bstype = [NDataUtil stringWith:dic[@"direction"]];
    _textField.inputView = _keyBoardView;
    [_textField becomeFirstResponder];
}

//MARK: - Getter

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        _textField.hidden = YES;
    }
    return _textField;
}

- (UIView *)headerView{
    if (!_headerView) {
        _headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [GUIUtil fit:30])];
        _headerView.backgroundColor = [ChartsUtil C13:0.1];
        [_headerView addSubview:self.headerTitle];
        [_headerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:10]);
            make.width.mas_equalTo([GUIUtil fit:-20]+SCREEN_WIDTH);
            make.centerY.mas_equalTo(0);
        }];
        _headerView.hidden = YES;
    }
    return _headerView;
}

- (UILabel *)headerTitle{
    if (!_headerTitle) {
        _headerTitle = [[UILabel alloc] init];
        _headerTitle.textColor = [GColorUtil C13];
        _headerTitle.font = [GUIUtil fitFont:14];
        _headerTitle.adjustsFontSizeToFitWidth = YES;
        _headerTitle.minimumScaleFactor = 0.5;
    }
    return _headerTitle;
}

- (OrderKeyBoardView *)keyBoardView{
    if (!_keyBoardView) {
        _keyBoardView = [[OrderKeyBoardView alloc] init];
        _keyBoardView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [GUIUtil fit:400]);
        WEAK_SELF;
        _keyBoardView.didSelelectedRow = ^(NSDictionary * _Nonnull dic, OrderKeyBoardType type) {
            NSString *sl = @"";
            NSString *tp = @"";
            NSString *op = @"";
            if (type == OrderKeyBoardTypeSl) {
                sl = [NDataUtil stringWith:dic[@"data"]];
                op = @"2";
            }else if (type == OrderKeyBoardTypeTP){
                tp = [NDataUtil stringWith:dic[@"data"]];
                op = @"1";
            }
            [DCService postUpdateSLTPWithOrderno:[NDataUtil stringWith:weakSelf.keyBoardView.config[@"orderno"]] optype:op stopprofit:tp stoploss:sl success:^(id data) {
                if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
                    [weakSelf endEditing:YES];
                }
                [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
            } failure:^(NSError *error) {
                [HUDUtil showInfo:[FTConfig webTips]];
            }];
            
        };
        _keyBoardView.calSLTPData = ^NSDictionary * _Nonnull(NSString * _Nonnull precent, BOOL isSl) {
            if (isSl) {
                return [OrderModel calSLData:precent data:weakSelf.keyBoardView.config];
            }else{
                return [OrderModel calTPData:precent data:weakSelf.keyBoardView.config];
            }
        };
    }
    return _keyBoardView;
}

@end

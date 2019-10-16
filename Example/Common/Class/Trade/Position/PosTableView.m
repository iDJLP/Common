//
//  PosTableView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "PosTableView.h"
#import "PosCell.h"

#import "OrderModel.h"

@interface PosTableView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSMutableArray *dataList;
@property (nonatomic,strong) OrderKeyBoardView *keyBoardView;
@property (nonatomic,strong) UITextField *textField;
@property (nonatomic,assign) BOOL isLoaded;
@end

@implementation PosTableView

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
        [self registerClass:[PosCell class] forCellReuseIdentifier:@"PosCell"];
        [self addSubview:self.textField];
        _dataList = [NSMutableArray array];
        [self loadData:NO];
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
        [NTimeUtil stopTimer:@"TradeVC_child"];
        _dataList = nil;
        [self reloadData];
        self.changedCount(_dataList.count);
        return;
    }
    [self startTimer];
}

- (void)startTimer{
    WEAK_SELF;
    [NTimeUtil startTimer:@"TradeVC_child" interval:1 repeats:YES action:^{
        [weakSelf loadData:YES];
    }];
}

- (void)loadData:(BOOL)isAuto{
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
    WEAK_SELF;
    [DCService getQueryposition:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [weakSelf parseData:data[@"data"]];
            weakSelf.changedCount(weakSelf.dataList.count);
            if (weakSelf.dataList.count<=0) {
                NoDataStateView *stateView = (NoDataStateView *)[StateUtil show:weakSelf type:StateTypeNodata];
                stateView.title.text = CFDLocalizedString(@"暂无持仓");
                [stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.left.top.mas_equalTo(0);
                    make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, [GUIUtil fit:250]));
                }];
                [weakSelf reloadData];
                return ;
            }else{
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
    NSArray *list = [NDataUtil arrayWith:dic[@"poslist"]];
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
    [DCAlert showAlert:@"" detail:CFDLocalizedString(@"确定平仓") sureTitle:CFDLocalizedString(@"确定") sureHander:^{
        [DCService postclosePosOrderno:[NDataUtil stringWith:dic[@"posid"]] ordertype:[NDataUtil stringWith:dic[@"ordertype"]] price:@"" quantity:[NDataUtil stringWith:dic[@"quantity"]] success:^(id data) {
            if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
                [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"]]];
                [weakSelf.dataList removeObject:dic];
                [weakSelf reloadData];
            }else{
                [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
            }
        } failure:^(NSError *error) {
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
    PosCell *cell=[tableView dequeueReusableCellWithIdentifier:@"PosCell"];
    [cell configCell:[NDataUtil dataWithArray:_dataList index:indexPath.row]];
    WEAK_SELF;
    cell.closePosAction = ^(NSMutableDictionary *dic){
        [weakSelf closePosAction:dic];
    };
    cell.setterSLTPHaner = ^OrderKeyBoardView * _Nonnull(OrderKeyBoardType type, NSDictionary * _Nonnull dic) {
        OrderKeyBoardView *view = [weakSelf becomeFirstReposd:type config:dic];
        return view;
    };
    cell.reloadDataHander = ^{
        [weakSelf reloadData];
    };
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [PosCell heightOfCell:[NDataUtil dataWithArray:_dataList index:indexPath.row]];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_scrollDelegate scrollViewDidScroll:scrollView];
}

- (OrderKeyBoardView *)becomeFirstReposd:(OrderKeyBoardType )type config:(NSDictionary *)dic{
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
    [self.keyBoardView setConfig:dic isEntrust:NO];
    [_keyBoardView configView:type list:list selData:precent price:openPrice];
    _keyBoardView.bstype = [NDataUtil stringWith:dic[@"direction"]];
    _keyBoardView.height = [OrderKeyBoardView heightOfView:type]+[GUIUtil fit:45];
    _textField.inputView = _keyBoardView;
    [_textField becomeFirstResponder];
    return self.keyBoardView;
}

//MARK: - Getter

- (UITextField *)textField{
    if (!_textField) {
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 0, 1, 1)];
        _textField.hidden = YES;
    }
    return _textField;
}

- (OrderKeyBoardView *)keyBoardView{
    if (!_keyBoardView) {
        _keyBoardView = [[OrderKeyBoardView alloc] init];
        _keyBoardView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [GUIUtil fit:400]);
        WEAK_SELF;
        _keyBoardView.didSelelectedRow = ^(NSDictionary * _Nonnull dic, OrderKeyBoardType type) {
            NSString *sl = @"";
            NSString *tp = @"";
            
            if (type == OrderKeyBoardTypeSl) {
                sl = [NDataUtil stringWith:dic[@"data"]];
            }else if (type == OrderKeyBoardTypeTP){
                tp = [NDataUtil stringWith:dic[@"data"]];
            }
            [DCService postSetSLTPWithPosid:[NDataUtil stringWith:weakSelf.keyBoardView.config[@"posid"]] stopprofit:tp stoploss:sl success:^(id data) {
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

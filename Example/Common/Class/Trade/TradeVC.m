//
//  TradeVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/18.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "TradeVC.h"
#import "TradeHeaderView.h"
#import "LockerView.h"
#import "PosTableView.h"
#import "EntrustView.h"
#import "OrderView.h"
#import "HQPankouView.h"
#import "TradeMlineView.h"
#import "DisnetView.h"
#import "BaseView.h"
#import "BaseImageView.h"
#import "BaseLabel.h"

#import "MarketVC.h"
#import "PositionHisVC.h"
#import "Popover.h"
#import "RuleVC.h"
#import "CalculatorVC.h"



@interface TradeVC ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>


@property (nonatomic,strong)LockerView *scrollView;
@property (nonatomic,strong)TradeHeaderView *headerView;
@property (nonatomic,strong)OrderView *orderView;
@property (nonatomic,strong)HQPankouView *pankouView;
@property (nonatomic,strong)BaseView *separatView;
@property (nonatomic,strong)PosTableView *posView;
@property (nonatomic,strong)EntrustView *entrustView;
@property (nonatomic,strong)UIButton *hisPosBtn;
@property (nonatomic,strong)UIButton *closeAllBtn;
@property (nonatomic,strong)TradeMlineView *mlineView;
@property (nonatomic,strong)DisnetBar *disnetBar;

@property (nonatomic,strong)UITapGestureRecognizer *tap;

@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *contractName;
@property (nonatomic, assign) BOOL isReal;

@property (nonatomic,strong)CFDBaseInfoModel *data;
@property (nonatomic,assign)BOOL isUnFold;
@property (nonatomic,assign)BOOL isJumpedNeedSocket;
@property (nonatomic,assign)NSInteger posCount;
@property (nonatomic,assign)NSInteger entrustCount;

@property (nonatomic,copy) void(^updateCalculatorPriceHander)(NSDictionary *target);

@end

@implementation TradeVC

+ (void)jumpTo:(NSString *)symbol{
    [self jumpTo:symbol isBuy:YES];
}

+ (void)jumpTo:(NSString *)symbol isBuy:(BOOL)isBuy{
    MainTabBarVC * tabC =(MainTabBarVC *)[GJumpUtil rootTabC];
    [(UINavigationController *)tabC.selectedViewController popViewControllerAnimated:NO];
    UINavigationController *navC = tabC.customizableViewControllers[2];
    TradeVC *target = (TradeVC *)[navC.viewControllers firstObject];
    if ([target isKindOfClass:[TradeVC class]]&&symbol.length>0) {
        [target changedSymbol:symbol];
    }
    [tabC selectedItemWithClassString:NSStringFromClass([self class])];
    [target.orderView changeTradeType:isBuy];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    _isJumpedNeedSocket = NO;
    [_orderView willAppear];
    [_pankouView willAppear];
    [_posView willAppear];
    [_entrustView willAppear];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [self marketVCDisAppear];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    if (!_isJumpedNeedSocket) {
        [_pankouView willDisappear];
    }
    [_mlineView viewDisAppear];
    [NTimeUtil stopTimer:@"TradeVC_child"];
    [NTimeUtil stopTimer:@"TradeVC_entrust"];
    [NTimeUtil stopTimer:@"TradeVC_order"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_symbol.length<=0) {
        _symbol = @"BTCUSDT";
    }
    [self setupUI];
    [self autoLayout];
    [self.view addGestureRecognizer:self.tap];
    [self addNotic];
    WEAK_SELF;
    [GUIUtil refreshWithHeader:_scrollView refresh:^{
        [weakSelf.orderView refreshData:^{
            [weakSelf.scrollView.mj_header endRefreshing];
            [weakSelf updateScrollViewContentSize];
        }];
        [weakSelf.pankouView refreshData];
        if (self.scrollView.selectedIndex==0) {
            [weakSelf.posView loadData:NO];
        }else if (self.scrollView.selectedIndex==1){
            [weakSelf.entrustView loadData:NO];
        }
    }];

    // Do any additional setup after loading the view.
}

- (void)tapAction{
    [self.view endEditing:YES];
}

- (void)setupUI{
    self.view.backgroundColor = [GColorUtil C6];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.mlineView];
    [self.scrollView addSubview:self.orderView];
    [self.scrollView addSubview:self.pankouView];
    [self.scrollView addSubview:self.separatView];
    [self.scrollView addSubview:self.hisPosBtn];
    [self.scrollView addSubview:self.closeAllBtn];
}
- (void)autoLayout{
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo([TradeHeaderView heightOfView]);
    }];
    [_mlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
    }];
    [_orderView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.size.mas_equalTo([OrderView sizeOfView]);
    }];
    [_pankouView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(self.orderView.mas_right);
        make.height.mas_equalTo([OrderView sizeOfView].height-[GUIUtil fit:50]+[GUIUtil fit:35]);
        make.width.mas_equalTo([HQPankouView sizeOfView].width);
    }];
    [_separatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fit:5]);
        make.top.equalTo(self.orderView.mas_bottom);
    }];
    CGFloat height = [OrderView sizeOfView].height+[GUIUtil fit:5];
    [_hisPosBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_left).mas_offset(SCREEN_WIDTH-[GUIUtil fit:15]);
        make.height.mas_equalTo([GUIUtil fit:35]);
        make.top.mas_equalTo(height);
    }];
    [_closeAllBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.hisPosBtn.mas_left).mas_offset([GUIUtil fit:-15]);
        make.height.mas_equalTo([GUIUtil fit:35]);
        make.top.mas_equalTo(height);
    }];
}

//MARK: - Action

- (void)changedSymbol:(NSString *)symbol{
    
    if (![_symbol isEqualToString:symbol]&&_symbol.length>0) {
        [_headerView configView:@{@"symbol":symbol}];
        [_orderView changedSymbol:symbol];
        [_pankouView changedSymbol:symbol];
        [_mlineView updateSymbol:symbol];
    }
    _symbol=symbol;
}

- (void)hisPosAction{
    if (![UserModel isLogin]) {
        [CFDJumpUtil jumpToLogin];
        return;
    }
    [PositionHisVC jumpTo];
}



- (void)closeAllAction{
    if (![UserModel isLogin]) {
        [CFDJumpUtil jumpToLogin];
        return;
    }
    if (_posCount >0) {
        WEAK_SELF;
        [DCAlert showAlert:@"" detail:CFDLocalizedString(@"是否全部以市价平仓") sureTitle:CFDLocalizedString(@"确认_yes") sureHander:^{
            [weakSelf closeHander];
        } cancelTitle:CFDLocalizedString(@"取消_no") cancelHander:^{
            
        }];
    }
}

- (void)closeHander{
    WEAK_SELF;
    [HUDUtil showProgress:@""];
    [DCService postCloseAllOrder:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [HUDUtil showInfo:CFDLocalizedString(@"操作成功")];
            [weakSelf.posView reloadData];
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
    }];
}

- (void)updateSectionTitle{
    NSString *pos = CFDLocalizedString(@"持仓");
    NSString *entrust = CFDLocalizedString(@"委托");
    if (_posCount>0) {
        pos = [pos stringByAppendingFormat:@"(%ld)",(long)_posCount];
    }
    if (_entrustCount>0) {
        entrust = [entrust stringByAppendingFormat:@"(%ld)",(long)_entrustCount];
    }
    [_scrollView updateTitleList:@[pos,entrust]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(nonnull UITouch *)touch{
    if (self.entrustView.isFirstRespond&&self.posView.isFirstRespond==NO&&self.orderView.isFirstRespond==NO&&gestureRecognizer.view==self.view) {
        return NO;
    }
    return YES;
}

//MARK: - MarketVC

- (void)marketVCDisAppear{
    WEAK_SELF;
    MarketVC *target = [self.childViewControllers lastObject];
    if ([target isKindOfClass:MarketVC.class]) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            target.tableView.transform = CGAffineTransformMakeTranslation(0, -target.tableView.height);
            target.view.alpha=0;
        } completion:^(BOOL finished) {
            [target.view removeFromSuperview];
            [target removeFromParentViewController];
            weakSelf.tap.enabled=YES;
        }];
        self.isUnFold=NO;
        [_orderView willAppear];
        [_pankouView willAppear];
        [_posView willAppear];
        [_entrustView willAppear];
    }
    self.scrollView.userInteractionEnabled = YES;
}

- (void)marketVCAppear{
    MarketVC *target = self.marketChildVC;
    [self.view addSubview:target.view];
    self.scrollView.userInteractionEnabled = NO;
    [target.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    [self.view layoutIfNeeded];
    self.tap.enabled=NO;
    target.tableView.transform = CGAffineTransformMakeTranslation(0, -target.tableView.height);
    target.view.alpha=0;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        target.tableView.transform = CGAffineTransformIdentity;
        target.view.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
    self.isUnFold=YES;
    [_pankouView willDisappear];
    [NTimeUtil stopTimer:@"TradeVC_child"];
    [NTimeUtil stopTimer:@"TradeVC_entrust"];
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
            make.top.mas_equalTo(TOP_BAR_HEIGHT);
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
    [self.scrollView.mj_header beginRefreshing];
    [self.pankouView changedSymbol:_symbol];
}

- (void)updateScrollViewContentSize {
    CGRect contentRect = CGRectMake(0, 0, SCREEN_WIDTH, 0);
    for (UIView *view in self.scrollView.subviews) {
        if ([view isEqual:self.scrollView.mj_header]) {
            continue;
        }
        contentRect = CGRectUnion(contentRect, view.frame);
    }
    contentRect.size.height += [GUIUtil fit:20]; // 增加20间隙
    if (contentRect.size.height < SCREEN_HEIGHT) {
        contentRect.size.height = SCREEN_HEIGHT + 1;
    }
    self.scrollView.contentSize = contentRect.size;
}


//MARK: - Getter

- (MarketVC *)marketChildVC{
    MarketVC *marketChildVC = [[MarketVC alloc] init];
    marketChildVC.view.backgroundColor = [GColorUtil colorWithBlackColorType:C8_ColorType alpha:0.8];
    WEAK_SELF;
    marketChildVC.didSelectedCell = ^(NSString * _Nonnull symbol) {
        [weakSelf changedSymbol:symbol];
        [weakSelf marketVCDisAppear];
    };
    marketChildVC.flodViewHander = ^{
        [weakSelf marketVCDisAppear];
    };
    [self addChildViewController:marketChildVC];
    return marketChildVC;
}

- (TradeHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[TradeHeaderView alloc] init];
        _headerView.bgColor = C6_ColorType;
        WEAK_SELF;
        _headerView.tapHander = ^{
            if (weakSelf.isUnFold) {
                [weakSelf marketVCDisAppear];
            }else{
                [weakSelf marketVCAppear];
            }
        };
        _headerView.rightHander = ^(NSString *symbol) {
            [CFDJumpUtil jumpToCharts:symbol];
        };
        _headerView.right1Hander = ^(NSString * _Nonnull symbol) {
            NSDictionary *dict = @{@"title":CFDLocalizedString(@"规则说明"),@"icon":@"pop_icon_rules",@"type":@"1"};
            NSDictionary *dict1 = @{@"title":CFDLocalizedString(@"计算器"),@"icon":@"pop_icon_calculator",@"type":@"2"};
            [Popover showAlert:@[dict,dict1] point:CGPointMake([GUIUtil fit:370], TOP_BAR_HEIGHT-[GUIUtil fit:5]) sureHander:^(NSDictionary * _Nonnull dict) {
                if ([NDataUtil boolWithDic:dict key:@"type" isEqual:@"1"]) {
                    [RuleVC jumpTo:symbol];
                }else if ([NDataUtil boolWithDic:dict key:@"type" isEqual:@"2"]){
                    if (![weakSelf.headerView.config containsObjectForKey:@"pryList"]) {
                        return ;
                    }
                    weakSelf.isJumpedNeedSocket = YES;
                    CalculatorVC *target = [CalculatorVC jumpTo:weakSelf.headerView.config];
                    __weak typeof(target) weakVC = target;
                    weakSelf.updateCalculatorPriceHander = ^(NSDictionary *dict) {
                        [weakVC updatePrice:dict];
                    };
                }
            }];
        };
    }
    return _headerView;
}

- (LockerView *)scrollView{
    if (!_scrollView) {
        CGFloat height = [OrderView sizeOfView].height+[GUIUtil fit:5];
        NSDictionary *dic1 = @{@"title":CFDLocalizedString(@"持仓") ,@"view":self.posView};
        NSDictionary *dic2 = @{@"title":CFDLocalizedString(@"委托"),@"view":self.entrustView};
        _scrollView = [[LockerView alloc] initWithTopHeight:ceil(height) lists:@[dic1,dic2] sectionType:SectionTypeLeft];
        _scrollView.frame = CGRectMake(0, [TradeHeaderView heightOfView], SCREEN_WIDTH, SCREEN_HEIGHT-[TradeHeaderView heightOfView]-BOTTOM_BAR_HEIGHT-[GUIUtil fit:35]);
        _scrollView.bgColor = C8_ColorType;
        [_scrollView setSectionBgColor:C6_ColorType sectionTextFont:[GUIUtil fitFont:16] sectionTextColor:C3_ColorType sectionSelTextColor:C13_ColorType hasLine:NO];
        WEAK_SELF;
        _scrollView.selectedIndexHander = ^(NSInteger index) {
            if (index==0) {
                [weakSelf.posView willAppear];
                if (weakSelf.posCount>0) {
                    weakSelf.closeAllBtn.hidden = NO;
                }else{
                    weakSelf.closeAllBtn.hidden = YES;
                }
            }else if (index==1){
                [weakSelf.entrustView willAppear];
                weakSelf.closeAllBtn.hidden = YES;
            }
        };
    }
    return _scrollView;
}

- (TradeMlineView *)mlineView{
    if (!_mlineView) {
        _mlineView = [[TradeMlineView alloc] init];
        [_mlineView updateSymbol:_symbol];
//        _mlineView.hidden = YES;
    }
    return _mlineView;
}

- (BaseView *)separatView{
    if (!_separatView) {
        _separatView = [[BaseView alloc] init];
        _separatView.bgColor = C8_ColorType;
    }
    return _separatView;
}

- (PosTableView *)posView{
    if (!_posView) {
        _posView = [[PosTableView alloc] init];
        _posView.bgColor = C6_ColorType;
        WEAK_SELF;
        _posView.changedCount = ^(NSInteger count) {
            if (weakSelf.posCount!=count) {
                weakSelf.posCount = count;
                [weakSelf updateSectionTitle];
                if (weakSelf.posCount>0&&weakSelf.scrollView.selectedIndex==0) {
                    weakSelf.closeAllBtn.hidden = NO;
                }else{
                    weakSelf.closeAllBtn.hidden = YES;
                }
            }
        };
    }
    return _posView;
}
- (EntrustView *)entrustView{
    if (!_entrustView) {
        _entrustView = [[EntrustView alloc] init];
        _entrustView.bgColor = C6_ColorType;
        WEAK_SELF;
        _entrustView.changedCount = ^(NSInteger count) {
            if (weakSelf.entrustCount!=count) {
                weakSelf.entrustCount = count;
                [weakSelf updateSectionTitle];
            }
        };
    }
    return _entrustView;
}

- (HQPankouView *)pankouView{
    if (!_pankouView) {
        _pankouView = [[HQPankouView alloc] initWithSymbol:_symbol height:[OrderView sizeOfView].height-[GUIUtil fit:50]+[GUIUtil fit:35]];
        _pankouView.bgColor = C6_ColorType;
        WEAK_SELF;
        _pankouView.changedPriceHander = ^(NSDictionary * _Nonnull dic) {
            [weakSelf.orderView changedPrice:dic];
            if (weakSelf.updateCalculatorPriceHander) {
                weakSelf.updateCalculatorPriceHander(dic);
            }
        };
    }
    return _pankouView;
}

- (OrderView *)orderView{
    if (!_orderView) {
        _orderView = [[OrderView alloc] initWithSymbol:_symbol];
        _orderView.bgColor = C6_ColorType;
        WEAK_SELF;
        _orderView.updateHeaderViewHander = ^(OrderModel * _Nonnull model) {
            [weakSelf.headerView configView:@{@"title":model.contractname,@"symbol":model.symbol,@"pryList":model.pryList,@"scale":model.scale,@"dotNum":[NSString stringWithFormat:@"%ld",model.dotNum],@"minfloat":model.minfloat}];
            [weakSelf.mlineView updateTitle:model.contractname];
        };
        _orderView.reloadPosHander = ^{
            [weakSelf.posView loadData:NO];
        };
        _orderView.reloadEntrustHander = ^{
            [weakSelf.entrustView loadData:NO];
        };
    }
    return _orderView;
}

- (UIButton *)hisPosBtn{
    if (!_hisPosBtn) {
        _hisPosBtn = [[UIButton alloc] init];
        NSString *imageName = [[FTConfig sharedInstance].lang isEqualToString:@"en"]? @"trade_btn_history_en":@"trade_btn_history";
        [_hisPosBtn setImage:[GColorUtil imageNamed:imageName] forState:UIControlStateNormal];
        [_hisPosBtn addTarget:self action:@selector(hisPosAction) forControlEvents:UIControlEventTouchUpInside];
        [_hisPosBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _hisPosBtn;
}

- (UIButton *)closeAllBtn{
    if (!_closeAllBtn) {
        _closeAllBtn = [[UIButton alloc] init];
        NSString *imageName = [[FTConfig sharedInstance].lang isEqualToString:@"en"]? @"trade_btn_closeall_en":@"trade_btn_closeall";
        [_closeAllBtn setImage:[GColorUtil imageNamed:imageName] forState:UIControlStateNormal];
        [_closeAllBtn addTarget:self action:@selector(closeAllAction) forControlEvents:UIControlEventTouchUpInside];
        [_closeAllBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
        _closeAllBtn.hidden = YES;
    }
    return _closeAllBtn;
}

- (UITapGestureRecognizer *)tap{
    if (!_tap) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
        tap.delegate = self;
        [tap addTarget:self action:@selector(tapAction)];
        _tap = tap;
    }
    return _tap;
}

- (void)languageChangedAction{
    WEAK_SELF;
    NSString *closeImageName = [[FTConfig sharedInstance].lang isEqualToString:@"en"]? @"trade_btn_closeall_en":@"trade_btn_closeall";
    [_closeAllBtn setImage:[GColorUtil imageNamed:closeImageName] forState:UIControlStateNormal];
    NSString *imageName = [[FTConfig sharedInstance].lang isEqualToString:@"en"]? @"trade_btn_history_en":@"trade_btn_history";
    [_hisPosBtn setImage:[GColorUtil imageNamed:imageName] forState:UIControlStateNormal];
    [self updateSectionTitle];
    [GUIUtil refreshWithHeader:_scrollView refresh:^{
        [weakSelf.orderView refreshData:^{
            [weakSelf.scrollView.mj_header endRefreshing];
            [weakSelf updateScrollViewContentSize];
        }];
        [weakSelf.pankouView refreshData];
        if (self.scrollView.selectedIndex==0) {
            [weakSelf.posView loadData:NO];
        }else if (self.scrollView.selectedIndex==1){
            [weakSelf.entrustView loadData:NO];
        }
    }];
    [weakSelf.orderView refreshData:^{
        [weakSelf.scrollView.mj_header endRefreshing];
        [weakSelf updateScrollViewContentSize];
    }];
    [weakSelf.pankouView refreshData];
    if (self.scrollView.selectedIndex==0) {
        [weakSelf.posView loadData:NO];
    }else if (self.scrollView.selectedIndex==1){
        [weakSelf.entrustView loadData:NO];
    }
}

- (void)themeChangedAction{
    WEAK_SELF;
    [GUIUtil refreshWithHeader:_scrollView refresh:^{
        [weakSelf.orderView refreshData:^{
            [weakSelf.scrollView.mj_header endRefreshing];
            [weakSelf updateScrollViewContentSize];
        }];
        [weakSelf.pankouView refreshData];
        if (self.scrollView.selectedIndex==0) {
            [weakSelf.posView loadData:NO];
        }else if (self.scrollView.selectedIndex==1){
            [weakSelf.entrustView loadData:NO];
        }
    }];

}

- (void)addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
    [center addObserver:self
               selector:@selector(themeChangedAction)
                   name:ThemeDidChangedNotification
                 object:nil];
    [center addObserver:self selector:@selector(languageChangedAction) name:LanguageDidChangedNotification object:nil];
    [self initNet];
}


@end

//
//  HomeVC.m
//  Chart
//
//  Created by ngw15 on 2019/3/4.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "ChartsVC.h"

#import "LockerView.h"
#import "DepthView.h"
#import "TradeView.h"
#import "RuleView.h"

#import "CFDChartsView.h"
#import "ChartsHeaderView.h"
#import "ChartsInfoView.h"
#import "ChartsBottomView.h"
#import "DemoChartsModel.h"
#import "CFDHSView.h"
#import "WebVC.h"
#import "HQAlertVC.h"
#import "MarketVC.h"


@interface ChartsVC ()<UIScrollViewDelegate,CFDChartsDelegate,CFDHSViewDelegate>

@property (nonatomic,strong)LockerView *scrollView;
@property (nonatomic,strong)DepthView *depthView;
@property (nonatomic,strong)TradeView *tradeView;
@property (nonatomic,strong)RuleView *ruleView;

@property (nonatomic,strong)ChartsHeaderView *headerView;
@property (nonatomic,strong)ChartsInfoView *infoView;
@property (nonatomic,strong)CFDChartsView *chartsView;
@property (nonatomic,strong)BaseView *colorView;
@property (nonatomic,strong) CFDHSView *hsView;
@property (nonatomic,strong)ChartsBottomView *bottomView;

@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *contractName;
@property (nonatomic, copy) NSString *contractCode;
@property (nonatomic, assign) BOOL isReal;

@property (nonatomic,strong)CFDBaseInfoModel *data;
@property (nonatomic,assign)BOOL isUnFold;
@end

@implementation ChartsVC

+ (void)jumpTo:(NSString *)symbol{
    ChartsVC *target = [[ChartsVC alloc] init];
    target.symbol=  symbol;
//    target.symbol=  @"BSVUSDT";
    target.hidesBottomBarWhenPushed = YES;
    [[GJumpUtil rootNavC] pushViewController:target animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [_chartsView willAppear];
    [_depthView willAppear];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [_chartsView willDisappear];
    [_depthView willDisAppear];
    [NTimeUtil stopTimer:@"ChartsVC_child"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self autoLayout];
    [self.chartsView clickedButtonList:0];
    WEAK_SELF;
    [GUIUtil refreshWithHeader:_scrollView refresh:^{
        if (weakSelf.scrollView.selectedIndex==0) {
            [weakSelf.depthView refreshData];
        }else if (weakSelf.scrollView.selectedIndex==1){
            [weakSelf.tradeView refreshData];
        }else if (weakSelf.scrollView.selectedIndex==2){
            [weakSelf.ruleView refreshData];
        }
        [weakSelf.chartsView loadKline];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self.chartsView selector:@selector(loadKline) name:UIApplicationWillEnterForegroundNotification object:nil];
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    self.view.backgroundColor = [GColorUtil C6_black];
    [self.view addSubview:self.headerView];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.hsView];
    [self.scrollView addSubview:self.infoView];
    [self.scrollView addSubview:self.chartsView];
    [self.scrollView addSubview:self.colorView];
    [self.view addSubview:self.bottomView];
}
- (void)autoLayout{
    [_headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo([ChartsHeaderView heightOfView]);
    }];
    [_infoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([ChartsInfoView heightOfView]);
    }];
    [_chartsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(self.chartsView.vHeight);
    }];
    [_colorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.chartsView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fit:5]);
    }];
    [_bottomView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo([ChartsBottomView heightOfView]);
    }];
}

//MARK: - ChartsDelegate

- (void)updateBaseInfo:(CFDBaseInfoModel *)data{
    if ([self.scrollView.mj_header isRefreshing]) {
        [self.scrollView.mj_header endRefreshing];
        [self updateScrollViewContentSize];
    }
    _data = data;
    _contractName = data.iStockname;
    NSString *closePrice = [NDataUtil stringWith:data.closePrice];
    NSString *highPrice = [NDataUtil stringWith:data.highPrice];
    UIColor *highColor = [GColorUtil C2];
    if([highPrice floatValue]>[closePrice floatValue]){
        highColor = [GColorUtil C11];
    }else if ([highPrice floatValue]<[closePrice floatValue]){
        highColor = [GColorUtil C12];
    }
    NSString *lowPrice = [NDataUtil stringWith:data.lowPrice];
    UIColor *lowColor = [GColorUtil C2];
    if([lowPrice floatValue]>[closePrice floatValue]){
        lowColor = [GColorUtil C11];
    }else if ([lowPrice floatValue]<[closePrice floatValue]){
        lowColor = [GColorUtil C12];
    }
    NSDictionary *high = @{@"key":CFDLocalizedString(@"最高") ,@"value":highPrice,@"color":[GColorUtil C2]};
    NSDictionary *low = @{@"key":CFDLocalizedString(@"最低"),@"value":lowPrice,@"color":[GColorUtil C2]};
    NSDictionary *vol = @{@"key":@"24H",@"value":data.volume,@"color":[GColorUtil C2]};
    NSMutableDictionary *infoDict = [NSMutableDictionary dictionary];
    [infoDict setObject:high forKey:@"high"];
    [infoDict setObject:low forKey:@"low"];
    [infoDict setObject:vol forKey:@"vol"];
    [infoDict setObject:data.lastPrice forKey:@"lastPrice"];
    [infoDict setObject:data.raise forKey:@"updown"];
    [infoDict setObject:data.raisRate forKey:@"updownRate"];
    [_infoView configOfView:infoDict];
    [_headerView configData:@{@"title":data.iStockname,@"remark":data.tradestatusText}];
    
    if (_isLS) {
        NSDictionary *open = @{@"key":CFDLocalizedString(@"今开"),@"value":data.openPrice,@"color":[GColorUtil C3]};
        NSDictionary *close = @{@"key":CFDLocalizedString(@"昨收"),@"value":data.closePrice,@"color":[GColorUtil C3]};
        NSArray *tem = @[high,open,low,close];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setObject:tem forKey:@"data"];
        [dic setObject:_contractName forKey:@"name"];
        [dic setObject:data.lastPrice forKey:@"lastPrice"];
        [dic setObject:data.raise forKey:@"updown"];
        [dic setObject:data.raisRate forKey:@"updownRate"];
        [self.hsView configOfView:dic];
    }
}

- (void)disenableScroll:(BOOL)flag{
    _scrollView.scrollEnabled = !flag;
}

- (void)switchsScreenToH{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    _isLS = self.chartsView.isLS = YES;
    self.hsView.hidden = NO;
    [self.view bringSubviewToFront:self.hsView];
    [self.hsView addSubview:self.chartsView];
    [_chartsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.hsView.topHeight);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_HEIGHT-self.hsView.rightHeight-IPHONE_X_BOTTOM_HEIGHT);
        make.height.mas_equalTo(SCREEN_WIDTH-self.hsView.topHeight);
    }];
    [_chartsView hitSwitchH];
    [self.depthView willDisAppear];
    self.n_shouldEdgPanEnable=NO;
}

- (void)switchsScreenToV{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    _isLS = self.chartsView.isLS = NO;
    _hsView.hidden = YES;
    [self.scrollView addSubview:self.chartsView];
    [_chartsView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.infoView.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo(self.chartsView.vHeight);
    }];
    [_chartsView hitSwitchH];
    [self.depthView willAppear];
    self.n_shouldEdgPanEnable=YES;
}

- (void)changedSymbol:(NSString *)symbol{
    _symbol = symbol;
    [self updateBaseInfo:[CFDBaseInfoModel new]];
    NSDictionary *open = @{@"key":CFDLocalizedString(@"今开"),@"value":@"--",@"color":[GColorUtil C3]};
    NSDictionary *close = @{@"key":CFDLocalizedString(@"昨收"),@"value":@"--",@"color":[GColorUtil C3]};
    NSDictionary *high = @{@"key":CFDLocalizedString(@"最高"),@"value":@"--",@"color":[GColorUtil C3]};
    NSDictionary *low = @{@"key":CFDLocalizedString(@"最低"),@"value":@"--",@"color":[GColorUtil C3]};
    NSArray *tem = @[high,open,low,close];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setObject:tem forKey:@"data"];
    [dic setObject:_contractName forKey:@"name"];
    [dic setObject:@"--" forKey:@"lastPrice"];
    [dic setObject:@"--" forKey:@"updown"];
    [dic setObject:@"--" forKey:@"updownRate"];
    [self.hsView configOfView:dic];
    
    [_chartsView changedSymbol:symbol];
    [_depthView changedSymbol:symbol];
    [_tradeView changedSymbol:symbol];
    [_ruleView changedSymbol:symbol];
}

//MARK: - MarketVC

- (void)marketVCDisAppear{
    MarketVC *target = [self.childViewControllers lastObject];
    if ([target isKindOfClass:MarketVC.class]) {
        [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            target.tableView.transform = CGAffineTransformMakeTranslation(0, -target.tableView.height);
            target.view.alpha=0;
        } completion:^(BOOL finished) {
            [target.view removeFromSuperview];
            [target removeFromParentViewController];
        }];
        self.isUnFold=NO;
        [self.chartsView willAppear];
        [self.depthView willAppear];
        [self.headerView changedArrow:NO];
    }
}

- (void)marketVCAppear{
    WEAK_SELF;
    MarketVC *target = weakSelf.marketChildVC;
    [weakSelf.view addSubview:target.view];
    [target.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.headerView.mas_bottom);
        make.bottom.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
    }];
    [weakSelf.view layoutIfNeeded];
    target.tableView.transform = CGAffineTransformMakeTranslation(0, -target.tableView.height);
    target.view.alpha=0;
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        target.tableView.transform = CGAffineTransformIdentity;
        target.view.alpha=1;
    } completion:^(BOOL finished) {
    }];
    self.isUnFold=YES;
    [weakSelf.chartsView willDisappear];
    [weakSelf.depthView willDisAppear];
    [self.headerView changedArrow:YES];
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

- (ChartsHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[ChartsHeaderView alloc] init];
        WEAK_SELF;
        _headerView.tapHander = ^{
            if (weakSelf.isUnFold) {
                [weakSelf marketVCDisAppear];
            }else{
                [weakSelf marketVCAppear];
            }
        };
        _headerView.backHander = ^{
            if (weakSelf.isUnFold) {
                [weakSelf marketVCDisAppear];
            }else{
                [GJumpUtil popAnimated:YES];
            }
        };
    }
    return _headerView;
}

- (LockerView *)scrollView{
    if (!_scrollView) {
        CGFloat height = [ChartsInfoView heightOfView]+CHeight+[GUIUtil fit:5];
        NSDictionary *dic1 = @{@"title":CFDLocalizedString(@"委托"),@"view":self.depthView};
        NSDictionary *dic2 = @{@"title":CFDLocalizedString(@"成交_charts"),@"view":self.tradeView};
        NSDictionary *dic3 = @{@"title":CFDLocalizedString(@"规则"),@"view":self.ruleView};
        _scrollView = [[LockerView alloc] initWithTopHeight:ceil(height) lists:@[dic1,dic2,dic3]];
        _scrollView.frame = CGRectMake(0, [ChartsHeaderView heightOfView], SCREEN_WIDTH, SCREEN_HEIGHT-[ChartsHeaderView heightOfView]-[ChartsBottomView heightOfView]);
        [_scrollView setSectionBgColor:C6_ColorType sectionTextFont:[GUIUtil fitFont:14] sectionTextColor:C3_ColorType sectionSelTextColor:C13_ColorType hasLine:NO];
        _scrollView.bgColor = C8_ColorType;
        [_scrollView hScrollviewShouldScroll:NO];
        WEAK_SELF;
        _scrollView.selectedIndexHander = ^(NSInteger index) {
            if (index==0) {
                [weakSelf.depthView willAppear];
            }else if (index==1){
                [weakSelf.tradeView willAppear];
            }else if (index==2){
                [weakSelf.ruleView willAppear];
            }
        };
    }
    return _scrollView;
}


- (DepthView *)depthView{
    if (!_depthView) {
        _depthView = [[DepthView alloc] initWithSymbol:_symbol];
    }
    return _depthView;
}
- (TradeView *)tradeView{
    if (!_tradeView) {
        _tradeView = [[TradeView alloc] initWithSymbol:_symbol];
    }
    return _tradeView;
}
- (RuleView *)ruleView{
    if (!_ruleView) {
        _ruleView = [[RuleView alloc] initWithSymbol:_symbol isChild:YES];
    }
    return _ruleView;
}

- (ChartsInfoView *)infoView{
    if (!_infoView) {
        _infoView = [[ChartsInfoView alloc] init];
    }
    return _infoView;
}

- (CFDChartsView *)chartsView{
    if (!_chartsView) {
        CGFloat vHeight = CHeight;
        _chartsView = [[CFDChartsView alloc] initWithVHeight:vHeight symbol:_symbol];
        _chartsView.delegate = self;
        _chartsView.hasVol = NO;
    }
    return _chartsView;
}

- (BaseView *)colorView{
    if (!_colorView) {
        _colorView = [[BaseView alloc] init];
        _colorView.bgColor = C8_ColorType;
    }
    return _colorView;
}

- (ChartsBottomView *)bottomView{

    if(!_bottomView){
        _bottomView = [[ChartsBottomView alloc] init];
        WEAK_SELF;
        _bottomView.buyHander = ^{
            [weakSelf viewDidDisappear:NO];
            [CFDJumpUtil jumpToTradeVC:weakSelf.data.symbol];
        };
        _bottomView.sellHander = ^{
            [weakSelf viewDidDisappear:NO];
            [CFDJumpUtil jumpToTradeVC:weakSelf.data.symbol isBuy:NO];
        };
        _bottomView.alertHander = ^{
            if (![UserModel isLogin]) {
                [CFDJumpUtil jumpToLogin];
                return ;
            }
            NSDictionary *dic = @{@"symbol":weakSelf.data.symbol,@"stockname":weakSelf.data.iStockname
                                  ,@"iPreclose":weakSelf.data.closePrice,@"nowv":weakSelf.data.lastPrice,@"updown":weakSelf.data.raise,@"updownRate":weakSelf.data.raisRate
                                  ,@"dotnum":@(weakSelf.data.dotNum)};
            [HQAlertVC jumpTo:dic];
        };
    }
    return _bottomView;
}

- (CFDHSView *)hsView{
    if (!_hsView) {
        _hsView = [[CFDHSView alloc] initWithIsReal:_isReal];
        _hsView.frame=CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        _hsView.bgColor = C6_ColorType;
        CGAffineTransform at =CGAffineTransformMakeRotation(M_PI/2);
        [_hsView setTransform:at];
        _hsView.delegate = self;
        _hsView.left=0;
        _hsView.top=0;
        self.chartsView.hsTopHeight = _hsView.topHeight;
        self.chartsView.hsRight = _hsView.rightHeight;
        _hsView.hidden = YES;
        WEAK_SELF;
        _hsView.getChartsSelectedIndex = ^NSMutableDictionary *{
            if (weakSelf.chartsView.chartsType == EChartsType_RT) {
                NSMutableDictionary *dic = @{@"topIndex":@(weakSelf.chartsView.chartView.mLineView.indexTopType),@"bottomIndex":@(weakSelf.chartsView.chartView.mLineView.indexType)}.mutableCopy;
                return dic;
            }else{
                NSMutableDictionary *dic = @{@"topIndex":@(weakSelf.chartsView.chartView.kLineView.indexTopType),@"bottomIndex":@(weakSelf.chartsView.chartView.kLineView.indexType)}.mutableCopy;
                return dic;
            }
        };
        _hsView.selectedIndexHander = ^(NSMutableDictionary *dic) {
            
            if (weakSelf.chartsView.chartsType == EChartsType_RT) {
                if (dic) {
                    EIndexTopType topType = [dic[@"topIndex"] integerValue];
                    EIndexType type = [dic[@"bottomIndex"] integerValue];
                    [weakSelf.chartsView.chartView.mLineView changedTopIndex:topType];
                    [weakSelf.chartsView.chartView.mLineView changedIndex:type];
                }
            }else{
                if (dic) {
                    EIndexTopType topType = [dic[@"topIndex"] integerValue];
                    EIndexType type = [dic[@"bottomIndex"] integerValue];
                    [weakSelf.chartsView.chartView.kLineView changedTopIndex:topType];
                    [weakSelf.chartsView.chartView.kLineView changedIndex:type];
                }
            }
        };
    }
    return _hsView;
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


@end

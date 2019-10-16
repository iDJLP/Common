//
//  HomeVC.m
//  Chart
//
//  Created by ngw15 on 2019/3/4.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "HomeVC.h"
#import "LockerView.h"
#import "NewsTableView.h"
#import "SDCycleScrollView.h"
#import "ProfitBroadcastView.h"
#import "DCTradeVarityView.h"
#import "HelpBannerView.h"
#import "BaseView.h"
#import "BaseLabel.h"
#import "BaseImageView.h"
#import "BaseBtn.h"
#import "DisnetView.h"

@interface HomeVC ()<UIScrollViewDelegate,SDCycleScrollViewDelegate>

@property (nonatomic,strong)BaseView *navView;
@property (nonatomic,strong)BaseImageView *logoImg;
@property (nonatomic,strong)BaseLabel *titleLabel;
@property (nonatomic,strong)BaseBtn *rightBtn;

@property (nonatomic,strong)BaseScrollView *scrollView;
@property (nonatomic,strong)SDCycleScrollView *rollView;
@property (nonatomic,strong)ProfitBroadcastView *broadView;
@property (nonatomic,strong)DCTradeVarityView *varityView;
@property (nonatomic,strong)HelpBannerView *helpBannerView;
@property (nonatomic,strong)BaseImageView *adView;
@property (nonatomic,strong)NewsTableView *ftScrollView;
@property (nonatomic,strong)NewsTableView *bcScrollView;
@property (nonatomic,strong)NewsTableView *stScrollView;
@property (nonatomic,strong)DisnetBar *disnetBar;

@property (nonatomic,strong)NSArray *bannerList;
@property (nonatomic,strong)NSArray *helpBannerList;
@property (nonatomic,copy)NSString *winnerContent;
@property (nonatomic,strong)ThreadSafeArray *marketList;
@end

@implementation HomeVC

- (void)dealloc{
    [self removeNotic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUI];
    [self autoLayout];
    [self loadData];
    [self addNotic];
    WEAK_SELF;
    [GUIUtil refreshWithHeader:self.scrollView refresh:^{
        [weakSelf loadBanner];
        [weakSelf loadHelpBanner];
        if (weakSelf.winnerContent.length<=0) {
            [weakSelf loadWinnerList];
        }
        [weakSelf.varityView refreshData];
    }];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [_ftScrollView viewWillAppear];
    [_varityView willAppear];
    [self startTimer];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_varityView willDisAppear];
    [NTimeUtil stopTimer:@"HomeVC"];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setupUI{
    [self.view addSubview:self.navView];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.rollView];
    [self.scrollView addSubview:self.broadView];
    [self.scrollView addSubview:self.varityView];
    [self.scrollView addSubview:self.adView];
    [self.scrollView addSubview:self.helpBannerView];
}
- (void)autoLayout{
    [_broadView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rollView.mas_bottom).mas_offset([GUIUtil fit:5]);
        make.height.mas_equalTo([GUIUtil fit:45]);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
    }];
    [_varityView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.equalTo(self.broadView.mas_bottom);
        make.height.mas_equalTo([DCTradeVarityView heightOfView]);
    }];
    [_adView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.varityView.mas_bottom).mas_offset([GUIUtil fit:20]);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo([GUIUtil fit:343]);
        make.height.mas_equalTo([GUIUtil fit:60]);
    }];
    [_helpBannerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.adView.mas_bottom).mas_offset([GUIUtil fit:15]);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([HelpBannerView heightOfView:6]);
        make.bottom.mas_equalTo([GUIUtil fit:-35]);
    }];
}


- (void)loadData{
    [self loadBanner];
    [self loadHelpBanner];
    [self loadWinnerList];
}

- (void)loadBanner{
    WEAK_SELF;
    [DCService homeBannerData:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            NSArray *bannerList = [NDataUtil arrayWith:data[@"data"]];
            NSMutableArray *bannerImg = [NSMutableArray array];
            for (NSDictionary *dict in [NDataUtil arrayWith:bannerList]) {
                NSString *imgUrl = [NDataUtil stringWith:dict[@"url"]];
                [bannerImg addObject:imgUrl];
            }
            weakSelf.rollView.imageURLStringsGroup = bannerImg;
            weakSelf.bannerList = bannerList;
        }else{
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"message"] valid:[FTConfig webTips]]];
        }
        [weakSelf.scrollView.mj_header endRefreshing];
        [weakSelf updateScrollViewContentSize];
    } failure:^(NSError *error) {
        [HUDUtil showInfo:[FTConfig webTips]];
        [weakSelf.scrollView.mj_header endRefreshing];
        [weakSelf updateScrollViewContentSize];
    }];
}

- (void)loadHelpBanner{
    WEAK_SELF;
    [DCService homeHelpBannerData:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            weakSelf.helpBannerList = [NDataUtil arrayWith:data[@"data"]];
            if (weakSelf.helpBannerList.count/2!=weakSelf.helpBannerView.count/2) {
                [weakSelf.helpBannerView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo([HelpBannerView heightOfView:weakSelf.helpBannerList.count]);
                }];
//                CGFloat height = self.rollView.height+[GUIUtil fit:45]+[DCTradeVarityView heightOfView]+[GUIUtil fit:80]+[GUIUtil fit:15]+[HelpBannerView heightOfView:weakSelf.helpBannerList.count]+[GUIUtil fit:15];
//                [weakSelf.scrollView updateTopHeight:height];
            }
            [weakSelf.helpBannerView configOfView:weakSelf.helpBannerList];
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)loadWinnerList{
    WEAK_SELF;
    [DCService winnerlistsuccess:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            data = [NDataUtil dictWith:data[@"data"]];
            NSString *content = [NDataUtil stringWith:data[@"content"] valid:@""];
            if (![content isEqualToString:weakSelf.winnerContent]&&content.length>0) {
                [weakSelf.broadView reloadData:content comtext:weakSelf.winnerContent];
                weakSelf.winnerContent = content;
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)startTimer{
    WEAK_SELF;
    [NTimeUtil startTimer:@"HomeVC" interval:5 repeats:YES action:^{
        [weakSelf loadWinnerList];
    }];
}

- (void)rightAction{
    [CFDJumpUtil jumpToService];
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    NSDictionary *dic =[NDataUtil dataWithArray:_bannerList index:index];
    [CFDJumpUtil jumpToHomeFucs:dic];
//    [CFDJumpUtil jumpToWeb:[NDataUtil stringWith:dic[@"title"]] link:[NDataUtil stringWith:dic[@"openurl"]] animated:YES];
    
//    if (@available(iOS 10.0, *)) {
//        UIImpactFeedbackGenerator *impactLight = [[UIImpactFeedbackGenerator alloc]initWithStyle:UIImpactFeedbackStyleMedium];
//        [impactLight impactOccurred];
//    }
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
    [self loadBanner];
    [self loadHelpBanner];
    if (self.winnerContent.length<=0) {
        [self loadWinnerList];
    }
    [self.varityView refreshData];
}

//MARK: - Getter

- (BaseView *)navView{
    if (!_navView) {
        _navView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, TOP_BAR_HEIGHT)];
        _navView.bgColor = C6_ColorType;
        [_navView addSubview:self.logoImg];
        [_navView addSubview:self.rightBtn];
        WEAK_SELF;
        [_logoImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.equalTo(weakSelf.navView.mas_top).mas_offset(STATUS_BAR_HEIGHT+22);
        }];
        [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.logoImg);
            make.right.mas_equalTo([GUIUtil fit:-15]);
        }];
    }
    return _navView;
}

- (BaseImageView *)logoImg{
    if (!_logoImg) {
        _logoImg = [[BaseImageView alloc] init];
        _logoImg.imageName = @"home_logo";
    }
    return _logoImg;
}

- (BaseBtn *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[BaseBtn alloc] init];
        _rightBtn.imageName = @"mine_icon_customer";
        [_rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _rightBtn;
}

- (BaseScrollView *)scrollView{
    if (!_scrollView) {

        _scrollView = [[BaseScrollView alloc] init];
        _scrollView.frame = CGRectMake(0, TOP_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-TOP_BAR_HEIGHT-BOTTOM_BAR_HEIGHT);
        _scrollView.bgColor = C6_ColorType;
    }
    return _scrollView;
}

- (SDCycleScrollView *)rollView{
    if (!_rollView) {
        _rollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [GUIUtil fit:150]) delegate:self placeholderImage:nil];
        _rollView.autoScrollTimeInterval = 4.0f;
        _rollView.bgColor = C6_ColorType;
        _rollView.currentPageDotColor = [GColorUtil C5];
        _rollView.pageDotColor = [GColorUtil colorWithColorType:C5_ColorType alpha:0.5];
    }
    return _rollView;
}

- (ProfitBroadcastView *)broadView{
    if (!_broadView) {
        _broadView = [[ProfitBroadcastView alloc] init];
    }
    return _broadView;
}

- (DCTradeVarityView *)varityView{
    if (!_varityView) {
        _varityView = [[DCTradeVarityView alloc] initWithSelectedEnabled:NO];
        _varityView.selectedRow = ^(CFDBaseInfoModel *model) {
            [CFDJumpUtil jumpToCharts:model.symbol];
        };
    }
    return _varityView;
}

- (BaseImageView *)adView{
    if (!_adView) {
        _adView = [[BaseImageView alloc] init];
        if ([[FTConfig sharedInstance].lang isEqualToString:@"cn"]) {
            _adView.imageName =@"home_pic_golden";
        }else{
            _adView.imageName =@"home_pic_golden_en";
        }
        [_adView g_clickBlock:^(UITapGestureRecognizer *tap) {
            [CFDJumpUtil jumpToDeposit:@"USDT"];
        }];
    }
    return _adView;
}

- (HelpBannerView *)helpBannerView{
    if (!_helpBannerView) {
        _helpBannerView = [[HelpBannerView alloc] init];
        _helpBannerView.selectedRow = ^(NSDictionary * _Nonnull model) {
            [CFDJumpUtil jumpToHomeFucs:model];
        };
    }
    return _helpBannerView;
}

- (void)languageChangedAction{
    WEAK_SELF;
    if ([[FTConfig sharedInstance].lang isEqualToString:@"cn"]) {
        _adView.imageName =@"home_pic_golden";
    }else{
        _adView.imageName =@"home_pic_golden_en";
    }
    [GUIUtil refreshWithHeader:self.scrollView refresh:^{
        [weakSelf loadBanner];
        [weakSelf loadHelpBanner];
        if (weakSelf.winnerContent.length<=0) {
            [weakSelf loadWinnerList];
        }
        [weakSelf.varityView refreshData];
    }];
    [weakSelf loadBanner];
    [weakSelf loadHelpBanner];
    if (weakSelf.winnerContent.length<=0) {
        [weakSelf loadWinnerList];
    }
    [weakSelf.varityView refreshData];
}

- (void)themeChangedAction{
    WEAK_SELF;
    [GUIUtil refreshWithHeader:self.scrollView refresh:^{
        [weakSelf loadBanner];
        [weakSelf loadHelpBanner];
        if (weakSelf.winnerContent.length<=0) {
            [weakSelf loadWinnerList];
        }
        [weakSelf.varityView refreshData];
    }];
    [_rollView reloadData];
}

- (void)addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
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

@end

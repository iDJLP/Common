//
//  DrawlVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/27.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "DrawlVC.h"
#import "FundRecordVC.h"
#import "SectionView.h"
#import "OTCDrawlView.h"
#import "ChainDrawlView.h"

@interface DrawlVC ()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) SectionView *sectionView;

@property (nonatomic,strong) OTCDrawlView *otcView;
@property (nonatomic,strong) ChainDrawlView *chainView;

@property (nonatomic,strong) NSArray *datalist;
@property (nonatomic,assign) BOOL isLoaded;

@property (nonatomic,copy)NSString *type;
@property (nonatomic,assign) BOOL firstIsOtc;
@end

@implementation DrawlVC

+ (void)jumpTo:(NSString *)type{
    DrawlVC *target = [DrawlVC new];
    target.type = type;
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [_otcView willAppear];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.otcView hidenKeyboard];
    [self.chainView hidenKeyboard];
    [NTimeUtil stopTimer:@"DrawlVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CFDLocalizedString(@"出金");
    _firstIsOtc = YES;
    WEAK_SELF;
    [GNavUtil rightTitle:self title:CFDLocalizedString(@"资金记录") color:C2_ColorType onClick:^{
        if (weakSelf.firstIsOtc) {
            if (weakSelf.sectionView.selectedIndex==0) {
                [FundRecordVC jumpTo:2];
            }else{
                [FundRecordVC jumpTo:3];
            }
        }else{
            if (weakSelf.sectionView.selectedIndex==0) {
                [FundRecordVC jumpTo:3];
            }else{
                [FundRecordVC jumpTo:2];
            }
        }
    }];
    [self setupUI];
    [self autoLayout];
    ProgressStateView *stateView = (ProgressStateView *)[StateUtil show:self.view type:StateTypeProgress];
    stateView.backgroundColor = [GColorUtil C8];
    [GUIUtil refreshWithHeader:_otcView refresh:^{
        [weakSelf loadData];
        [weakSelf.otcView refreshData];
    }];
    [GUIUtil refreshWithHeader:_chainView refresh:^{
        [weakSelf loadData];
        [weakSelf.chainView refreshData];
    }];
    // Do any additional setup after loading the view.
}

- (void)setupUI{
    self.view.backgroundColor = [GColorUtil C6];
    [self.view addSubview:self.otcView];
    [self.view addSubview:self.chainView];
    [self.view addSubview:self.sectionView];
}

- (void)autoLayout{
    
    [_sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fit:40]);
    }];
    [_otcView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo([GUIUtil  fit:45]);
    }];
    [_chainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.mas_equalTo([GUIUtil  fit:45]);
    }];
}

- (void)loadData{
    WEAK_SELF;
    [DCService getDrawlData:^(id data) {
        [weakSelf.otcView.mj_header endRefreshing];
        [weakSelf.chainView.mj_header endRefreshing];
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            
            weakSelf.datalist = [NDataUtil arrayWith:data[@"data"]];
            [weakSelf configVC];
            weakSelf.isLoaded = YES;
            [StateUtil hide:weakSelf.view];
        }else {
            if(weakSelf.isLoaded==NO){
                NoDataStateView *stateView = (NoDataStateView *)[StateUtil show:weakSelf.view type:StateTypeNodata];
                stateView.backgroundColor = [GColorUtil C6];
            }else{
                [StateUtil hide:weakSelf.view];
            }
            [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
        }
    } failure:^(NSError *error) {
        [weakSelf.chainView.mj_header endRefreshing];
        [HUDUtil showInfo:[FTConfig webTips]];
        if(weakSelf.isLoaded==NO){
            ReloadStateView *reloadView = (ReloadStateView *)[StateUtil show:weakSelf.view type:StateTypeReload];
            [reloadView setOnReload:^{
                [StateUtil hide:weakSelf.view];
                [weakSelf loadData];
            }];
        }else{
            [StateUtil hide:weakSelf.view];
        }
    }];
}

- (void)configVC{
    NSDictionary *dic1 = [NDataUtil dictWithArray:self.datalist index:0];
    NSDictionary *dic2 = [NDataUtil dictWithArray:self.datalist index:1];
    
    if (self.datalist.count==1) {
        [self.sectionView updateTitleList:@[[NDataUtil stringWith:dic1[@"name"]]]];
        BOOL isdefault = [[NDataUtil stringWith:dic1[@"ischeck"]] isEqualToString:@"1"];
        BOOL isOtc = [[NDataUtil stringWith:dic1[@"id"]] isEqualToString:@"1"];
        if (isOtc) {
            [self.otcView configVC:dic1];
            _firstIsOtc = YES;
        }else{
            [self.chainView configVC:dic1];
            _firstIsOtc = NO;
        }
        if (isdefault&&_isLoaded==NO) {
            [_sectionView changeSelectedIndex:0];
        }
    }else{
        
        [self.sectionView updateTitleList:@[[NDataUtil stringWith:dic1[@"name"]],[NDataUtil stringWith:dic2[@"name"]]]];
        BOOL isdefault = [[NDataUtil stringWith:dic1[@"ischeck"]] isEqualToString:@"1"];
        BOOL isOtc = [[NDataUtil stringWith:dic1[@"id"]] isEqualToString:@"1"];
        if (isOtc) {
            [self.otcView configVC:dic1];
            [self.chainView configVC:dic2];
            _firstIsOtc = YES;
        }else{
            [self.otcView configVC:dic2];
            [self.chainView configVC:dic1];
            _firstIsOtc = NO;
        }
        if (_isLoaded==NO) {
            [_sectionView changeSelectedIndex:isdefault?0:1];
        }
    }
}

//MARK: - Getter

- (void)changedSelectedIndex:(NSInteger)index{
    
    BOOL flag = _firstIsOtc&&index==0;
    _otcView.hidden=  !flag;
    _chainView.hidden = flag;
    if (flag) {
        [_otcView willAppear];
    }else{
        [_chainView willAppear];
    }
}

- (SectionView *)sectionView{
    if (!_sectionView) {
        NSArray *title = @[@" ",@" "];
        _sectionView = [[SectionView alloc] initWithList:title sectionType:SectionTypeDivideWidth];
        _sectionView.backgroundColor = [GColorUtil C6];
        WEAK_SELF;
        _sectionView.changedSelectedIndex = ^(NSInteger index) {
            [weakSelf changedSelectedIndex:index];
        };
    }
    return _sectionView;
}

- (OTCDrawlView *)otcView{
    if (!_otcView) {
        OTCDrawlView *otcView = [[OTCDrawlView alloc] init];
        otcView.showsVerticalScrollIndicator = NO;
        otcView.bounces = YES;
        otcView.alwaysBounceVertical = YES;
        otcView.alwaysBounceHorizontal = NO;
        otcView.userInteractionEnabled = YES;
        otcView.backgroundColor = [GColorUtil C6];
        otcView.type = _type;
        if (@available(iOS 11.0, *)) {
            otcView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _otcView = otcView;
    }
    return _otcView;
}

- (ChainDrawlView *)chainView{
    if (!_chainView) {
        _chainView = [[ChainDrawlView alloc] init];
        _chainView.showsVerticalScrollIndicator = NO;
        _chainView.bounces = YES;
        _chainView.alwaysBounceVertical = YES;
        _chainView.alwaysBounceHorizontal = NO;
        _chainView.userInteractionEnabled = YES;
        _chainView.backgroundColor =[GColorUtil C6];
        _chainView.hidden = YES;
        _chainView.type = _type;
        if (@available(iOS 11.0, *)) {
            _chainView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
    }
    return _chainView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end

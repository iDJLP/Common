//
//  DCChargedVC.m
//  coinare_ftox
//
//  Created by ngw15 on 2018/8/16.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "DepositVC.h"
#import "OTCDepositView.h"
#import "ChainDepositView.h"
#import "SectionView.h"
#import "FundRecordVC.h"

@interface DepositVC ()<UIGestureRecognizerDelegate,UITextFieldDelegate>

@property (nonatomic,strong) SectionView *sectionView;

@property (nonatomic,strong) OTCDepositView *otcView;
@property (nonatomic,strong) ChainDepositView *chainView;

@property (nonatomic,strong) NSArray *datalist;
@property (nonatomic,assign) BOOL isLoaded;

@property (nonatomic,assign) BOOL firstIsOtc;
@property (nonatomic,copy)NSString *type;
@end

@implementation DepositVC

+ (void)jumpTo:(NSString *)type{
    DepositVC *target = [DepositVC new];
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
    [NTimeUtil stopTimer:@"DepositVC"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = CFDLocalizedString(@"入金");
    WEAK_SELF;
    [GNavUtil rightTitle:self title:CFDLocalizedString(@"资金记录") color:C2_ColorType onClick:^{
        if (weakSelf.firstIsOtc) {
            if (weakSelf.sectionView.selectedIndex==0) {
                [FundRecordVC jumpTo:0];
            }else{
                [FundRecordVC jumpTo:1];
            }
        }else{
            if (weakSelf.sectionView.selectedIndex==0) {
                [FundRecordVC jumpTo:1];
            }else{
                [FundRecordVC jumpTo:0];
            }
        }

    }];
    [self setupUI];
    [self autoLayout];
    ProgressStateView *stateView = (ProgressStateView *)[StateUtil show:self.view type:StateTypeProgress];
    stateView.backgroundColor = [GColorUtil C8];
    [GUIUtil refreshWithHeader:_otcView refresh:^{
        [weakSelf loadData];
        [weakSelf.otcView loadTradeOrder];
        [weakSelf.otcView loadData];
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
    [DCService getpaymentmethod:^(id data) {
        [weakSelf.otcView.mj_header endRefreshing];
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            
            weakSelf.otcView.isLoaded = YES;
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
        [weakSelf.otcView.mj_header endRefreshing];
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
        BOOL isdefault = [[NDataUtil stringWith:dic1[@"isdefault"]] isEqualToString:@"1"];
        BOOL isOtc = [[NDataUtil stringWith:dic1[@"channeltype"]] isEqualToString:@"1"];
        if (isOtc) {
            [self.otcView configVC:dic1];
            _firstIsOtc = YES;
        }else{
            self.chainView.payId = [NDataUtil stringWith:dic1[@"payid"]];
        }
        if (isdefault&&_isLoaded==NO) {
            [_sectionView changeSelectedIndex:0];
        }
    }else{
        
        [self.sectionView updateTitleList:@[[NDataUtil stringWith:dic1[@"name"]],[NDataUtil stringWith:dic2[@"name"]]]];
        
        BOOL isdefault = [[NDataUtil stringWith:dic1[@"isdefault"]] isEqualToString:@"1"];
        BOOL isOtc = [[NDataUtil stringWith:dic1[@"channeltype"]] isEqualToString:@"1"];
        if (isOtc) {
            [self.otcView configVC:dic1];
            self.chainView.payId = [NDataUtil stringWith:dic2[@"payid"]];
            _firstIsOtc = YES;
        }else{
            [self.otcView configVC:dic2];
            self.chainView.payId = [NDataUtil stringWith:dic1[@"payid"]];
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
        if (_otcView.isLoaded==NO) {
            [self loadData];
        }
    }else{
        if (_chainView.isLoaded==NO) {
            [_chainView loadData];
            [_chainView loadTradeOrder];
        }
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

- (OTCDepositView *)otcView{
    if (!_otcView) {
        OTCDepositView *scrollView = [[OTCDepositView alloc] init];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.bounces = YES;
        scrollView.alwaysBounceVertical = YES;
        scrollView.alwaysBounceHorizontal = NO;
        scrollView.userInteractionEnabled = YES;
        scrollView.backgroundColor = [GColorUtil C6];
        scrollView.type = _type;
        if (@available(iOS 11.0, *)) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        _otcView = scrollView;
    }
    return _otcView;
}

- (ChainDepositView *)chainView{
    if (!_chainView) {
        _chainView = [[ChainDepositView alloc] init];
        _chainView.showsVerticalScrollIndicator = NO;
        _chainView.bounces = YES;
        _chainView.type = _type;
        _chainView.alwaysBounceVertical = YES;
        _chainView.alwaysBounceHorizontal = NO;
        _chainView.userInteractionEnabled = YES;
        _chainView.backgroundColor =[GColorUtil C6];
        _chainView.hidden = YES;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

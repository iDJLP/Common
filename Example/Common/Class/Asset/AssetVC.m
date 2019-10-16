//
//  AssetVC.m
//  Bitmixs
//
//  Created by ngw15 on 2019/6/4.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "AssetVC.h"
#import "AssetDetailVC.h"
#import "AssetActionView.h"
#import "BaseTableView.h"
#import "AssetVarityCell.h"
#import "DisnetView.h"
#import "PositionAnalyseVC.h"
#import "TradeAnalyseVC.h"
#import "BaseBtn.h"

@interface AssetVC ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) BaseTableView *tableView;
@property (nonatomic,strong)BaseView *headerView;
@property (nonatomic,strong)BaseImageView *bgImgView;
@property (nonatomic,strong)BaseBtn *eyeBtn;
@property (nonatomic,strong)BaseLabel *accountText;
@property (nonatomic,strong)BaseLabel *accountTitle;
@property (nonatomic,strong)BaseLabel *profitText;
@property (nonatomic,strong)BaseLabel *profitTitle;
@property (nonatomic,strong)BaseLabel *marginText;
@property (nonatomic,strong)BaseLabel *marginTitle;
@property (nonatomic,strong)AssetActionView *controlView;
@property (nonatomic,strong)BaseView *separateView;

@property (nonatomic,strong)DisnetBar *disnetBar;

@property(nonatomic,assign) BOOL openEye;
@property(nonatomic,strong) NSDictionary *config;
@property(nonatomic,strong) NSArray *dataArray;
@property(nonatomic,strong) NSArray *dataArrayClose;

@end

@implementation AssetVC

+ (void)jumpTo{
    
    AssetVC *target = [AssetVC new];
    target.hidesBottomBarWhenPushed = YES;
    [GJumpUtil pushVC:target animated:YES];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = CFDLocalizedString(@"资产");
    WEAK_SELF;
    _openEye = [NLocalUtil boolForKey:@"openEye_assets"];
    
    [self setVCRighticon];
    [self setupUI];
    [self autoLayout];
    [self addNotic];
    [self loadUserAccount:NO];
    [GUIUtil refreshWithHeader:_tableView refresh:^{
        [weakSelf loadUserAccount:NO];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self startTimer];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [NTimeUtil stopTimer:@"AssetVC"];
}

- (void)setupUI{
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.bgImgView];
    [self.tableView addSubview:self.controlView];
    [self.tableView addSubview:self.separateView];

    [_bgImgView addSubview:self.accountText];
    [_bgImgView addSubview:self.accountTitle];
    [_bgImgView addSubview:self.eyeBtn];
    [_bgImgView addSubview:self.profitText];
    [_bgImgView addSubview:self.profitTitle];
    [_bgImgView addSubview:self.marginText];
    [_bgImgView addSubview:self.marginTitle];
    

}

- (void)autoLayout{
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:10]);
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.width.mas_equalTo([GUIUtil fit:345]);
        make.height.mas_equalTo([GUIUtil fit:140]);
    }];
    [_controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgImgView.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([AssetActionView heightOfView]);
    }];
    [_separateView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.height.mas_equalTo([GUIUtil fit:7]);
        make.top.equalTo(self.controlView.mas_bottom).mas_offset([GUIUtil fit:0]);
    }];
    {
        [self.accountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
           make.top.equalTo(self.bgImgView).mas_offset([GUIUtil fit:17]);
            make.left.equalTo(self.accountText);
        }];
        [self.accountText mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.accountTitle.mas_bottom).mas_offset([GUIUtil fit:5]);
            make.left.mas_equalTo([GUIUtil fit:15]);
        }];
        [_eyeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.accountTitle);
            make.left.equalTo(self.accountTitle.mas_right).mas_offset([GUIUtil fit:5]);
        }];
        [self updateLanguage];
    }
}

- (void)updateLanguage{
    if ([[FTConfig sharedInstance].lang isEqualToString:@"en"]) {
        [_profitTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.top.equalTo(self.accountText.mas_bottom).mas_offset([GUIUtil fit:22]);
        }];
        [_profitText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.profitTitle.mas_right).mas_offset([GUIUtil fit:8]);
            make.centerY.equalTo(self.profitTitle);
        }];
        [_marginTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.top.equalTo(self.profitTitle.mas_bottom).mas_offset([GUIUtil fit:14]);
        }];
        [_marginText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.marginTitle.mas_right).mas_offset([GUIUtil fit:8]);
            make.centerY.equalTo(self.marginTitle);
        }];
    }else{
        [self.profitText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.accountText.mas_bottom).mas_offset([GUIUtil fit:25]);
            make.left.mas_equalTo([GUIUtil fit:15]);
        }];
        [self.profitTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.profitText.mas_bottom).mas_offset([GUIUtil fit:5]);
            make.left.mas_equalTo([GUIUtil fit:15]);
        }];
        [self.marginText mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.profitText);
            make.left.mas_equalTo([GUIUtil fit:182]);
        }];
        [self.marginTitle mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.profitTitle);
            make.left.equalTo(self.marginText);
        }];
    }
    [self.view layoutIfNeeded];
}

//MARK: - Load

- (void)loadUserAccount:(BOOL)isAuto{
    if (![UserModel isLogin]) {
        [self.tableView.mj_header endRefreshing];
        return;
    }
    WEAK_SELF;
    [DCService postgetUserAccount:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            [weakSelf updateView:data[@"data"]];
            if (isAuto==NO) {
                [weakSelf.tableView.mj_header endRefreshing];
            }
        }else{
            if (isAuto==NO) {
                [weakSelf.tableView.mj_header endRefreshing];
                [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
            }
        }
    } failure:^(NSError *error) {
        if (isAuto==NO) {
            [weakSelf.tableView.mj_header endRefreshing];
            [FTConfig webTips];
        }
    }];
}

- (void)startTimer{
    WEAK_SELF;
    [NTimeUtil startTimer:@"AssetVC" interval:5 repeats:YES action:^{
        [weakSelf loadUserAccount:YES];
    }];
}

- (void)updateView:(NSDictionary *)dic{
    _config = dic;
    _dataArray = [NDataUtil arrayWith:dic[@"accounts"]];
    NSMutableArray *tem = [NSMutableArray array];
    for (NSInteger i=0 ; i<_dataArray.count; i++) {
        NSDictionary *d = _dataArray[i];
        NSMutableDictionary *dict = d.mutableCopy;
        [dict setObject:@"*****" forKey:@"totalEquity"];
        [dict setObject:@"*****" forKey:@"totalEquityCNY"];
        [dict setObject:@"*****" forKey:@"profit"];
        [dict setObject:@"*****" forKey:@"profitCNY"];
        [dict setObject:@"*****" forKey:@"canUseMoney"];
        [dict setObject:@"*****" forKey:@"canUseMoneyCNY"];
        [tem addObject:dict];
    }
    _dataArrayClose = tem.copy;
    [self eyeChangedAction];
}

- (void)positionAction{
    [PositionAnalyseVC jumpTo];
}

- (void)eyeAction{
    _openEye = !_openEye;
    _eyeBtn.selected = _openEye;
    [self eyeChangedAction];
//    [self testcurrencylist:^(id data) {
//
//    } failure:^(NSError *error) {
//
//    }];
}

- (void)eyeChangedAction{

    [NLocalUtil setBool:_openEye forKey:@"openEye_assets"];
    if (_openEye==NO) {
        _accountText.text =@"*****";
        _marginText.text =@"*****";
        _profitText.text =@"*****";
        _profitText.textColor = [GColorUtil colorWithWhiteColorType:C5_ColorType];
    }else{
        _accountText.text =[NDataUtil stringWith:_config[@"totalEquityCNY"] valid:@"--"];
        _marginText.text =[NDataUtil stringWith:_config[@"totalMarginCNY"] valid:@"--"];
        _profitText.text =[NDataUtil stringWith:_config[@"totalProfitCNY"] valid:@"--"];
        if ([_profitText.text floatValue]>0) {
            _profitText.textColor = [GColorUtil C11];
        }else if ([_profitText.text floatValue]<0){
            _profitText.textColor = [GColorUtil C12];
        }else{
            _profitText.textColor = [GColorUtil colorWithWhiteColorType:C5_ColorType];
        }
    }
    [_tableView reloadData];
}

- (void)languageChangedAction{
    self.title = CFDLocalizedString(@"资产");
    [self loadUserAccount:NO];
    [self updateLanguage];
    WEAK_SELF;
    [GUIUtil refreshWithHeader:self.tableView refresh:^{
        [weakSelf loadUserAccount:NO];
    }];
}

- (void)themeChangedAction{
    WEAK_SELF;
    [GUIUtil refreshWithHeader:self.tableView refresh:^{
        [weakSelf loadUserAccount:NO];
    }];
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


//MARK: - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AssetVarityCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AssetVarityCell"];
    NSDictionary *dic = _openEye?[NDataUtil dataWithArray:_dataArray index:indexPath.row]:[NDataUtil dataWithArray:_dataArrayClose index:indexPath.row];
    [cell configOfView:dic];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return  [AssetVarityCell heightOfCell];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSDictionary *dic = [NDataUtil dataWithArray:_dataArray index:indexPath.row];
    [AssetDetailVC jumpTo:[NDataUtil stringWith:dic[@"currencyType"]]];
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
        make.top.mas_equalTo(0);
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
    [self.tableView.mj_header beginRefreshing];
}


//MARK: - Getter

- (void)setVCRighticon{

    UIBarButtonItem *item = nil;
    UIBarButtonItem *item1 = nil;
    {
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18+14, 44)];
        BaseImageView *righticon=[[BaseImageView alloc] initWithFrame:CGRectMake(7,(44-20)/2,18,20)];
        righticon.imageName = @"trade_topicon_statistical_dack";
        [customView addSubview:righticon];
        WEAK_SELF;
        [customView g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf positionAction];
        }];
        item = [[UIBarButtonItem alloc] initWithCustomView:customView];
    }
    {
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 18+14, 44)];
        BaseImageView *righticon=[[BaseImageView alloc] initWithFrame:CGRectMake(7,(44-20)/2,18,20)];
        righticon.imageName = @"assets_topicon_trade_dack";
        [customView addSubview:righticon];

        [customView g_clickBlock:^(UITapGestureRecognizer *tap) {
            [TradeAnalyseVC jumpTo];

        }];
        item1 = [[UIBarButtonItem alloc] initWithCustomView:customView];
    }
    self.navigationItem.rightBarButtonItems=@[item,item1];
}

- (BaseTableView *)tableView
{
    if(!_tableView)
    {
        _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-BOTTOM_BAR_HEIGHT) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.bgColor = C6_ColorType;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableHeaderView = self.headerView;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[AssetVarityCell class] forCellReuseIdentifier:@"AssetVarityCell"];
    }
    return _tableView;
}

- (BaseView *)headerView{
    if (!_headerView) {
        _headerView = [[BaseView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, [GUIUtil fit:160]+[AssetActionView heightOfView])];
        _headerView.bgColor = C6_ColorType;
    }
    return _headerView;
}

- (BaseImageView *)bgImgView
{
    if(!_bgImgView)
    {
        _bgImgView = [BaseImageView new];
        _bgImgView.imageName = @"assets_bg";
        _bgImgView.userInteractionEnabled = YES;
        [_bgImgView g_clickBlock:^(UITapGestureRecognizer *tap) {
            if ([UserModel isLogin]==NO) {
                [CFDJumpUtil jumpToLogin];
            }
        }];
    }
    return _bgImgView;
}

- (BaseBtn *)eyeBtn{
    if (!_eyeBtn) {
        _eyeBtn = [[BaseBtn alloc] init];
        [_eyeBtn setImage:[UIImage imageNamed:@"assets_icon_eye_close"] forState:UIControlStateNormal];
        [_eyeBtn setImage:[UIImage imageNamed:@"assets_icon_eye"] forState:UIControlStateSelected];
        _eyeBtn.selected = self.openEye;
        [_eyeBtn addTarget:self action:@selector(eyeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _eyeBtn;
}

- (BaseLabel *)accountText
{
    if(!_accountText)
    {
        _accountText = [BaseLabel new];
        _accountText.font = [GUIUtil fitBoldFont:20];
        _accountText.textColor = [GColorUtil colorWithWhiteColorType:C5_ColorType];
        _accountText.text = @"--";
    }
    return _accountText;
}

- (BaseLabel *)accountTitle
{
    if(!_accountTitle)
    {
        _accountTitle = [BaseLabel new];
        _accountTitle.font = [GUIUtil fitFont:12];
        _accountTitle.textColor = [GColorUtil colorWithColorType:C5_ColorType alpha:0.7];
        _accountTitle.textBlock = CFDLocalizedStringBlock(@"总权益估值(人民币)");
    }
    return _accountTitle;
}

- (BaseLabel *)profitText
{
    if(!_profitText)
    {
        _profitText = [BaseLabel new];
        _profitText.font = [GUIUtil fitBoldFont:14];
        _profitText.textColor = [GColorUtil colorWithWhiteColorType:C5_ColorType];
        _profitText.text = @"--";
    }
    return _profitText;
}

- (BaseLabel *)profitTitle
{
    if(!_profitTitle)
    {
        _profitTitle = [BaseLabel new];
        _profitTitle.font = [GUIUtil fitFont:12];
        _profitTitle.textColor = [GColorUtil colorWithColorType:C5_ColorType alpha:0.7];
        _profitTitle.textBlock = CFDLocalizedStringBlock(@"浮动盈亏估值(人民币)");
    }
    return _profitTitle;
}

- (BaseLabel *)marginText
{
    if(!_marginText)
    {
        _marginText = [BaseLabel new];
        _marginText.font = [GUIUtil fitBoldFont:14];
        _marginText.textColor = [GColorUtil colorWithWhiteColorType:C5_ColorType];
        _marginText.text = @"--";
    }
    return _marginText;
}

- (BaseLabel *)marginTitle
{
    if(!_marginTitle)
    {
        _marginTitle = [BaseLabel new];
        _marginTitle.font = [GUIUtil fitFont:12];
        _marginTitle.textColor = [GColorUtil colorWithColorType:C5_ColorType alpha:0.7];
        _marginTitle.textBlock = CFDLocalizedStringBlock(@"占用保证金估值(人民币)");
    }
    return _marginTitle;
}

- (AssetActionView *)controlView{
    if (!_controlView) {
        _controlView = [[AssetActionView alloc] init];
        _controlView.bgColor = C6_ColorType;
        _controlView.type = @"USDT";
    }
    return _controlView;
}


- (BaseView *)separateView{
    if (!_separateView) {
        _separateView = [[BaseView alloc] init];
        _separateView.bgColor = C8_ColorType;
    }
    return _separateView;
}

/***test*/
- (void)testcurrencylist:(void (^)(id))success failure:(void (^)(NSError *))failure{
//
//    http://203.107.1.1/147592/d?host=shq.niuguwang.com
    
//    101.251.227.15   shq.niuguwang.com
    
    //原始URL
    NSURL *originalUrl =[NSURL URLWithString:@"https://shq.niuguwang.com/aquote/quotedata/quotehomenew.ashx"];
    NSString *url = [NSString stringWithFormat:@"https://101.251.249.51/aquote/quotedata/quotehomenew.ashx"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    //将request的host字段改为原始URL的域名
    [request setValue:originalUrl.host forHTTPHeaderField:@"host"];
    
    
    //默认配置
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    //会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];

    // 请求方式
    [request setHTTPMethod:@"GET"];
    // 设置超时
    [request setTimeoutInterval:15];
    // 设置缓冲策略
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    // 使用压缩数据返回
    [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
    
    
    NSURLSessionDataTask *task=[session dataTaskWithRequest:request
                    completionHandler:^(NSData *data,
                                        NSURLResponse* response,
                                        NSError *error)
          {
              dispatch_async(dispatch_get_main_queue(), ^{
                  [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
              });
              dispatch_queue_t currentQueue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
              dispatch_async(currentQueue, ^{
                  if(error!=nil){
                      
                      if(failure!=nil){
                          dispatch_async(dispatch_get_main_queue(),^{
                              failure(error);
                          });
                      }
                      
                      return;
                  }
                  if(data!=nil){
                      if (data.length==0) {
                          if(success!=nil){
                              dispatch_async(dispatch_get_main_queue(),^{
                                  success(nil);
                              });
                          }
                          return;
                      }
                      id obj=[[FOWebService sharedInstance]toJson:@"" data:data];
                      if(obj==nil ||[obj isKindOfClass:[NSError class]]){
                          if(failure!=nil){
                              dispatch_async(dispatch_get_main_queue(),^{
                                  failure(obj);
                              });
                          }
                      }else{
                          
                          if(success!=nil){
                              dispatch_async(dispatch_get_main_queue(),^{
                                  success(obj);
                              });
                          }
                      }
                  }else{
                      
                  }
              });
          }];
    [task resume];
}

- (BOOL)evaluateServerTrust:(SecTrustRef)serverTrust
                  forDomain:(NSString *)domain
{
    /*
     * 创建证书校验策略
     */
    NSMutableArray *policies = [NSMutableArray array];
    if (domain) {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateSSL(true, (__bridge CFStringRef)domain)];
    } else {
        [policies addObject:(__bridge_transfer id)SecPolicyCreateBasicX509()];
    }
    /*
     * 绑定校验策略到服务端的证书上
     */
    SecTrustSetPolicies(serverTrust, (__bridge CFArrayRef)policies);
    /*
     * 评估当前serverTrust是否可信任，
     * 官方建议在result = kSecTrustResultUnspecified 或 kSecTrustResultProceed
     * 的情况下serverTrust可以被验证通过，https://developer.apple.com/library/ios/technotes/tn2232/_index.html
     * 关于SecTrustResultType的详细信息请参考SecTrust.h
     */
    SecTrustResultType result;
    SecTrustEvaluate(serverTrust, &result);
    return (result == kSecTrustResultUnspecified || result == kSecTrustResultProceed);
}
/*
 * NSURLSession
 */
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential * __nullable credential))completionHandler
{
    if (!challenge) {
        return;
    }
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = nil;
    /*
     * 获取原始域名信息。
     */
    NSString* host = @"shq.niuguwang.com";
   
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if ([self evaluateServerTrust:challenge.protectionSpace.serverTrust forDomain:host]) {
            disposition = NSURLSessionAuthChallengeUseCredential;
            credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
        } else {
            disposition = NSURLSessionAuthChallengePerformDefaultHandling;
        }
    } else {
        disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    }
    // 对于其他的challenges直接使用默认的验证方案
    completionHandler(disposition,credential);
}


@end

//
//  CFDChartsView.m
//  globalwin
//
//  Created by ngw15 on 2018/8/1.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//  绘图视图（带数据请求）

#import "CFDChartsView.h"
#import "DemoChartsModel.h"
#import "WebSocketManager.h"

@interface CFDChartsView ()


@property (nonatomic,strong)BKCancellationToken delay;
@property (nonatomic,strong)NSMutableDictionary *config;
@property (nonatomic,copy) NSString *symbol;
@property (nonatomic, assign)EChartsLineType lineType;
@property (nonatomic, strong) DemoChartsModel *chartsModel;
@property (nonatomic, strong) WebSocketManager *webSocket;
@property (nonatomic, strong) BKCancellationToken delayKlineHander;
@property (nonatomic, strong) BKCancellationToken delayKAddlineHander;
@property (nonatomic,strong) dispatch_semaphore_t lock;
@property (nonatomic,strong)NSOperationQueue *queue;
@property (nonatomic, assign) BOOL isTimer;
@property (nonatomic,assign) BOOL hasLoaded;
@end

@implementation CFDChartsView

- (instancetype)initWithVHeight:(CGFloat)vHeight symbol:(NSString *)symbol{
    if (self = [super init]) {
        _vHeight = vHeight;
        _symbol = symbol;
        _lineType = EChartsLineTypeTradePrice;
        _lock=dispatch_semaphore_create(1);
        self.chartsModel= [[DemoChartsModel alloc] init] ;
        WEAK_SELF;
        _chartsModel.isDataAvailable = ^BOOL(NSString * _Nonnull symbol, EChartsType chartsType, EChartsLineType lineType) {
            if (![symbol isEqualToString:weakSelf.symbol]&&symbol.length>0) {
                return NO;
            }
            if (chartsType!=weakSelf.chartsType) {
                return NO;
            }
            if (lineType!=weakSelf.lineType) {
                return NO;
            }
            return YES;
        };
        _config = [NSMutableDictionary dictionary];
        [self addSubview:self.chartView];
    }
    return self;
}

- (void)willAppear{
    _isTimer = YES;
    [self startKlineTimer];
    [self websocketLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(netStateChange:) name:kNetStateChangedNoti object:nil];
}

- (void)willDisappear{
    [self stopTimer];
    [_webSocket disconnect];
    _webSocket=nil;
    [self.queue cancelAllOperations];
    [NTimeUtil cancelDelay:_delayKAddlineHander];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

//MARK: - LoadData

- (void)websocketLoad{
    if (_webSocket) {
        [_webSocket reconnect];
        return;
    }
    _queue = [[NSOperationQueue alloc] init];
    _webSocket = [[WebSocketManager alloc] init];
    _webSocket.target = self;
    [_webSocket singleContractData:_symbol];
    WEAK_SELF;
    [_webSocket setReciveMessage:^(NSArray *array) {
        NSLog(@"CFDChartsView的websocket收到数据");
        if (weakSelf.hasLoaded==NO) {
            return ;
        }
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:weakSelf selector:@selector(parseSocketData:) object:array];
        weakSelf.queue.maxConcurrentOperationCount = 1;
        [weakSelf.queue addOperation:operation];
    }];
}

- (void)parseSocketData:(NSArray *)array{
    WEAK_SELF;
    for (NSDictionary *dic in array) {
        if ([NDataUtil boolWithDic:dic key:@"S" isEqual:weakSelf.symbol]) {
            
            CFDBaseInfoModel *infoModel = [weakSelf.chartsModel.baseInfoData updateSocketDic:dic];
            weakSelf.chartsModel.baseInfoData = infoModel;
            
            if (weakSelf.chartsType==EChartsType_RT) {
                BOOL hasNewPoint = [weakSelf.chartsModel updateMlineDataWithSocketDic:dic lineType:weakSelf.lineType];
                [weakSelf updateBaseInfo];
                [weakSelf reloadSocketMlineCharts:hasNewPoint];
                
            }else{
                BOOL hasNewPoint = [weakSelf.chartsModel updateKlineDataWithSocketDic:dic chartsType:weakSelf.chartsType lineType:weakSelf.lineType];
                [weakSelf updateBaseInfo];
                [weakSelf reloadSocketKlineCharts:hasNewPoint];
            }
        }
    }
}

- (void)loadKline{
    if(_symbol.length>0) {
        WEAK_SELF;
        NSString *symbol = _symbol;
        EChartsType type = self.chartsType;
        EChartsLineType lineType = weakSelf.lineType;
        [self.chartsModel loadKlineData:symbol chartsType:type lineType:lineType success:^{
            weakSelf.hasLoaded = YES;
            if (type == EChartsType_RT) {
                [weakSelf updateMlineChartInfo];
            }else{
                [weakSelf updateKlineChartInfo];
            }
            [weakSelf startKlineTimer];
        } failure:^{
            [NTimeUtil cancelDelay:weakSelf.delayKlineHander];
            weakSelf.delayKlineHander=[NTimeUtil run:^{
                [weakSelf loadKline];
            } delay:3];
        }];
    }
}

- (void)loadAddKline{
    NSLog(@"nice:loadAddKline");
    if(_symbol.length>0&&_hasLoaded) {
        WEAK_SELF;
        NSString *symbol = _symbol;
        EChartsType type = self.chartsType;
        EChartsLineType lineType = weakSelf.lineType;
        [self.chartsModel addKlineData:symbol chartsType:type lineType:lineType success:^{
            [weakSelf startKlineTimer];
            if (weakSelf.hasLoaded==NO) {
                return ;
            }
            if (type == EChartsType_RT) {
                [weakSelf updateMlineChartInfo];
            }else{
                [weakSelf updateKlineChartInfo];
            }
        } failure:^{
            [weakSelf startKlineTimer];
        }];
    }
}

- (void)startKlineTimer{
    WEAK_SELF;
    if (_isTimer) {
        [NTimeUtil cancelDelay:_delayKAddlineHander];
        _delayKAddlineHander = [NTimeUtil run:^{
            [weakSelf loadAddKline];
        } delay:5];
    }
}

- (void)stopTimer{
    _isTimer=NO;
    [NTimeUtil cancelDelay:_delayKAddlineHander];
}

-(void)selectBar:(EChartsType)chartsType
{
    if (_chartsType!=chartsType) {
        _chartsType = chartsType;
        _hasLoaded = NO;
        [_chartsModel cancelTask];
        _chartView.kLineView.isFirst = YES;
        [self reloadMoreCharts:chartsType moreCount:0];
        [self loadKline];
    }
}

- (void)changedLineType:(EChartsLineType)type{
    _lineType = type;
    [self.chartsModel clearData];
    [self clearData];
    [self stopTimer];
    self.isTimer = YES;
    _hasLoaded=NO;
    [self loadKline];
}

- (void)changedSymbol:(NSString *)symbol{
    _symbol = symbol;
    [self.chartsModel clearData];
    [self reloadCharts:_chartsType isClose:NO];
    [_webSocket disconnect];
    _webSocket=nil;
    [self.queue cancelAllOperations];
    [self.chartsModel clearData];
    _lineType=EChartsLineTypeTradePrice;
    [self clearData];
    [self stopTimer];
    self.isTimer = YES;
    _hasLoaded=NO;
    [self loadKline];
    [self websocketLoad];
}

//MARK: - 网络变化

- (void) netStateChange:(NSNotification *) noti
{
    if([NNetState isDisnet]){
        
    }else{
        [self reloadData];
    }
}

//MARK: - Action

- (void)clear{

}

- (void)clearData{
    [_config removeAllObjects];
    [_chartView.mLineView clearData];
    [_chartView.kLineView clearData];
}

- (void)reloadData{
    [self changedSymbol:_symbol];
}

- (void)clickedButtonList:(NSInteger)index{
    [_chartView clickedButtonList:index];
}

- (void)reloadSocketMlineCharts:(BOOL)hasNewPoint{
    if (_chartsType!=EChartsType_RT) {
        return;
    }
    if (![_chartView.mLineView.chartView isFocusing]) {
        NSArray *mlineList = [self.chartsModel getMLineDataCopy];
        if (mlineList.count>1) {
            [self.chartView configSocketMlineData:mlineList hasNewPoint:hasNewPoint];
        }
    }
}

- (void)reloadSocketKlineCharts:(BOOL)hasNewPoint{
    if (_chartsType==EChartsType_RT) {
        return;
    }
    if ([self isCanReloadKLine]) {
        NSMutableArray *klineList = [self.chartsModel getKLineDataCopy:_chartsType];
        if (klineList.count>1) {
            
            [self.chartView configSocketKlineData:klineList hasNewPoint:hasNewPoint];
        }
    }
}

- (void)reloadCharts:(EChartsType)chartsType isClose:(BOOL)isClose{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.chartView.isClose = isClose;
        [self reloadMoreCharts:chartsType moreCount:0];
    });
}

- (void)reloadMoreCharts:(EChartsType)chartsType moreCount:(NSInteger)moreCount{
    if (_chartsType!=chartsType) {
        return;
    }
    WEAK_SELF;
    if (chartsType == EChartsType_RT) {
        if ([self isCanReloadMLine]) {
            NSArray *mlineList = [self.chartsModel getMLineDataCopy];
            if (mlineList.count==0) {
                [self.chartView configMlineData:nil];
                [self showLoadView:YES];
            }else{
                _delay=[NTimeUtil run:^{
                    [StateUtil hide:weakSelf];
                } delay:0.1];
                [self.chartView configMlineData:mlineList];
            }
        }
    }else{
        if ([self isCanReloadKLine]) {
            NSMutableArray *klineList = [self.chartsModel getKLineDataCopy:chartsType];
            if (klineList.count==0) {
                [self.chartView configKlineData:nil];
                [self showLoadView:YES];
            }else{
                _delay=[NTimeUtil run:^{
                    [StateUtil hide:weakSelf];
                } delay:0.1];
                if (moreCount<=0) {
                    [self.chartView configKlineData:klineList];
                }else{
                    [self.chartView configKlineMoreData:klineList moreCount:moreCount];
                }
            }
        }
    }
}

- (void)hitSwitchH{
    
    if (_isLS) {
        self.chartView.size = CGSizeMake(SCREEN_HEIGHT-self.hsRight-IPHONE_X_BOTTOM_HEIGHT, SCREEN_WIDTH-self.hsTopHeight);
        _chartView.hsRight = _hsRight;
        [self.chartView vChartToHChart];
    }else{
        self.chartView.size = CGSizeMake(SCREEN_WIDTH, _vHeight);
        [self.chartView hChartToVChart];
    }
}

- (void)showLoadView:(BOOL)flag{
    [NTimeUtil cancelDelay:_delay];
    ProgressStateView *stateView = (ProgressStateView *)[StateUtil show:self type:StateTypeProgress];
    if (flag) {
        stateView.backgroundColor = [GColorUtil C6];
    }else{
        stateView.backgroundColor = [UIColor clearColor];
    }
    [stateView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:35]);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(CHeight-CButtonListHight);
    }];
}

//MARK: - ReloadUI

- (void)updateBaseInfo{
    CFDBaseInfoModel *data = self.chartsModel.baseInfoData;
    WEAK_SELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf.delegate updateBaseInfo:data];
    });
}

- (void)updateMlineChartInfo
{
    [self updateBaseInfo];
    self.chartView.mLineView.dotNum = self.chartView.mLineView.dotNum = self.chartsModel.baseInfoData.dotNum;
    BOOL isClose = _chartsModel.baseInfoData.openStatusTrade == NSOpenStatusTradeNonTime||[_chartsModel.baseInfoData.tradestatus isEqualToString:@"0"];
    [self reloadCharts:EChartsType_RT isClose:isClose];
}

- (void)updateKlineChartInfo
{
    [self updateBaseInfo];
    self.chartView.kLineView.dotNum = self.chartView.kLineView.dotNum = self.chartsModel.baseInfoData.dotNum;
    BOOL isClose = _chartsModel.baseInfoData.openStatusTrade == NSOpenStatusTradeNonTime||[_chartsModel.baseInfoData.tradestatus isEqualToString:@"0"];
    [self reloadCharts:self.chartsType isClose:isClose];
}

//MARK: - Getter

- (CFDMarketChartView *)chartView {
    if (!_chartView) {
        
        _chartView = [[CFDMarketChartView alloc] initWithTitles:self.titles hTitles:self.hTitles frame:CGRectMake(0, 0, SCREEN_WIDTH, _vHeight) hasVol:YES];
        WEAK_SELF;
        _chartView.selectBar = ^(EChartsType chartsType) {
            [weakSelf selectBar:chartsType];
        };
        _chartView.mLineView.disenableScroll = ^(BOOL flag){
            [weakSelf.delegate disenableScroll:flag];
        };
        _chartView.mLineView.hitSwitchH = ^{
            [weakSelf.delegate switchsScreenToH];
        };
        _chartView.kLineView.disenableScroll = ^(BOOL flag){
            [weakSelf.delegate disenableScroll:flag];
        };
        _chartView.kLineView.hitSwitchH = ^{
            [weakSelf.delegate switchsScreenToH];
        };
        _chartView.loadMore = ^(dispatch_block_t completeHander){
            NSString *symbol = weakSelf.symbol;
            if (symbol.length<=0) {
                return ;
            }
            [weakSelf showLoadView:NO];
            EChartsType chartsType = weakSelf.chartsType;
            EChartsLineType lineType = weakSelf.lineType;
            [weakSelf.chartsModel klineMoreData:symbol chartsType:chartsType lineType:lineType success:^(NSInteger moreCount){
                dispatch_async(dispatch_get_main_queue(), ^{
                    [StateUtil hide:weakSelf];
                    completeHander();
                    [weakSelf reloadMoreCharts:chartsType moreCount:moreCount];
                });
            } failure:^{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [StateUtil hide:weakSelf];
                    completeHander();
                });
            }];
        };
    }
    return _chartView;
}

//是否可以刷分时绘图 （十字线在时不能刷）
- (BOOL)isCanReloadMLine
{
    BOOL bRet = YES;
    if([_chartView.mLineView.chartView isFocusing]||[_chartView.kLineView.scrollView isDragging]||[_chartView.kLineView isPaning]||[_chartView.kLineView isPinching])
        bRet = NO;
    return bRet;
}

//是否可以刷K绘图 （十字线在时不能刷）
- (BOOL)isCanReloadKLine
{
    BOOL bRet = YES;
    if([_chartView.kLineView.chartView isFocusing]||[_chartView.kLineView isDragging]||[_chartView.kLineView isPaning]||[_chartView.kLineView isPinching])
        bRet = NO;
    return bRet;
}

- (NSArray  <NSDictionary *>*)titles{
   
    NSDictionary *dic = @{@"title":CFDLocalizedString(@"分时"),@"chartsType":@(EChartsType_RT)};
    NSDictionary *dic_1 = @{@"title":CFDLocalizedString(@"1分钟"),@"chartsType":@(EChartsType_KL_1)};
    NSDictionary *dic_3 = @{@"title":CFDLocalizedString(@"3分钟"),@"chartsType":@(EChartsType_KL_3)};
    NSDictionary *dic_5 = @{@"title":CFDLocalizedString(@"5分钟"),@"chartsType":@(EChartsType_KL_5)};
    NSDictionary *dic_15 = @{@"title":CFDLocalizedString(@"15分钟"),@"chartsType":@(EChartsType_KL_15)};
    NSDictionary *dic_30 = @{@"title":CFDLocalizedString(@"30分钟"),@"chartsType":@(EChartsType_KL_30)};
    NSDictionary *dic_60 = @{@"title":CFDLocalizedString(@"1小时"),@"chartsType":@(EChartsType_KL_60)};
    NSDictionary *dic_240 = @{@"title":CFDLocalizedString(@"4小时"),@"chartsType":@(EChartsType_KL_240)};
    NSDictionary *dic_day = @{@"title":CFDLocalizedString(@"日K"),@"chartsType":@(EChartsType_KL)};
    NSArray *tem = @[dic_3,dic_15,dic_30,dic_60,dic_240];
    NSDictionary *dict = @{@"more":@"1",@"moreTitles":tem,@"title":CFDLocalizedString(@"更多")};
    NSArray *indexs = @[@[@(EIndexTopTypeMa),@(EIndexTopTypeBool)],@[@(EIndexTypeMacd),@(EIndexTypeKdj),@(EIndexTypeRsi),@(EIndexTypeWR)]];
    NSDictionary *dict_index = @{@"more":@"1",@"moreTitles":indexs,@"title":CFDLocalizedString(@"指标"),@"isIndex":@(YES)};
    NSArray * titles = @[dic,dic_day,dic_1,dic_5,dict,dict_index];
    return titles;
}

- (NSArray  <NSDictionary *>*)hTitles{
    NSDictionary *dic = @{@"title":CFDLocalizedString(@"分时"),@"chartsType":@(EChartsType_RT)};
    NSDictionary *dic_1 = @{@"title":CFDLocalizedString(@"1分钟"),@"chartsType":@(EChartsType_KL_1)};
    NSDictionary *dic_3 = @{@"title":CFDLocalizedString(@"3分钟"),@"chartsType":@(EChartsType_KL_3)};
    NSDictionary *dic_5 = @{@"title":CFDLocalizedString(@"5分钟"),@"chartsType":@(EChartsType_KL_5)};
    NSDictionary *dic_15 = @{@"title":CFDLocalizedString(@"15分钟"),@"chartsType":@(EChartsType_KL_15)};
    NSDictionary *dic_30 = @{@"title":CFDLocalizedString(@"30分钟"),@"chartsType":@(EChartsType_KL_30)};
    NSDictionary *dic_60 = @{@"title":CFDLocalizedString(@"1小时"),@"chartsType":@(EChartsType_KL_60)};
    NSDictionary *dic_240 = @{@"title":CFDLocalizedString(@"4小时"),@"chartsType":@(EChartsType_KL_240)};
    NSDictionary *dic_day = @{@"title":CFDLocalizedString(@"日K"),@"chartsType":@(EChartsType_KL)};
    
    NSArray * titles = @[dic,dic_day,dic_1,dic_3,dic_5,dic_15,dic_30,dic_60,dic_240];
    return titles;
}


@end

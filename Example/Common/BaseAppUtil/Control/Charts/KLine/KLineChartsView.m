//
//  KLineChartsView.m
//  LiveTrade
//
//  Created by ngw15 on 2018/11/27.
//  Copyright © 2018 taojinzhe. All rights reserved.
//

#import "KLineChartsView.h"
#import "GirlLineView.h"
#import "AxisView.h"

@interface KLineChartsView()<UIScrollViewDelegate,UIGestureRecognizerDelegate>

@property (nonatomic,strong)AxisView *axisView;
@property (nonatomic,strong)BottomAxisView *bottomAxisView;
@property (nonatomic,strong)BottomAxisView *indexVolAxisView;
@property(nonatomic,strong)UIButton *btnSwichH;
@property (nonatomic,strong)GirlLineView *girlView;

@property (nonatomic,assign) NSInteger startX;
@property(nonatomic,assign)BOOL hasVol;

@property (nonatomic,strong) UIPinchGestureRecognizer *pinch;
@property (nonatomic,strong) UIPanGestureRecognizer *pan;
@property (nonatomic,assign) BOOL isHPaning;
@property (nonatomic,assign) CGFloat originPointY;
@property (nonatomic,assign) CGFloat originPointX;
@property (nonatomic,assign) CGFloat originX;
@property (nonatomic,assign) CGFloat originLength;

@property (nonatomic,assign) BOOL shouldLoadMore;
@property (nonatomic,strong) dispatch_semaphore_t lock;
@property (nonatomic,strong) UIActivityIndicatorView *indicator;
@end

@implementation KLineChartsView

- (void)dealloc{
    
}

- (instancetype)initWithFrame:(CGRect)frame hasVol:(BOOL)hasVol{
    if (self = [super initWithFrame:frame]) {
        _hasVol = hasVol;
        _isFirst=YES;
        _startX=0;
        _isHPaning = YES;
        _lock=dispatch_semaphore_create(1);
        [self setupUI];
        [self autoLayout];
        [self changedIndex:_chartView.indexType];
    }
    return self;
}

- (void)setupUI{
    self.multipleTouchEnabled = YES;
    [self addSubview:self.girlView];
    [self addSubview:self.scrollView];
    [self addSubview:self.bottomAxisView];
    [self addSubview:self.indexVolAxisView];
    [self addSubview:self.axisView];
    [self addSubview:self.btnSwichH];
    [self.scrollView addSubview:self.chartView];
    _pinch = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(zoomScaleAction:)];
    _pinch.delegate = self;
    [self addGestureRecognizer:_pinch];
    _pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(scrollAction:)];
    _pan.delegate = self;
    [self addGestureRecognizer:_pan];
    WEAK_SELF;
    _chartView.axisHander = ^(NSDictionary *dic) {
        [weakSelf.axisView setMaxAxis:[NDataUtil stringWith:dic[@"left1"] valid:@""] minY:[NDataUtil stringWith:dic[@"left2"] valid:@""] preNum:weakSelf.chartView.nDotNum lastPrice:[NDataUtil stringWith:dic[@"lastPrice"] valid:@""] isRed:[NDataUtil boolWith:dic[@"isRed"] valid:YES]];
    };
    _chartView.bottomAxisHander = ^(NSDictionary *dic) {
        [weakSelf.bottomAxisView setMaxAxis:[NDataUtil stringWith:dic[@"left1"] valid:@""] minY:[NDataUtil stringWith:dic[@"left2"] valid:@""]];
        if ([dic containsObjectForKey:@"y1"]) {        
            [weakSelf.bottomAxisView setY1:[NDataUtil stringWith:dic[@"y1"] valid:@""] setY2:[NDataUtil stringWith:dic[@"y2"] valid:@""] height:[dic[@"height"] floatValue]];
        }
    };
    _chartView.indexVolAxisHander = ^(NSDictionary *dic) {
        [weakSelf.indexVolAxisView setMaxAxis:[NDataUtil stringWith:dic[@"left1"] valid:@""] minY:[NDataUtil stringWith:dic[@"left2"] valid:@""]];
    };
    _chartView.axisCursorHander = ^(NSString *cursorPrice,BOOL isLast) {
 
        [weakSelf.axisView showCursorPrice:cursorPrice isLast:isLast];
    };
}

- (void)autoLayout{
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    _girlView.frame = CGRectMake(0, CButtonListToMainChartsHight, self.width-self.chartView.lineRight+[ChartsUtil fit:25], ceil(self.chartView.nfenshiheight/2.0)*2);
    _axisView.frame = CGRectMake(0, CButtonListToMainChartsHight, self.width, self.chartView.nfenshiheight);

    _btnSwichH.frame = CGRectMake([GUIUtil fit:5], _axisView.bottom-[GUIUtil fit:5]-19, 19, 19);
    _bottomAxisView.frame = CGRectMake(0, self.chartView.height-self.chartView.indexHeight-CTimeAixsHight+CButtonListToMainChartsHight, self.width, self.chartView.indexHeight);
    CGFloat bottomTop = _chartView.indexType==EIndexTypeNone?self.chartView.height-self.chartView.indexHeight-CTimeAixsHight+CButtonListToMainChartsHight:self.chartView.height-self.chartView.indexHeight*2-CVolIndexToIndexChartsHight-CTimeAixsHight+CButtonListToMainChartsHight;
    _indexVolAxisView.frame = CGRectMake(0, bottomTop, self.width, self.chartView.indexHeight);
}

//MARK: - Switch Screen

- (void)dynamicFrame{
    _chartView.size=CGSizeMake(self.size.width, self.size.height-CButtonListToMainChartsHight);
    [_chartView dynamicFrame];
    _chartView.size=CGSizeMake(self.size.width, self.size.height-CButtonListToMainChartsHight);
    _scrollView.contentSize = CGSizeMake(self.size.width+1, self.size.height);
    _girlView.frame = CGRectMake(0, CButtonListToMainChartsHight, self.width-self.chartView.lineRight+[ChartsUtil fit:25], ceil(self.chartView.nfenshiheight/2.0)*2);
    _axisView.frame = CGRectMake(0, CButtonListToMainChartsHight, self.width, self.chartView.nfenshiheight);
    
    _bottomAxisView.frame = CGRectMake(0, self.chartView.height-self.chartView.indexHeight-CTimeAixsHight+CButtonListToMainChartsHight, self.width, self.chartView.indexHeight);
    CGFloat bottomTop = _chartView.indexType==EIndexTypeNone?self.chartView.height-self.chartView.indexHeight-CTimeAixsHight+CButtonListToMainChartsHight:self.chartView.height-self.chartView.indexHeight*2-CTimeAixsHight-CVolIndexToIndexChartsHight+CButtonListToMainChartsHight;
    _indexVolAxisView.frame = CGRectMake(0, bottomTop, self.width, self.chartView.indexHeight);
}

- (void)vChartToHChart{
    _btnSwichH.hidden = YES;
    [self dynamicFrame];
}

- (void)vChartToHShowInfo{
    //isFirst 可控制是否回到默认状态
    _isFirst = NO;
    NSDictionary *dic = [self showInfo:YES];
    [_chartView showInfo:NSRangeFromString(dic[@"range"])];
}

- (void)hChartToVChart{
    _btnSwichH.hidden = NO;
    [self dynamicFrame];
}

- (void)hChartToVShowInfo{
    //isFirst 可控制是否回到默认状态
    _isFirst = NO;
    NSDictionary *dic = [self showInfo:YES];
    [_chartView showInfo:NSRangeFromString(dic[@"range"])];

}

//MARK: - Action

- (EIndexTopType)indexTopType{
    return _chartView.indexTopType;
}
- (EIndexType)indexType{
    return _chartView.indexType;
}

- (void)changedTopIndex:(EIndexTopType)indexTopType{
    if(_chartView.indexTopType==indexTopType){
        return;
    }
    [_chartView changedTopIndex:indexTopType];
}

- (void)changedIndex:(EIndexType)indexType{
    if(_chartView.indexType==indexType){
        return;
    }
    BOOL needChangedLayout = NO;
    if (indexType==EIndexTypeNone) {
        if (_chartView.indexType!=EIndexTypeNone) {
            needChangedLayout = YES;
        }
        _bottomAxisView.hidden = YES;
    }else{
        if (_chartView.indexType==EIndexTypeNone) {
            needChangedLayout = YES;
        }
        _bottomAxisView.hidden=NO;
    }
    [_chartView changedIndex:indexType];
    if (needChangedLayout) {
        [self dynamicFrame];
    }
}

- (void)switchH
{
    if(self.hitSwitchH)
        self.hitSwitchH(); 
}

- (void)clearData{
    _isFirst = YES;
    _chartView.hCount=KLineCountDefault;
    [_chartView clear];
}

- (void)clearChangedBarData{
    [_chartView clear];
}

- (void)configSocketChart:(NSArray *)dataList hasNewPoint:(BOOL)hasNewPoint{
    WEAK_SELF;
    _chartView.nDotNum= _dotNum;
    [_chartView setKLineDataArr:dataList];
    if (weakSelf.isPinching==NO&&weakSelf.isPaning==NO) {
        
        NSDictionary *dic = [self showInfo:YES];
        BOOL isReload = [NDataUtil boolWithDic:dic key:@"isReload" isEqual:@"1"];
        [_chartView socketShowInfo:NSRangeFromString(dic[@"range"]) isReload:isReload hasNewPoint:hasNewPoint];
        
    }
}

- (void)configChart:(NSArray *)dataList moreCount:(NSInteger)moreCount{
    _startX += moreCount;
    [self configChart:dataList];
}

- (void)configChart:(NSArray *)dataList{
    WEAK_SELF;
    _chartView.nDotNum= _dotNum;
    [_chartView setKLineDataArr:dataList];
    if (weakSelf.isPinching==NO&&weakSelf.isPaning==NO) {
        NSDictionary *dic = [self showInfo:YES];
        if ([NDataUtil boolWithDic:dic key:@"isReload" isEqual:@"1"]||dataList.count<=1) {
            [self clearChangedBarData];
            [_chartView showInfo:NSRangeFromString(dic[@"range"])];
        }
    }
}

- (void)scrollAction:(UIPanGestureRecognizer *)pan{
    NSArray *dataList = [_chartView getDataList];
    if (_chartView.hCount>dataList.count) {
        //标准屏展示下了，不用滚动
        _isPaning=NO;
        return;
    }
    CGPoint point = [pan locationInView:pan.view];
    if (pan.state==UIGestureRecognizerStateBegan) {
        _originPointX =point.x;
        _originPointY =point.y;
        _originX = _startX;
        _isPaning = YES;
        _isHPaning = YES;
        CGPoint velocity = [pan velocityInView:pan.view];
        if (dataList.count>_chartView.hCount) {
            
            BOOL isHPan = ABS(velocity.x)>ABS(velocity.y);
            if (isHPan==NO) {
                _isPaning = NO;
                pan.enabled = NO;
                pan.enabled=YES;
                _isHPaning = NO;
                return;
            }else{
                _disenableScroll(YES);
            }
        }else{
            _isPaning = NO;
            _isHPaning = NO;
            pan.enabled = NO;
            pan.enabled=YES;
            return;
        }
    }
    else if (pan.state == UIGestureRecognizerStateChanged) {
        CGFloat offsetX = point.x-_originPointX;
        CGFloat width = SCREEN_WIDTH-20;
        NSInteger offset = (NSInteger)((offsetX/(width/_chartView.nfenshiCount)+0.5)*100)/100;
        _startX = _originX-offset;
        if (_startX<0) {
            _startX=0;
        }else if (_startX>dataList.count-(_chartView.hCount)) {
            
            _startX= dataList.count-(_chartView.hCount);
            _startX = MAX(0, _startX);
        }else if (dataList.count<_chartView.hCount){
            _startX = 0;
        }
        
        NSDictionary *dic = [self showInfo:NO];
        if ([NDataUtil boolWithDic:dic key:@"isReload" isEqual:@"1"]) {
            [_chartView showInfo:NSRangeFromString(dic[@"range"])];
        }
    }else if (pan.state==UIGestureRecognizerStateEnded||pan.state==UIGestureRecognizerStateCancelled){
        _isPaning = NO;
        _disenableScroll(NO);
    }

}


- (void)zoomScaleAction:(UIPinchGestureRecognizer *)pinch{
    NSArray *dataList = [_chartView getDataList];
    CGFloat lastScale = [pinch scale];
    if (pinch.state==UIGestureRecognizerStateBegan) {
        _originLength = _chartView.hCount;
        _isPinching = YES;
        _originX = _startX;
        _disenableScroll(YES);
    }
    else if (pinch.state == UIGestureRecognizerStateChanged) {
        
        if (lastScale<=1&&_originLength==dataList.count) {
            _isPinching = NO;
            return;
        }else if (lastScale>=1&&_originLength==KLineCountMin){
            _isPinching = NO;
            return;
        }
        
        _isPinching = YES;
        NSInteger length = 1/lastScale*_originLength;
        if (length<KLineCountMin) {
            _chartView.hCount=KLineCountMin;
            _startX = dataList.count-_chartView.hCount;
            if (_originLength==KLineCountMin) {
                _isPinching = NO;
                return;
            }
        }else if (length>dataList.count) {
            if (length>_chartView.maxCount) {
                length=_chartView.maxCount;
                _startX = _startX + (_chartView.hCount - length);
                _chartView.hCount = length;
            }else{
                _startX=0;
                _chartView.hCount=dataList.count;
                if (_chartView.hCount<KLineCountMin) {
                    _chartView.hCount=KLineCountMin;
                }
                if (_originLength>dataList.count) {
                    _isPinching = NO;
                    return;
                }
            }
        }else if (length>_chartView.maxCount){
            length=_chartView.maxCount;
            _startX = _startX + (_chartView.hCount - length);
            _chartView.hCount = length;
        }else{
            _startX = _startX + (_chartView.hCount - length);
            _chartView.hCount = length;
        }
        
        _startX = MAX(0, _startX);
        NSDictionary *dic = [self showInfo:NO];
        if ([NDataUtil boolWithDic:dic key:@"isReload" isEqual:@"1"]) {
            [_chartView showInfo:NSRangeFromString(dic[@"range"])];
        }
    }else{
        _isPinching = NO;
        _disenableScroll(NO);
    }
}

- (NSDictionary *)showInfo:(BOOL)isLoadChart{
    CGFloat lineRight = self.chartView.lineRight;
    CGFloat width = self.chartView.allWidth-lineRight;
    int count = (self.chartView.allWidth)/width*_chartView.hCount;
    _chartView.nfenshiCount = count;
    NSArray *showList = [_chartView getShowData];
    NSArray *dataList = [_chartView getDataList];
    NSRange range = NSMakeRange(0, 0);
    //第一次刷
    if (_isFirst==YES||showList.count<=0) {
        
        NSInteger length = _chartView.hCount;
        _startX = dataList.count-length;
        _startX = MAX(0, _startX);
        range.location = _startX;
        range.length =  length;
        _isFirst = NO;
    }
    //是请求下来的数据
    else if (isLoadChart) {
        //最新的点有在显示
        if (_chartView.hasLast) {
            _startX= dataList.count-_chartView.hCount;
            range.location = _startX;
            range.length = _chartView.hCount;
        }else{
            //请求的数据下来时，在历史数据处，不用刷新
            return @{@"range":NSStringFromRange(range),@"isReload":@"0"};
        }
    }
    // 滚动 缩放时 最新的点不满一屏
    else if (dataList.count-_startX<_chartView.nfenshiCount) {
        range.location = _startX;
        range.length = dataList.count-_startX;
    }
    // 滚动 缩放时 满屏
    else{
        range.location = _startX;
        range.length = _chartView.nfenshiCount;
    }
    return @{@"range":NSStringFromRange(range),@"isReload":@"1"};
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer == _pan) {
        if (_isPinching) {
            return NO;
        }else{
            return YES;
        }
    }
    return YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView==_scrollView) {
        if (_isHPaning==NO) {
            _scrollView.contentOffset = CGPointZero;
            return;
        }
        BOOL leftScroll = _startX<=0;
        leftScroll &=scrollView.contentOffset.x<0;
        NSArray *dataList = [_chartView getDataList];
    
        BOOL rightScroll = _startX>=dataList.count-_chartView.hCount;
        rightScroll &=scrollView.contentOffset.x>0;
        BOOL notEnoughScroll = dataList.count<=_chartView.hCount||(_startX==0&&dataList.count<=_chartView.nfenshiCount);
        if  (leftScroll==NO&&
             rightScroll==NO&&
             notEnoughScroll==NO){
            _scrollView.contentOffset = CGPointZero;
        }else{
            
            CGPoint point = _scrollView.contentOffset;
            point.y=0;
            _scrollView.contentOffset = point;
            if (rightScroll) {
                if (point.x>=0){
                    _scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                }else if (point.x>-100) {
                    _scrollView.contentInset = UIEdgeInsetsMake(0, point.x, 0, 0);
                }else{
                    _scrollView.contentInset = UIEdgeInsetsMake(0, -100, 0, 0);
                }
            }else{
                //向左拉加载更多
                _isPaning=NO;
                if (_loadMore&&_shouldLoadMore) {
                    _shouldLoadMore=NO;
                    WEAK_SELF;
                    dispatch_block_t completeHander = ^{
                        if (weakSelf.scrollView.contentOffset.x<0) {
                            //打断下用户此时的手势与scrollview的滚动
                            weakSelf.pan.enabled = NO;
                            weakSelf.pan.enabled = YES;
                            weakSelf.scrollView.scrollEnabled=NO;
                            weakSelf.scrollView.scrollEnabled=YES;
                            
                            weakSelf.scrollView.contentOffset = CGPointZero;
                            weakSelf.isDragging = NO;
                        }
                    };
                    _loadMore(completeHander);
                }
            }
        }
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    _shouldLoadMore=YES;
    _isDragging = YES;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    _shouldLoadMore=NO;
    _isDragging = NO;
}

//MARK: - Gettr

- (void)setHitSwitchH:(void (^)(void))hitSwitchH{
    _hitSwitchH = hitSwitchH;

}

- (CFDKlineView*)chartView
{
    if (!_chartView) {
        _chartView = [[CFDKlineView alloc] initWithFrame:CGRectMake(0, CButtonListToMainChartsHight, (SCREEN_WIDTH-20), self.height-CButtonListToMainChartsHight) hasBottomIndex:_hasVol];
        _chartView.hCount = KLineCountDefault;
    }
    return _chartView;
}

- (GirlLineView *)girlView{
    if (!_girlView) {
        _girlView = [[GirlLineView alloc] initWithOffSetWidth:[ChartsUtil fit:25]];
    }
    return _girlView;
}

- (AxisView *)axisView{
    if (!_axisView) {
        _axisView = [[AxisView alloc] init];
        _axisView.bgImgView.image = [GColorUtil imageNamed:@"market_axis"];
    }
    return _axisView;
}
- (BottomAxisView *)bottomAxisView{
    if (!_bottomAxisView) {
        _bottomAxisView = [[BottomAxisView alloc] init];
        _bottomAxisView.bgImgView.image = [GColorUtil imageNamed:@"market_axis"];
    }
    return _bottomAxisView;
}

- (BottomAxisView *)indexVolAxisView{
    if (!_indexVolAxisView) {
        _indexVolAxisView = [[BottomAxisView alloc] init];
        _indexVolAxisView.bgImgView.image = [GColorUtil imageNamed:@"market_axis"];
    }
    return _indexVolAxisView;
}

- (UIButton*)btnSwichH
{
    if (!_btnSwichH) {
        _btnSwichH = [UIButton buttonWithType:UIButtonTypeCustom];
        [_btnSwichH g_clickEdgeWithTop:20 bottom:20 left:20 right:20];
        _btnSwichH.backgroundColor = [UIColor clearColor];
        [_btnSwichH setImage:[GColorUtil imageNamed:@"quanping"] forState:UIControlStateNormal];
        WEAK_SELF;
        [_btnSwichH g_clickBlock:^(id sender) {
            [weakSelf switchH];
        }];
        
    }
    return _btnSwichH;
}

- (CFDScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[CFDScrollView alloc] init];
        _scrollView.hasPan = YES;
        _scrollView.contentSize = CGSizeMake(self.size.width+1, self.size.height);
        _scrollView.bounces = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIActivityIndicatorView *) indicator
{
    if(!_indicator){
        _indicator= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                     UIActivityIndicatorViewStyleWhite];
        _indicator.transform = CGAffineTransformMakeScale(0.7, 0.7);
        _indicator.hidden=YES;
    }
    return _indicator;
}

@end


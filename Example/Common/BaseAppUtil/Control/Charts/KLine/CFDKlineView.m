//
//  CFDKLineView.m
//  LiveTrade
//
//  Created by ngw15 on 2018/11/27.
//  Copyright © 2018 taojinzhe. All rights reserved.
//

#import "CFDKlineView.h"
#import "CFDCursorView.h"
#import "CFDScrollView.h"
#import "DemoChartsModel.h"
#import "CFDKlineLayer.h"
#import "CFDGirlLayer.h"

#import "CFDTopIndexLayer.h"
#import "CFDIndexVOLLayer.h"
#import "CFDBottomIndexLayer.h"

@interface CFDKlineView()

@property(nonatomic,strong)CFDCursorView *cursorView;
@property(nonatomic,strong)UIView *lastPriceLine;

@property (nonatomic,strong)CFDGirlLayer *girlLayer;
@property (nonatomic,strong)CFDKlineLayer *kLineLayer;
@property (nonatomic,strong)UILabel *lastText;

//top指标
@property (nonatomic,strong)CFDTopIndexLayer *indexTopLayer;
@property(nonatomic,strong)CATextLayer *indexTopTextLayer;
//固定指标
@property (nonatomic,strong)CFDIndexVOLLayer *indexVolLayer;
@property(nonatomic,strong)CATextLayer *indexVolTextLayer;
//可选指标指标
@property (nonatomic,strong)CFDBottomIndexLayer *bottomLayer;
@property(nonatomic,strong)CATextLayer *indexTextLayer;

///是否展示底部的指标
@property (nonatomic,assign)BOOL hasBottomIndex;
///十字线上点的物理坐标
@property(atomic,strong)NSMutableArray *iPositionArr;
///总数据
@property(atomic,strong)ThreadSafeArray *ikLineDataArr;
///展示的数据
@property(atomic,strong)ThreadSafeArray *showData;

@property(nonatomic,strong)NSString *maxPrice;
@property(nonatomic,strong)NSString *minPrice;
@property(nonatomic,strong)NSOperationQueue *queue;

//http返回的数据是否已经绘图，（socket绘图需等http的绘完才能绘图）
@property (nonatomic,assign) BOOL hasLoadedFromHttp;
@end

@implementation CFDKlineView

- (instancetype)initWithFrame:(CGRect)frame hasBottomIndex:(BOOL)hasBottomIndex
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _queue = [[NSOperationQueue alloc] init];
        _hasBottomIndex = hasBottomIndex;
        _indexTopType = EIndexTopTypeNone;
        _indexType=EIndexTypeNone;
        [self defaultData];
        [self setupUI];
        [self showIndexTop:_indexTopType];
    }
    return self;
}

- (void)setupUI{
    //时间轴及线
    [self.layer addSublayer:self.girlLayer];
    //k线
    [self.layer addSublayer:self.kLineLayer];
    //主图的指标
    [self.layer addSublayer:self.indexTopLayer];
    //可选的指标
    [self.layer addSublayer:self.bottomLayer];
    //固定的指标（成交量图）
    [self.layer addSublayer:self.indexVolLayer];
    //最新的点
    {
        [self addSubview:self.lastText];
        [self addSubview:self.lastPriceLine];
    }
    //十字线
    [self addSubview:self.cursorView];
    
    [self.layer addSublayer:self.indexTopTextLayer];
    [self.layer addSublayer:self.indexVolTextLayer];
    [self.layer addSublayer:self.indexTextLayer];
    
    
    
}


- (void)defaultData{
    _allWidth = self.width;
    _lineRight = CLineRight-[GUIUtil fit:5];
    if (_hasBottomIndex) {
        CGFloat mainChartH = _indexType==EIndexTypeNone?CMainChartHight:CMainChartHight-CIndexChartHight;
        _nfenshiheight =  mainChartH;
        _indexHeight = CIndexChartHight;
    }else{
        _nfenshiheight = self.height;
        _indexHeight = 0;
    }
    _showWidth = self.width-self.lineRight+[ChartsUtil fit:25];
    [self.bottomLayer setIndexDrawHeight:_indexHeight-[GUIUtil fit:10]];
    self.indexVolLayer.height = _indexHeight;
    self.nDotNum = 2;
    self.iPositionArr = [[NSMutableArray alloc]init];
    self.ikLineDataArr = [[ThreadSafeArray alloc]init];
    self.showData = [[ThreadSafeArray alloc] init];
    self.maxPrice = [NSString stringWithFormat:@"%lf",CGFLOAT_MIN];
    self.minPrice = [NSString stringWithFormat:@"%lf",CGFLOAT_MAX];;
}

- (void)dynamicFrame
{
    if (_hasBottomIndex) {
        CGFloat mainChartH = _indexType==EIndexTypeNone?CMainChartHight:CMainChartHight-CIndexChartHight;
        _nfenshiheight =  (self.height-CRegularHeight)*mainChartH/CChartHeight;
        _indexHeight =  (self.height-CRegularHeight)*CIndexChartHight/CChartHeight;
    }else{
        _nfenshiheight = self.height;
        _indexHeight = 0;
    }
    [self.bottomLayer setIndexDrawHeight:_indexHeight-[GUIUtil fit:10]];
    self.indexVolLayer.height = _indexHeight;
    _showWidth = self.width-self.lineRight+[ChartsUtil fit:25];
    _allWidth = self.width;
    _cursorView.frame = CGRectMake(0, 0, (self.frame.size.width-_lineRight), self.frame.size.height);
    [self setNeedsLayout];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    self.indexTopLayer.frame =
    self.kLineLayer.frame    = CGRectMake(0, 0, self.width, self.nfenshiheight);
    self.girlLayer.frame     = CGRectMake(0, 0, self.width, self.height-CTimeAixsHight);
    self.indexTopTextLayer.frame = CGRectMake([GUIUtil fit:5], [GUIUtil fit:1], self.width-_lineRight, [GUIUtil fitFont:8].lineHeight);
    //bottomlayer
    {
        CGFloat bottomLayerTop = self.height-self.indexHeight-CTimeAixsHight;
        self.bottomLayer.frame   = CGRectMake(0, bottomLayerTop, self.width, self.indexHeight);
        self.indexTextLayer.frame = CGRectMake([GUIUtil fit:5], bottomLayerTop+[GUIUtil fit:1], [GUIUtil fit:250], [GUIUtil fitFont:8].lineHeight);
    }
    //volIndex
    {
        CGFloat bottomTop = _indexType==EIndexTypeNone?self.height-self.indexHeight-CTimeAixsHight:self.height-self.indexHeight*2-CVolIndexToIndexChartsHight-CTimeAixsHight;
        self.indexVolLayer.frame = CGRectMake(0,bottomTop , self.width, self.indexHeight) ;
        self.indexVolTextLayer.frame = CGRectMake([GUIUtil fit:5], bottomTop+[GUIUtil fit:1], [GUIUtil fit:250], [GUIUtil fitFont:8].lineHeight);
    }
    [CATransaction commit];
}

//MARK: - Action

- (BOOL)isFocusing{
    return [self.cursorView isShowFocus];
}

- (void)vChartToHChart
{
    [self dynamicFrame];
    _lastPriceLine.hidden = YES;
}

- (void)hChartToVChart
{
    [self dynamicFrame];
}



- (void)changedTopIndex:(EIndexTopType)indexTopType{
    _indexTopType=indexTopType;
    NSArray *dataList = [self showData];
    CFDKLineData *firstData = [NDataUtil dataWithArray:dataList index:1];
    CFDKLineData *lastData = [NDataUtil dataWithArray:dataList index:dataList.count-1];
    [self calIndexTopData:_indexTopType firstData:firstData lastData:lastData];
    [_indexTopLayer drawTopIndex:_indexTopType showDataList:dataList maxPrice:_maxPrice minPrice:_minPrice];
    [self showIndexTop:_indexTopType];
}

- (void)changedIndex:(EIndexType)indexType{
    if (_hasBottomIndex) {
        _indexType = indexType;
        NSArray *dataList = [self showData];
        CFDKLineData *firstData = [NDataUtil dataWithArray:dataList index:1];
        CFDKLineData *lastData = [NDataUtil dataWithArray:dataList index:dataList.count-1];
        [self calIndexData:_indexType firstData:firstData lastData:lastData];
        [self showBottomIndex:_indexType showDataList:dataList];
    }
}


//MARK: - 计算
- (void)socketShowInfo:(NSRange)range isReload:(BOOL)isReload hasNewPoint:(BOOL)flag{
    if (_hasLoadedFromHttp==NO) {
        return;
    }
    CFDKLineData *lineData = [_ikLineDataArr lastObject];
    NSString *lastPriceStr =[lineData iNowv];
    
    if (_hasLast) {    
        CGFloat lastPrice = [lastPriceStr floatValue];
        if ([ChartsUtil compare:lastPrice withFloat:[_maxPrice floatValue]]==NSOrderedDescending) {
            _maxPrice = lastPriceStr;
        }else if ([ChartsUtil compare:lastPrice withFloat:[_minPrice floatValue]]==NSOrderedAscending){
            _minPrice = lastPriceStr;
        }
    }
    WEAK_SELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.axisHander) {
            NSDictionary *axisDic = @{@"left1":weakSelf.maxPrice?:@"",@"left2":weakSelf.minPrice?:@"",@"volNum":@"",@"lastPrice":lastPriceStr,@"isRed":@(lineData.isRed)};
            weakSelf.axisHander(axisDic);
        }
        if (isReload == NO) {
            [weakSelf drawLastLine:weakSelf.maxPrice minPrice:weakSelf.minPrice lastPrice:lastPriceStr lastX:weakSelf.showWidth isRed:lineData.isRed];
        }
        
    });
    if (isReload==NO) {
        return;
    }
    range.length = MIN(self.ikLineDataArr.count, range.length);
    range.location = MIN(range.location, self.ikLineDataArr.count-1);
    _hasLast = NO;
    if (range.location+range.length>=self.ikLineDataArr.count) {
        NSInteger location = self.ikLineDataArr.count-range.length;
        range.location = MAX(0, location);
        _hasLast = YES;
    }
    NSArray *tem = [self.ikLineDataArr subarrayWithRange:range];
    ThreadSafeArray *dataList = [[ThreadSafeArray alloc] initWithArray:tem];
    [self showView:dataList maxPrice:_maxPrice minPrice:_minPrice lastPrice:lastPriceStr isRed:lineData.isRed isSocketRefresh:!flag];
}

- (void)showInfo:(NSRange)range{
    WEAK_SELF;
    NSBlockOperation *operation = [NSBlockOperation blockOperationWithBlock:^{
        [weakSelf asyncShowInfo:range];
    }];
    _queue.maxConcurrentOperationCount = 1;
    [_queue addOperation:operation];
}

- (void)asyncShowInfo:(NSRange)range
{//计算range数据并显示
    if (_ikLineDataArr.count<1) {
        WEAK_SELF;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.showData removeAllObjects];
            weakSelf.bottomLayer.hidden =
            weakSelf.lastPriceLine.hidden=
            weakSelf.indexTopLayer.hidden =
            weakSelf.kLineLayer.hidden =
            YES;
            if (weakSelf.axisHander) {
                NSDictionary *axisDic = @{@"left1":@"0",@"left2":@"0",@"volNum":@"",@"lastPrice":@"0",@"isRed":@(YES)};
                
                weakSelf.axisHander(axisDic);
            }
        });
        return;
    }
    range.length = MIN(self.ikLineDataArr.count, range.length);
    range.location = MIN(range.location, self.ikLineDataArr.count-1);
    _hasLast = NO;
    if (range.location+range.length>=self.ikLineDataArr.count) {
        NSInteger location = self.ikLineDataArr.count-range.length;
        range.location = MAX(0, location);
        _hasLast = YES;
    }
    NSArray *tem = [self.ikLineDataArr subarrayWithRange:range];
    ThreadSafeArray *dataList = [[ThreadSafeArray alloc] initWithArray:tem];
    if (dataList.count<=0) {
        return;
    }
    __block CGFloat maxPrice = CGFLOAT_MIN;
    __block CGFloat minPrice = CGFLOAT_MAX;
    __block CGFloat maxBOLLPrice = CGFLOAT_MIN;
    __block CGFloat minBOLLPrice = CGFLOAT_MAX;
    [dataList enumerateObjectsUsingBlock:^(CFDKLineData *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        maxPrice = MAX(maxPrice, cell.iHighp.floatValue);
        minPrice = MIN(minPrice, cell.iLowp.floatValue);
        if (cell.BOLLDic) {
            maxBOLLPrice = MAX(maxBOLLPrice, [cell.BOLLDic[@"up"] floatValue]);
            minBOLLPrice = MIN(minBOLLPrice, [cell.BOLLDic[@"dn"] floatValue]);
        }
    }];
    CGFloat max = MAX(maxPrice, maxBOLLPrice);
    CGFloat min = MIN(minPrice, minBOLLPrice);
    if (max-min>(maxPrice-minPrice)*1.5) {
        max = maxPrice+(maxPrice-minPrice)*0.25;
        min = minPrice-(maxPrice-minPrice)*0.25;
    }
    NSString *format = [DemoChartsModel stringFormatByDotNum:_nDotNum];
    NSString *maxStr=[NSString stringWithFormat:format,max];
    NSString *minStr=[NSString stringWithFormat:format,min];
    
    CFDKLineData *lineData= [_ikLineDataArr lastObject];
    NSString *lastPrice = [lineData iNowv];
    [self showView:dataList maxPrice:maxStr minPrice:minStr lastPrice:lastPrice isRed:lineData.isRed isSocketRefresh:NO];
    WEAK_SELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (weakSelf.axisHander) {
            NSDictionary *axisDic = @{@"left1":maxStr,@"left2":minStr,@"volNum":@"",@"lastPrice":lastPrice,@"isRed":@(lineData.isRed)};
            
            weakSelf.axisHander(axisDic);
        }
    });
}

- (void)showView:(NSArray *)dataList maxPrice:(NSString *)maxPrice minPrice:(NSString *)minPrice lastPrice:(NSString *)lastPrice isRed:(BOOL)isRed isSocketRefresh:(BOOL)isSocket{
    
    CFDKLineData *firstData = [NDataUtil dataWithArray:dataList index:1];
    CFDKLineData *lastData = [NDataUtil dataWithArray:dataList index:dataList.count-1];
    
    [_girlLayer drawGirdVLine:dataList];
//    [self drawLastDate:dataList];
    [self drawKLine:dataList maxPirce:maxPrice minPrice:minPrice lastPrice:lastPrice isRed:isRed];
    [self calIndexTopData:_indexTopType firstData:firstData lastData:lastData];
    [_indexTopLayer drawTopIndex:_indexTopType showDataList:dataList maxPrice:maxPrice minPrice:minPrice];
    if (_hasBottomIndex&&isSocket==NO) {
        [_indexVolLayer drawVolLine:dataList];
        [self calIndexData:_indexType firstData:firstData lastData:lastData];
        [self showBottomIndex:_indexType showDataList:dataList];
    }
    WEAK_SELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([weakSelf.showData count]==0)
        {
            weakSelf.lastPriceLine.hidden=
            weakSelf.bottomLayer.hidden =
            YES;
            return;
        }else{
            weakSelf.indexTopLayer.hidden =
            weakSelf.kLineLayer.hidden =
            NO;
            weakSelf.kLineLayer.barWidth  = self.barWidth;
            weakSelf.bottomLayer.hidden = !weakSelf.hasBottomIndex;
        }
        [weakSelf showCursorView];
    });
}


//MARK: - 指标计算
- (void)calIndexTopData:(EIndexTopType)type firstData:(CFDKLineData *)firstData lastData:(CFDKLineData *)lastData{
    if (type==EIndexTopTypeNone) {
        
    }else if (type==EIndexTopTypeMa){
        if (!firstData.MADic||!lastData.MADic) {
            [DemoChartsModel calMA:_ikLineDataArr dotNum:_nDotNum];
        }
    }else if (type==EIndexTopTypeBool){
        if (!firstData.BOLLDic||!lastData.BOLLDic) {
            [DemoChartsModel calBOLLData:_ikLineDataArr dotNum:_nDotNum];
        }
    }
}

- (void)calIndexData:(EIndexType)type firstData:(CFDKLineData *)firstData lastData:(CFDKLineData *)lastData{
    if (type==EIndexTypeMacd){
        if (!firstData.MACDDic||!lastData.MACDDic) {
            [DemoChartsModel calMACDData:_ikLineDataArr dotNum:_nDotNum];
        }
    }else if (type==EIndexTypeKdj){
        if (!firstData.KDJDic||!lastData.KDJDic) {
            [DemoChartsModel calKDJData:_ikLineDataArr dotNum:_nDotNum];
        }
    }else if (type==EIndexTypeRsi){
        if (!firstData.RSIDic||!lastData.RSIDic) {
            [DemoChartsModel calRSIData:_ikLineDataArr dotNum:_nDotNum];
        }
    }else if (type==EIndexTypeWR){
        if (!firstData.WRDic||!lastData.WRDic) {
            [DemoChartsModel calWRData:_ikLineDataArr dotNum:_nDotNum];
        }
    }else if (type==EIndexTypeBIAS){
        if (!firstData.BIASDic||!lastData.BIASDic) {
            [DemoChartsModel calBIASData:_ikLineDataArr dotNum:_nDotNum];
        }
    }else if (type==EIndexTypeCCI){
        if (!firstData.CCiDic||!lastData.CCiDic) {
            [DemoChartsModel calCCIData:_ikLineDataArr dotNum:_nDotNum];
        }
    }
}

- (void)showBottomIndex:(EIndexType)indexType showDataList:(NSArray *)dataList{
    [_bottomLayer showIndex:indexType];
    [_bottomLayer showBottomIndex:indexType showDataList:dataList];
    dispatch_async(dispatch_get_main_queue(), ^{    
        CFDKLineData *lastData = [[self getDataList] lastObject];
        if (lastData) {
            [self setIndexTopText:lastData];
            [self setIndexVolText:lastData];
            [self setIndexBottomText:lastData];
        }
    });
}

- (void)showIndexTop:(EIndexTopType)topType{
    [_indexTopLayer showIndexTop:topType];
    dispatch_async(dispatch_get_main_queue(), ^{
        CFDKLineData *lastData = [[self getDataList] lastObject];
        if (lastData) {
            [self setIndexTopText:lastData];
            [self setIndexVolText:lastData];
            [self setIndexBottomText:lastData];
        }
    });
}

- (void)showCursorView{
    _cursorView.nfenshiCount = _nfenshiCount;
    _cursorView.topLineH = _nfenshiheight;
    _cursorView.bottomLineH = self.height-_indexHeight;
    _cursorView.iMLineW = self.pointWidth;
    _cursorView.posotionList = self.iPositionArr;
    _cursorView.dataList = self.showData;
    _cursorView.axisCursorHander = _axisCursorHander;
    WEAK_SELF;
    _cursorView.indexCursorHander = ^(CFDKLineData *cell) {
        if (cell) {
            [weakSelf setIndexTopText:cell];
            [weakSelf setIndexVolText:cell];
            [weakSelf setIndexBottomText:cell];
        }else{
            CFDKLineData *lastData = [[weakSelf getDataList] lastObject];
            if (lastData) {
                [weakSelf setIndexTopText:lastData];
                [weakSelf setIndexVolText:lastData];
                [weakSelf setIndexBottomText:lastData];
            }
        }
    };
}

- (void)clear{
    _hasLoadedFromHttp = NO;
}

//MARK: - Getter Setter

- (void)setBottomAxisHander:(void (^)(NSDictionary * _Nonnull))bottomAxisHander{
    self.bottomLayer.bottomAxisHander = bottomAxisHander;
}

- (void)setIndexVolAxisHander:(void (^)(NSDictionary * _Nonnull))indexVolAxisHander{
    self.indexVolLayer.bottomAxisHander = indexVolAxisHander;
}

- (NSInteger)maxCount{
    return ((self.allWidth-_lineRight)/([GUIUtil fitLine]*4));
}

- (CGFloat)pointWidth{
    CGFloat pointWidth = (self.allWidth)/(self.nfenshiCount);
    return pointWidth;
}

- (CGFloat)barWidth{
    
    CGFloat lineWidth = MIN(self.pointWidth-[ChartsUtil fitLine]*2, [ChartsUtil fit:5]);
    lineWidth = MAX(lineWidth, self.pointWidth*2/3.0);
    NSInteger count = lineWidth*10/([ChartsUtil fitLine]*10);
    if (count<2) {
        count=2;
    }
    return [ChartsUtil fitLine]*count;
}


- (UIView *)lastPriceLine{
    if (!_lastPriceLine) {
        _lastPriceLine = [[UIView alloc] init];
        _lastPriceLine.backgroundColor = [ChartsUtil colorWithColorType:C14_ColorType alpha:0.4];
        _lastPriceLine.left = 0;
        _lastPriceLine.height = [ChartsUtil fitLine];
    }
    return _lastPriceLine;
}

- (CFDCursorView *)cursorView
{
    if(!_cursorView)
    {
        _cursorView = [[CFDCursorView alloc] initWithFrame:CGRectMake(0, 0, (self.frame.size.width-_lineRight), self.frame.size.height)];
    }
    return _cursorView;
}

- (CFDGirlLayer *)girlLayer{
    if (!_girlLayer) {
        _girlLayer = [[CFDGirlLayer alloc] init];
        
        WEAK_SELF;
        _girlLayer.pointWidth = ^CGFloat{
            return weakSelf.pointWidth;
        };
        _girlLayer.hCount = ^NSInteger{
            return weakSelf.hCount;
        };
    }
    return _girlLayer;
}

- (UILabel *)lastText{
    if (!_lastText) {
        _lastText = [[UILabel alloc] init];
        
        _lastText.font = [ChartsUtil fitFont:8];
        _lastText.textColor = [ChartsUtil C3]; _lastText.layer.anchorPoint=CGPointMake(1, 1);
        _lastText.bounds = CGRectMake(0, 0, 40, ceil([ChartsUtil fitFont:8].lineHeight));
        _lastText.textAlignment = NSTextAlignmentRight;
    }
    return _lastText;
}

- (CFDKlineLayer *)kLineLayer{
    if (!_kLineLayer) {
        _kLineLayer = [[CFDKlineLayer alloc] init];
    }
    return _kLineLayer;
}

- (CFDTopIndexLayer *)indexTopLayer{
    if (!_indexTopLayer) {
        _indexTopLayer = [[CFDTopIndexLayer alloc] init];
        WEAK_SELF;
        _indexTopLayer.getPointWidth = ^CGFloat{
            return weakSelf.pointWidth;
        };
    }
    return _indexTopLayer;
}

- (CFDBottomIndexLayer *)bottomLayer{
    if (!_bottomLayer) {
        _bottomLayer = [[CFDBottomIndexLayer alloc] init];
        WEAK_SELF;
        _bottomLayer.getBarWidth = ^CGFloat{
            return weakSelf.barWidth;
        };
        _bottomLayer.getPointWidth = ^CGFloat{
            return weakSelf.pointWidth;
        };
        
        _bottomLayer.hidden = !_hasBottomIndex;
    }
    return _bottomLayer;
}

- (CFDIndexVOLLayer *)indexVolLayer{
    if (!_indexVolLayer) {
        _indexVolLayer = [[CFDIndexVOLLayer alloc] init];
        WEAK_SELF;
        _indexVolLayer.pointWidth = ^CGFloat{
            return weakSelf.pointWidth;
        };
    }
    return _indexVolLayer;
}


- (CATextLayer *)indexTopTextLayer{
    if (!_indexTopTextLayer) {
        _indexTopTextLayer = [[CATextLayer alloc] init];
        _indexTopTextLayer.fontSize = [ChartsUtil fitFontSize:8];
        _indexTopTextLayer.foregroundColor = [ChartsUtil C2].CGColor;
        _indexTopTextLayer.anchorPoint=CGPointMake(0.5, 0);
        _indexTopTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _indexTopTextLayer.alignmentMode=kCAAlignmentLeft;
    }
    return _indexTopTextLayer;
}

- (CATextLayer *)indexVolTextLayer{
    if (!_indexVolTextLayer) {
        _indexVolTextLayer = [[CATextLayer alloc] init];
        _indexVolTextLayer.fontSize = [ChartsUtil fitFontSize:8];
        _indexVolTextLayer.foregroundColor = [ChartsUtil C2].CGColor;
        _indexVolTextLayer.anchorPoint=CGPointMake(0.5, 0);
        _indexVolTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _indexVolTextLayer.alignmentMode=kCAAlignmentLeft;
    }
    return _indexVolTextLayer;
}

- (CATextLayer *)indexTextLayer{
    if (!_indexTextLayer) {
        _indexTextLayer = [[CATextLayer alloc] init];
        _indexTextLayer.fontSize = [ChartsUtil fitFontSize:8];
        _indexTextLayer.foregroundColor = [ChartsUtil C2].CGColor;
        _indexTextLayer.anchorPoint=CGPointMake(0.5, 0);
        _indexTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _indexTextLayer.alignmentMode=kCAAlignmentLeft;
    }
    return _indexTextLayer;
}

- (void)setKLineDataArr:(NSArray *)kLineDataArr
{
    [_ikLineDataArr setArray:kLineDataArr];
}

- (NSArray *)getDataList
{
    return _ikLineDataArr;
}

- (NSArray *)getShowData
{
    return _showData;
}

//MARK: - Private

//蜡烛图的绘制
- (void)drawKLine:(NSArray *)dataList maxPirce:(NSString *)maxPrice minPrice:(NSString *)minPrice lastPrice:(NSString *)lastPrice isRed:(BOOL)isRed{
    
    CGMutablePathRef upThinPath = CGPathCreateMutable();
    CGMutablePathRef upThickPath = CGPathCreateMutable();
    CGMutablePathRef downThinPath = CGPathCreateMutable();
    CGMutablePathRef downThickPath = CGPathCreateMutable();
    NSMutableArray *pointList = [NSMutableArray array];
    CGFloat pointWidth= self.pointWidth;
    __block CGFloat x = 0.f;
    //绘制分时线与成交量
    [dataList enumerateObjectsUsingBlock:^(CFDKLineData *lineData, NSUInteger i, BOOL * _Nonnull stop) {
        x = (i)*pointWidth+[GUIUtil fitLine]/2;
        CGFloat highY = [self yByPrice:[lineData.iHighp floatValue] minPrice:minPrice maxPrice:maxPrice];
        CGFloat lowY = [self yByPrice:[lineData.iLowp floatValue] minPrice:minPrice maxPrice:maxPrice];
        CGFloat closeY = [self yByPrice:[lineData.iNowv floatValue] minPrice:minPrice maxPrice:maxPrice];
        CGFloat openY = [self yByPrice:[lineData.iOpenp floatValue] minPrice:minPrice maxPrice:maxPrice];
        if([NDataUtil IsInfOrNan:x] ||
           [NDataUtil IsInfOrNan:highY]||
           [NDataUtil IsInfOrNan:lowY]||
           [NDataUtil IsInfOrNan:openY]||
           [NDataUtil IsInfOrNan:closeY])
        {
            return;
        }
        CGMutablePathRef thinPath = nil;
        CGMutablePathRef thickPath = nil;
        if (lineData.isRed==NO) {
            thinPath = downThinPath;
            thickPath = downThickPath;
        }else{
            thinPath = upThinPath;
            thickPath = upThickPath;
        }
        CGPathMoveToPoint(thinPath, NULL, x, highY);
        CGPathAddLineToPoint(thinPath, NULL, x,lowY);
        if ([ChartsUtil compare:openY withFloat:closeY]==NSOrderedSame) {
            CGPathMoveToPoint(thickPath, NULL, x, openY+[ChartsUtil fitLine]);
            CGPathAddLineToPoint(thickPath, NULL, x, openY-[ChartsUtil fitLine]);
        }else{
            CGPathMoveToPoint(thickPath, NULL, x, openY);
            CGPathAddLineToPoint(thickPath, NULL, x, closeY);
        }
        //触碰点
        CGPoint point = CGPointMake(x, closeY);
        [pointList addObject:@(point)];
    }];

    self.iPositionArr = pointList;
    if ([dataList count] >= 1)
    {
        WEAK_SELF;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.showData setArray:dataList];
            weakSelf.maxPrice = maxPrice;
            weakSelf.minPrice = minPrice;
            [weakSelf.kLineLayer configUpThinPath:upThinPath upThickPath:upThickPath downThinPath:downThinPath downThickPath:downThickPath];
            [weakSelf drawLastLine:maxPrice minPrice:minPrice lastPrice:lastPrice lastX:x isRed:isRed];
            weakSelf.hasLoadedFromHttp = YES;
        });
    }
}


//最新价横线的绘制
- (void)drawLastLine:(NSString *)maxPrice minPrice:(NSString *)minPrice lastPrice:(NSString *)lastPrice lastX:(CGFloat)lastX isRed:(BOOL)isRed{
    //绘制最新价的横线
    _lastPriceLine.backgroundColor = [ChartsUtil C17];
    if([ChartsUtil compare:[lastPrice floatValue] withFloat:[maxPrice floatValue]]==NSOrderedDescending||
       [ChartsUtil compare:[lastPrice floatValue] withFloat:[minPrice floatValue]]==NSOrderedAscending){
        self.lastPriceLine.hidden = YES;
    }else{
        CGFloat lastRate = ([lastPrice floatValue]-[minPrice floatValue])/([maxPrice floatValue]-[minPrice floatValue]);
        lastRate = MAX(0, MIN(1, lastRate));
        CGFloat lastY= (1-lastRate)*_nfenshiheight;
        self.lastPriceLine.width=lastX;
        self.lastPriceLine.centerY = ceil_half(lastY);
        self.lastPriceLine.hidden=NO;
    }
}

//最新的时间显示
- (void)drawLastDate:(NSArray *)dataList
{
    WEAK_SELF;
    NSString *dateDraw = @"";
    CGFloat pointWidth= self.pointWidth;
    //屏上最后的时间点
    CGFloat x = self.showWidth;
    NSString *lastDate = @"";
    if (dateDraw.length==0&&dataList.count>15) {
        NSInteger index = x/pointWidth;
        if (index<dataList.count-1) {
            CFDKLineData *kline = [NDataUtil dataWithArray:dataList index:index];
            lastDate = kline.iTimeText;
        }else{
            CFDKLineData *kline = [NDataUtil dataWithArray:dataList index:dataList.count-1];
            lastDate = kline.iTimeText;
            x=(dataList.count-1)*pointWidth;
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        weakSelf.lastText.hidden = weakSelf.showData.count>weakSelf.hCount;
        weakSelf.lastText.text = lastDate;
        weakSelf.lastText.center = CGPointMake(ceil(x), ceil(weakSelf.nfenshiheight));
    });
    
}

//计算y值
- (CGFloat)yByPrice:(CGFloat)curp minPrice:(NSString *)minPrice maxPrice:(NSString *)maxPrice{
    //分时线
    CGFloat padding = [maxPrice floatValue]-[minPrice floatValue];
    if (padding==0) {
        return _nfenshiheight;
    }
    CGFloat rate = (curp-[minPrice floatValue])/padding;
    rate = MAX(0, MIN(1, rate));
    CGFloat y= (1-rate)*_nfenshiheight;
    return y;
}

- (void)setIndexTopText:(CFDKLineData *)cell{
    if (self.indexTopType==EIndexTopTypeNone) {
        self.indexTopTextLayer.string = @"";
    }else if (self.indexTopType==EIndexTopTypeMa){
        NSDictionary *MADic = cell.MADic;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"MA(5,10,30) "];
        attStr.color = [GColorUtil C2];
        if (cell.MADic==nil) {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"· MA5" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C13]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"  · MA10" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C1100]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"  · MA30" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C20]}]];
        }else{
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"MA5:%@ ",MADic[@"MA5"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C13]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"MA10:%@ ",MADic[@"MA10"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C1100]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"MA30:%@ ",MADic[@"MA30"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C20]}]];
        }
        attStr.font = [GUIUtil fitFont:8];
        self.indexTopTextLayer.string = attStr;
    }else if (self.indexTopType==EIndexTopTypeBool){
        NSDictionary *BOLLDic = cell.BOLLDic;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"BOLL(20,2) "];
        attStr.color = [GColorUtil C2];
        if (cell.BOLLDic==nil) {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"· Mid" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C13]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"  · Upper" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C1100]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"  · Lower" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C20]}]];
        }else{
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"Mid:%@ ",BOLLDic[@"mb"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C13]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"Upper:%@ ",BOLLDic[@"up"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C1100]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"Lower:%@ ",BOLLDic[@"dn"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C20]}]];
        }
        attStr.font = [GUIUtil fitFont:8];
        self.indexTopTextLayer.string = attStr;
    }
}

- (void)setIndexVolText:(CFDKLineData *)cell{
    NSDictionary *volDic = cell.volDic;
    NSString *vol = [NDataUtil stringWith:volDic[@"vol"] valid:@"0"];
    NSString *value = [NDataUtil stringWith:volDic[@"value"] valid:@"0"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@ %@：%@",CFDLocalizedString(@"成交量"),vol,CFDLocalizedString(@"成交额"),value]];
    attStr.font = [GUIUtil fitFont:8];
    attStr.color = [ChartsUtil C2];
    self.indexVolTextLayer.string = attStr;
}

- (void )setIndexBottomText:(CFDKLineData *)cell{
    
    self.indexTextLayer.hidden = NO;
    if (self.indexType==EIndexTypeNone) {
        self.indexTextLayer.hidden = YES;
    }else if (self.indexType==EIndexTypeKdj){
        NSDictionary *KDJDic = cell.KDJDic;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"KDJ(9,3,3) "];
        attStr.color = [ChartsUtil C2];
        if (cell.KDJDic==nil) {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"· K" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C20]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"  · D" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C13]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"  · J" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C1100]}]];
        }else{
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"K:%@ ",KDJDic[@"k"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C20]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"D:%@ ",KDJDic[@"d"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C13]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"J:%@ ",KDJDic[@"j"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C1100]}]];
        }
        attStr.font = [GUIUtil fitFont:8];
        self.indexTextLayer.string = attStr;
    }else if (self.indexType==EIndexTypeMacd){
        NSDictionary *kMACDDic = cell.MACDDic;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"MACD(12,26,9) "];
        attStr.color = [ChartsUtil C2];
        if (cell.MACDDic==nil) {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"· DIF" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C13]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"  · DEA" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C1100]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"  · MACD" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C9]}]];
        }else{
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"DIF:%@ ",kMACDDic[@"dif"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C13]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"DEA:%@ ",kMACDDic[@"dea"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C1100]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"MACD:%@ ",kMACDDic[@"bar"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C9]}]];
        }
        attStr.font = [GUIUtil fitFont:8];
        self.indexTextLayer.string = attStr;
    }else if (self.indexType==EIndexTypeRsi){
        NSDictionary *RSIDic = cell.RSIDic;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"RSI(6,12,24) "];
        attStr.color = [ChartsUtil C2];
        if (cell.RSIDic==nil) {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"· RSI1" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C20]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"  · RSI2" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C13]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"  · RSI3" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C1100]}]];
        }else{
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"RSI1:%@ ",RSIDic[@"rsi1"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C20]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"RSI2:%@ ",RSIDic[@"rsi2"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C13]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"RSI3:%@ ",RSIDic[@"rsi3"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C1100]}]];
        }
        attStr.font = [GUIUtil fitFont:8];
        self.indexTextLayer.string = attStr;
    }else if (self.indexType==EIndexTypeWR){
        NSDictionary *WRDic = cell.WRDic;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"WR(10,6) "];
        attStr.color = [ChartsUtil C2];
        if (cell.WRDic==nil) {
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"· WR1" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C1100]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"  · WR2" attributes:@{NSForegroundColorAttributeName:[ChartsUtil C13]}]];
        }else{
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"WR1:%@ ",WRDic[@"wr1"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C1100]}]];
            [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"WR2:%@ ",WRDic[@"wr2"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C13]}]];
        }
        attStr.font = [GUIUtil fitFont:8];
        self.indexTextLayer.string = attStr;
    }else if (self.indexType==EIndexTypeBIAS){
        NSDictionary *BIASDic = cell.BIASDic;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"BIAS(6,12,24) "];
        attStr.color = [ChartsUtil C2];
        [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"BIAS1:%@ ",BIASDic[@"bias1"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C20]}]];
        [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"BIAS2:%@ ",BIASDic[@"bias2"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C13]}]];
        [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"BIAS3:%@ ",BIASDic[@"bias3"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C1100]}]];
        attStr.font = [GUIUtil fitFont:8];
        self.indexTextLayer.string = attStr;
    }else if (self.indexType==EIndexTypeCCI){
        NSDictionary *CCiDic = cell.CCiDic;
        NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:@"CCI(14) "];
        attStr.color = [ChartsUtil C2];
        [attStr appendAttributedString:[[NSAttributedString alloc]initWithString:[NSString stringWithFormat:@"CCI:%@ ",CCiDic[@"cci"]] attributes:@{NSForegroundColorAttributeName:[ChartsUtil C1100]}]];
        attStr.font = [GUIUtil fitFont:8];
        self.indexTextLayer.string = attStr;
    }
}

@end

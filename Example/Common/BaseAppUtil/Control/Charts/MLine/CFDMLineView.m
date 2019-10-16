//
//  MlineView.m
//  nntj_ftox
//
//  Created by zhangchangqing on 2017/10/12.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#define POINT(_INDEX_) [(NSValue *)[points objectAtIndex:_INDEX_] CGPointValue]

#import "CFDMLineView.h"
#import "CFDCursorView.h"
#import "CFDScrollView.h"
#import "DemoChartsModel.h"
#import "CFDGirlLayer.h"

#import "CFDTopIndexLayer.h"
#import "CFDIndexVOLLayer.h"
#import "CFDBottomIndexLayer.h"

@interface CFDMLineView()

@property(nonatomic,strong)CFDCursorView *cursorView;

@property (nonatomic,strong)CFDGirlLayer *girlLayer;
@property (nonatomic,strong)UILabel *lastText;
@property(nonatomic,strong)BaseImageView *lastPriceImg;

@property(nonatomic,strong)BaseView* lastPriceLine;

@property (nonatomic,strong)CAShapeLayer *shareLayer;
@property (nonatomic,strong)CAShapeLayer *gradientLayer;
@property (nonatomic,strong)CAGradientLayer *fillLayer;

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
@property (nonatomic,strong)NSOperationQueue *queue;
//http返回的数据是否已经绘图，（socket绘图需等http的绘完才能绘图）
@property (nonatomic,assign) BOOL hasLoadedFromHttp;
@end

@implementation CFDMLineView


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
    }
    return self;
}

- (void)setupUI{
    //时间轴及线
    [self.layer addSublayer:self.girlLayer];
    //分时
    [self.layer addSublayer:self.shareLayer];
    [self.layer addSublayer:self.fillLayer];
    //可选的指标
    [self.layer addSublayer:self.bottomLayer];
    //固定的指标（成交量图）
    [self.layer addSublayer:self.indexVolLayer];
    
    //最新的点
    {
        [self addSubview:self.lastText];
        [self addSubview:self.lastPriceLine];
        [self addSubview:self.lastPriceImg];
    }
    //十字线
    [self addSubview:self.cursorView];
    
    [self.layer addSublayer:self.indexVolTextLayer];
    [self.layer addSublayer:self.indexTextLayer];
    
 
    
}


- (void)defaultData{
    _allWidth = self.width;
    _lineRight = CLineRight;
    if (_hasBottomIndex) {
        CGFloat mainChartH = _indexType==EIndexTypeNone?CMainChartHight:CMainChartHight-CIndexChartHight;
        _nfenshiheight =  mainChartH;
        _indexHeight = CIndexChartHight;
    }else{
        _nfenshiheight = self.height-CTimeAixsHight;
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
        _nfenshiheight = self.height-CTimeAixsHight;
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
    
    
    self.gradientLayer.frame =
    self.fillLayer.frame     =
    self.shareLayer.frame    = CGRectMake(0, 0, self.width, self.nfenshiheight);
    self.girlLayer.frame     = CGRectMake(0, 0, self.width, self.height-CTimeAixsHight);
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
            weakSelf.fillLayer.hidden=
            weakSelf.shareLayer.hidden=
            weakSelf.lastPriceImg.hidden=
            weakSelf.lastPriceLine.hidden=
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
 
    [dataList enumerateObjectsUsingBlock:^(CFDMLineData *cell, NSUInteger idx, BOOL * _Nonnull stop) {
        maxPrice = MAX(maxPrice, cell.iNowv.floatValue);
        minPrice = MIN(minPrice, cell.iNowv.floatValue);
    }];
    CGFloat max = maxPrice;
    CGFloat min = minPrice;
    max = maxPrice+(maxPrice-minPrice)*0.03;
    min = minPrice-(maxPrice-minPrice)*0.03;
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
    [self drawLastDate:dataList];
    [self drawShareTime:dataList maxPirce:maxPrice minPrice:minPrice lastPrice:lastPrice isRed:isRed];
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
            weakSelf.fillLayer.hidden=
            weakSelf.shareLayer.hidden=
            weakSelf.lastPriceImg.hidden=
            weakSelf.lastPriceLine.hidden=
            YES;
            return;
        }else{
            weakSelf.shareLayer.hidden =
            weakSelf.fillLayer.hidden=
            NO;
            weakSelf.bottomLayer.hidden = !weakSelf.hasBottomIndex;
        }
        [weakSelf showCursorView];
    });
}


//MARK: - 指标计算

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
            [weakSelf setIndexVolText:cell];
            [weakSelf setIndexBottomText:cell];
        }else{
            CFDKLineData *lastData = [[weakSelf getDataList] lastObject];
            if (lastData) {
                [weakSelf setIndexVolText:lastData];
                [weakSelf setIndexBottomText:lastData];
            }
        }
    };
}

- (void)clear{
    _hasLoadedFromHttp = NO;
}

- (void)setDateBgColor:(UIColor *)color{
    _girlLayer.dateBgLayer.backgroundColor = color.CGColor;
}

//MARK: - Getter Setter

- (void)setBottomAxisHander:(void (^)(NSDictionary * _Nonnull))bottomAxisHander{
    self.bottomLayer.bottomAxisHander = bottomAxisHander;
}

- (void)setIndexVolAxisHander:(void (^)(NSDictionary * _Nonnull))indexVolAxisHander{
    self.indexVolLayer.bottomAxisHander = indexVolAxisHander;
}

- (CGFloat)pointWidth{
    CGFloat pointWidth = (self.allWidth)/(self.nfenshiCount);
    return pointWidth;
}

//分时最大点数
- (NSInteger)maxCount{
    return ((self.allWidth-_lineRight)/([GUIUtil fitLine]*3));
}

- (CGFloat)barWidth{
//    CGFloat barWidth = 2/3.0*self.pointWidth;
//    if (barWidth<1.5) {
//        barWidth=
//    }
    return [GUIUtil fit:1];
}


- (BaseView *)lastPriceLine{
    if (!_lastPriceLine) {
        _lastPriceLine = [[BaseView alloc] init];
        _lastPriceLine.backgroundColor = [ChartsUtil colorWithColorType:C13_ColorType alpha:0.4];
        _lastPriceLine.left = 0;
        _lastPriceLine.height = [ChartsUtil fitLine];
    }
    return _lastPriceLine;
}

- (BaseImageView *)lastPriceImg
{
    if (!_lastPriceImg) {
        _lastPriceImg=[[BaseImageView alloc]initWithFrame:CGRectMake(0, 0, 6, 6)];
        _lastPriceImg.bgColor = C21_ColorType;
        _lastPriceImg.layer.cornerRadius = 3;
        _lastPriceImg.layer.masksToBounds = YES;
        _lastPriceImg.hidden=YES;
    }
    return _lastPriceImg;
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

- (CAShapeLayer *)shareLayer{
    if (!_shareLayer) {
        _shareLayer = [[CAShapeLayer alloc] init];
        _shareLayer.fillColor = [UIColor clearColor].CGColor;
        _shareLayer.strokeColor   = [ChartsUtil C13].CGColor;      //设置划线颜色
        _shareLayer.lineCap = kCALineCapRound;
        _shareLayer.lineJoin = kCALineJoinRound;
        _shareLayer.lineWidth     = [ChartsUtil fitLine]*2;          //设置线宽
        
    }
    return _shareLayer;
}

- (CAShapeLayer *)gradientLayer{
    if (!_gradientLayer) {
        
        _gradientLayer = [[CAShapeLayer alloc] init];
        
        _gradientLayer.fillColor = [ChartsUtil C13:0.1].CGColor;
        _gradientLayer.strokeColor   = [UIColor clearColor].CGColor;      //设置划线颜色
        _gradientLayer.lineWidth     = [ChartsUtil fitLine]*2;          //设置线宽
    }
    return _gradientLayer;
}

- (CAGradientLayer *)fillLayer{
    if (!_fillLayer) {
        _fillLayer =  [[CAGradientLayer alloc] init];
        _fillLayer.colors = @[(__bridge id)[ChartsUtil C13:1].CGColor,(__bridge id)[ChartsUtil C13:1].CGColor,(__bridge id)[ChartsUtil C13:0.2].CGColor,(__bridge id)[ChartsUtil C13:0.2].CGColor];
        _fillLayer.locations = @[@(0),@(0.3),@(0.6),@(1)];
        _fillLayer.startPoint = CGPointMake(0, 0);
        _fillLayer.endPoint = CGPointMake(0, 1);
    }
    return _fillLayer;
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

- (void)drawShareTime:(NSArray *)dataList maxPirce:(NSString *)maxPrice minPrice:(NSString *)minPrice lastPrice:(NSString *)lastPrice isRed:(BOOL)isRed{
    CGMutablePathRef sharePath = CGPathCreateMutable();
    NSMutableArray *pointList = [NSMutableArray array];
    CGFloat x = 0.f;
    CGFloat y =0.f;
    CGFloat pointWidth= self.pointWidth;
    //绘制分时线与成交量
    for (int i=0;i<[dataList count];i++)
    {
        CFDMLineData *cell = [NDataUtil dataWithArray:dataList index:i];
        CGFloat curp = [cell.iNowv floatValue];
        x = i*pointWidth;
        //分时线
        CGFloat rate = (curp-[minPrice floatValue])/([maxPrice floatValue]-[minPrice floatValue]);
        rate = MAX(0, MIN(1, rate));
        y= (1-rate)*_nfenshiheight;
        if([NDataUtil IsInfOrNan:x] ||
           [NDataUtil IsInfOrNan:y])
        {
            return;
        }
        //触碰点
        CGPoint point = CGPointMake(x, y);
        [pointList addObject:@(point)];
    }
    if (dataList.count>4) {
        sharePath = [self smoothedPathWithPoints:pointList andGranularity:3];
    }else{
        for (NSInteger i=0; i<pointList.count; i++) {
            CGPoint point = [pointList[i] CGPointValue];
            //分时的点
            if (i==0) {
                CGPathMoveToPoint(sharePath, NULL, point.x, point.y);
            }else{
                CGPathAddLineToPoint(sharePath, NULL, point.x,point.y);
            }
        }
    }
    self.iPositionArr = pointList;
    if ([dataList count] >1 )//如果等于1会整个蓝框
    {
        CGMutablePathRef fillPath = CGPathCreateMutableCopy(sharePath);
        CGPathAddLineToPoint(fillPath, NULL, x, _nfenshiheight);
        CGPathAddLineToPoint(fillPath, NULL, 0, _nfenshiheight);
        CGPathCloseSubpath(fillPath);
        
        WEAK_SELF;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.showData setArray:dataList];
            weakSelf.maxPrice = maxPrice;
            weakSelf.minPrice = minPrice;
            [weakSelf configDataOfShareLayer:sharePath];
            [weakSelf configDataOfGradientLayer:fillPath];
            [weakSelf drawLastLine:maxPrice minPrice:minPrice lastPrice:lastPrice lastX:x isRed:isRed];
            [weakSelf drawLastPoint:CGPointMake(x, y) maxPirce:maxPrice minPrice:minPrice lastPrice:lastPrice];
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
        self.lastPriceLine.bottom = ceil(lastY);
        self.lastPriceLine.hidden=NO;
    }
}

- (void)drawLastPoint:(CGPoint )point maxPirce:(NSString *)maxPrice minPrice:(NSString *)minPrice lastPrice:(NSString *)lastPrice{
    //最新价闪烁效果
    if (_isClose==NO&&_hasLast)
    {
        self.lastPriceImg.center=CGPointMake(point.x, point.y);
        self.lastPriceImg.hidden=NO;
    }
    else{
        self.lastPriceImg.hidden=YES;
    }
}

//最新的时间显示
- (void)drawLastDate:(NSArray *)dataList
{
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
//    dispatch_async(dispatch_get_main_queue(), ^{
//        weakSelf.lastText.hidden = weakSelf.showData.count>weakSelf.hCount;
//        weakSelf.lastText.text = lastDate;
//        weakSelf.lastText.center = CGPointMake(ceil(x), ceil(weakSelf.nfenshiheight));
//    });
    
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

- (CGMutablePathRef )smoothedPathWithPoints:(NSArray *) pointsArray andGranularity:(NSInteger)granularity {
    
    NSMutableArray *points = [pointsArray mutableCopy];
    
    
    CGMutablePathRef smoothedPath = CGPathCreateMutable();
    // Add control points to make the math make sense
    [points insertObject:[points objectAtIndex:0] atIndex:0];
    [points addObject:[points lastObject]];
    
    CGPathMoveToPoint(smoothedPath, NULL, POINT(0).x, POINT(0).y);
    for (NSUInteger index = 1; index < points.count - 2; index++) {
        CGPoint p0 = POINT(index - 1);
        CGPoint p1 = POINT(index);
        CGPoint p2 = POINT(index + 1);
        CGPoint p3 = POINT(index + 2);
        
        // now add n points starting at p1 + dx/dy up until p2 using Catmull-Rom splines
        for (int i = 1; i < granularity; i++) {
            float t = (float) i * (1.0f / (float) granularity);
            float tt = t * t;
            float ttt = tt * t;
            
            CGPoint pi; // intermediate point
            pi.x = 0.5 * (2*p1.x+(p2.x-p0.x)*t + (2*p0.x-5*p1.x+4*p2.x-p3.x)*tt + (3*p1.x-p0.x-3*p2.x+p3.x)*ttt);
            pi.y = 0.5 * (2*p1.y+(p2.y-p0.y)*t + (2*p0.y-5*p1.y+4*p2.y-p3.y)*tt + (3*p1.y-p0.y-3*p2.y+p3.y)*ttt);
            CGPathAddLineToPoint(smoothedPath, NULL, pi.x, pi.y);
        }
        // Now add p2
        CGPathAddLineToPoint(smoothedPath, NULL, p2.x, p2.y);
        
    }
    CGPathAddLineToPoint(smoothedPath, NULL, POINT(points.count - 1).x, POINT(points.count - 1).y);
    // finish by adding the last point
    return smoothedPath;
}


- (void)setIndexVolText:(CFDKLineData *)cell{
    NSDictionary *volDic = cell.volDic;
    NSString *vol = [NDataUtil stringWith:volDic[@"vol"] valid:@"0"];
    NSString *value = [NDataUtil stringWith:volDic[@"value"] valid:@"0"];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@：%@ %@：%@",CFDLocalizedString(@"成交量"),vol,CFDLocalizedString(@"成交额"),value]];
    attStr.font = [GUIUtil fitFont:8];
    attStr.color = [ChartsUtil C2];
    self.indexVolTextLayer.string = attStr;
    self.indexVolTextLayer.hidden = _isSingleCharts;
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

- (void)configDataOfShareLayer:(CGPathRef)path{
    
    _shareLayer.path= path;
    CGPathRelease(path);
}
- (void)configDataOfGradientLayer:(CGPathRef)path{
    _gradientLayer.path = path;
    _fillLayer.mask = _gradientLayer;
    CGPathRelease(path);
}

@end



//  FTOXMarketChartView.m
//  niuguwang
//
//  Created by ddsfsdfsd on 2016/11/6.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "CFDMarketChartView.h"
#import "CFDKLineButtonView.h"
#import "CFDHqDefine.h"


@interface  CFDMarketChartView()<UIGestureRecognizerDelegate>


@property (nonatomic,strong)  UIView  *minuteSelectViewBackg;

@property (nonatomic,assign)  NSInteger nChartLeftPos; //框的x坐标
@property (nonatomic,assign)  NSInteger nChartWidth;//框的宽度
@property (nonatomic,strong)  CFDKLineButtonView *kLineButtonView;

@property (nonatomic,strong)  UITapGestureRecognizer *singleFingerTap;
@property (nonatomic,assign)  EChartsType chartsType;
@property(nonatomic,assign)BOOL hasVol;

// segment数据
@property (nonatomic,strong) NSArray <NSDictionary *>*titles;
// segment横屏数据
@property (nonatomic,strong) NSArray <NSDictionary *>*hTitles;

@end

@implementation CFDMarketChartView

- (void)dealloc
{
    _kLineView = nil;
    _mLineView = nil;
    _kLineButtonView = nil;
}

- (id)initWithTitles:(NSArray<NSDictionary *> *)titles hTitles:(NSArray <NSDictionary *>*)hTitles frame:(CGRect)frame hasVol:(BOOL)hasVol{
    if (self = [super initWithFrame:frame]) {
        _hasVol = hasVol;
        _titles = titles;
        _hTitles=hTitles;
        [self initSome];
    }
    return self;
}

- (void)initSome
{
    self.backgroundColor = [ChartsUtil chartsBgColor];
    _nChartLeftPos = 0;
    _nChartWidth = SCREEN_WIDTH;

   [self addSubview:self.kLineButtonView];

    [self addSubview:self.kLineView];
   [self addSubview:self.mLineView];

}

//MARK: - Action

- (void)clickedButtonList:(NSInteger)index{
    [_kLineButtonView clickedButtonList:index];
}

//MARK: - 赋值 绘图

- (void)configSocketMlineData:(NSArray *)mlineList hasNewPoint:(BOOL)hasNewPoint{
    [_mLineView configSocketChart:mlineList hasNewPoint:hasNewPoint];
}

- (void)configMlineData:(NSArray *)mlineList{

    [_mLineView configChart:mlineList];
}


- (void)configSocketKlineData:(NSArray *)mlineList hasNewPoint:(BOOL)hasNewPoint{
    
    [_kLineView configSocketChart:mlineList hasNewPoint:hasNewPoint];
}

- (void)configKlineData:(NSArray *)klineList{
    
    [_kLineView configChart:klineList];
}

- (void)configKlineMoreData:(NSArray *)klineList moreCount:(NSInteger)moreCount{
    [_kLineView configChart:klineList moreCount:moreCount];
}


- (void)setSelectHQBtn:(EChartsType)chartsType
{
    [self.kLineButtonView hideSelectedView];
    _chartsType = chartsType;
    [self showCurrentView];
    if (self.selectBar) {
        self.selectBar(chartsType);
    }
}
//MARK: - 横竖屏切换
//横屏切竖屏
- (void)hChartToVChart
{
    
    _kLineButtonView.frame = CGRectMake(0, 0,SCREEN_WIDTH, CButtonListHight);
    [_kLineButtonView  hChartToVChart];
    
    _mLineView.frame = CGRectMake(_nChartLeftPos, _kLineButtonView.bottom, _nChartWidth, CHeight-CButtonListHight);;
    [_mLineView  hChartToVChart];
    [_mLineView hChartToVShowInfo];

    _kLineView.frame = CGRectMake(_nChartLeftPos, _kLineButtonView.bottom, _nChartWidth, CHeight-CButtonListHight);
    [_kLineView hChartToVChart];
    [_kLineView hChartToVShowInfo];
}

//竖屏切横屏
- (void)vChartToHChart
{
    NSInteger nChartLeftPos = IS_IPHONE_X?40:5;
    NSInteger nChartWidth = SCREEN_HEIGHT -nChartLeftPos-IPHONE_X_BOTTOM_HEIGHT-_hsRight;
    _kLineButtonView.frame = CGRectMake(nChartLeftPos, [ChartsUtil fit:5], nChartWidth, [ChartsUtil fit:35]);
    [_kLineButtonView vChartToHChart];

    _mLineView.frame =  CGRectMake(nChartLeftPos, _kLineButtonView.bottom, nChartWidth, self.height -_kLineButtonView.bottom-[ChartsUtil fit:10]);
    [_mLineView  vChartToHChart];
    [_mLineView vChartToHShowInfo];
    
    _kLineView.frame = CGRectMake(nChartLeftPos, _kLineButtonView.bottom, nChartWidth, self.height -_kLineButtonView.bottom-[ChartsUtil fit:10]);
    [_kLineView vChartToHChart];
    [_kLineView vChartToHShowInfo];
}

//MARK: - Getter

- (void)setLoadMore:(void (^)(dispatch_block_t))loadMore{
    _loadMore = loadMore;
    self.kLineView.loadMore = loadMore;
}

- (void)setIsClose:(BOOL)isClose{
    _isClose = isClose;
    _mLineView.isClose = isClose;
}

- (CFDKLineButtonView*)kLineButtonView
{
    if (!_kLineButtonView) {
       
        _kLineButtonView = [[CFDKLineButtonView alloc] initWithTitles:_titles hTitles:_hTitles frame:CGRectMake(0, 0, SCREEN_WIDTH, CButtonListHight)];
        WEAK_SELF;
        _kLineButtonView.selectedChartsHander = ^(EChartsType chartsType) {
            [weakSelf setSelectHQBtn:chartsType];
        };
        _kLineButtonView.getChartsSelectedIndex = ^NSMutableDictionary *{
            if (weakSelf.chartsType == EChartsType_RT) {
                NSMutableDictionary *dic = @{@"topIndex":@(weakSelf.mLineView.indexTopType),@"bottomIndex":@(weakSelf.mLineView.indexType)}.mutableCopy;
                return dic;
            }else{
                NSMutableDictionary *dic = @{@"topIndex":@(weakSelf.kLineView.indexTopType),@"bottomIndex":@(weakSelf.kLineView.indexType)}.mutableCopy;
                return dic;
            }
        };
        _kLineButtonView.selectedIndexHander = ^(NSMutableDictionary *dic) {
            
            if (weakSelf.chartsType == EChartsType_RT) {
                if (dic) {
                    EIndexTopType topType = [dic[@"topIndex"] integerValue];
                    EIndexType type = [dic[@"bottomIndex"] integerValue];
                    [weakSelf.mLineView changedTopIndex:topType];
                    [weakSelf.mLineView changedIndex:type];
                }
            }else{
                if (dic) {                
                    EIndexTopType topType = [dic[@"topIndex"] integerValue];
                    EIndexType type = [dic[@"bottomIndex"] integerValue];
                    [weakSelf.kLineView changedTopIndex:topType];
                    [weakSelf.kLineView changedIndex:type];
                    [weakSelf.mLineView changedTopIndex:topType];
                    [weakSelf.mLineView changedIndex:type];
                }
            }
        };
    }
    return _kLineButtonView;
}

- (MLineChartView*)mLineView
{
    if (!_mLineView) {
        CGRect rect = CGRectMake(_nChartLeftPos, _kLineButtonView.bottom, _nChartWidth, self.height -_kLineButtonView.bottom);
        _mLineView = [[MLineChartView alloc] initWithFrame:rect hasVol:_hasVol];
        
        WEAK_SELF;
        _mLineView.hitSwitchH = ^{
            [weakSelf vChartToHChart];
        };
    }
    return _mLineView;
}

- (KLineChartsView*)kLineView
{
    if (!_kLineView) {
        CGRect rect = CGRectMake(_nChartLeftPos, _kLineButtonView.bottom, _nChartWidth, self.height -_kLineButtonView.bottom);
        _kLineView = [[KLineChartsView alloc] initWithFrame:rect hasVol:YES];
        
        WEAK_SELF;
        _kLineView.hitSwitchH = ^{
            [weakSelf vChartToHChart];
        };
    }
    return _kLineView;
}



- (EChartsType)selectMinuteBtnToChartsType:(NSInteger)selectMinuteBtn
{
    EChartsType chartsType = EChartsType_RT;
    switch (selectMinuteBtn) {
        case 0:
            chartsType = EChartsType_RT;
            break;
        case 1:
            chartsType = EChartsType_KL_1;
            break;
        case 2:
            chartsType = EChartsType_KL_3;
            break;
        case 3:
            chartsType = EChartsType_KL_5;
            break;
        case 4:
            chartsType = EChartsType_KL_15;
            break;
        default:
            chartsType = EChartsType_RT;
            break;
    }
    return chartsType;
}


//MARK: - Private

//根据当前行情类型，显示正确的viwe
- (void)showCurrentView
{
    if (_chartsType == EChartsType_RT) {
        _kLineView.hidden = YES;
        _mLineView.hidden  = NO;
        [_mLineView changedIndex:_kLineView.indexType];
        [_mLineView changedTopIndex:_kLineView.indexTopType];
    }else{
        _kLineView.hidden = NO;
        _mLineView.hidden = YES;
        [_kLineView changedIndex:_mLineView.indexType];
        [_kLineView changedTopIndex:_mLineView.indexTopType];
    }
}


@end

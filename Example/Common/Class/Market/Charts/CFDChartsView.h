//
//  CFDChartsView.h
//  globalwin
//
//  Created by ngw15 on 2018/8/1.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CFDMarketChartView.h"

@protocol CFDChartsDelegate

- (void)updateBaseInfo:(CFDBaseInfoModel *)model;
- (void)disenableScroll:(BOOL)flag;
- (void)switchsScreenToH;
- (void)switchsScreenToV;
@end

@interface CFDChartsView : UIView

@property (nonatomic,weak) id<CFDChartsDelegate> delegate;
@property (nonatomic,strong) CFDMarketChartView *chartView;
@property (nonatomic,assign) EChartsType chartsType;

@property (nonatomic,assign) BOOL isLS;
///是否要绘制成交量
@property (nonatomic,assign) BOOL hasVol;
///竖屏下该视图高度
@property (nonatomic,assign) CGFloat vHeight;
///横屏下顶部预留高度
@property (nonatomic,assign) CGFloat hsTopHeight;
///横屏下右边预留高度
@property (nonatomic,assign) CGFloat hsRight;

- (instancetype)initWithVHeight:(CGFloat)vHeihgt symbol:(NSString *)symbol;

- (void)willAppear;
- (void)willDisappear;
- (void)loadKline;
- (void)websocketLoad;

- (void)changedSymbol:(NSString *)symbol;
- (void)changedLineType:(EChartsLineType)type;

- (void)hitSwitchH;
///isClose:是否休市
- (void)reloadCharts:(EChartsType)chartsType isClose:(BOOL)isClose;
- (void)clickedButtonList:(NSInteger)index;
- (void)clearData;
@end

//
//  FTOXMarketChartView.h
//  niuguwang
//
//  Created by ddsfsdfsd on 2016/11/6.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//  分时与k线的绘图控件

#import <UIKit/UIKit.h>
#import "CFDMLineView.h"
#import "MLineChartView.h"
#import "KLineChartsView.h"


@interface CFDMarketChartView : UIView
///休市状态
@property (nonatomic,assign)BOOL isClose;

@property (nonatomic,strong)  MLineChartView  *mLineView;
@property (nonatomic,strong)  KLineChartsView  *kLineView;
@property(nonatomic,copy)void(^selectBar)(EChartsType EChartsType);
@property(nonatomic,copy)void(^loadMore)(dispatch_block_t);

@property (nonatomic,assign) CGFloat hsRight;

- (id)initWithTitles:(NSArray<NSDictionary *> *)titles hTitles:(NSArray <NSDictionary *>*)hTitles frame:(CGRect)frame hasVol:(BOOL)hasVol;

- (void)configSocketMlineData:(NSArray *)mlineList hasNewPoint:(BOOL)hasNewPoint;
- (void)configMlineData:(NSArray *)mlineList;
- (void)configSocketKlineData:(NSArray *)mlineList hasNewPoint:(BOOL)hasNewPoint;
- (void)configKlineData:(NSArray *)mlineList;
- (void)configKlineMoreData:(NSArray *)klineList moreCount:(NSInteger)moreCount;
- (void)clickedButtonList:(NSInteger)index;
//竖屏切横屏
- (void)vChartToHChart;

//横屏切竖屏
- (void)hChartToVChart;
@end

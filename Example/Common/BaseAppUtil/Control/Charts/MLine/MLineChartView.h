//
//  TimeShareChartScrollView.h
//  coinare_ftox
//
//  Created by ngw15 on 2018/7/20.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//  分时图控件（有手势，数据的处理）

#import <UIKit/UIKit.h>
#import "CFDMLineView.h"
#import "CFDScrollView.h"


@interface MLineChartView : UIView

///休市状态
@property (nonatomic,assign)BOOL isClose;

@property (nonatomic,strong)CFDScrollView *scrollView;
@property (nonatomic,strong) CFDMLineView *chartView;
@property (nonatomic,assign) BOOL isPinching;
@property (nonatomic,assign) BOOL isPaning;
@property (nonatomic,assign) BOOL isDragging;

//@property (nonatomic,copy) NSString *closePrice;
@property (nonatomic,assign) BOOL isFirst;

@property (nonatomic,assign) BOOL isSingleCharts;
@property (nonatomic,assign)NSInteger dotNum;
//切换横屏
@property(nonatomic,copy) void(^hitSwitchH)(void);

@property(nonatomic,copy) void(^loadMore)(dispatch_block_t);
@property(nonatomic,copy)void(^disenableScroll)(BOOL flag);

- (instancetype)initWithFrame:(CGRect)frame hasVol:(BOOL)hasVol;


- (void)configSocketChart:(NSArray *)dataList hasNewPoint:(BOOL)hasNewPoint;
- (void)configChart:(NSArray *)dataList moreCount:(NSInteger)moreCount;
- (void)configChart:(NSArray *)dataList;

- (void)vChartToHChart;
- (void)vChartToHShowInfo;
- (void)hChartToVChart;
- (void)hChartToVShowInfo;
- (void)clearData;

- (void)changedTopIndex:(EIndexTopType)indexTopType;
- (void)changedIndex:(EIndexType)indexType;
- (EIndexTopType)indexTopType;
- (EIndexType)indexType;

- (void)setAxisYImg:(NSString *)imageName;
- (void)setDateBgColor:(UIColor *)color;

@end

//
//  KLineChartsView.h
//  LiveTrade
//
//  Created by ngw15 on 2018/11/27.
//  Copyright © 2018 taojinzhe. All rights reserved.
//  k线图控件（有手势，数据的处理）

#import <UIKit/UIKit.h>
#import "CFDKlineView.h"
#import "CFDScrollView.h"

NS_ASSUME_NONNULL_BEGIN

@interface KLineChartsView : UIView

@property (nonatomic,strong)CFDScrollView *scrollView;
@property (nonatomic,strong) CFDKlineView *chartView;
@property (nonatomic,assign) BOOL isPinching;
@property (nonatomic,assign) BOOL isPaning;
@property (nonatomic,assign) BOOL isDragging;

//@property (nonatomic,copy) NSString *closePrice;
@property (nonatomic,assign) BOOL isFirst;
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

@end

NS_ASSUME_NONNULL_END

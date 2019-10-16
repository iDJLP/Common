//
//  CFDKLineView.h
//  LiveTrade
//
//  Created by ngw15 on 2018/11/27.
//  Copyright © 2018 taojinzhe. All rights reserved.
//  k线图的绘制控件

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFDKlineView : UIView

///分时图高度
@property(nonatomic,assign)int nfenshiheight;
//底部高度
@property (nonatomic,assign) CGFloat indexHeight;
///总根数（包含右侧被遮住部分）
@property(nonatomic,assign)int nfenshiCount;
///小数点位数
@property(nonatomic,assign)NSInteger nDotNum;
///标准区域距右的距离
@property (nonatomic,assign)CGFloat lineRight;
///显示的宽度
@property (nonatomic,assign) CGFloat showWidth;
///frame.width
@property (nonatomic,assign) CGFloat allWidth;
///有效区域内的根数
@property (nonatomic,assign)NSInteger hCount;
///是否有最新的点
@property (nonatomic,assign) BOOL hasLast;

@property (nonatomic,assign) EIndexTopType indexTopType;
@property (nonatomic,assign) EIndexType indexType;

@property (nonatomic,copy) void (^axisCursorHander)(NSString *cursorPrice,BOOL isLast);
@property (nonatomic,copy) void (^axisHander)(NSDictionary *dic);
@property (nonatomic,copy) void (^bottomAxisHander)(NSDictionary *dic);
@property (nonatomic,copy) void (^indexVolAxisHander)(NSDictionary *dic);


#pragma mark 界面初始化
- (instancetype)initWithFrame:(CGRect)frame hasBottomIndex:(BOOL)hasBottomIndex;

- (void)showInfo:(NSRange)range;
- (void)socketShowInfo:(NSRange)range isReload:(BOOL)isReload hasNewPoint:(BOOL)flag;
#pragma mark 横竖屏切换
- (void)vChartToHChart;
- (void)hChartToVChart;

- (BOOL)isFocusing;
- (NSInteger)maxCount;

#pragma mark 数据处理
- (void)setKLineDataArr:(NSArray *)kLineDataArr;
- (NSArray *)getShowData;
- (NSArray *)getDataList;
- (void)clear;

- (void)dynamicFrame;
- (void)changedTopIndex:(EIndexTopType)indexTopType;
- (void)changedIndex:(EIndexType)indexType;

@end

NS_ASSUME_NONNULL_END

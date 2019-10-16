//
//  CFDKLineButtonView.h
//  nntj_ftox
//
//  Created by zhangchangqing on 2017/10/11.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//  

#import <UIKit/UIKit.h>

#import "CFDKlineMinuteSelectView.h"

@interface CFDKLineButtonView : UIView

@property(nonatomic,copy)void(^selectedChartsHander)(EChartsType chartsType);
@property(nonatomic,copy)void(^selectedIndexHander)(NSMutableDictionary *dic);
@property(nonatomic,copy)NSMutableDictionary *(^getChartsSelectedIndex)(void);

- (id)initWithTitles:(NSArray <NSDictionary *>*)titles hTitles:(NSArray <NSDictionary *>*)hTitles frame:(CGRect)frame;

- (void)vChartToHChart;
- (void)hChartToVChart;

- (void)clickedButtonList:(NSInteger)index;
- (void)hideSelectedView;

@end

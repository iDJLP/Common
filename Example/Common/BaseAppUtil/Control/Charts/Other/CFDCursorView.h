//
//  CFDMLineCursorView.h
//  MyKLineView
//
//  Created by Han on 13-9-27.
//  Copyright (c) 2013年 Han. All rights reserved.
//  十字线视图

#import <UIKit/UIKit.h>

@interface CFDCursorView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic,copy) void (^axisCursorHander)(NSString *cursorPrice,BOOL isLast);
@property (nonatomic,copy) void (^indexCursorHander)(CFDKLineData *data);

@property (nonatomic,assign) int nfenshiCount;//分时线个数
@property (nonatomic,assign) CGFloat bottomLineH;
@property (nonatomic,assign) CGFloat topLineH;
@property(nonatomic,assign)CGFloat iMLineW;
@property(atomic,strong)NSArray *dataList;
@property(atomic,strong)NSArray *posotionList;

- (BOOL)isShowFocus;
@end

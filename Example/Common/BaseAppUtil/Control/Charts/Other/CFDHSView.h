//
//  CFDHSView.h
//  globalwin
//
//  Created by ngw15 on 2018/9/1.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//  横屏时的视图

#import <UIKit/UIKit.h>
#import "BaseView.h"

@protocol CFDHSViewDelegate

- (void)switchsScreenToV;
@end

@interface CFDHSView : BaseView

@property (nonatomic,assign,readonly) CGFloat topHeight;
@property (nonatomic,assign,readonly) CGFloat rightHeight;
@property (nonatomic,weak)id<CFDHSViewDelegate> delegate;

- (instancetype)initWithIsReal:(BOOL)isReal;

- (void)configOfView:(NSMutableDictionary *)config;

@property(nonatomic,copy)void(^selectedIndexHander)(NSMutableDictionary *dic);
@property(nonatomic,copy)NSMutableDictionary *(^getChartsSelectedIndex)(void);


@end

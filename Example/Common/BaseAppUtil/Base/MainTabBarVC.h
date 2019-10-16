//
//  MainTabBarVC.h
//  TabDemo
//
//  Created by zhanghonglin on 15/7/9.
//  Copyright (c) 2015年 zhl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBar.h"

@interface MainTabBarVC : UITabBarController

// item数组
@property (nonatomic, strong) NSMutableArray *tabItemArray;

// 选中事件
@property (nonatomic, copy) BOOL(^selectItem)(NSString *className);

/**
 *  更改当前选中索引
 *
 *  @param tag 索引
 */
- (void)chageSelectedIndex:(NSInteger)tag;

/**
 *  用类名选择控制器
 *
 *  @param classString 类名
 */
- (void)selectedItemWithClassString:(NSString *)classString;

@end

@interface UITabBar (AOP)

@end

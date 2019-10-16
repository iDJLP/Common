//
//
//  globalwin
//
//  
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarItem.h"
#import "BaseView.h"

// Tab页签的类型，要求必须连续
typedef NS_ENUM(NSUInteger, TabBarItemTag) {
    TabBarItemTagBegin  = 0,    // 最小
    TabBarItemTagOne,           // tab 1
    TabBarItemTagTwo,           // tab 2
    TabBarItemTagThree,         // tab 3
    TabBarItemTagMax,           // 最大
};
@protocol TabBarDelegate <NSObject>
// 选中事件
- (void)tabBarSelectedItemWithTag:(NSString *)clsControlName;

@end
@interface TabBarItemInfo : NSObject

@property (nonatomic, assign) NSInteger tagID;              // item的tag
@property (nonatomic, assign) BOOL      flagSelected;       // 初始时是否选中
@property (nonatomic,copy) NSString *(^textBlock)(void) ;
@property (nonatomic, strong) NSString  *imgNormalName;     // 默认图片名称
@property (nonatomic, strong) NSString  *imgSelectName;     // 选中图片名称
@property (nonatomic, strong) NSString  *clsControlName;    // 控制器的类名
@property (nonatomic, strong) UIViewController *viewController; // 控制器对象
-(instancetype)initWithTitle:(NSString *(^)(void))textBlock
                  NormalName:(NSString *)imgNormalName
                  SelectName:(NSString *)imgSelectName
              ControllerName:(NSString *)clsControlName
                    Selected:(BOOL)flagSelected;

@end
@interface TabBar : BaseView
@property (nonatomic, strong) NSMutableArray        *aryTabBarItem;  // 按钮控件列表
@property (nonatomic, assign) id<TabBarDelegate>  delegate;

/**
 *  选中事件
 *
 *  @param item TabBar的Item
 */
- (void)tabBarItemTapped:(TabBarItem *)item;

/**
 *  刷新item
 *
 *  @param aryTabItemInfo item数组
 */
- (void)reloadViews:(NSMutableArray*)aryTabItemInfo;

- (void)reloadViews:(NSMutableArray *)aryTabItemInfo animation:(NSInteger)index;

@end

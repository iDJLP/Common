//
//  MainTabBarVC.m
//  TabDemo
//
//  Created by zhanghonglin on 15/7/9.
//  Copyright (c) 2015年 zhl. All rights reserved.
//


#import "MainTabBarVC.h"
#import "HomeVC.h"
#import "MarketVC.h"
#import "TradeVC.h"
#import "MineVC.h"
#import "AssetVC.h"
#import "BaseNC.h"


@interface MainTabBarVC ()<TabBarDelegate>
@property (nonatomic, strong) TabBar  *ctrlTabBar;
@property (nonatomic, strong) NSString  *selectClassName;
@end

@implementation MainTabBarVC

- (void)dealloc{
    [self removeNotic];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configTabBar];
    [self createCustomTabBar];
    [self addNotic];
}
- (void)createCustomTabBar{
    [self.tabItemArray removeAllObjects];

    TabBarItemInfo * info0 = [[TabBarItemInfo alloc]initWithTitle:CFDLocalizedStringBlock(@"首页") NormalName:@"tabicon_home_default" SelectName:@"tabicon_home_click" ControllerName:NSStringFromClass(HomeVC.class) Selected:YES];
    
    TabBarItemInfo * info1 = [[TabBarItemInfo alloc]initWithTitle:CFDLocalizedStringBlock(@"行情") NormalName:@"tabicon_market_default" SelectName:@"tabicon_market_click" ControllerName:NSStringFromClass(MarketVC.class) Selected:YES];
    TabBarItemInfo * info2 = [[TabBarItemInfo alloc]initWithTitle:CFDLocalizedStringBlock(@"交易") NormalName:@"tabicon_trade_default" SelectName:@"tabicon_trade_click" ControllerName:NSStringFromClass(TradeVC.class) Selected:YES];
    TabBarItemInfo * info3 = [[TabBarItemInfo alloc]initWithTitle:CFDLocalizedStringBlock(@"资产") NormalName:@"tabicon_assets_default" SelectName:@"tabicon_assets_click" ControllerName:NSStringFromClass(AssetVC.class) Selected:YES];
    TabBarItemInfo * info4 = [[TabBarItemInfo alloc]initWithTitle:CFDLocalizedStringBlock(@"我的") NormalName:@"tabicon_mine_default" SelectName:@"tabicon_mine_click" ControllerName:NSStringFromClass(MineVC.class) Selected:YES];
    
    [self.tabItemArray addObjectsFromArray:@[info0,info1,info2,info3,info4]];

    [self reloadWithAnimated];
    self.selectedIndex = 0;

}
- (void)configTabBar{
    [self.tabBar setBackgroundImage:[UIImage new]];

    [self.tabBar setShadowImage:[UIImage new]];

    [self.tabBar addSubview:self.ctrlTabBar];
}

- (void)themeChangedAction{
    self.ctrlTabBar.backgroundColor = [GColorUtil tabbarColor];
}

- (void)addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
    [center addObserver:self
               selector:@selector(themeChangedAction)
                   name:ThemeDidChangedNotification
                 object:nil];
}

- (void)removeNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}


#pragma mark - geter/seter

- (TabBar *)ctrlTabBar{
    if (!_ctrlTabBar) {
        _ctrlTabBar = [[TabBar alloc] initWithFrame:(CGRect){0, 0, self.view.width, 49.0+IPHONE_X_BOTTOM_HEIGHT}];
        _ctrlTabBar.backgroundColor = [GColorUtil tabbarColor];
        _ctrlTabBar.delegate        = self;
    }
    return _ctrlTabBar;
}

- (NSMutableArray *)tabItemArray{
    if (!_tabItemArray) {
        _tabItemArray = [[NSMutableArray alloc] init];
    }
    return _tabItemArray;
}

- (BOOL (^)(NSString *))selectItem{
    return ^BOOL(NSString *className){
        BOOL select = NO;
        return select;
    };
}

- (TabBarItemInfo *)getTabItem:(NSString *)clsControlName{
    __block TabBarItemInfo *itemInfo = nil;
    
    [self.tabItemArray enumerateObjectsUsingBlock:^(TabBarItemInfo * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.clsControlName isEqualToString:clsControlName]) {
            itemInfo = obj;
            *stop = YES;
        }
    }];
    
    return itemInfo;
}

#pragma mark - TabBarDelegate
// 选中事件
- (void)tabBarSelectedItemWithTag:(NSString *)clsControlName {
    
    [self.ctrlTabBar.aryTabBarItem enumerateObjectsUsingBlock:^(TabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.clsControlName isEqualToString:clsControlName]) {
            if ([clsControlName isEqualToString:NSStringFromClass(AssetVC.class)]&&[UserModel isLogin]==NO) {
                [CFDJumpUtil jumpToLogin];
                return ;
            }
            obj.selected = YES;
            self.selectedIndex = idx;
        }else{
            obj.selected = NO;
        }
    }];
}
#pragma mark - 外部调用
// 更改当前选中索引
- (void)chageSelectedIndex:(NSInteger)tag{

    for (TabBarItem *item in self.ctrlTabBar.aryTabBarItem) {
        if (item.tag == tag) {
            [self.ctrlTabBar tabBarItemTapped:item];
            break;
        }
    }
}

// 用类名选择控制器
- (void)selectedItemWithClassString:(NSString *)classString{
    for (TabBarItem *item in self.ctrlTabBar.aryTabBarItem) {
        if ([item.clsControlName isEqualToString:classString]) {
            [self.ctrlTabBar tabBarItemTapped:item];
            break;
        }
    }
}

// 刷新Item和controller
- (void)reloadWithAnimated{
    [self reloadWith:self.tabItemArray];
}

- (void)reloadItemTab{

}

- (void)reloadWith:(NSMutableArray *)tabItemArray{
    NSMutableArray *aryVC = [[NSMutableArray alloc] initWithCapacity:0];
    NSInteger itemCount = [tabItemArray count];
    
    for (NSInteger n=0; n < itemCount; ++n) {
        TabBarItemInfo *itemInfoTmp = [tabItemArray objectAtIndex:n];
        itemInfoTmp.tagID = n;
        
        if (itemInfoTmp.viewController) {
            BaseNC *baseNC = [[BaseNC alloc] initWithRootViewController:itemInfoTmp.viewController];
//            itemInfoTmp.viewController.title = itemInfoTmp.textBlock();
            [aryVC addObject:baseNC];
        }else{
            Class cls = NSClassFromString(itemInfoTmp.clsControlName);
            UIViewController *uiController = [[cls alloc] init];
//            uiController.title = itemInfoTmp.textBlock();
            itemInfoTmp.viewController = uiController;
            
            BaseNC *baseNC = [[BaseNC alloc] initWithRootViewController:uiController];
//            baseNC.title = itemInfoTmp.textBlock();
            
            [aryVC addObject:baseNC];
        }
    }
    [self setViewControllers:aryVC animated:NO];
    [self.ctrlTabBar reloadViews:tabItemArray animation:2];
    
    if ([self.selectClassName length]) {
        [self selectedItemWithClassString:self.selectClassName];
    }else{
        [self chageSelectedIndex:0];
    }
}

@end

#import "NSafe.h"

@implementation UITabBar (AOP)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [NSafe swizzleMethod:[self class]
                    original:@selector(addSubview:)
                    swizzled:@selector(aop_addSubview:)];

    });
}

#pragma mark - Swizzle方法
- (void)aop_addSubview:(UIView *)view{
    if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")] ||
        [view isKindOfClass:NSClassFromString(@"UIImageView")]) {
        return;
    }
    [self aop_addSubview:view];
}

@end

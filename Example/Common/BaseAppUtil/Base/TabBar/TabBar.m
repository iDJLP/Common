//
//
//  globalwin
//
//
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "TabBar.h"


@implementation TabBarItemInfo

-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

-(instancetype)initWithTitle:(NSString *(^)(void))textBlock
                  NormalName:(NSString *)imgNormalName
                  SelectName:(NSString *)imgSelectName
              ControllerName:(NSString *)clsControlName
                    Selected:(BOOL)flagSelected{
    self = [super init];
    if (self) {
        
        self.textBlock = textBlock;
        self.imgNormalName = imgNormalName;
        self.imgSelectName = imgSelectName;
        self.clsControlName = clsControlName;
        self.flagSelected = flagSelected;
    }
    return self;
}

@end
@interface TabBar ()<TabBarItemDelegate>
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) BaseView *topLine;

@end
@implementation TabBar

-(BaseView *)topLine{
    if (!_topLine) {
        
        _topLine = [[BaseView alloc]initWithFrame:(CGRect){0, 0, self.width,[GUIUtil fitLine]}];
        _topLine.bgColor = C7_ColorType;
    }
    return _topLine;
}

- (void)reloadViews:(NSMutableArray *)aryTabItemInfo animation:(NSInteger)index{
    self.index = index;
    [self reloadViews:aryTabItemInfo];
//    [self getliveRoom];
}

// 实例化item并加到视图上
- (void)reloadViews:(NSMutableArray *)aryTabItemInfo
{
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
        [self.aryTabBarItem removeAllObjects];
    }
    
    NSInteger itemCount = aryTabItemInfo.count;
    
    for (NSInteger n = 0; n < itemCount; ++n) {
        TabBarItemInfo *infoItem = [aryTabItemInfo objectAtIndex:n];
        
        TabBarItem *tabItem = [TabBarItem new];
        tabItem.imageName           = infoItem.imgNormalName;
        tabItem.selectedImageName   = infoItem.imgSelectName;
        tabItem.textBlock           = infoItem.textBlock;
        tabItem.delegate        = self;
        tabItem.tag             = infoItem.tagID;
        tabItem.selected        = infoItem.flagSelected;
        tabItem.clsControlName  = infoItem.clsControlName;
        [self.aryTabBarItem addObject:tabItem];
        [self addSubview:tabItem];
    }
    
    CGFloat tabItemWidth = (CGFloat)(self.width / itemCount);
    CGRect itemFrame = (CGRect){0, 0, tabItemWidth, self.height-IPHONE_X_BOTTOM_HEIGHT};
    CGFloat x = 0.0;
    
    for (NSInteger n = 0; n < itemCount; ++n) {
        TabBarItem *tabItem = [self.aryTabBarItem objectAtIndex:n];
        tabItem.frame = itemFrame;
        tabItem.left = x;
        x += itemFrame.size.width;
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self insertSubview:self.topLine atIndex:0];
}

- (TabBarItem *)getliveTabItem{
    __block TabBarItem *item = nil;
    
    [self.aryTabBarItem enumerateObjectsUsingBlock:^(TabBarItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.clsControlName isEqualToString:@"ZegoLiveVC"]) {
            item = obj;
            *stop = YES;
        }
    }];
    
    return item;
}

#pragma mark - FetchData

- (void)getliveRoom{
//    WEAK_SELF;
//    [[ZegoAVKitManager shareIntance] checkOpenLive:^(NSError *error) {
//        if (error.code == 1) {
//            [[weakSelf getliveTabItem] dealAnimation];
//            MainTabBarVC *vc = (MainTabBarVC *)[GJumpUtil rootTabC];
//            [vc reloadItemTab];
//        }
//    }];
//    [NTimeUtil startTimer:@"getliveRoom" interval:3 repeats:YES action:^{
//        [[ZegoAVKitManager shareIntance] getroomno:^(NSError *error) {
//            if (!error) {
//                [[weakSelf getliveTabItem] dealAnimation];
//            }
//        }];
//    }];
}

#pragma mark - geter/seter

- (NSMutableArray *)aryTabBarItem{
    if (!_aryTabBarItem) {
        _aryTabBarItem = [[NSMutableArray alloc] init];
    }
    return _aryTabBarItem;
}

#pragma mark - TabBarItemDelegate
// 选中事件
- (void)tabBarItemTapped:(TabBarItem *)item {
//    if (item.tag==3&&[GJumpUtil isLogin]==NO) {
//        [GJumpUtil jumpToLogin:nil];
//        return;
//    }
    if ([self.delegate respondsToSelector:@selector(tabBarSelectedItemWithTag:)]) {
        [self.delegate tabBarSelectedItemWithTag:item.clsControlName];
    }
}

@end

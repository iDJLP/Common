//
//  TabBarItem.h
//  globalwin
//
//  
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"
#import "BaseImageView.h"
#import "BaseLabel.h"

@class TabBarItem;

@protocol TabBarItemDelegate <NSObject>
// 选中事件
- (void)tabBarItemTapped:(TabBarItem *)item;

@end

@interface TabBarItem : BaseView {
    BaseImageView *imageView;     // 图标
    BaseLabel     *titleLb;       // title
}

@property (nonatomic, assign) id<TabBarItemDelegate> delegate;
@property (nonatomic, assign) BOOL   isAnimation;
@property (nonatomic, strong) NSString   *imageName;             // 默认图片
@property (nonatomic, strong) NSString   *selectedImageName;     // 选中之后的图片
@property (nonatomic,copy) NSString *(^textBlock)(void) ;
@property (nonatomic, copy) NSString    *clsControlName;    // 控制器的类名

@property (nonatomic) BOOL selected;    // 是否选中

/**
 *  选中之后改变颜色和图片
 *
 *  @param gr 手势
 */
- (void)tapped:(UITapGestureRecognizer *)gr;


@end

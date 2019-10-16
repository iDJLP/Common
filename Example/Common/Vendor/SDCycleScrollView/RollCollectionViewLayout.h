//
//  HomeCardCollectionViewLayout.h
//  xywallet
//
//  Created by lzh on 2018/1/31.
//  Copyright © 2018年 bjxy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define AutoSizeScale6 ((SCREEN_WIDTH) / 375.)
/**
 以750的屏幕宽，适配位置
 */
#define AutoSize6(size) ( lroundl((size) * AutoSizeScale6 * 10 / 2.0) / 10.0 )


// 状态栏默认高度
#define kStatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)

/// cell width
#define HomeCollectionViewItemWidth AutoSize6(686.0)

/// image width
#define HomeCollectionViewItemImageWidth AutoSize6(686.0)

/// content height
#define HomeCollectionViewItemHight AutoSize6(300)

/// section 左间距, 在无限轮播中无用
#define HomeCollectionViewLeftSpace ((SCREEN_WIDTH - HomeCollectionViewItemWidth) / 2.0)

/// minimumLineSpacing
#define HomeCollectionViewLineSpace AutoSize6(-15)

@interface RollCollectionViewLayout : UICollectionViewFlowLayout

@end

//
//  GuidePageCell.h
//  globalwin
//
//  Created by 张洪林 on 2018/7/25.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuidePageCell : UICollectionViewCell
@property (nonatomic, strong) UIImage *image;

// 判断是否是最后一页
- (void)setIndexPath:(NSIndexPath *)indexPath count:(NSUInteger)count;
@end

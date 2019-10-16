//
//  RollCollectionViewLayout.m
//  xywallet
//
//  Created by lzh on 2018/1/31.
//  Copyright © 2018年 bjxy. All rights reserved.
//

#import "RollCollectionViewLayout.h"

@implementation RollCollectionViewLayout

- (instancetype)init {
    self = [super init];
    if (self) {
        self.itemSize = CGSizeMake(HomeCollectionViewItemWidth, HomeCollectionViewItemHight);
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.minimumLineSpacing = HomeCollectionViewLineSpace;
//        self.sectionInset = UIEdgeInsetsMake(0, HomeCollectionViewLeftSpace, 0, HomeCollectionViewLeftSpace);
    }
    return self;
}

- (CGFloat)pageWidth {
    return self.itemSize.width + self.minimumLineSpacing;
}

- (CGFloat)flickVelocity {
    return 0.3;
}

- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    
    CGFloat rawPageValue = self.collectionView.contentOffset.x / self.pageWidth;
    CGFloat currentPage = (velocity.x > 0.0) ? floor(rawPageValue) : ceil(rawPageValue);
    CGFloat nextPage = (velocity.x > 0.0) ? ceil(rawPageValue) : floor(rawPageValue);
    
    BOOL pannedLessThanAPage = fabs(1 + currentPage - rawPageValue) > 0.5;
    BOOL flicked = fabs(velocity.x) > [self flickVelocity];
    if (pannedLessThanAPage && flicked) {
        proposedContentOffset.x = nextPage * self.pageWidth;
    } else {
        proposedContentOffset.x = round(rawPageValue) * self.pageWidth;
    }
    
    // view最后停留的范围
    CGRect lastRect ;
    lastRect.origin = proposedContentOffset;
    lastRect.size = self.collectionView.frame.size;
    NSArray *array = [self layoutAttributesForElementsInRect:lastRect];
    
    CGFloat adjustOffsetX = MAXFLOAT;
    // 计算屏幕最中间的x, 并算出最小值
    CGFloat centerX = proposedContentOffset.x + self.collectionView.frame.size.width / 2 ;
    for (UICollectionViewLayoutAttributes *attrs in array) {
        if(ABS(attrs.center.x - centerX) < ABS(adjustOffsetX)){
            adjustOffsetX = attrs.center.x - centerX;
        }
    }
    return CGPointMake(proposedContentOffset.x + adjustOffsetX, proposedContentOffset.y);
}

/**
 *  返回yes，只要显示的边界发生改变，就需要重新布局：(会自动调用layoutAttributesForElementsInRect方法，获得所有cell的布局属性)
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return YES;
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {

    CGRect visiableRect;
    visiableRect.size = self.collectionView.frame.size;
    visiableRect.origin = self.collectionView.contentOffset;

    // 取出默认cell的UICollectionViewLayoutAttributes
    NSArray *array = [super layoutAttributesForElementsInRect:rect];

    //计算屏幕最中间的x
    CGFloat centerX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width / 2;

    // 遍历所有的布局属性
    for (UICollectionViewLayoutAttributes *attrs in array) {
        // 不是可见范围的 就返回，不再屏幕就直接跳过
        if (!CGRectIntersectsRect(visiableRect, attrs.frame)) continue;

        CGFloat itemCenterx = attrs.center.x;
        CGFloat centerSpace = ABS(itemCenterx - centerX);
        // 根据与屏幕最中间的距离计算缩放比例
        CGFloat multiple = 0.8;
        CGFloat scale = 1 - (centerSpace / self.collectionView.frame.size.width * 0.5) * (1 - multiple);

        attrs.transform = CGAffineTransformMakeScale(scale, scale);

        // 如果想对z轴操作
        attrs.zIndex = centerSpace <= 80.0;
    }

    return array;
}

@end

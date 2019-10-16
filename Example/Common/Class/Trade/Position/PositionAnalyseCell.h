//
//  PositionAnalyseCell.h
//  Bitmixs
//
//  Created by ngw15 on 2019/9/30.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface PositionAnalyseSectionView : UIView

+ (CGFloat)heightOfView;

@end

@interface PositionAnalyseCell : BaseCell

+ (CGFloat)heightOfCell;

- (void)configOfCell:(NSDictionary *)dict isSingle:(BOOL)isSingle;

- (void)updateSelected:(BOOL)flag;

@end

NS_ASSUME_NONNULL_END

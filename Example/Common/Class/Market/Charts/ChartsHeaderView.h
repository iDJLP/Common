//
//  ChartsHeaderView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/18.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChartsHeaderView : UIView

@property (nonatomic,copy) dispatch_block_t tapHander;
@property (nonatomic,copy) dispatch_block_t backHander;

+ (CGFloat)heightOfView;
- (void)configData:(NSDictionary *)data;
- (void)changedArrow:(BOOL)isSelected;
@end

NS_ASSUME_NONNULL_END

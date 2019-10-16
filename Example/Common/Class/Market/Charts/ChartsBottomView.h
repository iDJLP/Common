//
//  ChartsBottomView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/18.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChartsBottomView : UIView

+ (CGFloat)heightOfView;
@property (nonatomic,copy) dispatch_block_t buyHander;
@property (nonatomic,copy) dispatch_block_t sellHander;
@property (nonatomic,copy) dispatch_block_t alertHander;

@end

NS_ASSUME_NONNULL_END

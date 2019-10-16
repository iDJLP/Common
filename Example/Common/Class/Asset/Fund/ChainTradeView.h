//
//  ChainTradeView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/4/25.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChainTradeView : UIView

@property (nonatomic,strong) UILabel *amountTitle;

+ (CGFloat)heightOfView;
- (void)configView:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

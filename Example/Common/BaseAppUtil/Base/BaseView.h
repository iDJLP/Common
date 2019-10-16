//
//  BaseView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/4/30.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseView : UIView

@property (nonatomic,assign)ColorType bgColor;
@property (nonatomic,assign)ColorType bgLayerColor;
@property (nonatomic,assign)ColorType bgShadowColor;

- (void)base_themeChangedAction;

@end

NS_ASSUME_NONNULL_END

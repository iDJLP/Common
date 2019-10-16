//
//  BaseTextField.h
//  Bitmixs
//
//  Created by ngw15 on 2019/5/5.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseTextField : UITextField

@property (nonatomic,assign)ColorType txColor;
@property (nonatomic,assign)ColorType placeColor;
@property (nonatomic,assign)ColorType bgColor;
@property (nonatomic,assign)ColorType bgLayerColor;

@end

NS_ASSUME_NONNULL_END

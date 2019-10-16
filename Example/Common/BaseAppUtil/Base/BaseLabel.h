//
//  BaseLabel.h
//  Bitmixs
//
//  Created by ngw15 on 2019/4/30.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseLabel : UILabel

//只用黑版的色值
@property (nonatomic,assign)BOOL hasTheme;
@property (nonatomic,assign)CGFloat txAlpha;
@property (nonatomic,assign)ColorType txColor;
@property (nonatomic,assign)ColorType bgColor;
@property (nonatomic,copy) NSString *(^textBlock)(void) ;
@end

NS_ASSUME_NONNULL_END

//
//  MarkView.h
//  niuguwang
//
//  Created by ngw15 on 2017/4/17.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MarkView : UIView

@property (nonatomic,strong) UIFont *font;
@property (nonatomic,strong) UIColor *textColor;

@property (nonatomic,strong) NSString *text;

@property (nonatomic,assign) CGFloat hPadding;
@property (nonatomic,assign) CGFloat vPadding;

+ (CGSize)sizeOfView:(NSString *)text vPadding:(CGFloat)vPadding hPadding:(CGFloat)hPadding fontSize:(CGFloat)fontSize;

@end

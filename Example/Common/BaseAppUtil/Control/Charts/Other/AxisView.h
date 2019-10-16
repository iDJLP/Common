//
//  AxisView.h
//  coinare_ftox
//
//  Created by ngw15 on 2018/7/27.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//  坐标轴视图

#import <UIKit/UIKit.h>

@interface AxisView : UIView

@property (nonatomic,strong) BaseImageView *bgImgView;
- (void)setMaxAxis:(NSString *)maxY minY:(NSString *)minY preNum:(NSInteger)precise lastPrice:(NSString *)lastPrice isRed:(BOOL)isRed;
- (void)showCursorPrice:(NSString *)cursorPrice isLast:(BOOL)isLast;


@end

@interface BottomAxisView : UIView

@property (nonatomic,strong) BaseImageView *bgImgView;

- (void)setMaxAxis:(NSString *)maxY minY:(NSString *)minY;
- (void)setY1:(NSString *)y1 setY2:(NSString *)y2 height:(CGFloat)height;

@end


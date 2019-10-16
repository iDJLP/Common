//
//  BaseView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/4/30.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseView.h"

@implementation BaseView

- (void)dealloc{
    [self base_removeNotic];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self base_addNotic];
    }
    return self;
}

- (void)setBgColor:(ColorType)bgColor{
    _bgColor = bgColor;
    if (_bgColor!=Unkown_ColorType) {
        self.backgroundColor = [GColorUtil colorWithColorType:_bgColor];
    }
}

- (void)setBgLayerColor:(ColorType)bgLayerColor{
    _bgLayerColor = bgLayerColor;
    if (_bgLayerColor!=Unkown_ColorType) {
        self.layer.borderColor = [GColorUtil colorWithColorType:_bgLayerColor].CGColor;
    }
}

- (void)base_themeChangedAction{
    if (_bgColor!=Unkown_ColorType) {
        self.backgroundColor = [GColorUtil colorWithColorType:_bgColor];
    }
    if (_bgLayerColor!=Unkown_ColorType) {
        self.layer.borderColor = [GColorUtil colorWithColorType:_bgLayerColor].CGColor;
    }
}

- (void)base_addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
    [center addObserver:self
               selector:@selector(base_themeChangedAction)
                   name:ThemeDidChangedNotification
                 object:nil];
}

- (void)base_removeNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}


@end

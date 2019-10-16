//
//  BasePickerView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/5/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BasePickerView.h"

@implementation BasePickerView

- (void)dealloc{
    [self removeNotic];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self addNotic];
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

- (void)themeChangedAction{
    if (_bgColor!=Unkown_ColorType) {
        self.backgroundColor = [GColorUtil colorWithColorType:_bgColor];
    }
    if (_bgLayerColor!=Unkown_ColorType) {
        self.layer.borderColor = [GColorUtil colorWithColorType:_bgLayerColor].CGColor;
    }
}

- (void)addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
    [center addObserver:self
               selector:@selector(themeChangedAction)
                   name:ThemeDidChangedNotification
                 object:nil];
}

- (void)removeNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}


@end


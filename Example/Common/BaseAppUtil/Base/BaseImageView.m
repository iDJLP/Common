//
//  BaseImageView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/4/30.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseImageView.h"

@implementation BaseImageView

- (void)dealloc{
    [self removeNotic];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self addNotic];
    }
    return self;
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    [self themeChangedAction];
}

- (void)setHighlightedImageName:(NSString *)highlightedImageName{
    _highlightedImageName = highlightedImageName;
    [self themeChangedAction];
}

- (void)setBgColor:(ColorType)bgColor{
    _bgColor = bgColor;
    self.backgroundColor = [GColorUtil colorWithColorType:_bgColor];
}

- (void)themeChangedAction{
    if (_imageName.length>0) {    
        self.image = [GColorUtil imageNamed:_imageName];
    }
    if (_highlightedImageName.length>0) {
        self.highlightedImage = [GColorUtil imageNamed:_highlightedImageName];
        if (self.isHighlighted) {
            self.highlighted=NO;
            self.highlightedImage = [GColorUtil imageNamed:_highlightedImageName];
            self.highlighted = YES;
        }
    }
    if (_bgColor!=Unkown_ColorType) {
        self.backgroundColor = [GColorUtil colorWithColorType:_bgColor];
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

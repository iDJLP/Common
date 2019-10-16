//
//  BaseLabel.m
//  Bitmixs
//
//  Created by ngw15 on 2019/4/30.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseLabel.h"

@implementation BaseLabel

- (void)dealloc{
    [self base_removeNotic];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self base_addNotic];
        _txAlpha = 1;
    }
    return self;
}

- (void)setTextBlock:(NSString * _Nonnull (^)(void))textBlock{
    _textBlock = textBlock;
    self.text = textBlock();
}

- (void)setTxColor:(ColorType)txColor{
    _txColor = txColor;
    if (_txColor!=Unkown_ColorType) {
        if (_hasTheme) {
            self.textColor = [GColorUtil colorWithBlackColorType:_txColor alpha:_txAlpha];
        }else{
            self.textColor = [GColorUtil colorWithColorType:_txColor alpha:_txAlpha];
        }
    }
}

- (void)setBgColor:(ColorType)bgColor{
    _bgColor = bgColor;
    self.backgroundColor = [GColorUtil colorWithColorType:_bgColor];
}

- (void)base_themeChangedAction{
    if (_txColor!=Unkown_ColorType) {
        if (_hasTheme) {
            self.textColor = [GColorUtil colorWithBlackColorType:_txColor alpha:_txAlpha];
        }else{
            self.textColor = [GColorUtil colorWithColorType:_txColor alpha:_txAlpha];
        }
    }
    if (_bgColor!=Unkown_ColorType) {
        self.backgroundColor = [GColorUtil colorWithColorType:_bgColor];
    }
}

- (void)base_languageChangedAction{
    if (_textBlock) {    
        self.text = _textBlock();
    }
}

- (void)base_addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
    [center addObserver:self
               selector:@selector(base_themeChangedAction)
                   name:ThemeDidChangedNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(base_languageChangedAction)
                   name:LanguageDidChangedNotification
                 object:nil];
}

- (void)base_removeNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}


@end

//
//  BaseTextField.m
//  Bitmixs
//
//  Created by ngw15 on 2019/5/5.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseTextField.h"

@implementation BaseTextField

- (void)dealloc{
    [self base_removeNotic];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self =[super initWithFrame:frame]) {
        [self base_addNotic];
        self.txColor = C2_ColorType;
    }
    return self;
}

- (void)setTxColor:(ColorType)txColor{
    _txColor = txColor;
    if (_txColor!=Unkown_ColorType) {
        self.textColor = [GColorUtil colorWithColorType:_txColor];
    }
}

- (void)setPlaceColor:(ColorType)placeColor{
    _placeColor = placeColor;
    self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder.length>0?self.placeholder:@" " attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:_placeColor]}];
}

- (void)setBgLayerColor:(ColorType)bgLayerColor{
    _bgLayerColor = bgLayerColor;
    if (_bgLayerColor!=Unkown_ColorType) {
        self.layer.borderColor = [GColorUtil colorWithColorType:bgLayerColor].CGColor;
    }
}

- (void)setBgColor:(ColorType)bgColor{
    _bgColor = bgColor;
    self.backgroundColor = [GColorUtil colorWithColorType:_bgColor];
}

- (void)themeChangedAction{
    
    if (_txColor!=Unkown_ColorType) {
        self.textColor = [GColorUtil colorWithColorType:_txColor];
    }
    if (_bgColor!=Unkown_ColorType) {
        self.backgroundColor = [GColorUtil colorWithColorType:_bgColor];
    }
    if (_placeColor!=Unkown_ColorType) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder.length>0?self.placeholder:@" " attributes:@{NSForegroundColorAttributeName:[GColorUtil colorWithColorType:_placeColor]}];
    }
    if (_bgLayerColor!=Unkown_ColorType) {
        self.layer.borderColor = [GColorUtil colorWithColorType:_bgLayerColor].CGColor;
    }
}

- (void)base_addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
    [center addObserver:self
               selector:@selector(themeChangedAction)
                   name:ThemeDidChangedNotification
                 object:nil];
}

- (void)base_removeNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}


@end


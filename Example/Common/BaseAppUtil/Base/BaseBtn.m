//
//  BaseBtn.m
//  Bitmixs
//
//  Created by ngw15 on 2019/4/30.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseBtn.h"

@implementation BaseBtn

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

- (void)setTextBlock:(NSString * _Nonnull (^)(void))textBlock{
    _textBlock = textBlock;
    if (_textBlock) {
        [self setTitle:_textBlock() forState:UIControlStateNormal];
        [self themeChangedAction];
    }
}

- (void)setTxColor:(ColorType)txColor{
    _txColor = txColor;
    if (_txColor!=Unkown_ColorType) {
        [self setTitleColor:[GColorUtil colorWithColorType:_txColor] forState:UIControlStateNormal];
    }
    
}

- (void)setTxColor_sel:(ColorType)txColor_sel{
    _txColor_sel = txColor_sel;
    [self setTitleColor:[GColorUtil colorWithColorType:_txColor_sel] forState:UIControlStateSelected];
}

- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    [self setImage:[GColorUtil imageNamed:_imageName] forState:UIControlStateNormal];
}

- (void)setImageName_sel:(NSString *)imageName_sel{
    _imageName_sel = imageName_sel;
    [self setImage:[GColorUtil imageNamed:_imageName_sel] forState:UIControlStateSelected];
}

- (void)setImageName_dis:(NSString *)imageName_dis{
    _imageName_dis = imageName_dis;
    [self setImage:[GColorUtil imageNamed:_imageName_dis] forState:UIControlStateDisabled];
}

- (void)setBgImageName:(NSString *)bgImageName{
    _bgImageName = bgImageName;
    
    [self setBackgroundImage:[GColorUtil imageNamed:_bgImageName] forState:UIControlStateNormal];
}

- (void)setBgImageName_sel:(NSString *)bgImageName{
    _bgImageName_sel = bgImageName;
    
    [self setBackgroundImage:[GColorUtil imageNamed:_bgImageName_sel] forState:UIControlStateSelected];
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
- (void)languageChangedAction{
    if (_textBlock) {
        [self setTitle:_textBlock() forState:UIControlStateNormal];
        [self themeChangedAction];
    }
}

- (void)themeChangedAction{
    if (_txColor!=Unkown_ColorType) {
        [self setTitleColor:[GColorUtil colorWithColorType:_txColor] forState:UIControlStateNormal];
    }
    if (_txColor_sel!=Unkown_ColorType) {
        [self setTitleColor:[GColorUtil colorWithColorType:_txColor_sel] forState:UIControlStateSelected];
    }
    if (_imageName.length>0) {
        UIImage *image = [GColorUtil imageNamed:_imageName];
        if (image) {
            [self setImage:image forState:UIControlStateNormal];
        }
    }
    if (_imageName_sel.length>0) {
        UIImage *image_sel = [GColorUtil imageNamed:_imageName_sel];
        if (image_sel) {
            [self setImage:image_sel forState:UIControlStateSelected];
        }
    }
    if (_imageName_dis.length>0) {
        UIImage *image_dis = [GColorUtil imageNamed:_imageName_dis];
        if (image_dis) {
            [self setImage:image_dis forState:UIControlStateDisabled];
        }
    }
    if (_bgImageName.length>0) {
        UIImage *image = [GColorUtil imageNamed:_bgImageName];
        if (image) {
            [self setBackgroundImage:image forState:UIControlStateNormal];
        }
    }
    if (_bgImageName_sel.length>0) {
        UIImage *image = [GColorUtil imageNamed:_bgImageName_sel];
        if (image) {
            [self setBackgroundImage:image forState:UIControlStateSelected];
        }
    }
    if (_bgLayerColor!=Unkown_ColorType) {
        self.layer.borderColor = [GColorUtil colorWithColorType:_bgLayerColor].CGColor;
    }
    if (_bgColor!=Unkown_ColorType) {
        self.backgroundColor = [GColorUtil colorWithColorType:_bgColor];
    }
}

- (void)base_addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
    [center addObserver:self
               selector:@selector(themeChangedAction)
                   name:ThemeDidChangedNotification
                 object:nil];
    [center addObserver:self
               selector:@selector(languageChangedAction)
                   name:LanguageDidChangedNotification
                 object:nil];
    
}

- (void)base_removeNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}



@end

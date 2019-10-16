//
//
//  globalwin
//
//  Created by ngw15 on 2018/7/31.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "BaseCell.h"

@implementation BaseCell

- (void)dealloc{
    [self removeNotic];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.bgColorType = C6_ColorType;
        self.bgSelColorType = C8_ColorType;
        [self addNotic];
    }
    return self;
}

- (void)setbgColorType:(ColorType)bgColorType{
    _bgColorType = bgColorType;
    if (_bgColorType!= Unkown_ColorType) {
        self.contentView.backgroundColor = [GColorUtil colorWithColorType:_bgColorType];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    if (selected&&_hasPressEffect) {
        self.contentView.backgroundColor =[GColorUtil colorWithColorType:_bgSelColorType];
    }else{
        self.contentView.backgroundColor = [GColorUtil colorWithColorType:_bgColorType];
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    if (highlighted&&_hasPressEffect) {
        self.contentView.backgroundColor = [GColorUtil colorWithColorType:_bgSelColorType];
    }else{
        self.contentView.backgroundColor = [GColorUtil colorWithColorType:_bgColorType];
    }
}

- (void)themeChangedAction{
    if (_bgColorType!= Unkown_ColorType) {
        self.contentView.backgroundColor = [GColorUtil colorWithColorType:_bgColorType];
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

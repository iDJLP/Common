//
//  baseTableView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/4/30.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView


- (void)dealloc{
    [self base_removeNotic];
}

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self =[super initWithFrame:frame style:style]) {
        [self base_addNotic];
    }
    return self;
}


- (void)setBgColor:(ColorType)bgColor{
    _bgColor = bgColor;
    self.backgroundColor = [GColorUtil colorWithColorType:_bgColor];
}

- (void)themeChangedAction{
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
}

- (void)base_removeNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

@end

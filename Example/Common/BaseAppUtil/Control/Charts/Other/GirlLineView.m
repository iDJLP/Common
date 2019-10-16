//
//  GirlLineView.m
//  coinare_ftox
//
//  Created by ngw15 on 2018/8/26.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "GirlLineView.h"

@interface GirlLineView ()

@property (nonatomic,strong)UIView *topHLine;
@property (nonatomic,strong)UIView *firstHLine;
@property (nonatomic,strong)UIView *secondHLine;
@property (nonatomic,strong)UIView *ThirdHLine;
@property (nonatomic,strong)UIView *bottomHLine;

@property (nonatomic,assign)CGFloat sWidth;
@end

@implementation GirlLineView

- (void)dealloc{
    [self removeNotic];
}

- (instancetype)initWithOffSetWidth:(CGFloat)sWidth{
    if (self = [super init]) {
        _sWidth = sWidth;
        self.userInteractionEnabled=NO;
        [self setupUI];
        [self autoLayout];
        [self addNotic];
    }
    return self;
}
- (void)setupUI{
    [self addSubview:self.topHLine];
    [self addSubview:self.firstHLine];
    [self addSubview:self.secondHLine];
    [self addSubview:self.ThirdHLine];
    [self addSubview:self.bottomHLine];
}

- (void)autoLayout{
    [_topHLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo([ChartsUtil fit:0]);
        make.height.mas_equalTo([ChartsUtil fitLine]*2);
    }];
    [_firstHLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.multipliedBy(1/2.0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo([ChartsUtil fit:0]);
        make.height.mas_equalTo([ChartsUtil fitLine]);
    }];
    [_secondHLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.multipliedBy(1);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo([ChartsUtil fit:0]);
        make.height.mas_equalTo([ChartsUtil fitLine]);
    }];
    
    [_ThirdHLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.multipliedBy(3/2.0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo([ChartsUtil fit:0]);
        make.height.mas_equalTo([ChartsUtil fitLine]);
    }];
    [_bottomHLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo([ChartsUtil fit:0]);
        make.height.mas_equalTo([ChartsUtil fitLine]);
    }];
}

- (void)themeChangedAction{
    _topHLine.backgroundColor = [ChartsUtil C7];
    _firstHLine.backgroundColor = [ChartsUtil C7];
    _secondHLine.backgroundColor = [ChartsUtil C7];
    _ThirdHLine.backgroundColor = [ChartsUtil C7];
    _bottomHLine.backgroundColor = [ChartsUtil C7];
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

- (UIView *)topHLine{
    if (!_topHLine) {
        _topHLine = [[UIView alloc] init];
        _topHLine.backgroundColor = [ChartsUtil C7];
    }
    return _topHLine;
}
- (UIView *)firstHLine{
    if (!_firstHLine) {
        _firstHLine = [[UIView alloc] init];
        _firstHLine.backgroundColor = [ChartsUtil C7];
    }
    return _firstHLine;
}
- (UIView *)secondHLine{
    if (!_secondHLine) {
        _secondHLine = [[UIView alloc] init];
        _secondHLine.backgroundColor = [ChartsUtil C7];
    }
    return _secondHLine;
}
- (UIView *)ThirdHLine{
    if (!_ThirdHLine) {
        _ThirdHLine = [[UIView alloc] init];
        _ThirdHLine.backgroundColor = [ChartsUtil C7];
    }
    return _ThirdHLine;
}
- (UIView *)bottomHLine{
    if (!_bottomHLine) {
        _bottomHLine = [[UIView alloc] init];
        _bottomHLine.backgroundColor = [ChartsUtil C7];
    }
    return _bottomHLine;
}


@end

//
//  TradeMlineView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/5/9.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "TradeMlineView.h"
#import "TradeChartsView.h"
#import "BaseLabel.h"

@interface TradeMlineView ()

@property(nonatomic,strong) UIView *mainView;
@property(nonatomic,strong) BaseLabel *titleLabel;

@property(nonatomic,strong) UIView *foldView;
@property(nonatomic,strong) UILabel *foldLabel;
@property(nonatomic,strong) UIImageView *foldImgView;
@property(nonatomic,strong) BaseView *topLineView;
@property(nonatomic,strong) BaseView *lineView;
@property(nonatomic,strong) TradeChartsView *chartsView;
@property(nonatomic,strong) MASConstraint *masBottom;
@property(nonatomic,copy) NSString *symbol;
@property(nonatomic,assign) BOOL isUnFold;

@end

@implementation TradeMlineView

+ (CGFloat)heightOfCell:(NSDictionary *)dict{
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    return 0;
}

- (void)dealloc{
    [self removeNotic];
}

- (instancetype)init{
    if (self = [super init]) {
        self.backgroundColor = [GColorUtil tabbarColor];
        [self setupUI];
        [self autoLayout];
        [self addNotic];
    }
    return self;
}

- (void)viewDisAppear{
    _isUnFold = NO;
    [self foldChanged];
}

- (void)setupUI{
    [self addSubview:self.mainView];
    [self addSubview:self.chartsView];
    [self.mainView addSubview:self.titleLabel];
    [self.mainView addSubview:self.foldView];
    [self.mainView addSubview:self.foldLabel];
    [self.mainView addSubview:self.foldImgView];
    [self.mainView addSubview:self.topLineView];
    [self.mainView addSubview:self.lineView];
}

- (void)autoLayout{
    WEAK_SELF;
    
    [_mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo(ceil([GUIUtil fit:35]));
        weakSelf.masBottom = make.bottom.mas_equalTo(0);
    }];
    [_chartsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.mainView.mas_bottom);
        make.height.mas_equalTo(ceil(CTimeAixsHight+CMainChartHight+[GUIUtil fit:5]));
        make.bottom.mas_equalTo(0).priority(750);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.mas_equalTo(0);
    }];
    [_foldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo([GUIUtil fit:-15]);
    }];
    [_foldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.foldView).mas_offset([GUIUtil fit:5]);
        make.centerY.mas_equalTo(0);
        make.top.equalTo(self.foldView).mas_offset([GUIUtil fit:3]);
        make.bottom.equalTo(self.foldView).mas_offset([GUIUtil fit:-3]);
    }];
    [_foldImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.foldLabel.mas_right).mas_offset([GUIUtil fit:3]);
        make.right.equalTo(self.foldView).mas_offset([GUIUtil fit:-5]);
        make.centerY.mas_equalTo(0);
    }];
    [_topLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.equalTo(self.mainView);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    
}

- (void)updateTitle:(NSString *)title{
    _titleLabel.text = [NSString stringWithFormat:@"%@%@",title,CFDLocalizedString(@"分时图")];
}
- (void)updateSymbol:(NSString *)symbol{
    _symbol = symbol;
    if (_isUnFold) {
        [_chartsView changedSymbol:_symbol];
    }
}

- (void)foldChanged{
    if (self.isUnFold) {
        //展开状态
        self.foldImgView.image = [GColorUtil imageNamed:@"market_icon_under_blue_down"];
        self.foldLabel.text = CFDLocalizedString(@"收起");
        [self.masBottom deactivate];
        self.chartsView.hidden = NO;
        [self.chartsView changedSymbol:self.symbol];
        [self.chartsView willAppear];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }else{
        //收起状态
        self.foldImgView.image = [GColorUtil imageNamed:@"market_icon_under_blue_up"];
        [self.masBottom activate];
        [self.chartsView willDisappear];
        [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.superview layoutIfNeeded];
        } completion:^(BOOL finished) {
            self.foldLabel.text = CFDLocalizedString(@"展开");
            self.chartsView.hidden = YES;
        }];
    }
    
}

- (void)themeChangedAction{
    self.backgroundColor = [GColorUtil tabbarColor];
    _mainView.backgroundColor = [GColorUtil tradeChartsBgColor];
    _mainView.layer.shadowColor = [GColorUtil tradeChartsBgShadowColor].CGColor;
    _chartsView.backgroundColor = [GColorUtil tradeChartsBgColor];
    if ([CFDApp sharedInstance].isWhiteTheme) {
        [_chartsView.mLineView setAxisYImg:@"market_axis"];
    }else{
        [_chartsView.mLineView setAxisYImg:@"market_axis_trade"];
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.chartsView.mLineView setDateBgColor:[GColorUtil tradeChartsBgColor]];
    });
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

//MARK:Getter

- (UIView *)mainView{
    if (!_mainView) {
        _mainView = [[UIView alloc] init];
        _mainView.backgroundColor = [GColorUtil tradeChartsBgColor];
        _mainView.layer.shadowColor = [GColorUtil tradeChartsBgShadowColor].CGColor;
        _mainView.layer.shadowOffset = CGSizeMake(0, -4);
        _mainView.layer.shadowRadius = 5;
        _mainView.layer.shadowOpacity = 0.6;
        WEAK_SELF;
        [_mainView g_clickBlock:^(UITapGestureRecognizer *tap) {
            weakSelf.isUnFold = !weakSelf.isUnFold;
            [weakSelf foldChanged];
        }];
    }
    return _mainView;
}

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.txColor = C2_ColorType;
        _titleLabel.font = [GUIUtil fitFont:12];
        _titleLabel.numberOfLines = 1;
//        _titleLabel.text = @"BTC/USDT分时图";
    }
    return _titleLabel;
}

- (UIView *)foldView{
    if (!_foldView) {
        _foldView = [[UIView alloc] init];
        _foldView.layer.borderWidth = [GUIUtil fitLine];
        _foldView.layer.borderColor = [GColorUtil C13].CGColor;
        _foldView.layer.cornerRadius = 4;
        _foldView.layer.masksToBounds = YES;
    }
    return _foldView;
}

- (UILabel *)foldLabel{
    if (!_foldLabel) {
        _foldLabel = [[UILabel alloc] init];
        _foldLabel.textColor = [GColorUtil C13];
        _foldLabel.font = [GUIUtil fitFont:10];
        _foldLabel.numberOfLines = 1;
        _foldLabel.text = @"展开";
    }
    return _foldLabel;
}

- (UIImageView *)foldImgView{
    if (!_foldImgView) {
        _foldImgView = [[UIImageView alloc] init];
        _foldImgView.image = [GColorUtil imageNamed:@"market_icon_under_blue_down"];
    }
    return _foldImgView;
}
- (BaseView *)topLineView{
    if (!_topLineView) {
        _topLineView = [[BaseView alloc] init];
        _topLineView.bgColor = C7_ColorType;
    }
    return _topLineView;
}

- (BaseView *)lineView{
    if (!_lineView) {
        _lineView = [[BaseView alloc] init];
        _lineView.bgColor = C7_ColorType;
    }
    return _lineView;
}

- (TradeChartsView *)chartsView{
    if (!_chartsView) {
        _chartsView = [[TradeChartsView alloc] init];
        _chartsView.backgroundColor = [GColorUtil tradeChartsBgColor];
        if ([CFDApp sharedInstance].isWhiteTheme) {
            [_chartsView.mLineView setAxisYImg:@"market_axis"];
        }else{
            [_chartsView.mLineView setAxisYImg:@"market_axis_trade"];
        }
        [_chartsView.mLineView setDateBgColor:[GColorUtil tradeChartsBgColor]];
    }
    return _chartsView;
}


@end

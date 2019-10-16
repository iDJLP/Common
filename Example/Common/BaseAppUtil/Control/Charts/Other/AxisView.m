//
//  AxisView.m
//  coinare_ftox
//
//  Created by ngw15 on 2018/7/27.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "AxisView.h"
#import "DemoChartsModel.h"
#import "BaseImageView.h"
#import "BaseView.h"
#import "BaseLabel.h"

@interface AxisView()

@property (nonatomic,strong) UIView *contentView;

@property (nonatomic,strong) BaseLabel *axisY1Label;
@property (nonatomic,strong) BaseLabel *axisY2Label;
@property (nonatomic,strong) BaseLabel *axisY3Label;
@property (nonatomic,strong) BaseLabel *axisY4Label;
@property (nonatomic,strong) BaseLabel *axisY5Label;
@property (nonatomic,strong) UIView *axisY1Line;
@property (nonatomic,strong) UIView *axisY2Line;
@property (nonatomic,strong) UIView *axisY3Line;
@property (nonatomic,strong) UIView *axisY4Line;
@property (nonatomic,strong) UIView *axisY5Line;
@property (nonatomic,strong) BaseImageView *lastView;
@property (nonatomic,strong) BaseLabel *lastPrice;

@property (nonatomic,strong) BaseImageView *cursorImgView;
@property (nonatomic,strong) BaseLabel *cursorPrice;

@property (nonatomic,copy) NSString *minPrice;
@property (nonatomic,copy) NSString *maxPrice;
@property (nonatomic,assign) NSInteger precise;
@end

@implementation AxisView

- (void)dealloc{
    [self removeNotic];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        [self setupUI];
        [self autoLayout];
        [self addNotic];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.bgImgView];
    [self.contentView addSubview:self.axisY1Label];
    [self.contentView addSubview:self.axisY2Label];
    [self.contentView addSubview:self.axisY3Label];
    [self.contentView addSubview:self.axisY4Label];
    [self.contentView addSubview:self.axisY5Label];
    [self.contentView addSubview:self.axisY1Line];
    [self.contentView addSubview:self.axisY2Line];
    [self.contentView addSubview:self.axisY3Line];
    [self.contentView addSubview:self.axisY4Line];
    [self.contentView addSubview:self.axisY5Line];
    [self.contentView addSubview:self.lastView];
    [self.contentView addSubview:self.lastPrice];
    [self.contentView addSubview:self.cursorImgView];
    [self.contentView addSubview:self.cursorPrice];
}

- (void)autoLayout{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo([ChartsUtil fit:45]);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(-1);
        make.top.mas_equalTo([ChartsUtil fit:0]);
        make.bottom.mas_equalTo([ChartsUtil fit:7]);
    }];
    [_axisY1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.lastPrice);
        make.top.equalTo(self.contentView.mas_top).mas_offset([GUIUtil fit:1]);
        make.width.mas_lessThanOrEqualTo([ChartsUtil fit:40]);
    }];
    [_axisY2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.lastPrice);
        make.top.equalTo(self.contentView.mas_centerY).multipliedBy(1/2.0).mas_offset([GUIUtil fit:1]);
        make.width.mas_lessThanOrEqualTo([ChartsUtil fit:40]);
    }];
    [_axisY3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.lastPrice);
        make.bottom.equalTo(self.contentView.mas_centerY).multipliedBy(1).mas_offset([GUIUtil fit:-1]);
        make.width.mas_lessThanOrEqualTo([ChartsUtil fit:40]);
    }];
    [_axisY4Label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(self.lastPrice);
        make.bottom.equalTo(self.contentView.mas_centerY).multipliedBy(3/2.0).mas_offset([GUIUtil fit:-1]);
        make.width.mas_lessThanOrEqualTo([ChartsUtil fit:40]);
    }];
    [_axisY5Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.lastPrice);
        make.bottom.equalTo(self.contentView.mas_bottom).mas_offset([GUIUtil fit:-1]);
        make.width.mas_lessThanOrEqualTo([ChartsUtil fit:40]);
    }];
    [_axisY1Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo([ChartsUtil fitLine]);
        make.right.mas_equalTo([ChartsUtil fit:-0]);
//        make.right.equalTo(self.axisY1Label.mas_left).mas_offset([ChartsUtil fit:-2]);
    }];
    [_axisY2Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.multipliedBy(1/2.0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo([ChartsUtil fitLine]);
        make.right.mas_equalTo([ChartsUtil fit:-0]);
//        make.right.equalTo(self.axisY2Label.mas_left).mas_offset([ChartsUtil fit:-2]);
    }];
    [_axisY3Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.multipliedBy(1);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo([ChartsUtil fitLine]);
        make.right.mas_equalTo([ChartsUtil fit:-0]);
//        make.right.equalTo(self.axisY3Label.mas_left).mas_offset([ChartsUtil fit:-2]);
    }];
    [_axisY4Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.multipliedBy(3/2.0);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo([ChartsUtil fitLine]);
        make.right.mas_equalTo([ChartsUtil fit:-0]);
//        make.right.equalTo(self.axisY4Label.mas_left).mas_offset([ChartsUtil fit:-2]);
    }];
    [_axisY5Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo([ChartsUtil fitLine]);
        make.right.mas_equalTo([ChartsUtil fit:-0]);
//        make.right.equalTo(self.axisY5Label.mas_left).mas_offset([ChartsUtil fit:-2]);
    }];
    [_lastPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lastView).mas_offset([ChartsUtil fit:0]);
        make.right.mas_equalTo([GUIUtil fit:-5]);
        make.width.mas_lessThanOrEqualTo([ChartsUtil fit:40]);
    }];
    [_cursorPrice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.cursorImgView).mas_offset([ChartsUtil fit:0]);
        make.centerX.equalTo(self.cursorImgView).mas_offset([ChartsUtil fit:2]);
        make.width.mas_lessThanOrEqualTo([ChartsUtil fit:40]);
    }];
}

- (void)showCursorPrice:(NSString *)cursorPrice isLast:(BOOL)isLast{
    if (cursorPrice.length<=0||_minPrice.length<=0) {
        _cursorPrice.hidden = _cursorImgView.hidden = YES;
        return;
    }else{
        _cursorPrice.hidden = _cursorImgView.hidden = NO;
    }
    CGFloat price = 0;
    if (isLast) {
        price = [_lastPrice.text floatValue];
    }else{
        price = [cursorPrice floatValue];
    }
    if ([ChartsUtil compare:price withFloat:[_minPrice floatValue]]!= NSOrderedAscending&&
        [ChartsUtil compare:price withFloat:[_maxPrice floatValue]]!= NSOrderedDescending) {
        self.cursorPrice.hidden = self.cursorImgView.hidden = NO;
        CGFloat height = self.contentView.height;
        CGFloat lastH = ([_maxPrice floatValue]-price)/([_maxPrice floatValue]-[_minPrice floatValue])*height;
        self.cursorImgView.centerY = lastH;
        NSString *format = [DemoChartsModel stringFormatByDotNum:_precise];
        _cursorPrice.text = [NSString stringWithFormat:format,[cursorPrice floatValue]];
    }else
    {
        self.cursorPrice.hidden = self.cursorImgView.hidden = YES;
    }
}

- (void)setMaxAxis:(NSString *)maxY minY:(NSString *)minY preNum:(NSInteger)precise lastPrice:(NSString *)lastPrice isRed:(BOOL)isRed{
    
    if ([ChartsUtil compare:[minY floatValue] withFloat:[maxY floatValue]]==NSOrderedSame) {
        self.lastPrice.hidden = self.lastView.hidden = YES;
        _axisY1Label.text = maxY;
        _axisY5Label.text = minY;
        _axisY2Label.text = @"";
        _axisY3Label.text = @"";
        _axisY4Label.text = @"";
        return;
    }
    _minPrice = minY;
    _maxPrice = maxY;
    _precise = precise;
    _lastView.imageName = @"market_axis_red";
//    if (isRed) {
//        _lastView.image = [GColorUtil imageNamed:@"market_axis_red"];
//    }else{
//        _lastView.image = [GColorUtil imageNamed:@"market_axis_green"];
//    }
    CGFloat padding = ([maxY floatValue]-[minY floatValue])/4;
    NSString *format = [DemoChartsModel stringFormatByDotNum:precise];
    _axisY1Label.text = [NSString stringWithFormat:format,[maxY floatValue]];
    _axisY2Label.text = [NSString stringWithFormat:format,[maxY floatValue]-padding];
    _axisY3Label.text = [NSString stringWithFormat:format,[maxY floatValue]-padding*2];
    _axisY4Label.text = [NSString stringWithFormat:format,[maxY floatValue]-padding*3];
    _axisY5Label.text = [NSString stringWithFormat:format,[minY floatValue]];
    _lastPrice.text = [NSString stringWithFormat:format,[lastPrice floatValue]];
    CGFloat price = [lastPrice floatValue];
    
    if ([ChartsUtil compare:price withFloat:[minY floatValue]]!= NSOrderedAscending&&
        [ChartsUtil compare:price withFloat:[maxY floatValue]]!= NSOrderedDescending) {
        self.lastPrice.hidden = self.lastView.hidden = NO;
        CGFloat height = self.contentView.height;
        CGFloat lastH = ([maxY floatValue]-price)/([maxY floatValue]-[minY floatValue])*height;
        self.lastView.centerY = lastH;
    }else
    {
        self.lastPrice.hidden = self.lastView.hidden = YES;
    }
}

//MARK: - Getter

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (BaseImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[BaseImageView alloc] init];
    }
    return _bgImgView;
}

- (BaseLabel *)axisY1Label{
    if (!_axisY1Label) {
        _axisY1Label = [[BaseLabel alloc] init];
        _axisY1Label.txColor = C3_ColorType;
        _axisY1Label.font = [ChartsUtil fitBoldFont:8];
        _axisY1Label.textAlignment = NSTextAlignmentRight;
        _axisY1Label.adjustsFontSizeToFitWidth = YES;
        _axisY1Label.minimumScaleFactor = 0.5;

    }
    return _axisY1Label;
}

- (BaseLabel *)axisY2Label{
    if (!_axisY2Label) {
        _axisY2Label = [[BaseLabel alloc] init];
        _axisY2Label.txColor = C3_ColorType;
        _axisY2Label.font = [ChartsUtil fitBoldFont:8];
        _axisY2Label.textAlignment = NSTextAlignmentRight;
        _axisY2Label.adjustsFontSizeToFitWidth = YES;
        _axisY2Label.minimumScaleFactor = 0.5;
    }
    return _axisY2Label;
}

- (BaseLabel *)axisY3Label{
    if (!_axisY3Label) {
        _axisY3Label = [[BaseLabel alloc] init];
        _axisY3Label.txColor = C3_ColorType;
        _axisY3Label.font = [ChartsUtil fitBoldFont:8];
        _axisY3Label.textAlignment = NSTextAlignmentRight;
        _axisY3Label.adjustsFontSizeToFitWidth = YES;
        _axisY3Label.minimumScaleFactor = 0.5;
    }
    return _axisY3Label;
}

- (BaseLabel *)axisY4Label{
    if (!_axisY4Label) {
        _axisY4Label = [[BaseLabel alloc] init];
        _axisY4Label.font = [ChartsUtil fitBoldFont:8];
        _axisY4Label.txColor = C3_ColorType;
        _axisY4Label.textAlignment = NSTextAlignmentRight;
        _axisY4Label.adjustsFontSizeToFitWidth = YES;
        _axisY4Label.minimumScaleFactor = 0.5;

    }
    return _axisY4Label;
}

- (BaseLabel *)axisY5Label{
    if (!_axisY5Label) {
        _axisY5Label = [[BaseLabel alloc] init];
        _axisY5Label.font = [ChartsUtil fitBoldFont:8];
        _axisY5Label.txColor = C3_ColorType;
        _axisY5Label.textAlignment = NSTextAlignmentRight;
        _axisY5Label.adjustsFontSizeToFitWidth = YES;
        _axisY5Label.minimumScaleFactor = 0.5;
    }
    return _axisY5Label;
}

- (UIView *)axisY1Line{
    if (!_axisY1Line) {
        _axisY1Line = [[UIView alloc] init];
        _axisY1Line.backgroundColor = [ChartsUtil C7];
    }
    return _axisY1Line;
}
- (UIView *)axisY2Line{
    if (!_axisY2Line) {
        _axisY2Line = [[UIView alloc] init];
        _axisY2Line.backgroundColor = [ChartsUtil C7];
    }
    return _axisY2Line;
}
- (UIView *)axisY3Line{
    if (!_axisY3Line) {
        _axisY3Line = [[UIView alloc] init];
        _axisY3Line.backgroundColor = [ChartsUtil C7];
    }
    return _axisY3Line;
}
- (UIView *)axisY4Line{
    if (!_axisY4Line) {
        _axisY4Line = [[UIView alloc] init];
        _axisY4Line.backgroundColor = [ChartsUtil C7];
    }
    return _axisY4Line;
}

- (UIView *)axisY5Line{
    if (!_axisY5Line) {
        _axisY5Line = [[UIView alloc] init];
        _axisY5Line.backgroundColor = [ChartsUtil C7];
    }
    return _axisY5Line;
}

- (BaseLabel *)lastPrice{
    if (!_lastPrice) {
        _lastPrice = [[BaseLabel alloc] init];
        _lastPrice.font = [ChartsUtil fitBoldFont:8];
        _lastPrice.textColor = [ChartsUtil C2];
        _lastPrice.adjustsFontSizeToFitWidth = YES;
        _lastPrice.minimumScaleFactor = 0.5;
        _lastPrice.textAlignment = NSTextAlignmentCenter;
    }
    return _lastPrice;
}

- (BaseImageView *)lastView{
    if (!_lastView) {
        _lastView = [[BaseImageView alloc] initWithFrame:CGRectMake(0, 0, [ChartsUtil fit:45], [ChartsUtil fit:15])];
        _lastView.imageName = @"market_axis_red";
        _lastView.hidden = YES;
    }
    return _lastView;
}


- (BaseLabel *)cursorPrice{
    if (!_cursorPrice) {
        _cursorPrice = [[BaseLabel alloc] init];
        _cursorPrice.font = [ChartsUtil fitBoldFont:8];
        _cursorPrice.txColor = C2_ColorType;
        _cursorPrice.adjustsFontSizeToFitWidth = YES;
        _cursorPrice.minimumScaleFactor = 0.5;
        _cursorPrice.textAlignment = NSTextAlignmentCenter;
        _cursorPrice.hidden = YES;
    }
    return _cursorPrice;
}

- (BaseImageView *)cursorImgView{
    if (!_cursorImgView) {
        _cursorImgView = [[BaseImageView alloc] initWithFrame:CGRectMake(0, 0, [ChartsUtil fit:45], [ChartsUtil fit:15])];
        _cursorImgView.imageName = @"market_axis_gray";
        _cursorImgView.hidden = YES;
    }
    return _cursorImgView;
}

- (void)themeChangedAction{
    _axisY1Line.backgroundColor = [ChartsUtil C7];
    _axisY2Line.backgroundColor = [ChartsUtil C7];
    _axisY3Line.backgroundColor = [ChartsUtil C7];
    _axisY4Line.backgroundColor = [ChartsUtil C7];
    _axisY5Line.backgroundColor = [ChartsUtil C7];
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


@interface BottomAxisView()

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) BaseLabel *axisMaxYLabel;
@property (nonatomic,strong) UIView *axisMaxYLine;
@property (nonatomic,strong) BaseLabel *axisMinYLabel;
@property (nonatomic,strong) UIView *axisMinYLine;

@property (nonatomic,strong) BaseLabel *axisY1Label;
@property (nonatomic,strong) UIView *axisY1Line;
@property (nonatomic,strong) BaseLabel *axisY2Label;
@property (nonatomic,strong) UIView *axisY2Line;

@end

@implementation BottomAxisView

- (void)dealloc{
    [self removeNotic];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = NO;
        [self setupUI];
        [self autoLayout];
        [self addNotic];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.bgImgView];
    [self.contentView addSubview:self.axisMaxYLabel];
    [self.contentView addSubview:self.axisMaxYLine];
    [self.contentView addSubview:self.axisMinYLabel];
    [self.contentView addSubview:self.axisMinYLine];
    [self.contentView addSubview:self.axisY1Label];
    [self.contentView addSubview:self.axisY1Line];
    [self.contentView addSubview:self.axisY2Label];
    [self.contentView addSubview:self.axisY2Line];
}

- (void)autoLayout{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo([ChartsUtil fit:45]);
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    [_bgImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo([ChartsUtil fit:0]);
        make.bottom.mas_equalTo([ChartsUtil fit:0]);
    }];
    [_axisMaxYLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.mas_equalTo([GUIUtil fit:-5]);
        make.top.equalTo(self.contentView.mas_top);
        make.width.mas_lessThanOrEqualTo([ChartsUtil fit:40]);
    }];
    
    [_axisMaxYLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo([ChartsUtil fitLine]);
        make.right.mas_equalTo([ChartsUtil fit:0]);
//        make.right.equalTo(self.axisMaxYLabel.mas_left).mas_offset([ChartsUtil fit:-2]);
    }];
    [_axisMinYLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-5]);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.width.mas_lessThanOrEqualTo([ChartsUtil fit:40]);
    }];
    [_axisMinYLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_bottom);
        make.left.mas_equalTo(-SCREEN_HEIGHT);
        make.height.mas_equalTo([ChartsUtil fitLine]);
        make.right.mas_equalTo([ChartsUtil fit:0]);
//        make.right.equalTo(self.axisMinYLabel.mas_left).mas_offset([ChartsUtil fit:-2]);
    }];
    [_axisY1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-5]);
        make.width.mas_lessThanOrEqualTo([ChartsUtil fit:40]);
    }];
    [_axisY1Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.axisY1Label);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo([ChartsUtil fitLine]);
        make.right.equalTo(self.axisMinYLabel.mas_left).mas_offset([ChartsUtil fit:0]);
    }];
    [_axisY2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-5]);
        make.width.mas_lessThanOrEqualTo([ChartsUtil fit:40]);
    }];
    [_axisY2Line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.axisY2Label);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo([ChartsUtil fitLine]);
        make.right.equalTo(self.axisMinYLabel.mas_left).mas_offset([ChartsUtil fit:0]);
    }];
}


- (void)setMaxAxis:(NSString *)maxY minY:(NSString *)minY{
    
    _axisMaxYLabel.text = maxY;
    _axisMinYLabel.text = minY;
    _axisY1Label.hidden = _axisY1Line.hidden =
    _axisY2Label.hidden = _axisY2Line.hidden = YES;
}

- (void)setY1:(NSString *)y1 setY2:(NSString *)y2 height:(CGFloat)height{
    _axisY1Label.hidden = _axisY1Line.hidden =
    _axisY2Label.hidden = _axisY2Line.hidden = YES;
}

//MARK: - Getter

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (BaseImageView *)bgImgView{
    if (!_bgImgView) {
        _bgImgView = [[BaseImageView alloc] init];
        
    }
    return _bgImgView;
}

- (BaseLabel *)axisMaxYLabel{
    if (!_axisMaxYLabel) {
        _axisMaxYLabel = [[BaseLabel alloc] init];
        _axisMaxYLabel.txColor = C3_ColorType;
        _axisMaxYLabel.font = [ChartsUtil fitBoldFont:8];
        _axisMaxYLabel.textAlignment = NSTextAlignmentRight;
        _axisMaxYLabel.adjustsFontSizeToFitWidth = YES;
        _axisMaxYLabel.minimumScaleFactor = 0.5;
        
    }
    return _axisMaxYLabel;
}

- (BaseLabel *)axisMinYLabel{
    if (!_axisMinYLabel) {
        _axisMinYLabel = [[BaseLabel alloc] init];
        _axisMinYLabel.font = [ChartsUtil fitBoldFont:8];
        _axisMinYLabel.txColor = C3_ColorType;
        _axisMinYLabel.textAlignment = NSTextAlignmentRight;
        _axisMinYLabel.adjustsFontSizeToFitWidth = YES;
        _axisMinYLabel.minimumScaleFactor = 0.5;
    }
    return _axisMinYLabel;
}

- (UIView *)axisMaxYLine{
    if (!_axisMaxYLine) {
        _axisMaxYLine = [[UIView alloc] init];
        _axisMaxYLine.backgroundColor = [ChartsUtil C7];
        _axisMaxYLine.hidden = YES;
    }
    return _axisMaxYLine;
}

- (UIView *)axisMinYLine{
    if (!_axisMinYLine) {
        _axisMinYLine = [[UIView alloc] init];
        _axisMinYLine.backgroundColor = [ChartsUtil C7];
    }
    return _axisMinYLine;
}

- (BaseLabel *)axisY1Label{
    if (!_axisY1Label) {
        _axisY1Label = [[BaseLabel alloc] init];
        _axisY1Label.font = [ChartsUtil fitBoldFont:8];
        _axisY1Label.txColor = C3_ColorType;
        _axisY1Label.textAlignment = NSTextAlignmentRight;
        _axisY1Label.adjustsFontSizeToFitWidth = YES;
        _axisY1Label.minimumScaleFactor = 0.5;
        _axisY1Label.hidden = YES;
    }
    return _axisY1Label;
}

- (UIView *)axisY1Line{
    if (!_axisY1Line) {
        _axisY1Line = [[UIView alloc] init];
        _axisY1Line.backgroundColor = [ChartsUtil C7];
        _axisY1Line.hidden = YES;
    }
    return _axisY1Line;
}

- (BaseLabel *)axisY2Label{
    if (!_axisY2Label) {
        _axisY2Label = [[BaseLabel alloc] init];
        _axisY2Label.font = [ChartsUtil fitBoldFont:8];
        _axisY2Label.txColor = C3_ColorType;
        _axisY2Label.textAlignment = NSTextAlignmentRight;
        _axisY2Label.adjustsFontSizeToFitWidth = YES;
        _axisY2Label.minimumScaleFactor = 0.5;
        _axisY2Label.hidden = YES;
    }
    return _axisY2Label;
}

- (UIView *)axisY2Line{
    if (!_axisY2Line) {
        _axisY2Line = [[UIView alloc] init];
        _axisY2Line.backgroundColor = [ChartsUtil C7];
        _axisY2Line.hidden = YES;
    }
    return _axisY2Line;
}


- (void)themeChangedAction{
    _axisY2Line.backgroundColor = [ChartsUtil C7];
    _axisY1Line.backgroundColor = [ChartsUtil C7];
    _axisMaxYLine.backgroundColor = [ChartsUtil C7];
    _axisMinYLine.backgroundColor = [ChartsUtil C7];
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

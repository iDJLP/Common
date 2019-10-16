//
//  CFDChartsInfoView.m
//  globalwin
//
//  Created by ngw15 on 2018/8/1.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "ChartsInfoView.h"
#import "View.h"


@interface ChartsInfoView ()

@property (nonatomic,strong)UILabel *lastPriceLabel;
@property (nonatomic,strong)UILabel *updownLabel;
@property (nonatomic,strong)SingleInfoView *highView;
@property (nonatomic,strong)SingleInfoView *lowView;
@property (nonatomic,strong)SingleInfoView *volView;


@end

@implementation ChartsInfoView

+ (CGFloat)heightOfView{
    return [GUIUtil fitBoldFont:30].lineHeight+[GUIUtil fit:17]+[GUIUtil fitFont:14].lineHeight;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [GColorUtil C6];
        [self initUI];
        [self layout];
    }
    return self;
}

- (void)initUI{
    [self addSubview:self.highView];
    [self addSubview:self.lowView];
    [self addSubview:self.volView];
    [self addSubview:self.lastPriceLabel];
    [self addSubview:self.updownLabel];
   
}

- (void)layout{
    CGFloat width = (SCREEN_WIDTH-[GUIUtil fit:30])/3;
    [_highView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:7]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.width.mas_equalTo(width);
    }];
    [_lowView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.highView.mas_bottom).mas_offset([GUIUtil fit:7]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.width.mas_equalTo(width);
    }];
    [_volView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lowView.mas_bottom).mas_offset([GUIUtil fit:7]);
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.width.mas_equalTo(width);
    }];
    
    [_lastPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:3]);
        make.left.mas_equalTo([GUIUtil fit:13]);
    }];
    [_updownLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:17]);
        make.top.equalTo(self.lastPriceLabel.mas_bottom).mas_equalTo([GUIUtil fit:4]);
    }];
}

//MARK: - Action


- (void)configOfView:(NSMutableDictionary *)config{
    if (![config isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [_highView configOfInfo:config[@"high"]];
    [_lowView configOfInfo:config[@"low"]];
    [_volView configOfInfo:config[@"vol"]];
    _lastPriceLabel.text = config[@"lastPrice"];
    _updownLabel.text = [NSString stringWithFormat:@"%@  %@",config[@"updown"],config[@"updownRate"]];
    _updownLabel.textColor =
    _lastPriceLabel.textColor = [GColorUtil colorWithProfitString:config[@"updown"]];
}


//MARK:Getter

- (SingleInfoView *)highView{
    if (!_highView) {
        _highView = [[SingleInfoView alloc] init];
        _highView.alignment = SingleInfoAlignmentSide;
        [_highView setValueColor:C2_ColorType];
    }
    return _highView;
}

- (SingleInfoView *)lowView{
    if (!_lowView) {
        _lowView = [[SingleInfoView alloc] init];
        _lowView.alignment = SingleInfoAlignmentSide;
        [_lowView setValueColor:C2_ColorType];
    }
    return _lowView;
}

- (SingleInfoView *)volView{
    if (!_volView) {
        _volView = [[SingleInfoView alloc] init];
        _volView.alignment = SingleInfoAlignmentSide;
        [_volView setValueColor:C2_ColorType];
    }
    return _volView;
}

- (UILabel *)lastPriceLabel{
    if (!_lastPriceLabel) {
        _lastPriceLabel = [[UILabel alloc] init];
        _lastPriceLabel.font = [GUIUtil fitBoldFont:30];
    }
    return _lastPriceLabel;
}

- (UILabel *)updownLabel{
    if (!_updownLabel) {
        _updownLabel = [[UILabel alloc] init];
        _updownLabel.font = [GUIUtil fitFont:14];
    }
    return _updownLabel;
}

@end

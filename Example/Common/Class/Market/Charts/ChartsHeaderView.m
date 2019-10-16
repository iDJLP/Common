//
//  ChartsHeaderView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/18.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "ChartsHeaderView.h"

@interface ChartsHeaderView ()

@property (nonatomic,strong)UIButton *backBtn;
@property (nonatomic,strong)UIControl *centerControl;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UIImageView *arrowImgView;
@property (nonatomic,strong)UILabel *remarkLabel;
@end

@implementation ChartsHeaderView

+ (CGFloat)heightOfView{
    return STATUS_BAR_HEIGHT + [GUIUtil fit:10] + [GUIUtil fitBoldFont:18].lineHeight +[GUIUtil fitFont:10].lineHeight +[GUIUtil fit:5];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [GColorUtil C6];
    [self addSubview:self.centerControl];
    [self addSubview:self.backBtn];
    [self addSubview:self.titleLabel];
    [self addSubview:self.arrowImgView];
    [self addSubview:self.remarkLabel];
}

- (void)autoLayout{
    [_backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.top.mas_equalTo(STATUS_BAR_HEIGHT+[GUIUtil fit:15]);
        make.size.mas_equalTo(CGSizeMake(24, 24));
    }];
    [_centerControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo([GUIUtil fit:200]);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backBtn).mas_offset([GUIUtil fit:-6]);
        make.centerX.mas_equalTo([GUIUtil fit:-6]);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset([GUIUtil fit:0]);
        make.centerX.mas_equalTo(0);
    }];
    [_arrowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).mas_offset([GUIUtil fit:4]);
    }];
}

- (void)backAction{
    _backHander();
}

- (void)configData:(NSDictionary *)data{
    _titleLabel.text = [NDataUtil stringWith:data[@"title"]];
    _remarkLabel.text = [NDataUtil stringWith:data[@"remark"]];
    _arrowImgView.hidden = NO;
}

- (void)changedArrow:(BOOL)isSelected{
    _arrowImgView.image = isSelected ? [GColorUtil imageNamed:@"market_icon_under_blue_up"]:[GColorUtil imageNamed:@"market_icon_under_blue_down"];
}

//MARK: - Getter

- (UIControl *)centerControl{
    if (!_centerControl) {
        _centerControl = [[UIControl alloc] init];
        _centerControl.backgroundColor = [UIColor clearColor];
        WEAK_SELF;
        [_centerControl g_clickBlock:^(UITapGestureRecognizer *tap) {
            weakSelf.tapHander();
            weakSelf.centerControl.userInteractionEnabled = NO;
            [NTimeUtil run:^{
                weakSelf.centerControl.userInteractionEnabled = YES;
            } delay:0.5];
        }];
        
    }
    return _centerControl;
}

- (UIImageView *)arrowImgView{
    if (!_arrowImgView) {
        _arrowImgView = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"market_icon_under_blue_down"]];
    }
    return _arrowImgView;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [GColorUtil C2];
        _titleLabel.font = [GUIUtil fitBoldFont:18];
    }
    return _titleLabel;
}

- (UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.textColor = [GColorUtil C3];
        _remarkLabel.font = [GUIUtil fitFont:10];
    }
    return _remarkLabel;
}

- (UIButton *)backBtn{
    if (!_backBtn) {
        _backBtn = [[UIButton alloc]init];
        [_backBtn setImage:[GColorUtil imageNamed:@"nav_icon_back"] forState:UIControlStateNormal];
        [_backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [_backBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _backBtn;
}

@end

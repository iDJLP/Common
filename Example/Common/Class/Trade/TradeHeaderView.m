//
//  TradeHeaderView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "TradeHeaderView.h"
#import "BaseLabel.h"
#import "BaseImageView.h"
#import "BaseBtn.h"
#import "Popover.h"
#import "RuleVC.h"
#import "CalculatorVC.h"

@interface TradeHeaderView ()

@property (nonatomic,strong)UIControl *leftControl;
@property (nonatomic,strong)BaseLabel *titleLabel;
@property (nonatomic,strong)BaseImageView *leftImgView;
@property (nonatomic,strong)BaseBtn *rightBtn;
@property (nonatomic,strong)BaseBtn *right1Btn;

@end

@implementation TradeHeaderView

+ (CGFloat)heightOfView{
    return TOP_BAR_HEIGHT;
}
- (instancetype)init{
    if (self = [super init]) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [GColorUtil C6];
    [self addSubview:self.leftControl];
    [self addSubview:self.titleLabel];
    [self addSubview:self.leftImgView];
    [self addSubview:self.rightBtn];
    [self addSubview:self.right1Btn];
}

- (void)autoLayout{
    [_rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right1Btn.mas_left).mas_offset([GUIUtil fit:-15]);
        make.centerY.equalTo(self.mas_top).mas_offset(STATUS_BAR_HEIGHT+22);
        make.size.mas_equalTo(CGSizeMake(18, 20));
    }];
    [_right1Btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.equalTo(self.mas_top).mas_offset(STATUS_BAR_HEIGHT+22);
        //        make.size.mas_equalTo(CGSizeMake(18, 20));
    }];
    [_leftControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(STATUS_BAR_HEIGHT);
        make.bottom.mas_equalTo(0);
        make.width.mas_equalTo([GUIUtil fit:200]);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rightBtn);
        make.left.equalTo(self.leftImgView.mas_right).mas_offset([GUIUtil fit:4]);
    }];
    
    [_leftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.rightBtn);
        make.left.mas_equalTo([GUIUtil fit:15]);
    }];
}

- (void)configView:(NSDictionary *)dic{
    _config = dic;
    NSString *title = [NDataUtil stringWith:dic[@"title"]];
    _titleLabel.text = title;
    //    if (title.length>0) {
    //    }
}

- (void)centerTapAction{
    _tapHander();
}

- (void)rightAction{
    if (_config.count>0) {
        _rightHander([NDataUtil stringWith:_config[@"symbol"]]);
    }
}

- (void)right1Action{
    if (_config.count>0) {
        _right1Hander([NDataUtil stringWith:_config[@"symbol"]]);
    }
//    //    [CFDJumpUtil jumpToService];
//    NSDictionary *dict = @{@"title":@"规则说明",@"icon":@"pop_icon_rules",@"type":@"1"};
//    NSDictionary *dict1 = @{@"title":@"计算器",@"icon":@"pop_icon_calculator",@"type":@"2"};
//    WEAK_SELF;
//    [Popover showAlert:@[dict,dict1] rect:CGRectMake([GUIUtil fit:240], TOP_BAR_HEIGHT-[GUIUtil fit:5], [GUIUtil fit:130], [GUIUtil fit:95]) sureHander:^(NSDictionary * _Nonnull dict) {
//        if ([NDataUtil boolWithDic:dict key:@"type" isEqual:@"1"]) {
//            [RuleVC jumpTo:weakSelf.config[@"symbol"]];
//        }else if ([NDataUtil boolWithDic:dict key:@"type" isEqual:@"2"]){
//            [CalculatorVC jumpTo:weakSelf.config];
//        }
//    }];
}

- (void)configData:(NSDictionary *)data{
    _titleLabel.text = [NDataUtil stringWith:data[@"title"]];
    _leftImgView.hidden = NO;
}

//MARK: - Getter

- (UIControl *)leftControl{
    if (!_leftControl) {
        _leftControl = [[UIControl alloc] init];
        _leftControl.backgroundColor = [UIColor clearColor];
        WEAK_SELF;
        [_leftControl g_clickBlock:^(UITapGestureRecognizer *tap) {
            [weakSelf centerTapAction];
            weakSelf.leftControl.userInteractionEnabled = NO;
            [NTimeUtil run:^{
                weakSelf.leftControl.userInteractionEnabled = YES;
            } delay:0.5];
        }];
    }
    return _leftControl;
}

- (BaseImageView *)leftImgView{
    if (!_leftImgView) {
        _leftImgView = [[BaseImageView alloc] init];
        _leftImgView.imageName = @"trade_icon_menu";
    }
    return _leftImgView;
}

- (BaseLabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[BaseLabel alloc] init];
        _titleLabel.txColor = C2_ColorType;
        _titleLabel.font = [GUIUtil fitBoldFont:16];
    }
    return _titleLabel;
}

- (BaseBtn *)rightBtn{
    if (!_rightBtn) {
        _rightBtn = [[BaseBtn alloc]init];
        _rightBtn.imageName = @"trade_icon_menu_market";
        [_rightBtn addTarget:self action:@selector(rightAction) forControlEvents:UIControlEventTouchUpInside];
        [_rightBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _rightBtn;
}

- (BaseBtn *)right1Btn{
    if (!_right1Btn) {
        _right1Btn = [[BaseBtn alloc] init];
        _right1Btn.imageName = @"trade_icon_menu_more";
        [_right1Btn addTarget:self action:@selector(right1Action) forControlEvents:UIControlEventTouchUpInside];
        [_right1Btn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _right1Btn;
}


@end

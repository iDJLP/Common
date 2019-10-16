//
//  HIndexSelectedView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/29.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "HIndexSelectedView.h"

@interface HIndexSelectedView ()

@property (nonatomic,strong) UILabel *firstTitleLabel;
@property (nonatomic,strong) UIButton *firstShowBtn;
@property (nonatomic,strong) UILabel *secondTitleLabel;
@property (nonatomic,strong) UIButton *secondShowBtn;
@property (nonatomic,strong) NSArray <NSArray *>*titles;

@end

#define MinuteBackgHighlighteddColor [ChartsUtil colorWithHex:0x3c414d]

@implementation HIndexSelectedView

-(void)dealloc
{
}

-(instancetype)initWithTitles:(NSArray<NSArray *> *)titles frame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        _titles = titles;
        [self initKlineBtnList];
    }
    return self;
}

-(void)initKlineBtnList
{
    NSInteger index= 1;
    for (NSInteger i=0;i<_titles.count;i++)
    {
        NSArray *data = _titles[i];
        for (NSInteger j=0; j<data.count; j++) {
            UIButton *minuteBtn=[[UIButton alloc] init];
            NSString *title = @"";
            if (i==0) {
                EIndexTopType type = [NDataUtil integerWith:data[j]];
                if (type==EIndexTopTypeBool) {
                    title = @"BOLL";
                }else if (type==EIndexTopTypeMa){
                    title = @"MA";
                }else{
                    continue;
                }
                minuteBtn.tag=1480+type;
            }else{
                EIndexType type = [NDataUtil integerWith:data[j]];
                if (type==EIndexTypeMacd) {
                    title = @"MACD";
                }else if (type==EIndexTypeKdj){
                    title = @"KDJ";
                }else if (type==EIndexTypeRsi){
                    title = @"RSI";
                }else if (type==EIndexTypeWR){
                    title = @"WR";
                }else{
                    continue;
                }
                minuteBtn.tag=1480+type;
            }
            [minuteBtn setTitle:title  forState:UIControlStateNormal];
            minuteBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
            [minuteBtn.titleLabel setFont:[ChartsUtil fitFont:12]];
            [minuteBtn setTitleColor:[ChartsUtil C18] forState:UIControlStateNormal];
            [minuteBtn setTitleColor:[ChartsUtil C19] forState:UIControlStateSelected];
            [minuteBtn setTitleColor:[ChartsUtil C19] forState:UIControlStateHighlighted];
            [minuteBtn  setBackgroundImage:[UIImage imageWithColor:MinuteBackgHighlighteddColor] forState:UIControlStateHighlighted];
            [minuteBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            CGFloat width = [GUIUtil fit:65];
            CGFloat top = [GUIUtil fit:28]*index;
            
            [minuteBtn setFrame:CGRectMake([GUIUtil fit:-3], top, width, [GUIUtil fit:28])];
            minuteBtn.selected=NO;
            minuteBtn.userInteractionEnabled=YES;
            [self addSubview:minuteBtn];
            index++;
        }
        index++;
        index++;
    }
    [self addSubview:self.firstTitleLabel];
    [self addSubview:self.firstShowBtn];
    [self addSubview:self.secondTitleLabel];
    [self addSubview:self.secondShowBtn];
    [_firstTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:-3]);
        make.height.mas_equalTo([GUIUtil fit:28]);
        make.top.mas_equalTo([GUIUtil fit:0]);
        make.width.mas_equalTo([GUIUtil fit:65]);
    }];
    [_firstShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:-3]);
        make.height.mas_equalTo([GUIUtil fit:28]);
        make.top.mas_equalTo([GUIUtil fit:28]*3);
        make.width.mas_equalTo([GUIUtil fit:65]);
    }];
    [_secondTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:-3]);
        make.height.mas_equalTo([GUIUtil fit:28]);
        make.top.mas_equalTo([GUIUtil fit:28]*4);
        make.width.mas_equalTo([GUIUtil fit:65]);
    }];
    [_secondShowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:-3]);
        make.height.mas_equalTo([GUIUtil fit:28]);
        make.top.mas_equalTo([GUIUtil fit:28]*9);
        make.width.mas_equalTo([GUIUtil fit:65]);
    }];
    [self configBtnSelected];
}

- (UIImageView *)backImageView {
    
    UIImageView *imgBackView  = [[UIImageView alloc] init];
    imgBackView.backgroundColor = [GColorUtil C8];
    imgBackView.layer.cornerRadius = 4;
    imgBackView.layer.masksToBounds = YES;
    return imgBackView;
}

- (void)showAction:(UIButton *)btn{
    if (btn.selected) {
        return;
    }
    if (btn==_firstShowBtn) {
        [_config setObject:@(EIndexTopTypeNone) forKey:@"topIndex"];
    }else{
        [_config setObject:@(EIndexTypeNone) forKey:@"bottomIndex"];
    }
    [self configBtnSelected];
}

//点击了类型btn
-(void)typeBtnClick:(UIButton*)sender
{
    if (sender.selected)
    {
        return;
    }
    UIButton * btn = (UIButton*)sender;
    NSInteger index = btn.tag - 1480;
    
    if (index>=10) {
        [_config setObject:@(index) forKey:@"bottomIndex"];
    }else{
        [_config setObject:@(index) forKey:@"topIndex"];
    }
    [self configBtnSelected];
    _selectedIndexHander(_config);
}

- (void)setConfig:(NSMutableDictionary *)config{
    _config = config;
    [self configBtnSelected];
    WEAK_SELF;
    [NTimeUtil run:^{
        weakSelf.selectedIndexHander(weakSelf.config);
    } delay:0.3];
    
}

- (void)configBtnSelected{
    EIndexType indexType = [_config[@"bottomIndex"] integerValue];
    EIndexTopType indexTopType = [_config[@"topIndex"] integerValue];
    
    for (UIButton *btn in self.subviews) {
        if ([btn isKindOfClass:UIButton.class]) {
            btn.selected = btn.tag-1480==indexType||btn.tag-1480==indexTopType;
        }
    }
}

- (UILabel *)firstTitleLabel{
    if (!_firstTitleLabel) {
        _firstTitleLabel = [[UILabel alloc] init];
        _firstTitleLabel.textColor = [ChartsUtil C18];
        _firstTitleLabel.font = [GUIUtil fitFont:12];
        _firstTitleLabel.textAlignment = NSTextAlignmentCenter;
        _firstTitleLabel.backgroundColor = [GColorUtil C6];
        _firstTitleLabel.text = CFDLocalizedString(@"主图");
    }
    return _firstTitleLabel;
}

- (UIButton *)firstShowBtn{
    if (!_firstShowBtn) {
        _firstShowBtn = [[UIButton alloc] init];
        [_firstShowBtn setImage:[GColorUtil imageNamed:@"market_icon_eye"] forState:UIControlStateNormal];
        [_firstShowBtn setImage:[GColorUtil imageNamed:@"market_icon_eye_close"] forState:UIControlStateSelected];
        [_firstShowBtn addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
        _firstShowBtn.tag = 1480 + EIndexTopTypeNone;
    }
    return _firstShowBtn;
}

- (UILabel *)secondTitleLabel{
    if (!_secondTitleLabel) {
        _secondTitleLabel = [[UILabel alloc] init];
        _secondTitleLabel.textColor = [ChartsUtil C18];
        _secondTitleLabel.font = [GUIUtil fitFont:12];
        _secondTitleLabel.textAlignment = NSTextAlignmentCenter;
        _secondTitleLabel.text = CFDLocalizedString(@"副图");;
    }
    
    return _secondTitleLabel;
}

- (UIButton *)secondShowBtn{
    if (!_secondShowBtn) {
        _secondShowBtn = [[UIButton alloc] init];
        [_secondShowBtn setImage:[GColorUtil imageNamed:@"market_icon_eye"] forState:UIControlStateNormal];
        [_secondShowBtn setImage:[GColorUtil imageNamed:@"market_icon_eye_close"] forState:UIControlStateSelected];
        [_secondShowBtn addTarget:self action:@selector(showAction:) forControlEvents:UIControlEventTouchUpInside];
        _secondShowBtn.tag = 1480 + EIndexTypeNone;
    }
    return _secondShowBtn;
}

@end

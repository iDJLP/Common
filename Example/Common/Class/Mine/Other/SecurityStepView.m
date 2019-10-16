//
//  SecurityStepView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/5/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "SecurityStepView.h"

@interface SecurityStepView ()

@property (nonatomic,strong)UILabel *step1Label;
@property (nonatomic,strong)UILabel *step2Label;
@property (nonatomic,strong)UILabel *step3Label;
@property (nonatomic,strong)UIView *step1Dot;
@property (nonatomic,strong)UIView *step2Dot;
@property (nonatomic,strong)UIView *step3Dot;
@property (nonatomic,strong)UIView *bgLine;
@property (nonatomic,strong)UIView *selLine;

@end

@implementation SecurityStepView

+ (CGFloat)heightOfView{
    
    return 0;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self autoLayout];
        [self configOfStep:1];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.step1Label];
    [self addSubview:self.step2Label];
    [self addSubview:self.step3Label];
    [self addSubview:self.step1Dot];
    [self addSubview:self.step2Dot];
    [self addSubview:self.step3Dot];
    [self addSubview:self.bgLine];
    [self addSubview:self.selLine];
}

- (void)autoLayout{
    [_step1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).mas_offset([GUIUtil fit:63]);
        make.top.mas_equalTo([GUIUtil fit:35]);
    }];
    [_step2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).mas_offset([GUIUtil fit:187]);
        make.top.mas_equalTo([GUIUtil fit:35]);
    }];
    [_step3Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_left).mas_offset([GUIUtil fit:312]);
        make.top.mas_equalTo([GUIUtil fit:35]);
    }];
    [_step1Dot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.step1Label);
        make.top.equalTo(self.step1Label.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.size.mas_equalTo([GUIUtil fitWidth:8 height:8]);
    }];
    [_step2Dot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.step2Label);
        make.top.equalTo(self.step1Label.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.size.mas_equalTo([GUIUtil fitWidth:8 height:8]);
    }];
    [_step3Dot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.step3Label);
        make.top.equalTo(self.step1Label.mas_bottom).mas_offset([GUIUtil fit:10]);
        make.size.mas_equalTo([GUIUtil fitWidth:8 height:8]);
    }];
    [_bgLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.step1Dot);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:1]);
    }];
    [_selLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.step1Dot);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:1]);
        make.bottom.mas_equalTo([GUIUtil fit:-25]);
    }];
}

- (void)configOfStep:(NSInteger)index{
    if (index==1) {
        _step1Label.textColor = [GColorUtil C13];
        _step1Dot.backgroundColor = [GColorUtil C13];
        _step1Dot.layer.shadowColor = [GColorUtil colorWithColorType:C13_ColorType alpha:1].CGColor;
        [_selLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([GUIUtil fit:125]);
        }];
    }else if (index==2){
        _step1Label.textColor = [GColorUtil C13];
        _step1Dot.backgroundColor = [GColorUtil C13];
        _step1Dot.layer.shadowColor = [GColorUtil colorWithColorType:C13_ColorType alpha:1].CGColor;
        _step2Label.textColor = [GColorUtil C13];
        _step2Dot.backgroundColor = [GColorUtil C13];
        _step2Dot.layer.shadowColor = [GColorUtil colorWithColorType:C13_ColorType alpha:1].CGColor;
        [_selLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([GUIUtil fit:250]);
        }];
    }else{
        _step1Label.textColor = [GColorUtil C13];
        _step1Dot.backgroundColor = [GColorUtil C13];
        _step1Dot.layer.shadowColor = [GColorUtil colorWithColorType:C13_ColorType alpha:1].CGColor;
        _step2Label.textColor = [GColorUtil C13];
        _step2Dot.backgroundColor = [GColorUtil C13];
        _step2Dot.layer.shadowColor = [GColorUtil colorWithColorType:C13_ColorType alpha:1].CGColor;
        _step3Label.textColor = [GColorUtil C13];
        _step3Dot.backgroundColor = [GColorUtil C13];
        _step3Dot.layer.shadowColor = [GColorUtil colorWithColorType:C13_ColorType alpha:1].CGColor;
        [_selLine mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([GUIUtil fit:375]);
        }];
    }
}
//MARK:Getter

-(UILabel *)step1Label{
    if(!_step1Label){
        _step1Label = [[UILabel alloc] init];
        _step1Label.textColor = [GColorUtil C3];
        _step1Label.font = [GUIUtil fitFont:14];
        _step1Label.text = CFDLocalizedString(@"安装验证器");
    }
    return _step1Label;
}
-(UILabel *)step2Label{
    if(!_step2Label){
        _step2Label = [[UILabel alloc] init];
        _step2Label.textColor = [GColorUtil C3];
        _step2Label.font = [GUIUtil fitFont:14];
        _step2Label.text = CFDLocalizedString(@"绑定验证器");
    }
    return _step2Label;
}
-(UILabel *)step3Label{
    if(!_step3Label){
        _step3Label = [[UILabel alloc] init];
        _step3Label.textColor = [GColorUtil C3];
        _step3Label.font = [GUIUtil fitFont:14];
        _step3Label.text = CFDLocalizedString(@"输入验证码");
    }
    return _step3Label;
}
-(UIView *)step1Dot{
    if(!_step1Dot){
        _step1Dot = [[UIView alloc] init];
        _step1Dot.backgroundColor = [GColorUtil C8];
        _step1Dot.layer.cornerRadius = [GUIUtil fit:4];
        _step1Dot.layer.shadowColor = [GColorUtil colorWithColorType:C8_ColorType alpha:1].CGColor;
        _step1Dot.layer.shadowOffset = CGSizeMake(0, 0);
        _step1Dot.layer.shadowRadius = [GUIUtil fit:8];
        _step1Dot.layer.shadowOpacity = 1;
    }
    return _step1Dot;
}
-(UIView *)step2Dot{
    if(!_step2Dot){
        _step2Dot = [[UIView alloc] init];
        _step2Dot.backgroundColor = [GColorUtil C8];
        _step2Dot.layer.cornerRadius = [GUIUtil fit:4];
        _step2Dot.layer.shadowColor = [GColorUtil colorWithColorType:C8_ColorType alpha:1].CGColor;
        _step2Dot.layer.shadowOffset = CGSizeMake(0, 0);
        _step2Dot.layer.shadowRadius = [GUIUtil fit:8];
        _step2Dot.layer.shadowOpacity = 1;
    }
    return _step2Dot;
}
-(UIView *)step3Dot{
    if(!_step3Dot){
        _step3Dot = [[UIView alloc] init];
        _step3Dot.backgroundColor = [GColorUtil C8];
        _step3Dot.layer.cornerRadius = [GUIUtil fit:4];
        _step3Dot.layer.shadowColor = [GColorUtil colorWithColorType:C8_ColorType alpha:1].CGColor;
        _step3Dot.layer.shadowOffset = CGSizeMake(0, 0);
        _step3Dot.layer.shadowRadius = [GUIUtil fit:8];
        _step3Dot.layer.shadowOpacity = 1;
    }
    return _step3Dot;
}
-(UIView *)bgLine{
    if(!_bgLine){
        _bgLine = [[UIView alloc] init];
        _bgLine.backgroundColor = [GColorUtil C8];
    }
    return _bgLine;
}
-(UIView *)selLine{
    if(!_selLine){
        _selLine = [[UIView alloc] init];
        _selLine.backgroundColor = [GColorUtil C13];
    }
    return _selLine;
}



@end

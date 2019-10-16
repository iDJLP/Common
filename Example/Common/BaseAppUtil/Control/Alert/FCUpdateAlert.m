//
//  FCUpdateAlert.m
//  newfcox
//
//  Created by ngw15 on 2018/4/26.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "FCUpdateAlert.h"
#import "YYKit.h"
#import "DCService.h"

@interface FCUpdateAlertView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong)UIImageView *topImg;

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UILabel *versionLabel;
@property (nonatomic,strong) UILabel *remarkLabel;
@property (nonatomic,strong) UIButton *sureBtn;

@property (nonatomic,strong) dispatch_block_t sureHander;

@end

@implementation FCUpdateAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [GColorUtil colorWithHex:0x000000 alpha:0.4];
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.topImg];
    [self.contentView addSubview:self.closeBtn];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.versionLabel];
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.sureBtn];
}

- (void)autoLayout{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo([GUIUtil fit:-10]);
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo([GUIUtil fit:283]);
    }];
    [_topImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:148]);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-7]);
        make.top.mas_equalTo([GUIUtil fit:7]);
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.topImg.mas_bottom);
    }];
    [_versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.equalTo(self.titleLabel.mas_bottom).mas_offset([GUIUtil fit:2]);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:10]);
        make.right.mas_equalTo([GUIUtil fit:-10]);
        make.top.equalTo(self.versionLabel.mas_bottom).mas_offset([GUIUtil fit:22]);
    }];
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remarkLabel.mas_bottom).mas_offset([GUIUtil fit:35]);
        make.centerX.mas_equalTo([GUIUtil fit:0]);
//        make.right.mas_equalTo([GUIUtil fit:-30]);
//        make.height.mas_equalTo([GUIUtil fit:36]);
        make.bottom.mas_equalTo([GUIUtil fit:-20]);
    }];
}

//MARK: - Action


- (void)sureAction{
    
    [GJumpUtil updateApp:[CFDApp sharedInstance].updateAppUrl];
}

- (void)closeAction{
    [self removeFromSuperview];
}

//MARK: - Getter

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [GColorUtil C5];
        _contentView.layer.cornerRadius = 8;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

- (UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setBackgroundImage:[GColorUtil imageNamed_whiteTheme:@"nav_icon_close"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(UIImageView *)topImg{
    if (!_topImg) {
        _topImg = [[UIImageView alloc] init];
        _topImg.image = [GColorUtil imageNamed_whiteTheme:@"public_pic_version"];
    }
    return _topImg;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font =[GUIUtil fitBoldFont:16];
        _titleLabel.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
        _titleLabel.text = CFDLocalizedString(@"发现新版本");
    }
    return _titleLabel;
}

- (UILabel *)versionLabel{
    if (!_versionLabel) {
        _versionLabel = [[UILabel alloc] init];
        _versionLabel.font =[GUIUtil fitBoldFont:14];
        _versionLabel.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
    }
    return _versionLabel;
}

-(UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.font =[GUIUtil fitFont:12];
        _remarkLabel.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _remarkLabel;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setBackgroundImage:[GColorUtil imageNamed_whiteTheme:@"public_btn_version"] forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [GUIUtil fitFont:16];
        [_sureBtn setTitleColor:[GColorUtil C5] forState:UIControlStateNormal];
        _sureBtn.layer.cornerRadius = 2;
        _sureBtn.layer.masksToBounds = YES;
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end

@implementation FCUpdateAlert
+ (void)show:(NSString *)versionStr des:(NSString *)des hasClose:(BOOL)hasClose{
    NSInteger lastVersion = [[[[FTConfig sharedInstance] version] stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
    NSInteger version = [[versionStr stringByReplacingOccurrencesOfString:@"." withString:@""] integerValue];
    if (lastVersion>=version) {
        return;
    }
    [CFDApp sharedInstance].hasLastVersionApp = YES;
    UIWindow *window = [GJumpUtil window];
    FCUpdateAlertView *view = [[FCUpdateAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    view.versionLabel.text = [NSString stringWithFormat:@"V%@",versionStr];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:des];
    attStr.lineSpacing = 5;
    view.remarkLabel.attributedText = attStr;
    view.closeBtn.hidden = !hasClose;
    view.tag = 27121;
    [window addSubview:view];
}

+(void)show{

    [self checkVersion:^(NSDictionary *dic){
        [FCUpdateAlert show:[NDataUtil stringWith:dic[@"version"]] des:[NDataUtil stringWith:dic[@"updatecontent"]] hasClose:[NDataUtil boolWithDic:dic key:@"forceupdate" isEqual:@"0"]];
    } failure:^{
        
    }];
}

+(void)checkVersion:(void(^)(NSDictionary *))hander failure:(dispatch_block_t)failure{
    [DCService updateVersion:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            NSDictionary *dic = [NDataUtil dictWith:data[@"data"]];
            if ([NDataUtil boolWithDic:dic key:@"showdialog" isEqual:@"1"]) {
                [CFDApp sharedInstance].updateAppUrl = [NDataUtil stringWith:dic[@"url"] valid:@""];
                hander(dic);
            }
        }
    } failure:^(NSError *error) {
        
    }];
}

+ (void)hide{
    UIWindow *window = [GJumpUtil window];
    FCUpdateAlertView *view = [window viewWithTag:27121];
    [view removeFromSuperview];
}
@end




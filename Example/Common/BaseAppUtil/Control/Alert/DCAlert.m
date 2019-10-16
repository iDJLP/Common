//
//  DCAlert.m
//  niuguwang
//
//  Created by ngw15 on 2018/4/6.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//


//#import "NXDLabel.h"

@interface DCAlertView : UIView <UIGestureRecognizerDelegate>

@property (nonatomic,strong)UIView *contentView;
@property (nonatomic,strong)UILabel *titleLabel;

@property (nonatomic,strong) UILabel *remarkLabel;
@property (nonatomic,strong) UIButton *sureBtn;
@property (nonatomic,strong) UIButton *cancelBtn;
@property (nonatomic,strong) UIView *line;
@property (nonatomic,strong) UIView *vLine;

@property (nonatomic,strong) dispatch_block_t sureHander;
@property (nonatomic,strong) dispatch_block_t cancelHander;

@property (nonatomic,strong) UIColor *tinColor;
@property (nonatomic,assign) BOOL isBig;

@property (nonatomic,strong) MASConstraint *masRemarkTop;
@property (nonatomic,strong) MASConstraint *masNextBtnLeft;

@end

@implementation DCAlertView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [GColorUtil colorWithHex:0x000000 alpha:0.4];
        _tinColor = [GColorUtil C13];
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.remarkLabel];
    [self.contentView addSubview:self.sureBtn];
    [self.contentView addSubview:self.cancelBtn];
    [self.contentView addSubview:self.line];
    [self.contentView addSubview:self.vLine];
}

- (void)autoLayout{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo([GUIUtil fit:-10]);
        make.centerX.mas_equalTo(0);
        if (self.isBig) {
            make.width.mas_equalTo([GUIUtil fit:320]);
        }else{
            make.width.mas_equalTo([GUIUtil fit:280]);
        }
    }];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo([GUIUtil fit:20]);
        make.centerX.mas_equalTo(0);
    }];
    [_remarkLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo([GUIUtil fit:25]);
        make.right.mas_equalTo([GUIUtil fit:-25]);
        self.masRemarkTop = make.top.equalTo(self.titleLabel.mas_bottom).mas_offset([GUIUtil fit:10]).priority(750);
        make.top.equalTo(self.contentView).mas_offset([GUIUtil fit:30]).priority(700);
    }];
    [_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.sureBtn.mas_top);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
    [_vLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.mas_equalTo([GUIUtil fitLine]);
        make.height.mas_equalTo([GUIUtil fit:22]);
        make.centerY.equalTo(self.sureBtn);
    }];
    [_cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.sureBtn);
        make.right.equalTo(self.contentView.mas_centerX);
        make.left.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:44]);
    }];
    
    [_sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remarkLabel.mas_bottom).mas_offset([GUIUtil fit:15]);
        self.masNextBtnLeft = make.left.equalTo(self.contentView.mas_centerX).priority(750);
        make.left.mas_equalTo(0).priority(700);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:44]);
        make.bottom.mas_equalTo([GUIUtil fit:0]);
    }];
}

//MARK: - Action

- (void)setTinColor:(UIColor *)tinColor{
    if (tinColor) {
        _tinColor = tinColor;
        [_sureBtn setTitleColor:_tinColor forState:UIControlStateNormal];
    }
}

- (void)sureAction{
    [self removeFromSuperview];
    if(self.sureHander){
        self.sureHander();
    }
}

- (void)cancelAction{
    [self removeFromSuperview];
    if (self.cancelHander) {
        self.cancelHander();
    }
}

//MARK: - Getter

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [GColorUtil colorWithWhiteColorType:C5_ColorType];
        _contentView.layer.cornerRadius = 10;
        _contentView.layer.masksToBounds = YES;
    }
    return _contentView;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = CFDLocalizedString(@"安全验证");
        _titleLabel.font =[GUIUtil fitFont:16];
        _titleLabel.textColor = [GColorUtil colorWithWhiteColorType:C2_ColorType];
    }
    return _titleLabel;
}

-(UILabel *)remarkLabel{
    if (!_remarkLabel) {
        _remarkLabel = [[UILabel alloc] init];
        _remarkLabel.font =[GUIUtil fitFont:16];
        _remarkLabel.textColor = [GColorUtil colorWithWhiteColorType:C3_ColorType];
        _remarkLabel.numberOfLines = 0;
        _remarkLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _remarkLabel;
}

//- (NXDLabel *)remarkLabel{
//    if (!_remarkLabel) {
//        _remarkLabel = [[NXDLabel alloc] init];
//        _remarkLabel.backgroundColor=[UIColor clearColor];
//        _remarkLabel.label.font=[GUIUtil fitFont:16];
//        _remarkLabel.label.textColor=[GColorUtil colorWithHex:0x000000];
//        _remarkLabel.lineSpace = 2;
//        _remarkLabel.label.backgroundColor = [UIColor clearColor];
//        _remarkLabel.label.numberOfLines=0;
//        _remarkLabel.label.lineBreakMode=NSLineBreakByWordWrapping;
//        _remarkLabel.label.preferredMaxLayoutWidth = [GUIUtil fit:238];
//        _remarkLabel.userInteractionEnabled=YES;
//    }
//    return _remarkLabel;
//}

- (UIView *)line{
    if (!_line) {
        _line = [[UIView alloc] init];
        _line.backgroundColor = [GColorUtil colorWithWhiteColorType:C7_ColorType];
    }
    return _line;
}

- (UIView *)vLine{
    if (!_vLine) {
        _vLine = [[UIView alloc] init];
        _vLine.backgroundColor = [GColorUtil colorWithWhiteColorType:C7_ColorType];
    }
    return _vLine;
}

- (UIButton *)cancelBtn{
    if (!_cancelBtn) {
        _cancelBtn = [[UIButton alloc] init];
        [_cancelBtn setTitle:CFDLocalizedString(@"取消") forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [GUIUtil fitFont:16];
        [_cancelBtn setTitleColor:[GColorUtil colorWithWhiteColorType:C3_ColorType] forState:UIControlStateNormal];
        [_cancelBtn addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}

- (UIButton *)sureBtn{
    if (!_sureBtn) {
        _sureBtn = [[UIButton alloc] init];
        [_sureBtn setTitle:CFDLocalizedString(@"确定") forState:UIControlStateNormal];
        _sureBtn.titleLabel.font = [GUIUtil fitFont:16];
        [_sureBtn setTitleColor:_tinColor forState:UIControlStateNormal];
        [_sureBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sureBtn;
}

@end

@implementation DCAlert

+ (void)showAlert:(NSString *)title
           detail:(NSString *)detail
        sureTitle:(NSString *)sure
       sureHander:(dispatch_block_t)sureHander
      cancelTitle:(NSString *)cancel
     cancelHander:(dispatch_block_t)cancelHander{
        [self showAlert:title detail:detail sureTitle:sure sureHander:sureHander cancelTitle:cancel cancelHander:cancelHander isBigAlert:NO tinColor:nil];
}

+ (void)showAlert:(NSString *)title
           detail:(id)detail
        sureTitle:(NSString *)sure
       sureHander:(dispatch_block_t)sureHander{
    [self showAlert:title detail:detail sureTitle:sure sureHander:sureHander cancelTitle:nil cancelHander:nil];
}

+ (void)showAlert:(NSString *)title
           detail:(id)detail
        sureTitle:(NSString *)sure
       sureHander:(dispatch_block_t)sureHander
         tinColor:(UIColor *)tinColor{
    [self showAlert:title detail:detail sureTitle:sure sureHander:sureHander cancelTitle:nil cancelHander:nil isBigAlert:NO tinColor:tinColor];
}


+ (void)showAlert:(NSString *)title
           detail:(id)detail
        sureTitle:(NSString *)sure
       sureHander:(dispatch_block_t)sureHander
      cancelTitle:(NSString *)cancel
     cancelHander:(dispatch_block_t)cancelHander
       isBigAlert:(BOOL)isBig
         tinColor:(UIColor *)tinColor{
    [self showAlert:title detail:detail sureTitle:sure sureHander:sureHander cancelTitle:cancel cancelHander:cancelHander isBigAlert:isBig tinColor:tinColor tag:4412];
}

+ (void)showAlert:(NSString *)title
           detail:(id)detail
        sureTitle:(NSString *)sure
       sureHander:(dispatch_block_t)sureHander
      cancelTitle:(NSString *)cancel
     cancelHander:(dispatch_block_t)cancelHander
       isBigAlert:(BOOL)isBig
         tinColor:(UIColor *)tinColor
              tag:(NSInteger)tag{
    UIWindow *window = [GJumpUtil window];
    DCAlertView *view = [[DCAlertView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    if (title.length>0) {
        view.titleLabel.text = title;
        [view.masRemarkTop activate];
    }else{
        view.titleLabel.hidden = YES;
        [view.masRemarkTop deactivate];
    }
    if (cancel.length>0) {
        [view.cancelBtn setTitle:cancel forState:UIControlStateNormal];
        [view.masNextBtnLeft activate];
        view.cancelHander = cancelHander;
        view.vLine.hidden = NO;
    }else{
        view.vLine.hidden = 
        view.cancelBtn.hidden = YES;
        [view.masNextBtnLeft deactivate];
    }
    
    view.remarkLabel.text = detail;
    view.tinColor = tinColor;
    view.isBig = isBig;
    view.sureHander = sureHander;
    [view.sureBtn setTitle:sure forState:UIControlStateNormal];
    view.tag = tag;
    [window addSubview:view];
    //    if ([CFDMarketModel sharedInstance].isLS) {
    //        view.contentView.transform = CGAffineTransformMakeRotation(M_PI_2);
    //        if (view.isBig) {
    //            [view.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
    //                make.width.mas_equalTo([GUIUtil fit:545]);
    //            }];
    //        }
    //    }else{
    view.contentView.transform = CGAffineTransformIdentity;
    if (view.isBig) {
        [view.contentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([GUIUtil fit:280]);
        }];
    }
    //    }
}


+ (void)hide{
    UIWindow *window = [GJumpUtil window];
    DCAlertView *view = [window viewWithTag:4412];
    [view cancelAction];
    [view removeFromSuperview];
}

@end


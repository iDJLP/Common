//
//  DCPushAlert.m
//  LiveTrade
//
//  Created by ngw15 on 2019/1/4.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "DCPushAlert.h"
#import "AppDelegate.h"
#import <AudioToolbox/AudioToolbox.h>

@interface DCPushAlertView:UIView
@property (nonatomic,strong)UIImageView *logoImgView;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *titleLabel;
@property (nonatomic,strong)UILabel *detalLabel;
@property (nonatomic,strong)UIButton *foldBtn;

@end

@implementation DCPushAlertView

static int tag = 735;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.tag = tag;
        tag++;
        self.backgroundColor = [GColorUtil C6];
        [self addSubview:self.logoImgView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.titleLabel];
        [self addSubview:self.detalLabel];
        [self addSubview:self.foldBtn];
        [_logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.top.mas_equalTo([GUIUtil fit:12]+STATUS_BAR_HEIGHT);
        }];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.logoImgView.mas_right).mas_offset([GUIUtil fit:5]);
            make.centerY.equalTo(self.logoImgView);
        }];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nameLabel.mas_bottom).mas_offset([GUIUtil fit:10]);
            make.left.mas_equalTo([GUIUtil fit:15]);
        }];
        
        [_detalLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.width.mas_equalTo(SCREEN_WIDTH+[GUIUtil fit:-30]);
            make.right.mas_equalTo([GUIUtil fit:-15]);
            make.top.equalTo(self.titleLabel.mas_bottom).mas_offset([GUIUtil fit:5]);
        }];
        [_foldBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo([GUIUtil fit:13]);
            make.top.equalTo(self.detalLabel.mas_bottom).mas_offset([GUIUtil fit:7]);
            make.bottom.mas_equalTo(0);
        }];
        UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
        swipe.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swipe];
        WEAK_SELF;
        [NTimeUtil run:^{
            [weakSelf hide];
        } delay:4];
        self.layer.cornerRadius = 8;
        self.layer.shadowColor = [GColorUtil tabbarColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0,0);
        self.layer.shadowOpacity = 1;
        self.layer.shadowRadius = 10;
    }
    return self;
}

- (UIImageView *)logoImgView{
    if (!_logoImgView) {
        _logoImgView = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"logo_push"]];
    }
    return _logoImgView;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [GColorUtil C2];
        _nameLabel.font = [GUIUtil fitBoldFont:12];
        _nameLabel.numberOfLines = 1;
        _nameLabel.text = @"Bitmixs";
    }
    return _nameLabel;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [GColorUtil C2];
        _titleLabel.font = [GUIUtil fitBoldFont:14];
        _titleLabel.numberOfLines = 1;
    }
    return _titleLabel;
}

- (UILabel *)detalLabel{
    if (!_detalLabel) {
        _detalLabel = [[UILabel alloc] init];
        _detalLabel.textColor = [GColorUtil C2];
        _detalLabel.font = [GUIUtil fitFont:14];
        _detalLabel.numberOfLines = 2;
        _detalLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    }
    return _detalLabel;
}

- (UIButton *)foldBtn{
    if (!_foldBtn) {
        _foldBtn = [[UIButton alloc] init];
        [_foldBtn setImage:[GColorUtil imageNamed:@"icon_push_up"] forState:UIControlStateNormal];
        [_foldBtn g_clickEdgeWithTop:10 bottom:0 left:0 right:0];
        [_foldBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    }
    return _foldBtn;
}

- (void)show{
    [self.superview layoutIfNeeded];
    self.transform = CGAffineTransformMakeTranslation(0, -self.height);
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hide{
    [UIView animateWithDuration:0.35 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, -self.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end

@implementation DCPushAlert

+ (void)showContent:(NSString *)content title:(NSString *)title tapAction:(dispatch_block_t)tapHandler{
    UIWindow *window = [GJumpUtil window];
    DCPushAlertView *alertView = [[DCPushAlertView alloc] init];
    [window addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.mas_equalTo(0);
    }];
    alertView.titleLabel.text = title;
    alertView.detalLabel.text = content;
    [alertView g_clickBlock:^(UITapGestureRecognizer *tap) {
        [alertView hide];
        tapHandler();
    }];
    [alertView show];
   AudioServicesPlayAlertSound(kSystemSoundID_Vibrate);
}

+ (void)hide{
    NSInteger newTag = tag;
    while (newTag>=735) {
        UIWindow *window = [GJumpUtil window];
        UIView *view = [window viewWithTag:newTag];
        if ([view isKindOfClass:[DCPushAlertView class]]) {
            [(DCPushAlertView *)view hide];
        }
        newTag--;
    }
}

@end

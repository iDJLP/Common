//
//  DCHUD.m
//  niuguwang
//
//  Created by ngw15 on 2018/4/20.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "HUDUtil.h"
#import "FLAnimatedImage.h"

@interface DCHUDView:UIView

@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) UILabel *text;
@property (nonatomic,strong)UIActivityIndicatorView * indicator;

@property (nonatomic,strong) MASConstraint *masContentSize;

@end

@implementation DCHUDView

// GCD单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static DCHUDView * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[DCHUDView alloc] init];
    });
    return sharedInstance;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self autoLayout];
        self.userInteractionEnabled = NO;
        self.hidden = YES;
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.contentView];
    [self.contentView addSubview:self.text];
}

- (void)autoLayout{
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo([GUIUtil fit:280]);
        make.width.mas_greaterThanOrEqualTo([GUIUtil fit:100]).priority(750);
        self.masContentSize=make.size.mas_equalTo([GUIUtil fitWidth:60 height:60]);
        [self.masContentSize deactivate];
    }];
    [_text mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.equalTo(self.contentView).mas_offset([GUIUtil fit:-44]);
         make.height.equalTo(self.contentView).mas_offset([GUIUtil fit:-30]);
       
    }];
}

- (void)showInfo:(NSString *)text tinColor:(UIColor *)color{

    [self showInfo:text tinColor:color isHL:NO];
}

- (void)showInfo:(NSString *)text tinColor:(UIColor *)color isHL:(BOOL)isHL{
    [self show];
    [_masContentSize deactivate];
    self.userInteractionEnabled = NO;
    _indicator.hidden=YES;
    _text.hidden = NO;
    _text.textColor = [GColorUtil C2_black];
    _contentView.backgroundColor = [GColorUtil colorWithHex:0x1f285f];
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:text];
    attStr.font = [GUIUtil fitBoldFont:14];
    attStr.alignment = NSTextAlignmentCenter;
    
    _text.attributedText = attStr;
    WEAK_SELF;
    CGFloat time = 1.5;
    if ([[FTConfig sharedInstance].lang isEqualToString:@"cn"]) {
        
        if (attStr.length>15){
            time = 3.5;
        }else if (attStr.length>10){
            time = 2.7;
        }else if (attStr.length>=7) {
            time = 2;
        }
    }else{
        if (attStr.length>60){
            time = 3.5;
        }else if (attStr.length>40){
            time = 2.7;
        }else if (attStr.length>=28) {
            time = 2;
        }
    }
    
    [NTimeUtil cancelDelay:[HUDUtil sharedInstance].hideTask];
    [HUDUtil sharedInstance].hideTask = [NTimeUtil run:^{
        [weakSelf hide];
    } delay:time];
    if (isHL) {
        self.transform = CGAffineTransformMakeRotation(M_PI_2);
    }else{
        self.transform = CGAffineTransformIdentity;
    }
}


- (void)showInfo:(NSString *)text{
    [self showInfo:text tinColor:[GColorUtil colorWithHex:0x1f285f]];
}

- (void)showProgress:(BOOL)isWhiteLoading{
    [_masContentSize activate];
    [self show];
    self.userInteractionEnabled = YES;
    if (!_indicator) {
        [self.contentView addSubview:self.indicator];
        [_indicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0);
            make.centerY.mas_equalTo(0);
            make.width.mas_equalTo([GUIUtil fit:35]);
            make.height.mas_equalTo([GUIUtil fit:35]);
        }];
        
    }
    [_indicator startAnimating];
    _indicator.hidden = NO;
    _text.hidden = YES;
}

- (void)show{
    if(self.hidden==NO&&self.superview){
        return;
    }
    [NTimeUtil cancelDelay:[HUDUtil sharedInstance].showTask];
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    BOOL isKeyWindow = NO;
    NSArray *windows = [UIApplication sharedApplication].windows;
    for (id windowView in windows) {
        NSString *viewName = NSStringFromClass([windowView class]);
        if ([@"UIRemoteKeyboardWindow" isEqualToString:viewName]) {
            window = windowView;
            isKeyWindow = YES;
            break;
        }
    }
    
    if (isKeyWindow) {
        self.frame = window.bounds;
        [window addSubview:self];
    }else if (self.superview == [GJumpUtil window]) {
        [[GJumpUtil window] bringSubviewToFront:self];
    }else{
        self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [[GJumpUtil window] addSubview:self];
    }
    self.hidden = NO;
}

- (void)hide{
    [NTimeUtil cancelDelay:[HUDUtil sharedInstance].showTask];
    self.hidden = YES;
    if (_indicator) {
        [_indicator stopAnimating];
    }
}

//MARK: - Getter

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [GColorUtil colorWithHex:0x1f285f];
        _contentView.layer.cornerRadius = 4;
        _contentView.layer.masksToBounds = YES;
        _contentView.layer.borderWidth = [GUIUtil fitLine];
        _contentView.layer.borderColor = [GColorUtil colorWithHex:0x1f285f alpha:0.9].CGColor;
        
    }
    return _contentView;
}

- (UILabel *)text{
    if(!_text){
        _text = [[UILabel alloc] init];
        _text.textColor = [GColorUtil C2_black];
        _text.font = [GUIUtil fitBoldFont:14];
        _text.textAlignment = NSTextAlignmentCenter;
        _text.numberOfLines = 3;
    }
    return _text;
}

- (UIActivityIndicatorView *) indicator
{
    if(!_indicator){
        _indicator= [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:
                     UIActivityIndicatorViewStyleWhiteLarge];
        _indicator.hidden=YES;
    }
    return _indicator;
}

@end

@implementation HUDUtil

// GCD单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static HUDUtil * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[HUDUtil alloc] init];
    });
    return sharedInstance;
}

+ (void)showError:(NSError *)error{
    NSString *string = @"";
    if ([error isKindOfClass:[NSError class]]) {
        string = error.domain;
    }else{
//        string = [GUIUtil webTips];
    }
    string = string.length>0?string:@"";
    [self showInfo:string tinColor:[GColorUtil C13]];
}

+ (void)showInfo:(NSString *)string{
    string = string.length>0?string:@"";
    [self showInfo:string tinColor:[GColorUtil C13]];
}

+ (void)showInfo:(NSString *)string tinColor:(UIColor *)color{
    if ([NSThread isMainThread]) {
        [[DCHUDView sharedInstance] showInfo:string tinColor:color];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[DCHUDView sharedInstance] showInfo:string tinColor:color];
        });
    }
}

+ (void)showInfo:(NSString *)string isHL:(BOOL)isHL{
    if ([NSThread isMainThread]) {
        [[DCHUDView sharedInstance] showInfo:string tinColor:[GColorUtil colorWithHex:0x1f285f] isHL:isHL];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[DCHUDView sharedInstance] showInfo:string tinColor:[GColorUtil colorWithHex:0x1f285f] isHL:isHL];
        });
    }
    
}

+ (void)showProgress:(NSString *)string{
    if ([NSThread isMainThread]) {
        [NTimeUtil cancelDelay:[HUDUtil sharedInstance].showTask];
        [[DCHUDView sharedInstance] showProgress:NO];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [NTimeUtil cancelDelay:[HUDUtil sharedInstance].showTask];
            [[DCHUDView sharedInstance] showProgress:NO];
        });
    }
    
}

+ (void)showProgress:(NSString *)string delay:(CGFloat)delay{
    [HUDUtil sharedInstance].showTask =
    [NTimeUtil run:^{
        [HUDUtil showProgress:string];
    } delay:0.3];
}

+ (void)hide{
    if ([NSThread isMainThread]) {
        [NTimeUtil cancelDelay:[HUDUtil sharedInstance].showTask];
        [[DCHUDView sharedInstance] hide];
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            [NTimeUtil cancelDelay:[HUDUtil sharedInstance].showTask];
            [[DCHUDView sharedInstance] hide];
        });
    }
    
}

@end

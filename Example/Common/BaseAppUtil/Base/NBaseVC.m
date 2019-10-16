//
//  NBaseVC.m
//  niuguwang
//
//  Created by BrightLi on 2016/11/30.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "NBaseVC.h"

@interface NBaseVC()<UIGestureRecognizerDelegate>
@property (nonatomic,weak)id<UIGestureRecognizerDelegate>  interPopGestDeleagte;
@property (nonatomic,strong)BaseView *base_lineView;
@property (nonatomic,assign)BOOL lineHidden;
@end

@implementation NBaseVC

#pragma mark - 生命周期

- (void) dealloc
{
    [self base_removeNotic];
    NSLog(@"[%@]被释放",NSStringFromClass(self.class));
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    [self base_addNotic];
    _n_shouldEdgPanEnable = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    if ([GJumpUtil rootNavC].viewControllers.count>1) {
        [GNavUtil leftBack:self];
    }
    [GNavUtil hideLine:self];
    [self.navigationController.navigationBar addSubview:self.base_lineView];
    if (@available(iOS 11.0, *)) {
        if (self.navigationController!=nil) {
            [_base_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.mas_equalTo(0);
                make.height.mas_equalTo([GUIUtil fitLine]);
            }];
        }else{
            _base_lineView.hidden = YES;
            _base_lineView.frame = CGRectMake(0, TOP_BAR_HEIGHT, SCREEN_WIDTH, [GUIUtil fitLine]);
        }
    }else{
        _base_lineView.hidden = YES;
        _base_lineView.frame = CGRectMake(0, TOP_BAR_HEIGHT, SCREEN_WIDTH, [GUIUtil fitLine]);
    }
}


//MARK: - Action
- (BOOL) isTopVC
{
    UIViewController *topVC=self.navigationController.topViewController;
    return topVC==self;
}

- (NBaseVC *) topVC
{
    for(UIView *next=[self.view superview]; next; next = next.superview) {
        UIResponder* nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[NBaseVC class]]) {
            return (NBaseVC *)nextResponder;
        }
    }
    return self;
}


- (void)hideLine{
    _lineHidden = YES;
    self.base_lineView.backgroundColor = [GColorUtil C6];
}

#pragma mark - 私有方法

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.base_lineView.backgroundColor = _lineHidden?[GColorUtil C6]:[GColorUtil C7];
    [BuglyLog log:@"[%@]进入",NSStringFromClass(self.class)];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _interPopGestDeleagte = self.navigationController.interactivePopGestureRecognizer.delegate;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.base_lineView.backgroundColor = _lineHidden?[GColorUtil C6]:[GColorUtil C7];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.delegate = _interPopGestDeleagte;
    self.base_lineView.backgroundColor = [GColorUtil C7];
    [BuglyLog log:@"[%@]出去",NSStringFromClass(self.class)];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if (gestureRecognizer==self.navigationController.interactivePopGestureRecognizer) {
        if(self.navigationController.viewControllers.count==1){
            return NO;
        }
    }
    return _n_shouldEdgPanEnable;
}


// 设置导航栏是否隐藏
- (void) setN_navBarHidden:(BOOL)n_navBarHidden
{
    if(![self isTopVC]){
        return;
    }
    _n_navBarHidden=n_navBarHidden;
    [self.navigationController setNavigationBarHidden:_n_navBarHidden animated:NO];
}
// 设置状态栏为白色
- (void) setN_isWhiteStatusBar:(BOOL)n_isWhiteStatusBar
{
    if(![self isTopVC]){
        return;
    }
    _n_isWhiteStatusBar=n_isWhiteStatusBar;
    UIStatusBarStyle statusBarStyle=(_n_isWhiteStatusBar?UIStatusBarStyleLightContent:UIStatusBarStyleDefault);
    [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle
                                                animated:NO];
}
// 设置状态条是否隐藏
- (void) setN_statusBarHidden:(BOOL)n_statusBarHidden
{
    if(![self isTopVC]){
        return;
    }
    _n_statusBarHidden=n_statusBarHidden;
    [[UIApplication sharedApplication] setStatusBarHidden:n_statusBarHidden withAnimation:NO];
}

- (void)setBgColorType:(ColorType)bgColorType{
    _bgColorType = bgColorType;
    self.view.backgroundColor = [GColorUtil colorWithColorType:_bgColorType];
}

- (void)base_themeChangedAction{
    if (_bgColorType!= Unkown_ColorType) {
        self.view.backgroundColor = [GColorUtil colorWithColorType:_bgColorType];
    }
}

- (void)base_addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
    [center addObserver:self
               selector:@selector(base_themeChangedAction)
                   name:ThemeDidChangedNotification
                 object:nil];
}

- (void)base_removeNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}

- (BaseView *)base_lineView{
    if (!_base_lineView) {
        _base_lineView = [[BaseView alloc] init];
        _base_lineView.bgColor = C7_ColorType;
    }
    return _base_lineView;
}

@end

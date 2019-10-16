//
//  GLWWebVC.m
//  coinpass_ftox
//
//  Created by ngw15 on 2018/8/7.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "WebVC.h"
#import "WebLoadingView.h"
#import "WebFailView.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "DCAlert.h"
#import "CFDBridge.h"

@interface WebVC ()

@property (nonatomic,strong)WebLoadingView *waitView;
@property (nonatomic,strong)WebFailView *failureView;
@property (nonatomic,strong) NJKWebViewProgressView *webViewProgress;

@property (nonatomic,assign)BOOL isFirstLoadWebView;
@property (nonatomic,assign)WebVCType type;
@end

@implementation WebVC

+ (WebVC *)jumpTo:(NSString *)title link:(NSString *)link type:(WebVCType)type animated:(BOOL)animated;{
    return [self jumpTo:title link:link type:type canGoBack:NO animated:animated];
}

+ (WebVC *)jumpTo:(NSString *)title link:(NSString *)link animated:(BOOL)animated{
    return [self jumpTo:title link:link canGoBack:NO animated:animated];
}

+ (WebVC *)jumpTo:(NSString *)title link:(NSString *)link canGoBack:(BOOL)canGoBack animated:(BOOL)animated{
    return [self jumpTo:title link:link type:WebVCTypeDefault canGoBack:canGoBack animated:animated];
}

+ (WebVC *)jumpTo:(NSString *)title link:(NSString *)link type:(WebVCType)type canGoBack:(BOOL)canGoBack animated:(BOOL)animated
{
    WebVC *target = [[WebVC alloc] init];
    target.title = title;
    target.link = link;
    target.type = type;
    target.canGoBack = canGoBack;
    target.hidesBottomBarWhenPushed=YES;
    [GJumpUtil pushVC:target animated:YES];
    return target;
}

+ (WebVC *)jumpTo:(UIViewController *)current title:(NSString *)title link:(NSString *)link type:(WebVCType)type canGoBack:(BOOL)canGoBack animated:(BOOL)animated
{
    WebVC *target = [[WebVC alloc] init];
    target.link = link;
    target.type = type;
    target.title = title;
    target.canGoBack = canGoBack;
    target.hidesBottomBarWhenPushed=YES;
    [current.navigationController pushViewController:target animated:YES];
    return target;
}

// 初始化
- (id) init
{
    if((self=[super init])){
        _needRefresh=YES;
        _canGoBack=NO;
        _isFirstLoadWebView = NO;
    }
    return self;
}

- (void) dealloc
{
    [_webView stopLoading];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.webView removeObserver:self forKeyPath:@"estimatedProgress"];
    // 移除掉进度条
    [self.webViewProgress removeFromSuperview];
    self.webViewProgress = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [GColorUtil C6];
    [self initNav];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.waitView];
    [self.view addSubview:self.failureView];
    [self setupBridge];
    [self addObserver];
    [self verify];
    
}

- (void)addObserver{
    // 添加观察者，观察网页进度条
    [_webView addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self resetClose];
    NSString *currentURL=_webView.URL.absoluteString;
    _currentURL=(currentURL.length>0?currentURL:_link);
    BLYLogInfo(@"当前URL:%@",_currentURL);
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    if(_needRefresh){
        [self reload];
    }else if(_isReload){
        [_webView reload];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    // 移除掉进度条
    [self.webViewProgress removeFromSuperview];
    self.webViewProgress = nil;
    _needRefresh=NO;
    _isReload=NO;
}

- (void) verify
{
    NSString *param = [UserModel isLogin]?[DCService paramsWithHead:HttpBaseHead]:[DCService paramsWithHead:HttpGuestHead];
    if ([_link containsString:@"?"]) {
        NSString *lastParam = [[_link componentsSeparatedByString:@"?"] lastObject];
        NSArray *paramList = [lastParam componentsSeparatedByString:@"&"];
        for (NSString *str in paramList) {
            NSString *key = [[str componentsSeparatedByString:@"="] firstObject];
            if ([key isEqualToString:@"version"]) {
                return;
            }
        }
        _link = [_link stringByAppendingFormat:@"&%@",param];
    }else{
        _link = [_link stringByAppendingFormat:@"?%@",param];
    }
}

// 初始化导航条
- (void) initNav
{
    WEAK_SELF;
    [GNavUtil leftIcon:self icon:@"nav_icon_back" secondIcon:@"top_icon_cancel" gap:10 onClick:^(){
        [weakSelf clickBack];
    } onClickSecond:^(){
        [weakSelf clickClose];
    }];
}
// 重置关闭按钮
- (void) resetClose {
    if (!_canGoBack) {
        [GNavUtil leftSecondHidden:self hidden:YES];
    }else{
        [GNavUtil leftSecondHidden:self hidden:!_canGoBack];
    }
}
// 点击关闭
- (void)clickClose{
    [self popVC:self animated:YES];
}

- (void) popVC:(UIViewController *)current animated:(BOOL) animated
{
    if(![NSThread currentThread].isMainThread){
        BLYLogError(@"不是主线程弹出");
    }
    if(current==nil){
        return;
    }
    UINavigationController *nav=current.navigationController;
    NSMutableArray *vcs = [[NSMutableArray alloc] initWithArray:nav.viewControllers];
    [vcs enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj==current) {
            [vcs removeObjectAtIndex:idx];
            [nav setViewControllers:vcs animated:animated];
            *stop=YES;
        }
    }];
    dispatch_async(dispatch_get_main_queue(), ^{
        [current dismissViewControllerAnimated:animated completion:nil];
    });
}


- (void)setupBridge {
#if DEBUG
    [WebViewJavascriptBridge enableLogging];
#endif
    _bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [_bridge setWebViewDelegate:self];
    WEAK_SELF;
    //修改当前webvc的交互
    [_bridge registerHandler:@"settitle" handler:^(id data, WVJBResponseCallback responseCallback) {
        if ([data isKindOfClass:[NSString class]]) {
            weakSelf.title = data;
        }
        responseCallback(@"Response from testObjcCallback");
    }];
    //交互，不修改当前webvc
    [[CFDBridge sharedInstance] setup:_bridge];
    
    //    [_bridge callHandler:@"testJavascriptHandler" data:@{ @"foo":@"before ready" }];
    
}

- (void)loadExamplePage:(WKWebView*)webView {
    NSString* htmlPath = [[NSBundle mainBundle] pathForResource:@"ExampleApp" ofType:@"html"];
    NSString* appHtml = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    NSURL *baseURL = [NSURL fileURLWithPath:htmlPath];
    [webView loadHTMLString:appHtml baseURL:baseURL];
}

// 返回
- (void)clickBack
{
    if ([_webView canGoBack]) {
        [_webView goBack];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
// 刷新页面
- (void) reload {
    _webView.hidden=YES;
    _closeItem.customView.hidden=YES;
    // 清除网页缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    // 加载网页
    BLYLogInfo(@"加载H5:%@",_link);
    NSURL * url = [NSURL URLWithString:_link];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:15];
    [_webView loadRequest:request];
}

/**
 *  网页进度条观察者（WKWeb／UIWeb 共同监测estimatedProgress 设置进度条的变化）
 */
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"estimatedProgress"] && object == self.webView) {
        
        [self.webViewProgress setAlpha:1.0f];
        
        CGFloat newValue = [change[@"new"] doubleValue];
        if (0 < newValue) {
            [self.webViewProgress setProgress:newValue animated:YES];
        } else {
            [self.webViewProgress setProgress:0 animated:YES];
        }
        if(self.webView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.25 animations:^{
                [self.webViewProgress setAlpha:0];
            } completion:^(BOOL finished) {
                [self.webViewProgress setProgress:0 animated:NO];
            }];
        }
    }else if([keyPath isEqualToString:@"title"]
             && object == _webView){
        self.navigationItem.title = _webView.title;
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}


#pragma mark - WebViewDelegate

// 网页开始加载
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    if(_isFirstLoadWebView == NO)
    {
        self.waitView.hidden=NO;
        self.failureView.hidden=YES;
    }
}
// 网页加载完成
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    //添加进度条
    self.webViewProgress.alpha = 1.0;
    _isFirstLoadWebView = YES;
    _waitView.hidden = YES;
    _failureView.hidden = YES;
    [self resetClose];
    NSString *current=webView.URL.absoluteString;
    _currentURL=(current.length>0?current:_link);
    WEAK_SELF;
    [NTimeUtil run:^{
        weakSelf.webView.hidden=NO;
    } delay:0.3];
}
// 网页加载失败
- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    self.waitView.hidden=YES;
    self.failureView.hidden=NO;
}

// 当main frame开始加载数据失败时，会回调
- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    self.waitView.hidden=YES;
    self.failureView.hidden=NO;
}


#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image=info[UIImagePickerControllerEditedImage];
    NSData * Data= UIImageJPEGRepresentation(image,0.3);
    NSData *base64Data = [Data base64EncodedDataWithOptions:0];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    [_bridge callHandler:@"uploadPicPathHandler" data:[NSString stringWithUTF8String:[base64Data bytes]] responseCallback:^(id response) {
        NSLog(@"uploadPicPathHandler responded: %@", response);
    }];
}

// 点击刷新
- (void) clickRefresh
{
    [self.webView reload];
}

#pragma mark - 公开方法

- (void) clear
{
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

#pragma mark - 设置与获取


- (WKWebView *)webView
{
    if (!_webView) {
        _webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - TOP_BAR_HEIGHT)];
        _webView.backgroundColor = [UIColor clearColor];
        _webView.hidden = YES;
        _webView.navigationDelegate = self;
        _webView.UIDelegate = self;
        
    }
    return _webView;
}
/**
 *  进度条
 */
- (NJKWebViewProgressView *)webViewProgress {
    if (_webViewProgress == nil) {
        CGFloat progressBarHeight = 1.f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        _webViewProgress = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _webViewProgress.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _webViewProgress.progressBarView.backgroundColor = [GColorUtil C1];
        _webViewProgress.alpha = 0.0;
        [_webViewProgress setProgress:0];
        [self.navigationController.navigationBar addSubview:_webViewProgress];
    }
    return _webViewProgress;
}


- (WebLoadingView *)waitView
{
    if(!_waitView)
    {
        _waitView = [[WebLoadingView alloc]initWithType:_type];
        _waitView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TOP_BAR_HEIGHT);
        _waitView.hidden=YES;
    }
    return _waitView;
}

- (WebFailView *)failureView
{
    if(!_failureView)
    {
        WEAK_SELF;
        _failureView = [[WebFailView alloc]initWithType:_type onReload:^{
            [weakSelf.failureView removeFromSuperview];
            [weakSelf reload];
        }];
        _failureView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-TOP_BAR_HEIGHT);
        _failureView.hidden=YES;
    }
    return _failureView;
}

@end



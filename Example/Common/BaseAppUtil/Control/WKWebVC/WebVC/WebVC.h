//
//  
//  coinpass_ftox
//
//  Created by ngw15 on 2018/8/7.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
#import "WebViewJavascriptBridge.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"

typedef NS_ENUM(NSInteger, WebVCType) {
    WebVCTypeDefault,
    WebVCTypeNews,
};


@interface WebVC :NBaseVC<WKUIDelegate,WKNavigationDelegate,UIActionSheetDelegate>


@property (nonatomic,strong) WKWebView * webView;
@property (nonatomic,strong) WebViewJavascriptBridge * bridge;
@property (nonatomic,strong) UIBarButtonItem *backItem;
@property (nonatomic,strong) UIBarButtonItem *closeItem;
@property (nonatomic,strong) UIBarButtonItem *shareItem;
@property (nonatomic,strong) UIBarButtonItem *refreshItem;

@property (nonatomic,assign) BOOL isOpen;
@property (nonatomic,assign) BOOL bHideBottom;
@property (nonatomic,assign) BOOL needRefresh;
@property (nonatomic,assign) BOOL canGoBack;
@property (nonatomic,assign) BOOL isReload;
@property (nonatomic,assign) BOOL isRefresh;
@property(nonatomic,copy) NSString *userToken;


@property (nonatomic,copy) NSString *link;
@property (nonatomic,copy) NSString *currentURL;
@property (nonatomic,copy) NSString *shareUrl;
@property (nonatomic,copy) NSString *shareTitle;
@property (nonatomic,copy) NSString *shareContent;
@property (nonatomic,copy) NSString *invitationSharetitle;
@property (nonatomic,copy) NSString *invitationShareContent;
@property (nonatomic,copy) NSString *invitationShareUrl;

@property (nonatomic,copy) NSString *selfTitle;

- (void) reload;
- (void) clear;

+ (WebVC *)jumpTo:(NSString *)title link:(NSString *)link type:(WebVCType)type animated:(BOOL)animated;

+ (WebVC *)jumpTo:(NSString *)title link:(NSString *)link canGoBack:(BOOL)canGoBack animated:(BOOL)animated;

+ (WebVC *)jumpTo:(NSString *)title link:(NSString *)link animated:(BOOL)animated;

+ (WebVC *)jumpTo:(NSString *)title link:(NSString *)link type:(WebVCType)type canGoBack:(BOOL)canGoBack animated:(BOOL)animated;
+ (WebVC *)jumpTo:(UIViewController *)current title:(NSString *)title link:(NSString *)link type:(WebVCType)type canGoBack:(BOOL)canGoBack animated:(BOOL)animated;
@end


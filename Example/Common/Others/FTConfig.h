//
//  FTConfig.h
//  niuguwang
//
//  Created by 李明 on 16/3/24.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//



@interface FTConfig : NSObject

//下载地址
@property (nonatomic,copy) NSString *download_url;
// 是否上线
@property (nonatomic,assign) BOOL isAppStore;

@property (nonatomic,copy) NSString *version;
// 后缀
@property (nonatomic,copy) NSString *suffix;

// 包标识符
@property (nonatomic,copy) NSString *bundleId;
// 包版本 0 开发版/正式版 4 专业版 5 企业版
@property (nonatomic,copy) NSString *packType;
// 友盟应用KEY
@property (nonatomic,copy) NSString *umengAppId;
// TD 应用KEY
@property (nonatomic,copy) NSString *tdAppId;
// TD AD应用KEY
@property (nonatomic,copy) NSString *tdAdAppId;
// 腾讯Bugly应用ID
@property (nonatomic,copy) NSString *buglyAppId;
// 腾讯QQ应用ID
@property (nonatomic,copy) NSString *qqAppId;
// 腾讯QQ应用KEY
@property (nonatomic,copy) NSString *qqAppKey;
// 微信应用ID
@property (nonatomic,copy) NSString *wxAppId;
// 微信应用密钥
@property (nonatomic,copy) NSString *wxAppSecret;
// 腾讯微博应用ID
@property (nonatomic,copy) NSString *weiBoAppId;
// 新浪微博应用KEY
@property (nonatomic,copy) NSString *sinaWeiBoAppId;
// 新浪微博AppSecret
@property (nonatomic,copy) NSString *sinaWeiBoAppSecret;
// 谷歌AdMod移动广告单元ID
@property (nonatomic,copy) NSString *admodUnitId;
// 版次
@property (nonatomic,copy) NSString *edition;
// 渠道
@property (nonatomic,copy) NSString *channel;
// 苹果商店索引
@property (nonatomic,copy) NSString *appStoreId;
// widget组
@property (nonatomic,copy) NSString *widgetGroup;
// 跳转地址
@property (nonatomic,copy) NSString *scheme;
//期货对应代理渠道号
@property (nonatomic,copy) NSString *proxyid;
//常见问题url
@property (nonatomic,copy) NSString *commonProblem;
//关于我们url
@property (nonatomic,copy) NSString *aboutUs;
//新闻详情url
@property (nonatomic,copy) NSString *newsDetail;

//帮助中心详情url
@property (nonatomic,copy) NSString *helpDetail;
@property (nonatomic,copy) NSString *registrationAgreement;
@property (nonatomic,copy) NSString *riskDisclosure;
@property (nonatomic,copy) NSString *noviceSchool;

//显示名称
@property (nonatomic,copy) NSString *displayName;
@property (nonatomic,copy) NSString *iconnameprefix;

@property (nonatomic,copy) NSString *domainname;
@property (nonatomic,copy) NSString *deskey;

//语言
@property (nonatomic,copy) NSString *lang;

@property (nonatomic,copy) NSString *deviceToken;

// 单例
+ (instancetype) sharedInstance;
// 获得包标识符
+ (NSString *) bundleId;
+ (NSString *)domainname;

// 推送包类型
+ (NSString *) apnPackType;
- (void) load:(NSString *)path;

- (void) initWithDeviceToken:(NSData *) deviceToken;
+ (NSString *)webTips;

@end

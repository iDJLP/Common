//
//  FTConfig.m
//  niuguwang
//
//  Created by 李明 on 16/3/24.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "FTConfig.h"


@implementation FTConfig

// GCD单例
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static FTConfig * sharedInstance;
    dispatch_once(&onceToken, ^{
        sharedInstance=[[FTConfig alloc] init];
    });
    return sharedInstance;
}
// 返回推送packType
+ (NSString *) apnPackType
{
#if defined(EE)
    return @"5";
#elif defined(PR)
    return @"4";
#elif defined(GD)
    return @"302";
#else
    return @"0";
#endif
}


- (NSString *)version {
    return _version;
}



// 获得包标识符
+ (NSString *) bundleId{
    static NSString* _bundleId;
    if(_bundleId.length>0){
        return _bundleId;
    }
    _bundleId=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"];
    return _bundleId;
}

+ (NSString *)domainname{
    return [FTConfig sharedInstance].domainname;
}

#pragma mark - 私有方法
// 初始化
- (id)init{
    if ((self = [super init]))
    {
        _isAppStore=YES;
    }
    return self;
}
// 读取配置
-(void)load:(NSString *)path{
    
    NSString *docPath = [[NSBundle mainBundle] pathForResource:@"question" ofType:@"docx"];
    NSData *data1 =[NSData dataWithContentsOfFile:docPath];
    NSString *content = [data1 utf8String];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:path ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    _buglyAppId=[data objectForKey:@"bugly_app_id"];
    _tdAppId=[data objectForKey:@"td_app_id"];
    
    
    NSDictionary* builds=[data objectForKey:@"RE"];
    _suffix=@"de";
    _edition=@"开发版";
    _scheme=@"ftde";

    
    NSString *bundleId=[FTConfig bundleId];
    _widgetGroup=[NSString stringWithFormat:@"group.%@.todayWidget",bundleId];
    _channel=[NDataUtil stringWith:builds[@"channel"] valid:@""];
    //企业版没有苹果商店AppId,使用正式版苹果商店AppId
    
    _appStoreId=[builds objectForKey:@"app_store_app_id"];
    
    _version=[NDataUtil stringWith:builds[@"version"] valid:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"]];
    
    _domainname = [NDataUtil stringWith:builds[@"domainName"] valid:@""];
    _deskey     = [NDataUtil stringWith:builds[@"deskey"] valid:@""];
    _umengAppId=[NDataUtil stringWith:builds[@"umeng_app_id"] valid:@""];
    _tdAdAppId=[NDataUtil stringWith:builds[@"td_ad_app_id"] valid:@""];
    _qqAppId=[NDataUtil stringWith:builds[@"qq_app_id"] valid:@""];
    _qqAppKey=[NDataUtil stringWith:builds[@"qq_app_key"] valid:@""];
    _wxAppId=[NDataUtil stringWith:builds[@"wx_app_id"] valid:@""];
    _wxAppSecret=[NDataUtil stringWith:builds[@"wx_app_secret"] valid:@""];
    _sinaWeiBoAppId=[NDataUtil stringWith:builds[@"sina_wb_app_id"] valid:@""];
    _sinaWeiBoAppSecret=[NDataUtil stringWith:builds[@"sina_wb_app_secret"] valid:@""];
    _admodUnitId=[NDataUtil stringWith:builds[@"admod_unit_id"] valid:@""];
    _proxyid=[NDataUtil stringWith:builds[@"proxyid"] valid:@""];
    _packType=[NDataUtil stringWith:builds[@"packtype"] valid:@""];
    _displayName=[NDataUtil stringWith:builds[@"displayname"] valid:@""];
    NSString *language = [NSLocale preferredLanguages].firstObject;
    if ([language hasPrefix:@"en"]) {
        language = @"en";
    }else{
        language = @"cn";
    }
    _lang=language;
    NSString *lang = [NLocalUtil stringForKey:@"lang"];
    if (lang.length>0) {
        _lang = lang;
    }
//    _lang = @"cn";
    _download_url=[NDataUtil stringWith:builds[@"download_url"] valid:@""];
    _iconnameprefix = [NDataUtil stringWith:builds[@"iconnameprefix"] valid:@""];

    NSString *domain = [FTConfig sharedInstance].domainname;
    
    _aboutUs = [NSString stringWithFormat:@"https://inline.%@/%@",domain,data[@"about_us"]];
    _commonProblem = [NSString stringWithFormat:@"https://inline.%@/%@",domain,data[@"common_problem"]];
    _registrationAgreement = [NSString stringWithFormat:@"https://inline.%@/%@",domain,data[@"registration_agreement"]];
    _riskDisclosure = [NSString stringWithFormat:@"https://inline.%@/%@",domain,data[@"risk_disclosure"]];
    _noviceSchool = [NSString stringWithFormat:@"https://inline.%@/%@",domain,data[@"novice_School"]];
    _newsDetail = [NSString stringWithFormat:@"https://inline.%@/%@",domain,data[@"news_detail"]];
    _helpDetail = [NSString stringWithFormat:@"https://inline.%@/traindetails.html",domain];
    [self fixed];
}

// 初始化设备TOKEN
- (void) initWithDeviceToken:(NSData *) deviceToken{
    NSString *token = [NDataUtil hexadecimalStringFromData:deviceToken];
    token=[token stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token=[token stringByReplacingOccurrencesOfString:@">" withString:@""];
    BLYLogInfo(@"推送设备TOKEN=%@",token);
    NSLog(@"推送设备TOKEN=%@",token);
    
    if ([[UserModel sharedInstance].mobilePhone isEqualToString:@"13380780542"]) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"推送TOKEN" message:token delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = token;
        [alertView show];
    }
    token=[token stringByReplacingOccurrencesOfString:@" " withString:@""];
    _deviceToken=token;
    [DCService deviceSynctype:[UserModel isLogin]?@1:@0 success:^(id data) {

    } failure:^(NSError *error) {

    }];
}

+ (NSString *)webTips{
    return CFDLocalizedString(@"网络异常");
}

- (void) fixed
{
}

@end


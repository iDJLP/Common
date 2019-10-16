//
//  UserModel.m
//  NWinBoom
//
//  Created by kakiYen on 2018/9/14.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "UserModel.h"

static NSString* const kUserTokenKey=@"fomy_user_token";
static NSString* const kUserIdKey=@"fomy_user_id";
static NSString* const kUserNameKey=@"fomy_user_name";
static NSString* const kRealNameKey=@"fomy_user_realName";
static NSString* const kUserPhoneNumKey=@"fomy_user_phonenum";


@interface UserModel ()
@property (strong, nonatomic) NSURLSessionDataTask *dataTask;
@property (strong, nonatomic) NSString *countryCode;
@property (strong, nonatomic) NSDictionary *useInfo;
@property (strong, nonatomic) NSString *walletBankId;
@property (strong, nonatomic) NSString *mobilePhone;
@property (strong, nonatomic) NSString *bankstatus;
@property (strong, nonatomic) NSString *realName;
@property (strong, nonatomic) NSString *bankCard;
@property (strong, nonatomic) NSString *bankName;
@property (strong, nonatomic) NSString *email;


@end

@implementation UserModel

+ (instancetype)sharedInstance{
    static dispatch_once_t onceToken;
    
    static UserModel * userModel;
    dispatch_once(&onceToken, ^{
        userModel=[[UserModel alloc] init];
    });
    
    return userModel;
}

+ (NSString *)userToken{
    return [UserModel sharedInstance].userToken;
}

// 是否登录
+ (BOOL) isLogin
{
    NSString *userToken=[UserModel sharedInstance].userToken;
    return userToken.length>0;
}

+ (BOOL)isAuthentic{
    return [UserModel sharedInstance].realName.length ? YES : NO;
}

+ (BOOL)isBindBankCard{
    
    return [UserModel sharedInstance].bankCard.length>0;
}

+ (BOOL)isBindPhone{
    return [UserModel sharedInstance].mobilePhone.length ? YES : NO;
}


#pragma mark - 私有方法
// 初始化
- (id)init{
    if ((self = [super init]))
    {
        [self reset];
        [self loadWithLocal];
    }
    return self;
}
// 重置
- (void) reset
{
    _userToken=@"";
    _userId=@"";
    _userName=@"";
    _realName = @"";
    _mobilePhone=@"";
    _isLoaded = NO;
    
}
- (void) saveWithLocal
{
    [NLocalUtil setString:_userToken forKey:kUserTokenKey];
    [NLocalUtil setString:_userId forKey:kUserIdKey];
    [NLocalUtil setString:_userName forKey:kUserNameKey];
    [NLocalUtil setString:_realName forKey:kRealNameKey];
    [NLocalUtil setString:_mobilePhone forKey:kUserPhoneNumKey];
    
}
- (void)loadWithLocal
{
    _userToken=[NLocalUtil stringForKey:kUserTokenKey];
//    _userToken = @"_1N_O6u77VwSgCBxXE8dfDwUMQKasIXDeyBEVYPX6HzSdKHajSLMzboPK2zJQ8nLRNjwmf64kU0*";
    if(_userToken.length>0){
        _userId=[NLocalUtil stringForKey:kUserIdKey];
        _userName=[NLocalUtil stringForKey:kUserNameKey];
        _realName=[NLocalUtil stringForKey:kRealNameKey];
        _mobilePhone=[NLocalUtil stringForKey:kUserPhoneNumKey];
        // 已登录用户不显示欢迎页
//        [NLocalUtil setInt:1 forKey:@"firstLogin"];
        BLYLogInfo(@"用户[%@]已登录,userToken=%@",_userName,_userToken);
    }else{
        BLYLogInfo(@"用户未登录");
    }
}

// 从本地删除
- (void) removeWithLocal
{
    [NLocalUtil removeForKey:kUserTokenKey];
    [NLocalUtil removeForKey:kUserIdKey];
    [NLocalUtil removeForKey:kUserNameKey];
    [NLocalUtil removeForKey:kRealNameKey];
    [NLocalUtil removeForKey:kUserPhoneNumKey];
}

- (void)storeUserPhoneNum:(NSString *)phone
{
    _mobilePhone = phone;
    [NLocalUtil setString:phone forKey:kUserPhoneNumKey];
    
}

- (void)storeuserToken:(NSString *)userToken
{
    _userToken = userToken;
    [NLocalUtil setString:userToken forKey:kUserTokenKey];
}

// 帐号登录
- (void) login:(NSDictionary *)data
{
    if([_userToken isEqualToString:data[@"userToken"]]){
        BLYLogInfo(@"USERTOKEN:%@已经是最新的",_userToken);
    };
    _userToken=[NDataUtil stringWith:data[@"userToken"] valid:@""];
    _userId=[NDataUtil stringWith:data[@"userId"] valid:@""];
    _userName=[NDataUtil stringWith:data[@"userName"] valid:@""];
    _realName = [NDataUtil stringWith:data[@"Name"] valid:@""];
    _mobilePhone = [NDataUtil stringWith:[self base64Encode:data[@"mobile"]] valid:@""];
    if(_userName.length>0){
        [Bugly setUserIdentifier:_userName];
    }
    // 保存到本地
    [self saveWithLocal];
    [[CFDApp sharedInstance] checkUnReadNotice];
    [DCService deviceSynctype:@(1) success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
}

// 更新数据
- (void) dataWithMyTab:(NSDictionary *)userInfo
{
    _isLoaded = YES;
    _userId=[NDataUtil stringWith:userInfo[@"userId"] valid:@""];
    _userName=[NDataUtil stringWith:userInfo[@"userName"] valid:@""];
    _realName=[NDataUtil stringWith:userInfo[@"Name"] valid:@""];
    _bankCard = [NDataUtil stringWith:userInfo[@"bankno"]];
    _walletBankId = [NDataUtil stringWith:userInfo[@"walletbankid"]];
    _bankName = [NDataUtil stringWith:userInfo[@"bankname"]];
    _ccode = [NDataUtil stringWith:userInfo[@"ccode"]];
    _mobilePhone = [NDataUtil stringWith:[self base64Encode:userInfo[@"mobile"]] valid:@""];
    _openGoogleAuth = [NDataUtil boolWith:userInfo[@"googleAuthenStatus"]];
    _gooleAuthLoadUrl = [NDataUtil stringWith:userInfo[@"iOSUrl"]];
    // 保存到本地
    [self saveWithLocal];
}

// 登出
- (void) logout
{
    if(_userToken.length<1){
        return;
    }
    BLYLogInfo(@"用户[%@]登出",_userName);
    [self reset];
    [self removeWithLocal];
}

#pragma mark - FetchData

- (void)getUserIndex:(dispatch_block_t)success failure:(dispatch_block_t)failure{
    WEAK_SELF;
    [DCService postgetUserIndex:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"result" isEqual:@"1"]) {
            [weakSelf dataWithMyTab:data[@"userInfo"]];
            success();
            return ;
        }
        failure();
    } failure:^(NSError *error) {
        failure();
    }];
}


- (void)getIsAuthentic:(void (^)(BOOL isAuthentic))completeBlock{
    self.isLoaded==NO ?
    [self getUserIndex:^{
        completeBlock(UserModel.isAuthentic);
    } failure:^{
        [HUDUtil showInfo:[FTConfig webTips]];
    }]:
    completeBlock(UserModel.isAuthentic);
}

#pragma mark - Setter, Getter

- (void)setBankInfo:(NSDictionary *)dataDic{
    self.bankCard = [NDataUtil stringWithDict:dataDic keys:@[@"bankaccount"] valid:@""];
    self.bankName = [NDataUtil stringWithDict:dataDic keys:@[@"banktypename"] valid:@""];
    self.bankstatus = [NDataUtil stringWithDict:dataDic keys:@[@"bankstatus"] valid:@""];
    self.walletBankId = [NDataUtil stringWithDict:dataDic keys:@[@"walletbankid"] valid:@""];
}

- (NSString *)tailNumber{
    return self.bankCard.length > 4 ? [self.bankCard substringFromIndex:self.bankCard.length - 4] : self.bankCard;
}

- (NSString *)base64Encode:(NSString *)string
{
    NSString *tempString = @"";
    
    if (string.length) {
        NSData *nsdataFromBase64String = [[NSData alloc] initWithBase64EncodedString:string options:0];
        tempString = [[NSString alloc] initWithData:nsdataFromBase64String encoding:NSUTF8StringEncoding];
    }
    
    return tempString;
}

@end

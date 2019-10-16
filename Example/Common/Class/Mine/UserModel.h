//
//  UserModel.h
//  NWinBoom
//
//  Created by kakiYen on 2018/9/14.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (strong, readonly, nonatomic) NSString *userId;
@property (strong, readonly, nonatomic) NSString *walletBankId;
@property (strong, readonly, nonatomic) NSString *countryCode;
@property (strong, readonly, nonatomic) NSString *mobilePhone;
@property (strong, readonly, nonatomic) NSString *ccode;
@property (strong, nonatomic) NSString *userToken;
@property (strong, readonly, nonatomic) NSString *userName;
@property (strong, readonly, nonatomic) NSString *realName;
@property (strong, readonly, nonatomic) NSString *bankCard;
@property (strong, readonly, nonatomic) NSString *bankName;
@property (strong, readonly, nonatomic) NSString *email;
@property (assign, nonatomic) BOOL openGoogleAuth;
@property (copy, nonatomic) NSString *gooleAuthLoadUrl;
@property (assign, nonatomic) BOOL isLoaded;

+ (instancetype)sharedInstance;
+ (NSString *)userToken;

+ (BOOL)isBindPhone;
+ (BOOL)isBindBankCard;
+ (BOOL)isAuthentic;
// 是否登录
+ (BOOL) isLogin;

// 登出
- (void) logout;
// 帐号登录
- (void) login:(NSDictionary *)data;
// 更新数据
- (void) dataWithMyTab:(NSDictionary *)data;

- (void)storeUserPhoneNum:(NSString *)phone;
- (void)storeuserToken:(NSString *)userToken;

- (void)getUserIndex:(dispatch_block_t)success failure:(dispatch_block_t)failure;

- (void)getIsAuthentic:(void(^)(BOOL isAuthentic))completeBlock;

@end

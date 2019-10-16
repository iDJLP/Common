//
//  NCheckValid.h
//  globalwin
//
//  Created by ngw15 on 2018/7/31.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NCheckValid : NSObject

// 密码规则
+ (BOOL) checkPassWord:(NSString *)string;
//手机号
+ (BOOL) isMobilePhone:(NSString *)string;
//身份证号
+ (BOOL) validateIdentityCard:(NSString *)string;
//邮箱
+ (BOOL) isEmail:(NSString *)string;
//判断是否为全数字
+ (BOOL)isAllNum:(NSString *)string;
//判断是否为全英文
+ (BOOL)isAllEnglishCapital:(NSString *)string;
//判断是否是汉字
+ (BOOL)isChinese:(NSString *)string;
/**
 * 字母、数字、中文正则判断（不包括空格）
 */
+ (BOOL)isInputRuleNotBlank:(NSString *)string;
//是否包含中文
- (BOOL)includeChinese:(NSString *)string;
//汉字转拼音
- (NSString *)pinYinWithString:(NSString *)chinese;

@end

//
//  NCheckValid.m
//  globalwin
//
//  Created by ngw15 on 2018/7/31.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "NCheckValid.h"

@implementation NCheckValid


//手机号
+ (BOOL) isMobilePhone:(NSString *)string
{
    NSString * phoneRegex = @"1[0-9]{10}";
    NSPredicate * phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:string];
}

//身份证号
+ (BOOL) validateIdentityCard:(NSString *)string
{
    BOOL flag;
    if (string.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:string];
    
}

//邮箱
+ (BOOL) isEmail:(NSString *)string
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}

//判断是否为全数字
+ (BOOL)isAllNum:(NSString *)string{
    NSString *match = @"(^[0-9]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}

//判断是否为全英文
+ (BOOL)isAllEnglishCapital:(NSString *)string{
    NSString *match = @"(^[A-Z]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}

//判断是否是汉字
+ (BOOL)isChinese:(NSString *)string{
    
    NSString *match = @"(^[\u4e00-\u9fcb]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:string];
}

/**
 * 字母、数字、中文正则判断（不包括空格）
 */
+ (BOOL)isInputRuleNotBlank:(NSString *)string {
    NSString *pattern = @"^[a-zA-Z\u4E00-\u9FA5\\d]*$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}

//是否包含中文
- (BOOL)includeChinese:(NSString *)string
{
    for(int i=0; i< [string length];i++)
    {
        int a =[string characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}

#pragma mark 汉字转拼音

- (NSString *)pinYinWithString:(NSString *)chinese{
    NSString * pinYinStr = [NSString string];
    if (chinese.length){
        NSMutableString * pinYin = [[NSMutableString alloc]initWithString:chinese];
        if (CFStringTransform((__bridge CFMutableStringRef)pinYin, 0, kCFStringTransformMandarinLatin, NO)) {
        }
        if (CFStringTransform((__bridge CFMutableStringRef)pinYin, 0, kCFStringTransformStripDiacritics, NO)) {
            pinYinStr = [NSString stringWithString:pinYin];
            pinYinStr = [pinYinStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\r" withString:@""];
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            pinYinStr = [pinYinStr stringByReplacingOccurrencesOfString:@" " withString:@""];
        }
    }
    return pinYinStr;
}


@end

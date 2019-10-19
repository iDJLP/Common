//
// NDataUtil.m
//  niuguwang
//
//  Created by 李明 on 16/4/22.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "NDataUtil.h"
#import <zlib.h>
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "GLog.h"

@implementation NDataUtil

+ (NSString *) delParam:(NSString *) url
                    key:(NSString *) key
{
    if(url.length<1 || key.length<1 || [url rangeOfString:@"#/index"].location != NSNotFound){
        return url;
    }
    if([url rangeOfString:@"?"].location==NSNotFound){
        return url;
    }
    NSString *hasKey=[key stringByAppendingString:@"="];
    if([url rangeOfString:hasKey].location==NSNotFound){
        return url;
    }
    NSString *regStr=[NSString stringWithFormat:@"[^\?&]?%@=[^&]+",key];
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regStr
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];
    url=[regExp stringByReplacingMatchesInString:url
                                         options:NSMatchingReportProgress
                                           range:NSMakeRange(0,url.length)
                                    withTemplate:@""];
    return url;
}


// URL参数
+ (NSString *)urlParam:(NSString *) url
                   key:(NSString *) key
                 value:(NSString *) value
{
    if(url.length<1 || key.length<1 || [url rangeOfString:@"#/index"].location != NSNotFound){
        return url;
    }
    if([url rangeOfString:@"?"].location==NSNotFound){
        if(value.length>0){
            url=[url stringByAppendingFormat:@"?%@=%@",key,value];
        }
        return url;
    }
    NSString *hasKey=[key stringByAppendingString:@"="];
    if([url rangeOfString:hasKey].location==NSNotFound){
        if(value.length>0){
            url=[url stringByAppendingFormat:@"&%@=%@",key,value];
        }
        return url;
    }
    NSString *regStr=[NSString stringWithFormat:@"[^\?&]?%@=[^&]+",key];
    NSRegularExpression *regExp = [[NSRegularExpression alloc] initWithPattern:regStr
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];
    NSString *replace=[NSString stringWithFormat:@"%@=%@",key,value];
    url=[regExp stringByReplacingMatchesInString:url
                                         options:NSMatchingReportProgress
                                           range:NSMakeRange(0,url.length)
                                    withTemplate:replace];
    return url;
}

static NSDateFormatter *dateFormatter=nil;

+ (BOOL) boolWith:(id) data{
    NSString *temp=[NSString stringWithFormat:@"%@",data];
    return temp.boolValue;
}
+ (BOOL) boolWith:(id) data
            valid:(BOOL) valid{
    NSString *temp=[NSString stringWithFormat:@"%@",data];
    if(temp.length<1){
        return valid;
    }
    return temp.boolValue;
}
+ (BOOL)boolWithDic:(NSDictionary *)dic key:(NSString *)key isEqual:(NSString *)string{
    if ([dic isKindOfClass:[NSDictionary class]]) {
        NSString *value = [NSString stringWithFormat:@"%@",dic[key]];
        if([value isEqualToString:string]){
            return YES;
        }
    }
    return NO;
}

// 是否为有效的浮点数
+(BOOL)IsInfOrNan:(CGFloat)value
{
    return (isnan(value) || isinf(value));
}

// 单精度浮点数
+ (float) floatWith:(id) data
              valid:(float) valid
{
    NSString *temp=[NSString stringWithFormat:@"%@",data];
    if(temp.length<1){
        return valid;
    }
    return [temp floatValue];
}
// 双精度浮点数
+ (double) doubleWith:(id) data
                valid:(float) valid
{
    if([data isKindOfClass:[NSNumber class]]){
        return [data doubleValue];
    }
    NSString *temp=[NSString stringWithFormat:@"%@",data];
    if(temp.length<1){
        return valid;
        
    }
    return [temp doubleValue];
}
+ (NSInteger) integerWith:(id) data{
    if([data isKindOfClass:[NSNumber class]]){
        return [data integerValue];
    }
    NSString *temp=[NSString stringWithFormat:@"%@",data];
    return [temp integerValue];
}
+ (NSInteger) integerWith:(id) data
                    valid:(NSInteger) valid{
    if([data isKindOfClass:[NSNumber class]]){
        return [data integerValue];
    }
    NSString *temp=[NSString stringWithFormat:@"%@",data];
    if(temp.length<1){
        return valid;
    }
    return [temp integerValue];
}

+ (NSString *) stringWith:(id) data{
    if(data==nil || [data isKindOfClass:[NSNull class]]){
        return @"";
    }
    NSString *temp=[NSString stringWithFormat:@"%@",data];
    if(temp.length<1){
        return @"";
    }
    return temp;
}
// 获得字符串
+ (NSString *) stringWith:(id) data
                    valid:(NSString *) valid
{
    if(data==nil || [data isKindOfClass:[NSNull class]]){
        return valid;
    }
    NSString *temp=[NSString stringWithFormat:@"%@",data];
    if(temp.length<1){
        return valid;
    }
    return temp;
}
// 获得浮点字符串
+ (NSString *) stringWithDouble:(double) data
{
    return [self stringWithDouble:data decimal:3];
}
// 获得浮点字符串
+ (NSString *) stringWithDouble:(double) data
                        decimal:(int) decimal
                        hasZero:(BOOL)hasZero
{
    NSString *fmt=[NSString stringWithFormat:@"%%.%df",decimal];
    NSString *temp=[NSString stringWithFormat:fmt,data];
    if (!hasZero) {
        long len = temp.length;
        for (int i = 0; i < len; i++)
        {
            if (![temp hasSuffix:@"0"])
                break;
            else
                temp=[temp substringToIndex:[temp length]-1];
        }
        if ([temp hasSuffix:@"."])//避免像1.000这样的被解析成1.
        {
            return [temp substringToIndex:[temp length]-1];
        }
    }
    return temp;
}
// 获得浮点字符串
+ (NSString *) stringWithDouble:(double) data
                        decimal:(int) decimal
{
    return [self stringWithDouble:data decimal:decimal hasZero:NO];
}
// 从字典中获得字符串
+ (NSString *) stringWithDict:(NSDictionary *)dict
                         keys:(NSArray *) keys
                        valid:(NSString *) valid
{
    if(valid.length<1){
        valid=@"";
    }
    if(dict==nil || ![dict isKindOfClass:[NSDictionary class]]){
        return valid;
    }
    __block NSString *value;
    [keys enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL *stop) {
        value = [NDataUtil stringWith:dict[obj] valid:@""];
        if(value.length>0){
            *stop=YES;
        }
    }];
    if(value.length<1){
        return valid;
    }
    return value;
}

+ (NSDictionary *) dictWith:(id) data{
    if(data==nil){
        return nil;
    }
    if(![data isKindOfClass:[NSDictionary class]]){
        return nil;
    }
    return data;
}
// 获得可变字典
+ (NSMutableDictionary *) mutableDictWith:(id) data
{
    if(data==nil){
        return nil;
    }
    if(![data isKindOfClass:[NSMutableDictionary class]]){
        return nil;
    }
    return data;
}
// 获得指定的类
+ (id) classWith:(Class) cls
            data:(id)data
{
    if(data==nil){
        return nil;
    }
    if(![data isKindOfClass:cls]){
        return nil;
    }
    return data;
}
// 从数组中获得元素-安全
+ (id) dataWithArray:(NSArray *)target
               index:(NSUInteger) index{
    if (target==nil || [target isKindOfClass:[NSNull class]] || target.count<1){
        return nil;
    }
    if(index<target.count){
        return [target objectAtIndex:index];
    }
    return nil;
}
// 从数组中获得类元素-安全
+ (id) classWithArray:(Class) cls
                array:(NSArray *)array
                index:(NSUInteger) index
{
    if (cls==nil || array==nil || [array isKindOfClass:[NSNull class]] || array.count<1){
        return nil;
    }
    if(index<array.count){
        id result=[array objectAtIndex:index];
        if([result isKindOfClass:cls]){
            return result;
        }
    }
    return nil;
}
// 密码规则
+ (BOOL) checkPassWord:(NSString *)string
{
    if ([string containsString:@" "]) {
        return NO;
    }
    if (string.length<6||string.length>32) {
        return NO;
    }
    BOOL isNum = [self isNumber:string];
    return !isNum;
//    //6-16位数字和字母组成
//    NSString *regex = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z]{6,16}$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
//    if ([pred evaluateWithObject:string]) {
//        return YES ;
//    }else
//        return NO;
}

+ (BOOL) isMobilePhone:(NSString *)string
{
    if (string.length<=0) {
        return NO;
    }
    NSString * phoneRegex = @"^[0-9]*$";
    NSPredicate * phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:string];
}

+ (BOOL)isNumber:(NSString *)string
{
    NSString * phoneRegex = @"^[0-9]*$";
    NSPredicate * phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:string];
}


// 从数组中获得字典-安全
+ (NSDictionary *) dictWithArray:(NSArray *)target
                           index:(NSInteger) index
{
    if (target==nil || [target isKindOfClass:[NSNull class]] || target.count<1){
        NSLog(@"无效的数组访问!");
        return nil;
    }
    if(index<0 || index>=target.count){
        NSLog(@"无效的数组索引!");
        return nil;
    }
    id result=[target objectAtIndex:index];
    if(![result isKindOfClass:[NSDictionary class]]){
        NSLog(@"数据元素不是一个字典对象!");
        return nil;
    }else{
        return result;
    }
}
// 从数组中获得数组-安全
+ (NSArray *) arrayWithArray:(NSArray *)target
                       index:(NSUInteger) index
{
    if (target==nil || [target isKindOfClass:[NSNull class]] || target.count<1){
        return nil;
    }
    if(index<target.count){
        id result=[target objectAtIndex:index];
        if([result isKindOfClass:[NSArray class]]){
            return result;
        }
    }
    return nil;
}
// 加入数组-安全
+ (void) addTo:(NSMutableArray *)target
        object:(id) object
{
    if(target==nil || [target isKindOfClass:[NSNull class]] || object==nil){
        return;
    }
    if(![target isKindOfClass:[NSMutableArray class]]){
        return;
    }
    [target addObject:object];
}
// 插入数组-安全
+ (void) insertTo:(NSMutableArray *)target
           object:(id) object
            index:(NSUInteger)index

{
    if(target==nil || [target isKindOfClass:[NSNull class]] || object==nil){
        return;
    }
    if(![target isKindOfClass:[NSMutableArray class]]){
        return;
    }
    [target insertObject:object atIndex:index];
}
// 获得数组
+ (NSArray *) arrayWith:(id)data
{
    if([data isKindOfClass:[NSArray class]]){
        return data;
    }
    return nil;
}
// 获得可变数组
+ (NSMutableArray *) mutableArrayWith:(id)data
{
    if([data isKindOfClass:[NSMutableArray class]]){
        return data;
    }
    if([data isKindOfClass:[NSArray class]]){
        return [NSMutableArray arrayWithArray:data];
    }
    return nil;
}
// 转换类对象
+(id) toClass:(Class) cls object:(id)object
{
    if(object==nil){
        return nil;
    }
    if([object isKindOfClass:cls]){
        return object;
    }
    return nil;
}
+ (BOOL) removeAtIndex:(NSMutableArray *)target index:(NSUInteger)index
{
    if (target==nil || [target isKindOfClass:[NSNull class]] || target.count<1){
        return NO;
    }
    if(index<target.count){
        [target removeObjectAtIndex:index];
        return YES;
    }
    return NO;
}
// 移除+-号
+ (NSString *)removeSymbole:(NSString *)str {
    return ([str hasPrefix:@"+"] || [str hasPrefix:@"-"]) ? [str substringFromIndex:1] : str;
}
// 移除+号
+(NSString *)removePlus:(NSString *)value{
    if(value.length<1){
        return @"";
    }
    return [value hasPrefix:@"+"] ? [value substringFromIndex:1] : value;
}
+ (NSDecimalNumber *) decimalWithABS:(NSString *)target
{
    if(target.length<1){
        return nil;
    }
    if(target.length>1 && ([target hasPrefix:@"+"] || [target hasPrefix:@"-"])){
        return [NSDecimalNumber decimalNumberWithString:[target substringFromIndex:1]];
    }
    return [NSDecimalNumber decimalNumberWithString:target];
}
+ (NSDecimalNumber *) mulWithDecimal:(NSString *)source target:(NSString *)target
{
    NSDecimalNumber *a=[NSDecimalNumber decimalNumberWithString:source];
    NSDecimalNumber *b=[NSDecimalNumber decimalNumberWithString:target];
    return [a decimalNumberByMultiplyingBy:b];
}
+ (NSString *) addWithDecimal:(NSDecimalNumber *)source target:(NSDecimalNumber *)target
{
    return [[source decimalNumberByAdding:target] stringValue];
}
+ (NSString *) subWithDecimal:(NSDecimalNumber *)source target:(NSDecimalNumber *)target
{
    return [[source decimalNumberBySubtracting:target] stringValue];
}
+ (NSString *) subWithDecimal:(NSString *)source
                       target:(NSString *)target
                          max:(NSString *)max
{
    if(source.length<1 || target.length<1 || max.length<1){
        return @"0";
    }
    if([max isEqualToString:@"0"]){
        return max;
    }
    NSDecimalNumber *a=[NSDecimalNumber decimalNumberWithString:source];
    NSDecimalNumber *b=[NSDecimalNumber decimalNumberWithString:target];
    NSDecimalNumber *result=[a decimalNumberBySubtracting:b];
    if([result doubleValue]<0){
        return @"0";
    }
    if([result doubleValue]>[max doubleValue]){
        return max;
    }
    return [result stringValue];
}
+ (NSString *)md5:(NSString *)target
{
    const char *data = [target UTF8String];
    unsigned char result[16];
    CC_MD5(data, (CC_LONG)strlen(data), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}
// 解密3DES
+(NSString *) encodeWithDES:(NSString *)target
                        key:(NSString *)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    NSData* data = [target dataUsingEncoding:NSUTF8StringEncoding];
    plainTextBufferSize = [data length];
    vplainText = (const void *)[data bytes];
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *)[key UTF8String];
    Byte iv[] = {0x31, 0x32, 0x33, 0x31, 0x32, 0x33, 0x30, 0x30};
    CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt,
                                       kCCAlgorithm3DES,
                                       kCCOptionPKCS7Padding,
                                       vkey,
                                       kCCKeySize3DES,
                                       iv,
                                       vplainText,
                                       plainTextBufferSize,
                                       (void *)bufferPtr,
                                       bufferPtrSize,
                                       &movedBytes);
    if (ccStatus == kCCSuccess) {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        NSString *oriStr = [self hexadecimalStringFromData:myData];
        NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:@"< >"];
        NSString *result = [[oriStr componentsSeparatedByCharactersInSet:cSet] componentsJoinedByString:@""];
        free(bufferPtr);
        return result;
    }
    free(bufferPtr);
    return @"";
}

//加密3DES desIV = 8f82edf2
+(NSString *) encodeWithDES_8f82edf2:(NSString *)target
                                 key:(NSString *)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    NSData* data = [target dataUsingEncoding:NSUTF8StringEncoding];
    plainTextBufferSize = [data length];
    vplainText = (const void *)[data bytes];
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *)[key UTF8String];
    Byte iv[] = {0x38, 0x66, 0x38, 0x32, 0x65, 0x64, 0x66, 0x32};
    CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt,
                                       kCCAlgorithm3DES,
                                       kCCOptionPKCS7Padding,
                                       vkey,
                                       kCCKeySize3DES,
                                       iv,
                                       vplainText,
                                       plainTextBufferSize,
                                       (void *)bufferPtr,
                                       bufferPtrSize,
                                       &movedBytes);
    if (ccStatus == kCCSuccess) {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        NSString *oriStr = [self hexadecimalStringFromData:myData];
        NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:@"< >"];
        NSString *result = [[oriStr componentsSeparatedByCharactersInSet:cSet] componentsJoinedByString:@""];
        free(bufferPtr);
        return result;
    }
    free(bufferPtr);
    return @"";
}

//加密3DES desIV = 9bf1c9b0
+(NSString *) encodeWithDES_9bf1c9b0:(NSString *)target
                                 key:(NSString *)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    NSData* data = [target dataUsingEncoding:NSUTF8StringEncoding];
    plainTextBufferSize = [data length];
    vplainText = (const void *)[data bytes];
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *)[key UTF8String];
    Byte iv[] = {0x39, 0x62, 0x66, 0x31, 0x63, 0x39, 0x62, 0x30};
    CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt,
                                       kCCAlgorithm3DES,
                                       kCCOptionPKCS7Padding,
                                       vkey,
                                       kCCKeySize3DES,
                                       iv,
                                       vplainText,
                                       plainTextBufferSize,
                                       (void *)bufferPtr,
                                       bufferPtrSize,
                                       &movedBytes);
    if (ccStatus == kCCSuccess) {
        
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
       NSString *oriStr= [self hexadecimalStringFromData:myData];
       
        NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:@"< >"];
        NSString *result = [[oriStr componentsSeparatedByCharactersInSet:cSet] componentsJoinedByString:@""];
        
        free(bufferPtr);
        return result;
    }
    free(bufferPtr);
    return @"";
}

//加密3DES desIV = 9bf1c9b0
+(NSString *) encodeWithDES_584ff1dd:(NSString *)target
                                 key:(NSString *)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    
    NSData* data = [target dataUsingEncoding:NSUTF8StringEncoding];
    plainTextBufferSize = [data length];
    vplainText = (const void *)[data bytes];
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    
    const void *vkey = (const void *)[key UTF8String];
    Byte iv[] = {0x35, 0x38, 0x34, 0x66, 0x66, 0x31, 0x64, 0x64};
    CCCryptorStatus ccStatus = CCCrypt(kCCEncrypt,
                                       kCCAlgorithm3DES,
                                       kCCOptionPKCS7Padding,
                                       vkey,
                                       kCCKeySize3DES,
                                       iv,
                                       vplainText,
                                       plainTextBufferSize,
                                       (void *)bufferPtr,
                                       bufferPtrSize,
                                       &movedBytes);
    if (ccStatus == kCCSuccess) {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        NSString *oriStr = [self hexadecimalStringFromData:myData];
        NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:@"< >"];
        NSString *result = [[oriStr componentsSeparatedByCharactersInSet:cSet] componentsJoinedByString:@""];
        free(bufferPtr);
        return result;
    }
    free(bufferPtr);
    return @"";
}

//hex数据转为bytes
+ (NSData *) hexToBytes:(NSString *)target

{
    NSMutableData* data = [NSMutableData data];
    int idx;
    for (idx = 0; idx+2 <= target.length; idx+=2) {
        NSRange range = NSMakeRange(idx, 2);
        NSString* hexStr = [target substringWithRange:range];
        NSScanner* scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

// 解密3DES
+ (NSString *) decodeWithDES:(NSString *) target
                         key:(NSString *) key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    NSData *encryptData = [self hexToBytes:target];
    plainTextBufferSize = [encryptData length];
    vplainText = (const void *)[encryptData bytes];
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *)[key UTF8String];
    Byte iv[] = {0x31, 0x32, 0x33, 0x31, 0x32, 0x33, 0x30, 0x30};
    CCCryptorStatus ccStatus = CCCrypt(kCCDecrypt,
                                       kCCAlgorithm3DES,
                                       kCCOptionPKCS7Padding,
                                       vkey,
                                       kCCKeySize3DES,
                                       iv,
                                       vplainText,
                                       plainTextBufferSize,
                                       (void *)bufferPtr,
                                       bufferPtrSize,
                                       &movedBytes);
    if (ccStatus == kCCSuccess) {
        NSString *result = [[NSString alloc] initWithData:
                            [NSData dataWithBytes:(const void *)bufferPtr
                                           length:(NSUInteger)movedBytes]
                                                 encoding:NSUTF8StringEncoding];
        free(bufferPtr);
        return (result.length>0?result:target);
    }
    free(bufferPtr);
    return target;
}


// 解密3DES  desIV = 8f82edf2
+ (NSString *) decodeWithDES_8f82edf2:(NSString *) target
                                  key:(NSString *) key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    NSData *encryptData = [self hexToBytes:target];
    plainTextBufferSize = [encryptData length];
    vplainText = (const void *)[encryptData bytes];
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *)[key UTF8String];
    Byte iv[] = {0x38, 0x66, 0x38, 0x32, 0x65, 0x64, 0x66, 0x32};
    CCCryptorStatus ccStatus = CCCrypt(kCCDecrypt,
                                       kCCAlgorithm3DES,
                                       kCCOptionPKCS7Padding,
                                       vkey,
                                       kCCKeySize3DES,
                                       iv,
                                       vplainText,
                                       plainTextBufferSize,
                                       (void *)bufferPtr,
                                       bufferPtrSize,
                                       &movedBytes);
    if (ccStatus == kCCSuccess) {
        NSString *result = [[NSString alloc] initWithData:
                            [NSData dataWithBytes:(const void *)bufferPtr
                                           length:(NSUInteger)movedBytes]
                                                 encoding:NSUTF8StringEncoding];
        free(bufferPtr);
        return (result.length>0?result:target);
    }
    free(bufferPtr);
    return target;
}


// 解密3DES  desIV = 9bf1c9b0
+ (NSString *) decodeWithDES_9bf1c9b0:(NSString *) target
                                  key:(NSString *) key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    NSData *encryptData = [self hexToBytes:target];
    plainTextBufferSize = [encryptData length];
    vplainText = (const void *)[encryptData bytes];
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *)[key UTF8String];
    Byte iv[] = {0x39, 0x62, 0x66, 0x31, 0x63, 0x39, 0x62, 0x30};
    CCCryptorStatus ccStatus = CCCrypt(kCCDecrypt,
                                       kCCAlgorithm3DES,
                                       kCCOptionPKCS7Padding,
                                       vkey,
                                       kCCKeySize3DES,
                                       iv,
                                       vplainText,
                                       plainTextBufferSize,
                                       (void *)bufferPtr,
                                       bufferPtrSize,
                                       &movedBytes);
    if (ccStatus == kCCSuccess) {
        NSString *result = [[NSString alloc] initWithData:
                            [NSData dataWithBytes:(const void *)bufferPtr
                                           length:(NSUInteger)movedBytes]
                                                 encoding:NSUTF8StringEncoding];
        free(bufferPtr);
        return (result.length>0?result:target);
    }
    free(bufferPtr);
    return target;
}

// 解密3DES  desIV = 584ff1dd
+ (NSString *) decodeWithDES_584ff1dd:(NSString *)target
                                  key:(NSString *)key
{
    const void *vplainText;
    size_t plainTextBufferSize;
    NSData *encryptData = [self hexToBytes:target];
    plainTextBufferSize = [encryptData length];
    vplainText = (const void *)[encryptData bytes];
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    const void *vkey = (const void *)[key UTF8String];
    Byte iv[] = {0x35, 0x38, 0x34, 0x66, 0x66, 0x31, 0x64, 0x64};
    CCCryptorStatus ccStatus = CCCrypt(kCCDecrypt,
                                       kCCAlgorithm3DES,
                                       kCCOptionPKCS7Padding,
                                       vkey,
                                       kCCKeySize3DES,
                                       iv,
                                       vplainText,
                                       plainTextBufferSize,
                                       (void *)bufferPtr,
                                       bufferPtrSize,
                                       &movedBytes);
    if (ccStatus == kCCSuccess) {
        NSString *result = [[NSString alloc] initWithData:
                            [NSData dataWithBytes:(const void *)bufferPtr
                                           length:(NSUInteger)movedBytes]
                                                 encoding:NSUTF8StringEncoding];
        free(bufferPtr);
        return (result.length>0?result:target);
    }
    free(bufferPtr);
    return target;
}


+ (NSDictionary *) dictWithJson:(NSString *)jsonString
{
    if (jsonString.length<1) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                         options:NSJSONReadingMutableContainers
                                                           error:&error];
    if(error!=nil){
        [GLog output:@"json解析失败：%@",error];
        return nil;
    }
    return dict;
}

+ (NSString*) toJson:(id)data
{
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:&error];
    if(error!=nil){
        return nil;
    }
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

+ (id) jsonWithData:(NSData *) data
{
    if(data==nil){
        return nil;
    }
    NSError *error=nil;
    id result=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
    if(error!=nil){
        NSLog(@"%@",error);
        return nil;
    }
    return result;
}

+ (NSString *) decodeFromPercentEscapeString: (NSString *) input
{
    NSMutableString * output = [NSMutableString stringWithString:input];
    [output replaceOccurrencesOfString:@"+"
                            withString:@""
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [output length])];
    return [output stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
// 复用NSDateFormatter
+ (NSDateFormatter *) dateFormatter
{
    if(dateFormatter==nil){
        dateFormatter=[[NSDateFormatter alloc]init];
    }
    return dateFormatter;
}
+ (NSString *) formatDate:(NSDate *)date dateFormat:(NSString *) dateFormat
{
    if(dateFormatter==nil){
        dateFormatter=[[NSDateFormatter alloc]init];
    }
    [dateFormatter setDateFormat:dateFormat];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

+ (NSString*) stringByUnescapingFromURLArgument:(NSString *)target
{
    const char* src = [target UTF8String];
    if (NULL!= src) {
        unsigned long src_len = strlen(src);
        char* tmp = (char*)malloc(src_len +1);
        char word[3] ={0};
        unsigned char c = 0;
        int ind      = 0;
        bzero(tmp, src_len+1);
        while (ind<src_len) {
            if ('%' == src[ind]) {
                bzero(word,3);
                word[0] = src[ind+1];
                word[1] = src[ind+2];
                int dec = 0;
                sscanf(word,"%X",&dec);
                c = (char)dec;
                sprintf(tmp,"%s%c", tmp,c);
                ind += 3;
            }
            else {
                sprintf(tmp, "%s%c",tmp,src[ind++]);
            }
        }
        
        target = [NSString stringWithUTF8String:tmp];
        free(tmp);
    }
    return  target;
}
// 数组查找字符串元素
+ (BOOL) find:(NSArray *) array target:(NSString *) target
{
    if(array==nil || [array count]<1 || target.length<1){
        return NO;
    }
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@",target];
    NSArray *results=[array filteredArrayUsingPredicate:predicate];
    return [results count]>0;
}
// 获得字符串字节长度-(1个中文算2个英文)
+ (NSUInteger) charLength:(NSString *) target
{
    int length = 0;
    char* p = (char*)[target cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[target lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            length++;
        }else{
            p++;
        }
    }
    return length;
}
// 获得字符串双字节长度-(2个英文算1个中文)
+ (NSUInteger) doubleLength:(NSString *) target
{
    int length = 0;
    char* p = (char*)[target cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[target lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            length++;
        }else{
            p++;
        }
    }
    return (length+1)/2;
}
// 限制字符串长度
+ (NSString *) limit:(NSString *) target max:(NSUInteger) max
{
    int length = 0;
    NSInteger maxChar=max*2;
    char* p = (char*)[target cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[target lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];i++) {
        if (*p) {
            p++;
            length++;
            if(length>=maxChar){
                return [target substringToIndex:i/2];
            }
        }else{
            p++;
        }
    }
    return target;
}
// 限制字符串长度
+ (NSString *) limit:(NSString *) target
                 max:(NSUInteger) max
                omit:(NSString *) omit
{
    int length = 0;
    NSInteger maxChar=max*2;
    char* p = (char*)[target cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[target lengthOfBytesUsingEncoding:NSUnicodeStringEncoding];i++) {
        if (*p) {
            p++;
            length++;
            if(length>=maxChar){
                return [[target substringToIndex:i/2] stringByAppendingString:omit];
            }
        }else{
            p++;
        }
    }
    return target;
}
// 检查是否为正确的图像url地址
+ (NSString *) toImgUrl:(NSString *) url
{
    if(url.length<1){
        return @"";
    }
    if(![url hasPrefix:@"http"]){
        [GLog output:@"无效的图片地址:%@",url];
        return @"";
    }
    return url;
}
// 检查是否为正确的URL地址
+ (BOOL) isUrl:(NSString *) url
{
    if(url.length<1){
        return NO;
    }
    if(![url hasPrefix:@"http"]){
        [GLog output:@"无效的URL地址:%@",url];
        return NO;
    }
    if(![url hasPrefix:@"https:"]){
        [GLog output:@"不支持HTTPS:%@",url];
    }
    return YES;
}

// 检查是否为正确的图像url地址
+ (BOOL) isImgUrl:(NSString *) url
{
    if(url.length<1){
        return NO;
    }
    if(![url hasPrefix:@"http"]){
        [GLog output:@"无效的图片地址:%@",url];
        return NO;
    }
    if(![url hasPrefix:@"https:"]){
        [GLog output:@"不支持HTTPS:%@",url];
    }
    return YES;
}

+ (BOOL) stringIsBlank:(NSString *)string{
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    return string.length==0;
}

// 计算Y轴最小值
+ (double) axisYMin:(double) yMin
{
    return (yMin<0?yMin:0);
}

+ (NSString *)hexadecimalStringFromData:(NSData *)data
{
    NSUInteger dataLength = data.length;
    if (dataLength == 0) {
        return nil;
    }
    const unsigned char *dataBuffer = data.bytes;
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendFormat:@"%02x", dataBuffer[i]];
    }
    return [hexString copy];
}


@end

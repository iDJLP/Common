//
// NDataUtil.h
//  数据工具类
//
//  Created by 李明 on 16/4/27.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NDataUtil:NSObject

+ (NSString *) delParam:(NSString *) url
                    key:(NSString *) key;
// URL参数
+ (NSString *)urlParam:(NSString *) url
                   key:(NSString *)key
                 value:(NSString *) value;
// 是否为有效的浮点数
+(BOOL)IsInfOrNan:(CGFloat)InputX;
// 获得单精度浮点数
+ (float) floatWith:(id) data
              valid:(float) valid;
// 获得bool值
+ (BOOL) boolWith:(id) data;
+ (BOOL) boolWith:(id) data
            valid:(BOOL) valid;
+ (BOOL)boolWithDic:(NSDictionary *)dic key:(NSString *)key isEqual:(NSString *)string;
// 获得双精度浮点数
+ (double) doubleWith:(id) data
                valid:(float) valid;
+ (NSInteger) integerWith:(id) data;
+ (NSInteger) integerWith:(id) data
                    valid:(NSInteger) valid;
// 获得日期
+ (NSDate *) dateWith:(id)data;
// 获得浮点字符串
+ (NSString *) stringWithDouble:(double) data;
// 获得浮点字符串
+ (NSString *) stringWithDouble:(double) data
                        decimal:(int) decimal
                        hasZero:(BOOL)hasZero;
// 获得浮点字符串
+ (NSString *) stringWithDouble:(double) data
                        decimal:(int) decimal;
// 从字典中获得字符串
+ (NSString *) stringWithDict:(NSDictionary *)dict
                         keys:(NSArray *) keys
                        valid:(NSString *) valid;
+ (NSString *) stringWith:(id) data
                    valid:(NSString *) valid;
+ (NSString *) stringWith:(id) data;
// 获得字典
+ (NSMutableDictionary *) dictWith:(id) data;
// 获得可变字典
+ (NSMutableDictionary *) mutableDictWith:(id) data;
// 获得指定的类
+ (id) classWith:(Class) cls
            data:(id) data;
// 获得数组
+ (NSMutableArray *) arrayWith:(id) data;
// 获得可变数组
+ (NSMutableArray *) mutableArrayWith:(id) data;
// 从数组中删除数据
+ (BOOL) removeAtIndex:(NSMutableArray *) target
                 index:(NSUInteger) index;
// 从数组中获得字典-安全
+ (NSDictionary *) dictWithArray:(NSArray *)target
                           index:(NSInteger) index;
// 从数组中获得类元素-安全
+ (id) classWithArray:(Class) cls
                array:(NSArray *)array
                index:(NSUInteger) index;
// 从数组中获得数组-安全
+ (NSArray *) arrayWithArray:(NSArray *)target
                       index:(NSUInteger) index;
// 从数组中获得元素-安全
+ (id) dataWithArray:(NSArray *)target
               index:(NSUInteger) index;
// 加入数组-安全
+ (void) addTo:(NSMutableArray *)target
        object:(id) object;
// 插入数组-安全
+ (void) insertTo:(NSMutableArray *)target
           object:(id) object
            index:(NSUInteger)index;
// 转换类对象
+(id) toClass:(Class) cls object:(id)object;

+ (NSString *)removeSymbole:(NSString *)str ;
+ (NSString *)removePlus:(NSString *)str ;

+ (NSDecimalNumber *) decimalWithABS:(NSString *)target;
+ (NSDecimalNumber *) mulWithDecimal:(NSString *)source
                              target:(NSString *)target;
+ (NSString *) addWithDecimal:(NSDecimalNumber *)source
                       target:(NSDecimalNumber *)target;
+ (NSString *) subWithDecimal:(NSDecimalNumber *)source
                       target:(NSDecimalNumber *)target;
+ (NSString *) subWithDecimal:(NSString *)source
                       target:(NSString *)target
                          max:(NSString *)max;
// MD5加密
+ (NSString *) md5:(NSString *)target;
//加密3DES desIV = 12312300
+(NSString *) encodeWithDES:(NSString *)target
                        key:(NSString *)key;
// 解密3DES  desIV = 12312300
+ (NSString *) decodeWithDES:(NSString *) target
                         key:(NSString *) key;

//加密3DES desIV = 8f82edf2
+(NSString *) encodeWithDES_8f82edf2:(NSString *)target
                                 key:(NSString *)key;
//解密3DES desIV = 8f82edf2
+ (NSString *) decodeWithDES_8f82edf2:(NSString *) target
                                  key:(NSString *) key;
//加密3DES desIV = 9bf1c9b0
+(NSString *) encodeWithDES_9bf1c9b0:(NSString *)target
                                 key:(NSString *)key;

// 解密3DES  desIV = 9bf1c9b0
+ (NSString *) decodeWithDES_9bf1c9b0:(NSString *) target
                                  key:(NSString *) key;

// 解密3DES  desIV = 584ff1dd
+ (NSString *) encodeWithDES_584ff1dd:(NSString *) target
                                  key:(NSString *) key;
// 解密3DES  desIV = 584ff1dd
+ (NSString *) decodeWithDES_584ff1dd:(NSString *) target
                                  key:(NSString *) key;

// Json字符串转字典
+ (NSDictionary *) dictWithJson:(NSString *)jsonString;
// 转成Json字符串
+ (NSString*) toJson:(id)dict;
// 解析JSON
+ (id) jsonWithData:(NSData *) data;
// 复用NSDateFormatter
+ (NSDateFormatter *) dateFormatter;
// 格式化日期
+ (NSString *) formatDate:(NSDate *)date dateFormat:(NSString *) dateFormat;
+ (NSString *) decodeFromPercentEscapeString: (NSString *) input;
+ (NSString*) stringByUnescapingFromURLArgument:(NSString *)target;
// 数组查找字符串元素
+ (BOOL) find:(NSArray *) array target:(NSString *) target;
// 获得字符串字节长度-(1个中文算2个英文)
+ (NSUInteger) charLength:(NSString *) target;
// 获得字符串双字节长度-(2个英文算1个中文)
+ (NSUInteger) doubleLength:(NSString *) target;
// 限制字符串长度
+ (NSString *) limit:(NSString *) target
                 max:(NSUInteger) max;
// 限制字符串长度
+ (NSString *) limit:(NSString *) target
                 max:(NSUInteger) max
                omit:(NSString *) omit;
// 转换图像URL地址
+ (NSString *) toImgUrl:(NSString *) url;
// 检查是否为正确的URL地址
+ (BOOL) isUrl:(NSString *) url;
// 检查是否为正确的图像URL地址
+ (BOOL) isImgUrl:(NSString *) url;
+ (BOOL) stringIsBlank:(NSString *)string;

// 密码规则
+ (BOOL) checkPassWord:(NSString *)string;
+ (BOOL)isNumber:(NSString *)string;
+ (BOOL) isMobilePhone:(NSString *)string;

// 计算Y轴最小值
+ (double) axisYMin:(double) yMin;

+ (NSString *)hexadecimalStringFromData:(NSData *)data;

@end

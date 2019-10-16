//
//  GColorUtil.h
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,ColorType)
{
    Unkown_ColorType,
    C1_ColorType,  //主题色
    C2_ColorType,  //字体主色
    C3_ColorType,  //字体辅色
    C4_ColorType,  //textfield placeholder色
    C5_ColorType,  //白色
    C6_ColorType,  //底色
    C7_ColorType,  //线色
    C8_ColorType,  //分隔区域色
    C9_ColorType,  //绘图 涨色
    C10_ColorType, //绘图 跌色
    C11_ColorType, //涨色
    C12_ColorType, //跌色
    C13_ColorType, //蓝色
    C14_ColorType, //红色
    C15_ColorType, //背景色（辅）
    C16_ColorType,
    C17_ColorType, //红（辅）
    C18_ColorType, //绿（辅）
    C19_ColorType, //边框
    C21_ColorType, //
    C22_ColorType, // 黑版：白色，黑板：字主色
    C23_ColorType, //背景色（辅）
    C24_ColorType, //绿
    C1100_ColorType, //紫色
};

@interface GColorUtil : NSObject

// 转换十六进颜色
+ (UIColor *) colorWithHex:(long) hexColor;
// 转换十六进颜色
+ (UIColor *) colorWithHex:(long) hexColor
                     alpha:(CGFloat) alpha;
+ (UIColor *) colorWithHexString:(NSString *) hex;
+ (UIColor *)colorWithColorType:(ColorType)colorType;
//黑白皮肤颜色适配
+ (UIColor *)colorWithColorType:(ColorType)colorType alpha:(CGFloat)alpha;

+ (UIColor *)colorWithWhiteColorType:(ColorType)colorType;
+ (UIColor *)colorWithBlackColorType:(ColorType)colorType;
+ (UIColor *)colorWithBlackColorType:(ColorType)colorType alpha:(CGFloat)alpha;
/**
 主题色
 */
+(UIColor *)C1;
/**
 字体色主色
 */
+(UIColor *)C2;
/**
 字体色次色
 */
+(UIColor *)C3;
/**
 字体色浅色
 */
+(UIColor *)C4;
/**
 白色
 */
+(UIColor *)C5;
/**
 背景底色
 */
+(UIColor *)C6;
/**
 分割线
 */
+(UIColor *)C7;
/**
 分割区域
 */
+(UIColor *)C8;
/**
 绘图 上涨的色值
 */
+(UIColor *)C9;
/**
 绘图 下跌的色值
 */
+(UIColor *)C10;
/**
 按钮 上涨的色值
 */
+(UIColor *)C11;
/**
 按钮 下跌的色值
 */
+(UIColor *)C12;
/**
 蓝色
 */
+(UIColor *)C13;
/**
 红色
 */
+(UIColor *)C14;
/**
 背景色（辅）
 */
+(UIColor *)C15;
+(UIColor *)C16;
+(UIColor *)C17;
+(UIColor *)C18;
+(UIColor *)C19;
+(UIColor *)C21;
+(UIColor *)C22;
+(UIColor *)C23;
+(UIColor *)C24;
+(UIColor *)C1100;

+(UIColor *)C1_black;
+(UIColor *)C2_black;
+(UIColor *)C3_black;
+(UIColor *)C4_black;
+(UIColor *)C6_black;
+(UIColor *)C7_black;
+(UIColor *)C8_black;

+(UIColor *)tradeChartsBgColor;
+(UIColor *)tradeChartsBgShadowColor;
+(UIColor *)tabbarColor;
+(UIColor *)pwdLabelColor;
+ (UIColor *)disEnableColor;
+ (UIColor *)qrcodeBgColor;

+ (UIColor *)colorWithProfitString:(NSString *)profit;
+ (ColorType)colorTypeWithProfitString:(NSString *)profit;
+ (NSString *)raiseWithProfitString:(NSString *)profit;
+ (UIColor *)colorWithColor:(UIColor *)color alpha:(CGFloat)alpha;

+ (UIImage *)imageNamed:(NSString *)imageName;
+ (UIImage *)imageNamed_whiteTheme:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END

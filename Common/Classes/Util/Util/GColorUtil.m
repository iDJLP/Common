//
//  GColorUtil.m
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "GColorUtil.h"

@implementation GColorUtil

+ (NSString *)raiseWithProfitString:(NSString *)profit
{
    if (profit.length < 1) {
        return @"0";
    }else if (profit.floatValue < 0.00) {
        return @"2";
    }else if (profit.floatValue > 0.00){
        return @"1";
    }else{
        return @"0";
    }
}

+ (UIColor *)colorWithProfitString:(NSString *)profit
{
    if (profit.length < 1) {
        return [self C3];
    }else if (profit.floatValue < 0.00) {
        return [self C12];
    }else if (profit.floatValue > 0.00){
        return [self C11];
    }else{
        return [self C3];
    }
}

+ (ColorType)colorTypeWithProfitString:(NSString *)profit
{
    if (profit.length < 1) {
        return C3_ColorType;
    }else if (profit.floatValue < 0.00) {
        return C12_ColorType;
    }else if (profit.floatValue > 0.00){
        return C11_ColorType;
    }else{
        return C3_ColorType;
    }
}

+ (UIColor *)colorWithColor:(UIColor *)color alpha:(CGFloat)alpha{
    CGFloat red =0;
    CGFloat green =0;
    CGFloat blue =0;
    CGFloat a=0;
    [color getRed:&red green:&green blue:&blue alpha:&a];
    return [UIColor colorWithRed:red
                           green:green blue:blue alpha:alpha];
}

// 16进制颜色
+ (UIColor *) colorWithHex:(long) hexColor
{
    float alpha=((float)((hexColor & 0xFF000000) >> 24))/255.0;
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    if(alpha<=0){
        alpha=1;
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}
// 转换十六进颜色
+ (UIColor *) colorWithHex:(long) hexColor
                     alpha:(CGFloat) alpha
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *) colorWithHexString:(NSString *) hex
{
    NSString *cleanString = [hex stringByReplacingOccurrencesOfString:@"#" withString:@""];
    CGFloat alpha = 1.0;
    if ([cleanString length] == 8) {
        alpha = 1-[[cleanString.mutableCopy substringToIndex:2] floatValue];
        cleanString = [cleanString.mutableCopy substringFromIndex:2];
    }
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }
    if([cleanString length] == 6) {
        cleanString = [cleanString stringByAppendingString:@"ff"];
    }
    
    unsigned int baseValue;
    [[NSScanner scannerWithString:cleanString] scanHexInt:&baseValue];
    float red = ((baseValue >> 24) & 0xFF)/255.0f;
    float green = ((baseValue >> 16) & 0xFF)/255.0f;
    float blue = ((baseValue >> 8) & 0xFF)/255.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (UIColor *)colorWithColorType:(ColorType)colorType{
    return [self colorWithColorType:colorType alpha:1];
}
+ (UIColor *)colorWithColorType:(ColorType)colorType alpha:(CGFloat)alpha{
    if ([CFDApp sharedInstance].isWhiteTheme) {
        return [self colorWithWhiteColorType:colorType alpha:alpha];
    }else{
        return [self colorWithBlackColorType:colorType alpha:alpha];
    }
}

+ (UIColor *)colorWithWhiteColorType:(ColorType)colorType{
    return [self colorWithWhiteColorType:colorType alpha:1];
}
+ (UIColor *)colorWithWhiteColorType:(ColorType)colorType alpha:(CGFloat)alpha{
    switch (colorType) {
        case C1_ColorType:{
            return [self colorWithHex:0xff6b31 alpha:alpha];
        }
            break;
        case C2_ColorType:{
            return [self colorWithHex:0x1F3F59 alpha:alpha];
        }
            break;
        case C3_ColorType:{
            return [self colorWithHex:0x8C9FAD alpha:alpha];
        }
            break;
        case C4_ColorType:{
            return [self colorWithHex:0xC5CFD5 alpha:alpha];
        }
            break;
            
        case C5_ColorType:{
            return [self colorWithHex:0xffffff alpha:alpha];
        }
        case C6_ColorType:{
            return [self colorWithHex:0xffffff alpha:alpha];
        }
            break;
        case C7_ColorType:{
            return [self colorWithHex:0xF7F7FB alpha:alpha];
        }
            break;
        case C8_ColorType:{
            return [self colorWithHex:0xF8FAFB alpha:alpha];
        }
            break;
        case C9_ColorType:{
            
            return [CFDApp sharedInstance].isRed?[self colorWithHex:0xD14B64 alpha:alpha]:[self colorWithHex:0x03AD8F alpha:alpha];
        }
            break;
        case C10_ColorType:{
            return [CFDApp sharedInstance].isRed?[self colorWithHex:0x03AD8F alpha:alpha]:[self colorWithHex:0xD14B64 alpha:alpha];
        }
            break;
        case C11_ColorType:{
            return [CFDApp sharedInstance].isRed?[self colorWithHex:0xD14B64 alpha:alpha]:[self colorWithHex:0x03AD8F alpha:alpha];
        }
            break;
        case C12_ColorType:{
            return [CFDApp sharedInstance].isRed?[self colorWithHex:0x03AD8F alpha:alpha]:[self colorWithHex:0xD14B64 alpha:alpha];
        }
            break;
        case C13_ColorType:{
            return [self colorWithHex:0x1882D4 alpha:alpha];
        }
        case C14_ColorType:{
            return [self colorWithHex:0xD14B64 alpha:alpha];
        }
            break;
        case C15_ColorType:{
            return [self colorWithHex:0xffffff alpha:alpha];
        }
            break;
        case C16_ColorType:{
            return [self colorWithHex:0xF8FAFB alpha:alpha];
        }
            break;
        case C17_ColorType:{
            if ([CFDApp sharedInstance].isRed) {
                return [self colorWithHex:0xCC5C71 alpha:alpha];
            }else{
                return [self colorWithHex:0x51AF9E alpha:alpha];
            }
        }
            break;
        case C18_ColorType:{
            if ([CFDApp sharedInstance].isRed) {
                return [self colorWithHex:0x51AF9E alpha:alpha];
            }else{
                return [self colorWithHex:0xCC5C71 alpha:alpha];
            }
        }
            break;
        case C19_ColorType:{
            return [self colorWithHex:0xF2F4FB alpha:alpha];
        }
            break;
            
        case C21_ColorType:{
            return [self colorWithHex:0x1882D4 alpha:alpha];
        }
            break;
        case C22_ColorType:{
            return [self colorWithHex:0x1F3F59 alpha:alpha];
        }
            break;
        case C23_ColorType:{
            return [self colorWithHex:0xF8FAFB alpha:alpha];
        }
            break;
        case C24_ColorType:{
            return [self colorWithHex:0x03AD8F alpha:alpha];
        }
            break;
        case C1100_ColorType:{
            return [self colorWithHex:0xD456FE alpha:alpha];
        }
            break;
        default:
            break;
    }
    return [self colorWithHex:0x5f72ee alpha:alpha];
}

+ (UIColor *)colorWithBlackColorType:(ColorType)colorType{
    return [self colorWithBlackColorType:colorType alpha:1];
}
+ (UIColor *)colorWithBlackColorType:(ColorType)colorType alpha:(CGFloat)alpha{
    switch (colorType) {
        case C1_ColorType:{
            return [self colorWithHex:0xCFD3E9 alpha:alpha];
        }
            break;
        case C2_ColorType:{
            return [self colorWithHex:0xCFD3E9 alpha:alpha];
        }
            break;
        case C3_ColorType:{
            return [self colorWithHex:0x6D87A8 alpha:alpha];
        }
            break;
        case C4_ColorType:{
            return [self colorWithHex:0x3D526B alpha:alpha];
        }
            break;
            
        case C5_ColorType:{
            return [self colorWithHex:0xffffff alpha:alpha];
        }
        case C6_ColorType:{
            return [self colorWithHex:0x131E2F alpha:alpha];
        }
            break;
        case C7_ColorType:{
            return [self colorWithHex:0x0D1725 alpha:alpha];
        }
            break;
        case C8_ColorType:{
            return [self colorWithHex:0x0D1725 alpha:alpha];
        }
            break;
        case C9_ColorType:{
            
            return [CFDApp sharedInstance].isRed?[self colorWithHex:0xD14B64 alpha:alpha]:[self colorWithHex:0x03AD8F alpha:alpha];
        }
            break;
        case C10_ColorType:{
            return [CFDApp sharedInstance].isRed?[self colorWithHex:0x03AD8F alpha:alpha]:[self colorWithHex:0xD14B64 alpha:alpha];
        }
            break;
        case C11_ColorType:{
            return [CFDApp sharedInstance].isRed?[self colorWithHex:0xD14B64 alpha:alpha]:[self colorWithHex:0x03AD8F alpha:alpha];
        }
            break;
        case C12_ColorType:{
            return [CFDApp sharedInstance].isRed?[self colorWithHex:0x03AD8F alpha:alpha]:[self colorWithHex:0xD14B64 alpha:alpha];
        }
            break;
        case C13_ColorType:{
            return [self colorWithHex:0x1882D4 alpha:alpha];
        }
        case C14_ColorType:{
            return [self colorWithHex:0xD14B64 alpha:alpha];
        }
            break;
        case C15_ColorType:{
            return [self colorWithHex:0x19263C alpha:alpha];
        }
            break;
        case C16_ColorType:{
            return [self colorWithHex:0x19263C alpha:alpha];
        }
            break;
        case C17_ColorType:{
            if ([CFDApp sharedInstance].isRed) {
                return [self colorWithHex:0x532D40 alpha:alpha];
            }else{
                return [self colorWithHex:0x0D4E4F alpha:alpha];
            }
        }
            break;
        case C18_ColorType:{
            if ([CFDApp sharedInstance].isRed) {
                return [self colorWithHex:0x0D4E4F alpha:alpha];
            }else{
                return [self colorWithHex:0x532D40 alpha:alpha];
            }
        }
            break;
        case C19_ColorType:{
            return [self colorWithHex:0x000000 alpha:0];
        }
            break;
        case C21_ColorType:{
            return [self colorWithHex:0xffffff alpha:alpha];
        }
            break;
        case C22_ColorType:{
            return [self colorWithHex:0xffffff alpha:alpha];
        }
            break;
        case C23_ColorType:{
            return [self colorWithHex:0x131E2F alpha:alpha];
        }
            break;
        case C24_ColorType:{
            return [self colorWithHex:0x03AD8F alpha:alpha];
        }
            break;
        case C1100_ColorType:{
            return [self colorWithHex:0xD456FE alpha:alpha];
        }
            break;
        default:
            break;
    }
    return [self colorWithHex:0x5f72ee alpha:alpha];
}


+(UIColor *)C1{
    return [self colorWithColorType:C1_ColorType];
}
+(UIColor *)C2{
    return [self colorWithColorType:C2_ColorType];
}
+(UIColor *)C3{
    return [self colorWithColorType:C3_ColorType];
}
+(UIColor *)C4{
    return [self colorWithColorType:C4_ColorType];
}
+(UIColor *)C5{
    return [self colorWithColorType:C5_ColorType];
}
+(UIColor *)C6{
    return [self colorWithColorType:C6_ColorType];
}
+(UIColor *)C7{
    return [self colorWithColorType:C7_ColorType];
}
+(UIColor *)C8{
    return [self colorWithColorType:C8_ColorType];
}
+(UIColor *)C9{
    return [self colorWithColorType:C9_ColorType];
}
+(UIColor *)C10{
    
    return [self colorWithColorType:C10_ColorType];
}
+(UIColor *)C11{
    
    return [self colorWithColorType:C11_ColorType];
}
+(UIColor *)C12{
    
    return [self colorWithColorType:C12_ColorType];
}
+(UIColor *)C13{
    
    return [self colorWithColorType:C13_ColorType];
}

+(UIColor *)C14{
    
    return [self colorWithColorType:C14_ColorType];
}

+(UIColor *)C15{
    
    return [self colorWithColorType:C15_ColorType];
}
+(UIColor *)C16{
    
    return [self colorWithColorType:C16_ColorType];
}
+(UIColor *)C17{
    
    return [self colorWithColorType:C17_ColorType];
}
+(UIColor *)C18{
    
    return [self colorWithColorType:C18_ColorType];
}
+(UIColor *)C19{
    
    return [self colorWithColorType:C19_ColorType];
}
+(UIColor *)C21{
    return [self colorWithColorType:C21_ColorType];
}
+(UIColor *)C22{
    return [self colorWithColorType:C22_ColorType];
}
+(UIColor *)C23{
    return [self colorWithColorType:C23_ColorType];
}
+(UIColor *)C24{
    return [self colorWithColorType:C24_ColorType];
}
+(UIColor *)C1100{
    
    return [self colorWithColorType:C1100_ColorType];
}

+(UIColor *)C1_white{
    
    return [self colorWithColorType:C1_ColorType];
}
+(UIColor *)C2_white{
    return [self colorWithColorType:C2_ColorType];
}
+(UIColor *)C3_white{
    
    return [self colorWithColorType:C3_ColorType];
}
+(UIColor *)C4_white{
    return [self colorWithColorType:C4_ColorType];
}
+(UIColor *)C5_white{
    return [self colorWithColorType:C5_ColorType];
}
+(UIColor *)C6_white{
    return [self colorWithColorType:C6_ColorType];
}
+(UIColor *)C7_white{
    
    return [self colorWithColorType:C7_ColorType];
}
+(UIColor *)C8_white{
    return [self colorWithColorType:C8_ColorType];
}

+(UIColor *)C1_black{
    return [self colorWithBlackColorType:C1_ColorType];
}
+(UIColor *)C2_black{
    return [self colorWithBlackColorType:C2_ColorType];
}
+(UIColor *)C3_black{
    return [self colorWithBlackColorType:C3_ColorType];
}
+(UIColor *)C4_black{
    return [self colorWithBlackColorType:C4_ColorType];
}

+(UIColor *)C6_black{
    return [self colorWithBlackColorType:C6_ColorType];
}
+(UIColor *)C7_black{
    
    return [self colorWithBlackColorType:C7_ColorType];
}
+(UIColor *)C8_black{
    return [self colorWithBlackColorType:C8_ColorType];
}

+ (UIColor *)qrcodeBgColor{
    if ([CFDApp sharedInstance].isWhiteTheme) {
        return [self colorWithHex:0x000000];
    }else{
        return [self colorWithHex:0xffffff];
    }
}

+ (UIColor *)tradeChartsBgColor{
    if ([CFDApp sharedInstance].isWhiteTheme) {
        return [self colorWithHex:0xffffff];
    }else{
        return [self colorWithHex:0x162741];
    }
}
+ (UIColor *)tabbarColor{
    if ([CFDApp sharedInstance].isWhiteTheme) {
        return [self colorWithHex:0xffffff];
    }else{
        return [self colorWithHex:0x162741];
    }
}

+ (UIColor *)tradeChartsBgShadowColor{
    if ([CFDApp sharedInstance].isWhiteTheme) {
        return [self colorWithHex:0xD2D5D8 alpha:0.6];
    }else{
        return [self colorWithHex:0x2C3A4E alpha:0.6];
    }
}



+ (UIColor *)pwdLabelColor{
    if ([CFDApp sharedInstance].isWhiteTheme) {
        return [self colorWithHex:0x8C9FAD];
    }else{
        return [self colorWithHex:0xffffff];
    }
}

+ (UIColor *)disEnableColor{
    if ([CFDApp sharedInstance].isWhiteTheme) {
        return [self colorWithHex:0xE2E2E2];
    }else{
        return [self colorWithHex:0x19263C];
    }
}



+ (UIImage *)imageNamed:(NSString *)imageName{
    UIImage *img = nil;
    UIImage *img_white = nil;
    UIImage *img_black = nil;
    if ([CFDApp sharedInstance].isWhiteTheme) {
        NSString *imageName_white = [self imageName_whiteTheme:imageName];
        img_white = [UIImage imageNamed:imageName_white];
        img = img_white;
    }else{
        img_black = [UIImage imageNamed:imageName];
        img = img_black;
    }
    if (img==nil) {
        img_black = [UIImage imageNamed:imageName];
        img = [CFDApp sharedInstance].isWhiteTheme?img_black:img_white;
    }
    return img;
}

+ (UIImage *)imageNamed_whiteTheme:(NSString *)imageName{
    UIImage *img = nil;
    UIImage *img_white = nil;
    UIImage *img_black = nil;
    NSString *imageName_white = [self imageName_whiteTheme:imageName];
    img_white = [UIImage imageNamed:imageName_white];
    img = img_white;
    if (img==nil) {
        img_black = [UIImage imageNamed:imageName];
        img = img_black;
    }
    return img;
}

+ (NSString *)imageName_whiteTheme:(NSString *)imageName{
    NSString *name =[NSString stringWithFormat:@"%@_light",imageName];
    return name;
}



@end

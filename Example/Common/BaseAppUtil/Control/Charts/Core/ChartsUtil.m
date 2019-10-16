//
//  GUIUtil.m
//  globalwin
//
//  Created by ngw15 on 2018/8/31.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "ChartsUtil.h"

@implementation ChartsUtil

+ (CGFloat)fit:(CGFloat)f{
    return [GUIUtil fit:f];
}
// 等比适配尺寸
+ (CGSize) fitWidth:(CGFloat) width
             height:(CGFloat) height{
    return [GUIUtil fitWidth:width height:height];
}
+ (CGFloat)fitLine{
    return [GUIUtil fitLine];
}
+ (CGFloat)fitFontSize:(CGFloat)f{
    return [GUIUtil fitFontSize:f];
}

+ (UIFont *)fitFont:(CGFloat)f{
    return [GUIUtil fitFont:f];
}
// 粗体字体适配
+ (UIFont *) fitBoldFont:(CGFloat) size{
    return [GUIUtil fitBoldFont:size];
}
//MARK: - 根据字体计算指定宽度的自动尺寸

// 根据字体计算最大宽度的自动尺寸
+ (CGSize) sizeWith:(NSString *) text
           fontSize:(NSInteger) fontSize
{
    return [self sizeWith:text width:MAXFLOAT fontSize:fontSize];
}

+ (CGSize) sizeWith:(NSString *) text
              width:(CGFloat) width
           fontSize:(NSInteger)fontSize
{
    if([text isKindOfClass:[NSNull class]] || text.length<1){
        text=@"";
    }
    CGSize size=[text boundingRectWithSize:CGSizeMake(width,MAXFLOAT)
                                   options:NSStringDrawingUsesLineFragmentOrigin
                                attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize],NSFontAttributeName, nil] context:nil].size;
    size.width=ceil(size.width);
    size.height=ceil(size.height);
    return size;
}
// 计算尺寸
+ (CGSize) sizeWith:(NSString *) text
              width:(CGFloat) width
             height:(CGFloat) height
               font:(UIFont *) font
{
    if(![text isKindOfClass:[NSString class]] || text.length<1){
        text=@"?";
    }
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode=NSLineBreakByCharWrapping;
    NSDictionary *attribute = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraph};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width,height) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attribute context:nil].size;
    size.width=ceil(size.width);
    size.height=ceil(size.height);
    return size;
}
// 计算尺寸
+ (CGSize) sizeWith:(NSString *) text
              width:(CGFloat) width
               font:(UIFont *) font
{
    return [self sizeWith:text width:width height:MAXFLOAT font:font];
}

// 计算尺寸
+ (CGSize) sizeWith:(NSString *) text
              width:(CGFloat) width
               font:(UIFont *) font
          lineSpace:(CGFloat) lineSpace
{
    if([text isKindOfClass:[NSNull class]] || text.length<1){
        text=@"";
    }
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode=NSLineBreakByCharWrapping;
    paragraph.lineSpacing=lineSpace;
    NSDictionary *attribute = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraph};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attribute context:nil].size;
    size.width=ceil(size.width);
    size.height=ceil(size.height);
    return size;
}

+ (CGSize)sizeWith:(NSAttributedString *)attrString
             width:(NSInteger)width
{
    CGRect rect = [attrString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    CGSize size = rect.size;
    size.width = ceil(size.width);
    size.height = ceil(size.height);
    return size;
}

+(CGSize) fitSize:(UILabel *)label
{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = label.lineBreakMode;
    paragraphStyle.alignment = label.textAlignment;
    NSDictionary * attributes=@{NSFontAttributeName : label.font,
                                NSParagraphStyleAttributeName : paragraphStyle};
    CGSize contentSize = [label.text boundingRectWithSize:label.frame.size
                                                  options:(NSStringDrawingUsesLineFragmentOrigin)
                                               attributes:attributes
                                                  context:nil].size;
    return contentSize;
}



//MARK: - Color

+ (UIColor *)colorWithColorType:(ColorType)colorType alpha:(CGFloat)alpha{
    return [GColorUtil colorWithColorType:colorType alpha:alpha];
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
// 转换十六进颜色
+ (UIColor *) colorWithHex:(long) hexColor
{
    float red = ((float)((hexColor & 0xFF0000) >> 16))/255.0;
    float green = ((float)((hexColor & 0xFF00) >> 8))/255.0;
    float blue = ((float)(hexColor & 0xFF))/255.0;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1];
}
//蓝色
+ (UIColor *)C1{
    return GColorUtil.C1;
}
//字体色 主
+ (UIColor *)C2{
     return GColorUtil.C2;
}
//字体色 辅
+ (UIColor *)C3{
     return GColorUtil.C3;
}
//输入框placeholder字体色
+ (UIColor *)C4{
     return GColorUtil.C4;
}
//白
+ (UIColor *)C5{
    return GColorUtil.C5;
}
//底色
+ (UIColor *)C6{
     return GColorUtil.C6;
}
//线的色值
+ (UIColor *)C7{
    if ([CFDApp sharedInstance].isWhiteTheme) {
        return [self colorWithHex:0xE9EEF4];
    }else{
        return [self colorWithHex:0x1D2D40];
    }
}
//线的色值
+ (UIColor *)C17{
    if ([CFDApp sharedInstance].isWhiteTheme) {
        return [self colorWithHex:0x8C9FAD];
    }else{
        return [self colorWithHex:0xffffff];
    }
}
//字
+ (UIColor *)C18{
    if ([CFDApp sharedInstance].isWhiteTheme) {
        return [self colorWithHex:0x8C9FAD];
    }else{
        return GColorUtil.C3;
    }
}
//字
+ (UIColor *)C19{
    if ([CFDApp sharedInstance].isWhiteTheme) {
        return [self colorWithHex:0x1F3F59];
    }else{
        return [self colorWithHex:0xffffff];
    }
}
+ (UIColor *)C8{
     return GColorUtil.C8;
}
//绘图的涨色
+ (UIColor *)C9{
    return GColorUtil.C9;
}
//绘图的跌色
+ (UIColor *)C10{
    return GColorUtil.C10;
}
//按钮的涨色
+ (UIColor *)C11{
    return GColorUtil.C11;
}
//按钮的跌色
+ (UIColor *)C12{
    return GColorUtil.C12;
}
//蓝色
+ (UIColor *)C13{
    return GColorUtil.C13;
}
//红色
+ (UIColor *)C14{
    return GColorUtil.C14;
}
+ (UIColor *)C11:(CGFloat)alpha{
    return [GColorUtil colorWithBlackColorType:C11_ColorType alpha:alpha];
}
+ (UIColor *)C12:(CGFloat)alpha{
    return [GColorUtil colorWithBlackColorType:C12_ColorType alpha:alpha];
}
+ (UIColor *)C13:(CGFloat)alpha{
    return [GColorUtil colorWithBlackColorType:C13_ColorType alpha:alpha];
}

//黄色
+ (UIColor *)C20{
    return [ChartsUtil colorWithHex:0xC5C548];
}
//紫色
+ (UIColor *)C1100{
    return GColorUtil.C1100;
}

+ (UIColor *)chartsBgColor{
    if ([CFDApp sharedInstance].isWhiteTheme) {
        return [self colorWithHex:0xffffff];
    }else{
        return [self colorWithHex:0x0E1826];
    }
}

//MARK: - Compare
+ (NSComparisonResult)compare:(CGFloat)float1 withFloat:(CGFloat)float2{
    CGFloat result = float1 - float2;
    if (fabs(result)<0.000001) {
        return NSOrderedSame;
    }else if (result<0){
        return NSOrderedAscending;
    }else{
        return NSOrderedDescending;
    }
}

@end

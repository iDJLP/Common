//
//  GUIUtil.h
//  globalwin
//
//  Created by ngw15 on 2018/8/31.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ChartsUtil : NSObject

//MARK: - 根据系统字体大小与最大宽度计算尺寸
// 计算尺寸
+ (CGSize) sizeWith:(NSString *) text
              width:(CGFloat) width
               font:(UIFont *) font;
// 计算尺寸
+ (CGSize) sizeWith:(NSString *) text
              width:(CGFloat) width
               font:(UIFont *) font
          lineSpace:(CGFloat) lineSpace;
// 计算尺寸
+ (CGSize) sizeWith:(NSString *) text
              width:(CGFloat) width
             height:(CGFloat) height
               font:(UIFont *) font;
+ (CGSize) sizeWith:(NSString *) text
           fontSize:(NSInteger) fontSize;
+ (CGSize) sizeWith:(NSString *) text
              width:(CGFloat) width
           fontSize:(NSInteger)fontSize;
+ (CGSize)sizeWith:(NSAttributedString *)attrString
             width:(NSInteger)width;

+ (CGSize) fitSize:(UILabel *)label;

//MARK: - FitWidth
+ (CGFloat)fit:(CGFloat)f;
// 等比适配尺寸
+ (CGSize) fitWidth:(CGFloat) width
             height:(CGFloat) height;
+ (CGFloat)fitLine;
+ (UIFont *)fitFont:(CGFloat)f;
// 粗体字体适配
+ (UIFont *) fitBoldFont:(CGFloat) size;
+ (CGFloat)fitFontSize:(CGFloat)f;
//MARK: - Color
+ (UIColor *)colorWithColorType:(ColorType)colorType alpha:(CGFloat)alpha;
+ (UIColor *) colorWithHex:(long) hexColor
                     alpha:(CGFloat) alpha;
+ (UIColor *) colorWithHex:(long) hexColor;
+ (UIColor *)C1;
+ (UIColor *)C2;
+ (UIColor *)C3;
+ (UIColor *)C4;
+ (UIColor *)C5;
+ (UIColor *)C6;
+ (UIColor *)C7;
+ (UIColor *)C8;
+ (UIColor *)C9;
+ (UIColor *)C10;
+ (UIColor *)C11;
+ (UIColor *)C12;
+ (UIColor *)C13;
+ (UIColor *)C11:(CGFloat)alpha;
+ (UIColor *)C12:(CGFloat)alpha;
+ (UIColor *)C13:(CGFloat)alpha;
+ (UIColor *)C17;
+ (UIColor *)C18;
+ (UIColor *)C19;
+ (UIColor *)C20;
+ (UIColor *)C1100;

+ (UIColor *)chartsBgColor;

//MARK: - Compare
+ (NSComparisonResult)compare:(CGFloat)float1 withFloat:(CGFloat)float2;
@end

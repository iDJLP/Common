//
//  GUIUtil.h
//  niuguwang
//
//  Created by BrightLi on 2017/10/20.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface GUIUtil : NSObject

// 根据系统字体大小与最大宽度计算尺寸
+ (CGSize)sizeWith:(NSString *) text
          fontSize:(NSInteger) fontSize
             width:(NSInteger) width;
// 计算尺寸
+ (CGSize) sizeWith:(NSString *) text
              width:(CGFloat) width
               font:(UIFont *) font;
// 计算尺寸
+ (CGSize) sizeWith:(NSString *) text
              width:(CGFloat) width
               font:(UIFont *) font
          lineSpace:(CGFloat) lineSpace;
// 计算UILabel的自动尺寸
+ (CGSize) sizeWithLabel:(UILabel *)label;
// 计算UILabel的自动尺寸
+ (CGSize) sizeWithLabel:(UILabel *)label
                   width:(CGFloat) width;
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
+ (UIFont *) fitFont:(CGFloat) size;
// 字体适配
+ (UIFont *) fitFont:(NSString *)name size:(CGFloat)size;
// 粗体字体适配
+ (UIFont *) fitBoldFont:(CGFloat) size;
// 字体尺寸适配
+ (CGFloat) fitFontSize:(CGFloat) size;
// 字体尺寸适配
+(UIFont *) fitFontOfSize:(CGFloat) size;
// 适配宽度
+ (CGFloat) fit:(CGFloat) width;
+ (CGFloat) fitLine;
// 等比适配尺寸
+ (CGSize) fitWidth:(CGFloat) width
               height:(CGFloat) height;


// 获得行数
+ (NSInteger) linesWith:(UILabel *) label;
// 调整行间距
+ (void) adjustLineSpace:(UILabel *) label
               lineSpace:(CGFloat) lineSpace;
// 调整行间距
+ (void) adjustLineSpace:(UILabel *) label
                   width:(CGFloat) width
               lineSpace:(CGFloat) lineSpace;
// 替换指定属性文本的字体
+(NSMutableAttributedString *) replaceAttributed:(NSMutableAttributedString *) att
                                             key:(NSString *) key
                                           value:(NSString *) value
                                            font:(UIFont *)font;
// 设置锁屏
+(void) lockScreen:(BOOL) isLock;

+ (void) refreshWithWhiteHeader:(UIScrollView *) scrollView
                        refresh:(dispatch_block_t) refresh;
+ (void) refreshWithHeader:(UIScrollView *) scrollView
                   refresh:(dispatch_block_t) refresh;
// 设置上拉刷新
+ (void)refreshWithFooter:(UIScrollView *) scrollView
                  refresh:(dispatch_block_t) refresh;

+ (void)imageViewWithUrl:(UIImageView *)imgView url:(NSString *)url;
+ (void)imageViewWithUrl:(UIImageView *)imgView url:(NSString *)url placeholder:(NSString *)img;
+ (void)imageViewWithUrl:(UIImageView *)imgView url:(NSString *)url placeholder:(NSString *)img completedBlock:(void(^)(UIImage * image, NSError * error, NSInteger cacheType, NSURL * imageURL))completedBlock;
+ (void)imageBtnWithUrl:(UIImageView *)imgView url:(NSString *)url;
+ (void)imageBtnWithUrl:(UIImageView *)imgView url:(NSString *)url placeholder:(NSString *)img;
+ (void)imageBtnWithUrl:(UIImageView *)imgView url:(NSString *)url placeholder:(NSString *)img completedBlock:(void(^)(UIImage * image, NSError * error, NSInteger cacheType, NSURL * imageURL))completedBlock;

+ (NSString *)decimalAdd:(NSString *)num1 num:(NSString *)num2;
+ (NSString *)decimalSubtract:(NSString *)num1 num:(NSString *)num2;
+ (NSString *)decimalMultiply:(NSString *)num1 num:(NSString *)num2;
+ (NSString *)decimalDivide:(NSString *)num1 num:(NSString *)num2;
///返回的是带%的百分数
+ (NSString *)decimalPercentDivide:(NSString *)num1 num:(NSString *)num2;

+ (NSComparisonResult)compareFloat:(NSString *)num1 with:(NSString *)num2;
+ (BOOL)equalValue:(NSString *)num1 with:(NSString *)num2;
//给NSDecimalNumber四舍五入
+ (NSString *)notRounding:(NSDecimalNumber *)price afterPoint:(NSInteger)dotNum;
+ (NSString *)notRoundingString:(NSString *)price afterPoint:(NSInteger)dotNum;
+ (NSString *)notRoundingDownString:(NSString *)price afterPoint:(NSInteger)dotNum;
+ (NSString *)formatter:(NSInteger)dotnum;

+ (NSString *)readQRCodeFromImage:(UIImage *)image;
/**
 *  生成二维码图片
 *
 *  @param QRString  二维码内容
 *  @param sizeWidth 图片size（正方形）
 *  @param color     填充色
 *
 *  @return  二维码图片
 */
+(UIImage *)createQRimageString:(NSString *)QRString sizeWidth:(CGFloat)sizeWidth fillColor:(UIColor *)color;

+ (NSString *)webTips;

@end

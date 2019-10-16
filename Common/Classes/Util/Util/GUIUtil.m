//
//  GUIUtil.m
//  niuguwang
//
//  Created by BrightLi on 2017/10/20.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "GUIUtil.h"
#import "GLog.h"
#import "Macros.h"

#define FIXED_WIDTH 2
#define FIXED_HEIGHT 2
#define FIXED_FONT_WIDTH 3
#define FIXED_FONT_HEIGHT 1

static NSString *_screenWidth;
static NSString *_screenHeight;
static CGFloat _fitWidthScale;

@implementation GUIUtil

//MARK: - Font
// 字体适配
+ (UIFont *) fitFont:(CGFloat)size
{
    return [UIFont systemFontOfSize:[self fitFontSize:size]];
}
// 字体适配
+ (UIFont *) fitFont:(NSString *)name size:(CGFloat)size
{
    return [UIFont fontWithName:name size:[self fitFontSize:size]];
}
// 粗体字体适配
+ (UIFont *) fitBoldFont:(CGFloat)size
{
    return [UIFont boldSystemFontOfSize:[self fitFontSize:size]];
}
// 字体尺寸适配
+(CGFloat) fitFontSize:(CGFloat) size
{
    CGFloat scale=1.0f;
    if(IS_IPHONE_X){
        scale=1.0f;
    }else if(IS_IPHONE_6P){
        scale=1.05f;
    }else if(IS_IPHONE_6){
        scale=1.0f;
    }else if(IS_IPHONE_5){
        scale=0.92f;
    }else if(IS_IPHONE_4_OR_LESS){
        scale=0.92f;
    }
    return floor(size*scale);
}
// 字体尺寸适配
+(UIFont *) fitFontOfSize:(CGFloat) size
{
    return [UIFont systemFontOfSize:[self fitFontSize:size]];
}

//计算text宽高

// 根据字体计以及最大宽度计算控件高度
+ (CGSize)sizeWith:(NSString *) text
          fontSize:(NSInteger) fontSize
             width:(NSInteger) width
{
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode=NSLineBreakByCharWrapping;
    NSDictionary *attribute = @{NSFontAttributeName: [self fitFont:fontSize], NSParagraphStyleAttributeName:paragraph};
    CGSize size = [text boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return CGSizeMake(ceil(size.width),ceil(size.height));
}
// 计算UILabel的自动尺寸
+ (CGSize) sizeWithLabel:(UILabel *)label
{
    return [self sizeWith:label.text width:MAXFLOAT fontSize:label.font.pointSize];
}
// 计算UILabel的自动尺寸
+ (CGSize) sizeWithLabel:(UILabel *)label
                   width:(CGFloat) width
{
    return [self sizeWith:label.text width:width fontSize:label.font.pointSize];
}
// 根据字体计算最大宽度的自动尺寸
+ (CGSize) sizeWith:(NSString *) text
           fontSize:(NSInteger) fontSize
{
    return [self sizeWith:text width:MAXFLOAT fontSize:fontSize];
}
//MARK: - 根据字体计算指定宽度的自动尺寸
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
    size.width=ceil(size.width)+FIXED_FONT_WIDTH;
    size.height=ceil(size.height)+FIXED_FONT_HEIGHT;
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
    CGSize size = [text boundingRectWithSize:CGSizeMake(width,height) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    size.width=ceil(size.width)+3;
    size.height=ceil(size.height)+FIXED_FONT_HEIGHT;
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
    CGSize size = [text boundingRectWithSize:CGSizeMake(width,MAXFLOAT) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
    size.width=ceil(size.width)+3;
    size.height=ceil(size.height)+FIXED_FONT_HEIGHT;
    return size;
}

+ (CGSize)sizeWith:(NSAttributedString *)attrString
             width:(NSInteger)width
{
    CGRect rect = [attrString boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    CGSize size = rect.size;
    size.width = ceil(size.width)+3;
    size.height = ceil(size.height)+FIXED_FONT_HEIGHT;
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
                                                  options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                               attributes:attributes
                                                  context:nil].size;
    contentSize.width+=3;
    return contentSize;
}

//MARK: - Width
// 适配宽度
+ (CGFloat) fit:(CGFloat) width
{
    if(_fitWidthScale==0){
        _fitWidthScale=[UIScreen mainScreen].bounds.size.width/375.0;
    }
    return width*_fitWidthScale;
}

+ (CGFloat)fitLine{
    if(IS_IPHONE_6P || IS_IPHONE_X){
        return 1/3.0;
    }
    return 1/2.0;
}
// 6的原始尺寸转适配
+ (CGFloat) fitWidth6:(CGFloat) width
{
    CGFloat w=width*414/375;
    return [self fit:w];
}

+ (CGSize) fitWidth:(CGFloat) width
               height:(CGFloat) height
{
    if(_fitWidthScale==0){
        _fitWidthScale=[UIScreen mainScreen].bounds.size.width/375.0;
    }
    return CGSizeMake(width*_fitWidthScale,height*_fitWidthScale);
}

//MARK: - Refresh
+ (void) refreshWithHeader:(UIScrollView *) scrollView
                   refresh:(dispatch_block_t) refresh
{
    if ([CFDApp sharedInstance].isWhiteTheme) {
        [self refreshWithWhiteHeader:scrollView refresh:refresh];
    }else{    
        [self refreshWithBlackHeader:scrollView refresh:refresh];
    }
}

+ (void) refreshWithWhiteHeader:(UIScrollView *) scrollView
                        refresh:(dispatch_block_t) refresh
{
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        refresh();
    }];
    // 设置箭头
    [header arrowView].image=[GColorUtil imageNamed:@"refresh_arrow"];
    
    // 设置文字
    [header setTitle:CFDLocalizedString(@"下拉可以刷新") forState:MJRefreshStateIdle];
    [header setTitle:CFDLocalizedString(@"松开后刷新") forState:MJRefreshStatePulling];
    [header setTitle:CFDLocalizedString(@"正在加载...") forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    // 设置颜色
    // 设置颜色
    header.stateLabel.textColor = [GColorUtil C2];
    header.lastUpdatedTimeLabel.textColor = [GColorUtil colorWithColorType:C2_ColorType alpha:0.7];
    scrollView.mj_header=header;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    scrollView.mj_header.automaticallyChangeAlpha = YES;
}

+ (void) refreshWithBlackHeader:(UIScrollView *) scrollView
                   refresh:(dispatch_block_t) refresh
{
    MJRefreshNormalHeader *header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        refresh();
    }];
    // 设置箭头
    [header arrowView].image=[GColorUtil imageNamed:@"refresh_arrow_white"];
    header.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    // 设置文字
    [header setTitle:CFDLocalizedString(@"下拉可以刷新") forState:MJRefreshStateIdle];
    [header setTitle:CFDLocalizedString(@"松开后刷新") forState:MJRefreshStatePulling];
    [header setTitle:CFDLocalizedString(@"正在加载...") forState:MJRefreshStateRefreshing];
    // 设置字体
    header.stateLabel.font = [UIFont systemFontOfSize:14];
    header.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:12];
    // 设置颜色
    header.stateLabel.textColor = [GColorUtil colorWithHex:0xffffff];
    header.lastUpdatedTimeLabel.textColor = [GColorUtil colorWithHex:0xffffff alpha:0.5];
    scrollView.mj_header=header;
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    scrollView.mj_header.automaticallyChangeAlpha = YES;
}

// 设置上拉刷新
+ (void)refreshWithFooter:(UIScrollView *) scrollView
                  refresh:(dispatch_block_t) refresh
{
    if ([CFDApp sharedInstance].isWhiteTheme) {
        [self refreshWithWhiteFooter:scrollView refresh:refresh];
    }else{
        [self refreshWithBlackFooter:scrollView refresh:refresh];
    }
}

// 设置上拉刷新
+ (void)refreshWithWhiteFooter:(UIScrollView *) scrollView
                  refresh:(dispatch_block_t) refresh
{
    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        refresh();
    }];
    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    // 设置文字
    [footer setTitle:CFDLocalizedString(@"上拉加载更多") forState:MJRefreshStateIdle];
    [footer setTitle:CFDLocalizedString(@"正在加载...") forState:MJRefreshStateRefreshing];
    [footer setTitle:CFDLocalizedString(@"我是有底线的") forState:MJRefreshStateNoMoreData];
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    // 设置颜色
    footer.stateLabel.textColor = [GColorUtil C2];
    // 设置箭头
    [footer arrowView].image=[GColorUtil imageNamed:@"refresh_arrow"];
    scrollView.mj_footer=footer;
    scrollView.mj_footer.automaticallyChangeAlpha = YES;
}

// 设置上拉刷新
+ (void)refreshWithBlackFooter:(UIScrollView *) scrollView
                  refresh:(dispatch_block_t) refresh
{
    MJRefreshBackNormalFooter *footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        refresh();
    }];
    footer.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
    // 设置文字
    [footer setTitle:CFDLocalizedString(@"上拉加载更多") forState:MJRefreshStateIdle];
    [footer setTitle:CFDLocalizedString(@"正在加载...") forState:MJRefreshStateRefreshing];
    [footer setTitle:CFDLocalizedString(@"我是有底线的") forState:MJRefreshStateNoMoreData];
    // 设置字体
    footer.stateLabel.font = [UIFont systemFontOfSize:14];
    // 设置颜色
    footer.stateLabel.textColor = [GColorUtil C2];
    // 设置箭头
    [footer arrowView].image=[GColorUtil imageNamed:@"refresh_arrow_white"];
    scrollView.mj_footer=footer;
    scrollView.mj_footer.automaticallyChangeAlpha = YES;
}

//MARK: - SDWebImage

+ (void)imageViewWithUrl:(UIImageView *)imgView url:(NSString *)url{
    [self imageViewWithUrl:imgView url:url placeholder:nil];
}

+ (void)imageViewWithUrl:(UIImageView *)imgView url:(NSString *)url placeholder:(NSString *)img {
    [self imageViewWithUrl:imgView url:url placeholder:img completedBlock:nil];
}

+ (void)imageViewWithUrl:(UIImageView *)imgView url:(NSString *)url placeholder:(NSString *)img completedBlock:(void(^)(UIImage * image, NSError * error, NSInteger cacheType, NSURL * imageURL))completedBlock{
    if(imgView==nil){
        return ;
    }
    if(![NDataUtil isImgUrl:url]){
        return ;
    }
    
    if (img.length>0) {
        [imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[GColorUtil imageNamed:img] completed:completedBlock];
    }else{
        [imgView sd_setImageWithURL:[NSURL URLWithString:url]  completed:completedBlock];
    }
}

+ (void)imageBtnWithUrl:(UIImageView *)imgView url:(NSString *)url{
    [self imageBtnWithUrl:imgView url:url placeholder:nil];
}

+ (void)imageBtnWithUrl:(UIImageView *)imgView url:(NSString *)url placeholder:(NSString *)img {
    [self imageBtnWithUrl:imgView url:url placeholder:img completedBlock:nil];
}

+ (void)imageBtnWithUrl:(UIButton *)button url:(NSString *)url placeholder:(NSString *)img completedBlock:(void(^)(UIImage * image, NSError * error, NSInteger cacheType, NSURL * imageURL))completedBlock{
    if(button==nil){
        return ;
    }
    if(![NDataUtil isImgUrl:url]){
        return ;
    }
    if (img.length>0) {
        [button sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[GColorUtil imageNamed:img] completed:completedBlock];
    }else{
        [button sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal completed:completedBlock];
    }
}

#pragma mark 二维码

/**
 *  读取图片中二维码信息
 *
 *  @param image 图片
 *
 *  @return 二维码内容
 */
+(NSString *)readQRCodeFromImage:(UIImage *)image{
    NSData *data = UIImagePNGRepresentation(image);
    CIImage *ciimage = [CIImage imageWithData:data];
    if (ciimage) {
        CIDetector *qrDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:[CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer:@(YES)}] options:@{CIDetectorAccuracy : CIDetectorAccuracyHigh}];
        NSArray *resultArr = [qrDetector featuresInImage:ciimage];
        if (resultArr.count >0) {
            CIFeature *feature = resultArr[0];
            CIQRCodeFeature *qrFeature = (CIQRCodeFeature *)feature;
            NSString *result = qrFeature.messageString;
            
            return result;
        }else{
            return nil;
        }
    }else{
        return nil;
    }
}

/**
 *  生成二维码图片
 *
 *  @param QRString  二维码内容
 *  @param sizeWidth 图片size（正方形）
 *  @param color     填充色
 *
 *  @return  二维码图片
 */
+(UIImage *)createQRimageString:(NSString *)QRString sizeWidth:(CGFloat)sizeWidth fillColor:(UIColor *)color{
    CIImage *ciimage = [self createQRForString:QRString];
    UIImage *qrcode = [self createNonInterpolatedUIImageFormCIImage:ciimage withSize:sizeWidth];
    if (color) {
        CGFloat R, G, B;
        
        CGColorRef colorRef = [color CGColor];
        const CGFloat *components = CGColorGetComponents(colorRef);
        R = components[0];
        G = components[1];
        B = components[2];
        
        UIImage *customQrcode = [self imageBlackToTransparent:qrcode withRed:R andGreen:G andBlue:B];
        return customQrcode;
    }
    
    return qrcode;
}


+ (CIImage *)createQRForString:(NSString *)qrString {
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // Create the filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // Send the image back
    return qrFilter.outputImage;
}

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // create a bitmap image that we'll draw into a bitmap context at the desired size;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // Create an image with the contents of our bitmap
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);
}
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    // create context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // traverse pixe
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            // change color
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // context to image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // release
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}

//MARK: - NSDecimalNumber 计算
+ (NSString *)decimalAdd:(NSString *)num1 num:(NSString *)num2{
    
    num1 = [NDataUtil stringWith:num1];
    num2 = [NDataUtil stringWith:num2];
    if (num1.length<=0||[NDataUtil IsInfOrNan:num1.floatValue]) {
        num1=@"0";
    }
    if (num2.length<=0||[NDataUtil IsInfOrNan:num2.floatValue]) {
        num2=@"0";
    }
    NSString *result = @"0";
    @try {
        result = [[NSDecimalNumber decimalNumberWithString:num1] decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:num2]].stringValue;
    } @catch (NSException *exception) {
        [GLog stackLog:exception];
    } @finally {
        return result;
    }
}

+ (NSString *)decimalSubtract:(NSString *)num1 num:(NSString *)num2{
    num1 = [NDataUtil stringWith:num1];
    num2 = [NDataUtil stringWith:num2];
    if (num1.length<=0) {
        num1 = @"0";
    }
    if (num2.length<=0) {
        num2 = @"0";
    }
    if ([NDataUtil IsInfOrNan:num1.floatValue]||[NDataUtil IsInfOrNan:num2.floatValue]) {
        return @"0";
    }
    NSString *result = @"0";
    @try {
        result = [[NSDecimalNumber decimalNumberWithString:num1] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:num2]].stringValue;
    } @catch (NSException *exception) {
        [GLog stackLog:exception];
    } @finally {
        return result;
    }
}

+ (NSString *)decimalMultiply:(NSString *)num1 num:(NSString *)num2{
    num1 = [NDataUtil stringWith:num1];
    num2 = [NDataUtil stringWith:num2];
    if (num1.length<=0||num2.length<=0||[NDataUtil IsInfOrNan:num1.floatValue]||[NDataUtil IsInfOrNan:num2.floatValue]) {
        return @"0";
    }
    NSString *result = @"0";
    @try {
        result = [[NSDecimalNumber decimalNumberWithString:num1] decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString:num2]].stringValue;
    } @catch (NSException *exception) {
        [GLog stackLog:exception];
    } @finally {
        return result;
    }
}

+ (NSString *)decimalDivide:(NSString *)num1 num:(NSString *)num2{
    num1 = [NDataUtil stringWith:num1];
    num2 = [NDataUtil stringWith:num2];
    if (num1.length<=0||num2.length<=0||[NDataUtil IsInfOrNan:num2.floatValue]||[NDataUtil IsInfOrNan:num1.floatValue]||num2.floatValue==0) {
        return @"0";
    }
    NSString *result = @"0";
    @try {
        result = [[NSDecimalNumber decimalNumberWithString:num1] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:num2]].stringValue;
    } @catch (NSException *exception) {
        [GLog stackLog:exception];
    } @finally {
        return result;
    }
    
}

///返回的是带%的百分数
+ (NSString *)decimalPercentDivide:(NSString *)num1 num:(NSString *)num2{
    num1 = [NDataUtil stringWith:num1];
    num2 = [NDataUtil stringWith:num2];
    if (num1.length<=0||num2.length<=0||[NDataUtil IsInfOrNan:num2.floatValue]||[NDataUtil IsInfOrNan:num1.floatValue]||num2.floatValue==0) {
        return @"0";
    }
    NSDecimalNumber *dec = [[NSDecimalNumber decimalNumberWithString:num1] decimalNumberByDividingBy:[NSDecimalNumber decimalNumberWithString:num2]];
    dec = [dec decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithDecimal:@(100).decimalValue]];
    return [NSString stringWithFormat:@"%.2f%%",dec.stringValue.floatValue];
}


+ (NSString *)notRoundingDownString:(NSString *)price afterPoint:(NSInteger)dotNum
{
    if (price.length<=0||[NDataUtil IsInfOrNan:price.floatValue]) {
        return @"";
    }
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:dotNum raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *roundedOunces = [[NSDecimalNumber decimalNumberWithString:price] decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString *string = roundedOunces.stringValue;
    if (dotNum<=0) {
        NSInteger p = string.integerValue;
        return [NSString stringWithFormat:@"%ld",(long)p];
    }
    NSArray *tem = [string componentsSeparatedByString:@"."];
    NSString *place = @"";
    if (tem.count==2) {
        place = [tem lastObject];
    }
    while (place.length<dotNum) {
        place = [place stringByAppendingString:@"0"];
    }
    string = [NSString stringWithFormat:@"%@.%@",[tem firstObject],place];
    return string;
}


+ (NSString *)notRoundingString:(NSString *)price afterPoint:(NSInteger)dotNum
{
    if (price.length<=0||[NDataUtil IsInfOrNan:price.floatValue]) {
        return @"";
    }
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:dotNum raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *roundedOunces = [[NSDecimalNumber decimalNumberWithString:price] decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString *string = roundedOunces.stringValue;
    if (dotNum<=0) {
        NSInteger p = string.integerValue;
        return [NSString stringWithFormat:@"%ld",(long)p];
    }
    NSArray *tem = [string componentsSeparatedByString:@"."];
    NSString *place = @"";
    if (tem.count==2) {
        place = [tem lastObject];
    }
    while (place.length<dotNum) {
        place = [place stringByAppendingString:@"0"];
    }
    string = [NSString stringWithFormat:@"%@.%@",[tem firstObject],place];
    return string;
}

+ (NSString *)notRounding:(NSDecimalNumber *)price afterPoint:(NSInteger)dotNum
{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundBankers scale:dotNum raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *roundedOunces = [price decimalNumberByRoundingAccordingToBehavior:roundingBehavior];
    NSString *string = roundedOunces.stringValue;
    if (dotNum==0) {
        string = [NSString stringWithFormat:@"%ld",(long)string.integerValue];
    }else{
        NSArray *tem = [string componentsSeparatedByString:@"."];
        NSString *place = @"";
        if (tem.count==2) {
            place = [tem lastObject];
        }
        while (place.length<dotNum) {
            place = [place stringByAppendingString:@"0"];
        }
        string = [NSString stringWithFormat:@"%@.%@",[tem firstObject],place];
    }
    return string;
}

+ (NSComparisonResult)compareFloat:(NSString *)num1 with:(NSString *)num2{
    NSString *result = [GUIUtil decimalSubtract:num1 num:num2];
    CGFloat esp = 1e-10;
    if (ABS(result.floatValue)<=esp) {
        return NSOrderedSame;
    }else if([result hasPrefix:@"-"]){
        return NSOrderedAscending;
    }else{
        return NSOrderedDescending;
    }
}

+ (BOOL)equalValue:(NSString *)num1 with:(NSString *)num2{
    num1 = [NDataUtil stringWith:num1];
    num2 = [NDataUtil stringWith:num2];
    if (num1.length<=0||num2.length<=0||[NDataUtil IsInfOrNan:num1.floatValue]||[NDataUtil IsInfOrNan:num2.floatValue]) {
        return NO;
    }
    NSString *num = [[NSDecimalNumber decimalNumberWithString:num1] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:num2]].stringValue;
    return [self compareFloat:num with:@"0"]==NSOrderedSame;
}

+ (NSString *)formatter:(NSInteger)dotnum{
    NSString *format = @".2f";
    switch (dotnum) {
        case 0:
            format = @"%ld";
            break;
        case 1:
            format = @"%.1f";
            break;
        case 2:
            format = @"%.2f";
            break;
        case 3:
            format = @"%.3f";
            break;
        case 4:
            format = @"%.4f";
            break;
        case 5:
            format = @"%.5f";
            break;
        case 6:
            format = @"%.6f";
            break;
        case 7:
            format = @"%.7f";
            break;
        case 8:
            format = @"%.8f";
            break;
        default:
            break;
    }
    return format;
}

+ (long double)formatterAdd:(NSInteger)dotnum{
    long double format = 0.005;
    switch (dotnum) {
        case 0:
            format = 0.5;;
            break;
        case 1:
            format = 0.05;
            break;
        case 2:
            format = 0.005;
            break;
        case 3:
            format = 0.0005;
            break;
        case 4:
            format = 0.00005;
            break;
        case 5:
            format = 0.000005;
            break;
        case 6:
            format = 0.0000005;
            break;
        case 7:
            format = 0.00000005;
            break;
        case 8:
            format = 0.000000005;
            break;
        default:
            break;
    }
    return format;
}

//MARK: -  Others
// 获得行高
+ (NSInteger) linesWith:(UILabel *) label
{
    [label layoutIfNeeded];
    CGFloat width=label.frame.size.width;
    CGFloat labelHeight = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)].height+FIXED_HEIGHT;
    CGFloat lh=label.font.lineHeight;
    NSInteger count =floor(labelHeight/lh);
    return count;
}
// 获得行高
+ (NSInteger) linesWith:(UILabel *) label width:(CGFloat) width
{
    CGFloat labelHeight = [label sizeThatFits:CGSizeMake(width, MAXFLOAT)].height+FIXED_HEIGHT;
    CGFloat lh=label.font.lineHeight;
    NSInteger count =floor(labelHeight/lh);
    return count;
}
// 调整行间距
+ (void) adjustLineSpace:(UILabel *) label
               lineSpace:(CGFloat) lineSpace
{
    [label layoutIfNeeded];
    CGFloat width=label.frame.size.width;
    NSInteger lines=[GUIUtil linesWith:label width:width];
    // 只有1行不调整行间距
    if(lines<2){
        return;
    }
    NSString *text = label.text;
    NSRange range=NSMakeRange(0,text.length);
    NSMutableAttributedString *attributedString;
    if(label.attributedText){
        attributedString=[[NSMutableAttributedString alloc] initWithAttributedString:label.attributedText];
    }else{
        attributedString= [[NSMutableAttributedString alloc] initWithString:text];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    label.attributedText = attributedString;
    [label sizeToFit];
}
// 调整行间距
+ (void) adjustLineSpace:(UILabel *) label
                   width:(CGFloat) width
               lineSpace:(CGFloat) lineSpace
{
    NSInteger lines=[GUIUtil linesWith:label width:width];
    // 只有1行不调整行间距
    if(lines<2){
        return;
    }
    NSString *text = label.text;
    NSRange range=NSMakeRange(0,text.length);
    NSMutableAttributedString *attributedString;
    if(label.attributedText){
        attributedString=[[NSMutableAttributedString alloc] initWithAttributedString:label.attributedText];
    }else{
        attributedString= [[NSMutableAttributedString alloc] initWithString:text];
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:range];
    label.attributedText = attributedString;
    [label sizeToFit];
}

// 替换指定属性文本的字体
+(NSMutableAttributedString *) replaceAttributed:(NSMutableAttributedString *) att
                                             key:(NSString *) key
                                           value:(NSString *) value
                                            font:(UIFont *)font
{
    NSRange range=[att.string rangeOfString:key];
    if(range.location==NSNotFound){
        return att;
    }
    [att replaceCharactersInRange:range withString:value];
    range.length=value.length;
    [att addAttribute:NSFontAttributeName value:font range:range];
    return att;
}

// 设置锁屏
+(void) lockScreen:(BOOL) isLock
{
    // 禁用休闲时钟
    [[UIApplication sharedApplication] setIdleTimerDisabled:isLock];
}

+ (NSString *)webTips{
    return CFDLocalizedString(@"网络错误");
}

@end

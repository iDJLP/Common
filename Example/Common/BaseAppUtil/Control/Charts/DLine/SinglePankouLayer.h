//
//  SinglePankouView.h
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SinglePankouDegreeType) {
    SinglePankouDegreeTypeLeft,
    SinglePankouDegreeTypeRight,
} NS_ENUM_AVAILABLE_IOS(7_0);

typedef NS_ENUM(NSInteger, SinglePankouPriceType) {
    SinglePankouPriceTypeLeft,
    SinglePankouPriceTypeRight,
} NS_ENUM_AVAILABLE_IOS(7_0);

@interface SinglePankouLayer : CALayer

@property (nonatomic,assign)SinglePankouDegreeType degreeType;
@property (nonatomic,assign)SinglePankouDegreeType priceType;
@property (nonatomic,assign)ColorType bgColor;

- (void)configData:(NSDictionary *)data maxVol:(NSString *)maxVol;
- (void)setVolColor:(UIColor *)volColor;
- (void)setPriceColor:(UIColor *)priceColor;
- (void)setFontSize:(CGFloat)fontSize;
- (void)setDegreeBG:(UIColor *)color;
- (void)setSNText:(NSString *)snText;
- (void)showSN:(BOOL)flag;
@end

NS_ASSUME_NONNULL_END

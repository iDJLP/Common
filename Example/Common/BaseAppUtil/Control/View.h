//
//  View.h
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, SingleInfoAlignment) {
    SingleInfoAlignmentLeft,   //key,value 靠左对齐，padding为key,value间距
    SingleInfoAlignmentLeftPadding, //key,value 靠左对齐，leftPadding为value的left
    SingleInfoAlignmentRight,  //key,value 靠右对齐，padding为key,value间距
    SingleInfoAlignmentCenter, //key,value 居中对齐
    SingleInfoAlignmentSide,  //key,value 左右两边对齐
};

@interface SingleInfoView : UIView

@property (nonatomic , assign)SingleInfoAlignment alignment;
@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) CGFloat leftPadding;
@property (nonatomic,assign)BOOL needChangedStyle;
- (void)configOfInfo:(NSDictionary *)info;
- (void)setKeyFont:(UIFont *)font;
- (void)setValueFont:(UIFont *)font;
- (void)setKeyColor:(ColorType )colorType;
- (void)setKeyAlpha:(CGFloat )alpha;
- (void)setValueColor:(ColorType)color;
- (void)setKeyTheme:(BOOL)isChanged;
- (void)setValueTheme:(BOOL)isChanged;
@end

@interface SingleInputView:UIView

@property (nonatomic,copy)dispatch_block_t inputChangedHander;
- (void)setTitle:(NSString *)title;
- (void)setPlaceholder:(NSString *)placeholder;
- (NSString *)inputText;

@end

NS_ASSUME_NONNULL_END

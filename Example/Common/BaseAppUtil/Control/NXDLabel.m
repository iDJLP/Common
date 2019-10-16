//
//  NXDLabel.m
//  niuguwang
//
//  Created by ngw15 on 16/11/16.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "NXDLabel.h"

@interface NXDLabel ()

@property (nonatomic,strong)NSMutableDictionary *heightDic;
@property (nonatomic,assign)CGSize size;

@end

@implementation NXDLabel

+ (CGFloat)heightOfData:(NSMutableAttributedString *)attText width:(CGFloat)width{
    if (![attText isKindOfClass:[NSMutableAttributedString class]]) {
        return 0;
    }
    [attText enumerateAttributesInRange:NSMakeRange(0, attText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        if (!attrs[NSFontAttributeName]) {
            [attText addAttribute:NSFontAttributeName value:[GUIUtil fitFont:14] range:range];
        }
    }];
    // 创建文本容器
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    container.maximumNumberOfRows = 0;
    
    // 生成排版结果
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attText];
    CGSize size = layout.textBoundingSize;
    return size.height+5;
}

- (instancetype) initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]){
        _heightDic = [NSMutableDictionary dictionary];
        [self setupUserInterction];
        _lineSpace = 3;
    }
    return self;
}

- (void)setupUserInterction{
    [self addSubview:self.label];
}

//size 是YYLayout计算出来的
- (void)layout:(CGSize )size{
    
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_greaterThanOrEqualTo(size.width).priorityHigh();
        make.height.mas_equalTo(size.height+5);
    }];
    [_label mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo(size.width);
        make.height.mas_equalTo(size.height);
    }];
}

- (CGSize)size{
    return _size;
}

#pragma setter

+ (NSMutableAttributedString *)parseHTMLData:(NSString *)data{
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithData:[data dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType} documentAttributes:nil error:nil];
    
    [attributedString enumerateAttributesInRange:NSMakeRange(0, attributedString.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSAttributedStringKey,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        NSString *str = [attrs[@"NSLink"] absoluteString];
        NSArray *action = [str componentsSeparatedByString:@":"];
        if (action.count>2) {
            NSString *method = [NDataUtil dataWithArray:action index:0];
            NSString *param = [NDataUtil dataWithArray:action index:1];
            UIColor *color = attrs[NSForegroundColorAttributeName];
            [attributedString setTextHighlightRange:range color:color backgroundColor:[UIColor clearColor] tapAction:^(UIView * _Nonnull containerView, NSAttributedString * _Nonnull text, NSRange range, CGRect rect) {
                [NXDLabel actionMethod:method param:param];
            }];
        }
        UIFont *font = attrs[NSFontAttributeName];
        [attributedString addAttribute:NSFontAttributeName value:[GUIUtil fitBoldFont:font.pointSize] range:range];
    }];
    attributedString.lineSpacing = [GUIUtil fit:5];
    return attributedString;
}

+ (void)actionMethod:(NSString *)method param:(NSString *)param{
    NSLog(@"method:%@,param:%@",method,param);
}

- (void)setData:(id)data{
    NSMutableAttributedString *mutableAttStr;
    if ([data isKindOfClass:[NSString class]]) {
        mutableAttStr = [[NSMutableAttributedString alloc] initWithString:data attributes:@{NSFontAttributeName:_label.font,NSForegroundColorAttributeName:_label.textColor}];
        mutableAttStr.alignment = NSTextAlignmentCenter;
        mutableAttStr.lineSpacing = _lineSpace;
        [self displayAsync:self.label attributeText:mutableAttStr];
    }
    
    else if ([data isKindOfClass:[NSAttributedString class]]){
        NSMutableAttributedString *mutableAttStr = [data mutableCopy];
        mutableAttStr.lineSpacing = _lineSpace;
        [self setAttText:mutableAttStr];
    }
    
}

- (void)setAttText:(NSMutableAttributedString *)attText{
    if (![attText isKindOfClass:[NSMutableAttributedString class]]) {
        return;
    }
    [attText enumerateAttributesInRange:NSMakeRange(0, attText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
        if (!attrs[NSFontAttributeName]) {
            [attText addAttribute:NSFontAttributeName value:_label.font range:range];
        }
        if (!attrs[NSForegroundColorAttributeName]) {
            [attText addAttribute:NSForegroundColorAttributeName value:_label.textColor range:range];
        }
        if ([attrs[@"TextAddBold"] boolValue]) {
            [attText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:_label.font.pointSize] range:range];
        }
    }];
    [self displayAsync:self.label attributeText:attText];
}

- (void)asyncSetAttText:(NSMutableAttributedString *)attText{
    if (![attText isKindOfClass:[NSMutableAttributedString class]]) {
        return;
    }
    WEAK_SELF;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [attText enumerateAttributesInRange:NSMakeRange(0, attText.length) options:NSAttributedStringEnumerationReverse usingBlock:^(NSDictionary<NSString *,id> * _Nonnull attrs, NSRange range, BOOL * _Nonnull stop) {
            if (!attrs[NSFontAttributeName]) {
                [attText addAttribute:NSFontAttributeName value:_label.font range:range];
            }
            if (!attrs[NSForegroundColorAttributeName]) {
                [attText addAttribute:NSForegroundColorAttributeName value:weakSelf.label.textColor range:range];
            }
            if (attrs[@"TextAddBold"]) {
                [attText addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:_label.font.pointSize] range:range];
            }
        }];
        YYTextLayout *layout = [NXDLabel creatTextLayout:attText width:self.label.preferredMaxLayoutWidth];
        CGSize size = layout.textBoundingSize;
        if (size.width>weakSelf.label.preferredMaxLayoutWidth) {
            size.width = weakSelf.label.preferredMaxLayoutWidth;
        }
        weakSelf.size = size;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf layout:size];
            weakSelf.label.textLayout = layout;
        });
    });
    
}

#pragma mark - 排版

- (void)displayAsync:(YYLabel *)label attributeText:(NSMutableAttributedString *)attributedText{
    
    YYTextLayout *layout = [NXDLabel creatTextLayout:attributedText width:self.label.preferredMaxLayoutWidth];
    CGSize size = layout.textBoundingSize;
    //[_heightDic setObject:[NSNumber valueWithCGSize:size] forKey:attributedText.string];
    if (size.width>_label.preferredMaxLayoutWidth||layout.lines.count>1) {
        size.width = _label.preferredMaxLayoutWidth;
    }
    _size = size;
    [self layout:size];
    label.textLayout = layout;
    // }
}

+ (YYTextLayout *)creatTextLayout:(NSMutableAttributedString *)attributedText width:(CGFloat)width{
    // 创建文本容器
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(width, CGFLOAT_MAX);
    container.maximumNumberOfRows = 0;
    
    // 生成排版结果
    YYTextLayout *layout = [YYTextLayout layoutWithContainer:container text:attributedText.copy];
    return layout;
}

#pragma mark - getter

- (YYLabel *)label{
    if (!_label) {
        _label = [[YYLabel alloc] init];
        _label.displaysAsynchronously = NO;
        _label.ignoreCommonProperties = YES;
    }
    return _label;
}

#pragma makr - 私有方法

+ (NSString *)exchangedEmoji:(NSString *)content{
//    //获取得到的表情进行替换
//    for (int i=0; i< [AppModel.faceImgNames count]; i++) {
//        content = [content stringByReplacingOccurrencesOfString:[AppModel.faceImgNames objectAtIndexSafe:i] withString:[AppModel.emojiFaceImgNames objectAtIndexSafe:i]];
//    }
    return content;
}

@end

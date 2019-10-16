//
//  NXDLabel.h
//  niuguwang
//
//  Created by ngw15 on 16/11/16.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface NXDLabel : UIView

@property (nonatomic,copy) YYLabel *label;
@property (nonatomic,assign) CGFloat lineSpace;

+ (NSString *)exchangedEmoji:(NSString *)content;

+ (CGFloat)heightOfData:(NSMutableAttributedString *)attText width:(CGFloat)width;

- (void)setAttText:(NSMutableAttributedString *)attText;

- (void)asyncSetAttText:(NSMutableAttributedString *)attText;

- (void)setData:(id)data;

- (CGSize)size;

+ (NSMutableAttributedString *)parseHTMLData:(NSString *)data;

@end

//
//  
//  NWinBoom
//
//  Created by ngw15 on 2018/9/13.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface CFDCountView : UIView

@property (nonatomic , copy) void(^setCountBlock)(NSString *count);
@property (nonatomic,copy) void (^unflodHander)(BOOL flag) ;

- (id)initWithTinColor:(UIColor *)tinColor;
- (void)updateData:(NSArray *)array withCloseList:(NSArray *)closeList;
- (NSString *)countText;
- (void)unflodAction:(BOOL)flag;
- (void)updateDefault;
- (void)disableActivity;
- (void)enableActivity;
@end



@interface StopSetter:UIView

@property (nonatomic,assign)NSInteger dotnum;
@property (nonatomic,assign)NSString *price;
@property (nonatomic,assign)NSString *perProfit;
@property (nonatomic,assign)CGFloat maxLosses;
@property (nonatomic,assign)CGFloat maxProfit;

@property (nonatomic,assign)CGFloat defaultProfitRatio;
@property (nonatomic,assign)CGFloat defaultLossesRatio;

- (NSString *)stopLosses;
- (NSString *)takeProfit;
- (BOOL)hasChanged;

- (void)disableActivity;
- (void)enableActivity;
@end



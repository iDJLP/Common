//
//  CFDMLineView.h
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFDDLineView : UIView

///小数点位数
@property(nonatomic,assign)NSInteger nDotNum;

- (BOOL)isFocusing;

- (void)configData:(NSDictionary *)dic;


- (void)clear;


@end

NS_ASSUME_NONNULL_END

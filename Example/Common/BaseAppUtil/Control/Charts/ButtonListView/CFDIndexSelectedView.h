//
//  CFDIndexSelectedView.h
//  Chart
//
//  Created by ngw15 on 2019/3/15.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFDIndexSelectedView : UIView

@property (nonatomic,strong) NSMutableDictionary *config;
- (instancetype)initWithTitles:(NSArray <NSArray *>*)titles frame:(CGRect)frame;
@property(nonatomic,copy)void(^selectedIndexHander)(NSMutableDictionary *dic);

@end

NS_ASSUME_NONNULL_END

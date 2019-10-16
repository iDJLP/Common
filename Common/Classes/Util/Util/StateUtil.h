//
//  FCStateUtil.h
//  newfcox
//
//  Created by ngw15 on 2018/4/28.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTimeUtil.h"
#import "BaseView.h"
#import "BaseLabel.h"
#import "BaseImageView.h"

typedef NS_ENUM(NSInteger, StateType) {
    StateTypeNodata,
    StateTypeProgress,
    StateTypeReload,
    StateTypeChildReload,
};

@interface StateView : BaseView

@property(nonatomic,assign) StateType type;
- (void)updateTheme:(BOOL)isWhiteTheme;
@end

@interface NoDataStateView:StateView

@property(nonatomic,strong) BaseImageView *icon;
@property(nonatomic,strong) BaseLabel *title;

@end

@interface ProgressStateView:StateView

@property(nonatomic,strong) UIView *alertView;
@property(nonatomic,strong) UIActivityIndicatorView *indicator;
@property(nonatomic,strong) BaseLabel *title;
@property (nonatomic,copy) BKCancellationToken task;

@end

@interface ReloadStateView:StateView

@property(nonatomic,strong) BaseImageView *icon;
@property(nonatomic,strong) BaseLabel *title;
@property(nonatomic,copy) dispatch_block_t onReload;

@end

@interface ReloadChildStateView:StateView

@property(nonatomic,strong) BaseImageView *icon;
@property(nonatomic,strong) BaseLabel *title;
@property(nonatomic,copy) dispatch_block_t onReload;

@end

@interface StateUtil : NSObject

+ (StateView *) show:(UIView *) target type:(StateType) type;
+ (void) hide:(UIView *) target;

@end


//
//  TradeHeaderView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TradeHeaderView : BaseView
@property (nonatomic,strong)NSDictionary *config;

@property (nonatomic,copy) dispatch_block_t tapHander;
@property (nonatomic,copy) void (^rightHander) (NSString *symbol) ;
@property (nonatomic,copy) void (^right1Hander) (NSString *symbol) ;

+ (CGFloat)heightOfView;

- (void)configView:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END

//
//  TradeSelectedChoiceView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/10/12.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChoiceView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TradeSelectedChoiceView : BaseView

@property (nonatomic,strong)void(^loadDataHander)(NSDictionary *params);

- (void)willAppear:(NSDictionary *)parmas;

@end

NS_ASSUME_NONNULL_END

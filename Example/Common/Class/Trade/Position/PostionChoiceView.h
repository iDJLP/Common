//
//  PostionChoiceView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/8/6.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseView.h"
#import "ChoiceView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PostionChoiceView : BaseView

@property (nonatomic,strong)void(^loadDataHander)(NSString *params);

- (void)willAppear:(NSString *)params isEntrust:(BOOL)isEntrust;

@end

NS_ASSUME_NONNULL_END

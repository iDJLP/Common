//
//  ChoiceTransferView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/8/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseView.h"
#import "ChoiceView.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChoiceTransferView : BaseView


@property (nonatomic,strong)void(^loadDataHander)(NSString *params);

- (void)willAppear:(NSString *)parmas;

@end

NS_ASSUME_NONNULL_END

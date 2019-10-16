//
//  OtcTradeView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/4/25.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OtcTradeView : UIView

@property (nonatomic,copy) dispatch_block_t refreshData;

- (void)configView:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END

//
//  OTCDrawlView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/28.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTCDrawlView : UIScrollView

@property (nonatomic,copy)NSString *type;

- (void)hidenKeyboard;
- (void)configVC:(NSDictionary *)config;
- (void)willAppear;
- (void)refreshData;

@end

NS_ASSUME_NONNULL_END

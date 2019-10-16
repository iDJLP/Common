//
//  DCChargedView.h
//  ngw
//
//  Created by ngw15 on 2018/12/13.
//  Copyright © 2018 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OTCDepositView : UIScrollView

@property (nonatomic,assign) BOOL isLoaded;
@property (nonatomic,copy)NSString *type;

- (void)hidenKeyboard;
- (void)startTimer;
- (void)configVC:(NSDictionary *)config;
- (void)willAppear;
- (void)loadTradeOrder;
- (void)loadData;
@end

NS_ASSUME_NONNULL_END

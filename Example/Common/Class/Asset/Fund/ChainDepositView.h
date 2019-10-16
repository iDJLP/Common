//
//  DCOtherChargedView.h
//  niuguwang
//
//  Created by ngw15 on 2018/12/13.
//  Copyright © 2018 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChainDepositView : UIScrollView

@property (nonatomic,copy) NSString *payId;
@property (nonatomic,assign) BOOL isLoaded;
@property (nonatomic,copy)NSString *type;
- (void)loadData;
- (void)loadTradeOrder;

@end

NS_ASSUME_NONNULL_END

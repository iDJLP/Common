//
//  OrderView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN


@interface OrderView : BaseView

@property (nonatomic,copy) void(^updateHeaderViewHander)(OrderModel *model) ;
@property (nonatomic,copy) dispatch_block_t reloadPosHander;
@property (nonatomic,copy) dispatch_block_t reloadEntrustHander;


+ (CGSize)sizeOfView;

- (instancetype)initWithSymbol:(NSString *)symbol;
- (void)willAppear;

- (void)changeTradeType:(BOOL)isBuy;
- (void)changedSymbol:(NSString *)symbol;
- (void)changedPrice:(NSDictionary *)dic;

- (BOOL)isFirstRespond;
- (void)refreshData:(dispatch_block_t)endRefreshHander;

@end

NS_ASSUME_NONNULL_END

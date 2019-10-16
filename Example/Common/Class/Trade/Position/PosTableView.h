//
//  PosTableView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "TableView.h"
#import "LockerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface PosTableView : TableView

@property (nonatomic,weak)id<LockerScrollProtocol> scrollDelegate;
@property (nonatomic,copy)void(^changedCount)(NSInteger count);;

- (void)willAppear;
- (BOOL)isFirstRespond;
- (void)loadData:(BOOL)isAuto;
@end

NS_ASSUME_NONNULL_END

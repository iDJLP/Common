//
//  DepthView.h
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "ScrollView.h"
#import "LockerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface DepthView : ScrollView
@property (nonatomic,weak)id<LockerScrollProtocol> scrollDelegate;

- (instancetype)initWithSymbol:(NSString *)symbol;
- (void)willAppear;
- (void)willDisAppear;
- (void)refreshData;
- (void)changedSymbol:(NSString *)symbol;

@end

NS_ASSUME_NONNULL_END

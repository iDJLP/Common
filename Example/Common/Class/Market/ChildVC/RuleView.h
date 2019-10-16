//
//  RuleView.h
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "TableView.h"
#import "LockerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface RuleView : TableView

@property (nonatomic,weak)id<LockerScrollProtocol> scrollDelegate;
- (instancetype)initWithSymbol:(NSString *)symbol isChild:(BOOL)isChild;
- (void)willAppear;
- (void)willDisAppear;
- (void)changedSymbol:(NSString *)symbol;
- (void)refreshData;
@end

NS_ASSUME_NONNULL_END

//
//  TradeMlineView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/5/9.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TradeMlineView : BaseView

- (void)updateTitle:(NSString *)title;
- (void)updateSymbol:(NSString *)symbol;
- (void)viewDisAppear;

@end

NS_ASSUME_NONNULL_END

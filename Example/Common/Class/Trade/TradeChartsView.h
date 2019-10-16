//
//  TradeChartsView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/5/10.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "BaseView.h"
#import "MLineChartView.h"

NS_ASSUME_NONNULL_BEGIN

@interface TradeChartsView : BaseView

///休市状态
@property (nonatomic,assign) BOOL isClose;

@property (nonatomic,strong) MLineChartView  *mLineView;

@property (nonatomic,assign) CGFloat hsRight;

- (void)willAppear;
- (void)willDisappear;
- (void)changedSymbol:(NSString *)symbol;

@end

NS_ASSUME_NONNULL_END

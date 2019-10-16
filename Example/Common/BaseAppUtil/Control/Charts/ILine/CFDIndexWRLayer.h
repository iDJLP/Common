//
//  CFDIndexWRLayer.h
//  Chart
//
//  Created by ngw15 on 2019/2/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFDIndexWRLayer : CALayer
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,copy) void (^bottomAxisHander)(NSDictionary *dic);
@property (nonatomic,copy) CGFloat(^pointWidth)(void);
- (void)drawIndexWR:(NSArray <CFDKLineData *>*)dataList;
@end

NS_ASSUME_NONNULL_END

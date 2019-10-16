//
//  CFDIndexCCILayer.h
//  Chart
//
//  Created by ngw15 on 2019/2/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CFDIndexCCILayer : CALayer

@property (nonatomic,assign) CGFloat height;
@property (nonatomic,copy) void (^bottomAxisHander)(NSDictionary *dic);
@property (nonatomic,copy) CGFloat(^pointWidth)(void);
- (void)drawIndexCCI:(NSArray <CFDKLineData *>*)dataList;
@end

NS_ASSUME_NONNULL_END

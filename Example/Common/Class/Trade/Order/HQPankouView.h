//
//  HQPankouView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HQPankouView : BaseView

+ (CGSize)sizeOfView;

///askPrice,bidPrice
@property (nonatomic,copy)void(^changedPriceHander)(NSDictionary *dic);
- (instancetype)initWithSymbol:(NSString *)symbol height:(CGFloat)height;
- (void)willAppear;
- (void)willDisappear;
- (void)refreshData;
- (void)changedSymbol:(NSString *)symbol;

@end

NS_ASSUME_NONNULL_END

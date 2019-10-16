//
//  DGirlLayer.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/30.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface DGirlLayer : CALayer

- (void)configViewWithMinPrice:(NSString *)minPrice maxPrice:(NSString *)maxPrice centerPrice:(NSString *)centerPrice maxVol:(NSString *)maxVol;

@end

NS_ASSUME_NONNULL_END

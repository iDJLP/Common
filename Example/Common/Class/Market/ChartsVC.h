//
//  ChartsVC.h
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "NBaseVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface ChartsVC : NBaseVC

+ (void)jumpTo:(NSString *)symbol;
@property (nonatomic,assign) BOOL isLS;
@end

NS_ASSUME_NONNULL_END

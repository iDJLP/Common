//
//  Pankou5View.h
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface Pankou5View : BaseView

@property (nonatomic,assign) CGFloat singleHeight;

- (instancetype)initWithSingle:(CGFloat)singleHeight;
- (void)configData:(NSArray *)data maxVol:(NSString *)maxVol;

@end

NS_ASSUME_NONNULL_END

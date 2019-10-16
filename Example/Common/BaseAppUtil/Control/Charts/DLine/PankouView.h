//
//  PankouView.h
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PankouView : UIView

@property (nonatomic,assign) CGFloat singleHeight;

- (void)configData:(NSArray *)data maxVol:(NSString *)maxVol;

@end

NS_ASSUME_NONNULL_END

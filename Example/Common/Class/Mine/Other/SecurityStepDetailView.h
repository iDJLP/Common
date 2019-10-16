//
//  SecurityStepDetailView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/5/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SecurityStepDetailView : UIView

@property (nonatomic,strong)void(^stepChangedHander)(NSInteger stepIndex);

@end

NS_ASSUME_NONNULL_END

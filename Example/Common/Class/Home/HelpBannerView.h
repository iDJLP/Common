//
//  HelpBannerView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/27.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"

NS_ASSUME_NONNULL_BEGIN

@interface HelpBannerView : BaseView

+ (CGFloat)heightOfView:(NSInteger)count;
@property (nonatomic,copy) void(^selectedRow)(NSDictionary *model);
@property (nonatomic,assign) NSInteger count;
- (void)configOfView:(NSArray *)list;
@end

NS_ASSUME_NONNULL_END

//
//  BaseImageView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/4/30.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseImageView : UIImageView

@property (nonatomic,copy)NSString *imageName;
@property (nonatomic,copy)NSString *highlightedImageName;
@property (nonatomic,assign)ColorType bgColor;

@end

NS_ASSUME_NONNULL_END

//
//  Button.h
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseBtn.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, CFDSelectedLineType) {
    CFDSelectedLineTypeWidth,
    CFDSelectedLineTypeWidthLeft,
    CFDSelectedLineTypeEqualTitle,
};

@interface CFDSelectedBtn : BaseBtn

@property (nonatomic,assign) CFDSelectedLineType lineType;
@property (nonatomic,assign) UIColor *lineColor;
@property (nonatomic,strong) UIFont *norFont;
@property (nonatomic,strong) UIFont *selFont;

@end

NS_ASSUME_NONNULL_END

//
//  DCursorView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/30.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DCursorView : UIView

@property (nonatomic,copy) void (^axisCursorHander)(NSString *cursorPrice,BOOL isLast);

@property(atomic,strong)NSArray *posotionList;

- (BOOL)isShowFocus;

@end

NS_ASSUME_NONNULL_END

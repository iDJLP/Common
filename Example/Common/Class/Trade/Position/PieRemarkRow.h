//
//  PieRemarkView.h
//  Bitmixs
//
//  Created by ngw15 on 2019/9/29.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

NS_ASSUME_NONNULL_BEGIN

@interface PieRemarkRow : CALayer
@property (nonatomic,assign) CGPoint centerPoint;
@property (nonatomic,assign) CGFloat outerRadio;

- (void)configOfRow:(NSDictionary *)dict;
- (void)updatePosition:(CGFloat)centerAngle;

@end

NS_ASSUME_NONNULL_END

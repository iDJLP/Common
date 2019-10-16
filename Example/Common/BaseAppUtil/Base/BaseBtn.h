//
//  BaseBtn.h
//  Bitmixs
//
//  Created by ngw15 on 2019/4/30.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseBtn : UIButton

@property (nonatomic,copy)NSString *imageName;
@property (nonatomic,copy)NSString *imageName_sel;
@property (nonatomic,copy)NSString *imageName_dis;
@property (nonatomic,copy)NSString *bgImageName;
@property (nonatomic,copy)NSString *bgImageName_sel;
@property (nonatomic,assign)ColorType bgLayerColor;
@property (nonatomic,assign)ColorType txColor;
@property (nonatomic,assign)ColorType txColor_sel;
@property (nonatomic,assign)ColorType bgColor;

@property (nonatomic,copy) NSString *(^textBlock)(void);
@end

NS_ASSUME_NONNULL_END

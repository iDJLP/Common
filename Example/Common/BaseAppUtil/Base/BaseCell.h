//
//  globalwin
//
//  Created by ngw15 on 2018/7/31.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseCell : UITableViewCell

//默认为c6
@property (nonatomic,assign)ColorType bgColorType;

//是否要按压效果
@property (nonatomic,assign)BOOL hasPressEffect;
//按压效果的颜色，默认为c8
@property (nonatomic,assign)ColorType bgSelColorType;
@end

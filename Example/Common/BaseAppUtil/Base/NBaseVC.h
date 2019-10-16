//
//  NBaseVC.h
//  niuguwang
//
//  Created by BrightLi on 2016/11/30.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

@interface NBaseVC : UIViewController

@property (nonatomic,assign) BOOL n_navBarHidden;
@property (nonatomic,assign) BOOL n_statusBarHidden;
@property (nonatomic,assign) BOOL n_isWhiteStatusBar;
@property (nonatomic,assign) BOOL n_keepWhiteStatusBar;
@property (nonatomic,assign) BOOL n_shouldEdgPanEnable;
- (void)hideLine;
- (NBaseVC *) topVC;
- (BOOL) isTopVC;
//默认为c6
@property (nonatomic,assign)ColorType bgColorType;
@end


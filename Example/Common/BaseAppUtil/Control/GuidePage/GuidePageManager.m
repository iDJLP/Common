//
//  GuidePageManager.m
//  globalwin
//
//  Created by 张洪林 on 2018/7/25.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "GuidePageManager.h"
#import "Aspects.h"
#import "GuidePageController.h"

@interface GuidePageManager ()

@property (nonatomic, strong)NSMutableArray *picStrArr;
@property (nonatomic, strong)UIWindow *window;


@end
@implementation GuidePageManager

+ (void)shareManagerWithPicArr:(NSArray *)picStrArr{
    
    static GuidePageManager *instance = nil;
    static dispatch_once_t oneToken;
    dispatch_once(&oneToken, ^{
        instance = [[GuidePageManager alloc] init];
        [instance getDelegate:picStrArr];
        [instance setupNewFeature];
    });
}


- (void)getDelegate:(NSArray *)picStrArr {
    
    _picStrArr = [NSMutableArray arrayWithArray:picStrArr];
}

- (void)setupNewFeature {
    
    if ([NLocalUtil boolForKey:[NSString stringWithFormat:@"IsNewFeature%@",APP_VERSION]]) return;
    
    UIWindow *window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    for (int i = 0; i < _picStrArr.count; i++) {
        if ([[_picStrArr objectAtIndex:i] isEqualToString:@""]) {
            [_picStrArr removeObjectAtIndex:i];
        }
    }
    if (_picStrArr.count == 0) return;
    GuidePageController *fearure = [[GuidePageController alloc] initWithArray:_picStrArr];
    fearure.view.backgroundColor = [UIColor clearColor];
    window.rootViewController = fearure;
    window.windowLevel = UIWindowLevelAlert;
    window.alpha = 1;
    window.hidden = NO;
    _window = window;
}

+ (void)stopGuideAction{
    // 记录是否已经走过新特性
    [NLocalUtil setBool:YES forKey:[NSString stringWithFormat:@"IsNewFeature%@",APP_VERSION]];
    UIWindow *window = [[UIApplication sharedApplication].windows lastObject];
    if (window == [[UIApplication sharedApplication].delegate window]) {
        return;
    }
    // 新特性Window移除
    [UIView transitionWithView:window duration:0.8 options:UIViewAnimationOptionTransitionNone animations:^{
        window.alpha = 0;
    } completion:^(BOOL finished) {
        [GuidePageManager remove:window];
    }];
}

+ (void)remove:(UIWindow *)window {
    window.hidden = YES;
    window.rootViewController = nil;
    window = nil;
    
}
@end

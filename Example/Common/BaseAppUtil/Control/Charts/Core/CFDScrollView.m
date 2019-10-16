//
//  CFDScrollView.m
//  globalwin
//
//  Created by ngw15 on 2018/9/2.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "CFDScrollView.h"

@interface CFDScrollView()

@end

@implementation CFDScrollView

//- (BOOL)touchesShouldCancelInContentView:(UIView *)view
//{
//     // 即使触摸到的是一个 UIControl (如子类：UIButton), 我们也希望拖动时能取消掉动作以便响应滚动动作
//    return YES;
//}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    if (_hasPan&&[otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]){
        return YES;
    }
    
    if (self.contentOffset.x <= 0) {
        if ([otherGestureRecognizer isKindOfClass:NSClassFromString(@"UIScreenEdgePanGestureRecognizer")]) {
            
            return YES;
        }
    }
    
    return NO;
}

@end

@interface CFDControl ()

@end

@implementation CFDControl
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

@end




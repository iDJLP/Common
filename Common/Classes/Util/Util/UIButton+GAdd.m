//
//  UIButton+NAdd.h
//  niuguwang
//
//  Created by BrightLi on 2016/12/9.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//
//


#import "UIButton+GAdd.h"
#import <objc/runtime.h>
#import "UtilHeader.h"

@interface UIButton ()

// 是否忽略点击事件
@property (nonatomic, assign) BOOL isIgnoreEvent;

@end

@implementation UIButton (NAdd)

static char clickBlockKey;
static char topNameKey;
static char rightNameKey;
static char bottomNameKey;
static char leftNameKey;

static const char *isIgnoreEventKey="UIControl_isIgnoreEvent";
static const char *skipKey="UIControl_skip";

// 设置是否跳过事件
- (void) setIsIgnoreEvent:(BOOL)isIgnoreEvent
{
    objc_setAssociatedObject(self,isIgnoreEventKey, @(isIgnoreEvent), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
// 获得是否跳过事件
- (BOOL) isIgnoreEvent
{
    return [objc_getAssociatedObject(self,isIgnoreEventKey) boolValue];
}

// 设置是否跳过
- (void) setN_skip:(BOOL) isSkip
{
    objc_setAssociatedObject(self,skipKey, @(isSkip), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
// 获得是否跳过
- (BOOL) n_skip
{
    return [objc_getAssociatedObject(self,skipKey) boolValue];
}

// 点击事件回调块
- (void) g_clickBlock:(ClickButtonBlock) block
{
    objc_setAssociatedObject(self, &clickBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.isIgnoreEvent=NO;
    [self addTarget:self action:@selector(clickBlock:) forControlEvents:UIControlEventTouchUpInside];
}
// MARK:- 私有方法
// 点击回调块
- (void) clickBlock:(id)sender
{
    if(self.g_checkRepeatClick){
        if (self.isIgnoreEvent){
            [GLog output:@"重复点击了:("];
            return;
        }else{
            WEAK_SELF;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f*NSEC_PER_SEC)),dispatch_get_main_queue(),^{
                [weakSelf setIsIgnoreEvent:NO];
            });
        }
        self.isIgnoreEvent = YES;
    }
    ClickButtonBlock block = (ClickButtonBlock)objc_getAssociatedObject(self, &clickBlockKey);
    if (block) {
        block(sender);
    }
}

- (void) drawDebug
{
#if DEBUG
    CGRect rect=[self enlargedRect];
    NSLog(@"点击区域[%.2f %.2f %.2f %.2f]",rect.origin.x,rect.origin.y,rect.size.width,rect.size.height);
    UIView *debugView=[self viewWithTag:100];
    if(!debugView){
        debugView=[[UIView alloc] initWithFrame:rect];
        debugView.tag=100;
        debugView.layer.backgroundColor=[UIColor redColor].CGColor;
        debugView.alpha=0.3f;
        debugView.userInteractionEnabled = NO;
        [self insertSubview:debugView atIndex:0];
    }else{
        [debugView setFrame:rect];
    }
#endif
}

//MARK:- 设置上下左右边界
- (void) g_clickEdgeWithTop:(CGFloat) top
                     bottom:(CGFloat) bottom
                       left:(CGFloat) left
                      right:(CGFloat) right
{
    objc_setAssociatedObject(self, &topNameKey, [NSNumber numberWithFloat:top], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &rightNameKey, [NSNumber numberWithFloat:right], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &bottomNameKey, [NSNumber numberWithFloat:bottom], OBJC_ASSOCIATION_COPY_NONATOMIC);
    objc_setAssociatedObject(self, &leftNameKey, [NSNumber numberWithFloat:left], OBJC_ASSOCIATION_COPY_NONATOMIC);
}
// MARK:- 获得当前的响应区域
- (CGRect) enlargedRect
{
    NSNumber *topEdge = objc_getAssociatedObject(self, &topNameKey);
    NSNumber *rightEdge = objc_getAssociatedObject(self, &rightNameKey);
    NSNumber *bottomEdge = objc_getAssociatedObject(self, &bottomNameKey);
    NSNumber *leftEdge = objc_getAssociatedObject(self, &leftNameKey);
    if (topEdge && rightEdge && bottomEdge && leftEdge)
    {
        return CGRectMake(self.bounds.origin.x - leftEdge.floatValue,
                          self.bounds.origin.y - topEdge.floatValue,
                          self.bounds.size.width + leftEdge.floatValue + rightEdge.floatValue,
                          self.bounds.size.height + topEdge.floatValue + bottomEdge.floatValue);
    }else{
        return self.bounds;
    }
}

// MARK:- 重载hitTest方法
- (UIView*) hitTest:(CGPoint) point withEvent:(UIEvent*) event
{
    if(self.hidden || !self.enabled || !self.userInteractionEnabled){
        return nil;
    }
    CGRect rect = [self enlargedRect];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

- (void) setBackgroundImageWith:(UIColor *)color forState:(UIControlState)state{
    [self setBackgroundImageWith:color forState:state radius:4.f];
}

- (void) setBackgroundImageWith:(UIColor *)color forState:(UIControlState)state radius:(CGFloat)radius{
    [self layoutIfNeeded];
    
    UIView *tempView = [[UIView alloc] initWithFrame:self.frame];
    tempView.backgroundColor = color;
    tempView.layer.cornerRadius = radius;
    
    UIImage *image = [tempView convertToImage];
    [self setBackgroundImage:image forState:state];
}

@end

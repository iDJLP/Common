//
//  UIView+GAdd.m
//  niuguwang
//
//  Created by BrightLi on 2016/12/16.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "UIView+GAdd.h"
#import <objc/runtime.h>
#import "UtilHeader.h"

@interface UIView ()

// 是否忽略点击事件
@property (nonatomic, assign) BOOL isIgnoreTap;

@end

@implementation UIView(GAdd)

static char clickBlockKey;

static const char *isIgnoreTapKey="UIView_isIgnoreTap";
static const char *checkRepeatClickKey="UIView_checkRepeatClick";

// 设置是否跳过
- (void) setG_checkRepeatClick:(BOOL) checkRepeatClick
{
    objc_setAssociatedObject(self,checkRepeatClickKey, @(checkRepeatClick), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
// 获得是否跳过
- (BOOL) g_checkRepeatClick
{
    return [objc_getAssociatedObject(self,checkRepeatClickKey) boolValue];
}
// 设置是否跳过事件
- (void) setIsIgnoreTap:(BOOL)isIgnoreTap
{
    objc_setAssociatedObject(self,isIgnoreTapKey, @(isIgnoreTap), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
// 获得是否跳过事件
- (BOOL) isIgnoreTap
{
    return [objc_getAssociatedObject(self,isIgnoreTapKey) boolValue];
}

- (void) g_clickBlock:(ClickViewBlock) block
{
    objc_setAssociatedObject(self, &clickBlockKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.isIgnoreTap=NO;
    self.userInteractionEnabled=YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBlock:)];
    [self addGestureRecognizer:tap];
}

// 点击回调块
- (void) clickBlock:(UITapGestureRecognizer *) tap
{
    if(self.g_checkRepeatClick){
        if (self.isIgnoreTap){
            [GLog output:@"反复点击了:("];
            return;
        }else{
            WEAK_SELF;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f*NSEC_PER_SEC)),dispatch_get_main_queue(),^{
                [weakSelf setIsIgnoreTap:NO];
            });
        }
        self.isIgnoreTap = YES;
    }
#if DEBUG
//    UIView *debugView=[self viewWithTag:100];
//    if(!debugView){
//        debugView=[[UIView alloc] init];
//        debugView.tag=100;
//        debugView.layer.backgroundColor=[UIColor redColor].CGColor;
//        debugView.userInteractionEnabled=NO;
//        debugView.alpha=0.3f;
//        [self addSubview:debugView];
//        [debugView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.mas_equalTo(0);
//        }];
//    }
#endif
    ClickViewBlock block = (ClickViewBlock)objc_getAssociatedObject(self, &clickBlockKey);
    if (block) {
        block(tap);
    }
}

// 判断View是否显示在屏幕上
- (BOOL) isDisplayedInScreen
{
    if(self == nil || self.hidden || !self.superview) {
        return NO;
    }
    // 获取此view在屏幕中的位置
    CGRect screenRect = [UIScreen mainScreen].bounds;
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect rect = [self convertRect:self.bounds toView:window];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return NO;
    }
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return NO;
    }
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return NO;
    }
    return YES;
}
// 设置圆角
- (void) radius:(UIColor *)color radius:(CGFloat) radius
{
    self.layer.backgroundColor=color.CGColor;
    self.layer.cornerRadius=radius;
    self.layer.shouldRasterize=YES;
    self.layer.rasterizationScale=self.layer.contentsScale;
}

- (void)addLineWith:(LineDirection)lineDirection{
    [self addLineWith:lineDirection rect:self.bounds];
}

- (void)addLineWith:(LineDirection)lineDirection rect:(CGRect)rect{
    CAShapeLayer *shareLayer = [self dealLine:lineDirection rect:rect];
    
    [self.layer addSublayer:shareLayer];
}

- (void)addLineWith:(LineDirection)lineDirection lineWidth:(CGFloat)lineWidth{
    CAShapeLayer *shareLayer = [self dealLine:lineDirection rect:self.bounds];
    shareLayer.lineWidth = lineWidth;
    
    [self.layer addSublayer:shareLayer];
}

- (void)addLineWith:(LineDirection)lineDirection rect:(CGRect)rect lineWidth:(CGFloat)lineWidth{
    CAShapeLayer *shareLayer = [self dealLine:lineDirection rect:rect];
    shareLayer.lineWidth = lineWidth;
    
    [self.layer addSublayer:shareLayer];
}

- (CAShapeLayer *)dealLine:(LineDirection)lineDirection rect:(CGRect)rect{
    [self readyAddLine];
    
    UIBezierPath *bezierPath = [self dealDetailLine:lineDirection rect:rect];
    
    CAShapeLayer *shareLayer = [CAShapeLayer layer];
    shareLayer.strokeColor = [GColorUtil colorWithHex:0xe8e8e8].CGColor;
    shareLayer.path = bezierPath.CGPath;
    shareLayer.name = @"LineShapeLayer";
    shareLayer.lineWidth = .5f;
    
    return shareLayer;
}

- (UIBezierPath *)dealDetailLine:(LineDirection)lineDirection rect:(CGRect)rect{
    CGPoint start = CGPointZero;
    CGPoint end = CGPointZero;
    LineDirection target = 0;
    
    if (lineDirection & LineTop) {
        target = LineTop;
        start = CGPointMake(CGRectGetMinX(rect), CGRectGetMinY(rect));
        end = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
    }else if (lineDirection & LineRight){
        target = LineRight;
        start = CGPointMake(CGRectGetMaxX(rect), CGRectGetMinY(rect));
        end = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    }else if (lineDirection & LineBottom){
        target = LineBottom;
        start = CGPointMake(CGRectGetMaxX(rect), CGRectGetMaxY(rect));
        end = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
    }else if (lineDirection & LineLeft){
        target = LineLeft;
        start = CGPointMake(CGRectGetMinX(rect), CGRectGetMaxY(rect));
        end = CGPointMake(CGRectGetMinX(rect), CGRectGetMinX(rect));
    }
    
    UIBezierPath *bezierPath = nil;
    if (target) {
        UIBezierPath *tempPath = [self dealDetailLine:lineDirection ^ target rect:rect];
        
        bezierPath = tempPath ? [UIBezierPath bezierPathWithCGPath:tempPath.CGPath] : [UIBezierPath bezierPath];
        [bezierPath moveToPoint:start];
        [bezierPath addLineToPoint:end];
    }
    
    return bezierPath;
}

- (void)readyAddLine{
    __block CALayer *layer = nil;
    
    [self.layer.sublayers enumerateObjectsUsingBlock:^(CALayer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.name isEqualToString:@"LineShapeLayer"]) {
            layer = obj;
            *stop = YES;
        }
    }];
    
    [layer removeFromSuperlayer];
}

+ (UIViewController *)getPresentCurrentVC
{
    
    UINavigationController *navC = [GJumpUtil rootNavC];
    UIViewController *next = [navC presentedViewController];
    if (next) {
        while ([next presentedViewController]) {
            next = [next presentedViewController];
        }
        return next;
    }else{
        return [GJumpUtil rootNavC].topViewController;
    }
}

+ (UIViewController *)getPushCurrentVC
{
    UINavigationController *navC = [GJumpUtil rootNavC];
    return [GJumpUtil rootNavC].topViewController;
}


- (UIImage *)convertToImage{
    CGSize size = self.bounds.size;
    
    UIGraphicsBeginImageContextWithOptions(size, NO, [UIScreen mainScreen].scale);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

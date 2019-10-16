//
//  GNavUtil.m
//  niuguwang
//
//  Created by BrightLi on 2017/10/26.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "GNavUtil.h"
#import "UtilHeader.h"

#define NAV_BUTTON_WIDTH SCREEN_WIDTH*0.2f
#define NAV_LEFT_SECOND_TAG 10000

@implementation GNavUtil

+ (void)addLine:(UIViewController *)target{
    UINavigationBar *bar = target.navigationController.navigationBar;
    if (![bar isKindOfClass:[UINavigationBar class]]) {
        return;
    }
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [GColorUtil C7];
    [bar addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
}

// 隐藏导航栏底线
+ (void) hideLine:(UIViewController *) target
{
    UIImageView *navImg = [self findHairlineImageViewUnder:target.navigationController.navigationBar];
    navImg.hidden = YES;
}

// 创建导航栏左侧
+ (UIBarButtonItem *) itemWithLeft:(NSString *)icon onClick:(void (^)(void)) onClick
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NAV_BUTTON_WIDTH,NAV_BAR_HEIGHT)];
    UIImageView *leftIcon=[[UIImageView alloc] initWithImage:[GColorUtil imageNamed:icon]];
    [leftIcon setFrame:CGRectMake(0,(NAV_BAR_HEIGHT-leftIcon.frame.size.height)/2,leftIcon.frame.size.width,leftIcon.frame.size.height)];
    [customView addSubview:leftIcon];
    [customView g_clickBlock:^(UITapGestureRecognizer *tap) {
        if(onClick){
            onClick();
        }
    }];
    return  [[UIBarButtonItem alloc] initWithCustomView:customView];
}
// 创建导航栏右侧
+ (UIBarButtonItem *) itemWithRight:(NSString *)icon onClick:(void (^)(void)) onClick
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, NAV_BUTTON_WIDTH, 44)];
    BaseImageView *rightIcon=[[BaseImageView alloc] initWithFrame:CGRectMake(NAV_BUTTON_WIDTH-15,(44-15)/2,15,15)];
    rightIcon.imageName = icon;
    
    [customView addSubview:rightIcon];
    [customView g_clickBlock:^(UITapGestureRecognizer *tap) {
        if(onClick){
            onClick();
        }
    }];
    return  [[UIBarButtonItem alloc] initWithCustomView:customView];
}

// 创建导航栏右侧
+ (UIBarButtonItem *) itemWithRightLabel:(UILabel *)label onClick:(void (^)(void)) onClick
{
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,NAV_BUTTON_WIDTH,NAV_BAR_HEIGHT)];
    [label setFrame:customView.frame];
    [customView addSubview:label];
    [customView g_clickBlock:^(UITapGestureRecognizer *tap) {
        if(onClick){
            onClick();
        }
    }];
    return  [[UIBarButtonItem alloc] initWithCustomView:customView];
}

// 设置返回关闭按钮
+ (void) leftIcon:(UIViewController *)target
             icon:(NSString *) icon
       secondIcon:(NSString *) secondIcon
              gap:(NSInteger) gap
          onClick:(void (^)(void)) onClick
    onClickSecond:(void (^)(void)) onClickSecond
{
    if(target.navigationController.topViewController!=target){
        return;
    }
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,NAV_BUTTON_WIDTH,NAV_BAR_HEIGHT)];
    UIImageView *img=[[UIImageView alloc] initWithImage:[GColorUtil imageNamed:icon]];
    [img setFrame:CGRectMake(0,(44-img.size.height)/2, img.size.width, img.size.height)];
    UIView *firstView=[[UIView alloc] initWithFrame:CGRectMake(0,0,NAV_BUTTON_WIDTH,44)];
    [firstView addSubview:img];
    [customView addSubview:firstView];
    
    UIImageView *secondImg=[[UIImageView alloc] initWithImage:[GColorUtil imageNamed:secondIcon]];
    [secondImg setFrame:CGRectMake(gap,(44-secondImg.size.height)/2,secondImg.size.width,secondImg.size.height)];
    CGFloat width=NAV_BUTTON_WIDTH-(img.size.width+gap);
    UIView *secondView=[[UIView alloc] initWithFrame:CGRectMake(img.size.width+gap,0,width,44)];
    secondView.tag=NAV_LEFT_SECOND_TAG;
    [secondView addSubview:secondImg];
    [customView addSubview:secondView];
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:customView];
    target.navigationItem.leftBarButtonItems=@[item];
    [firstView g_clickBlock:^(UITapGestureRecognizer *tap) {
        if(onClick){
            onClick();
        }
    }];
    [secondView g_clickBlock:^(UITapGestureRecognizer *tap) {
        if(onClickSecond){
            onClickSecond();
        }
    }];
}
// 隐藏或显示关闭左侧第二个按钮
+ (void) leftSecondHidden:(UIViewController *)target
              hidden:(BOOL) hidden
{
    if(target.navigationController.topViewController!=target){
        return;
    }
    UIView *view=[[target.navigationItem.leftBarButtonItems lastObject].customView viewWithTag:NAV_LEFT_SECOND_TAG];
    if(!view){
        return;
    }
    view.hidden=hidden;
}

// 创建导航栏左侧返回按钮
+ (void) leftBack:(UIViewController *) target
{
    if(target.navigationController.topViewController!=target){
        return;
    }
    __weak typeof(target) weakVC=target;
    [GNavUtil leftIcon:target icon:@"nav_icon_back" onClick:^(){
        UIViewController *vc=[weakVC.navigationController popViewControllerAnimated:YES];
        if(!vc){
            [weakVC dismissViewControllerAnimated:YES completion:nil];
        }
    }];
}
// 创建导航栏左侧图标
+ (void) leftIcon:(UIViewController *) target
             icon:(NSString *) icon
          onClick:(void (^)(void)) onClick
{
    if(target.navigationController.topViewController!=target){
        return;
    }
    UIBarButtonItem *item=[GNavUtil itemWithLeft:icon onClick:onClick];
    target.navigationItem.leftBarButtonItems=@[item];
}

// 创建导航栏右侧双图标按钮
+ (void) rightIcon:(UIViewController *) target
              icon:(NSString *)icon
        secondIcon:(NSString *) secondIcon
               gap:(NSInteger) gap
           onClick:(void (^)(void)) onClick
     onClickSecond:(void (^)(void)) onClickSecond
{
    if(target.navigationController.topViewController!=target){
        return;
    }
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0,0,NAV_BUTTON_WIDTH,NAV_BAR_HEIGHT)];
    UIImageView *img=[[UIImageView alloc] initWithImage:[GColorUtil imageNamed:icon]];
    [img setFrame:CGRectMake(gap,(44-img.size.height)/2, img.size.width, img.size.height)];
    UIView *firstView=[[UIView alloc] initWithFrame:CGRectMake(NAV_BUTTON_WIDTH-gap-img.size.width,0,gap+img.size.width,44)];
    [firstView addSubview:img];
    [customView addSubview:firstView];
    
    UIImageView *secondImg=[[UIImageView alloc] initWithImage:[GColorUtil imageNamed:secondIcon]];
    [secondImg setFrame:CGRectMake(gap,(44-secondImg.size.height)/2,secondImg.size.width,secondImg.size.height)];
    CGFloat width=gap*2+secondImg.size.width;
    UIView *secondView=[[UIView alloc] initWithFrame:CGRectMake(firstView.origin.x-width,0,width,44)];

    [secondView addSubview:secondImg];
    [customView addSubview:secondView];
    
    UIBarButtonItem *item=[[UIBarButtonItem alloc] initWithCustomView:customView];
    target.navigationItem.rightBarButtonItems=@[item];
    [firstView g_clickBlock:^(UITapGestureRecognizer *tap) {
        if(onClick){
            onClick();
        }
    }];
    [secondView g_clickBlock:^(UITapGestureRecognizer *tap) {
        if(onClickSecond){
            onClickSecond();
        }
    }];
}

// 创建导航栏右侧图标按钮
+ (void) rightIcon:(UIViewController *) target
              icon:(NSString *)icon
           onClick:(void (^)(void)) onClick
{
    if(target.navigationController.topViewController!=target){
        return;
    }
    UIBarButtonItem *item=[GNavUtil itemWithRight:icon onClick:onClick];
    target.navigationItem.rightBarButtonItems=@[item];
}
// 创建导航栏右侧文本按钮
+ (UILabel *) rightTitle:(UIViewController *) target
                   title:(NSString *)title
                   color:(ColorType)color
                 onClick:(void (^)(void)) onClick;
{
    if(target.navigationController.topViewController!=target){
        return nil;
    }
    
    UILabel *label=[[UILabel alloc] init];
    label.font=[GUIUtil fitFont:12];
    label.textColor=[GColorUtil colorWithColorType:color];
    label.adjustsFontSizeToFitWidth=YES;
    label.minimumScaleFactor=0.8f;
    label.textAlignment=NSTextAlignmentRight;
    label.text=title;
    UIBarButtonItem *item=[GNavUtil itemWithRightLabel:label onClick:onClick];
    target.navigationItem.rightBarButtonItems=@[item];
    return label;
}

//取navBar 下的横线
+(UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

@end


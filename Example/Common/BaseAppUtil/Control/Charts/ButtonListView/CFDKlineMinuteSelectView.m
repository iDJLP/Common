//
//  KlineMinuteSelectView.m
//  niuguwang
//
//  Created by zhangchangqing on 16/9/9.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "CFDKlineMinuteSelectView.h"

@interface CFDKlineMinuteSelectView()
<UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIView *viewBackg;
@property (nonatomic,strong) NSArray <NSDictionary *>*titles;
@end

#define MinuteBackgHighlighteddColor [ChartsUtil colorWithHex:0x3c414d]

@implementation CFDKlineMinuteSelectView

-(void)dealloc
{
}

-(instancetype)initWithTitles:(NSArray<NSDictionary *> *)titles frame:(CGRect)frame
{
    if (self=[super initWithFrame:frame]) {
        _titles = titles;
        [self initKlineBtnList];
    }
    return self;
}

-(void)initKlineBtnList
{
    UIImageView *imageBackView = [self backImageView];
    imageBackView.frame = CGRectMake(0, 0, SCREEN_WIDTH, [GUIUtil fit:35]);
    [self addSubview:imageBackView];
    
    for (NSInteger i=0;i<_titles.count;i++)
    {
        UIButton *minuteBtn=[[UIButton alloc] init];
        minuteBtn.tag=i+1180;
        NSDictionary *dic = [NDataUtil dictWithArray:_titles index:i];
        NSString *title = [NDataUtil stringWith:dic[@"title"]];
        [minuteBtn setTitle:title  forState:UIControlStateNormal];
        minuteBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
        [minuteBtn.titleLabel setFont:[ChartsUtil fitFont:12]];
        [minuteBtn setTitleColor:[ChartsUtil C18] forState:UIControlStateNormal];
        [minuteBtn setTitleColor:[ChartsUtil C19] forState:UIControlStateHighlighted];
        [minuteBtn setTitleColor:[ChartsUtil C19] forState:UIControlStateSelected];
        [minuteBtn  setBackgroundImage:[UIImage imageWithColor:MinuteBackgHighlighteddColor] forState:UIControlStateHighlighted];
        [minuteBtn addTarget:self action:@selector(typeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat width = [GUIUtil fit:45];
        [minuteBtn setFrame:CGRectMake([GUIUtil fit:3]+[GUIUtil fit:65]*i+[GUIUtil fit:10], 0, width, [GUIUtil fit:35])];
        minuteBtn.selected=NO;
        minuteBtn.userInteractionEnabled=YES;
        [self addSubview:minuteBtn];
    }
}

- (UIImageView *)backImageView {
    
    UIImageView *imgBackView  = [[UIImageView alloc] init];
    imgBackView.backgroundColor = [GColorUtil C8];
    imgBackView.layer.cornerRadius = 4;
    imgBackView.layer.masksToBounds = YES;
    return imgBackView;
}

//点击了类型btn
-(void)typeBtnClick:(UIButton*)sender
{
    if (sender.selected)
    {
        return;
    }
    
    UIButton * btn = (UIButton*)sender;
    if (self.setSelectMinuteBtn) {
        NSInteger index = btn.tag - 1180;
        NSDictionary *dic = [NDataUtil dictWithArray:_titles index:index];
        self.setSelectMinuteBtn(_index, dic);
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer {
    //    self.hidden = YES;
    //    self.viewBackg.hidden = self.hidden;
    //    [self.window removeGestureRecognizer:recognizer];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //    CGPoint curp = [touch locationInView:self];
    //    if (curp.x >=0 && curp.x <= self.frame.size.width && curp.y >=0 && curp.y <= self.frame.size.height)
    //    {
    //        return NO;
    //    }
    return YES;
}


- (UIView*)viewBackg
{
    if (!_viewBackg) {
        _viewBackg = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    }
    return _viewBackg;
}
@end


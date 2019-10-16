//
//  UITextField+textFieldDone.m
//  niuguwang
//
//  Created by jly on 2017/6/23.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "UITextField+textFieldDone.h"
#import "BaseBtn.h"
#import "UIButton+GAdd.h"

@implementation UITextField (textFieldDone)

- (void)addToolBarDoneAndSwitch:(void (^)(BOOL isNext))hander nextEnable:(BOOL)nextEnable prevEnable:(BOOL)prevEnable{
    UIView *toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    toolbar.tintColor  = [GColorUtil C13];
    toolbar.backgroundColor = [GColorUtil colorWithHex:0xf4f4f4];
    
    BaseBtn *prevBtn = [[BaseBtn alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.2f, SCREEN_WIDTH*0.2f)];
    UIImage *img = [UIImage imageNamed:@"keyboard_icon_right"];
    img = [img imageByRotate180];
    [prevBtn setImage:img forState:UIControlStateNormal];
    [prevBtn setImage:[UIImage imageNamed:@"keyboard_icon_left"] forState:UIControlStateDisabled];
    prevBtn.enabled = prevEnable;
    BaseBtn *nextBtn = [[BaseBtn alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.2f, SCREEN_WIDTH*0.2f)];
    [nextBtn setImage:img forState:UIControlStateNormal];
    [nextBtn setImage:[UIImage imageNamed:@"keyboard_icon_left"] forState:UIControlStateDisabled];
    nextBtn.transform = CGAffineTransformMakeRotation(M_PI);
    nextBtn.enabled = nextEnable;
    BaseBtn *doneBtn = [[BaseBtn alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH*0.2f, SCREEN_WIDTH*0.2f)];
    doneBtn.textBlock = CFDLocalizedStringBlock(@"完成_done");
    [doneBtn addTarget:self action:@selector(textFieldDone) forControlEvents:UIControlEventTouchUpInside];
    doneBtn.txColor = C13_ColorType;
    [toolbar addSubview:nextBtn];
    [toolbar addSubview:prevBtn];
    [toolbar addSubview:doneBtn];
    [doneBtn g_clickEdgeWithTop:0 bottom:0 left:10 right:10];
    [prevBtn g_clickEdgeWithTop:0 bottom:0 left:10 right:10];
    [nextBtn g_clickEdgeWithTop:0 bottom:0 left:10 right:10];
    [prevBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:15]);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo([GUIUtil fitWidth:24 height:24]);
    }];
    [nextBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(prevBtn.mas_right).mas_offset([GUIUtil fit:20]);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo([GUIUtil fitWidth:24 height:24]);
    }];
    [doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo([GUIUtil fitWidth:44 height:44]);
    }];
    
    [nextBtn g_clickBlock:^(id sender) {
        hander(YES);

    }];
    [prevBtn g_clickBlock:^(id sender) {
        hander(NO);

    }];

    self.inputAccessoryView = toolbar;
}

- (void)addToolbar
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    toolbar.tintColor  = [GColorUtil C13];
    toolbar.backgroundColor = [GColorUtil colorWithHex:0xf4f4f4];
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc] initWithTitle:CFDLocalizedString(@"完成_done") style:UIBarButtonItemStylePlain target:self action:@selector(textFieldDone)];
    
    toolbar.items = @[space,bar];
    
    self.inputAccessoryView = toolbar;
    
}
- (void)textFieldDone
{
    [[GJumpUtil window] endEditing:YES];
}
@end

//
//  UITextView+Done.m
//  LiveTrade
//
//  Created by ngw15 on 2018/11/15.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "UITextView+Done.h"

@implementation UITextView (Done)

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


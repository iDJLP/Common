//
//  UIResponder+FirstResponder.m
//  LiveTrade
//
//  Created by kakiYen on 2018/11/7.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "UIResponder+FirstResponder.h"

static NSString *Responder_Catagory_Mark = @"Responder_Catagory_Mark";
static __weak id responder;

@implementation UIResponder (FirstResponder)

- (void)findResponder:(id)sender{
    responder = self;
}

- (id)findFirstResponder{
    [[UIApplication sharedApplication] sendAction:@selector(findResponder:) to:nil from:nil forEvent:nil];
    
    return responder;
}

@end

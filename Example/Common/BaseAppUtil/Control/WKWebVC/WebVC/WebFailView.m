//
//  WebFailView.m
//  globalwin
//
//  Created by ngw15 on 2018/8/7.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "WebFailView.h"

@implementation WebFailView

- (instancetype)initWithType:(WebVCType)type onReload:(dispatch_block_t)reloadHander
{
    self = [super init];
    if (self) {
        ReloadStateView *reloadView = (ReloadStateView *)[StateUtil show:self type:StateTypeReload];
        reloadView.onReload = reloadHander;
        if (type==WebVCTypeDefault) {
            
        }else{
            reloadView.icon.image = [GColorUtil imageNamed:@"schematic_nothing"];
            reloadView.title.text = [FTConfig webTips];
        }
    }
    return self;
}

@end

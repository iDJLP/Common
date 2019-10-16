//
//  WebLoadingView.m
//  globalwin
//
//  Created by ngw15 on 2018/8/7.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "WebLoadingView.h"

@interface WebLoadingView ()

@property (nonatomic,strong)UIImageView *imgView;

@end

@implementation WebLoadingView

- (instancetype)initWithType:(WebVCType)type
{
    self = [super init];
    if (self) {
        if (type==WebVCTypeDefault) {
            ProgressStateView *stateView = (ProgressStateView *)[StateUtil show:self type:StateTypeProgress];
            
        }else if(type==WebVCTypeNews){
            [self addSubview:self.imgView];
            [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(0);
            }];
        }
    }
    return self;
}

- (UIImageView *)imgView{
    if (!_imgView) {
        _imgView = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"article_placeholder_bg"]];
    }
    return _imgView;
}

@end


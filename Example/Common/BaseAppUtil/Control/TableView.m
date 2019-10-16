//
//  TableView.m
//  Chart
//
//  Created by ngw15 on 2019/3/7.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "TableView.h"

@implementation TableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    if (self = [super initWithFrame:frame style:style]) {
        self.bgColor = C6_ColorType;
    }
    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}


@end

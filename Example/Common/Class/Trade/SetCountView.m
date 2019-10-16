//
//  SetCountView.m
//  niuguwang
//
//  Created by ngw on 2016/11/25.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#import "SetCountView.h"

@interface SetCountView ()


@end

@implementation SetCountView


- (void)updateData:(NSArray *)array
{
    WEAK_SELF;
    __block BOOL isEqual = YES;
    [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id data = [NDataUtil dataWithArray:weakSelf.dataList index:idx];
        NSString *obj1 = @"";
        if ([data isKindOfClass:[NSString class]]) {
            obj1 = data;
        }else if ([data isKindOfClass:[NSDictionary class]]){
            obj1 = [NDataUtil stringWithDict:data keys:@[@"data"] valid:@""];
        }
        if (![[NDataUtil stringWith:obj valid:@""] isEqualToString:obj1]||obj1.length<=0) {
            isEqual=NO;
        }
    }];
    if (isEqual==NO) {
        for(UIView * sender in self.subviews)
        {
            [sender removeFromSuperview];
        }
        _dataList = [[NSMutableArray alloc]initWithArray:array];
        if(_dataList.count<1)return;
        [self setupSubviews];
    }
   
}
-(void)setupSubviews
{
    NSMutableArray *marr = [NSMutableArray new];

    for (int i = 0; i < _dataList.count; i ++) {
        UIButton *  btn=[UIButton buttonWithType:UIButtonTypeCustom];
        [btn.titleLabel setFont:[GUIUtil fitFont:14]];
        btn.layer.masksToBounds=YES;
        btn.layer.cornerRadius=1;
        btn.layer.borderWidth = [GUIUtil fitLine]*2;
        btn.layer.borderColor=[GColorUtil C4].CGColor;

        [btn setTitleColor:[GColorUtil C4] forState:UIControlStateNormal];
        [btn setTitleColor:[GColorUtil C13] forState:UIControlStateHighlighted];
        [btn setTitleColor:[GColorUtil C13] forState:UIControlStateSelected];

        WEAK_SELF;
        [btn g_clickBlock:^(id sender) {
            [weakSelf countClicked:sender];
        }];
        [btn g_clickEdgeWithTop:10 bottom:10 left:2 right:2];
        btn.tag=1050+i;
       
        id data = [NDataUtil dataWithArray:weakSelf.dataList index:i];
        NSString *obj1 = @"";
        if ([data isKindOfClass:[NSString class]]) {
            obj1 = data;
        }else if ([data isKindOfClass:[NSDictionary class]]){
            obj1 = [NDataUtil stringWithDict:data keys:@[@"data"] valid:@""];
        }
        [btn setTitle:obj1 forState:UIControlStateNormal];
        [self addSubview:btn];
        [marr addObject:btn];
        if(i == 0){
            [self countClicked:btn];
        }
    }
    
    [marr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:[GUIUtil fit:5] leadSpacing:[GUIUtil fit:5] tailSpacing:0];
    [marr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.height.mas_equalTo([GUIUtil fitFontSize:22]);
        make.width.mas_equalTo([GUIUtil fit:55]);
    }];
    
}

- (void)setSelectedIndex:(NSInteger)index{
    UIButton *button = [self viewWithTag:1050+index];
    [self countClicked:button];
}


-(void)countClicked:(id)sender
{
    UIButton *btn=(UIButton *)sender;
    NSInteger index = btn.tag-1050;
    id data = [NDataUtil dataWithArray:self.dataList index:index];
    [self changedSelected:index];
    if (_setCountBlock) {
        _setCountBlock(data);
    }
}

-(void)changedSelected:(NSInteger)tag
{
    if (tag > 5) {
        return;
    }
    for(int i=0; i < 5 ; i++)
    {
        UIButton *button = [self viewWithTag:i+1050];
        if (button.tag == tag+1050) {
            button.selected=YES;
            button.layer.borderColor=[GColorUtil C13].CGColor;
        }
        else{
            button.layer.borderColor=[GColorUtil C4].CGColor;
            button.selected  = NO;
        }
    }

}



@end

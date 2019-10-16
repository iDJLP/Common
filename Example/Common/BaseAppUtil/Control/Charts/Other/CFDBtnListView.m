//
//  CFDBtnListView.m
//  LiveTrade
//
//  Created by ngw15 on 2019/2/19.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "CFDBtnListView.h"

@interface CFDBtnListView()

@property (nonatomic,strong)NSArray *list;
@property (nonatomic,strong)NSArray *btnlist;

@end

@implementation CFDBtnListView

- (instancetype)initWithList:(NSArray *)list
{
    self = [super init];
    if (self) {
        _list = list;
        UIButton *lastBtn = nil;
        NSMutableArray *tem = [NSMutableArray array];
        for (NSInteger i=0; i<list.count; i++) {
            NSNumber *indexType = list[i];
            UIButton *btn = self.btn;
            [self addSubview:btn];
            [tem addObject:btn];
            NSString *title = @"";
            if (indexType.integerValue==EIndexTypeKdj){
                btn.tag = EIndexBtnTag + EIndexTypeKdj;
                title = @"KDJ";
            }else if (indexType.integerValue==EIndexTypeMacd){
                btn.tag = EIndexBtnTag + EIndexTypeMacd;
                title = @"MACD";
            }else if (indexType.integerValue==EIndexTypeRsi){
                btn.tag = EIndexBtnTag + EIndexTypeRsi;
                title = @"RSI";
            }else if (indexType.integerValue==EIndexTypeWR){
                btn.tag = EIndexBtnTag + EIndexTypeWR;
                title = @"WR";
            }else if (indexType.integerValue==EIndexTypeBIAS){
                btn.tag = EIndexBtnTag + EIndexTypeBIAS;
                title = @"BIAS";
            }else if (indexType.integerValue==EIndexTypeCCI){
                btn.tag = EIndexBtnTag + EIndexTypeCCI;
                title = @"CCI";
            }
            [btn setTitle:title forState:UIControlStateNormal];
            CGFloat width = [GUIUtil sizeWith:title fontSize:[GUIUtil fitFontSize:10]].width;
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.height.equalTo(self);
                make.top.mas_equalTo(0);
                make.width.mas_equalTo(width+[GUIUtil fit:10]);
                if (i==0) {
                    make.left.mas_equalTo(0);
                }else{
                    make.left.equalTo(lastBtn.mas_right).mas_offset([GUIUtil fit:5]);
                }
            }];
            lastBtn = btn;
        }
        _btnlist = tem;
        UIButton *btn = [NDataUtil dataWithArray:_btnlist index:0];
        btn.selected=YES;
    }
    return self;
}

- (void)btnAction:(UIButton *)sender{
    for (UIButton *btn in _btnlist) {
        btn.selected = NO;
    }
    sender.selected = YES;
    _indexSelectedHander(sender.tag-EIndexBtnTag);
}

- (UIButton *)btn{
    UIButton *btn = [[UIButton alloc] init];
    btn.titleLabel.font = [GUIUtil fitFont:10];
    btn.tag = EIndexBtnTag;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageWithColor:[GColorUtil C4]] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:[GColorUtil C14]] forState:UIControlStateSelected];
    btn.selected = NO;
    return btn;
}


@end

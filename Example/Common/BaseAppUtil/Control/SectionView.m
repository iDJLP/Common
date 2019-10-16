//
//  SectionView.m
//  Chart
//
//  Created by ngw15 on 2019/3/7.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "SectionView.h"
#import "Control.h"
#import "BaseBtn.h"

@interface SectionView ()

@property (nonatomic,strong)BaseView *lineView;
@property (nonatomic,strong)NSMutableArray <CFDSelectedBtn *>*btnList;
@property (nonatomic,assign)SectionType type;

@end

@implementation SectionView

- (instancetype)initWithList:(NSArray *)list sectionType:(SectionType)type{
    if (self = [super init]) {
        _btnList = [NSMutableArray array];
        _type = type;
        if (type==SectionTypeDivideWidth) {
            UIButton *referView = nil;
            for (NSString *title in list) {
                CFDSelectedBtn *btn = [self btn:title];
                if (referView==nil) {
                    btn.selected = YES;
                }
                [_btnList addObject:btn];
                [self addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (referView==nil) {
                        make.left.mas_equalTo(0);
                    }else{
                        make.left.equalTo(referView.mas_right);
                    }
                    make.top.mas_equalTo(0);
                    make.height.equalTo(self);
                    make.width.mas_equalTo(SCREEN_WIDTH/list.count);
                }];
                referView = btn;
            }
//            [referView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo(0);
//            }];
        }else{
            UIButton *referView = nil;
            for (NSString *title in list) {
                
                CFDSelectedBtn *btn = [self btn:title];
                if (referView==nil) {
                    btn.selected = YES;
                }
                [_btnList addObject:btn];
                [self addSubview:btn];
                [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (referView==nil) {
                        make.left.mas_equalTo([GUIUtil fit:15]);
                    }else{
                        make.left.equalTo(referView.mas_right).mas_offset([GUIUtil fit:30]);
                    }
                    make.top.mas_equalTo(0);
                    make.height.equalTo(self);
                    make.width.equalTo(btn.titleLabel);
                }];
                referView = btn;
            }
//            [referView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.right.mas_equalTo([GUIUtil fit:-15]);
//            }];
        }
        [self addSubview:self.lineView];
        [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo([GUIUtil fitLine]);
        }];
    }
    return self;
}
- (void)changeSelectedIndex:(NSInteger)index{
    if (_selectedIndex==index) {
        return;
    }
    CFDSelectedBtn *btn = _btnList[index];
    [self btnAction:btn];
}

- (void)updateTitleList:(NSArray *)list{
    
    CFDSelectedBtn *lastRow = nil;
    for (int i =0; i<_btnList.count; i++) {
        CFDSelectedBtn *row= _btnList[i];
        NSInteger listCount = list.count;
        if (i<listCount) {
            NSString *title = [NDataUtil dataWithArray:list index:i];
            [row setTitle:title forState:UIControlStateNormal];
            if (_type == SectionTypeDivideWidth) {
                [row mas_remakeConstraints:^(MASConstraintMaker *make) {
                    if (lastRow==nil) {
                        make.left.mas_equalTo(0);
                    }else{
                        make.left.equalTo(lastRow.mas_right);
                    }
                    make.top.mas_equalTo(0);
                    make.height.equalTo(self);
                    if (list.count==1) {
                        make.width.mas_equalTo(SCREEN_WIDTH);
                    }else{                    
                        make.width.mas_equalTo(SCREEN_WIDTH/list.count);
                    }
                }];
            }else{
                [row mas_remakeConstraints:^(MASConstraintMaker *make) {
                    if (lastRow==nil) {
                        make.left.mas_equalTo([GUIUtil fit:15]);
                    }else{
                        make.left.equalTo(lastRow.mas_right).mas_offset([GUIUtil fit:30]);
                    }
                    make.top.mas_equalTo(0);
                    make.height.equalTo(self);
                    make.width.equalTo(row.titleLabel);
                }];
            }
            row.hidden = NO;
            lastRow = row;
        }else{
            row.hidden = YES;
        }
    }
    
    if(list.count>_btnList.count){
        for (NSInteger i =_btnList.count; i<list.count; i++) {
            NSString *title = [NDataUtil dataWithArray:list index:i];
            CFDSelectedBtn *row = [self btn:title];
            row.hidden = NO;
            [self addSubview:row];
            [_btnList addObject:row];
            if (_type == SectionTypeDivideWidth) {
                [row mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (lastRow==nil) {
                        make.left.mas_equalTo(0);
                    }else{
                        make.left.equalTo(lastRow.mas_right);
                    }
                    make.top.mas_equalTo(0);
                    make.height.equalTo(self);
                    make.width.mas_equalTo(SCREEN_WIDTH/list.count);
                }];
            }else{
                [row mas_makeConstraints:^(MASConstraintMaker *make) {
                    if (lastRow==nil) {
                        make.left.mas_equalTo([GUIUtil fit:15]);
                    }else{
                        make.left.equalTo(lastRow.mas_right).mas_offset([GUIUtil fit:30]);
                    }
                    make.top.mas_equalTo(0);
                    make.height.equalTo(self);
                    make.width.equalTo(row.titleLabel);
                }];
            }
            [row setTitle:title forState:UIControlStateNormal];
            lastRow = row;
        }
    }
}

- (void)setSectionBgColor:(ColorType)sectionBgColor sectionTextFont:(UIFont *)font sectionTextColor:(ColorType)textColor sectionSelTextColor:(ColorType)selTextColor hasLine:(BOOL)hasLine{
    self.bgColor = sectionBgColor;
    for (CFDSelectedBtn *btn in _btnList) {
        if (hasLine==NO) {
            btn.lineColor = [UIColor clearColor];
        }
        btn.titleLabel.font = font;
        btn.norFont = font;
        btn.selFont = font;
        btn.txColor = textColor;
        btn.txColor_sel = selTextColor;
    }
}

- (void)btnAction:(CFDSelectedBtn *)btn{
    UIButton *lastBtn = _btnList[_selectedIndex];
    lastBtn.selected = NO;
    NSInteger index = [_btnList indexOfObject:btn];
    _selectedIndex = index;
    btn.selected = YES;
    _changedSelectedIndex(index);
}

- (CFDSelectedBtn *)btn:(NSString *)title{
    CFDSelectedBtn *btn = [[CFDSelectedBtn alloc] init];
    btn.backgroundColor = [UIColor clearColor];
    btn.lineType = CFDSelectedLineTypeEqualTitle;
    btn.titleLabel.font = [GUIUtil fitFont:14];
    btn.norFont = [GUIUtil fitFont:14];
    btn.selFont = [GUIUtil fitFont:14];
//    btn.bgColor = C6_ColorType;
    btn.txColor = C3_ColorType;
    btn.txColor_sel = C13_ColorType;
    [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.lineColor = [GColorUtil C13];
    return btn;
}

- (BaseView *)lineView{
    if (!_lineView) {
        _lineView = [[BaseView alloc] init];
        _lineView.bgColor = C7_ColorType;
    }
    return _lineView;
}

@end

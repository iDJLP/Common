//
//  CFDKLineVButton.m
//  nntj_ftox
//
//  Created by zhangchangqing on 2017/10/11.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "CFDKLineVButton.h"

@interface CFDKLineButton : UIControl
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIImageView *markImg;
@property (nonatomic,strong) UIView *lineView;
@end

@implementation CFDKLineButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.markImg];
    [self addSubview:self.lineView];
}

- (void)autoLayout{
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
//        make.width.equalTo(self).mas_offset([ChartsUtil fit:-10]);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.width.equalTo(self.titleLabel.mas_width);
        make.height.mas_equalTo([ChartsUtil fit:2]);
        make.bottom.mas_equalTo(0);
    }];
    [_markImg  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.titleLabel);
        make.left.equalTo(self.titleLabel.mas_right).mas_offset([ChartsUtil fit:3]);
    }];
}

- (void)setSelected:(BOOL)selected{
    [super setSelected:selected];
    if (selected) {
        _titleLabel.textColor = [ChartsUtil C13];
    }else{
        _titleLabel.textColor = [ChartsUtil C3];
    }
    _lineView.hidden = !selected;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [ChartsUtil C3];
        _titleLabel.font = [ChartsUtil fitBoldFont:12];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.numberOfLines = 1;
        _titleLabel.adjustsFontSizeToFitWidth = YES;
        _titleLabel.minimumScaleFactor = 0.5;
    }
    return _titleLabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [ChartsUtil C13];
        _lineView.hidden = YES;
    }
    return _lineView;
}

- (UIImageView *)markImg{
    if(!_markImg){
        _markImg = [[UIImageView alloc] init];
        _markImg.image =[GColorUtil imageNamed: @"charts_home_triangle"];
        _markImg.hidden = YES;
    }
    return _markImg;
}


@end

@interface  CFDKLineVButton()

@property(nonatomic,strong) UIView *labLine;

@property (nonatomic,strong)NSArray <NSDictionary *>*titles;
@end

@implementation CFDKLineVButton


- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles{
    if (self = [super initWithFrame:frame]) {
        _titles = titles;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    NSMutableArray *marr = [NSMutableArray new];
    for (int i = 0; i < _titles.count; i ++) {
        NSDictionary *dic = [NDataUtil  dataWithArray:_titles index:i];
        NSString *title = [NDataUtil stringWith:dic[@"title"]];
        BOOL hasMark = [NDataUtil boolWithDic:dic key:@"more" isEqual:@"1"];
        CFDKLineButton *  btn= [[CFDKLineButton alloc] init];
        btn.titleLabel.text = title;
        btn.markImg.hidden = !hasMark;
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        btn.tag=1000+i;        
        [self addSubview:btn];
        [marr addObject:btn];
        
        if (i==0)
        {
            btn.selected = YES;
        }
    }
    [self addSubview:self.labLine];
    
    
    [marr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:0 leadSpacing:0 tailSpacing:0];
    [marr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.height.equalTo(self);
    }];

    [_labLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self);
        make.height.mas_equalTo([ChartsUtil fitLine]);
        make.left.mas_equalTo(0);
        make.width.equalTo(self);
    }];
}

-(void)btnAction:(id)sender
{
    CFDKLineButton *btn=(CFDKLineButton *)sender;
    NSInteger index = btn.tag-1000;
    [self clickedButtonList:index];
}

- (void)clickedButtonList:(NSInteger)index{
    NSDictionary *dic = [NDataUtil dictWithArray:_titles index:index];
    if (_setKlineTypeBlock) {
        _setKlineTypeBlock(index,dic);
    }
    if (![NDataUtil boolWithDic:dic key:@"more" isEqual:@"1"])
    {
        [self setSelected:index];
    }
}

-(void)setSelected:(NSInteger)index
{
    if (index > _titles.count) {
        return;
    }
    
    for(int i=0; i < _titles.count ; i++)
    {
        CFDKLineButton *button = [self viewWithTag:i+1000];
        if (button.tag == index+1000) {
            button.selected=YES;
        }
        else
            button.selected  = NO;
    }
}

- (void)resetSelectedBtn{
    for (NSInteger i=0; i<_titles.count; i++) {
        NSDictionary *config = [NDataUtil dictWithArray:_titles index:i];
        if ([NDataUtil boolWithDic:config key:@"more" isEqual:@"1"]) {
            CFDKLineButton *btn = [self viewWithTag:1000+i];
            NSString *title = [NDataUtil stringWith:config[@"title"]];
            btn.titleLabel.text = title;
        }
    }
}

- (void)changedSelected:(NSInteger)index title:(NSString *)title
{
    CFDKLineButton *btn = [self viewWithTag:1000+index];
    btn.titleLabel.text = title;
    for(int i=0; i < _titles.count ; i++)
    {
        CFDKLineButton *button = [self viewWithTag:i+1000];
        if (button.tag == 1000+index) {
            button.selected=YES;
        }
        else
            button.selected  = NO;
    }
}

- (UIView*)labLine
{
    if (!_labLine) {
        _labLine = [[UIView alloc] init];
        _labLine.backgroundColor = [ChartsUtil C7];
        _labLine.hidden = YES;
    }
    return _labLine;
}

@end

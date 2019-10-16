//
//  CFDKLineButtonView.m
//  nntj_ftox
//
//  Created by zhangchangqing on 2017/10/11.
//  Copyright © 2017年 taojinzhe. All rights reserved.
//

#import "CFDKLineButtonView.h"
#import "CFDKLineVButton.h"
#import "CFDIndexSelectedView.h"

@interface CFDKLineButtonView()

@property (nonatomic,strong)CFDKLineVButton *vBtn;
@property (nonatomic,strong)CFDKLineVButton *hBtn;

@property (nonatomic,strong)UIView *selectedBgView;
@property (nonatomic,strong)CFDKlineMinuteSelectView *selectedView;
@property (nonatomic,strong)CFDIndexSelectedView *selectedIndexView;


@property(nonatomic,assign)EChartsType iKLineType;
// segment数据
@property (nonatomic,strong) NSArray <NSDictionary *>*titles;
// segment 横屏下数据
@property (nonatomic,strong) NSArray <NSDictionary *>*hTitles;
@end



@implementation CFDKLineButtonView

- (void)dealloc
{
    [_selectedBgView removeFromSuperview];
    [_selectedView removeFromSuperview];
}

- (id)initWithTitles:(NSArray<NSDictionary *> *)titles hTitles:(NSArray<NSDictionary *> *)hTitles frame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titles = titles;
        _hTitles = hTitles;
        // Initialization code
        [self addSubView];
    }
    return self;
}

- (void)addSubView
{
    self.backgroundColor = [GColorUtil C6];
    [self addSubview:self.vBtn];
    [self addSubview:self.hBtn];
    
    WEAK_SELF;
    _vBtn.setKlineTypeBlock =
    _hBtn.setKlineTypeBlock =
    ^(NSInteger index,NSDictionary *config) {
        
        if ([NDataUtil boolWithDic:config key:@"more" isEqual:@"1"])
        {
            if ([NDataUtil boolWith:config[@"isIndex"]]) {
                weakSelf.selectedIndexView.config = weakSelf.getChartsSelectedIndex();
                [weakSelf showIndexSelected:index config:config];
            }else{
                //分钟k线菜单部分
                [weakSelf showMoreSelected:index config:config];
            }

        }else
        {
            weakSelf.iKLineType = [NDataUtil integerWith:config[@"chartsType"]];
            if (weakSelf.selectedChartsHander) {
                weakSelf.selectedChartsHander(weakSelf.iKLineType);
            }
            [weakSelf.vBtn  resetSelectedBtn];
        }
    };
}

- (void)clickedButtonList:(NSInteger)index{
    [_vBtn clickedButtonList:index];
}

//MARK: - SelectedView
- (void)tapAction:(UITapGestureRecognizer *)recognizer {
    
    [self hideSelectedView];
}

//显示k线选择菜单和背景
- (void)showIndexSelected:(NSInteger)index config:(NSDictionary *)config
{
    self.selectedBgView.hidden = self.selectedIndexView.superview.hidden = self.selectedIndexView.hidden = NO;
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    if (_selectedIndexView.superview==nil) {
        [window addSubview:self.selectedBgView];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.selectedIndexView.height*2)];
        bgView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:self.selectedIndexView];
        [window addSubview:bgView];
        WEAK_SELF;
        [bgView g_clickBlock:^(UITapGestureRecognizer *tap) {
            CGFloat pointY = [tap locationInView:tap.view].y;
            if (pointY<weakSelf.selectedIndexView.height) {
                [weakSelf hideSelectedView];
            }
        }];
        self.selectedIndexView.origin = CGPointMake(0, self.selectedIndexView.height);
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, self.selectedIndexView.height, SCREEN_WIDTH, self.selectedIndexView.height)];
        maskView.backgroundColor = [UIColor blackColor];
        bgView.maskView = maskView;
    }
    [window bringSubviewToFront:self.selectedIndexView.superview];
    CGPoint point = [self convertPoint:CGPointMake(0, self.bottom) toView:window];
    self.selectedIndexView.superview.origin = CGPointMake(0, point.y-self.selectedIndexView.height);
    self.selectedBgView.alpha = 0;
    self.selectedIndexView.transform = CGAffineTransformMakeTranslation(0, -self.selectedIndexView.height);
    [UIView animateWithDuration:0.25 animations:^{
        self.selectedIndexView.transform = CGAffineTransformIdentity;
        self.selectedBgView.alpha = 1;
    }];
}

//显示k线选择菜单和背景
- (void)showMoreSelected:(NSInteger)index config:(NSDictionary *)config
{
    self.selectedBgView.hidden = self.selectedView.superview.hidden = self.selectedView.hidden = NO;
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    if (_selectedView.superview==nil) {
        [window addSubview:self.selectedBgView];
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.selectedView.height*2)];
        WEAK_SELF;
        [bgView g_clickBlock:^(UITapGestureRecognizer *tap) {
            CGFloat pointY = [tap locationInView:tap.view].y;
            if (pointY<weakSelf.selectedView.height) {
                [weakSelf hideSelectedView];
            }
        }];
        bgView.backgroundColor = [UIColor clearColor];
        [bgView addSubview:self.selectedView];
        [window addSubview:bgView];
        _selectedView.origin = CGPointMake(0, self.selectedView.height);
        UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, self.selectedView.height, SCREEN_WIDTH, self.selectedView.height)];
        maskView.backgroundColor = [UIColor blackColor];
        bgView.maskView = maskView;
    }
    [window bringSubviewToFront:self.selectedView.superview];
    CGPoint point = [self convertPoint:CGPointMake(0, self.bottom) toView:window];
    self.selectedView.superview.origin = CGPointMake(0, point.y-self.selectedView.height);
    self.selectedBgView.alpha = 0;
    self.selectedView.transform = CGAffineTransformMakeTranslation(0, -self.selectedView.height);
    [UIView animateWithDuration:0.25 animations:^{
        self.selectedView.transform = CGAffineTransformIdentity;
        self.selectedBgView.alpha = 1;
    }];
}
//隐藏k线选择菜单和背景
- (void)hideSelectedView
{
    if (_selectedIndexHander&&self.selectedIndexView.hidden==NO) {
        _selectedIndexHander(_selectedIndexView.config);
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.selectedView.transform = CGAffineTransformMakeTranslation(0, -self.selectedView.height);
        self.selectedIndexView.transform =CGAffineTransformMakeTranslation(0, -self.selectedIndexView.height);
        self.selectedBgView.alpha = 0;
    } completion:^(BOOL finished) {
        self.selectedBgView.hidden = self.selectedIndexView.superview.hidden= self.selectedView.superview.hidden = YES;
        self.selectedIndexView.transform =
        self.selectedView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark 分钟弹出菜单选择

//config:在SelectedView选中的数据 ，index在vBtn上的位置
-(void)setSelectMinuteBtn:(NSInteger)index  config:(NSDictionary*)config
{
    
    EChartsType chartsType=[config[@"chartsType"] integerValue];
    if (chartsType==EChartsType_UNKOWN) {
        return;
    }
    _iKLineType = chartsType;
    NSString *title = [NDataUtil stringWith:config[@"title"]];
    [self.vBtn changedSelected:index title:title];
    self.selectedChartsHander(chartsType);
    [self hideSelectedView];
}

- (void)vChartToHChart
{
    _hBtn.hidden = NO;
    _vBtn.hidden = YES;
    NSInteger index = 0;
    for (NSInteger i=0;i<_hTitles.count;i++) {
        NSDictionary *dic = _hTitles[i];
        EChartsType type = [NDataUtil integerWith:dic[@"chartsType"]];
        if (type==_iKLineType) {
            index=i;
        }
    }
    [self.hBtn clickedButtonList:index];
    _hBtn.frame =CGRectMake(0, 0, self.frame.size.width-CLineRight, self.height);
}

- (void)hChartToVChart
{
    _hBtn.hidden = YES;
    _vBtn.hidden = NO;
    NSInteger index = 0;
    for (NSInteger i=0;i<_titles.count;i++) {
        NSDictionary *dic = _titles[i];
        if ([NDataUtil boolWithDic:dic key:@"more" isEqual:@"1"]&&![NDataUtil boolWith:dic[@"isIndex"]]) {
            NSArray *data = [NDataUtil arrayWith:dic[@"moreTitles"]];
            for (NSDictionary *dict in data) {
                EChartsType type = [NDataUtil integerWith:dict[@"chartsType"]];
                if (type==_iKLineType) {
                    index = i;
                    NSString *title = [NDataUtil stringWith:dict[@"title"]];
                    [self.vBtn changedSelected:index title:title];
                    return;
                }
            }
        }else{
            EChartsType type = [NDataUtil integerWith:dic[@"chartsType"]];
            if (type==_iKLineType) {
                index = i;
                continue;
            }
        }
    }
    [self.vBtn clickedButtonList:index];
}

//MARK: - Getter

- (void)setSelectedIndexHander:(void (^)(NSMutableDictionary *))selectedIndexHander{
    _selectedIndexHander = selectedIndexHander;
    self.selectedIndexView.selectedIndexHander = selectedIndexHander;
}

- (CFDKLineVButton*)vBtn
{
    if (!_vBtn) {
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _vBtn = [[CFDKLineVButton alloc] initWithFrame:rect titles:_titles];
        
    }
    return _vBtn;
}

- (CFDKLineVButton*)hBtn
{
    if (!_hBtn) {
        CGRect rect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        _hBtn = [[CFDKLineVButton alloc] initWithFrame:rect titles:_hTitles];
        _hBtn.hidden = YES;
    }
    return _hBtn;
}

- (CFDKlineMinuteSelectView*)selectedView
{
    if (!_selectedView) {
        __block NSArray <NSDictionary *>*titles = nil;
        __block NSInteger index = -1;
        [_titles enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([NDataUtil boolWithDic:obj key:@"more" isEqual:@"1"]) {
                if (![NDataUtil boolWith:obj[@"isIndex"]]) {
                    titles = obj[@"moreTitles"];
                    index = idx;
                    *stop = YES;
                }
            }
        }];
        _selectedView = [[CFDKlineMinuteSelectView alloc] initWithTitles:titles frame:CGRectMake(0, 0, SCREEN_WIDTH, [GUIUtil fit:35])];
        _selectedView.index = index;
        _selectedView.hidden = YES;
        _selectedView.userInteractionEnabled=YES;
        WEAK_SELF;
        _selectedView.setSelectMinuteBtn = ^(NSInteger index, NSDictionary *config) {
            [weakSelf setSelectMinuteBtn:index config:config];
        };
    }
    return _selectedView;
}


- (CFDIndexSelectedView*)selectedIndexView
{
    if (!_selectedIndexView) {
        __block NSArray <NSArray *>*titles = nil;
        __block NSInteger index = -1;
        [_titles enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([NDataUtil boolWithDic:obj key:@"more" isEqual:@"1"]) {
                if ([NDataUtil boolWith:obj[@"isIndex"]]) {
                    titles = obj[@"moreTitles"];
                    index = idx;
                    *stop = YES;
                }
            }
        }];
        _selectedIndexView = [[CFDIndexSelectedView alloc] initWithTitles:titles frame:CGRectMake(0, 0, SCREEN_WIDTH, [GUIUtil fit:64])];
        _selectedIndexView.hidden = YES;
        _selectedIndexView.userInteractionEnabled=YES;
    }
    return _selectedIndexView;
}

- (UIView*)selectedBgView
{
    if (!_selectedBgView) {
        _selectedBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _selectedBgView.backgroundColor = [UIColor clearColor];
        _selectedBgView.hidden = YES;
        UITapGestureRecognizer *tap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                                action:@selector(tapAction:)];
        [tap setCancelsTouchesInView:NO];
        [_selectedBgView addGestureRecognizer:tap];
    }
    return _selectedBgView;
}


#pragma mark 横屏处理
- (EChartsType)selectHKlineBtnToChartsType:(NSInteger)selectKlineBtn
{
    EChartsType chartsType = EChartsType_RT;
    switch (selectKlineBtn) {
        case 0:
            chartsType = EChartsType_RT;
            break;
        case 1:
            chartsType = EChartsType_KL_1;
            break;
        case 2:
            chartsType = EChartsType_KL_3;
            break;
        case 3:
            chartsType = EChartsType_KL_5;
            break;
        case 4:
            chartsType = EChartsType_KL_15;
            break;
        case 5:
            chartsType = EChartsType_KL_30;
            break;
        case 6:
            chartsType = EChartsType_KL_60;
            break;
        case 7:
            chartsType = EChartsType_KL_240;
            break;
        case 8:
            chartsType = EChartsType_KL;
            break;
        case 9:
            chartsType = EChartsType_KL_MONTH;
            break;
        default:
            chartsType = EChartsType_RT;
            break;
    }
    return chartsType;
}



#pragma mark 竖屏处理
- (EChartsType)selectVKlineBtnToChartsType:(NSInteger)selectKlineBtn
{
    EChartsType chartsType = EChartsType_KL_30;
    switch (selectKlineBtn) {
        case 0:
            chartsType = EChartsType_KL_30;
            break;
        case 1:
            chartsType = EChartsType_KL_60;
            break;
        case 2:
            chartsType = EChartsType_KL_240;
            break;
        case 3:
            chartsType = EChartsType_KL;
            break;
        case 4:
            chartsType = EChartsType_KL_MONTH;
            break;
        default:
            chartsType = EChartsType_KL_30;
            break;
    }
    return chartsType;
}

@end


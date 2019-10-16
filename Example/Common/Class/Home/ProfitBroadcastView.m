//
//  ProfitBroadcastView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/27.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "ProfitBroadcastView.h"
#import "BaseScrollView.h"
#import "BaseView.h"
#import "BaseImageView.h"
#import "BaseLabel.h"

@interface QZHProfitAnimationView : BaseView
@property (nonatomic,strong)BaseImageView *imgView1;
@property (nonatomic,strong)BaseImageView *imgView2;
@property (nonatomic,strong)BaseLabel *firstlabel;
@property (nonatomic,strong)BaseLabel *secondlabel;

@property (nonatomic,strong)BaseScrollView *scrollview;
@end
@implementation QZHProfitAnimationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self addSubview:self.scrollview];
        [self.scrollview addSubview:self.imgView1];
        [self.scrollview addSubview:self.firstlabel];
        [self.scrollview addSubview:self.imgView2];
        [self.scrollview addSubview:self.secondlabel];
        [_scrollview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [_imgView1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.centerY.equalTo(self.firstlabel);
        }];
        [_firstlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView1.mas_right).mas_offset([GUIUtil fit:5]);
            make.top.mas_equalTo(0);
            make.height.equalTo(self);
        }];
        [_imgView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([GUIUtil fit:15]);
            make.centerY.equalTo(self.secondlabel);
        }];
        [_secondlabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imgView2.mas_right).mas_offset([GUIUtil fit:5]);
            make.top.equalTo(self.firstlabel.mas_bottom);
            make.height.equalTo(self);
            make.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)reloadData:(NSString *)tetx comtext:(NSString *)comtext
{
    if(comtext.length){
        
        self.firstlabel.text = comtext;
        self.secondlabel.text = tetx;
        [self startAnimation];
        
    }
    else{
        
        self.firstlabel.text = tetx;
    }
    
}


- (void)startAnimation
{
    WEAK_SELF;
    [UIView animateWithDuration:.5 animations:^{
        weakSelf.scrollview.contentOffset = CGPointMake(0, weakSelf.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        weakSelf.firstlabel.attributedText = weakSelf.secondlabel.attributedText;
        weakSelf.scrollview.contentOffset = CGPointMake(0, 0);
        
    }];
}
#pragma mark ----- setter and getter

- (BaseImageView *)imgView1{
    if (!_imgView1) {
        _imgView1 = [[BaseImageView alloc] init];
        _imgView1.imageName = @"home_icon_message";
    }
    return _imgView1;
}
- (BaseImageView *)imgView2{
    if (!_imgView2) {
        _imgView2 = [[BaseImageView alloc] init];
        _imgView2.imageName = @"home_icon_message";
    }
    return _imgView2;
}

- (BaseLabel *)firstlabel
{
    if(!_firstlabel)
    {
        _firstlabel = [BaseLabel new];
        _firstlabel.txColor = C2_ColorType;
        _firstlabel.font  = [GUIUtil fitFont:12];
        _firstlabel.frame = CGRectMake([GUIUtil fit:15], 0, self.frame.size.width-[GUIUtil fit:20], self.frame.size.height);
    }
    return _firstlabel;
}

- (BaseLabel *)secondlabel
{
    if(!_secondlabel)
    {
        _secondlabel = [BaseLabel new];
        _secondlabel.txColor = C2_ColorType;
        _secondlabel.font  = [GUIUtil fitFont:12];
        _secondlabel.frame = CGRectMake([GUIUtil fit:15], self.frame.size.height, self.frame.size.width-[GUIUtil fit:20], self.frame.size.height);
    }
    return _secondlabel;
}

- (BaseScrollView *)scrollview
{
    if(!_scrollview)
    {
        _scrollview = [[BaseScrollView alloc]initWithFrame:self.frame];
        _scrollview.bgColor = C6_ColorType;
        _scrollview.pagingEnabled = YES;
        _scrollview.scrollEnabled = NO;
        _scrollview.showsVerticalScrollIndicator   = NO;
        _scrollview.showsHorizontalScrollIndicator = NO;
    }
    return _scrollview;
}
@end


@interface ProfitBroadcastView ()<CAAnimationDelegate>
@property (nonatomic,strong)BaseView  *topline;
@property (nonatomic,strong)QZHProfitAnimationView *anView;

@end
@implementation ProfitBroadcastView

- (id)init
{
    self = [super init];
    if(self)
    {
        [self initSubviews];
        [self initLayout];
    }
    return self;
}

- (void)initSubviews
{
    [self addSubview:self.anView];
    [self addSubview:self.topline];
}

- (void)initLayout
{
    [self.topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(.5);
    }];
    [_anView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}

- (void)reloadData:(NSString *)tetx comtext:(NSString *)comtext
{
    [_anView reloadData:tetx comtext:comtext];
}



#pragma mark --- setter and getter
- (BaseView *)topline
{
    if(!_topline)
    {
        _topline = [BaseView new];
        _topline.bgColor = C7_ColorType;
    }
    return _topline;
}

- (QZHProfitAnimationView *)anView
{
    if(!_anView)
    {
        _anView = [[QZHProfitAnimationView alloc]init];
    }
    return _anView;
}

@end


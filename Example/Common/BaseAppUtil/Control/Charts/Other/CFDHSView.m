//
//  CFDHSView.m
//  globalwin
//
//  Created by ngw15 on 2018/9/1.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "CFDHSView.h"
#import "HIndexSelectedView.h"
#import "View.h"

@interface CFDHSView()

@property (nonatomic,strong)NSMutableDictionary *config;
@property (nonatomic,strong)NSArray <NSDictionary *>*list;

@property (nonatomic,strong)UIView *topView;
@property (nonatomic,strong)UIButton *closeBtn;
@property (nonatomic,strong)UIButton *watchListBtn;
@property (nonatomic,strong)UIImageView *demoMarkImg;
@property (nonatomic,strong)UIImageView *tradeTypeImg;
@property (nonatomic,strong)UILabel *nameLabel;
@property (nonatomic,strong)UILabel *priceLabel;
@property (nonatomic,strong)UILabel *raiseVaule;
@property (nonatomic,strong)UILabel *raiseRate;
@property (nonatomic,strong)NSMutableArray <SingleInfoView *>*listView;
@property (nonatomic,strong)UIView *lineView;


@property (nonatomic,strong)HIndexSelectedView *indexView;
//@property (nonatomic, strong) QZHLSTradeSelectView* tradeSelectView;
@property (nonatomic, assign)BOOL isReal;
@end

@implementation CFDHSView

- (instancetype)initWithIsReal:(BOOL)isReal
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH);
        _isReal = isReal;
        _topHeight = [ChartsUtil fit:55];
        _rightHeight = [ChartsUtil fit:55];
        _listView = [NSMutableArray array];
        [self setupUI];
        [self autoLayout];
      
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.topView];
    [self.topView addSubview:self.watchListBtn];
    [self.topView addSubview:self.demoMarkImg];
    [self.topView addSubview:self.tradeTypeImg];
    [self.topView addSubview:self.nameLabel];
    [self.topView addSubview:self.priceLabel];
    [self.topView addSubview:self.raiseVaule];
    [self.topView addSubview:self.raiseRate];
    [self.topView addSubview:self.closeBtn];
    [self addSubview:self.indexView];
    for (int i=0;i<4;i++) {
        SingleInfoView *singleView = [[SingleInfoView alloc] init];
        singleView.alignment = SingleInfoAlignmentSide;
        [self.topView addSubview:singleView];
        [_listView addObject:singleView];
        [singleView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo([self leftBy:i]);
            make.width.mas_equalTo([self widthBy:i]);
            make.top.mas_equalTo([self topBy:i]);
        }];
    }
    [self.topView addSubview:self.lineView];
    
}

- (void)autoLayout{
    NSInteger nChartLeftPos = IS_IPHONE_X?40:5;
    _topView.frame = CGRectMake(nChartLeftPos, 0, SCREEN_HEIGHT-nChartLeftPos-IPHONE_X_BOTTOM_HEIGHT, self.topHeight);
    _indexView.frame = CGRectMake(_topView.right-self.rightHeight, self.topHeight+[GUIUtil fit:20], self.rightHeight, (SCREEN_WIDTH-self.topHeight-[GUIUtil fit:20]));
//    [_indexView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.topHeight+[GUIUtil fit:20]);
//        make.height.mas_equalTo((SCREEN_WIDTH-self.topHeight-[GUIUtil fit:20]));
//        make.width.mas_equalTo(self.rightHeight);
//        make.right.mas_equalTo(-IPHONE_X_BOTTOM_HEIGHT);
//    }];
//    [_topView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(nChartLeftPos);
//        make.right.mas_equalTo(-IPHONE_X_BOTTOM_HEIGHT);
//        make.height.mas_equalTo(self.topHeight);
//        make.top.mas_equalTo(0);
//    }];
    [_watchListBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ChartsUtil fit:10]);
        make.centerY.mas_equalTo(0);
    }];
    [_tradeTypeImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.watchListBtn.mas_right).mas_offset([ChartsUtil fit:15]);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo([ChartsUtil fitWidth:19 height:19]);
    }];
    [_demoMarkImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.equalTo(self.tradeTypeImg);
    }];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:30]);
        make.centerY.mas_equalTo(0);
        make.width.mas_equalTo([ChartsUtil fit:80]);
    }];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([ChartsUtil fit:120]);
        make.top.mas_equalTo([ChartsUtil fit:10]);
        make.width.mas_equalTo([ChartsUtil fit:120]);
    }];
    [_raiseVaule mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceLabel);
        make.top.equalTo(self.priceLabel.mas_bottom).mas_offset([ChartsUtil fit:3]);
        
    }];
    [_raiseRate mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.raiseVaule);
        make.left.equalTo(self.raiseVaule.mas_right).mas_offset([ChartsUtil fit:5]);
    }];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo([ChartsUtil fit:0]);
        make.height.mas_equalTo([ChartsUtil fitLine]);
    }];
    [_closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([ChartsUtil fit:-20]);
        make.centerY.mas_equalTo([GUIUtil fit:5]);
    }];
    
}

- (void)configOfView:(NSMutableDictionary *)config{
    if (![config isKindOfClass:[NSMutableDictionary class]]) {
        return;
    }
    NSArray *list = config[@"data"];
    if (![list isKindOfClass:[NSArray class]]||list.count<=0) {
        return;
    }
    _config = config;
    {
        _nameLabel.text = [NDataUtil stringWith:config[@"name"]];
        _priceLabel.text = [NDataUtil stringWith:config[@"lastPrice"]];
        _raiseRate.text = [NDataUtil stringWith:config[@"updownRate"]];
        _raiseVaule.text = [NDataUtil stringWith:config[@"updown"]];
        if ([_raiseRate.text hasPrefix:@"+"]) {
            _raiseRate.textColor =
            _raiseVaule.textColor=
            _priceLabel.textColor=[ChartsUtil C9];
        }else if ([_raiseRate.text hasPrefix:@"-"]){
            _raiseRate.textColor =
            _raiseVaule.textColor=
            _priceLabel.textColor=[ChartsUtil C10];
        }else{
            _raiseRate.textColor =
            _raiseVaule.textColor=
            _priceLabel.textColor=[ChartsUtil C2];
        }
    }
    _list = list;
    for (int i = 0; i<4; i++) {
        SingleInfoView *singleView = _listView[i];
        if (i<list.count) {
            [singleView configOfInfo:list[i]];
        }
    }
}

- (void)closeAction:(UIButton *)btn{
    [_delegate switchsScreenToV];
    _selectedIndexHander(_indexView.config);
}

- (void)setHidden:(BOOL)hidden{
    [super setHidden:hidden];
    if (hidden==NO&&_getChartsSelectedIndex) {
        [_indexView setConfig:_getChartsSelectedIndex()];
    }
}

//MARK:Getter

- (void)setSelectedIndexHander:(void (^)(NSMutableDictionary *))selectedIndexHander{
    _selectedIndexHander = selectedIndexHander;
    _indexView.selectedIndexHander = selectedIndexHander;
}

- (void)setChangedHander:(void (^)(NSDictionary *))changedHander{
//    WEAK_SELF;
//    _tradeSelectView.chooseBlock = ^(NSDictionary *dataDict) {
//        [weakSelf.delegate changedContradId:dataDict];
//    };
}

- (HIndexSelectedView *)indexView{
    if (!_indexView) {
        NSArray *tem = @[@(EIndexTopTypeMa),@(EIndexTopTypeBool)];
        NSArray *tem1 = @[@(EIndexTypeMacd),@(EIndexTypeKdj),@(EIndexTypeRsi),@(EIndexTypeWR)];
        _indexView = [[HIndexSelectedView alloc] initWithTitles:@[tem,tem1] frame:CGRectZero];
        _indexView.backgroundColor = [GColorUtil C6];
    }
    return _indexView;
}

- (UIView *)topView{
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [GColorUtil C6];
    }
    return _topView;
}

- (UIButton *)watchListBtn{
    if (!_watchListBtn) {
        _watchListBtn = [[UIButton alloc] init];
        [_watchListBtn setImage:[GColorUtil imageNamed:@"landscape_trade_search"] forState:UIControlStateNormal];
        [_watchListBtn g_clickEdgeWithTop:10 bottom:15 left:10 right:20];
    }
    return _watchListBtn;
}

- (UIImageView *)demoMarkImg{
    if (!_demoMarkImg) {
        _demoMarkImg = [[UIImageView alloc] initWithImage:[GColorUtil imageNamed:@"landscape_trade_demo"]];
        _demoMarkImg.hidden = _isReal;
    }
    return _demoMarkImg;
}

- (UIImageView *)tradeTypeImg{
    if (!_tradeTypeImg) {
        _tradeTypeImg = [[UIImageView alloc] init];
    }
    return _tradeTypeImg;
}

- (UILabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textColor = [ChartsUtil C2];
        _nameLabel.font = [ChartsUtil fitBoldFont:16];
        _nameLabel.numberOfLines = 1;
        _nameLabel.text = @" ";
        _nameLabel.minimumScaleFactor=0.5;
        _nameLabel.adjustsFontSizeToFitWidth = YES;
    }
    return _nameLabel;
}

- (UILabel *)priceLabel{
    if (!_priceLabel) {
        _priceLabel = [[UILabel alloc] init];
        _priceLabel.font = [ChartsUtil fitBoldFont:16];
        _priceLabel.text = @" ";
        _priceLabel.adjustsFontSizeToFitWidth = YES;
        _priceLabel.minimumScaleFactor = 0.3;
    }
    return _priceLabel;
}

- (UILabel *)raiseVaule{
    if (!_raiseVaule) {
        _raiseVaule = [[UILabel alloc] init];
        _raiseVaule.font = [ChartsUtil fitBoldFont:12];
        _raiseVaule.text = @" ";
    }
    return _raiseVaule;
}
- (UILabel *)raiseRate{
    if (!_raiseRate) {
        _raiseRate = [[UILabel alloc] init];
        _raiseRate.font = [ChartsUtil fitBoldFont:12];
        _raiseRate.text = @" ";
    }
    return _raiseRate;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor =[ChartsUtil C7];
        _lineView.hidden = YES;
    }
    return _lineView;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_closeBtn setImage:[GColorUtil imageNamed:@"market_icon_full2"] forState:(UIControlStateNormal)];
        [_closeBtn g_clickEdgeWithTop:10 bottom:10 left:10 right:10];
    }
    return _closeBtn;
}

//- (QZHLSTradeSelectView *)tradeSelectView
//{
//    if(!_tradeSelectView)
//    {
//        WEAK_SELF;
//        _tradeSelectView = [[QZHLSTradeSelectView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_HEIGHT, SCREEN_WIDTH)]; _tradeSelectView.chooseBlock = ^(NSDictionary *dataDict) {
////            [weakSelf.delegate changedContradId:dataDict];
//        };
//    }
//    return _tradeSelectView;
//}

//MARK: - Private

- (CGFloat)leftBy:(NSInteger)index{
    switch (index%2) {
        case 0:
            return [ChartsUtil fit:390];
        case 1:
            return [ChartsUtil fit:490];
        
        default:
            return 0;
    }
}

- (CGFloat)widthBy:(NSInteger)index{
//    if (index==2||index==5) {
//        return [ChartsUtil fit:72];
//    }
    return [ChartsUtil fit:90];
}

- (CGFloat)topBy:(NSInteger)index{
    switch (index/2) {
        case 0:
            return [ChartsUtil fit:12];
        case 1:
            return [ChartsUtil fit:35];
        default:
            return 0;
    }
}

/*
- (void)keyboardH{
    NSUInteger windowCount = [[[UIApplication sharedApplication] windows] count];
    if(windowCount < 2) {
        return;
    }
    UIWindow *keyboardWindow = [[[UIApplication sharedApplication] windows] lastObject];
    keyboardWindow.bounds =CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width);
    keyboardWindow.center = CGPointMake([[UIScreen mainScreen] bounds].size.width*0.5f,[[UIScreen mainScreen] bounds].size.height*0.5f);
    keyboardWindow.transform = CGAffineTransformMakeRotation(M_PI_2);
    keyboardWindow.left=-[[UIScreen mainScreen] bounds].size.width;
    keyboardWindow.top=0;
    keyboardWindow.hidden = YES;
    [NTimeUtil run:^{
        keyboardWindow.hidden = NO;
        [UIView animateWithDuration:0.25 animations:^{
            keyboardWindow.left=0;
        }];
    } delay:0.25];
}

- (void)showMaskView{
    UIView *view = [[[UIApplication sharedApplication].delegate window] viewWithTag:87312];
    if (view!=nil) {
        return;
    }
    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    maskView.backgroundColor = [UIColor clearColor];
    WEAK_SELF;
    [maskView g_clickBlock:^(UITapGestureRecognizer *tap) {
        UIView *view = [[[UIApplication sharedApplication].delegate window] viewWithTag:87312];
        [view removeFromSuperview];
        view = nil;
        [weakSelf endEditing:YES];
    }];
    maskView.tag = 87312;
    [[[UIApplication sharedApplication].delegate window] addSubview:maskView];
}
*/
@end

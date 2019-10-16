//
//  CFDMLineCursorView.m
//  MyKLineView
//
//  Created by Han on 13-9-27.
//  Copyright (c) 2013年 Han. All rights reserved.
//

#import "CFDCursorView.h"
#import "MarkView.h"
#import "NSDate+Additions.h"
#import "View.h"

@interface CFDCursorInfoView : UIView

@property (nonatomic,strong)NSMutableArray <SingleInfoView *>*singViews;
@property (nonatomic,strong)NSArray *config;

@end

@implementation CFDCursorInfoView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [GColorUtil colorWithHex:0x000000 alpha:0.6];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    _singViews = [NSMutableArray array];
    SingleInfoView *lastInfoView = nil;
    for (int i =0; i<8; i++) {
        SingleInfoView *infoView = self.singleView;
        [self addSubview:infoView];
        [_singViews addObject:infoView];
        [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==0) {
                make.top.mas_equalTo([GUIUtil fit:5]);
            }
            make.left.mas_equalTo([GUIUtil fit:5]);
            make.width.mas_equalTo([GUIUtil fit:100]);
            make.right.mas_equalTo([GUIUtil fit:-5]);
        }];
        lastInfoView = infoView;
    }
    [lastInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo([GUIUtil fit:-3]).priority(500);
    }];
}

- (void)configOfView:(NSArray *)list{
    if (![list isKindOfClass:[NSArray class]]||[list count]<=0) {
        return;
    }
    _config = list;
    SingleInfoView *lastInfoView = nil;
    for (int i =0; i<_config.count; i++) {
        SingleInfoView *infoView= _singViews[i];
        NSInteger listCount = list.count;
        if (i<listCount) {
            NSDictionary *dic = [NDataUtil dataWithArray:list index:i];
            if (lastInfoView) {
                [infoView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastInfoView.mas_bottom).mas_offset([GUIUtil fit:3]);
                }];
            }
            infoView.hidden = NO;
            [infoView configOfInfo:dic];
            lastInfoView = infoView;
        }else{
            infoView.hidden = YES;
        }
    }
    if(list.count>_singViews.count){
        for (NSInteger i =_singViews.count; i<list.count; i++) {
            SingleInfoView *infoView = self.singleView;
            infoView.hidden = NO;
            [self addSubview:infoView];
            [_singViews addObject:infoView];
            [infoView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo([GUIUtil fit:5]);
                make.width.mas_equalTo([GUIUtil fit:100]);
                make.right.mas_equalTo([GUIUtil fit:-5]);
            }];
            if (lastInfoView) {
                [lastInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(lastInfoView.mas_bottom).mas_offset([GUIUtil fit:3]);
                }];
            }else{
                [infoView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.top.mas_equalTo([GUIUtil fit:5]);
                }];
            }
            
            [infoView configOfInfo:[NDataUtil dataWithArray:list index:i]];
            lastInfoView = infoView;
        }
    }
    [lastInfoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo([GUIUtil fit:-3]);
    }];
}

- (SingleInfoView *)singleView{
    SingleInfoView *singView =[[SingleInfoView alloc] init];
    singView.alignment = SingleInfoAlignmentSide;
    [singView setKeyFont:[GUIUtil fitFont:8]];
    [singView setValueFont:[GUIUtil fitFont:8]];
    [singView setKeyColor:C5_ColorType];
    [singView setKeyAlpha:0.8];
    [singView setValueColor:C3_ColorType];
    [singView setKeyTheme:YES];
    [singView setValueTheme:YES];
    singView.hidden = YES;
    return singView;
}

@end

@interface CFDCursorView()

@property(nonatomic,strong)UILongPressGestureRecognizer *longPressGestureRecognizer;
@property(nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,strong)CAShapeLayer *focusLayer;
@property (nonatomic,strong)UILabel *dateLabel;

@property (nonatomic,strong)CFDCursorInfoView *cursorInfoView;
@property (nonatomic,strong)MASConstraint *masInfoViewLeft;
@property (nonatomic,strong)MASConstraint *masInfoViewRight;
@end

@implementation CFDCursorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self.layer addSublayer:self.focusLayer];
        [self addSubview:self.dateLabel];
        [self addSubview:self.cursorInfoView];
        [self showFousce:NO];
        WEAK_SELF;
        [_cursorInfoView mas_makeConstraints:^(MASConstraintMaker *make) {
            weakSelf.masInfoViewLeft = make.left.mas_equalTo([GUIUtil fit:5]);
            weakSelf.masInfoViewRight = make.right.mas_equalTo([GUIUtil fit:-15]).priority(750);
            make.top.mas_equalTo([GUIUtil fit:20]);
        }];
        
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                           initWithTarget:self
                                           action:@selector(handleLongPressGestures:)];
        /* numberOfTouchesRequired这个属性保存了有多少个手指点击了屏幕,因此你要确保你每次的点击手指数目是一样的,默认值是为 0. */
        self.longPressGestureRecognizer.numberOfTouchesRequired = 1;
        /*最大100像素的运动是手势识别所允许的*/
        self.longPressGestureRecognizer.allowableMovement = 100.0f;
        /*这个参数表示,两次点击之间间隔的时间长度。*/
        self.longPressGestureRecognizer.minimumPressDuration = 0.3;
        [self addGestureRecognizer:self.longPressGestureRecognizer];

    }
    return self;
}

- (BOOL)isShowFocus{
    return !self.focusLayer.isHidden;
}

//MARK: - Action

-(void)touchBeEnd
{
    [self drawFousce];
    [self showFousce:NO];
}

-(void)touchBeginPosition:(CGPoint)aPoint
{
    if([self.posotionList count]==0)
        return;
    
    CGFloat MLineW = self.frame.size.width/_nfenshiCount;
    NSInteger selected = aPoint.x/MLineW;
    
    NSLog(@"[self.posotionList count]=%lu, selected=%ld",(unsigned long)[self.posotionList count],selected);
    
    if ((selected >= [self.posotionList count])||selected<0)
    {
        //这句在上面，放下面，出了左面的外面会当成最大的很奇怪
        if (selected<0)
        {
            selected = 0;
            //            [self touchBeEnd];
            //            return;
        }
        
        if (selected >= [self.posotionList count])
        {
            selected = (int)[self.posotionList count] -1;
        }
    }
    
    NSLog(@"[self.posotionList count]1=%lu, selected=%ld",(unsigned long)[self.posotionList count],selected);
    
    CGPoint aTouch = [[NDataUtil dataWithArray:self.posotionList index:selected] CGPointValue];
    _selectedIndex = selected;
    NSMutableArray *dataArr1 = [[NSMutableArray alloc] init];;
    [dataArr1 addObject:[NSNumber numberWithFloat:aTouch.y]];
    [dataArr1 addObject:[NSNumber numberWithInteger:selected]];
    
    NSMutableArray *dataArr2 = [[NSMutableArray alloc] init];;
    [dataArr2 addObject:[NSNumber numberWithFloat:aTouch.x]];
    [dataArr2 addObject:[NSNumber numberWithInteger:selected]];
    
    
    [self drawFousce];
}

- (void) handleLongPressGestures:(UILongPressGestureRecognizer *)longGestures
{//长按
    if (![longGestures isEqual:self.longPressGestureRecognizer])
    {
        return;
    }
    CGPoint touchPoint = [longGestures locationOfTouch:0 inView:longGestures.view];
    
    if (longGestures.state==UIGestureRecognizerStateBegan) {
        [self showFousce:YES];
        [self touchBeginPosition:touchPoint];
    }else if (longGestures.state==UIGestureRecognizerStateChanged) {
        [self touchBeginPosition:touchPoint];
    }
    else if (longGestures.state ==UIGestureRecognizerStateEnded||longGestures.state ==UIGestureRecognizerStateCancelled||
        longGestures.state ==UIGestureRecognizerStateFailed)
    {
        [self touchBeEnd];
    }
}

- (void)drawFousce{
    
    NSInteger index = _selectedIndex;
    CGPoint aTouch = [[NDataUtil dataWithArray:self.posotionList index:_selectedIndex] CGPointValue];
    if (CGPointEqualToPoint(aTouch, CGPointZero))
    {
        return;
    }
    CGPoint point = CGPointMake(aTouch.x, aTouch.y);
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL, point.x, 0);
    CGPathAddLineToPoint(path, NULL, point.x, self.height);
    
//    if (self.bottomLineH<self.height) {
//        CGPathMoveToPoint(path,NULL, point.x, self.bottomLineH);
//        CGPathAddLineToPoint(path,NULL, point.x, self.height);
//    }
    
    CGPathMoveToPoint(path,NULL, 0, point.y);
    CGPathAddLineToPoint(path,NULL, self.frame.size.width, point.y);
    _focusLayer.path = path;
    CGPathRelease(path);
    
    CFDLineData *cell = [NDataUtil dataWithArray:self.dataList index:index];
    NSString *lastPrice = cell.iNowv;
    NSString *date = cell.iCursorTimeText;
    CGSize size = [ChartsUtil sizeWith:date fontSize:[ChartsUtil fitFontSize:8]];
    _dateLabel.size = CGSizeMake(size.width+6, size.height);
    _dateLabel.bottom = self.height+1-[GUIUtil fit:5];
    _dateLabel.centerX = point.x;
    if (_dateLabel.left<0) {
        _dateLabel.left=0;
    }
    if (_dateLabel.right>self.frame.size.width) {
        _dateLabel.right=self.frame.size.width;
    }
    _dateLabel.text = date;
    
    {
//        UIColor *openColor = [GColorUtil colorWithColorType:C6_ColorType alpha:0.6];
        ColorType openColor = C5_ColorType;
        CGFloat openAlpha = 0.6;
        if([cell.iOpenp floatValue]>[cell.iPreclose floatValue]){
            openColor = C11_ColorType;
            openAlpha = 1;
        }else if ([cell.iOpenp floatValue]<[cell.iPreclose floatValue]){
            openColor = C12_ColorType;
            openAlpha = 1;
        }
        
//        UIColor *highColor = [GColorUtil colorWithColorType:C6_ColorType alpha:0.6];
        ColorType highColor = C5_ColorType;
        CGFloat highAlpha = 0.6;
        if([cell.iHighp floatValue]>[cell.iPreclose floatValue]){
            highColor = C11_ColorType;
            highAlpha =1 ;
        }else if ([cell.iHighp floatValue]<[cell.iPreclose floatValue]){
            highColor = C12_ColorType;
            highAlpha =1 ;
        }
        
//        UIColor *lowColor = [GColorUtil colorWithColorType:C6_ColorType alpha:0.6];
        ColorType lowColor = C5_ColorType;
        CGFloat lowAlpha = 0.6;
        if([cell.iLowp floatValue]>[cell.iPreclose floatValue]){
            lowColor = C11_ColorType;
            lowAlpha = 1;
        }else if ([cell.iLowp floatValue]<[cell.iPreclose floatValue]){
            lowColor = C12_ColorType;
            lowAlpha = 1;
        }
        
//        UIColor *lastColor = [GColorUtil colorWithColorType:C6_ColorType alpha:0.6];
        ColorType lastColor = C5_ColorType;
        CGFloat lastAlpha = 0.6;
        if([cell.iNowv floatValue]>[cell.iPreclose floatValue]){
            lastColor = C11_ColorType;
            lastAlpha = 1;
        }else if ([cell.iNowv floatValue]<[cell.iPreclose floatValue]){
            lastColor = C12_ColorType;
            lastAlpha = 1;
        }
        NSDictionary *dic = @{@"key":CFDLocalizedString(@"时间"),@"value":cell.iCursorTimeText,@"color":[GColorUtil colorWithColorType:C6_ColorType alpha:0.6],@"colortype":@(C5_ColorType),@"alpha":@(0.6)};
        NSDictionary *dic4 = @{@"key":CFDLocalizedString(@"涨跌额"),@"value":cell.iUpdown,@"colortype":@(lastColor),@"alpha":@(lastAlpha)};
        NSDictionary *dic5 = @{@"key":CFDLocalizedString(@"涨跌幅"),@"value":cell.iUpdownRate,@"colortype":@(lastColor),@"alpha":@(lastAlpha)};
        NSDictionary *dic0 = @{@"key":CFDLocalizedString(@"开盘价"),@"value":cell.iOpenp?:@"--",@"colortype":@(openColor),@"alpha":@(openAlpha)};
        NSDictionary *dic1 = @{@"key":CFDLocalizedString(@"最高价"),@"value":cell.iHighp?:@"--",@"colortype":@(highColor),@"alpha":@(highAlpha)};
        NSDictionary *dic2 = @{@"key":CFDLocalizedString(@"最低价"),@"value":cell.iLowp?:@"--",@"colortype":@(lowColor),@"alpha":@(lowAlpha)};
        NSArray *tem = nil;
        if ([cell isKindOfClass:[CFDMLineData class]]) {
            NSDictionary *dic6 = @{@"key":CFDLocalizedString(@"价格"),@"value":cell.iNowv,@"colortype":@(lastColor),@"alpha":@(lastAlpha)};
            tem = @[dic,dic6,dic0,dic1,dic2,dic4,dic5];
        }else{
            NSDictionary *dic3 = @{@"key":CFDLocalizedString(@"收盘价"),@"value":cell.iNowv,@"colortype":@(lastColor),@"alpha":@(lastAlpha)};
            tem = @[dic,dic0,dic1,dic2,dic3,dic4,dic5];
        }
        [_cursorInfoView configOfView:tem];
        if (index>self.dataList.count/2) {
            [_masInfoViewLeft activate];
            [_masInfoViewRight deactivate];
        }else{
            [_masInfoViewLeft deactivate];
            [_masInfoViewRight activate];
        }
    }
    
    _axisCursorHander(lastPrice,index==self.dataList.count-1);
    if (_indexCursorHander) {
        _indexCursorHander((CFDKLineData *)cell);
    }
}

- (void)showFousce:(BOOL)flag{
    _focusLayer.hidden =
    _dateLabel.hidden = !flag;
    _cursorInfoView.hidden = !flag;
    if (flag==NO&&_axisCursorHander) {
        _axisCursorHander(nil,YES);
        if (_indexCursorHander) {
            _indexCursorHander(nil);
        }
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

//MARK: - Getter

- (CFDCursorInfoView *)cursorInfoView{
    if (!_cursorInfoView) {
        _cursorInfoView = [[CFDCursorInfoView alloc] init];
        _cursorInfoView.hidden = YES;
        _cursorInfoView.layer.cornerRadius = [GUIUtil fit:3];
        _cursorInfoView.layer.masksToBounds = YES;
    }
    return _cursorInfoView;
}

- (UILabel *)dateLabel{
    
    if (!_dateLabel) {
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.textColor = [ChartsUtil C5];
        _dateLabel.backgroundColor = [ChartsUtil C4];
        _dateLabel.font = [ChartsUtil fitBoldFont:8];
        _dateLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _dateLabel;
}

- (CAShapeLayer *)focusLayer{
    if (!_focusLayer) {
        _focusLayer = [[CAShapeLayer alloc] init];
        _focusLayer.fillColor = [UIColor clearColor].CGColor;
        _focusLayer.strokeColor   = [ChartsUtil C2].CGColor;
        _focusLayer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _focusLayer;
}

- (void)dealloc
{
    self.posotionList = nil;
    self.dataList = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

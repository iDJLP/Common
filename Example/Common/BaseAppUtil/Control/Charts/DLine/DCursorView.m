//
//  DCursorView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/30.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "DCursorView.h"
#import "MarkView.h"
#import "NSDate+Additions.h"

@interface DCursorView ()

@property(nonatomic,strong)UILongPressGestureRecognizer *longPressGestureRecognizer;
@property(nonatomic,assign)NSInteger selectedIndex;
@property (nonatomic,strong)CAShapeLayer *focusLayer;
@property (nonatomic,strong)UILabel *dateLabel;
@property (nonatomic,strong)UILabel *volLabel;
@property (nonatomic,strong)UIView *currentView;
@end

@implementation DCursorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        [self.layer addSublayer:self.focusLayer];
        [self addSubview:self.dateLabel];
        [self addSubview:self.volLabel];
        [self addSubview:self.currentView];
        [self showFousce:NO];
        
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
    
    CGFloat MLineW = self.width/_posotionList.count;
    NSInteger selected = aPoint.x/MLineW;
    selected = MAX(0,MIN(selected,_posotionList.count-1));
    _selectedIndex = selected;

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
    
 
    NSDictionary *dic = [NDataUtil dataWithArray:self.posotionList index:_selectedIndex];
    CGPoint aTouch = [dic[@"point"] CGPointValue];
    NSDictionary *data = [NDataUtil dictWith:dic[@"data"]];
    if (CGPointEqualToPoint(aTouch, CGPointZero))
    {
        return;
    }
//    CGMutablePathRef path = CGPathCreateMutable();
//    CGPathMoveToPoint(path, NULL, aTouch.x, 0);
//    CGPathAddLineToPoint(path, NULL, aTouch.x, self.height-CTimeAixsHight);
//    _focusLayer.path = path;
//    CGPathRelease(path);
    
    {
        NSString *vol = [NDataUtil stringWith:data[@"total"]];
        CGSize size = [ChartsUtil sizeWith:vol fontSize:[ChartsUtil fitFontSize:8]];
        _volLabel.size = CGSizeMake(size.width+6, size.height);
        _volLabel.center = CGPointMake(self.width-[GUIUtil fit:5], aTouch.y);
        _volLabel.text = vol;
    }
    {
        NSString *price = [NDataUtil stringWith:data[@"price"]];
        CGSize size = [ChartsUtil sizeWith:price fontSize:[ChartsUtil fitFontSize:8]];
        _dateLabel.size = CGSizeMake(size.width+6, size.height);
        _dateLabel.bottom = self.height+1-[GUIUtil fit:5];
        _dateLabel.centerX = aTouch.x;
        _dateLabel.text = price;
    }
    _currentView.center = aTouch;
}

- (void)showFousce:(BOOL)flag{
    _volLabel.hidden =
    _currentView.hidden =
    _focusLayer.hidden =
    _dateLabel.hidden = !flag;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return YES;
}

//MARK: - Getter

- (UIView *)currentView{
    if (!_currentView) {
        _currentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 6, 6)];
        _currentView.backgroundColor = [GColorUtil C21];
        _currentView.layer.cornerRadius = 3;
        _currentView.layer.masksToBounds = YES;
        _currentView.hidden = YES;
    }
    return _currentView;
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

- (UILabel *)volLabel{
    if (!_volLabel) {
        _volLabel = [[UILabel alloc] init];
        _volLabel.textColor = [ChartsUtil C5];
        _volLabel.backgroundColor = [ChartsUtil C4];
        _volLabel.font = [ChartsUtil fitBoldFont:8];
        _volLabel.textAlignment = NSTextAlignmentRight;
        _volLabel.layer.anchorPoint = CGPointMake(1, 0.5);
    }
    return _volLabel;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end


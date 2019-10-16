//
//  PieChartView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/9/26.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "PieChartView.h"
#import "PieRemarkRow.h"

@interface PieChartView ()

@property (nonatomic,strong) UIImageView *centerImgView;
@property (nonatomic,strong) UIView *contentView;
@property (nonatomic,strong) NSArray *dataList;
@property (nonatomic,strong) NSMutableArray <CAShapeLayer *> *layerList;
@property (nonatomic,strong) NSMutableArray <PieRemarkRow *> *remarkList;
@property (nonatomic,strong) NSMutableArray *angleList;
@property (nonatomic,strong) CAShapeLayer *selectedLayer;
@property (nonatomic,copy) BKCancellationToken delay;

@end

@implementation PieChartView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [GColorUtil C5];
        _layerList = [[NSMutableArray alloc] init];
        _remarkList = [[NSMutableArray alloc] init];
        [self addSubview:self.contentView];
    }
    return self;
}

- (void)updateList:(NSArray *)dataList{
    _dataList = dataList;
    [self setupUI];
}

- (void)setSelectedIndex:(NSInteger)index{
    _selectedLayer = [NDataUtil dataWithArray:_layerList index:index];
    [self setupUI];
    WEAK_SELF;
    _delay = [NTimeUtil run:^{
        weakSelf.selectedLayer = nil;
        [weakSelf setupUI];
    } delay:2];
}

- (void)setupUI{
    _angleList = [[NSMutableArray alloc] init];
    CGFloat padding = _dataList.count>1? 1.5:0;
    CGFloat all = padding*_dataList.count+100;
    CGFloat angle = 0;
    CGFloat centerX = CGPointEqualToPoint(_centerPoint, CGPointZero)?self.width/2:_centerPoint.x;
    CGFloat centerY = CGPointEqualToPoint(_centerPoint, CGPointZero)?self.height/2:_centerPoint.y;
    CGFloat lineWidth = [GUIUtil fit:30];
    CGFloat radius = centerX-lineWidth/2-[GUIUtil fit:30];
    if (_innerRadius>0&&_outerRadius>0) {
        radius = (_outerRadius + _innerRadius)/2;
        lineWidth = _outerRadius - _innerRadius;
    }
    _contentView.bounds = CGRectMake(0, 0, radius+[GUIUtil fit:150], radius+[GUIUtil fit:150]);
    _contentView.center = CGPointMake(centerX, centerY);
    for (NSInteger i=0; i<_dataList.count; i++) {
        NSDictionary *dict = [NDataUtil dictWithArray:_dataList index:i];
        CGFloat rate = [NDataUtil floatWith:dict[@"proportion"] valid:0];
        rate = rate/all;
        CGFloat endAngle = angle + rate*M_PI*2;
        PieRemarkRow *row = [NDataUtil dataWithArray:_remarkList index:i];
        if (row==nil) {
            row = self.row;
            row.centerPoint = CGPointMake(centerX, centerY);
            row.frame = CGRectMake(0, 0, self.width, self.height);
            [self.layer addSublayer:row];
            [self.remarkList addObject:row];
        }
        CAShapeLayer *shapelayer = [NDataUtil dataWithArray:_layerList index:i];
        if (shapelayer==nil) {
            shapelayer = self.shapelayer;
            shapelayer.frame = CGRectMake(0, 0, self.width, self.height);
            [self.layer addSublayer:shapelayer];
            [self.layerList addObject:shapelayer];
        }
        if (_selectedLayer==shapelayer&&_selectedLayer) {
            radius = centerX-lineWidth/2-[GUIUtil fit:30];
            if (_innerRadius>0&&_outerRadius>0) {
                radius = (_outerRadius + _innerRadius)/2;
                lineWidth = _outerRadius - _innerRadius;
            }
            shapelayer.lineWidth = lineWidth+[GUIUtil fit:10];
            radius = radius+[GUIUtil fit:5];
            row.outerRadio = radius+lineWidth/2+[GUIUtil fit:5];
        }else{
            shapelayer.lineWidth = lineWidth;
            radius = centerX-lineWidth/2-[GUIUtil fit:30];
            if (_innerRadius>0&&_outerRadius>0) {
                radius = (_outerRadius + _innerRadius)/2;
                lineWidth = _outerRadius - _innerRadius;
            }
            row.outerRadio = radius+lineWidth/2;
        }
        [row configOfRow:dict];
        [row updatePosition:(angle+endAngle)/2];
        shapelayer.hidden = NO;
        shapelayer.strokeColor = [GColorUtil colorWithHexString:[NDataUtil stringWith:dict[@"bgColor"]]].CGColor;
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddArc(path, NULL, centerX, centerY, radius, angle, endAngle, NO);
        shapelayer.path = path;
        CGPathRelease(path);
        NSDictionary *angleDic = @{@"begin":@(angle),@"end":@(endAngle),@"center":@((angle+endAngle)/2)};
        CGFloat paddingAngle = padding/all*M_PI*2;
        angle = endAngle + paddingAngle;
        [_angleList addObject:angleDic];
    }
    for (NSInteger i=_dataList.count; i<_layerList.count; i++) {
        CAShapeLayer *shapelayer = [NDataUtil dataWithArray:_layerList index:i];
        shapelayer.hidden = YES;
    }
    if (_selectedLayer) {
        if (_selectedHander) {
            NSInteger index = [_layerList indexOfObject:_selectedLayer];
            if (index!= NSNotFound) {
                _selectedHander(index);
            }
        }
    }else{
        if (_deSelectedHander) {
            _deSelectedHander();
        }
    }
}


- (CAShapeLayer *)shapelayer{
    
    CAShapeLayer *shapelayer = [[CAShapeLayer alloc] init];
    shapelayer.fillColor = [UIColor clearColor].CGColor;
    shapelayer.strokeColor   = [ChartsUtil C6].CGColor;      //设置划线颜色
    return shapelayer;
}

- (PieRemarkRow *)row{
    
    PieRemarkRow *row = [[PieRemarkRow alloc] init];
    return row;
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor clearColor];
        UILongPressGestureRecognizer *pressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(pressAction:)];
        pressGesture.minimumPressDuration = 0.01;
        [_contentView addGestureRecognizer:pressGesture];
    }
    return _contentView;
}

- (void)pressAction:(UILongPressGestureRecognizer *)press{
    WEAK_SELF;
    CGPoint point = [press locationInView:weakSelf.contentView];
    if (press.state==UIGestureRecognizerStateBegan) {
        [NTimeUtil cancelDelay:weakSelf.delay];
        weakSelf.delay = nil;
    }else if (press.state == UIGestureRecognizerStateChanged){
        CGFloat angle = 0;
        CGFloat centerX = weakSelf.contentView.width/2;
        CGFloat centerY = weakSelf.contentView.height/2;
        if (point.y>=centerY) {
            if (point.x>centerX) {
                //第四象限
                angle = atan((point.y-centerY)/(point.x - centerX));
            }else if (point.x==centerX){
                angle = M_PI_2;
            }
            else{
                //第三象限
                angle = M_PI- atan((point.y-centerY)/(centerX-point.x));
            }
        }else{
            if (point.x>centerX) {
                //第一象限
                angle = -atan((centerY-point.y)/(point.x - centerX))+M_PI*2;
            }else if (point.x==centerX){
                angle = M_PI_2*3;
            }
            else{
                //第二象限
                angle = atan((centerY-point.y)/(centerX-point.x))+M_PI;
            }
        }
        for (NSInteger i = 0; i<weakSelf.angleList.count; i++) {
            NSDictionary *dict = [NDataUtil dictWith:weakSelf.angleList[i]];
            CGFloat a = [NDataUtil floatWith:dict[@"end"] valid:0];
            if (angle<=a) {
                weakSelf.selectedLayer = [NDataUtil dataWithArray:weakSelf.layerList index:i];
                break;
            }
        }
        [weakSelf setupUI];
    }else if (press.state==UIGestureRecognizerStateEnded||press.state==UIGestureRecognizerStateCancelled){
        weakSelf.delay = [NTimeUtil run:^{
               weakSelf.selectedLayer = nil;
               [weakSelf setupUI];
           } delay:2];
    }
}

@end

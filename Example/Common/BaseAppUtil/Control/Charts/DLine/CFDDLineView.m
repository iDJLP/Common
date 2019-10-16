//
//  CFDMLineView.m
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "CFDDLineView.h"
#import "DCursorView.h"
#import "CFDScrollView.h"
#import "DemoChartsModel.h"
#import "DGirlLayer.h"


@interface CFDDLineView()

@property(nonatomic,strong)DCursorView *cursorView;

@property (nonatomic,strong)DGirlLayer *girlLayer;
@property (nonatomic,strong)CAShapeLayer *buyLayer;
@property (nonatomic,strong)CAShapeLayer *buyGradientLayer;
@property (nonatomic,strong)CAGradientLayer *buyFillLayer;

@property (nonatomic,strong)CAShapeLayer *sellLayer;
@property (nonatomic,strong)CAShapeLayer *sellGradientLayer;
@property (nonatomic,strong)CAGradientLayer *sellFillLayer;

///十字线上点的物理坐标
@property(atomic,strong)NSMutableArray *iPositionArr;


@property(atomic,strong)NSArray *dataList;
//http返回的数据是否已经绘图，（socket绘图需等http的绘完才能绘图）
@property (nonatomic,assign) BOOL hasLoadedFromHttp;

@property (nonatomic,strong) UIView *lineView;

@end

@implementation CFDDLineView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [GColorUtil C6];
        [self defaultData];
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    
    //分时
    [self.layer addSublayer:self.buyLayer];
    [self.layer addSublayer:self.buyFillLayer];
    
    [self.layer addSublayer:self.sellLayer];
    [self.layer addSublayer:self.sellFillLayer];
    
    //时间轴及线
    [self.layer addSublayer:self.girlLayer];
    
    //十字线
    [self addSubview:self.cursorView];
    
    [self addSubview:self.lineView];
    [_lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fitLine]);
    }];
}


- (void)defaultData{
    
    self.nDotNum = 2;
    self.iPositionArr = [[NSMutableArray alloc]init];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    CGFloat bottom = CTimeAixsHight +[GUIUtil fit:5];
    CGFloat top = [GUIUtil fit:25];
    self.buyFillLayer.frame     =
    self.buyLayer.frame    = CGRectMake(0, top, self.width/2.0-[GUIUtil fit:2.5], self.height-bottom-top);
    self.buyGradientLayer.frame = self.buyFillLayer.bounds;
    
    
    self.sellFillLayer.frame     =
    self.sellLayer.frame    = CGRectMake(self.width/2.0+[GUIUtil fit:2.5], top, self.width/2.0-[GUIUtil fit:2.5], self.height-bottom-top);
    self.sellGradientLayer.frame = self.sellFillLayer.bounds;
    
    self.girlLayer.frame     = CGRectMake(0, 0, self.width, self.height-[GUIUtil fit:5]);
    
    self.cursorView.frame = CGRectMake(0, top, self.width, self.height-[GUIUtil fit:5]-top);
    [CATransaction commit];
}

//MARK: - Action

- (BOOL)isFocusing{
    return [self.cursorView isShowFocus];
}

//MARK: - 计算

- (void)configData:(NSDictionary *)dic{
    [_iPositionArr removeAllObjects];
    NSArray *list = [NDataUtil arrayWith:dic[@"pankouList"]];
    NSString *maxVol = [NDataUtil stringWith:dic[@"totalVol"]];
    NSDictionary *buyDic = [NDataUtil dataWithArray:list index:0];
    NSString *buyMaxPrice = [NDataUtil stringWith:buyDic[@"maxPrice"] valid:@""];
    NSString *buyMinPrice = [NDataUtil stringWith:buyDic[@"minPrice"] valid:@""];
    NSArray *buyList = [NDataUtil arrayWith:buyDic[@"data"]];
    [self drawShareTime:buyList maxPirce:buyMaxPrice minPrice:buyMinPrice maxVol:maxVol isBuy:YES];
    
    NSDictionary *sellDic = [NDataUtil dataWithArray:list index:1];
    NSString *sellMaxPrice = [NDataUtil stringWith:sellDic[@"maxPrice"] valid:@""];
    NSString *sellMinPrice = [NDataUtil stringWith:sellDic[@"minPrice"] valid:@""];
    NSArray *sellList = [NDataUtil arrayWith:sellDic[@"data"]];
    [self drawShareTime:sellList maxPirce:sellMaxPrice minPrice:sellMinPrice maxVol:maxVol isBuy:NO];
//        buyMaxPrice = (sellMinPrice+buyMaxPrice)/2.0;
    NSString *centerPrice = [GUIUtil decimalAdd:buyMaxPrice num:sellMinPrice];
    centerPrice = [GUIUtil decimalDivide:centerPrice num:@"2"];
    [self.girlLayer configViewWithMinPrice:buyMinPrice maxPrice:sellMaxPrice centerPrice:centerPrice maxVol:maxVol];
    _dataList = @[buyList,sellList];
    [self showCursorView];
}

- (void)showCursorView{
    _cursorView.posotionList = self.iPositionArr;
}

- (void)clear{
    _hasLoadedFromHttp = NO;
}

//MARK: - Getter Setter

- (DCursorView *)cursorView
{
    if(!_cursorView)
    {
        _cursorView = [[DCursorView alloc] init];
    }
    return _cursorView;
}

- (DGirlLayer *)girlLayer{
    if (!_girlLayer) {
        _girlLayer = [[DGirlLayer alloc] init];
    }
    return _girlLayer;
}

- (CAShapeLayer *)buyLayer{
    if (!_buyLayer) {
        _buyLayer = [[CAShapeLayer alloc] init];
        _buyLayer.fillColor = [UIColor clearColor].CGColor;
        _buyLayer.strokeColor   = [ChartsUtil C11].CGColor;      //设置划线颜色
        _buyLayer.lineCap = kCALineCapRound;
        _buyLayer.lineJoin = kCALineJoinRound;
        _buyLayer.lineWidth     = [ChartsUtil fitLine]*2;          //设置线宽
        
    }
    return _buyLayer;
}

- (CAShapeLayer *)buyGradientLayer{
    if (!_buyGradientLayer) {
        
        _buyGradientLayer = [[CAShapeLayer alloc] init];
        
        _buyGradientLayer.fillColor = [ChartsUtil C13:0.1].CGColor;
        _buyGradientLayer.strokeColor   = [UIColor clearColor].CGColor;      //设置划线颜色
        _buyGradientLayer.lineWidth     = [ChartsUtil fitLine]*2;          //设置线宽
    }
    return _buyGradientLayer;
}

- (CAGradientLayer *)buyFillLayer{
    if (!_buyFillLayer) {
        _buyFillLayer =  [[CAGradientLayer alloc] init];
        _buyFillLayer.colors = @[(__bridge id)[ChartsUtil C11:1].CGColor,(__bridge id)[ChartsUtil C11:1].CGColor,(__bridge id)[ChartsUtil C11:0.3].CGColor,(__bridge id)[ChartsUtil C11:0.2].CGColor];
        _buyFillLayer.locations = @[@(0),@(0.3),@(0.8),@(1)];
        _buyFillLayer.startPoint = CGPointMake(1, 0);
        _buyFillLayer.endPoint = CGPointMake(0, 0);
    }
    return _buyFillLayer;
}

- (CAShapeLayer *)sellLayer{
    if (!_sellLayer) {
        _sellLayer = [[CAShapeLayer alloc] init];
        _sellLayer.fillColor = [UIColor clearColor].CGColor;
        _sellLayer.strokeColor   = [ChartsUtil C12].CGColor;      //设置划线颜色
        _sellLayer.lineCap = kCALineCapRound;
        _sellLayer.lineJoin = kCALineJoinRound;
        _sellLayer.lineWidth     = [ChartsUtil fitLine]*2;          //设置线宽
    }
    return _sellLayer;
}

- (CAShapeLayer *)sellGradientLayer{
    if (!_sellGradientLayer) {
        
        _sellGradientLayer = [[CAShapeLayer alloc] init];
        
        _sellGradientLayer.fillColor = [ChartsUtil C12:0.1].CGColor;
        _sellGradientLayer.strokeColor   = [UIColor clearColor].CGColor;      //设置划线颜色
        _sellGradientLayer.lineWidth     = [ChartsUtil fitLine]*2;          //设置线宽
    }
    return _sellGradientLayer;
}

- (CAGradientLayer *)sellFillLayer{
    if (!_sellFillLayer) {
        _sellFillLayer =  [[CAGradientLayer alloc] init];
        _sellFillLayer.colors = @[(__bridge id)[ChartsUtil C12:1].CGColor,(__bridge id)[ChartsUtil C12:1].CGColor,(__bridge id)[ChartsUtil C12:0.2].CGColor,(__bridge id)[ChartsUtil C12:0.2].CGColor];
        _sellFillLayer.locations = @[@(0),@(0.3),@(0.8),@(1)];
        _sellFillLayer.startPoint = CGPointMake(0, 0);
        _sellFillLayer.endPoint = CGPointMake(1, 0);
    }
    return _sellFillLayer;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = [GColorUtil C8];
    }
    return _lineView;
}

//MARK: - Private

- (void)drawShareTime:(NSArray *)dataList maxPirce:(NSString *)maxPrice minPrice:(NSString *)minPrice maxVol:(NSString *)maxVol isBuy:(BOOL)isBuy{
    CGMutablePathRef sharePath = CGPathCreateMutable();
    NSMutableArray *pointList = [NSMutableArray array];
    CGFloat x = 0.f;
    CGFloat y =0.f;
    for (int i=0;i<[dataList count];i++)
    {
        NSDictionary *cell = [NDataUtil dataWithArray:dataList index:i];
        CGFloat vol = [NDataUtil floatWith:cell[@"total"] valid:0];
        CGFloat price = [NDataUtil floatWith:cell[@"price"] valid:0];

        x = [self xByPrice:price minPrice:minPrice maxPrice:maxPrice];
        y = [self yByVol:vol maxVol:maxVol];
        //分时线
        if([NDataUtil IsInfOrNan:x] ||
           [NDataUtil IsInfOrNan:y])
        {
            return;
        }
        //触碰点
        CGPoint point = CGPointMake(x, y);
        [pointList addObject:@(point)];
        
        if (isBuy) {
            [_iPositionArr addObject:@{@"point":@(point),@"data":cell}];
        }else{
            CGPoint point1 = point;
            point1.x += self.width/2;
            [_iPositionArr addObject:@{@"point":@(point1),@"data":cell}];
        }
        
    }
    for (NSInteger i=0; i<pointList.count; i++) {
        CGPoint point = [pointList[i] CGPointValue];
        //分时的点
        if (i==0) {
            CGPathMoveToPoint(sharePath, NULL, point.x, point.y);
        }else{
            CGPathAddLineToPoint(sharePath, NULL, point.x,point.y);
        }
    }
    WEAK_SELF;
    if ([dataList count] >1 )//如果等于1会整个蓝框
    {
        [SortUtil quickSort:_iPositionArr isAscending:YES keyHander:^CGFloat(NSDictionary *dic) {
            NSValue *point = dic[@"point"];
            return [point CGPointValue].x;
        }];
        CGPoint point2 = [[pointList firstObject] CGPointValue];
        CGMutablePathRef fillPath = CGPathCreateMutableCopy(sharePath);
        CGPathAddLineToPoint(fillPath, NULL, x, self.buyFillLayer.height);
        
        CGPathAddLineToPoint(fillPath, NULL, point2.x, self.buyFillLayer.height);
        CGPathAddLineToPoint(fillPath, NULL, point2.x, point2.y);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (isBuy) {
                weakSelf.buyLayer.hidden =
                weakSelf.buyFillLayer.hidden = NO;
                weakSelf.buyLayer.path= sharePath;
                weakSelf.buyGradientLayer.path = fillPath;
                weakSelf.buyFillLayer.mask = weakSelf.buyGradientLayer;
            }else{
                weakSelf.sellLayer.hidden =
                weakSelf.sellFillLayer.hidden = NO;
                weakSelf.sellLayer.path= sharePath;
                weakSelf.sellGradientLayer.path = fillPath;
                weakSelf.sellFillLayer.mask = weakSelf.sellGradientLayer;
            }
            weakSelf.hasLoadedFromHttp = YES;
            CGPathRelease(sharePath);
            CGPathRelease(fillPath);
        });
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.buyLayer.hidden =
            weakSelf.buyGradientLayer.hidden =
            weakSelf.buyFillLayer.hidden = YES;
            
            weakSelf.sellLayer.hidden =
            weakSelf.sellGradientLayer.hidden =
            weakSelf.sellFillLayer.hidden = YES;
        });
    }
}

//计算x值
- (CGFloat)xByPrice:(CGFloat)curp minPrice:(NSString *)minPrice maxPrice:(NSString *)maxPrice{
    //分时线
    CGFloat padding = [maxPrice floatValue]-[minPrice floatValue];
    if (padding==0) {
        return self.buyLayer.width/2;
    }
    CGFloat rate = (curp-[minPrice floatValue])/padding;
    rate = MAX(0, MIN(1, rate));
    CGFloat x= self.buyLayer.width*rate;
    return x;
}

//计算y值
- (CGFloat)yByVol:(CGFloat)vol maxVol:(NSString *)maxVol{
    //分时线
    CGFloat padding = [maxVol floatValue];
    if (padding==0) {
        return self.buyLayer.height;
    }
    CGFloat rate = (vol)/padding;
    rate = MAX(0, MIN(1, rate));
    CGFloat y= (1-rate)*self.buyLayer.height;
    return y;
}

@end



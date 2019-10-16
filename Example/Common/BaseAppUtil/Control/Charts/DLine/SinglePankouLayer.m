//
//  SinglePankouView.m
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "SinglePankouLayer.h"

@interface SinglePankouLayer ()

@property (nonatomic,strong) CATextLayer *snTextLayer;
@property (nonatomic,strong) CATextLayer *priceTextLayer;
@property (nonatomic,strong) CATextLayer *volTextLayer;
@property (nonatomic,strong) CALayer *degreeLayer;
@property (nonatomic,copy) NSString *maxVol;
@property (nonatomic,copy) NSString *totalVol;
@end

@implementation SinglePankouLayer

- (void)dealloc{
    [self removeNotic];
}

- (instancetype)init{
    if (self = [super init]) {
        self.anchorPoint = CGPointMake(0, 0);
        [self addSublayer:self.snTextLayer];
        [self addSublayer:self.priceTextLayer];
        [self addSublayer:self.volTextLayer];
        [self addSublayer:self.degreeLayer];
        [self addNotic];
    }
    return self;
}

- (void)layoutSublayers{
    [super layoutSublayers];
    CGFloat snWidth = [GUIUtil fit:45];
    CGFloat leftPadding = [GUIUtil fit:15];
    CGFloat padding = [GUIUtil fit:3];
    if (_snTextLayer.hidden==YES) {
        _priceTextLayer.frame = CGRectMake(leftPadding, self.height/2, self.width-leftPadding-padding, [GUIUtil fitFont:_priceTextLayer.fontSize].lineHeight);
        _volTextLayer.frame = CGRectMake(padding, self.height/2, self.width-leftPadding+padding*3, [GUIUtil fitFont:_volTextLayer.fontSize].lineHeight);
        _priceTextLayer.position = _volTextLayer.position = CGPointMake(padding, self.height/2);
    }else{
        CGFloat left = _priceType == SinglePankouPriceTypeRight?snWidth:padding;
        _priceTextLayer.frame = CGRectMake(left, self.height/2, self.width-snWidth-padding, [GUIUtil fitFont:_priceTextLayer.fontSize].lineHeight);
        _volTextLayer.frame = CGRectMake(left, self.height/2, self.width-snWidth-padding, [GUIUtil fitFont:_volTextLayer.fontSize].lineHeight);
        _priceTextLayer.position = _volTextLayer.position = CGPointMake(left, self.height/2);
    }
    _snTextLayer.frame = CGRectMake(leftPadding, self.height/2, self.width-leftPadding*2+padding, [GUIUtil fitFont:_snTextLayer.fontSize].lineHeight);
    _snTextLayer.position = CGPointMake(leftPadding, self.height/2);
}

- (void)configData:(NSDictionary *)data maxVol:(nonnull NSString *)maxVol{
    
    //正常的赋值
    if (data.count>=2) {
        NSString *vol = [NDataUtil stringWithDict:data keys:@[@"quantity",@"s"] valid:@""];
        NSString *price = [NDataUtil stringWithDict:data keys:@[@"price",@"p"] valid:@""];
        NSString *total = [NDataUtil stringWithDict:data keys:@[@"total"] valid:@""];
        _totalVol = total;
        _priceTextLayer.string = price;
        _volTextLayer.string = vol;
        
        CGFloat width = 0;
        if (maxVol.floatValue>0) {
            CGFloat rate = [total floatValue]/maxVol.floatValue;
            width = self.width*rate;
        }
        CGFloat left = 0;
        if (_degreeType==SinglePankouDegreeTypeRight) {
            left = self.width-width;
        }
        _degreeLayer.frame = CGRectMake(left, 0, width, self.height);
    }
    //最大值变了
    else if (![_maxVol isEqualToString:maxVol]&&maxVol.length>0) {
        _maxVol = maxVol;
        CGFloat width = 0;
        
        if (maxVol.floatValue>0) {
            CGFloat rate = [_totalVol floatValue]/maxVol.floatValue;
            width = self.width*rate;
        }
        CGFloat left = 0;
        if (_degreeType==SinglePankouDegreeTypeRight) {
            left = self.width-width;
        }
        _degreeLayer.frame = CGRectMake(left, 0, width, self.height);
    }
}

- (void)showSN:(BOOL)flag{
    _snTextLayer.hidden = !flag;
    if (flag==NO) {
        CGFloat padding = [GUIUtil fit:3];
        _priceTextLayer.frame = CGRectMake(padding, self.height/2, self.width-padding*2, self.height);
        _volTextLayer.frame = CGRectMake(padding, self.height/2, self.width-padding*2, self.height);
        _priceTextLayer.position = _volTextLayer.position = CGPointMake(padding, self.height/2);
    }
}

- (void)setBgColor:(ColorType)bgColor{
    _bgColor = bgColor;
    if (_bgColor!=Unkown_ColorType) {
        self.backgroundColor = [GColorUtil colorWithColorType:_bgColor].CGColor;
    }
}

- (void)themeChangedAction{
    if (_bgColor!=Unkown_ColorType) {
        self.backgroundColor = [GColorUtil colorWithColorType:_bgColor].CGColor;
    }
    _volTextLayer.foregroundColor = [GColorUtil colorWithColorType:C22_ColorType].CGColor;
    _snTextLayer.foregroundColor = [GColorUtil colorWithColorType:C22_ColorType alpha:0.6].CGColor;
}

- (void)addNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:ThemeDidChangedNotification object:nil];
    [center addObserver:self
               selector:@selector(themeChangedAction)
                   name:ThemeDidChangedNotification
                 object:nil];
}

- (void)removeNotic{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self];
}


- (void)setSNText:(NSString *)snText{
    _snTextLayer.string = snText;
}

- (void)setPriceType:(SinglePankouDegreeType)priceType{
    _priceType = priceType;
    if (priceType==SinglePankouDegreeTypeRight) {
        _priceTextLayer.alignmentMode = kCAAlignmentRight;
        _snTextLayer.alignmentMode = kCAAlignmentLeft;
    }else{
        _volTextLayer.alignmentMode = kCAAlignmentRight;
        _snTextLayer.alignmentMode = kCAAlignmentRight;
    }
}

- (void)setPriceColor:(UIColor *)priceColor{
    _priceTextLayer.foregroundColor = priceColor.CGColor;
}

- (void)setVolColor:(UIColor *)volColor{
    _volTextLayer.foregroundColor = volColor.CGColor;
    _snTextLayer.foregroundColor = [GColorUtil colorWithColorType:C22_ColorType alpha:0.6].CGColor;
}

- (void)setFontSize:(CGFloat)fontSize{
    _priceTextLayer.fontSize = fontSize;
    _volTextLayer.fontSize = fontSize;
    _snTextLayer.fontSize = fontSize;
    _priceTextLayer.bounds = CGRectMake(0, 0, 40, ceil([UIFont systemFontOfSize:fontSize].lineHeight));
    _volTextLayer.bounds = CGRectMake(0, 0, 40, ceil([UIFont systemFontOfSize:fontSize].lineHeight));
}

- (void)setDegreeBG:(UIColor *)color{
    _degreeLayer.backgroundColor = color.CGColor;
}

- (CATextLayer *)priceTextLayer{
    if (!_priceTextLayer) {
        _priceTextLayer = [[CATextLayer alloc] init];
        _priceTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _priceTextLayer.anchorPoint = CGPointMake(0, 0.5);
    }
    return _priceTextLayer;
}

- (CATextLayer *)volTextLayer{
    if (!_volTextLayer) {
        _volTextLayer = [[CATextLayer alloc] init];
        _volTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _volTextLayer.anchorPoint = CGPointMake(0, 0.5);
    }
    return _volTextLayer;
}

- (CATextLayer *)snTextLayer{
    if (!_snTextLayer) {
        _snTextLayer = [[CATextLayer alloc] init];
        _snTextLayer.contentsScale = [UIScreen mainScreen].scale;
        _snTextLayer.anchorPoint = CGPointMake(0, 0.5);
    }
    return _snTextLayer;
}

- (CALayer *)degreeLayer{
    if (!_degreeLayer) {
        _degreeLayer = [[CALayer alloc] init];
    }
    return _degreeLayer;
}

@end

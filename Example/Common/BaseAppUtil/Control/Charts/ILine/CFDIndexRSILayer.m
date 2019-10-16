//
//  CFDIndexMALayer.m
//  LiveTrade
//
//  Created by ngw15 on 2019/2/19.
//  Copyright © 2019 taojinzhe. All rights reserved.
//  RSI绘制及计算

#import "CFDIndexRSILayer.h"

@interface CFDIndexRSILayer ()

@property (nonatomic,strong)CAShapeLayer *indexRSI1Layer;
@property (nonatomic,strong)CAShapeLayer *indexRSI2Layer;
@property (nonatomic,strong)CAShapeLayer *indexRSI3Layer;

@property (nonatomic,strong)CAShapeLayer *line1Layer;
@property (nonatomic,strong)CAShapeLayer *line2Layer;

@end

@implementation CFDIndexRSILayer

- (instancetype)init{
    if (self = [super init]) {
        [self addSublayer:self.indexRSI1Layer];
        [self addSublayer:self.indexRSI2Layer];
        [self addSublayer:self.indexRSI3Layer];
        [self addSublayer:self.line1Layer];
        [self addSublayer:self.line2Layer];
    }
    return self;
}

- (void)layoutSublayers{
    [super layoutSublayers];
    self.indexRSI1Layer.frame =
    self.indexRSI2Layer.frame =
    self.indexRSI3Layer.frame =
    self.line1Layer.frame =
    self.line2Layer.frame =
    self.bounds;
}

- (void)drawIndexRSI:(NSArray <CFDKLineData *>*)dataList{
    
    CGMutablePathRef rsi1Path = CGPathCreateMutable();
    CGMutablePathRef rsi2Path = CGPathCreateMutable();
    CGMutablePathRef rsi3Path = CGPathCreateMutable();

    CGFloat pointWidth= self.pointWidth();
    __block CGFloat x = 0.f;
    __block BOOL isStart = NO;
    CGFloat max = 100.0;
    CGFloat min = 0.0;
    [dataList enumerateObjectsUsingBlock:^(CFDKLineData * _Nonnull cell, NSUInteger idx, BOOL * _Nonnull stop) {
        NSDictionary *RSIDic = cell.RSIDic;
        if (RSIDic==nil) {
            return ;
        }
        CGFloat rsi1 = [RSIDic[@"rsi1"] floatValue];
        CGFloat rsi2 = [RSIDic[@"rsi2"] floatValue];
        CGFloat rsi3 = [RSIDic[@"rsi3"] floatValue];
        x = idx*pointWidth;
        
        CGFloat rsi1_y= (1-(rsi1-min)/(max-min))*(self.height-1)+(self.frame.size.height-self.height);
        CGFloat rsi2_y= (1-(rsi2-min)/(max-min))*(self.height-1)+(self.frame.size.height-self.height);
        CGFloat rsi3_y= (1-(rsi3-min)/(max-min))*(self.height-1)+(self.frame.size.height-self.height);
        
        if([NDataUtil IsInfOrNan:x] ||
           [NDataUtil IsInfOrNan:rsi1]||
           [NDataUtil IsInfOrNan:rsi2]||
           [NDataUtil IsInfOrNan:rsi3])
        {
            return;
        }
        if (isStart==NO) {
            isStart = YES;
            CGPathMoveToPoint(rsi1Path, NULL, x, rsi1_y);
            CGPathMoveToPoint(rsi2Path, NULL, x, rsi2_y);
            CGPathMoveToPoint(rsi3Path, NULL, x, rsi3_y);
        }else{
            CGPathAddLineToPoint(rsi1Path, NULL, x,rsi1_y);
            CGPathAddLineToPoint(rsi2Path, NULL, x, rsi2_y);
            CGPathAddLineToPoint(rsi3Path, NULL, x, rsi3_y);
        }
    }];
    
    WEAK_SELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([dataList count] >1)
        {
            weakSelf.indexRSI1Layer.path = rsi1Path;
            weakSelf.indexRSI2Layer.path = rsi2Path;
            weakSelf.indexRSI3Layer.path = rsi3Path;
            
            CGMutablePathRef line1Path = CGPathCreateMutable();
            CGMutablePathRef line2Path = CGPathCreateMutable();
            CGFloat line_y1 = 0.7*(self.height-1)+(self.frame.size.height-self.height);
            CGFloat line_y2 = 0.3*(self.height-1)+(self.frame.size.height-self.height);
            CGPathMoveToPoint(line1Path, NULL, 0, line_y1);
            CGPathAddLineToPoint(line1Path, NULL, self.width, line_y1);
            CGPathMoveToPoint(line2Path, NULL, 0, line_y2);
            CGPathAddLineToPoint(line2Path, NULL, self.width, line_y2);
            weakSelf.line1Layer.path = line1Path;
            weakSelf.line2Layer.path = line2Path;
            CGPathRelease(line1Path);
            CGPathRelease(line2Path);
            if (weakSelf.bottomAxisHander) {
                NSDictionary *axisDic = @{@"left1":@"100",@"left2":@"0",@"y1":@"70",@"y2":@"30",@"height":@(self.frame.size.height-self.height)};
                weakSelf.bottomAxisHander(axisDic);
            }
        }else{
            weakSelf.indexRSI1Layer.path = nil;
            weakSelf.indexRSI2Layer.path = nil;
            weakSelf.indexRSI3Layer.path = nil;
        }
        CGPathRelease(rsi1Path);
        CGPathRelease(rsi2Path);
        CGPathRelease(rsi3Path);
    });
}


//MARK: - Getter

- (CAShapeLayer *)indexRSI1Layer{
    if (!_indexRSI1Layer) {
        _indexRSI1Layer = [[CAShapeLayer alloc] init];
        _indexRSI1Layer.fillColor = [UIColor clearColor].CGColor;
        _indexRSI1Layer.strokeColor   = [ChartsUtil C20].CGColor;      //设置划线颜色
        _indexRSI1Layer.lineCap = @"round";
        _indexRSI1Layer.lineJoin = kCALineJoinRound;
        _indexRSI1Layer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexRSI1Layer;
}
- (CAShapeLayer *)indexRSI2Layer{
    if (!_indexRSI2Layer) {
        _indexRSI2Layer = [[CAShapeLayer alloc] init];
        _indexRSI2Layer.fillColor = [UIColor clearColor].CGColor;
        _indexRSI2Layer.strokeColor   = [ChartsUtil C13].CGColor;      //设置划线颜色
        _indexRSI2Layer.lineCap = @"round";
        _indexRSI2Layer.lineJoin = kCALineJoinRound;
        _indexRSI2Layer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexRSI2Layer;
}
- (CAShapeLayer *)indexRSI3Layer{
    if (!_indexRSI3Layer) {
        _indexRSI3Layer = [[CAShapeLayer alloc] init];
        _indexRSI3Layer.fillColor = [UIColor clearColor].CGColor;
        _indexRSI3Layer.strokeColor   = [ChartsUtil C1100].CGColor;      //设置划线颜色
        _indexRSI3Layer.lineCap = @"round";
        _indexRSI3Layer.lineJoin = kCALineJoinRound;
        _indexRSI3Layer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _indexRSI3Layer;
}

- (CAShapeLayer *)line1Layer{
    if (!_line1Layer) {
        _line1Layer = [[CAShapeLayer alloc] init];
        _line1Layer.fillColor = [UIColor clearColor].CGColor;
        _line1Layer.strokeColor   = [ChartsUtil C7].CGColor;      //设置划线颜色
        _line1Layer.lineCap = @"round";
        _line1Layer.lineJoin = kCALineJoinRound;
        _line1Layer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _line1Layer;
}

- (CAShapeLayer *)line2Layer{
    if (!_line2Layer) {
        _line2Layer = [[CAShapeLayer alloc] init];
        _line2Layer.fillColor = [UIColor clearColor].CGColor;
        _line2Layer.strokeColor   = [ChartsUtil C7].CGColor;      //设置划线颜色
        _line2Layer.lineCap = @"round";
        _line2Layer.lineJoin = kCALineJoinRound;
        _line2Layer.lineWidth     = [ChartsUtil fitLine];          //设置线宽
    }
    return _line2Layer;
}

@end

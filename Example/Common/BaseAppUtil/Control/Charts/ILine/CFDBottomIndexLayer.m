//
//  CFDBottomIndexLayer.m
//  Chart
//
//  Created by ngw15 on 2019/3/15.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "CFDBottomIndexLayer.h"
#import "CFDIndexVOLLayer.h"
#import "CFDIndexMACDLayer.h"
#import "CFDIndexKDJLayer.h"
#import "CFDIndexRSILayer.h"
#import "CFDIndexWRLayer.h"
#import "CFDIndexBIASLayer.h"
#import "CFDIndexCCILayer.h"

@interface CFDBottomIndexLayer ()

@property (nonatomic,strong)CFDIndexMACDLayer *indexMACDLayer;
@property (nonatomic,strong)CFDIndexKDJLayer *indexKDJLayer;
@property (nonatomic,strong)CFDIndexRSILayer *indexRSILayer;
@property (nonatomic,strong)CFDIndexWRLayer *indexWRLayer;
@property (nonatomic,strong)CFDIndexBIASLayer *indexBIASLayer;
@property (nonatomic,strong)CFDIndexCCILayer *indexCCILayer;

@end

@implementation CFDBottomIndexLayer

- (instancetype)init{
    if (self = [super init]) {
        //指标MACD
        [self addSublayer:self.indexMACDLayer];
        //指标KDJ
        [self addSublayer:self.indexKDJLayer];
        //指标RSI
        [self addSublayer:self.indexRSILayer];
        //指标WR
        [self addSublayer:self.indexWRLayer];
        //指标BIAS
        [self addSublayer:self.indexBIASLayer];
        //指标CCI
        [self addSublayer:self.indexCCILayer];
    }
    return self;
}

- (void)layoutSublayers{
    [super layoutSublayers];
    _indexMACDLayer.frame =
    _indexKDJLayer.frame =
    _indexRSILayer.frame =
    _indexWRLayer.frame =
    _indexBIASLayer.frame =
    _indexCCILayer.frame =
    self.bounds;
}

- (void)setIndexDrawHeight:(CGFloat)height{
    self.indexWRLayer.height = self.indexRSILayer.height =
    self.indexKDJLayer.height =  self.indexBIASLayer.height =
    self.indexMACDLayer.height = self.indexCCILayer.height = height;
}

- (void)showBottomIndex:(EIndexType)type showDataList:(NSArray *)dataList{
    if (type==EIndexTypeKdj){
        
        [_indexKDJLayer drawIndexKDJ:dataList];
    }else if (type==EIndexTypeMacd){
        
        [_indexMACDLayer drawIndexMACD:dataList];
    }else if (type==EIndexTypeRsi){
        
        [_indexRSILayer drawIndexRSI:dataList];
    }else if (type==EIndexTypeWR){
        
        [_indexWRLayer drawIndexWR:dataList];
    }else if (type==EIndexTypeBIAS){
        
        [_indexBIASLayer drawIndexBIAS:dataList];
    }else if (type==EIndexTypeCCI){
        
        [_indexCCILayer drawIndexCCI:dataList];
    }
}

- (void)showIndex:(EIndexType)indexType{
    
    _indexKDJLayer.hidden=
    _indexMACDLayer.hidden=
    _indexRSILayer.hidden=
    _indexWRLayer.hidden =
    _indexBIASLayer.hidden =
    _indexCCILayer.hidden =
    YES;
    if (indexType==EIndexTypeKdj){
        _indexKDJLayer.hidden = NO;
        
    }else if (indexType==EIndexTypeMacd){
        _indexMACDLayer.hidden=NO;
        
    }else if (indexType==EIndexTypeRsi){
        _indexRSILayer.hidden = NO;
        
    }else if (indexType==EIndexTypeWR){
        _indexWRLayer.hidden = NO;
        
    }else if (indexType==EIndexTypeBIAS){
        _indexBIASLayer.hidden = NO;
        
    }else if (indexType==EIndexTypeCCI){
        _indexCCILayer.hidden = NO;
    }
}

//MARK: - Getter

- (void)setBottomAxisHander:(void (^)(NSDictionary * _Nonnull))bottomAxisHander{
    self.indexKDJLayer.bottomAxisHander =
    self.indexRSILayer.bottomAxisHander =
    self.indexMACDLayer.bottomAxisHander =
    self.indexWRLayer.bottomAxisHander=
    self.indexBIASLayer.bottomAxisHander=
    self.indexCCILayer.bottomAxisHander =
    bottomAxisHander;
}

- (CGFloat)pointWidth{
    return self.getPointWidth();
}

- (CFDIndexMACDLayer *)indexMACDLayer{
    if (!_indexMACDLayer) {
        _indexMACDLayer = [[CFDIndexMACDLayer alloc] init];
        WEAK_SELF;
        _indexMACDLayer.pointWidth = ^CGFloat{
            return weakSelf.pointWidth;
        };
    }
    return _indexMACDLayer;
}

- (CFDIndexKDJLayer *)indexKDJLayer{
    if (!_indexKDJLayer) {
        _indexKDJLayer = [[CFDIndexKDJLayer alloc] init];
        WEAK_SELF;
        _indexKDJLayer.pointWidth = ^CGFloat{
            return weakSelf.pointWidth;
        };
    }
    return _indexKDJLayer;
}

- (CFDIndexRSILayer *)indexRSILayer{
    if (!_indexRSILayer) {
        _indexRSILayer = [[CFDIndexRSILayer alloc] init];
        WEAK_SELF;
        _indexRSILayer.pointWidth = ^CGFloat{
            return weakSelf.pointWidth;
        };
    }
    return _indexRSILayer;
}
- (CFDIndexWRLayer *)indexWRLayer{
    if (!_indexWRLayer) {
        _indexWRLayer = [[CFDIndexWRLayer alloc] init];
        WEAK_SELF;
        _indexWRLayer.pointWidth = ^CGFloat{
            return weakSelf.pointWidth;
        };
    }
    return _indexWRLayer;
}
- (CFDIndexBIASLayer *)indexBIASLayer{
    if (!_indexBIASLayer) {
        _indexBIASLayer = [[CFDIndexBIASLayer alloc] init];
        WEAK_SELF;
        _indexBIASLayer.pointWidth = ^CGFloat{
            return weakSelf.pointWidth;
        };
    }
    return _indexBIASLayer;
}
- (CFDIndexCCILayer *)indexCCILayer{
    if (!_indexCCILayer) {
        _indexCCILayer = [[CFDIndexCCILayer alloc] init];
        WEAK_SELF;
        _indexCCILayer.pointWidth = ^CGFloat{
            return weakSelf.pointWidth;
        };
    }
    return _indexCCILayer;
}

@end

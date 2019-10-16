//
//  CFDTopIndexLayer.m
//  Chart
//
//  Created by ngw15 on 2019/3/15.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "CFDTopIndexLayer.h"
#import "CFDIndexMALayer.h"
#import "CFDIndexBOLLLayer.h"

@interface CFDTopIndexLayer ()

@property (nonatomic,strong)CFDIndexMALayer *indexMALayer;
@property (nonatomic,strong)CFDIndexBOLLLayer *indexBOLLLayer;

@end

@implementation CFDTopIndexLayer

- (instancetype)init{
    if (self = [super init]) {
        
        [self addSublayer:self.indexMALayer];  
        [self addSublayer:self.indexBOLLLayer];
    }
    return self;
}

- (void)layoutSublayers{
    [super layoutSublayers];
    self.indexMALayer.frame=
    self.indexBOLLLayer.frame=
    self.bounds;
    
}

- (void)drawTopIndex:(EIndexTopType)type showDataList:(NSArray *)dataList maxPrice:(NSString *)maxPrice minPrice:(NSString *)minPrice{
    if (type==EIndexTopTypeNone) {
        
    }else if (type==EIndexTopTypeMa){
        [_indexMALayer drawMA:dataList maxPirce:maxPrice minPrice:minPrice];
    }else if (type==EIndexTopTypeBool){
        [_indexBOLLLayer drawBOOL:dataList maxPirce:maxPrice minPrice:minPrice];
    }
}

- (void)showIndexTop:(EIndexTopType)topType{
    if (topType==EIndexTopTypeBool){
        _indexBOLLLayer.hidden = NO;
        _indexMALayer.hidden=YES;
    }else if (topType==EIndexTopTypeMa){
        _indexMALayer.hidden=NO;
        _indexBOLLLayer.hidden=YES;
    }else{
        _indexBOLLLayer.hidden=
        _indexMALayer.hidden = YES;
    }
}

//MARK: - Getter

- (CFDIndexMALayer *)indexMALayer{
    if (!_indexMALayer) {
        _indexMALayer = [[CFDIndexMALayer alloc] init];
        _indexMALayer.hidden = YES;
        WEAK_SELF;
        _indexMALayer.pointWidth = ^CGFloat{
            return weakSelf.getPointWidth();
        };
    }
    return _indexMALayer;
}


- (CFDIndexBOLLLayer *)indexBOLLLayer{
    if (!_indexBOLLLayer) {
        _indexBOLLLayer = [[CFDIndexBOLLLayer alloc] init];
        WEAK_SELF;
        _indexBOLLLayer.pointWidth = ^CGFloat{
            return weakSelf.getPointWidth();
        };
    }
    return _indexBOLLLayer;
}

@end

//
//  DepthView.m
//  Chart
//
//  Created by ngw15 on 2019/3/8.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "DepthView.h"
#import "PankouView.h"
#import "CFDDLineView.h"

@interface DepthSectionView : UIView

@property (nonatomic,strong)UILabel *left1Label;
@property (nonatomic,strong)UILabel *left2Label;
@property (nonatomic,strong)UILabel *centerLabel;
@property (nonatomic,strong)UILabel *right1Label;
@property (nonatomic,strong)UILabel *right2Label;

@end

@implementation DepthSectionView

+ (CGFloat)heightOfView{
    return [GUIUtil fit:34];
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [GColorUtil C6];
    [self addSubview:self.left1Label];
    [self addSubview:self.left2Label];
    [self addSubview:self.centerLabel];
    [self addSubview:self.right1Label];
    [self addSubview:self.right2Label];
    
}

- (void)autoLayout{
    [_left1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:12]);
        make.centerY.mas_equalTo(0);
    }];
    [_left2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.left1Label.mas_right).mas_offset([GUIUtil fit:5]);
        make.centerY.mas_equalTo(0);
    }];
    [_centerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.centerX.mas_equalTo([GUIUtil fit:0]);
    }];
    [_right1Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-10]);
        make.centerY.mas_equalTo(0);
    }];
    [_right2Label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.right1Label.mas_left).mas_offset([GUIUtil fit:-5]);
        make.centerY.mas_equalTo(0);
    }];

}

- (UILabel *)left1Label{
    if (!_left1Label) {
        _left1Label = [[UILabel alloc] init];
        _left1Label.textColor = GColorUtil.C4;
        _left1Label.font = [GUIUtil fitFont:10];
        _left1Label.numberOfLines = 1;
        _left1Label.text = CFDLocalizedString(@"买盘");
    }
    return _left1Label;
}

- (UILabel *)left2Label{
    if (!_left2Label) {
        _left2Label = [[UILabel alloc] init];
        _left2Label.textColor = GColorUtil.C4;
        _left2Label.font = [GUIUtil fitFont:10];
        _left2Label.numberOfLines = 1;
        _left2Label.text = CFDLocalizedString(@"数量(手)");
    }
    return _left2Label;
}

- (UILabel *)centerLabel{
    if (!_centerLabel) {
        _centerLabel = [[UILabel alloc] init];
        _centerLabel.textColor = GColorUtil.C4;
        _centerLabel.font = [GUIUtil fitFont:10];
        _centerLabel.numberOfLines = 1;
        _centerLabel.text = CFDLocalizedString(@"价格");
    }
    return _centerLabel;
}

- (UILabel *)right1Label{
    if (!_right1Label) {
        _right1Label = [[UILabel alloc] init];
        _right1Label.textColor = GColorUtil.C4;
        _right1Label.font = [GUIUtil fitFont:10];
        _right1Label.numberOfLines = 1;
        _right1Label.text = CFDLocalizedString(@"卖盘");
    }
    return _right1Label;
}

- (UILabel *)right2Label{
    if (!_right2Label) {
        _right2Label = [[UILabel alloc] init];
        _right2Label.textColor = GColorUtil.C4;
        _right2Label.font = [GUIUtil fitFont:10];
        _right2Label.numberOfLines = 1;
        _right2Label.text = CFDLocalizedString(@"数量(手)");
    }
    return _right2Label;
}



@end

@interface DepthView()<UIScrollViewDelegate>

@property (nonatomic,strong) DepthSectionView *sectionView;
@property (nonatomic,strong) CFDDLineView *dLineView;
@property (nonatomic,strong) PankouView *pankouView;
@property (nonatomic,strong) NSMutableArray *pankouData;

@property (nonatomic,assign) BOOL isLoaded;
@property (nonatomic,copy)NSString *symobl;
@property (nonatomic,assign) NSInteger dotnum;

@end

@implementation DepthView

- (instancetype)initWithSymbol:(NSString *)symbol{
    if (self = [super init]) {
        _symobl = symbol;
        self.backgroundColor = [GColorUtil C6];
        self.directionalLockEnabled = YES;
        self.delegate = self;
        [self setupUI];
        [self startTimer];
        [_dLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo([GUIUtil fit:0]);
            make.left.mas_equalTo([GUIUtil fit:0]);
            make.width.mas_equalTo(SCREEN_WIDTH-[GUIUtil fit:0]);
            make.height.mas_equalTo([GUIUtil fit:200]);
        }];
        [_sectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dLineView.mas_bottom).mas_offset([GUIUtil fit:10]);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo([GUIUtil fit:30]);
        }];
        [_pankouView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(0);
            make.width.mas_equalTo(SCREEN_WIDTH);
            make.height.mas_equalTo([GUIUtil fit:500]);
            make.top.equalTo(self.sectionView.mas_bottom).mas_offset([GUIUtil fit:0]);
        }];
    }
    return self;
}

- (void)setupUI{
    [self addSubview:self.sectionView];
    [self addSubview:self.dLineView];
    [self addSubview:self.pankouView];
}

- (void)refreshData{
    [self loadData:NO];
}

- (void)willAppear{
    if (_isLoaded) {
        [self startTimer];
    }else{
        [self loadData:NO];
        [self startTimer];
    }
}

- (void)willDisAppear{
    [NTimeUtil stopTimer:@"ChartsVC_child"];
}

- (void)startTimer{
    WEAK_SELF;
    [NTimeUtil startTimer:@"ChartsVC_child" interval:3 repeats:YES action:^{
        [weakSelf loadData:YES];
    }];
}

- (void)loadData:(BOOL)isAuto{
    WEAK_SELF;
    
    NSString *symbol = _symobl.copy;
    [DCService orderbookData:symbol limit:@"200" success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            if ([symbol isEqualToString:weakSelf.symobl]) {
                weakSelf.isLoaded = YES;
                NSDictionary *dic = [NDataUtil dictWith:data[@"data"]];
                NSMutableArray *bids = [NDataUtil arrayWith:dic[@"bids"]].mutableCopy;
                NSMutableArray *asks = [NDataUtil arrayWith:dic[@"asks"]].mutableCopy;
                [SortUtil quickSort:asks isAscending:YES keyHander:^CGFloat(NSDictionary *dic) {
                    return [NDataUtil stringWith:dic[@"price"]].floatValue;
                }];
                [SortUtil quickSort:bids isAscending:NO keyHander:^CGFloat(NSDictionary *dic) {
                    return [NDataUtil stringWith:dic[@"price"]].floatValue;
                }];
                weakSelf.dotnum = [NDataUtil integerWith:dic[@"decimalplace"]];
                if (bids&&asks) {
                    weakSelf.pankouData = @[asks,bids].mutableCopy;
                    NSDictionary *dic = [weakSelf parsePankouData];
                    [weakSelf.pankouView configData:dic[@"pankouList"] maxVol:dic[@"totalVol_20"]];
                    weakSelf.dLineView.nDotNum = weakSelf.dotnum;
                    [weakSelf.dLineView configData:dic];
                }
                [NTimeUtil run:^{
                    weakSelf.pankouView.hidden = NO;
                    weakSelf.dLineView.hidden = NO;
                } delay:0.3];
            }
        }else{
            if (isAuto==NO) {
                [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
            }
        }
        if (isAuto==NO) {
            [StateUtil hide:weakSelf];
        }
    } failure:^(NSError *error) {
        if (isAuto==NO) {
            [HUDUtil showInfo:[FTConfig webTips]];
            [StateUtil hide:weakSelf];
        }
    }];
}

- (NSMutableArray *)test:(NSMutableArray *)list{
    NSMutableArray *tem = [NSMutableArray array];
    for (NSDictionary *dic in list) {
        NSMutableDictionary *dict = dic.mutableCopy;
        NSString *vol = [NDataUtil stringWith:dict[@"quantity"]];
        if ([_symobl isEqualToString:@"BTCUSDT"]) {
            vol = [GUIUtil decimalMultiply:vol num:@"100"];
        }else if ([_symobl isEqualToString:@"ETHUSDT"]){
            vol = [GUIUtil decimalMultiply:vol num:@"10"];
        }else if ([_symobl isEqualToString:@"EOSUSDT"]){
            vol = [GUIUtil decimalMultiply:vol num:@"1"];
        }else if ([_symobl isEqualToString:@"LTCUST"]){
            vol = [GUIUtil decimalMultiply:vol num:@"100"];
        }else if ([_symobl isEqualToString:@"XRPUSDT"]){
            vol = [GUIUtil decimalMultiply:vol num:@"0.01"];
        }
        vol = [GUIUtil notRoundingString:vol afterPoint:0];
        if (vol.floatValue<1) {
            vol = @"1";
        }
        [dict setObject:vol forKey:@"quantity"];
        [tem addObject:dict];
    }
    return tem;
}

- (void)changedSymbol:(NSString *)symbol{
    if (![_symobl isEqualToString:symbol]&&symbol.length>0) {
        _symobl = symbol;
        _pankouData = [NSMutableArray array];
        _pankouView.hidden = YES;
        _dLineView.hidden = YES;
        ProgressStateView *stateView = (ProgressStateView *)[StateUtil show:self type:StateTypeProgress];
        stateView.backgroundColor = [GColorUtil C6];
        [self loadData:NO];
    }
}

//MARK: - Getter

- (DepthSectionView *)sectionView{
    if (!_sectionView) {
        _sectionView = [[DepthSectionView alloc] init];
        _sectionView.backgroundColor = [GColorUtil C6];
    }
    return _sectionView;
}

- (CFDDLineView *)dLineView{
    if (!_dLineView) {
        _dLineView = [[CFDDLineView alloc] init];
        _dLineView.hidden = YES;
    }
    return _dLineView;
}

- (PankouView *)pankouView{
    if (!_pankouView) {
        _pankouView = [[PankouView alloc] initWithFrame:CGRectMake(0, [GUIUtil fit:30], SCREEN_WIDTH, [GUIUtil fit:500])];
        _pankouView.backgroundColor = [GColorUtil C6];
    }
    return _pankouView;
}


- (NSDictionary *)parsePankouData{
    CGFloat buyMaxPrice = CGFLOAT_MIN;
    CGFloat buyMinPrice = CGFLOAT_MAX;
    NSString *buyTotalVol = @"0";
    NSString *sellTotalVol = @"0";
    NSString *buyTotalVol_20 = @"0";
    NSString *sellTotalVol_20 = @"0";
    NSArray *buyList = [NDataUtil arrayWithArray:self.pankouData index:1];
    NSArray *sellList = [NDataUtil arrayWithArray:self.pankouData index:0];
    NSMutableArray *list1 = [NSMutableArray array];
    NSMutableArray *list2 = [NSMutableArray array];
    for (NSInteger i=0; i<buyList.count; i++) {
        NSDictionary *dic = buyList[i];
        NSString *vol = [NDataUtil stringWithDict:dic keys:@[@"quantity",@"s"] valid:@""];
        NSString *price = [NDataUtil stringWithDict:dic keys:@[@"price",@"p"] valid:@""];
        price = [GUIUtil notRoundingString:price afterPoint:_dotnum];
        buyMaxPrice = MAX(buyMaxPrice,[price floatValue]);
        buyMinPrice = MIN(buyMinPrice,[price floatValue]);
        buyTotalVol = [GUIUtil decimalAdd:buyTotalVol num:vol];
        if (i<20) {
            buyTotalVol_20 = [GUIUtil decimalAdd:buyTotalVol_20 num:vol];
        }
        [list1 addObject:@{@"quantity":vol,@"price":price,@"total_20":buyTotalVol_20,@"total":buyTotalVol}.mutableCopy];
    }

    CGFloat sellMaxPrice = CGFLOAT_MIN;
    CGFloat sellMinPrice = CGFLOAT_MAX;
    for (NSInteger i=0; i<sellList.count; i++) {
        NSDictionary *dic = sellList[i];
        NSString *vol = [NDataUtil stringWithDict:dic keys:@[@"quantity",@"s"] valid:@""];
        NSString *price = [NDataUtil stringWithDict:dic keys:@[@"price",@"p"] valid:@""];
        price = [GUIUtil notRoundingString:price afterPoint:_dotnum];
        sellMaxPrice = MAX(sellMaxPrice,[price floatValue]);
        sellMinPrice = MIN(sellMinPrice,[price floatValue]);
        sellTotalVol = [GUIUtil decimalAdd:sellTotalVol num:vol];
        if (i<20) {
            sellTotalVol_20 = [GUIUtil decimalAdd:sellTotalVol_20 num:vol];
        }
        [list2 addObject:@{@"quantity":vol,@"price":price,@"total_20":sellTotalVol_20,@"total":sellTotalVol.mutableCopy}];
    }
    
    NSString *buyMaxStr = [NSString stringWithFormat:@"%.8f",buyMaxPrice];
    NSString *buyMinStr = [NSString stringWithFormat:@"%.8f",buyMinPrice];
    buyMaxStr = [GUIUtil notRoundingString:buyMaxStr afterPoint:_dotnum];
    buyMinStr = [GUIUtil notRoundingString:buyMinStr afterPoint:_dotnum];
    NSMutableDictionary *buyDic = @{@"maxPrice":buyMaxStr,@"minPrice":buyMinStr,@"data":list1}.mutableCopy;
    NSString *sellMaxStr = [NSString stringWithFormat:@"%.8f",sellMaxPrice];
    NSString *sellMinStr = [NSString stringWithFormat:@"%.8f",sellMinPrice];
    sellMaxStr = [GUIUtil notRoundingString:sellMaxStr afterPoint:_dotnum];
    sellMinStr = [GUIUtil notRoundingString:sellMinStr afterPoint:_dotnum];
    NSMutableDictionary *sellDic = @{@"maxPrice":sellMaxStr,@"minPrice":sellMinStr,@"data":list2}.mutableCopy;
    NSString *totalVol = buyTotalVol.floatValue>sellTotalVol.floatValue?buyTotalVol:sellTotalVol;
    NSString *totalVol_20 = buyTotalVol_20.floatValue>sellTotalVol_20.floatValue?buyTotalVol_20:sellTotalVol_20;
    NSArray *pankouList = @[buyDic,sellDic];
    return @{@"totalVol":totalVol,
             @"totalVol_20":totalVol_20,
             @"pankouList":pankouList,
             };
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [_scrollDelegate scrollViewDidScroll:scrollView];
}

@end

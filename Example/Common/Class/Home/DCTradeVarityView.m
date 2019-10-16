//
//  DCTradeVarityCell.m
//  qzh_ftox
//
//  Created by ngw15 on 2018/3/27.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "DCTradeVarityView.h"
#import "MarkView.h"
#import "WebSocketManager.h"
#import "BaseBtn.h"
#import "BaseLabel.h"
#import "BaseImageView.h"

@interface DCTradeVarityRow: BaseBtn

@property (nonatomic,strong) UIImageView *bgImg;
@property (nonatomic,strong) BaseLabel *name;
@property (nonatomic,strong) BaseLabel *price;
@property (nonatomic,strong) BaseLabel *updownRate;
@property (nonatomic,strong) BaseLabel *valueLabel;

@property (nonatomic,strong) CFDBaseInfoModel *config;
@property (nonatomic,assign) BOOL hasChangeAnimation;
@end

@implementation DCTradeVarityRow

+ (CGSize)sizeOfCell{
    CGFloat height = [GUIUtil fit:10]+[GUIUtil fitFont:12].lineHeight+[GUIUtil fit:5]+[GUIUtil fitBoldFont:18].lineHeight+[GUIUtil fit:2]+[GUIUtil fitFont:12].lineHeight+[GUIUtil fit:2]+[GUIUtil fitFont:12].lineHeight+[GUIUtil fit:10];
    CGSize size = CGSizeMake((SCREEN_WIDTH-[GUIUtil fit:30])/3, ceil(height));
    return size;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius=4;
        self.layer.masksToBounds = YES;
        [self setupUI];
        [self autoLayout];
    }
    return self;
}

- (void)setupUI{
    self.bgColor = C6_ColorType;
    self.bgLayerColor = C6_ColorType;
    self.layer.borderWidth = 1;
    [self addSubview:self.bgImg];
    [self addSubview:self.name];
    [self addSubview:self.price];
    [self addSubview:self.updownRate];
    [self addSubview:self.valueLabel];
}

- (void)autoLayout{
    [_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo([GUIUtil fit:0]);
    }];
    [_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo([GUIUtil fit:0]);
        make.top.mas_equalTo([GUIUtil fit:8]);
    }];
    [_price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo([GUIUtil fit:0]);
        make.top.equalTo(self.name.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [_updownRate mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo([GUIUtil fit:0]);
        make.top.equalTo(self.price.mas_bottom).mas_offset([GUIUtil fit:5]);
    }];
    [_valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.updownRate.mas_bottom).mas_offset([GUIUtil fit:5]);
        make.centerX.mas_equalTo([GUIUtil fit:0]);
    }];
 
}

//MARK: - Action

- (void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
}

- (void)selectedRow:(BOOL)isSelected{
    [self setSelected:isSelected];
    if (isSelected) {
        if (self.updownRate.text.floatValue < 0.00) {
            self.bgLayerColor = C12_ColorType;
        }else if (self.updownRate.text.floatValue > 0.00){
            self.bgLayerColor = C11_ColorType;
        }else{
            self.bgLayerColor = C6_ColorType;
        }
    }else{
        self.bgLayerColor = C6_ColorType;
    }
}

- (void)configOfCell:(CFDBaseInfoModel *)model{
    if (![model isKindOfClass:[CFDBaseInfoModel class]]) {
        return;
    }
    BOOL hasChange = ![model.lastPrice isEqualToString:self.price.text];
    self.name.text = model.iStockname;
    self.price.text = model.lastPrice;
    NSString *cnyText= [GUIUtil notRoundingString:[GUIUtil decimalMultiply:model.lastPrice num:model.rate] afterPoint:2];
    self.valueLabel.text=  [NSString stringWithFormat:@"≈¥%@",cnyText];
    self.updownRate.text =  model.raisRate;
    self.updownRate.txColor =
    self.price.txColor = [GColorUtil colorTypeWithProfitString:self.updownRate.text];
    [self setBackgroundImage:[UIImage imageWithColor:[GColorUtil colorWithColor:self.price.textColor alpha:0.2]] forState:UIControlStateSelected];
    _bgImg.image =[UIImage imageWithColor:[GColorUtil colorWithColor:self.price.textColor alpha:0.2]];
    if (hasChange&&_hasChangeAnimation==YES&&_config) {
        [self startAnimation];
    }else{
        _bgImg.hidden = YES;
    }
    _config = model;
}

- (void)startAnimation{
    _bgImg.hidden = NO;
    _bgImg.alpha=0;
    WEAK_SELF;
    [UIView animateWithDuration:0.2 animations:^{
        weakSelf.bgImg.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            weakSelf.bgImg.alpha = 0;
        } completion:^(BOOL finished) {
            weakSelf.bgImg.hidden = YES;
        }];
    }];
}

//MARK:Getter

- (UIImageView *)bgImg{
    if (!_bgImg) {
        _bgImg = [[UIImageView alloc] init];
        _bgImg.hidden = YES;
    }
    return _bgImg;
}

- (BaseLabel *)name
{
    if(!_name)
    {
        _name = [BaseLabel new];
        _name.txColor = C2_ColorType;
        _name.font  = [GUIUtil fitFont:12];
    }
    return _name;
}

- (BaseLabel *)price
{
    if(!_price)
    {
        _price = [BaseLabel new];
        _price.txColor = C2_ColorType;
        _price.font  = [GUIUtil fitBoldFont:18];
    }
    return _price;
}


- (BaseLabel *)valueLabel
{
    if(!_valueLabel)
    {
        _valueLabel = [BaseLabel new];
        _valueLabel.txColor = C3_ColorType;
        _valueLabel.font  = [GUIUtil fitFont:12];
    }
    return _valueLabel;
}

- (BaseLabel *)updownRate
{
    if(!_updownRate)
    {
        _updownRate = [BaseLabel new];
        _updownRate.font  = [GUIUtil fitFont:12];
        _updownRate.txColor = C2_ColorType;
    }
    return _updownRate;
}

@end


@interface DCTradeVarityView ()

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *stockRowList;
@property (nonatomic,assign) NSInteger selectedIndex;
@property (nonatomic,strong) BaseView *separatView;
@property (nonatomic,assign) BOOL selectedEnabled;

@property (nonatomic,strong) ThreadSafeArray *dataList;
@property (nonatomic, strong) WebSocketManager *webSocket;
@property (nonatomic,assign) BOOL isLoaded;
@end

@implementation DCTradeVarityView

+ (CGFloat)heightOfView{
    return  [DCTradeVarityRow sizeOfCell].height + [GUIUtil fit:15];
}

- (instancetype)initWithSelectedEnabled:(BOOL)enabled{
    if (self = [super init]) {
        _selectedIndex = -1;
        _selectedEnabled = enabled;
        _dataList = [ThreadSafeArray array];
        [self setupUI];
    }
    return self;
}

- (void)willAppear{
    if (_isLoaded==NO) {
        [self loadRecommendMarket:YES];
    }else{
        [self websocketLoad];
    }
}

- (void)willDisAppear{
    [_webSocket disconnect];
}

- (void)refreshData{
    [self loadRecommendMarket:YES];
}

- (void)setupUI{
    [self addSubview:self.scrollView];
    [self addSubview:self.separatView];
    _stockRowList = [NSMutableArray array];
    DCTradeVarityRow *lastRow = nil;
    for (int i =0; i<3; i++) {
        DCTradeVarityRow *row = self.stockRow;
        [_scrollView addSubview:row];
        [_stockRowList addObject:row];
        [row mas_makeConstraints:^(MASConstraintMaker *make) {
            if (i==0) {
                make.left.mas_equalTo([GUIUtil fit:15]);
            }
            make.top.mas_equalTo([GUIUtil fit:0]);
            make.size.mas_equalTo([DCTradeVarityRow sizeOfCell]);
        }];
        lastRow = row;
    }
    [lastRow mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo([GUIUtil fit:-15]).priority(500);
    }];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo([GUIUtil fit:-15]);
    }];
    [_separatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.height.mas_equalTo([GUIUtil fit:5]);
    }];
}

- (void)websocketLoad{
    if (_dataList.count<=0) {
        return;
    }
    if (_webSocket) {
        [_webSocket reconnect];
        return;
    }
    NSMutableArray *tem = [NSMutableArray array];
    for (NSInteger i = 0; i<_dataList.count; i++) {
        CFDBaseInfoModel *model = [NDataUtil dataWithArray:_dataList index:i];
        [tem addObject:model.symbol];
    }
    _webSocket = [[WebSocketManager alloc] init];
    _webSocket.target = self;
    [_webSocket multipleContractData:tem];
    WEAK_SELF;
    [_webSocket setReciveMessage:^(NSArray *array) {
        NSLog(@"DCTradeVarityView的websocket收到数据");
        for (NSDictionary *dic in array) {
            [weakSelf updateSingleContradId:dic];
        }
        [weakSelf configOfView];
    }];
}


- (void)loadRecommendMarket:(BOOL)isRefresh{
    WEAK_SELF;
    [DCService getRecommendDataList:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            if (isRefresh) {
                [weakSelf.dataList removeAllObjects];
            }
            [weakSelf parseData:[NDataUtil arrayWith:data[@"data"]]];
            [weakSelf configOfView];
            [weakSelf websocketLoad];
            weakSelf.isLoaded = YES;
        }
    } failure:^(NSError *error) {
        
    }];
}

- (void)parseData:(NSArray *)data{
    for (NSDictionary *dic in data) {
        [self updateSingleContradId:dic];
    }
}

- (void)updateSingleContradId:(NSDictionary *)dic{
    __block BOOL hasContradId = NO;
    NSString *symbol = [NDataUtil stringWithDict:dic keys:@[@"symbol",@"S"] valid:@""];
    NSString *askp = [NDataUtil stringWithDict:dic keys:@[@"askPrice",@"a"] valid:@""];
    NSString *bidp = [NDataUtil stringWithDict:dic keys:@[@"bidPrice",@"b"] valid:@""];
    NSString *name = [NDataUtil stringWithDict:dic keys:@[@"name",@"S"] valid:@""];
    NSString *volume = [NDataUtil stringWithDict:dic keys:@[@"volume",@"v"] valid:@""];
    NSString *price = [NDataUtil stringWithDict:dic keys:@[@"tradePrice",@"t"] valid:@""];
    NSString *upDownRate = [NDataUtil stringWithDict:dic keys:@[@"upDownRate"] valid:@""];
    NSString *dotnum = [NDataUtil stringWithDict:dic keys:@[@"decimalplace"] valid:@""];
    NSString *rate = [NDataUtil stringWithDict:dic keys:@[@"cnyRate"] valid:@""];
    if ([dic containsObjectForKey:@"c"]&&[dic containsObjectForKey:@"t"]) {
        NSString *upDown = [GUIUtil decimalSubtract:dic[@"t"] num:dic[@"c"]];
        upDownRate = [GUIUtil decimalDivide:upDown num:dic[@"c"]];
        if (upDownRate.length<=0) {
            upDownRate = @"0.00%";
        }else{
            upDownRate = [GUIUtil notRoundingString:upDownRate afterPoint:4];
            upDownRate = [NSString stringWithFormat:@"%@%%",[GUIUtil decimalMultiply:upDownRate num:@"100"]];
        }
    }
    
    [_dataList enumerateObjectsUsingBlock:^(CFDBaseInfoModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj.symbol isEqualToString:symbol]&&obj.symbol.length>0) {
            obj.lastPrice = price;
            obj.volume = volume;
            obj.raisRate = upDownRate;
            hasContradId = YES;
            *stop = YES;
        }
    }];
    if (hasContradId==NO) {
        CFDBaseInfoModel *obj = [[CFDBaseInfoModel alloc] init];
        obj.dotNum = [dotnum integerValue];
        obj.rate = rate;
        obj.symbol = symbol;
        obj.askp = askp;
        obj.bidp = bidp;
        obj.iStockname = name;
        obj.lastPrice = price;
        obj.raisRate = upDownRate;
        obj.volume = volume;
        [_dataList addObject:obj];
    }
}



//MARK: - Action

- (void)separatViewHidden{
    _separatView.hidden = YES;
}

- (void)rowSelectedAction:(DCTradeVarityRow *)row{
    if (_selectedRow) {
        _selectedRow(row.config);
    }
    if (_selectedEnabled) {
        [self selectedTradeVarity:row.config];
    }
}

- (void)selectedTradeVarity:(CFDBaseInfoModel *)model{
    if (![model isKindOfClass:[CFDBaseInfoModel class]]) {
        return;
    }
    NSInteger index = [_dataList indexOfObject:model];
    if (_selectedIndex!=index&&
        index<_stockRowList.count&&
        index>=0) {
        [_delegate tradeVarityChanged:model];
    }
    [self selectedTradeVarityIndex:index];
}

- (void)configOfView{
    NSArray *list = _dataList;
    DCTradeVarityRow *lastRow = nil;
    for (int i =0; i<_stockRowList.count; i++) {
        DCTradeVarityRow *row= _stockRowList[i];
        NSInteger listCount = list.count;
        if (i<listCount) {

            CFDBaseInfoModel *model = [NDataUtil dataWithArray:list index:i];
            if (lastRow) {
                [lastRow mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(row.mas_left).mas_offset([GUIUtil fit:-0]);
                }];
            }
            row.hidden = NO;
            [row configOfCell:model];
            lastRow = row;
        }else{
            row.hidden = YES;
            [lastRow mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo([GUIUtil fit:-15]);
            }];
        }
    }
    
    if(list.count>_stockRowList.count){
        for (NSInteger i =_stockRowList.count; i<list.count; i++) {
            DCTradeVarityRow *row = self.stockRow;
            row.hidden = NO;
            [_scrollView addSubview:row];
            [_stockRowList addObject:row];
            [row mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo([GUIUtil fit:0]);
                make.size.mas_equalTo([DCTradeVarityRow sizeOfCell]);
            }];
            if (lastRow) {
                [lastRow mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.right.equalTo(row.mas_left).mas_offset([GUIUtil fit:0]);
                }];
            }else{
                [row mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo([GUIUtil fit:15]);
                }];
            }
            
            [row configOfCell:[NDataUtil dataWithArray:list index:i]];
            lastRow = row;
        }
        [lastRow mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo([GUIUtil fit:-15]);
        }];
    }
}

//MARK:Getter

- (DCTradeVarityRow *)stockRow{
    DCTradeVarityRow *row = [[DCTradeVarityRow alloc] init];
    [row addTarget:self action:@selector(rowSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
    row.hidden = YES;
    row.hasChangeAnimation = !_selectedEnabled;
    return row;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.alwaysBounceVertical = NO;
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollEnabled=NO;
    }
    return _scrollView;
}

- (BaseView *)separatView{
    if (!_separatView) {
        _separatView = [[BaseView alloc] init];
        _separatView.bgColor = C8_ColorType;
    }
    return _separatView;
}

//MARK: - Private

- (void)selectedTradeVarityIndex:(NSInteger)index{
    if (index>=_stockRowList.count||
        index<0) {
        return;
    }
    _selectedIndex = index;
    DCTradeVarityRow *selRow = nil;
    for (int i=0; i<_stockRowList.count; i++) {
        DCTradeVarityRow *row= (DCTradeVarityRow  *)[NDataUtil dataWithArray:_stockRowList index:i];
        if (i==index) {
            selRow = row;
        }
        [row selectedRow:i==index];
    }
    [self layoutIfNeeded];
    if (_isNeedScroll) {
        CGFloat minX = CGRectGetMinX(selRow.frame)-[GUIUtil fit:10];
        CGFloat maxX = CGRectGetMaxX(selRow.frame)+[GUIUtil fit:10];
        CGFloat offsetX = _scrollView.contentOffset.x + _scrollView.frame.size.width;
        if (minX<_scrollView.contentOffset.x) {
            _scrollView.contentOffset = CGPointMake(minX, 0);
        }else if (maxX>offsetX){
            _scrollView.contentOffset = CGPointMake(maxX-_scrollView.frame.size.width, 0);
        }
        _isNeedScroll=NO;
    }
}


@end


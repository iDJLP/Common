//
//  HQPankouView.m
//  Bitmixs
//
//  Created by ngw15 on 2019/3/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import "HQPankouView.h"
#import "Pankou5View.h"
#import "WebSocketManager.h"

@interface HQPankouView()

@property (nonatomic,strong) BaseLabel *priceTitle;
@property (nonatomic,strong) BaseLabel *amountTitle;
@property (nonatomic,strong) UILabel *priceText;
@property (nonatomic,strong) UILabel *askText;
@property (nonatomic,strong) UILabel *bidText;
@property (nonatomic,strong) Pankou5View *pankou5View;
@property (nonatomic,strong) ThreadSafeArray *pankouData;
@property (nonatomic,copy) NSString *symbol;
@property (nonatomic,assign) NSInteger dotnum;
@property (nonatomic,assign)BOOL isLoaded;
@property (nonatomic,assign)CGFloat allHeight;
@property (nonatomic, strong) WebSocketManager *webSocket;
@property (nonatomic, strong) NSOperationQueue *queue;
@end

@implementation HQPankouView

+ (CGSize)sizeOfView{
    CGFloat width = [GUIUtil fit:135];
    return CGSizeMake(width, 300);
}

- (instancetype)initWithSymbol:(NSString *)symbol height:(CGFloat)height{
    if (self = [super init]) {
        self.backgroundColor = [GColorUtil C6];
        _allHeight = height;
        _pankouData = [ThreadSafeArray array];
        _symbol = symbol;
        [self setupUI];
    }
    return self;
}

- (void)willAppear{
    [self loadData:NO];
    [self websocketLoad];
    _priceText.text = @"--";
}
- (void)willDisappear{
    [NTimeUtil stopTimer:@"HQPankouView"];
    [_webSocket disconnect];
    _webSocket=nil;
    [self.queue cancelAllOperations];
}

- (void)setupUI{
    [self addSubview:self.pankou5View];
    [self addSubview:self.priceTitle];
    [self addSubview:self.amountTitle];
    [self addSubview:self.priceText];
    [self addSubview:self.askText];
    [self addSubview:self.bidText];
    [_pankou5View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo([GUIUtil fit:35]);
        make.width.mas_equalTo([GUIUtil fit:125]);
        make.bottom.mas_equalTo(0);
    }];
    [_priceTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pankou5View);
        make.bottom.equalTo(self.pankou5View.mas_top).mas_offset([GUIUtil fit:-8]);
    }];
    [_amountTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.pankou5View);
        make.bottom.equalTo(self.pankou5View.mas_top).mas_offset([GUIUtil fit:-8]);
    }];
    [_priceText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo([GUIUtil fit:0]);
        make.centerY.equalTo(self.pankou5View);
    }];
    [_askText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceText.mas_right).mas_offset([GUIUtil fit:5]);
        make.bottom.equalTo(self.pankou5View.mas_centerY);
    }];
    [_bidText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.priceText.mas_right).mas_offset([GUIUtil fit:5]);
        make.top.equalTo(self.pankou5View.mas_centerY);
    }];
}

- (void)refreshData{
    [self loadData:NO];
}

//MARK: - LoadData

- (void)websocketLoad{
    if (_webSocket) {
        [_webSocket reconnect];
        return;
    }
    _queue = [[NSOperationQueue alloc] init];
    _webSocket = [[WebSocketManager alloc] init];
    _webSocket.target = self;
    [_webSocket contractOrderBook:_symbol];
    WEAK_SELF;
    [_webSocket setReciveMessage:^(NSArray *array) {
        NSLog(@"HQPankouView的websocket收到数据");
        if (weakSelf.isLoaded==NO) {
            return ;
        }
        NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:weakSelf selector:@selector(parseSocketDataAndPriceChanged:) object:array];
        weakSelf.queue.maxConcurrentOperationCount = 1;
        [weakSelf.queue addOperation:operation];
        
    }];
}

- (void)parseSocketDataAndPriceChanged:(NSArray *)array{
    [self parseSocketData:array];
    NSString *tradePrice = nil;
    NSString *close = nil;
    for (NSDictionary *dic in array) {
        if ([NDataUtil boolWithDic:dic key:@"S" isEqual:self.symbol]) {
            tradePrice =[GUIUtil notRoundingString:[NDataUtil stringWith:dic[@"t"]] afterPoint:self.dotnum];
            close = [GUIUtil notRoundingString:[NDataUtil stringWith:dic[@"c"]] afterPoint:self.dotnum];
        }
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        self.priceText.text = tradePrice;
        self.priceText.textColor = [GUIUtil decimalSubtract:tradePrice num:close].floatValue>0?[GColorUtil C11]:[GColorUtil C12];
    });
}

- (void)parseSocketData:(NSArray *)array{

    //卖盘
    __block ThreadSafeArray *askArray = _pankouData[0];
    //买盘
    __block ThreadSafeArray *bidArray = _pankouData[1];
    //买盘最高价
    NSDictionary *bidMaxDic = [NDataUtil dataWithArray:bidArray index:0];
    NSString *bidMaxPrice = [NDataUtil stringWithDict:bidMaxDic keys:@[@"price",@"p"] valid:@""];
    //卖盘最低价
    NSDictionary *askMinDic = [NDataUtil dataWithArray:askArray index:askArray.count-1];
    NSString *askMinPrice = [NDataUtil stringWithDict:askMinDic keys:@[@"price",@"p"] valid:@""];
    for (NSDictionary *dic in array) {
        if (![NDataUtil boolWithDic:dic key:@"S" isEqual:_symbol]) {
            continue;
        }
        NSArray *a = [NDataUtil arrayWith:dic[@"A"]];
        NSArray *b = [NDataUtil arrayWith:dic[@"B"]];
        NSDictionary *a1 = [NDataUtil dictWith:dic[@"A1"]];
        NSDictionary *b1 = [NDataUtil dictWith:dic[@"B1"]];
        if (a.count>0) {
            [a enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *price = [NDataUtil stringWithDict:obj keys:@[@"price",@"p"] valid:@""];
                NSString *vol = [NDataUtil stringWithDict:obj keys:@[@"quantity",@"s"] valid:@""];
                //卖价低于买盘的最高价时
                if (price.floatValue<=bidMaxPrice.floatValue) {
                    NSString *v = [self subData:bidArray price:price vol:vol isAsk:YES];
                    if (v.floatValue>0) {
                        [self addData:askArray price:price vol:vol];
                    }
                }else{
                    [self addData:askArray price:price vol:vol];
                }
            }];
        }
        if (b.count>0) {
            [b enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *price = [NDataUtil stringWithDict:obj keys:@[@"price",@"p"] valid:@""];
                NSString *vol = [NDataUtil stringWithDict:obj keys:@[@"quantity",@"s"] valid:@""];
                //买价高于卖盘的最高价时
                if (price.floatValue>=askMinPrice.floatValue) {
                    NSString *v = [self subData:askArray price:price vol:vol isAsk:NO];
                    if (v.floatValue>0) {
                        [self addData:bidArray price:price vol:vol];
                    }
                }else{
                    [self addData:bidArray price:price vol:vol];
                }
            }];
        }
        
        if (a1.count>0) {
            NSString *price = [NDataUtil stringWithDict:a1 keys:@[@"price",@"p"] valid:@""];
            NSString *vol = [NDataUtil stringWithDict:a1 keys:@[@"quantity",@"s"] valid:@""];
            __block NSInteger index = INT_MAX;
            __block CGFloat f = CGFLOAT_MAX;
            [askArray enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *askP = [NDataUtil stringWithDict:obj keys:@[@"price",@"p"] valid:@""];
                CGFloat f1 = price.floatValue - askP.floatValue;
                if (f1>=0) {
                    if (f1<f) {
                        f = f1;
                        index = idx;
                    }
                }
            }];
            if (index<askArray.count) {
                NSArray *tem = [askArray subarrayWithRange:NSMakeRange(index,askArray.count-index)];
                [askArray removeObjectsInArray:tem];
            }
            [askArray addObject:@{@"price":[GUIUtil notRoundingString:price afterPoint:_dotnum],@"quantity":vol}.mutableCopy];
        }
        if (b1.count>0) {
            NSString *price = [NDataUtil stringWithDict:b1 keys:@[@"price",@"p"] valid:@""];
            NSString *vol = [NDataUtil stringWithDict:b1 keys:@[@"quantity",@"s"] valid:@""];
            __block NSInteger index = INT_MAX;
            __block CGFloat f = CGFLOAT_MAX;
            [bidArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                NSString *bidP = [NDataUtil stringWithDict:obj keys:@[@"price",@"p"] valid:@""];
                CGFloat f1 = bidP.floatValue-price.floatValue;
                if (f1>=0) {
                    if (f1<f) {
                        f = f1;
                        index = idx;
                    }
                }
            }];
            if (index<bidArray.count) {
                NSArray *tem = [bidArray subarrayWithRange:NSMakeRange(0,index+1)];
                [bidArray removeObjectsInArray:tem];
            }
            [bidArray addObject:@{@"price":[GUIUtil notRoundingString:price afterPoint:_dotnum],@"quantity":vol}.mutableCopy];
        }
        [askArray sortUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
            NSString *price1 = [NDataUtil stringWithDict:obj1 keys:@[@"price",@"p"] valid:@""];
            NSString *price2 = [NDataUtil stringWithDict:obj2 keys:@[@"price",@"p"] valid:@""];
            return price1.floatValue<price2.floatValue;
        }];
        [bidArray sortUsingComparator:^NSComparisonResult(NSDictionary * obj1, NSDictionary * obj2) {
            NSString *price1 = [NDataUtil stringWithDict:obj1 keys:@[@"price",@"p"] valid:@""];
            NSString *price2 = [NDataUtil stringWithDict:obj2 keys:@[@"price",@"p"] valid:@""];
            return price1.floatValue<price2.floatValue;
        }];
    }
    if(askArray.count<5||bidArray.count<5){
        NSLog(@"end");
    }
    WEAK_SELF;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (askArray.count>0) {
            [askArray sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                return [GUIUtil compareFloat:[NDataUtil stringWithDict:obj2 keys:@[@"price",@"p"] valid:@""] with:[NDataUtil stringWithDict:obj1 keys:@[@"price",@"p"] valid:@""]];
            }];
            if (askArray.count>200) {
                NSArray *tem = [askArray subarrayWithRange:NSMakeRange(0, 200)];
                [askArray removeObjectsInArray:tem];
            }
        }
        if (bidArray.count>0) {
            [bidArray sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                return [GUIUtil compareFloat:[NDataUtil stringWithDict:obj2 keys:@[@"price",@"p"] valid:@""] with:[NDataUtil stringWithDict:obj1 keys:@[@"price",@"p"] valid:@""]];
            }];

            if (bidArray.count>200) {
                NSArray *tem = [bidArray subarrayWithRange:NSMakeRange(200, bidArray.count-200)];
                [bidArray removeObjectsInArray:tem];
            }
        }
        [weakSelf configView];
        //卖盘
        ThreadSafeArray *askArray = weakSelf.pankouData[0];
        //买盘
        ThreadSafeArray *bidArray = weakSelf.pankouData[1];
        //买盘最高价
        NSDictionary *bid1Dic = [NDataUtil dataWithArray:bidArray index:0];
        NSString *bidp1 = [NDataUtil stringWithDict:bid1Dic keys:@[@"price",@"p"] valid:@""];
        //卖盘最低价
        NSDictionary *ask1Dic = [NDataUtil dataWithArray:askArray index:askArray.count-1];
        NSString *askp1 = [NDataUtil stringWithDict:ask1Dic keys:@[@"price",@"p"] valid:@""]; weakSelf.changedPriceHander(@{@"askPrice":askp1,@"bidPrice":bidp1,@"symbol":weakSelf.symbol});
    });
}

- (void)addData:(ThreadSafeArray *)askArray price:(NSString *)price vol:(NSString *)vol{
    __block BOOL hasNotData = YES;
    NSMutableArray *temList = [NSMutableArray array];
    [askArray enumerateObjectsUsingBlock:^(NSMutableDictionary *dic, NSUInteger i, BOOL * _Nonnull stop1) {
        NSString *lastPrice = [NDataUtil stringWithDict:dic keys:@[@"price",@"p"] valid:@""];
        if ([GUIUtil decimalSubtract:lastPrice num:price].floatValue==0) {
            if ([vol isEqualToString:@"0"]) {
                [temList addObject:dic];
            }
            [dic setObject:vol forKey:@"quantity"];
            hasNotData = NO;
            *stop1 = YES;
        }
    }];
    for (NSDictionary *dic in temList) {
        [askArray removeObject:dic];
    }
    if (hasNotData) {
        [askArray addObject:@{@"price":[GUIUtil notRoundingString:price afterPoint:_dotnum],@"quantity":vol}.mutableCopy];
    }
}

//isAsk:是卖价

- (NSString *)subData:(ThreadSafeArray *)bidArray price:(NSString *)price vol:(NSString *)vol1 isAsk:(BOOL)isAsk{
    
    NSMutableArray *temList = [NSMutableArray array];
    __block NSString *vol = vol1;
    BOOL isOrder = NO;
    if (isAsk) {
        isOrder = YES;
    }
    if (isOrder) {
        for (NSInteger i=0; i<bidArray.count; i++) {
            NSMutableDictionary *dic = [NDataUtil dataWithArray:bidArray index:i];
            NSString *lastPrice = [NDataUtil stringWithDict:dic keys:@[@"price",@"p"] valid:@""];
            //卖价比当前买盘的价低 即成交
            BOOL flag = isAsk && price.floatValue<=lastPrice.floatValue;
            //买价比当前卖盘的价高 即成交
            BOOL flag1 = !isAsk && price.floatValue>=lastPrice.floatValue;
            if (flag||flag1) {
                NSString *lastVol = [NDataUtil stringWithDict:dic keys:@[@"quantity",@"s"] valid:@""];
                vol = [GUIUtil decimalSubtract:vol num:lastVol];
                if (vol.floatValue<0) {
                    [dic setObject:[GUIUtil decimalMultiply:vol num:@"-1"] forKey:@"quantity"];
                }else{
                    [temList addObject:dic];
                }
            }else{
                break;
            }
            if (vol.floatValue<=0) {
                break;
            }
        }
    }else{
        for (NSInteger i=bidArray.count-1; i>=0; i--) {
            NSMutableDictionary *dic = [NDataUtil dataWithArray:bidArray index:i];
            NSString *lastPrice = [NDataUtil stringWithDict:dic keys:@[@"price",@"p"] valid:@""];
            //卖价比当前买盘的价低 即成交
            BOOL flag = isAsk && price.floatValue<=lastPrice.floatValue;
            //买价比当前卖盘的价高 即成交
            BOOL flag1 = !isAsk && price.floatValue>=lastPrice.floatValue;
            if (flag||flag1) {
                NSString *lastVol = [NDataUtil stringWithDict:dic keys:@[@"quantity",@"s"] valid:@""];
                vol = [GUIUtil decimalSubtract:vol num:lastVol];
                if (vol.floatValue<0) {
                    [dic setObject:[GUIUtil decimalMultiply:vol num:@"-1"] forKey:@"quantity"];
                }else{
                    [temList addObject:dic];
                }
            }else{
                break;
            }
            if (vol.floatValue<=0) {
                break;
            }
        }
    }
    for (NSDictionary *dic in temList) {
        [bidArray removeObject:dic];
    }
    return vol;
}

- (void)loadData:(BOOL)isAuto{
    WEAK_SELF;
    NSString *symbol = _symbol.copy;
    [DCService orderbookData:symbol limit:@"200" success:^(id data) {
        if ([NDataUtil boolWithDic:data key:@"status" isEqual:@"1"]) {
            if ([symbol isEqualToString:weakSelf.symbol]) {
                weakSelf.isLoaded = YES;
                weakSelf.hidden = NO;
                NSDictionary *dic = [NDataUtil dictWith:data[@"data"]];
                weakSelf.dotnum = [NDataUtil integerWith:dic[@"decimalplace"]];
                NSArray *bids = [NDataUtil arrayWith:dic[@"bids"]];
                NSArray *asks = [NDataUtil arrayWith:dic[@"asks"]];
                if (bids&&asks) {
                    ThreadSafeArray *temAsks = [[ThreadSafeArray alloc] init];
                    ThreadSafeArray *temBids = [[ThreadSafeArray alloc] init];
                    for (NSDictionary *dictionary in asks) {
                        [temAsks addObject:dictionary.mutableCopy];
                    }
                    for (NSDictionary *dictionary in bids) {
                        [temBids addObject:dictionary.mutableCopy];
                    }
                    [temAsks sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                        return [GUIUtil compareFloat:[NDataUtil stringWithDict:obj2 keys:@[@"price",@"p"] valid:@""] with:[NDataUtil stringWithDict:obj1 keys:@[@"price",@"p"] valid:@""]];
                    }];
                    [temBids sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
                        return [GUIUtil compareFloat:[NDataUtil stringWithDict:obj2 keys:@[@"price",@"p"] valid:@""] with:[NDataUtil stringWithDict:obj1 keys:@[@"price",@"p"] valid:@""]];
                    }];
                    weakSelf.pankouData = [ThreadSafeArray arrayWithArray:@[temAsks,temBids]];
                    [weakSelf configView];
                    
                    NSString *tradePrice = [NDataUtil stringWith:dic[@"tradePrice"]];
                    //卖盘
                    ThreadSafeArray *askArray = weakSelf.pankouData[0];
                    //买盘
                    ThreadSafeArray *bidArray = weakSelf.pankouData[1];
                    //买盘最高价
                    NSDictionary *bid1Dic = [NDataUtil dataWithArray:bidArray index:0];
                    NSString *bidp1 = [NDataUtil stringWithDict:bid1Dic keys:@[@"price",@"p"] valid:@""];
                    //卖盘最低价
                    NSDictionary *ask1Dic = [NDataUtil dataWithArray:askArray index:askArray.count-1];
                    NSString *askp1 = [NDataUtil stringWithDict:ask1Dic keys:@[@"price",@"p"] valid:@""];
                    weakSelf.priceText.text = tradePrice;
                    weakSelf.changedPriceHander(@{@"askPrice":askp1,@"bidPrice":bidp1,@"symbol":weakSelf.symbol});
                    
                }
            }
        }else{
            if (isAuto==NO) {
                [HUDUtil showInfo:[NDataUtil stringWith:data[@"info"] valid:[FTConfig webTips]]];
            }
        }
    } failure:^(NSError *error) {
        if (isAuto==NO) {
            [HUDUtil showInfo:[FTConfig webTips]];
        }
    }];
}

- (void)configView{
    NSDictionary *dic = [self parsePankouData];
    if (dic.count>0) {
        [self.pankou5View configData:dic[@"pankouList"] maxVol:dic[@"maxVol"]];
    }
}

- (void)changedSymbol:(NSString *)symbol{
    if (![_symbol isEqualToString:symbol]&&symbol.length>0) {
        _symbol = symbol;
        _isLoaded = NO;
        self.hidden = YES;
        [_webSocket disconnect];
        _webSocket=nil;
        [self.queue cancelAllOperations];
        [self loadData:NO];
        [self websocketLoad];
        _priceText.text = @"--";
    }
}

- (void)startTimer{
    WEAK_SELF;
    [NTimeUtil startTimer:@"HQPankouView" interval:5 repeats:YES action:^{
        [weakSelf loadData:YES];
    }];
}


//MARk: - Getter

- (Pankou5View *)pankou5View{
    if (!_pankou5View) {
        _pankou5View = [[Pankou5View alloc] initWithSingle:(_allHeight-[GUIUtil fit:65])/10];
        _pankou5View.bgColor = C6_ColorType;
    }
    return _pankou5View;
}

- (UILabel *)priceText{
    if (!_priceText) {
        _priceText = [[UILabel alloc] init];
        _priceText.font = [GUIUtil fitBoldFont:18];
        _priceText.textColor = [GColorUtil C2];
        _priceText.text = @"--";
    }
    return _priceText;
}
- (UILabel *)askText{
    if (!_askText) {
        _askText = [[UILabel alloc] init];
        _askText.font = [GUIUtil fitFont:10];
        _askText.textColor = [GColorUtil C10];
        _askText.text = @"--";
        _askText.hidden = YES;
    }
    return _askText;
}
- (UILabel *)bidText{
    if (!_bidText) {
        _bidText = [[UILabel alloc] init];
        _bidText.font = [GUIUtil fitFont:10];
        _bidText.textColor = [GColorUtil C9];
        _bidText.text = @"--";
        _bidText.hidden = YES;
    }
    return _bidText;
}
- (BaseLabel *)priceTitle{
    if (!_priceTitle) {
        _priceTitle = [[BaseLabel alloc] init];
        _priceTitle.font = [GUIUtil fitFont:10];
        _priceTitle.textColor = [GColorUtil C3];
        _priceTitle.textBlock = CFDLocalizedStringBlock(@"价格");
    }
    return _priceTitle;
}

- (BaseLabel *)amountTitle{
    if (!_amountTitle) {
        _amountTitle = [[BaseLabel alloc] init];
        _amountTitle.font = [GUIUtil fitFont:10];
        _amountTitle.textColor = [GColorUtil C3];
        _amountTitle.textBlock = CFDLocalizedStringBlock(@"数量");
    }
    return _amountTitle;
}

- (NSDictionary *)parsePankouData{
    NSString *buyTotalVol = @"0";
    NSString *sellTotalVol = @"0";
    ThreadSafeArray *sellList1 = self.pankouData[0];
    ThreadSafeArray *buyList1 = self.pankouData[1];
    NSArray *sellList = sellList1.copy;
    if (sellList1.count>5) {
        sellList = [sellList1 subarrayWithRange:NSMakeRange(sellList1.count-5, 5)];
    }
    NSArray *buyList = buyList1.copy;
    if (buyList1.count>5) {
        buyList = [buyList1 subarrayWithRange:NSMakeRange(0, 5)];
    }
    NSMutableArray *list1 = [NSMutableArray array];
    NSMutableArray *list2 = [NSMutableArray array];
    
    for (NSInteger i=sellList.count-1; i>=0; i--) {
        NSDictionary *dic = sellList[i];
        NSString *vol = [NDataUtil stringWithDict:dic keys:@[@"quantity",@"s"] valid:@""];
        NSString *price = [NDataUtil stringWithDict:dic keys:@[@"price",@"p"] valid:@""];
 
        sellTotalVol = [GUIUtil decimalAdd:sellTotalVol num:vol];
        [list1 addObject:@{@"quantity":vol,@"price":price,@"total":sellTotalVol}];
    }
    [list1 sortUsingComparator:^NSComparisonResult(NSDictionary *obj1, NSDictionary *obj2) {
        return [GUIUtil compareFloat:[NDataUtil stringWith:obj2[@"price"]] with:[NDataUtil stringWith:obj1[@"price"]]];
    }];
    for (NSInteger i=0; i<buyList.count; i++) {
        NSDictionary *dic = buyList[i];
        NSString *vol = [NDataUtil stringWithDict:dic keys:@[@"quantity",@"s"] valid:@""];
        NSString *price = [NDataUtil stringWithDict:dic keys:@[@"price",@"p"] valid:@""];
        buyTotalVol = [GUIUtil decimalAdd:buyTotalVol num:vol];
        [list2 addObject:@{@"quantity":vol,@"price":price,@"total":buyTotalVol}];
    }
    NSString *maxVol = buyTotalVol;
    if (sellTotalVol.floatValue>buyTotalVol.floatValue) {
        maxVol = sellTotalVol;
    }
    NSArray *pankouList = @[list1,list2];
    return @{
             @"maxVol":maxVol,
             @"pankouList":pankouList,
             };
}

- (void)nslog{
    WEAK_SELF;
    //卖盘
    ThreadSafeArray *askArray = weakSelf.pankouData[0];
    //买盘
    ThreadSafeArray *bidArray = weakSelf.pankouData[1];
    
    NSString *askStr = @"";
    NSString *bidStr = @"";
    for (NSDictionary *dic in askArray) {
        NSString *price = [NDataUtil stringWithDict:dic keys:@[@"price",@"p"] valid:@""];
        askStr = [askStr stringByAppendingFormat:@",%@",price];
    }
    for (NSDictionary *dic in bidArray) {
        NSString *price = [NDataUtil stringWithDict:dic keys:@[@"price",@"p"] valid:@""];
        bidStr = [bidStr stringByAppendingFormat:@",%@",price];
    }
    NSLog(@"askCount:%ld,askPrices:%@;\nbidCount:%ld,bidPrices:%@",askArray.count,askStr,bidArray.count,bidStr);
}


@end

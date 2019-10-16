//
//  OrderModel.h
//  Bitmixs
//
//  Created by ngw15 on 2019/3/21.
//  Copyright © 2019 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OrderModel : NSObject

///下单需要的参数
@property(nonatomic,copy)NSString *ordertype; //委托类型 1限价，2市价
@property(nonatomic,copy)NSString *bstype;   //买卖方向 1买，2卖
@property (nonatomic,copy)NSString *openPrice; //限价单时需要
@property(nonatomic,copy)NSString *delegateAmount;//实际输入委托数量
@property(nonatomic,copy)NSString *margin;//保证金
@property(nonatomic,copy)NSString *pry;  //杠杆倍数
@property(nonatomic,copy)NSString *slPrecent;//止损的比例(相对于保证金)
@property(nonatomic,copy)NSString *tpPrecent;//止盈的比例(相对于保证金)
@property(nonatomic,copy)NSString *fee;   //手续费

//接口返回的参数
@property (nonatomic,readonly,copy)NSString *symbol;
@property(nonatomic,copy)NSString *contractname;
@property (nonatomic,copy)NSString *lastPrice;
@property(nonatomic,copy)NSString *cantrade;//cantrade=1 表示允许交易；cantrade=0 表示不允许交易。
@property(nonatomic,copy)NSString *balance;//可用余额
@property(nonatomic,copy)NSString *perFee;//每笔手续费
@property(nonatomic,copy)NSString *minfloat;//价格最小浮动数
@property(nonatomic,assign)NSInteger dotNum;//价格小数位
@property(nonatomic,copy)NSString *perValue;//最小浮动数对应的价值
@property(nonatomic,copy)NSString *scale;      //合约规模
@property(nonatomic,strong)NSArray *pryList; //杠杆倍数组
@property(nonatomic,strong)NSArray *slPrecentList;//最大止损的数组(相对于保证金)
@property(nonatomic,strong)NSArray *tpPrecentList;//最大止盈的数组(相对于保证金)
@property(nonatomic,strong)NSString *maxBuyAmount;//最大可买手数
@property(nonatomic,strong)NSString *amountFloat;//手数最小浮动点
@property(nonatomic,strong)NSString *marketOrderTip;//市价单tip
@property(nonatomic,strong)NSString *limitOrderTip;//限价单tip



//计算所得的数据
@property(nonatomic,copy)NSString *delegateValue;//委托价值（用于展示）

@property (nonatomic,assign,readonly) BOOL isLoaded;

//hander
@property(nonatomic,copy)dispatch_block_t priceChangedHander;

- (instancetype)initWithSymbol:(NSString *)symbol;
- (void)changedSymbol:(NSString *)symbol;
- (void)changedPrice:(NSString *)price;
- (void)changedOrdertype:(BOOL)isMarket;
- (void)configData:(NSDictionary *)dic;
- (NSDictionary *)calSLData:(NSString *)slPrencet;
- (NSDictionary *)calTPData:(NSString *)slPrencet;
- (void)calData;
+ (NSArray *)pickerData:(NSArray *)list;
+ (NSDictionary *)calSLData:(NSString *)slPrencet data:(NSDictionary *)dic;
+ (NSDictionary *)calTPData:(NSString *)slPrencet data:(NSDictionary *)dic;
@end

NS_ASSUME_NONNULL_END

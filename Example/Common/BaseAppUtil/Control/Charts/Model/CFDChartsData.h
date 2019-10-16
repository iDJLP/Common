//
//  CFDMLineDataStruct.h
//  MyKLineView
//
//  Created by Han on 13-9-25.
//  Copyright (c) 2013年 Han. All rights reserved.
//  数据模型

#import <UIKit/UIKit.h>

//基础数据
@interface  CFDBaseInfoModel:  NSObject

@property (nonatomic,copy) NSString *iStockname;//名字
@property (nonatomic,copy) NSString *contractId;//合约id
@property (nonatomic,copy) NSString *symbol;//代码
@property (nonatomic,copy) NSString *otherContractId;//合约id
@property (nonatomic,copy) NSString *iStockcode;//代码
@property (nonatomic,assign) NSInteger dotNum;//小数位
@property(nonatomic,copy)NSString *askp; //卖一价
@property(nonatomic,copy)NSString *bidp; //买一价
@property (nonatomic,copy) NSString *highPrice;
@property (nonatomic,copy) NSString *openPrice;
@property (nonatomic,copy) NSString *lowPrice;
@property (nonatomic,copy) NSString *closePrice;
@property (nonatomic,copy) NSString *lastPrice;
@property (nonatomic,copy) NSString *raise;
@property (nonatomic,copy) NSString *raisRate;
@property (nonatomic,copy) NSString *volume;
@property (nonatomic,copy) NSString *spread;
@property (nonatomic,copy) NSString *speed;
@property (nonatomic,copy) NSString *rate;
@property (nonatomic,copy) NSString *tradestatus;//交易状态
@property (nonatomic,copy) NSString *tradestatusText;//交易状态
@property (nonatomic,assign) NSOpenStatusTrade    openStatusTrade;//开盘状态 1 交易中，0 未开盘


//+ (CFDBaseInfoModel *)configData:(NSDictionary *)dict;
- (void)configNData:(NSDictionary *)dict;

- (CFDBaseInfoModel *)updateSocketDic:(NSDictionary *)dict;
//- (void)configData:(NSDictionary *)dic;

@end

//单根线数据结构
@interface CFDLineData : NSObject

@property(nonatomic,copy)NSString *timestemp; // 服务端返回的时间格式 格林威治时间戳
@property(nonatomic,copy)NSString *iTimes;   // 服务端返回的时间格式 yyyyMMddHHmmss
@property(nonatomic,assign)long long formatTimestemp; //格式化后的时间戳
@property(nonatomic,copy) NSString *iTimeText;  //绘图时间的显示
@property(nonatomic,copy) NSString *iCursorTimeText; //十字线时间的显示
@property(nonatomic,copy) NSString *iHighp;
@property(nonatomic,copy) NSString *iOpenp;
@property(nonatomic,copy) NSString *iLowp;
@property(nonatomic,copy)NSString *iNowv;

@property(nonatomic,copy)NSString *iPreclose; //分时是是昨收，k线时是上一根的收盘价
@property(nonatomic,copy)NSString *iUpdown;
@property(nonatomic,copy)NSString *iUpdownRate;

//成交量，key: volValue vol
@property(nonatomic,strong)NSDictionary *volDic;

@property(nonatomic,assign)BOOL isRed;         //量线显示的红绿
@property (nonatomic,assign)BOOL isHttpData;
- (void)setITimeTextByChartsType:(EChartsType)chartstype;
- (void)setITimeTextByChartsType:(EChartsType)chartstype timestemp:(long long)timestemp;
@end


//单根分时线数据结构
@interface CFDMLineData : CFDLineData<NSMutableCopying>

//移动平均值, key:MA5,MA10,MA20
@property(nonatomic,strong)NSDictionary *MADic;
//BOOL, key:md,up,dn
@property(nonatomic,strong)NSDictionary *BOLLDic;
///MACD指标，key:ema_12,ema_26,dif,dea,bar
@property(nonatomic,strong)NSDictionary *MACDDic;
///KDJ指标，key:rsa,k,d,j
@property(nonatomic,strong)NSDictionary *KDJDic;
///RSI指标，key:rsi1,rsi2,rsi3
@property(nonatomic,strong)NSDictionary *RSIDic;
///WR指标，key:wr1,wr2
@property(nonatomic,strong)NSDictionary *WRDic;
///BIAS指标，key:wr1,wr2
@property(nonatomic,strong)NSDictionary *BIASDic;
///CCI指标，key:wr1,wr2
@property(nonatomic,strong)NSDictionary *CCiDic;

@end

//单根K线数据结构
@interface CFDKLineData : CFDLineData<NSMutableCopying>

//移动平均值, key:MA5,MA10,MA20
@property(nonatomic,strong)NSDictionary *MADic;
//BOOL, key:md,up,dn
@property(nonatomic,strong)NSDictionary *BOLLDic;
///MACD指标，key:ema_12,ema_26,dif,dea,bar
@property(nonatomic,strong)NSDictionary *MACDDic;
///KDJ指标，key:rsa,k,d,j
@property(nonatomic,strong)NSDictionary *KDJDic;
///RSI指标，key:rsi1,rsi2,rsi3
@property(nonatomic,strong)NSDictionary *RSIDic;
///WR指标，key:wr1,wr2
@property(nonatomic,strong)NSDictionary *WRDic;
///BIAS指标，key:wr1,wr2
@property(nonatomic,strong)NSDictionary *BIASDic;
///CCI指标，key:wr1,wr2
@property(nonatomic,strong)NSDictionary *CCiDic;
@end


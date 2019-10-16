//
//  DCService.m
//  LiveTrade
//
//  Created by ngw15 on 2018/10/19.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import "DCService.h"
#import "FTDeviceInfoUtils.h"

#import "GDevice.h"
#import "CFDLocation.h"

@implementation DCService

//MARK: - HomePage

+ (NSURLSessionDataTask *)homeBannerData:(void (^)(id data)) success
                               failure:(void (^)(NSError *error)) failure{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/public/homeads.ashx",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpGuestHead];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
}

+ (NSURLSessionDataTask *)homeHelpBannerData:(void (^)(id data)) success
                                 failure:(void (^)(NSError *error)) failure{
    NSString *url = [NSString stringWithFormat:@"https://user.%@/api/getadbanners.ashx",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpGuestHead];
    params = [params stringByAppendingFormat:@"&code=1003"];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
}

/**滚动盈利榜*/
+ (NSURLSessionDataTask *)winnerlistsuccess:(void (^)(id data)) success
                                    failure:(void (^)(NSError *error)) failure
{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/winnerlist.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

//查询资讯列表
+ (NSURLSessionDataTask *)articlesDataindex:(NSInteger)index
                                      count:(NSInteger)count
                                   category:(NSString *)category
                                    success:(void (^)(id data)) success
                                    failure:(void (^)(NSError *error)) failure{
    NSString *url = [NSString stringWithFormat:@"https://news.%@/news/getarticles",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpGuestHead];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&index=%ld",(long)index]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&count=%ld",(long)count]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&category=%@",category]];
    return [FOWebService jsonWithPost:url params:param success:success failure:failure];
}
//MARK: - Market

//推荐合约列表
+ (NSURLSessionDataTask *)getRecommendDataList:(void (^)(id data)) success
                                       failure:(void (^)(NSError *error)) failure{
    NSString *url = [NSString stringWithFormat:@"https://hq.%@/v1/api/quote/recommendedProducts",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpGuestHead];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
    
}
//合约列表
+ (NSURLSessionDataTask *)demoContractDataList:(void (^)(id data)) success
                                   failure:(void (^)(NSError *error)) failure{
    NSString *url = [NSString stringWithFormat:@"https://hq.%@/v1/api/quote/product",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpGuestHead];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
}

//M线数据
+ (NSURLSessionDataTask *)demoMLineData:(NSString *)contradId
                               lineType:(NSInteger)lineType
                            success:(void (^)(id data)) success
                            failure:(void (^)(NSError *error)) failure{
    NSString *url = [NSString stringWithFormat:@"https://hq.%@/v1/api/quote/candleLines",FTConfig.domainname];
    
    NSString *params = [self paramsWithHead:HttpGuestHead];
    params = [params stringByAppendingFormat:@"&symbol=%@&interval=1m&priceType=%ld&count=300",contradId,(long)lineType];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
    
}

//k线更多历史数据
+ (NSURLSessionDataTask *)demoKLineMoreData:(NSString *)contradId
                                    endtime:(NSString *)endtime
                                 chartsType:(NSString *)chartsType
                                   lineType:(NSInteger)lineType
                                    success:(void (^)(id data)) success
                                    failure:(void (^)(NSError *error)) failure{
    NSString *url = [NSString stringWithFormat:@"https://hq.%@/v1/api/quote/candleLines",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpGuestHead];
    params = [params stringByAppendingFormat:@"&symbol=%@&interval=%@&priceType=%ld&endtime=%@&count=100",contradId,chartsType,(long)lineType,endtime];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
}

//k线新增数据
+ (NSURLSessionDataTask *)demoKLineAddData:(NSString *)contradId
                                chartsType:(NSString *)chartsType
                                  lineType:(NSInteger)lineType
                                   success:(void (^)(id data)) success
                                   failure:(void (^)(NSError *error)) failure{
    NSString *url = [NSString stringWithFormat:@"https://hq.%@/v1/api/quote/candleLines",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpGuestHead];
    params = [params stringByAppendingFormat:@"&symbol=%@&interval=%@&priceType=%ld&count=30",contradId,chartsType,(long)lineType];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
}

//k线数据
+ (NSURLSessionDataTask *)demoKLineData:(NSString *)contradId
                         chartsType:(NSString *)chartsType
                               lineType:(NSInteger)lineType
                            success:(void (^)(id data)) success
                            failure:(void (^)(NSError *error)) failure{
    NSString *url = [NSString stringWithFormat:@"https://hq.%@/v1/api/quote/candleLines",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpGuestHead];
    params = [params stringByAppendingFormat:@"&symbol=%@&interval=%@&priceType=%ld&count=300",contradId,chartsType,(long)lineType];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
}

//盘口数据数据
+ (NSURLSessionDataTask *)orderbookData:(NSString *)symbol
                             limit:(NSString *)limit
                                success:(void (^)(id data)) success
                                failure:(void (^)(NSError *error)) failure{
    NSString *url = [NSString stringWithFormat:@"https://hq.%@/v1/api/quote/orderbook",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpGuestHead];
    params = [params stringByAppendingFormat:@"&symbol=%@&limit=%@",symbol,limit];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
}

//成交明细数据
+ (NSURLSessionDataTask *)tradeData:(NSString *)symbol
                            success:(void (^)(id data)) success
                            failure:(void (^)(NSError *error)) failure{
    NSString *url = [NSString stringWithFormat:@"https://hq.%@/v1/api/quote/trades",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpGuestHead];
    params = [params stringByAppendingFormat:@"&symbol=%@&limit=20",symbol];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
}

//交易规则数据
+ (NSURLSessionDataTask *)ruleData:(NSString *)symbol
                           success:(void (^)(id data)) success
                           failure:(void (^)(NSError *error)) failure{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/public/traderule.ashx",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpGuestHead];
    params = [params stringByAppendingFormat:@"&symbol=%@",symbol];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
}


//获取行情提醒设置
+ (NSURLSessionDataTask *)getalertsymbol:(NSString *)symbol success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/alert/get.ashx",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpBaseHead];
    params = [params stringByAppendingFormat:@"&symbol=%@",symbol];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
    
}

/***行情提醒设置 alertrate:提醒级别 1 仅提醒一次 2 每日提醒 3 每次提醒
 {
 risingpriceisopen:是否打开上涨价格提醒 1 是打开，非1都是不打开（包括空
 risingprice:上涨价格
 fallpriceisopen:是否打开下跌价格提醒 1 是打开，非1都是不打开（包括空）
 fallprice:下跌价格
 dailydeclineexceed:日跌幅超过提醒
 dailydeclineexceedisopen:是否打开下跌价格提醒 1 是打开，非1都是不打开（包括空）
 dailygainexceed:日涨幅超过提醒
 dailygainexceedisopen:是否打开日涨幅超过提醒 1 是打开，非1都是不打开（包括空）
 }这些非必须，放在dic里传过来
 */
+ (NSURLSessionDataTask *)setalertsymbol:(NSString *)symbol
                               alertrate:(NSString *)alertrate
                                     dic:(NSDictionary *)dic
                                 success:(void(^)(id data))success
                                 failure:(void(^)(NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/alert/set.ashx",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpBaseHead];
    params = [params stringByAppendingFormat:@"&symbol=%@",symbol];
    params = [params stringByAppendingFormat:@"&alertrate=%@",alertrate];
    
    for(NSString *key in dic.allKeys)
    {
        params = [params stringByAppendingFormat:@"&%@=%@",key,[NDataUtil stringWith:[dic objectForKey:key] valid:@""]];
    }
    
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
}

//MARK: - Trade

//下单页面信息
+ (NSURLSessionDataTask *)getBuyPage:(NSString *)symbol success:(void (^)(id))success
                                      failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/buypage.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&symbol=%@",symbol]];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

//下单
+ (NSURLSessionDataTask *)orderSymbol:(NSString *)symbol
                                  bstype:(NSString *)bstype
                               ordertype:(NSString *)ordertype
                                   price:(NSString *)price
                                quantity:(NSString *)quantity
                                  pry:(NSString *)pry
                            slPrecent:(NSString *)slPrecent
                            tpPrecent:(NSString *)tpPrecent
                                tradefee:(NSString *)tradefee
                                  margin:(NSString *)margin
                                 success:(void (^)(id))success
                                 failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/order.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&symbol=%@&direction=%@&ordertype=%@&price=%@&quantity=%@&stoplossPrecent=%@&stopprofitPrecent=%@&pryBar=%@&tradefee=%@&margin=%@",symbol,bstype,ordertype,price,quantity,slPrecent,tpPrecent,pry,tradefee,margin]];
    
    NSString *datatype = [NSString stringWithFormat:@"&datatype=%@",[NSNumber numberWithInteger:2]];
    NSString *deviceid = [NSString stringWithFormat:@"&deviceid=%@",[NUDID deviceId]];
    NSString *mobilemode = [NSString stringWithFormat:@"&mobilemode=%@",[FTDeviceInfoUtils mobilemode]];
    NSString *ipInfo = [NSString stringWithFormat:@"&ip=%@",[CFDLocation sharedInstance].ipInfo];
    NSString *locationInfo = [NSString stringWithFormat:@"&gps=%@",[CFDLocation sharedInstance].locationInfo];
    param = [param stringByAppendingFormat:@"%@%@%@%@%@",datatype,deviceid,mobilemode,ipInfo,locationInfo];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

//快速平仓 price是ordertype=1时需传此参数
+ (NSURLSessionDataTask *)postclosePosOrderno:(NSString *)orderno ordertype:(NSString *)ordertype price:(NSString *)price quantity:(NSString *)quantity success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/closepos.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&posid=%@",orderno]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&ordertype=%@",ordertype]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&quantity=%@",quantity]];
    if([ordertype intValue] == 1)
        param = [param stringByAppendingString:[NSString stringWithFormat:@"&price=%@",price]];
    
    NSString *datatype = [NSString stringWithFormat:@"&datatype=%@",[NSNumber numberWithInteger:2]];
    NSString *deviceid = [NSString stringWithFormat:@"&deviceid=%@",[NUDID deviceId]];
    NSString *ipInfo = [NSString stringWithFormat:@"&ip=%@",[CFDLocation sharedInstance].ipInfo];
    NSString *locationInfo = [NSString stringWithFormat:@"&gps=%@",[CFDLocation sharedInstance].locationInfo];
    NSString *mobilemode = [NSString stringWithFormat:@"&mobilemode=%@",[FTDeviceInfoUtils mobilemode]];
    param = [param stringByAppendingFormat:@"%@%@%@%@%@",datatype,deviceid,mobilemode,ipInfo,locationInfo];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

///全部平仓
+ (NSURLSessionDataTask *)postCloseAllOrder:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/closeallpos.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    
    NSString *datatype = [NSString stringWithFormat:@"&datatype=%@",[NSNumber numberWithInteger:2]];
    NSString *deviceid = [NSString stringWithFormat:@"&deviceid=%@",[NUDID deviceId]];
    NSString *ipInfo = [NSString stringWithFormat:@"&ip=%@",[CFDLocation sharedInstance].ipInfo];
    NSString *locationInfo = [NSString stringWithFormat:@"&gps=%@",[CFDLocation sharedInstance].locationInfo];
    NSString *mobilemode = [NSString stringWithFormat:@"&mobilemode=%@",[FTDeviceInfoUtils mobilemode]];
    param = [param stringByAppendingFormat:@"%@%@%@%@%@",datatype,deviceid,mobilemode,ipInfo,locationInfo];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

//撤单
+ (NSURLSessionDataTask *)postcancelOrderno:(NSString *)orderno success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/cancelorder.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&orderno=%@",orderno]];
    
    NSString *datatype = [NSString stringWithFormat:@"&datatype=%@",[NSNumber numberWithInteger:2]];
    NSString *deviceid = [NSString stringWithFormat:@"&deviceid=%@",[NUDID deviceId]];
    NSString *ipInfo = [NSString stringWithFormat:@"&ip=%@",[CFDLocation sharedInstance].ipInfo];
    NSString *locationInfo = [NSString stringWithFormat:@"&gps=%@",[CFDLocation sharedInstance].locationInfo];
    NSString *mobilemode = [NSString stringWithFormat:@"&mobilemode=%@",[FTDeviceInfoUtils mobilemode]];
    param = [param stringByAppendingFormat:@"%@%@%@%@%@",datatype,deviceid,mobilemode,ipInfo,locationInfo];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

//交易订单筛选条件
+ (NSURLSessionDataTask *)getSymbolfilterlistr:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/public/symbolfilterlist.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

//查询持仓
+ (NSURLSessionDataTask *)getQueryposition:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/queryposition.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

//查询委托
+ (NSURLSessionDataTask *)getQueryEntrust:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/queryorder.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

//查询历史持仓
+ (NSURLSessionDataTask *)getQueryPositionHis:(NSString *)params page:(NSInteger)page success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/closetrade.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"%@&page=%ld&pagesize=20",params,page];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}
//查询历史委托
+ (NSURLSessionDataTask *)getQueryEntrustHis:(NSString *)params page:(NSInteger)page success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/querylimithisorder.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"%@&page=%ld&pagesize=20",params,page];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}
/***持仓分析*/
+ (NSURLSessionDataTask *)positionAnalysis:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/positionanalysis.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

/***交易分析*/
+ (NSURLSessionDataTask *)transactionanalysis:(NSString *)symbol timetype:(NSString *)timetype success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/transactionanalysis.ashx",FTConfig.domainname];
    
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"&symbol=%@",symbol];
    param = [param stringByAppendingFormat:@"&timetype=%@",timetype];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}


/***设置止盈止损*/
+ (NSURLSessionDataTask *)postSetSLTPWithPosid:(NSString *)posid stopprofit:(NSString *)stopprofit stoploss:(NSString *)stoploss success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/setstopprice.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&posid=%@",posid]];
    
    NSString *optype = @"2";
    if (stoploss.length<=0) {
        optype = @"1";
        param = [param stringByAppendingString:[NSString stringWithFormat:@"&stopPrecent=%@",stopprofit]];
    }else{
        param = [param stringByAppendingString:[NSString stringWithFormat:@"&stopPrecent=%@",stoploss]];
    }
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&optype=%@",optype]];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

/***更改委托的止盈止损 1:tp,2:sl*/
+ (NSURLSessionDataTask *)postUpdateSLTPWithOrderno:(NSString *)orderno optype:(NSString *)optype stopprofit:(NSString *)stopprofit stoploss:(NSString *)stoploss success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/updateorder.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&orderno=%@",orderno]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&optype=%@",optype]];
    if (stoploss.length>0) {
        param = [param stringByAppendingString:[NSString stringWithFormat:@"&stoplossprecent=%@",stoploss]];
    }
    if (stopprofit.length>0) {
        param = [param stringByAppendingString:[NSString stringWithFormat:@"&stopprofitprecent=%@",stopprofit]];
    }
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}



/***查询止盈止损*/
+ (NSURLSessionDataTask *)postQuerySLTPWithPosid:(NSString *)posid success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/queryprofit.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&posid=%@",posid]];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

/***查询用户余额*/
+ (NSURLSessionDataTask *)postgetuserbalance:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/getuserbalance.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

/***查询用户浮动盈亏*/
+ (NSURLSessionDataTask *)postgetUserProfit:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/querytotalprofit.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

/***查询用户账户资产*/
+ (NSURLSessionDataTask *)postgetUserAccount:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/getuseraccounts.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}


/***查询用户账户详情*/
+ (NSURLSessionDataTask *)postgetUserAccountDetail:(NSString *)currentType success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/getaccountdetail.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&currentType=%@",currentType]];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

/***查询用户多账户余额*/
+ (NSURLSessionDataTask *)postgetUserAmounts:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/getuseramounts.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

/***币币兑换*/
+ (NSURLSessionDataTask *)currencyexchange:(NSString *)amount fromcurrency:(NSString *)fromcurrency tocurrency:(NSString *)tocurrency success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/currencyexchange.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"&fromcurrency=%@",fromcurrency];
    param = [param stringByAppendingFormat:@"&tocurrency=%@",tocurrency];
    param = [param stringByAppendingFormat:@"&money=%@",amount];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

/***币币兑换记录*/
+ (NSURLSessionDataTask *)currencyexchangeRecorde:(NSInteger )page params:(NSString *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/querycurrencyexchangeflow.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"%@&page=%ld",params,page];
    param = [param stringByAppendingFormat:@"&pagesize=20"];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

/***查询品种列表*/
+ (NSURLSessionDataTask *)getcurrencylist:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/payment/getcurrencylist.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

/***查询品种汇率*/
+ (NSURLSessionDataTask *)getCurrencyRate:(NSString *)currency success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/payment/getcurrencyexchangerate.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&currency=%@",currency]];
    return [FOWebService jsonWithPost:url params:param success:success failure:failure];
}



//MARK: - Login

//注册
+ (NSURLSessionDataTask *)postregisterMobile:(NSString *)mobile
                                        Code:(NSString *)code
                                    password:(NSString *)password
                                      yqCode:(NSString *)yqCode
                                       cCode:(NSString *)cCode
                                      sucess:(void(^)(id data))success
                                     failure:(void(^)(NSError *error))failure
{
    
    NSString *url = [NSString stringWithFormat:@"https://user.%@/Api/register.ashx",FTConfig.domainname];
    NSString *head = [self paramsWithHead:HttpGuestHead];
    NSData *nsdata = [mobile
                      dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    url = [url stringByAppendingFormat:@"?%@",head];
    
    NSString *param = [NSString stringWithFormat:@"mobile=%@",base64Encoded];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&code=%@",code]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&password=%@",password]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&ycode=%@",yqCode]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&ccode=%@",cCode]];
    
    if([FTConfig sharedInstance].deviceToken.length>0)
        param = [param stringByAppendingString:[NSString stringWithFormat:@"&deviceUserToken=%@",[FTConfig sharedInstance].deviceToken]];
    return [FOWebService jsonWithPost:url params:param success:success failure:failure];
}

//检查验证码
+ (NSURLSessionDataTask *)postcheckVerifyCodeMobile:(NSString *)mobile
                                               code:(NSString *)code
                                            smsType:(int)smsType
                                             sucess:(void(^)(id data))success
                                            failure:(void(^)(NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"https://user.%@/Api/checkVerifyCode.ashx",FTConfig.domainname];
    NSString *head = [self paramsWithHead:HttpGuestHead];
    NSData *nsdata = [mobile
                      dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    url = [url stringByAppendingFormat:@"?%@",head];
    
    NSString *param = [NSString stringWithFormat:@"mobile=%@",base64Encoded];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&code=%@",code]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&smsType=%d",smsType]];
    return [FOWebService jsonWithPost:url params:param success:success failure:failure];
}

//登录
+ (NSURLSessionDataTask *)postloginMobile:(NSString *)mobile
                                 password:(NSString *)password
                                  success:(void(^)(id data))success
                                  failure:(void(^)(NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"https://user.%@/Api/login.ashx",FTConfig.domainname];
    NSString *head = [self paramsWithHead:HttpGuestHead];
    head = [head stringByAppendingFormat:@"&ip=%@",[CFDLocation sharedInstance].ipInfo];
    NSData *nsdata = [mobile
                      dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    url = [url stringByAppendingFormat:@"?%@",head];
    NSString *param = [NSString stringWithFormat:@"mobile=%@",base64Encoded];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&password=%@",password]];
    return [FOWebService jsonWithPost:url params:param success:success failure:failure];
}

///获取国家吗
+ (NSURLSessionDataTask *)getCountryCode:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://user.%@/Api/getcountrycode.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpGuestHead];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

//登出
+ (NSURLSessionDataTask *)postloginOut:(void(^)(id data))success
                               failure:(void(^)(NSError *error))failure
{
    
    NSString *url = [NSString stringWithFormat:@"https://user.%@/Api/loginOut.ashx",FTConfig.domainname];
    NSString *head = [self paramsWithHead:HttpBaseHead];
    url = [url stringByAppendingFormat:@"?%@",head];
    NSMutableDictionary *deveiceDict = [NSMutableDictionary dictionary];
    deveiceDict[@"usertoken"] = [UserModel userToken];
    deveiceDict[@"packtype"] = [FTConfig sharedInstance].packType;
    deveiceDict[@"idfa"] = [Bugly buglyDeviceId];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:deveiceDict options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    NSString *md5string = [[NDataUtil md5:jsonString] uppercaseString];
    NSString *desString  = [NDataUtil encodeWithDES:jsonString key:[FTConfig sharedInstance].deskey];
    NSString * params = [NSString stringWithFormat:@"&deviceparams=%@&sign=%@",desString,md5string];
    
    
    return [FOWebService jsonWithPost:url params:params success:success failure:failure];
}

//获取验证码
+ (NSURLSessionDataTask *)postgetVerifyCodeMobile:(NSString *)mobile smsType:(int)smsType ccode:(NSString *) ccode sucess:(void(^)(id data))success failure:(void(^)(NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"https://user.%@/Api/getverifycode.ashx",FTConfig.domainname];
    NSString *head = [self paramsWithHead:HttpGuestHead];
    url = [url stringByAppendingFormat:@"?%@",head];
    
    NSData *nsdata = [mobile
                      dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    NSString *param = [NSString stringWithFormat:@"mobile=%@",base64Encoded];
    if (ccode.length>0) {
        param = [param stringByAppendingString:[NSString stringWithFormat:@"&ccode=%@",ccode]];
    }
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&smsType=%d",smsType]];
    return [FOWebService jsonWithPost:url params:param success:success failure:failure];
}

/***重置密码*/
+ (NSURLSessionDataTask *)postgetresetpasswordMobile:(NSString *)mobile
                                                code:(NSString *)code
                                               ccode:(NSString *)ccode
                                              newpwd:(NSString *)newpwd
                                              sucess:(void(^)(id data))success
                                             failure:(void(^)(NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"https://user.%@/Api/resetPassword.ashx",FTConfig.domainname];
    NSString *head = [self paramsWithHead:HttpBaseHead];
    url = [url stringByAppendingFormat:@"?%@",head];
    
    NSData *nsdata = [mobile
                      dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64Encoded = [nsdata base64EncodedStringWithOptions:0];
    
    NSData *newpwdData = [newpwd dataUsingEncoding:NSUTF8StringEncoding];
    NSString *newpwdEncoded = [newpwdData base64EncodedStringWithOptions:0];
    NSString *param = [NSString stringWithFormat:@"mobile=%@",base64Encoded];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&newpwd=%@",newpwdEncoded]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&code=%@",code]];
//    param = [param stringByAppendingString:[NSString stringWithFormat:@"&ccode=%@",ccode]];
    
    return [FOWebService jsonWithPost:url params:param success:success failure:failure];
}

//MARK: - User

/***校验密码*/
+ (NSURLSessionDataTask *)checkpwd:(NSString *)pwd
                           success:(void(^)(id data))success
                           failure:(void(^)(NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"https://user.%@/Api/validePassword.ashx",FTConfig.domainname];
    NSString *head = [self paramsWithHead:HttpBaseHead];
    url = [url stringByAppendingFormat:@"?%@",head];
    NSString *param = [NSString stringWithFormat:@"password=%@",pwd];
    return [FOWebService jsonWithPost:url params:param success:success failure:failure];
}



/***用户中心*/
+ (NSURLSessionDataTask *)postgetUserIndex:(void(^)(id data))success
                                   failure:(void(^)(NSError *error))failure
{
    NSString *url = [NSString stringWithFormat:@"https://user.%@/Api/getUserIndex.ashx",FTConfig.domainname];
    NSString *head = [self paramsWithHead:HttpBaseHead];
    url = [url stringByAppendingFormat:@"?%@",head];
    return [FOWebService jsonWithPost:url params:nil success:success failure:failure];
}

//绑定身份证
+ (NSURLSessionDataTask *)postaddidcard:(NSString *)idcard name:(NSString *)name success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/wallet/addidcard.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&idcard=%@",idcard]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&name=%@",name]];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

//绑定银行卡
+ (NSURLSessionDataTask *)postaddbank:(NSString *)currenttype banktypename:(NSString *)banktypename bankaccount:(NSString *)bankaccount success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/wallet/addbank.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&banktypename=%@",banktypename]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&bankaccount=%@",bankaccount]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&currenttype=%@",currenttype]];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}


//解绑银行卡
+ (NSURLSessionDataTask *)postunbindbankwalletbankid:(NSString *)walletbankid currenttype:(NSString *)currenttype success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/wallet/unbindbank.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&walletbankid=%@",walletbankid]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&currenttype=%@",currenttype]];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

///打开，关闭谷歌验证
+ (NSURLSessionDataTask *)operateGoogleAuth:(BOOL )isOpen
                                       key1:(NSString *)key1
                                       key2:(NSString *)key2
                                    emsCode:(NSString *)emsCode
                                 googleCode:(NSString *)googleCode
                                     success:(void (^)(id data))success
                                     failure:(void (^)(NSError * error))failure{
    NSString *url = [NSString stringWithFormat:@"https://user.%@/Api/GoogleAuthen.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param=[param stringByAppendingFormat:@"&flag=%d",isOpen?3:4];
    param=[param stringByAppendingFormat:@"&smsCode=%@",emsCode];
    param=[param stringByAppendingFormat:@"&googleCode=%@",googleCode];
    if (isOpen) {
        param=[param stringByAppendingFormat:@"&gSecretkey=%@",key1];
        param=[param stringByAppendingFormat:@"&gEntryKey=%@",key2];
    }
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

///验证谷歌验证
+ (NSURLSessionDataTask *)verifyGoogleAuth:(NSString *)code
                                       key:(NSString *)gSecretkey
                                    success:(void (^)(id data))success
                                    failure:(void (^)(NSError * error))failure{
    NSString *url = [NSString stringWithFormat:@"https://user.%@/Api/GoogleAuthen.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param=[param stringByAppendingFormat:@"&flag=2"];
    param=[param stringByAppendingFormat:@"&code=%@",code];
    if (gSecretkey.length>0) {
        param=[param stringByAppendingFormat:@"&gSecretkey=%@",gSecretkey];
        param=[param stringByAppendingFormat:@"&isGAuthenStatus=%d",NO];
    }else{
        param=[param stringByAppendingFormat:@"&isGAuthenStatus=%d",YES];
    }
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

///获取谷歌验证信息
+ (NSURLSessionDataTask *)getGoogleAuthInfo:(void (^)(id data))success
                                    failure:(void (^)(NSError * error))failure{
    NSString *url = [NSString stringWithFormat:@"https://user.%@/Api/GoogleAuthen.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param=[param stringByAppendingFormat:@"&flag=1"];
    param=[param stringByAppendingFormat:@"&qrCodeWidth=280"];
    param=[param stringByAppendingFormat:@"&qrCodeHeight=280"];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}



/**消息中心***/
+ (NSURLSessionDataTask *) getMessageList:(void (^)(id data)) success
                              failure:(void (^)(NSError *error)) failure{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/notice/getlastnewnotice.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

+ (NSURLSessionDataTask *) getMessage:(NSInteger)pageindex
                             pagesize:(NSInteger)pagesize
                                 type:(NSString *)type
                              success:(void (^)(id data)) success
                              failure:(void (^)(NSError *error)) failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/notice/noticelog.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param=[param stringByAppendingFormat:@"&type=%@&pageindex=%ld&pagesize=%ld",type,(long)pageindex,(long)pagesize];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

//新手训练营
+ (NSURLSessionDataTask *)postInvestmentCamp:(NSString *)category
                                     success:(void (^)(id data))success
                                     failure:(void (^)(NSError * error))failure{
    NSString *url = [NSString stringWithFormat:@"https://user.%@/api/getnews.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpGuestHead];
    param=[param stringByAppendingFormat:@"&code=%@&pageindex=1&pagesize=20",category];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

//MARK: - 出入金

//出入金订单筛选条件
+ (NSURLSessionDataTask *)getOrderfilter:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/payment/orderfilter.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"&type=OTC"];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

//入金显示数据
+ (NSURLSessionDataTask *)getpaymentmethod:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/payment/paymentmethod.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

//出金显示数据
+ (NSURLSessionDataTask *)getDrawlData:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/wallet/getwalletmethod.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

//出入金显示用户数据
+ (NSURLSessionDataTask *)getAvailData:(NSString *)type isOTC:(BOOL)isOTC priceArrow:(BOOL)isBuy success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/payment/getAmountInfo.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"&currencyType=%@&priceArrow=%@",type,isBuy?@"BUY":@"SELL"];
    param = [param stringByAppendingFormat:@"&type=%@",isOTC?@"OTC":@"CHAIN"];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

//获取usdt汇率
+ (NSURLSessionDataTask *)getpaymentRate:(NSString *)payid priceCoin:(NSString *)priceCoin priceArrow:(NSString *)type success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = @"";
    if ([type isEqualToString:@"BUY"]) {
        url = [NSString stringWithFormat:@"https://pay.%@/payment/bygetexchangerate.ashx",FTConfig.domainname];
    }else{
        url = [NSString stringWithFormat:@"https://pay.%@/wallet/getsellrate.ashx",FTConfig.domainname];
    }
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"&payid=%@&priceArrow=%@&priceCoin=%@",payid,type,priceCoin];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

//获取正在交易订单（出入金）
+ (NSURLSessionDataTask *)getpayOrder:(BOOL)isOtc success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/payment/bypaycenterget.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"&ordertype=%@",isOtc?@"OTC":@"CHAIN"];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

//取消正在交易订单（出入金）
+ (NSURLSessionDataTask *)getpayCancelOrder:(NSString *)orderId logId:(NSString *)logId success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/payment/byordercancel.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"&orderId=%@",orderId];
    param = [param stringByAppendingFormat:@"&logId=%@",logId];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

//确认付款正在交易订单（出入金）
+ (NSURLSessionDataTask *)getpayConfirmOrder:(NSString *)orderId logId:(NSString *)logId success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/payment/byorderconfirm.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"&orderId=%@",orderId];
    param = [param stringByAppendingFormat:@"&logId=%@",logId];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

//Otc记录list
+ (NSURLSessionDataTask *)getOtcOrderlist:(BOOL)isDeposit params:(NSString *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/payment/getorderlist.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"%@&priceArrow=%@",params,isDeposit?@"BUY":@"SELL"];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

//chain记录list
+ (NSURLSessionDataTask *)getChainOrderlist:(BOOL)isDeposit params:(NSString *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/payment/chaingetorderlist.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"%@&priceArrow=%@",params,isDeposit?@"BUY":@"SELL"];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

//otc订单详情
+ (NSURLSessionDataTask *)getOtcOrderDetail:(NSString *)logid txtId:(NSString *)txtId isDeposit:(BOOL)isBuy success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/payment/bygetorderurl.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"&logId=%@",logid];
    param = [param stringByAppendingFormat:@"&txtid=%@",txtId];
    param = [param stringByAppendingFormat:@"&priceArrow=%@",isBuy?@"BUY":@"SELL"];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

//chain订单详情
+ (NSURLSessionDataTask *)getChainOrderDetail:(NSString *)logid txtId:(NSString *)txtId currenttype:(NSString *)currenttype isDeposit:(BOOL)isBuy success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/payment/chaingetorderurl.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"&logId=%@",logid];
    param = [param stringByAppendingFormat:@"&txtid=%@",txtId];
    param = [param stringByAppendingFormat:@"&currenttype=%@",currenttype];
    param = [param stringByAppendingFormat:@"&priceArrow=%@",isBuy?@"BUY":@"SELL"];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

//获取入金订单
+ (NSURLSessionDataTask *)getpayHisOrder:(NSString *)payId page:(NSInteger)page success:(void (^)(id))success failure:(void (^)(NSError *))failure
{

    NSString *url = [NSString stringWithFormat:@"https://pay.%@/payment/getorderlist.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"&pagesize=15"];
    param = [param stringByAppendingFormat:@"&pageindex=%ld",(long)page];
    if (payId.length>0) {
        param = [param stringByAppendingFormat:@"&payid=%@",payId];
    }
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

//获取连上入金
+ (NSURLSessionDataTask *)chainusdtPay:(NSString *)payId currencyType:(NSString *)currencyType success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/payment/chainpay.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"&payid=%@",payId];
    param = [param stringByAppendingFormat:@"&currencyType=%@",currencyType];
    return [FOWebService jsonWithGet:url params:param success:success failure:failure];
}

// 提交OTC出金接口
+ (NSURLSessionDataTask *)commitOTCDrawl:(NSString *)amount exchangetrade:(NSString *)exchangetrade amountrmb:(NSString *)amountrmb currenttype:(NSString *)currenttype success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/wallet/walletrquest.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&amount=%@",amount]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&exchangetrade=%@",exchangetrade]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&amountrmb=%@",amountrmb]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&walletbankid=%@",[UserModel sharedInstance].walletBankId]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&currenttype=%@",currenttype]];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

// 提交链上出金接口
+ (NSURLSessionDataTask *)commitChainDrawl:(NSString *)amount address:(NSString *)address currenttype:(NSString *)currenttype success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/wallet/chainwalletrquest.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"&amount=%@",amount];
    param = [param stringByAppendingFormat:@"&timestamp=%ld",(long)[[NSDate date] timeIntervalSince1970]];
    param = [param stringByAppendingFormat:@"&address=%@",address];
    param = [param stringByAppendingFormat:@"&currenttype=%@",currenttype];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

/*** 资金明细
 资金明细类型
 全部：optype=0或者不传
 充值：optype=1
 提现：optype=2
 开仓：optype=3
 结算：optype=4*/
+ (NSURLSessionDataTask *)postquerymoneyflowoptype:(NSInteger)optype page:(NSInteger)page pagesize:(NSInteger)pagesize success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://trade.%@/querymoneyflow.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&optype=%ld",(long)optype]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&page=%ld",(long)page]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&pagesize=%ld",(long)pagesize]];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

/**获取用户链上地址列表*/
+ (NSURLSessionDataTask *)addresslist:(NSString *)currenttype success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/wallet/addresslist.ashx",FTConfig.domainname];
    NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"&currenttype=%@",currenttype];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

/**用户链上地址（1：修改；2：新增；3：删除）*/
+ (NSURLSessionDataTask *)addressManage:(NSString *)action currenttype:(NSString *)currenttype params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/wallet/addressmanage.ashx",FTConfig.domainname];
    __block NSString *param = [self paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingFormat:@"&action=%@",action];
    param = [param stringByAppendingFormat:@"&currenttype=%@",currenttype];
    [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        param = [param stringByAppendingFormat:@"&%@=%@",key,obj];
    }];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"param=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

//MARK: - Others

//得到IP地址
+ (NSURLSessionDataTask *)getIPInfo:(NSString *)url
                            success:(void (^)(id))success
                            failure:(void (^)(NSError *))failure
{
    
    return [FOWebService jsonWithGet:url params:@"" success:success failure:failure];
}

//更新版本消息
+ (NSURLSessionDataTask *)updateVersion:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"https://user.%@/api/getappinfo.ashx",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpGuestHead];
    params = [params stringByAppendingFormat:@"&platformtype=1"];
    params = [NDataUtil encodeWithDES_9bf1c9b0:params key:[FTConfig sharedInstance].deskey];
    params = [NSString stringWithFormat:@"param=%@",params];
    return [FOWebService desWithPost:url params:params desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

//更新token
+ (NSURLSessionDataTask *)updateUserToken:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"https://user.%@/Api/updateUserToken.ashx",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpBaseHead];
    return [FOWebService jsonWithPost:url params:params success:success failure:failure];
}



//获取客服方式
+(NSURLSessionDataTask*)getCustomerService:(void (^)(id))success
                                   failure:(void (^)(NSError *))failure
{   
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/public/customerservice.ashx",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpGuestHead];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
}

//获取投诉客服方式
+(NSURLSessionDataTask*)getSuggestService:(void (^)(id))success
                                   failure:(void (^)(NSError *))failure
{
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/public/complaint.ashx",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpGuestHead];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
}

//设备收集接口
+ (NSURLSessionDataTask *)deviceSynctype:(NSNumber *)operatetype
                                 success:(void (^)(id))success
                                 failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"https://user.%@/Api/deviceSync.ashx",FTConfig.domainname];
    url = [url stringByAppendingFormat:@"?%@",[self paramsWithHead:HttpBaseHead]];
    
    NSString *param = [DCService paramsWithHead:HttpBaseHead];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&loginstatus=%@",operatetype]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&deviceid=%@",[Bugly buglyDeviceId]]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&mobilename=%@",[FTDeviceInfoUtils mobilemode]]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&systemversion=%@",[FTDeviceInfoUtils os]]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&apntoken=%@",[[FTConfig sharedInstance] deviceToken]]];
    
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&idfa=%@",[NUDID idfa]]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&os=%d",1]];
    param = [param stringByAppendingString:[NSString stringWithFormat:@"&isjailbroken=%d",[[UIDevice currentDevice]isJailbroken]]];
    param = [NDataUtil encodeWithDES_9bf1c9b0:param key:[FTConfig sharedInstance].deskey];
    param = [NSString stringWithFormat:@"deviceparams=%@",param];
    return [FOWebService desWithPost:url params:param desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

//是否有未读消息
+ (NSURLSessionDataTask *)hasUnReadNotice:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/notice/getnewnoticecount.ashx",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpBaseHead];
    params = [params stringByAppendingFormat:@"&type=0"];
    return [FOWebService jsonWithPost:url params:params success:success failure:failure];
}

//系统消息设置为已读消息
+ (NSURLSessionDataTask *)setReadNotice:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"https://pay.%@/notice/setRead.ashx",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpBaseHead];
    params = [params stringByAppendingFormat:@"&type=1"];
    params = [NDataUtil encodeWithDES_9bf1c9b0:params key:[FTConfig sharedInstance].deskey];
    params = [NSString stringWithFormat:@"param=%@",params];
    return [FOWebService desWithPost:url params:params desKey:[FTConfig sharedInstance].deskey success:success failure:failure];
}

//事件统计
+ (NSURLSessionDataTask *)eventCollect:(NSString *)event success:(void (^)(id))success failure:(void (^)(NSError *))failure{
    NSString *url = [NSString stringWithFormat:@"https://user.%@/v1/api/AppBehavior/DataCollect",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpBaseHead];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
}



//获取websocket的url
+ (NSURLSessionDataTask *)wssAddressUrl:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"https://hq.%@/v1/api/mktdata/GetWebSocketAddress",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpGuestHead];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
}

//获取domain列表
+ (NSURLSessionDataTask *)getDomain:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSString *url = @"https://winbi.oss-cn-hangzhou.aliyuncs.com/domain.json";
    NSString *params = [self paramsWithHead:HttpGuestHead];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
}

//检测domain列表
+ (NSURLSessionDataTask *)checkDomain:(void (^)(id))success failure:(void (^)(NSError *))failure{
    
    NSString *url = [NSString stringWithFormat:@"https://user.%@/Api/checkdomain.html",FTConfig.domainname];
    NSString *params = [self paramsWithHead:HttpGuestHead];
    return [FOWebService jsonWithGet:url params:params success:success failure:failure];
}



//MARK: - Private

// HTTP参数头
+ (NSString *)paramsWithHead:(HttpHeadType)type
{
    FTConfig *config = [FTConfig sharedInstance];
    UserModel *userModel = [UserModel sharedInstance];
    NSString *userToken = userModel.userToken;
    NSString *params = [NSString stringWithFormat:@"version=%@&packtype=%@&proxyid=%@&lang=%@&channel=ee",config.version,config.packType,config.proxyid,config.lang];
    switch (type) {
        case HttpGuestHead:
            break;
        case HttpBaseHead:
            params = [params stringByAppendingFormat:@"&usertoken=%@",userToken];
            break;
        default:
            params = @"";
            break;
    }
     
    return params;
}

+ (NSString *)convertToJsonData:(NSDictionary *)dict{
    
    NSError *error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
    
    NSString *jsonString;
    
    if (!jsonData) {
        
        NSLog(@"%@",error);
        
    }else{
        jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSMutableString *mutStr = [NSMutableString stringWithString:jsonString];
    NSRange range = {0,jsonString.length};
    //去掉字符串中的空格
    [mutStr replaceOccurrencesOfString:@" " withString:@"" options:NSLiteralSearch range:range];
    
    NSRange range2 = {0,mutStr.length};
    //去掉字符串中的换行符
    [mutStr replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:range2];
    
    return mutStr;
    
}

@end

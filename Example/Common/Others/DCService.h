//
//  DCService.h
//  LiveTrade
//
//  Created by ngw15 on 2018/10/19.
//  Copyright © 2018年 taojinzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FOWebService.h"

@interface DCService : NSObject

//MARK: - Home
//首页banner
+ (NSURLSessionDataTask *)homeBannerData:(void (^)(id data)) success
                                 failure:(void (^)(NSError *error)) failure;
//首页帮助Banner
+ (NSURLSessionDataTask *)homeHelpBannerData:(void (^)(id data)) success
                                     failure:(void (^)(NSError *error)) failure;
/**滚动盈利榜*/
+ (NSURLSessionDataTask *)winnerlistsuccess:(void (^)(id data)) success
                                    failure:(void (^)(NSError *error)) failure;
//查询资讯列表
+ (NSURLSessionDataTask *)articlesDataindex:(NSInteger)index
                                         count:(NSInteger)count
                                      category:(NSString *)category
                                       success:(void (^)(id data)) success
                                       failure:(void (^)(NSError *error)) failure;

//MARK: - Market

//k线更多历史数据
+ (NSURLSessionDataTask *)demoKLineMoreData:(NSString *)contradId
                                    endtime:(NSString *)endtime
                             chartsType:(NSString *)chartsType
                               lineType:(NSInteger)lineType
                                success:(void (^)(id data)) success
                                failure:(void (^)(NSError *error)) failure;

//k线数据
+ (NSURLSessionDataTask *)demoKLineData:(NSString *)contradId
                             chartsType:(NSString *)chartsType
                               lineType:(NSInteger)lineType
                                success:(void (^)(id data)) success
                                failure:(void (^)(NSError *error)) failure;

//k线新增数据
+ (NSURLSessionDataTask *)demoKLineAddData:(NSString *)contradId
                             chartsType:(NSString *)chartsType
                               lineType:(NSInteger)lineType
                                success:(void (^)(id data)) success
                                failure:(void (^)(NSError *error)) failure;
//M线数据
+ (NSURLSessionDataTask *)demoMLineData:(NSString *)contradId
                               lineType:(NSInteger)lineType
                                success:(void (^)(id data)) success
                                failure:(void (^)(NSError *error)) failure;
//盘口数据数据
+ (NSURLSessionDataTask *)orderbookData:(NSString *)symbol
                                  limit:(NSString *)limit
                                success:(void (^)(id data)) success
                                failure:(void (^)(NSError *error)) failure;
//成交明细数据
+ (NSURLSessionDataTask *)tradeData:(NSString *)symbol
                            success:(void (^)(id data)) success
                            failure:(void (^)(NSError *error)) failure;
//交易规则数据
+ (NSURLSessionDataTask *)ruleData:(NSString *)symbol
                           success:(void (^)(id data)) success
                           failure:(void (^)(NSError *error)) failure;
//合约列表
+ (NSURLSessionDataTask *)demoContractDataList:(void (^)(id data)) success
                                       failure:(void (^)(NSError *error)) failure;
//推荐合约列表
+ (NSURLSessionDataTask *)getRecommendDataList:(void (^)(id data)) success
                                       failure:(void (^)(NSError *error)) failure;

//获取行情提醒设置
+ (NSURLSessionDataTask *)getalertsymbol:(NSString *)symbol success:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (NSURLSessionDataTask *)setalertsymbol:(NSString *)symbol
                               alertrate:(NSString *)alertrate
                                     dic:(NSDictionary *)dic
                                 success:(void(^)(id data))success
                                 failure:(void(^)(NSError *error))failure;

//MARK: - Trade

//下单页面信息
+ (NSURLSessionDataTask *)getBuyPage:(NSString *)symbol success:(void (^)(id))success
                             failure:(void (^)(NSError *))failure;
//下单
+ (NSURLSessionDataTask *)orderSymbol:(NSString *)contractid
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
                              failure:(void (^)(NSError *))failure;
//快速平仓 price是ordertype=1时需传此参数
+ (NSURLSessionDataTask *)postclosePosOrderno:(NSString *)orderno ordertype:(NSString *)ordertype price:(NSString *)price quantity:(NSString *)quantity success:(void (^)(id))success failure:(void (^)(NSError *))failure;
///全部平仓
+ (NSURLSessionDataTask *)postCloseAllOrder:(void (^)(id))success failure:(void (^)(NSError *))failure;
//撤单
+ (NSURLSessionDataTask *)postcancelOrderno:(NSString *)orderno success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//交易订单筛选条件
+ (NSURLSessionDataTask *)getSymbolfilterlistr:(void (^)(id))success failure:(void (^)(NSError *))failure;
//查询持仓
+ (NSURLSessionDataTask *)getQueryposition:(void (^)(id))success failure:(void (^)(NSError *))failure;
//查询委托
+ (NSURLSessionDataTask *)getQueryEntrust:(void (^)(id))success failure:(void (^)(NSError *))failure;
//查询历史持仓
+ (NSURLSessionDataTask *)getQueryPositionHis:(NSString *)params page:(NSInteger)page success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//查询历史委托
+ (NSURLSessionDataTask *)getQueryEntrustHis:(NSString *)params page:(NSInteger)page success:(void (^)(id))success failure:(void (^)(NSError *))failure;
/***持仓分析*/
+ (NSURLSessionDataTask *)positionAnalysis:(void (^)(id))success failure:(void (^)(NSError *))failure;
/***交易分析*/
+ (NSURLSessionDataTask *)transactionanalysis:(NSString *)symbol timetype:(NSString *)timetype success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/***更改委托的止盈止损 1:tp,2:sl*/
+ (NSURLSessionDataTask *)postUpdateSLTPWithOrderno:(NSString *)orderno optype:(NSString *)optype stopprofit:(NSString *)stopprofit stoploss:(NSString *)stoploss success:(void (^)(id))success failure:(void (^)(NSError *))failure;
/***设置止盈止损*/
+ (NSURLSessionDataTask *)postSetSLTPWithPosid:(NSString *)posid stopprofit:(NSString *)stopprofit stoploss:(NSString *)stoploss success:(void (^)(id))success failure:(void (^)(NSError *))failure;
/***查询止盈止损*/
+ (NSURLSessionDataTask *)postQuerySLTPWithPosid:(NSString *)posid success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/***查询用户余额*/
+ (NSURLSessionDataTask *)postgetuserbalance:(void (^)(id))success failure:(void (^)(NSError *))failure;
/***查询用户浮动盈亏*/
+ (NSURLSessionDataTask *)postgetUserProfit:(void (^)(id))success failure:(void (^)(NSError *))failure;


//MARK: - Login

//注册
+ (NSURLSessionDataTask *)postregisterMobile:(NSString *)mobile
                                        Code:(NSString *)code
                                    password:(NSString *)password
                                      yqCode:(NSString *)yqCode
                                       cCode:(NSString *)cCode
                                      sucess:(void(^)(id data))success
                                     failure:(void(^)(NSError *error))failure;
//检查验证码
+ (NSURLSessionDataTask *)postcheckVerifyCodeMobile:(NSString *)mobile
                                               code:(NSString *)code
                                            smsType:(int)smsType
                                             sucess:(void(^)(id data))success
                                            failure:(void(^)(NSError *error))failure;
//登录
+ (NSURLSessionDataTask *)postloginMobile:(NSString *)mobile
                                 password:(NSString *)password
                                  success:(void(^)(id data))success
                                  failure:(void(^)(NSError *error))failure;
///获取国家吗
+ (NSURLSessionDataTask *)getCountryCode:(void (^)(id))success failure:(void (^)(NSError *))failure;
//登出
+ (NSURLSessionDataTask *)postloginOut:(void(^)(id data))success
                               failure:(void(^)(NSError *error))failure;
//获取验证码
+ (NSURLSessionDataTask *)postgetVerifyCodeMobile:(NSString *)mobile smsType:(int)smsType ccode:(NSString *) ccode sucess:(void(^)(id data))success failure:(void(^)(NSError *error))failure;
/***重置密码*/
+ (NSURLSessionDataTask *)postgetresetpasswordMobile:(NSString *)mobile
                                                code:(NSString *)code
                                               ccode:(NSString *)ccode
                                              newpwd:(NSString *)newpwd
                                              sucess:(void(^)(id data))success
                                             failure:(void(^)(NSError *error))failure;

//MARK: - User

/***校验密码*/
+ (NSURLSessionDataTask *)checkpwd:(NSString *)pwd
                           success:(void(^)(id data))success
                           failure:(void(^)(NSError *error))failure;

/***用户中心*/
+ (NSURLSessionDataTask *)postgetUserIndex:(void(^)(id data))success
                                   failure:(void(^)(NSError *error))failure;
/***查询用户账户资产*/
+ (NSURLSessionDataTask *)postgetUserAccount:(void (^)(id))success failure:(void (^)(NSError *))failure;
/***查询用户账户详情*/
+ (NSURLSessionDataTask *)postgetUserAccountDetail:(NSString *)currentType success:(void (^)(id))success failure:(void (^)(NSError *))failure;
/***查询用户多账户余额*/
+ (NSURLSessionDataTask *)postgetUserAmounts:(void (^)(id))success failure:(void (^)(NSError *))failure;
/***币币兑换*/
+ (NSURLSessionDataTask *)currencyexchange:(NSString *)amount fromcurrency:(NSString *)fromcurrency tocurrency:(NSString *)tocurrency success:(void (^)(id))success failure:(void (^)(NSError *))failure;
/***币币兑换记录*/
+ (NSURLSessionDataTask *)currencyexchangeRecorde:(NSInteger )page params:(NSString *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
/***查询品种列表*/
+ (NSURLSessionDataTask *)getcurrencylist:(void (^)(id))success failure:(void (^)(NSError *))failure;
/***查询品种列表*/
+ (NSURLSessionDataTask *)getCurrencyRate:(NSString *)currency success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//绑定身份证
+ (NSURLSessionDataTask *)postaddidcard:(NSString *)idcard name:(NSString *)name success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//绑定银行卡
+ (NSURLSessionDataTask *)postaddbank:(NSString *)currenttype banktypename:(NSString *)banktypename bankaccount:(NSString *)bankaccount success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//解绑银行卡
+ (NSURLSessionDataTask *)postunbindbankwalletbankid:(NSString *)walletbankid currenttype:(NSString *)currenttype success:(void (^)(id))success failure:(void (^)(NSError *))failure;
///打开，关闭谷歌验证
+ (NSURLSessionDataTask *)operateGoogleAuth:(BOOL )isOpen
                                       key1:(NSString *)key1
                                       key2:(NSString *)key2
                                    emsCode:(NSString *)emsCode
                                 googleCode:(NSString *)googleCode
                                    success:(void (^)(id data))success
                                    failure:(void (^)(NSError * error))failure;
///验证谷歌验证
+ (NSURLSessionDataTask *)verifyGoogleAuth:(NSString *)code
                                       key:(NSString *)gSecretkey
                                   success:(void (^)(id data))success
                                   failure:(void (^)(NSError * error))failure;
///获取谷歌验证信息
+ (NSURLSessionDataTask *)getGoogleAuthInfo:(void (^)(id data))success
                                    failure:(void (^)(NSError * error))failure;
/**消息中心***/
+ (NSURLSessionDataTask *) getMessageList:(void (^)(id data)) success
                                  failure:(void (^)(NSError *error)) failure;
+ (NSURLSessionDataTask *) getMessage:(NSInteger)pageindex
                             pagesize:(NSInteger)pagesize
                                 type:(NSString *)type
                              success:(void (^)(id data)) success
                              failure:(void (^)(NSError *error)) failure;
//新手训练营
+ (NSURLSessionDataTask *)postInvestmentCamp:(NSString *)category
                                     success:(void (^)(id data))success
                                     failure:(void (^)(NSError * error))failure;
//MARK: - 出入金
//订单筛选条件
+ (NSURLSessionDataTask *)getOrderfilter:(void (^)(id))success failure:(void (^)(NSError *))failure;
//入金显示数据
+ (NSURLSessionDataTask *)getpaymentmethod:(void (^)(id))success failure:(void (^)(NSError *))failure;
//出金显示数据
+ (NSURLSessionDataTask *)getDrawlData:(void (^)(id))success failure:(void (^)(NSError *))failure;
//出入金显示用户数据
+ (NSURLSessionDataTask *)getAvailData:(NSString *)type isOTC:(BOOL)isOTC priceArrow:(BOOL)isBuy success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//获取usdt汇率
+ (NSURLSessionDataTask *)getpaymentRate:(NSString *)payid priceCoin:(NSString *)priceCoin priceArrow:(NSString *)type success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//获取入金订单
+ (NSURLSessionDataTask *)getpayHisOrder:(NSString *)payId page:(NSInteger)page success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//获取连上入金
+ (NSURLSessionDataTask *)chainusdtPay:(NSString *)payId currencyType:(NSString *)currencyType success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//获取正在交易订单（出入金）
+ (NSURLSessionDataTask *)getpayOrder:(BOOL)isOtc success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//取消正在交易订单（出入金）
+ (NSURLSessionDataTask *)getpayCancelOrder:(NSString *)orderId logId:(NSString *)logId success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//确认付款正在交易订单（出入金）
+ (NSURLSessionDataTask *)getpayConfirmOrder:(NSString *)orderId logId:(NSString *)logId success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//Otc记录list
+ (NSURLSessionDataTask *)getOtcOrderlist:(BOOL)isDeposit params:(NSString *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//chain记录list
+ (NSURLSessionDataTask *)getChainOrderlist:(BOOL)isDeposit params:(NSString *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//chain订单详情
+ (NSURLSessionDataTask *)getChainOrderDetail:(NSString *)logid txtId:(NSString *)txtId currenttype:(NSString *)currenttype isDeposit:(BOOL)isBuy success:(void (^)(id))success failure:(void (^)(NSError *))failure;
//otc订单详情
+ (NSURLSessionDataTask *)getOtcOrderDetail:(NSString *)logid txtId:(NSString *)txtId isDeposit:(BOOL)isBuy success:(void (^)(id))success failure:(void (^)(NSError *))failure;

// 提交OTC出金接口
+ (NSURLSessionDataTask *)commitOTCDrawl:(NSString *)amount exchangetrade:(NSString *)exchangetrade amountrmb:(NSString *)amountrmb currenttype:(NSString *)currenttype success:(void (^)(id))success failure:(void (^)(NSError *))failure;
// 提交链上出金接口
+ (NSURLSessionDataTask *)commitChainDrawl:(NSString *)amount address:(NSString *)address currenttype:(NSString *)currenttype success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//资金流水
+ (NSURLSessionDataTask *)postquerymoneyflowoptype:(NSInteger)optype page:(NSInteger)page pagesize:(NSInteger)pagesize success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**获取用户链上地址列表*/
+ (NSURLSessionDataTask *)addresslist:(NSString *)currenttype success:(void (^)(id))success failure:(void (^)(NSError *))failure;

/**用户链上地址修改,增加，删除*/
+ (NSURLSessionDataTask *)addressManage:(NSString *)action currenttype:(NSString *)currenttype params:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//MARK: - Others

//获取domain列表
+ (NSURLSessionDataTask *)getDomain:(void (^)(id))success failure:(void (^)(NSError *))failure;
//检测domain列表
+ (NSURLSessionDataTask *)checkDomain:(void (^)(id))success failure:(void (^)(NSError *))failure;

//得到IP地址
+ (NSURLSessionDataTask *)getIPInfo:(NSString *)url
                            success:(void (^)(id))success
                            failure:(void (^)(NSError *))failure;

//更新版本消息
+ (NSURLSessionDataTask *)updateVersion:(void (^)(id))success failure:(void (^)(NSError *))failure;
//更新token
+ (NSURLSessionDataTask *)updateUserToken:(void (^)(id))success failure:(void (^)(NSError *))failure;
//获取客服方式
+(NSURLSessionDataTask*)getCustomerService:(void (^)(id))success
                                   failure:(void (^)(NSError *))failure;
//获取投诉客服方式
+(NSURLSessionDataTask*)getSuggestService:(void (^)(id))success
                                  failure:(void (^)(NSError *))failure;
//设备收集接口
+ (NSURLSessionDataTask *)deviceSynctype:(NSNumber *)operatetype
                                 success:(void (^)(id))success
                                 failure:(void (^)(NSError *))failure;

//是否有未读消息
+ (NSURLSessionDataTask *)hasUnReadNotice:(void (^)(id))success failure:(void (^)(NSError *))failure;
+ (NSURLSessionDataTask *)setReadNotice:(void (^)(id))success failure:(void (^)(NSError *))failure;

//事件统计
+ (NSURLSessionDataTask *)eventCollect:(NSString *)event success:(void (^)(id))success failure:(void (^)(NSError *))failure;

//获取websocket的url
+ (NSURLSessionDataTask *)wssAddressUrl:(void (^)(id))success failure:(void (^)(NSError *))failure;

// HTTP参数头
+ (NSString *)paramsWithHead:(HttpHeadType)type;


@end

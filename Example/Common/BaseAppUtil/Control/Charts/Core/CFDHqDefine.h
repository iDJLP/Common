//
//  HqDefine.h
//  niuguwang
//
//  Created by zhangchangqing on 16/11/3.
//  Copyright © 2016年 taojinzhe. All rights reserved.
//

#ifndef CFDHqDefine_h
#define CFDHqDefine_h



typedef NS_ENUM(NSInteger, EChartsType)
{
    EChartsType_UNKOWN = 0,
    EChartsType_RT = 1,               //分时
    EChartsType_RT_FIVEDAY = 2,       //五日分时
    EChartsType_KL = 5,               //日K线
    EChartsType_KL_WEEK = 6,          //周K线
    EChartsType_KL_MONTH = 9,         //月K线
    EChartsType_KL_1 = 100,             //1分钟K线
    EChartsType_KL_3 = 101,             //3分钟K线
    EChartsType_KL_5 = 102,             //5分钟K线
    EChartsType_KL_15 = 103,            //15分钟K线
    EChartsType_KL_30 = 104,            //30分钟K线
    EChartsType_KL_60 = 105,            //60分钟K线
    EChartsType_KL_120 ,            //120分钟K线
    EChartsType_KL_240 ,            //240分钟K线
    EChartsType_KL_6H ,            //120分钟K线
    EChartsType_KL_8H ,            //8h分钟K线
    EChartsType_KL_12H ,            //12h K线
};

// 分时数据Key
static NSString *const MLineData_RT = @"EChartsType_RT";
static NSString *const MLineData_Five = @"EChartsType_RT_FIVEDAY";
// K线数据Key
static NSString *const KLineData_Day = @"EChartsType_KL";
static NSString *const KLineData_Week = @"EChartsType_KL_WEEK";
static NSString *const KLineData_Month = @"EChartsType_KL_MONTH";
static NSString *const KLineData_1 = @"EChartsType_KL_1";
static NSString *const KLineData_3 = @"EChartsType_KL_3";
static NSString *const KLineData_5 = @"EChartsType_KL_5";
static NSString *const KLineData_15 = @"EChartsType_KL_15";
static NSString *const KLineData_30 = @"EChartsType_KL_30";
static NSString *const KLineData_60 = @"EChartsType_KL_60";
static NSString *const KLineData_120 = @"EChartsType_KL_120";
static NSString *const KLineData_240 = @"EChartsType_KL_240";
static NSString *const KLineData_6H = @"EChartsType_KL_6H";
static NSString *const KLineData_8H = @"EChartsType_KL_8H";
static NSString *const KLineData_12H = @"EChartsType_KL_12H";

//行情历史数据有增加
static NSString *const KLineMoreDataHasAdded = @"KLineMoreDataHasAdded";

//用于绘图的价格
typedef NS_ENUM(NSInteger , EChartsLineType)
{
    EChartsLineTypeTradePrice=1,   //成交价
    EChartsLineTypeBidPrice=2,     //买价
    EChartsLineTypeOfferPrice=3,   //卖价
    EChartsLineTypeMiddlePrice=4,  //均价
};

typedef NS_ENUM(NSInteger , EIndexTopType)
{
    EIndexTopTypeNone = 0,//
    EIndexTopTypeMa ,
    EIndexTopTypeBool,
    EIndexTopTypeEnd ,
};

typedef NS_ENUM(NSInteger , EIndexType)
{
    EIndexTypeNone = 10,//
    EIndexTypeMacd = 11,
    EIndexTypeKdj = 12,
    EIndexTypeRsi = 13,
    EIndexTypeWR = 14,
    EIndexTypeBIAS = 15,
    EIndexTypeCCI = 16,
};

typedef NS_ENUM(NSInteger , NSOpenStatusQuotes)
{
    NSOpenStatusQuotesNonTime = 0, //非行情开盘时间
    NSOpenStatusQuotesTime = 1//行情开盘时间
};

typedef NS_ENUM(NSInteger , NSOpenStatusTrade)
{
    NSOpenStatusTradeNonTime = 0, //非交易开盘时间
    NSOpenStatusTradeTime = 1, //交易开盘时间
    NSOpenStatusTradeNot = 2,//不支持交易
};

#define EIndexBtnTag 840 //指标按钮的tag
#define EPankouBuySingleTag 900 //买盘单个的tag
#define EPankouSellSingleTag 950 //卖盘单个的tag



#define MLineCountDefault 90 //分时线默认点数
#define MLineCountMin 60 //分时线最小点数
#define MLineBounceCountDefault 20  //分时线回跳数
#define KLineCountDefault 40  //k线默认蜡烛数
#define KLineCountMin 20  //k线最少蜡烛数
#define KLineCountMax 90  //k线最大蜡烛数

#define CHeight (CRegularHeight+CChartHeight+CButtonListHight+CButtonListToMainChartsHight)

#define CChartHeight (CMainChartHight+CIndexChartHight)
//固定的间距高度（不随横屏时变化）
#define CRegularHeight (CMainChartsToIndexChartsHight+CTimeAixsHight)
#define CButtonListHight [GUIUtil fit:32] //顶部按钮的高度
#define CButtonListToMainChartsHight (ceil_half([GUIUtil fit:8])) //按钮据主图的高度
#define CMainChartHight [GUIUtil fit:230] //主图的高度
#define CMainChartsToIndexChartsHight [GUIUtil fit:5] //主图距副图index的高度
#define CIndexChartHight [GUIUtil fit:70] //副图index的高度
#define CVolIndexToIndexChartsHight [GUIUtil fit:0] //vol距副图index的高度
#define CTimeAixsHight [GUIUtil fit:15] //时间横轴的高度

#define CLineRight  [ChartsUtil fit:50]

#import "CFDChartsData.h"
#import "ChartsUtil.h"

#endif /* HqDefine_h */

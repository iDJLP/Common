//
//  NSDate+Additions.h
//  Lapsule
//
//  Created by wei on 14-7-11.
//  Copyright (c) 2014年 ruihexin. All rights reserved.
//

#import <Foundation/Foundation.h>

#define D_MINUTE	60
#define D_HOUR		3600
#define D_DAY		86400
#define D_WEEK		604800
#define D_MONTH		2592000
#define D_YEAR		31556926

@interface NSDate (Lapsule)

- (NSString *) stringWithFormat:(NSString *)format;
+ (NSDate *) dateFromString:(NSString *)string
                 withFormat:(NSString *)format;
+ (NSDate *)dateFromUtcStr:(NSString *)string
                withFormat:(NSString *)format;

- (NSString *)defaultStringDescription;
- (NSString *)ymdStringDescription;
- (NSString *)ymStringDescription;
- (NSTimeInterval) timeDifferenceBetween: (NSDate *)date;


- (NSString *)getUTCFormateLocalDate:(NSString *)localDate;
- (NSString *)utcStringWithFormat:(NSString *)format;


// Relative dates from the current date
+ (NSDate *) dateTomorrow;
+ (NSDate *) dateYesterday;
+ (NSDate *) dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes;
+ (NSDate *) dateWithSecondsFromNow: (NSInteger) dSeconds;
+ (NSDate *) dateWithSecondsBeforeNow: (NSInteger) dSeconds;

// Comparing dates
- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate;
- (BOOL) isToday;
- (BOOL) isTomorrow;
- (BOOL) isYesterday;
- (BOOL) isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) isThisWeek;
- (BOOL) isNextWeek;
- (BOOL) isLastWeek;
- (BOOL) isThisYear;
- (BOOL) isEarlierThanDate: (NSDate *) aDate;
- (BOOL) isLaterThanDate: (NSDate *) aDate;
- (BOOL) isBeforeDays:(NSInteger)days; //判断当前时间是否是几天之前

// Adjusting dates
- (NSDate *) dateBySubtractingYears: (NSInteger) dYears;
- (NSDate *) dataByAddingMonths: (NSInteger) dMonths;
- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths;
- (NSDate *) dateByAddingDays: (NSInteger) dDays;
- (NSDate *) dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) dateByAddingHours: (NSInteger) dHours;
- (NSDate *) dateBySubtractingHours: (NSInteger) dHours;
- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes;
- (NSDate *) dateAtStartOfDay;

// Retrieving intervals
- (NSInteger) minutesAfterDate: (NSDate *) aDate;
- (NSInteger) minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) hoursAfterDate: (NSDate *) aDate;
- (NSInteger) hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) daysAfterDate: (NSDate *) aDate;
- (NSInteger) daysBeforeDate: (NSDate *) aDate;


// Decomposing dates
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;

- (NSInteger)secondsWithTime;
- (NSString *)timeSp;
+ (NSString *)currentTimeStamp;


/**
 *  是否为今天
 */
- (BOOL)IsToday;
/**
 *  是否为昨天
 */
- (BOOL)IsYesterday;
/**
 *  是否为今年
 */
- (BOOL)IsThisYear;


/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;

//MARK: - Private
+ (NSTimeInterval)openPostionTimestamp:(NSString *)date;
+ (NSString *)openPostionDate:(NSString *)date;
+ (NSString *)postionRecordDate:(NSString *)date;
+ (NSString *)validDate:(NSString *)date isBegin:(BOOL)isBegin;
+ (NSString *)postionRecordCurrentDate;
+ (NSString *)postionRecordPreMnthDate:(NSString *)dateStr;
+ (NSString *)klineDateByTimestemp:(NSTimeInterval)timeInterval;
+ (NSString *)mlineDateByTimestemp:(NSTimeInterval)timeInterval;
+ (NSString *)tradeDateByTimestemp:(NSTimeInterval)timeInterval;
+ (NSDate *)dateByklineTimes:(NSString *)lineTime;

@end

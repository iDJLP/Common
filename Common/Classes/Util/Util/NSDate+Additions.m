//
//  NSDate+Additions.m
//  Lapsule
//
//  Created by wei on 14-7-11.
//  Copyright (c) 2014年 ruihexin. All rights reserved.
//

#import "NSDate+Additions.h"

#define DATE_COMPONENTS (kCFCalendarUnitYear| kCFCalendarUnitMonth | kCFCalendarUnitDay | NSCalendarUnitWeekOfYear |  kCFCalendarUnitHour | kCFCalendarUnitMinute | kCFCalendarUnitSecond | kCFCalendarUnitWeekday | kCFCalendarUnitWeekdayOrdinal)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@interface DateFormatter : NSObject

+ (instancetype)sharedDateFormatter;

@property (nonatomic, strong) NSMutableDictionary * dict;

@end


@implementation DateFormatter

+ (instancetype)sharedDateFormatter {
    static DateFormatter *sharedInstance = nil;
    static dispatch_once_t pred;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[DateFormatter alloc] init];
    });
    
    return sharedInstance;
}


- (id)init {
	if (self = [super init]) {
		
        self.dict = [[NSMutableDictionary alloc] initWithCapacity:1];
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [self.dict setObject:dateFormatter forKey:@"nil"];
        
	}
	return self;
}


- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format{
    
    NSDateFormatter * dateFormatter;
    if (format) {
        dateFormatter = [self.dict objectForKey:format];
        if (!dateFormatter) {
            dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:format];
            [self.dict setObject:dateFormatter forKey:format];
        }
    } else {
        dateFormatter = [self.dict objectForKey:@"nil"];
    }
    
    return dateFormatter;
}


@end

@implementation NSDate (Lapsule)

- (NSString *)stringWithFormat:(NSString *)format{
    
	NSString *destDateString = [[[DateFormatter sharedDateFormatter] dateFormatterWithFormat:format] stringFromDate:self];
    
    return destDateString;
}

+ (NSDate *)dateFromString:(NSString *)string
                withFormat:(NSString*) format{
    
	NSDate * destDate = [[[DateFormatter sharedDateFormatter] dateFormatterWithFormat:format] dateFromString:string];
    
    return destDate;
}

+ (NSDate *)dateFromUtcStr:(NSString *)string
                withFormat:(NSString *)format {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone * timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    if (format) {
        [dateFormatter setDateFormat:format];
    } else {
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    NSDate * destDate = [dateFormatter dateFromString:string];
    
    return destDate;
}

- (NSString *)defaultStringDescription
{
    NSDateFormatter * dateFormatter = [DateFormatter sharedDateFormatter].dict[@"defaultStringDescription"];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        [[DateFormatter sharedDateFormatter].dict setObject:dateFormatter forKey:@"defaultStringDescription"];
    }
    NSString * dateString = [dateFormatter stringFromDate:self];
    return dateString;
}
- (NSString *)ymdStringDescription
{
    return [self stringWithFormat:@"yyyy年MM月dd日"];
}
- (NSString *)ymStringDescription
{
    return [self stringWithFormat:@"yyyy年MM月"];
}
- (NSTimeInterval) timeDifferenceBetween: (NSDate *)date
{
    return fabs([date timeIntervalSince1970] - [self timeIntervalSince1970]);
}

- (NSString *)getUTCFormateLocalDate:(NSString *)localDate {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    //输入格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate * dateFormatted = [dateFormatter dateFromString:localDate];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
    NSString * dateString = [dateFormatter stringFromDate:dateFormatted];
    return dateString;
}

- (NSString *)utcStringWithFormat:(NSString *)format {
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    //输出格式
    [dateFormatter setDateFormat:format];
    NSString * dateString = [dateFormatter stringFromDate:self];
    return dateString;
}


+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithDaysBeforeNow: (NSInteger) days
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_DAY * days;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateTomorrow
{
	return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateYesterday
{
	return [NSDate dateWithDaysBeforeNow:1];
}

+ (NSDate *) dateWithHoursFromNow: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithHoursBeforeNow: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithMinutesFromNow: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithMinutesBeforeNow: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithSecondsFromNow: (NSInteger) dSeconds {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + dSeconds;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSDate *) dateWithSecondsBeforeNow: (NSInteger) dSeconds {
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - dSeconds;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

+ (NSString *)postionRecordCurrentDate{
    NSDateFormatter * dateFormatter = [DateFormatter sharedDateFormatter].dict[@"postionRecordCurrentDate"];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        [[DateFormatter sharedDateFormatter].dict setObject:dateFormatter forKey:@"postionRecordCurrentDate"];
    }
    NSDate *date = [NSDate date];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)postionRecordPreMnthDate:(NSString *)dateStr{
    NSDateFormatter * dateFormatter = [DateFormatter sharedDateFormatter].dict[@"postionRecordCurrentDate"];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM"];
        [[DateFormatter sharedDateFormatter].dict setObject:dateFormatter forKey:@"postionRecordCurrentDate"];
    }
    NSDate *date = [dateFormatter dateFromString:dateStr];
    date = [date dateBySubtractingMonths:1];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)openPostionDate:(NSString *)date{
    NSDateFormatter * dateFormatter = [DateFormatter sharedDateFormatter].dict[@"openPostionOriginDate"];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [[DateFormatter sharedDateFormatter].dict setObject:dateFormatter forKey:@"openPostionOriginDate"];
    }
    NSDateFormatter * dateFormatter1 = [DateFormatter sharedDateFormatter].dict[@"openPostionDate"];
    if (dateFormatter1 == nil) {
        dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"MM-dd HH:mm:ss"];
        [[DateFormatter sharedDateFormatter].dict setObject:dateFormatter1 forKey:@"openPostionDate"];
    }
    NSDate *date1 = [dateFormatter dateFromString:date];
    return [dateFormatter1 stringFromDate:date1];
}

+ (NSString *)postionRecordDate:(NSString *)date{
    NSDateFormatter * dateFormatter = [DateFormatter sharedDateFormatter].dict[@"openPostionOriginDate"];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [[DateFormatter sharedDateFormatter].dict setObject:dateFormatter forKey:@"openPostionOriginDate"];
    }
    NSDateFormatter * dateFormatter1 = [DateFormatter sharedDateFormatter].dict[@"postionRecordDate"];
    if (dateFormatter1 == nil) {
        dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"MM-dd HH:mm"];
        [[DateFormatter sharedDateFormatter].dict setObject:dateFormatter1 forKey:@"postionRecordDate"];
    }
    NSDate *date1 = [dateFormatter dateFromString:date];
    return [dateFormatter1 stringFromDate:date1];
}

+ (NSString *)validDate:(NSString *)date isBegin:(BOOL)isBegin{
    NSDateFormatter * dateFormatter = [DateFormatter sharedDateFormatter].dict[@"openPostionOriginDate"];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [[DateFormatter sharedDateFormatter].dict setObject:dateFormatter forKey:@"openPostionOriginDate"];
    }
    NSDateFormatter * dateFormatter1 = [DateFormatter sharedDateFormatter].dict[@"validDate"];
    if (dateFormatter1 == nil) {
        dateFormatter1 = [[NSDateFormatter alloc] init];
        [dateFormatter1 setDateFormat:@"yyyy-MM-dd"];
        [[DateFormatter sharedDateFormatter].dict setObject:dateFormatter1 forKey:@"validDate"];
    }
    
    NSDate *date1 = [dateFormatter dateFromString:date];
    if ([date hasSuffix:@"00:00:00"]&&isBegin==NO) {
        date1 = [date1 dateBySubtractingHours:1];
    }
    NSString *date2 = [dateFormatter1 stringFromDate:date1];
    return date2;
}

+ (NSTimeInterval)openPostionTimestamp:(NSString *)date{
    NSDateFormatter * dateFormatter = [DateFormatter sharedDateFormatter].dict[@"openPostionOriginDate"];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        [[DateFormatter sharedDateFormatter].dict setObject:dateFormatter forKey:@"openPostionOriginDate"];
    }
    NSDate *date1 = [dateFormatter dateFromString:date];
    return [date1 timeIntervalSinceReferenceDate];
}

+ (NSDate *)dateByklineTimes:(NSString *)lineTime{
    NSDateFormatter * dateFormatter = [DateFormatter sharedDateFormatter].dict[@"klineDate"];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        [[DateFormatter sharedDateFormatter].dict setObject:dateFormatter forKey:@"klineDate"];
    }
    return [dateFormatter dateFromString:lineTime];
}

+ (NSString *)klineDateByTimestemp:(NSTimeInterval)timeInterval{
    NSDateFormatter * dateFormatter = [DateFormatter sharedDateFormatter].dict[@"klineDate"];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        [[DateFormatter sharedDateFormatter].dict setObject:dateFormatter forKey:@"klineDate"];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)mlineDateByTimestemp:(NSTimeInterval)timeInterval{
    NSDateFormatter * dateFormatter = [DateFormatter sharedDateFormatter].dict[@"mlineDate"];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm"];
        [[DateFormatter sharedDateFormatter].dict setObject:dateFormatter forKey:@"mlineDate"];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)tradeDateByTimestemp:(NSTimeInterval)timeInterval{
    NSDateFormatter * dateFormatter = [DateFormatter sharedDateFormatter].dict[@"tradeDate"];
    if (dateFormatter == nil) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        [[DateFormatter sharedDateFormatter].dict setObject:dateFormatter forKey:@"tradeDate"];
    }
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    return [dateFormatter stringFromDate:date];
}

#pragma mark Comparing Dates

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	return ((components1.year == components2.year) &&
			(components1.month == components2.month) &&
			(components1.day == components2.day));
}

- (BOOL) isToday
{
	return [self isEqualToDateIgnoringTime:[NSDate date]];
}

- (BOOL) isTomorrow
{
	return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

- (BOOL) isYesterday
{
	return [self isEqualToDateIgnoringTime:[NSDate dateYesterday]];
}

// This hard codes the assumption that a week is 7 days
- (BOOL) isSameWeekAsDate: (NSDate *) aDate
{
	NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
	
	// Must be same week. 12/31 and 1/1 will both be week "1" if they are in the same week
	if (components1.weekOfMonth != components2.weekOfMonth) return NO;
	
	// Must have a time interval under 1 week. Thanks @aclark
	return (fabs([self timeIntervalSinceDate:aDate]) < D_WEEK);
}

- (BOOL) isThisWeek
{
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isNextWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

- (BOOL) isLastWeek
{
	NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] - D_WEEK;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return [self isSameWeekAsDate:newDate];
}

- (BOOL) isThisYear
{
	return [self isSameWeekAsDate:[NSDate date]];
}

- (BOOL) isEarlierThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedAscending);
}

- (BOOL) isLaterThanDate: (NSDate *) aDate
{
	return ([self compare:aDate] == NSOrderedDescending);
}

- (BOOL) isBeforeDays:(NSInteger)days {
    
    return [self isEarlierThanDate:[NSDate dateWithDaysBeforeNow:days]];
}

#pragma mark Adjusting Dates

- (NSDate *) dateBySubtractingYears: (NSInteger) dYears {
    return [self dateBySubtractingMonths:dYears * 12];
}

- (NSDate *) dataByAddingMonths: (NSInteger) dMonths {
    
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];

    [components setMonth:([components month] + 1)];
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *) dateBySubtractingMonths: (NSInteger) dMonths {
    
    NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    
    [components setMonth:([components month] - dMonths)];
    return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDate *) dateByAddingDays: (NSInteger) dDays
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_DAY * dDays;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

- (NSDate *) dateBySubtractingDays: (NSInteger) dDays
{
	return [self dateByAddingDays: (dDays * -1)];
}

- (NSDate *) dateByAddingHours: (NSInteger) dHours
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_HOUR * dHours;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

- (NSDate *) dateBySubtractingHours: (NSInteger) dHours
{
	return [self dateByAddingHours: (dHours * -1)];
}

- (NSDate *) dateByAddingMinutes: (NSInteger) dMinutes
{
	NSTimeInterval aTimeInterval = [self timeIntervalSinceReferenceDate] + D_MINUTE * dMinutes;
	NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
	return newDate;
}

- (NSDate *) dateBySubtractingMinutes: (NSInteger) dMinutes
{
	return [self dateByAddingMinutes: (dMinutes * -1)];
}

- (NSDate *) dateAtStartOfDay
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	components.hour = 0;
	components.minute = 0;
	components.second = 0;
	return [CURRENT_CALENDAR dateFromComponents:components];
}

- (NSDateComponents *) componentsWithOffsetFromDate: (NSDate *) aDate
{
	NSDateComponents *dTime = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate toDate:self options:0];
	return dTime;
}

#pragma mark Retrieving Intervals

- (NSInteger) minutesAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) minutesBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_MINUTE);
}

- (NSInteger) hoursAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) hoursBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_HOUR);
}

- (NSInteger) daysAfterDate: (NSDate *) aDate
{
	NSTimeInterval ti = [self timeIntervalSinceDate:aDate];
	return (NSInteger) (ti / D_DAY);
}

- (NSInteger) daysBeforeDate: (NSDate *) aDate
{
	NSTimeInterval ti = [aDate timeIntervalSinceDate:self];
	return (NSInteger) (ti / D_DAY);
}

#pragma mark Decomposing Dates

- (NSInteger) hour
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.hour;
}

- (NSInteger) minute
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.minute;
}

- (NSInteger) seconds
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.second;
}

- (NSInteger) day
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.day;
}

- (NSInteger) month
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.month;
}

- (NSInteger) week
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekOfYear;
}

- (NSInteger) weekday
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekday;
}

- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.weekdayOrdinal;
}
- (NSInteger) year
{
	NSDateComponents *components = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
	return components.year;
}

- (NSInteger)secondsWithTime {
    
    NSInteger seconds = 0;
    NSString * str = [self stringWithFormat:@"HHmmss"];
    NSInteger hour = [[str substringWithRange:NSMakeRange(0, 2)] integerValue];
    NSInteger mineute = [[str substringWithRange:NSMakeRange(2, 2)] integerValue];
    NSInteger second = [[str substringWithRange:NSMakeRange(4, 2)] integerValue];
    
    seconds = hour * 60 * 60 + mineute * 60 + second;
    return seconds;
}


- (NSString *)timeSp {
    
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[self timeIntervalSince1970]];

    return timeSp;
}

+ (NSString *)currentTimeStamp {
    
    return [[NSDate date] timeSp];
}


/**
 *  是否为今天
 */
- (BOOL)IsToday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    return
    (selfCmps.year == nowCmps.year) &&
    (selfCmps.month == nowCmps.month) &&
    (selfCmps.day == nowCmps.day);
}

/**
 *  是否为昨天
 */
- (BOOL)IsYesterday
{
    // 2014-05-01
    NSDate *nowDate = [[NSDate date] dateWithYMD];
    
    // 2014-04-30
    NSDate *selfDate = [self dateWithYMD];
    
    // 获得nowDate和selfDate的差距
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *cmps = [calendar components:NSCalendarUnitDay fromDate:selfDate toDate:nowDate options:0];
    return cmps.day == 1;
}

/**
 *  是否为今年
 */
- (BOOL)IsThisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitYear;
    
    // 1.获得当前时间的年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    
    // 2.获得self的年月日
    NSDateComponents *selfCmps = [calendar components:unit fromDate:self];
    
    return nowCmps.year == selfCmps.year;
}

- (NSDate *)dateWithYMD
{
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = @"yyyy-MM-dd";
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}


- (NSDateComponents *)deltaWithNow
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    return [calendar components:unit fromDate:self toDate:[NSDate date] options:0];
}


@end

//
//  DCHDateHelper.h
//  DCHCalendarDemo
//
//  Created by dch on 2017/8/24.
//  Copyright © 2017年 dch. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum : NSUInteger {
    DateType_year=0,
    DateType_month,
    DateType_day,
    DateType_hour,
    DateType_minute,
    DateType_second,
} DateType;

@interface DCHDateHelper : NSObject

/**
 获取某个日期的前后日期
 
 @param currentDate 当前时间
 @param lead 距离时间 正数往后推  负数往前推
 @param timeType 时间类型(0-年  1-月 2-日 3-时 4-分 5-秒)
 @return 返回结果时间
 */
+ (NSDate *)getEarlyOrLaterDate:(NSDate *)currentDate LeadTime:(NSInteger)lead Type:(DateType)timeType;

/**
 获取当天是周几
 
 @param curDate 当天日期
 @return 周数(1-7  ->  日-六)
 */
+ (NSInteger)getNumberInWeek:(NSDate *)curDate;

/**
 获取当前日期所在周最后一天(日-六 也就是周六)
 
 @param curDate 当前日期
 @return 返回日期
 */
+ (NSDate *)getLastdayOfTheWeek:(NSDate *)curDate;


/**
 返回传入时间月份第一天
 
 @param curDate 传入日期
 @return 第一天
 */
+ (NSDate *)GetFirstDayOfMonth:(NSDate *)curDate;


/**
 * 获取上个月的时间
 */
+ (NSDate*)getPreviousMonth:(NSDate*)curDate;

/**
 * 获取下一个月的时间
 */
+ (NSDate*)getNextMonth:(NSDate*)curDate;
//获取一个月有多少行
+ (NSInteger)getRows:(NSDate *)myDate;

//判断两个月是否是同一月
+ (BOOL)checkSameMonth:(NSDate*)_month1 AnotherMonth:(NSDate*)_month2;
/**
 * 判断两天是不是同一天
 */
+ (BOOL)isSameDate:(NSDate *)date1 AnotherDate:(NSDate *)date2;


//返回传入格式的日期字符
+ (NSString *)getStrFromDateFormat:(NSString *)format Date:(NSDate *)date;

@end

//
//  DCHDateHelper.m
//  DCHCalendarDemo
//
//  Created by dch on 2017/8/24.
//  Copyright © 2017年 dch. All rights reserved.
//

#import "DCHDateHelper.h"

@implementation DCHDateHelper

+ (NSDate *)getEarlyOrLaterDate:(NSDate *)currentDate LeadTime:(NSInteger)lead Type:(DateType)timeType
{
    NSCalendar *calendar = [NSCalendar calendarWithIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComp = [[NSDateComponents alloc] init];
    switch (timeType) {
        case DateType_year:
            [dateComp setYear:lead];
            break;
        case DateType_month:
            [dateComp setMonth:lead];
            break;
        case DateType_day:
            [dateComp setDay:lead];
            break;
        case DateType_hour:
            [dateComp setHour:lead];
            break;
        case DateType_minute:
            [dateComp setMinute:lead];
            break;
        case DateType_second:
            [dateComp setSecond:lead];
            break;
        default:
            break;
    }
    return [calendar dateByAddingComponents:dateComp toDate:currentDate options:0];
}

//获取当天是周几
+ (NSInteger)getNumberInWeek:(NSDate *)curDate
{
    NSUInteger num =[[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:curDate];
    return num;
}

//获取传入时间当前周最后一天(日 -> 六,也就是周六日期)
+ (NSDate *)getLastdayOfTheWeek:(NSDate *)curDate
{
    NSInteger week = [self getNumberInWeek:curDate];
    return [self getEarlyOrLaterDate:curDate LeadTime:7 - week Type:2];
}

//获取当前时间月份的第一天的时间
+ (NSDate *)GetFirstDayOfMonth:(NSDate *)curDate
{
    NSCalendar *myCalendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [myCalendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:curDate];
    NSDate* date = [myCalendar dateFromComponents:components];
    return date;
}

//获取当前月份的上个月的时间
+ (NSDate *)getPreviousMonth:(NSDate *)curDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:curDate];
    
    NSInteger year = comps.year;
    NSInteger month = comps.month;
    NSInteger day = comps.day;
    
    
    NSDate *date = nil;
    if (day <= 28 || month==1) {
        comps.month = month - 1;
        date = [calendar dateFromComponents:comps];
    }else{
        NSString *dateStr = [NSString stringWithFormat:@"%ld-%ld-3",year,month-1];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *theMonth = [formatter dateFromString:dateStr];
        NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:theMonth];
        
        NSInteger daysInMonth = range.length;
        
        NSString* datestring = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)year, month-1, MIN(day, daysInMonth)];
        date = [formatter dateFromString:datestring];
    }
    return date;
}

//获取下一个月的时间
+ (NSDate*)getNextMonth:(NSDate*)_date {
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *comps = [cal components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:_date];
    
    NSInteger year  = comps.year;
    NSInteger month = comps.month;
    NSInteger day   = comps.day;
    
    // NSLog(@"%d === %d === %d",year,month,day);
    
    NSDate* rt = nil;
    
    if (day <= 28 || month == 12) {
        
        comps.month = month+1;
        rt = [cal dateFromComponents:comps];
        
    } else {
        
        NSString* ss = [NSString stringWithFormat:@"%ld-%ld-3", (long)year, month+1];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        NSDate* the_month = [formatter dateFromString:ss];
        NSRange rng = [cal rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:the_month];
        NSInteger day_in_month = rng.length;
        
        NSString* datestring = [NSString stringWithFormat:@"%ld-%ld-%ld", (long)year, month+1, MIN(day, day_in_month)];
        rt = [formatter dateFromString:datestring];
        
        //NSLog(@" ss = %@  the_month = %@ day_in_month = %ld datestring = %@ rt = %@",ss,the_month,(long)day_in_month,datestring,rt);
    }
    
    return rt;
}


//获取一个月有多少行
+ (NSInteger)getRows:(NSDate *)myDate {
    NSDate *firstday;
    [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitMonth startDate:&firstday interval:NULL forDate:myDate];
    NSUInteger zhouji =[[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:firstday];
    NSRange daysOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:myDate];
    //该月的行数
    NSInteger shenyu = daysOfMonth.length - (8 - zhouji);
    NSInteger hangshu;
    hangshu = shenyu % 7 > 0 ? shenyu/7 + 2 : shenyu/7 + 1;
    return hangshu;
}

//判断两个月份是不是一样的
+ (BOOL)checkSameMonth:(NSDate*)_month1 AnotherMonth:(NSDate*)_month2 {
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents* m1 = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:_month1];
    NSDateComponents* m2 = [cal components:NSCalendarUnitYear|NSCalendarUnitMonth fromDate:_month2];
    BOOL rt = NO;
    if ((m1.year == m2.year) && (m1.month == m2.month))
    {
        rt = YES;
    }
    return rt;
}

/**
 * 判断两天是不是同一天
 */
+ (BOOL)isSameDate:(NSDate *)date1 AnotherDate:(NSDate *)date2 {
    
    NSCalendar* calendar = [NSCalendar currentCalendar];
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:date1];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:date2];
    
    return [comp1 day]   == [comp2 day] &&
    [comp1 month] == [comp2 month] &&
    [comp1 year]  == [comp2 year];
    
}

//返回传入格式的日期字符
+ (NSString *)getStrFromDateFormat:(NSString *)format Date:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:date];
    
}

@end

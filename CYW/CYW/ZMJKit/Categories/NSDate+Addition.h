//
//  NSDate+Addition.h
//  GeneralFramework
//
//  Created by ZMJ on 15/5/14.
//  Copyright (c) 2015年 ZMJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Addition)
- (NSString *)timeScrp;

/**
 *  根据时间戳算当前时间
 *
 *  @param dataString 传入的时间戳
 *
 *  @return 返回当前时间
 */
+ (NSString *)returnCurrentDayString:(NSString *)dataString;


/**
 *  算当前日期然后翻转
 *
 *  @param timestr 传入的时间戳
 *
 *  @return 当前时间
 */
+(NSString *)currentData:(NSString *)timestr;
/**
 *  判断当前是多久
 *
 *  @param reference 传入的时间戳
 *
 *  @return 返回我确定后的时间
 */
+ (NSString *)prettyDateWithReference:(NSString *)reference;

+ (NSString *)timestampDateWithRefresh:(NSString *)timedetail withFormat:(BOOL)format;

+ (NSString *)distanceTimeWithBeforeTime:(double)beTime;

+(NSString *)TimeStamp:(NSString *)strTime;
+(NSString *)TimeStamps:(NSString *)strTimes;


- (BOOL)isSameWeek;
- (NSString *)weekdayStringFromDate;
- (BOOL)isToday;
- (BOOL)isYesterday;
- (NSDate *)dateWithYMD;
@end

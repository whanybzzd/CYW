//
//  StringUtils.h
//  TGoTest
//
//  Created by ZMJ on 14-9-1.
//  Copyright (c) 2014年 MJShareDemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtils : NSObject
/**
 *  得到文本框的值
 *
 *  @param sources 文本框对象
 *
 *  @return 文本字符串
 */
+ (NSString *) trimString:(NSString *)sources;
/**
 *  判断字符串是否为空
 *
 *  @param sources 传入的字符串
 *
 *  @return yes no
 */
+ (BOOL) isEmity:(NSString *)sources;

/**
 *  验证手机号码是否正确
 */
+ (BOOL)isMobileNumber:(NSString *)mobileNum;
@end

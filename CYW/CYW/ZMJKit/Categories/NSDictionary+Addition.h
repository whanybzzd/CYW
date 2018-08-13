//
//  NSDictionary+Addition.h
//  Framework
//
//  Created by ZMJ on 16/3/19.
//  Copyright © 2016年 ZMJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Addition)

/*!
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

/*!
 * @brief 把格式化的JSON格式的字典转换成字符串
 * @param dic JSON格式
 * @return 返回字符
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

@end

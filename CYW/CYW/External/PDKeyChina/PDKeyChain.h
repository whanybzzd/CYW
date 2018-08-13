//
//  PDKeyChain.h
//  PDKeyChain
//
//  Created by Panda on 16/8/23.
//  Copyright © 2016年 v2panda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h>

@interface PDKeyChain : NSObject

/**
 存储字符串到 KeyChain

 @param string NSString
 */
+ (void)keyChainSave:(NSString *)string;

/**
 *  从 KeyChain 中读取存储的字符串
 *
 *  @return NSString
 */
+ (NSString *)keyChainLoad;

/**
 *  删除 KeyChain 信息
 */
+ (void)keyChainDelete;


/**
 存储设备唯一标识符

 @param string 标识符
 */
+ (void)keyChainidentifierSave:(NSString *)string;


/**
 读取设备唯一标识符

 @return <#return value description#>
 */
+ (NSString *)keyChainidentifierLoad;
@end

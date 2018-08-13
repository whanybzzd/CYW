//
//  NSObject+Addition.h
//  xcode6
//
//  Created by ZMJ on 15/3/12.
//  Copyright (c) 2015年 MJShareDemo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Addition)
+ (BOOL)isEmpty:(id)object;
+ (BOOL)isNotEmpty:(id)object;

/**
 *  判断邮箱格式是否输入正确
 *
 *  @param email 传入的邮箱
 *
 *  @return 返回YES or NO
 */
+ (BOOL) validateEmail:(NSString *)email;


/**
 *  验证手机号是否正确
 *
 *  @param mobile 传入的手机号
 *
 *  @return 返回YES or NO
 */
+ (BOOL) validateMobile:(NSString *)mobile;


/**
 *  判断用户名是否合格
 *
 *  @param name 传入的用户名
 *
 *  @return 返回YES  or NO
 */
+ (BOOL) validateUserName:(NSString *)name;

/**
 *  判断密码是否正确
 *
 *  @param passWord 传入的密码
 *
 *  @return 返回YES or NO
 */
+ (BOOL) validatePassword:(NSString *)passWord;

/**
 *  判断昵称是否正确
 *
 *  @param nickname 传入的昵称
 *
 *  @return 返回YES or NO
 */
+ (BOOL) validateNickname:(NSString *)nickname;


/**
 *  判断身份证是否正确
 *
 *  @param identityCard 传入的身份证
 *
 *  @return 返回YES or NO
 */
+ (BOOL) validateIdentityCard: (NSString *)identityCard;

+ (NSString *)MD5Encrypt:(NSString *)string;//md5
- (NSString *)getSha1String:(NSString *)srcString;//sha1


+ (NSObject *)data:(id)responseObject modelName:(NSString *)modelName;
@end

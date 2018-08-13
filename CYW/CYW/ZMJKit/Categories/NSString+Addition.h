//
//  NSString+Addition.h
//  xcode6
//
//  Created by ZMJ on 15/3/12.
//  Copyright (c) 2015年 MJShareDemo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "EnumClass.h"
#import <CommonCrypto/CommonCryptor.h>
@interface NSString (Addition)
+ (BOOL)isUrl:(NSString *)string;
+ (NSString *)trimString:(NSString *)string;
+ (BOOL)isNotUrl:(NSString *)string;


/**
 *  设置tag
 *
 *  @param alias 设置别名
 *  @param tags  设置tag
 */
+ (void)analyseInput:(NSString **)alias tags:(NSSet **)tags;

/**
 *  设置tage
 *
 *  @param tags 设置tag
 *  @param tag  设置tag
 */
+ (void)setTags:(NSMutableSet *)tags addTag:(NSString *)tag;

#pragma mark - 字符串比较
/**
 *  比较两个版本号的大小
 *
 *  @param versionString1 1.2.1  -1  0   1
 *  @param versionString2 1.2.2
 *
 *  @return 0:version1小  1:两者相等  2:version1大
 */
//+ (VersionCompareResult)compareBetweenVersion:(NSString *)version1 withVersion:(NSString *)version2;

+ (NSUInteger)compareWithVersion:(NSString *)version2;

+ (NSString *)getIPAddress;
+(NSString*)strmethodComma:(NSString*)str;

+(NSString *) jsonStringWithArray:(NSArray *)array;
+(NSString *) jsonStringWithObject:(id) object;
+(NSString *) jsonStringWithString:(NSString *) string;
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary;
//返回UTF8字符串编码
+(NSString *)relpaceingUTF8String:(NSString *)string;

/**
 *  匹配参数，然后返回加密后的字符串
 *  
 *  @param dictParam 传入的字典
 *  @return 返回加密后的字符串
 */

+ (NSString *)ReturnMD5String:(NSDictionary *)dictParam;

+ (NSDate *)lastMonth:(NSDate *)date;
+ (NSDate*)nextMonth:(NSDate *)date;
+ (NSString *)getDateForNowWithFormatter:(NSString *)formatter;
+ (NSInteger)year:(NSDate *)date;
+ (NSInteger)month:(NSDate *)date;
+ (NSInteger)day:(NSDate *)date;
+ (NSInteger)totaldaysInMonth:(NSDate *)date;
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date;
+ (NSString *)decodeString:(NSString*)encodedString;
/**
 返回图片在Documents的地址

 @param imageData 压缩后的NSData图片
 @param account 图片count
 @return 返回路径
 */
+ (BOOL )returnImagFilePath:(NSData *)imageData withImageCurrentCount:(NSString *)account;

/**
 *  计算缓存的大小
 *
 *  @param filePath 文件路径
 *
 *  @return 返回缓存大小
 */
+ (NSString *)cacheObjectSize:(NSString *)filePath;



+ (NSInteger)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime;

+(NSString*) uuid;

/**
 请求Id，不能同一

 @return NSString
 */
+ (NSString *)RequestequipmentId;

/**
 返回设备唯一编码

 @return NSString
 */
+(NSString *)currentDeviceNumber;

/**
 过滤Html标签
 
 @param html html标签
 @return 字符串
 */
+ (NSString *)flattenHTML:(NSString *)html;
- (NSString *)MD5Hash;
@end

///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  针对NSString扩展——加密解密
//
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSString (Security)

#pragma mark - base64加密解密(标准的)
+ (NSString *)Base64Encrypt:(NSString *)string;//加密
- (NSString *)Base64EncryptString;
+ (NSString *)Base64Decrypt:(NSString *)string;//解密
- (NSString *)Base64DecryptString;

#pragma mark - AES加密解密
+ (NSString *)AESEncrypt:(NSString *)string;
- (NSString *)AESEncryptString;
+ (NSString *)AESEncrypt:(NSString *)string useKey:(NSString *)key;

+ (NSString *)AESDecrypt:(NSString *)string;
- (NSString *)AESDecryptString;
+ (NSString *)AESDecrypt:(NSString *)string useKey:(NSString *)key;

#pragma mark - DES加密解密
+ (NSString *)DESEncrypt:(NSString *)string;
- (NSString *)DESEncryptString;
+ (NSString *)DESEncrypt:(NSString *)string useKey:(NSString *)key;

+ (NSString *)DESDecrypt:(NSString *)string;
- (NSString *)DESDecryptString;
+ (NSString *)DESDecrypt:(NSString *)string useKey:(NSString *)key;


#pragma mark - RSA加密解密
//TODO:需要调用openssl标准函数实现

#pragma mark - MD5加密(标准的)
+ (NSString*)MD5Encrypt:(NSString*)string;
- (NSString*)MD5EncryptString;

#pragma mark - SHA1HASH加密
+ (NSString *)Sha1Hash:(NSString *)string;
- (NSString *)Sha1HashString;

#pragma mark - HMacSha1
+ (NSString *) hmacSha1:(NSString*)key text:(NSString*)text;

#pragma mark UTF8编码解码
+ (NSString *)UTF8Encoded:(NSString *)string;
- (NSString *)UTF8EncodedString;
+ (NSString *)UTF8Decoded:(NSString *)string;
- (NSString *)UTF8DecodedString;

#pragma mark 3DES加密
+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key;

@end

///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  针对NSString扩展——带emoji表情的富文本显示
//  Created by Joey on 14-9-17.
//  Copyright (c) 2014年 JoeytatEmojiText. All rights reserved.
///////////////////////////////////////////////////////////////////////////////////////////////////
@interface NSString (EmojiAttributedString)

//
//  NSObject+Addition.m
//  xcode6
//
//  Created by ZMJ on 15/3/12.
//  Copyright (c) 2015年 MJShareDemo. All rights reserved.
//

#import "NSObject+Addition.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
@implementation NSObject (Addition)
#pragma mark -  check empty
+ (BOOL)isEmpty:(id)object {
    return (object == nil
            || [object isKindOfClass:[NSNull class]]
            || ([object respondsToSelector:@selector(length)] && [(NSData *)object length] == 0)
            || ([object respondsToSelector:@selector(count)]  && [(NSArray *)object count] == 0));
}

+ (BOOL)isNotEmpty:(id)object {
    return ( ! [self isEmpty:object]);
}


+ (BOOL) validateEmail:(NSString *)email
{
    NSString *emailRegex = @"^\\w+([-+.]\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

//手机号码验证
+ (BOOL) validateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^(0|86|17951)?(13[0-9]|15[012356789]|17[678]|18[0-9]|14[57])[0-9]{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


//用户名
+ (BOOL) validateUserName:(NSString *)name
{
    NSString *userNameRegex = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *userNamePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",userNameRegex];
    return [userNamePredicate evaluateWithObject:name];
}


//密码
+ (BOOL) validatePassword:(NSString *)passWord
{
    NSString *passWordRegex = @"^[a-zA-Z0-9]{6,20}+$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:passWord];
}



//昵称
+ (BOOL) validateNickname:(NSString *)nickname
{
    NSString *nicknameRegex = @"^[\u4e00-\u9fa5]{4,8}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",nicknameRegex];
    return [passWordPredicate evaluateWithObject:nickname];
}



+ (BOOL) validateIdentityCard: (NSString *)identityCard
{
    BOOL flag;
    if (identityCard.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}([0-9]|x)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:identityCard];
}

#pragma mark - MD5加密(标准的)
+ (NSString *)MD5Encrypt:(NSString *)string {
    ReturnEmptyWhenObjectIsEmpty(string)
    const char *cStr = [string UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
}
#pragma mark - sha1加密
- (NSString *)getSha1String:(NSString *)srcString{
    ReturnEmptyWhenObjectIsEmpty(srcString)
    const char *cstr = [srcString cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:srcString.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    //去掉cc_long
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
}


+ (NSObject *)data:(id)responseObject modelName:(NSString *)modelName{
    
    NSObject *dataModel=responseObject;
    JSONModelError *initError = nil;
    if ([dataModel isKindOfClass:[NSArray class]]) {
        
        if ( [NSString isNotEmpty:modelName] && [NSClassFromString(modelName) isSubclassOfClass:[BaseDataModel class]]) {
            dataModel = [NSClassFromString(modelName) arrayOfModelsFromDictionaries:(NSArray *)dataModel error:&initError];
            
        }
    }
    else if ([dataModel isKindOfClass:[NSDictionary class]]) {
        
        if ( [NSString isNotEmpty:modelName] && [NSClassFromString(modelName) isSubclassOfClass:[BaseDataModel class]]) {
            dataModel = [[NSClassFromString(modelName) alloc] initWithDictionary:(NSDictionary *)dataModel error:&initError];
            
        }
    }
    return dataModel;
}

@end

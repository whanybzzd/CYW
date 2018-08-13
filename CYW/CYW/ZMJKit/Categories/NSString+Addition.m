//
//  NSString+Addition.m
//  xcode6
//
//  Created by ZMJ on 15/3/12.
//  Copyright (c) 2015年 MJShareDemo. All rights reserved.
//

#import "NSString+Addition.h"
#import "sys/utsname.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "GTMBase64.h"
#include <net/if.h>

@implementation NSString (Addition)


+ (BOOL)isEmptyConsiderWhitespace:(NSString *)string {
    if ([NSString isNotEmpty:string]) {
        return ![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length];
    }
    else {
        return YES;
    }
}


#pragma mark - 字符串简单变换
+ (NSString *)trimString:(NSString *)string {
    ReturnEmptyWhenObjectIsEmpty(string)
    return [string trimString];
}
- (NSString *)trimString {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
+ (BOOL)isUrl:(NSString *)string {
    ReturnNOWhenObjectIsEmpty(string)
    return [string isUrl];
}

- (BOOL)isUrl {
    return [NSString isMatchRegex:RegexUrl withString:self];
}
+ (BOOL)isNotUrl:(NSString *)string {
    return ![self isUrl:string];
}

//版本升级
+ (NSUInteger)compareWithVersion:(NSString *)version2{
    
    NSUInteger compareResultNumber=0;
    //按照.来分解成数组
    NSArray *version2Array=[NSString splitString:version2 byRegex:@"\\."];
    NSArray* reversedArray = [[version2Array reverseObjectEnumerator] allObjects];
   
    for (int i=0; i<[reversedArray count]; i++) {
        
        NSUInteger version1Value=   pow(10, i+1)*[reversedArray[i] integerValue];
        
        compareResultNumber=compareResultNumber+version1Value;
        
    }
    return compareResultNumber;
}

+(CGSize)sizeWithFont:(UIFont *)font withstring:(NSString *)str
{
    return  [str sizeWithFont:font constrainedToSize:CGSizeMake(120, 20) lineBreakMode:NSLineBreakByWordWrapping];
}

+ (void)analyseInput:(NSString **)alias tags:(NSSet **)tags {
    // alias analyse
    if (![*alias length]) {
        // ignore alias
        *alias = nil;
    }
    // tags analyse
    if (![*tags count]) {
        *tags = nil;
    } else {
        __block int emptyStringCount = 0;
        [*tags enumerateObjectsUsingBlock:^(NSString *tag, BOOL *stop) {
            if ([tag isEqualToString:@""]) {
                emptyStringCount++;
            } else {
                emptyStringCount = 0;
                *stop = YES;
            }
        }];
        if (emptyStringCount == [*tags count]) {
            *tags = nil;
        }
    }
}


+ (void)setTags:(NSMutableSet *)tags addTag:(NSString *)tag {
    //  if ([tag isEqualToString:@""]) {
    // }
    [tags addObject:tag];
}
+ (BOOL)isMatchRegex:(NSString*)pattern withString:(NSString *)string {
    ReturnNOWhenObjectIsEmpty(string)
    return [string isMatchRegex:pattern options:NSRegularExpressionCaseInsensitive];
}
- (BOOL)isMatchRegex:(NSString *)pattern options:(NSRegularExpressionOptions)options {
    ReturnNOWhenObjectIsEmpty(pattern)
    
    //方法一：缺点是无法兼容大小写的情况
    //	NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    //	return [identityCardPredicate evaluateWithObject:self];
    
    //方法二：
    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                options:options
                                                                                  error:&error];
    if (error) {
        NSLog(@"Error by creating Regex: %@",[error description]);
        return NO;
    }
    
    return ([expression numberOfMatchesInString:self options:0 range:NSMakeRange(0, [self length])] > 0);
}


+ (NSString *)getIPAddress {
    NSString *address = @"error";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
    
}


/**
 过滤Html标签
 
 @param html html标签
 @return 字符串
 */
+ (NSString *)flattenHTML:(NSString *)html {
    
    NSScanner *theScanner;
    NSString *text = nil;
    
    theScanner = [NSScanner scannerWithString:html];
    
    while ([theScanner isAtEnd] == NO) {
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        [theScanner scanUpToString:@">" intoString:&text] ;
        html = [html stringByReplacingOccurrencesOfString:
                [NSString stringWithFormat:@"%@>", text]
                                               withString:@""];
    }
    return html;
}


+(NSString *) jsonStringWithArray:(NSArray *)array{
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"["];
    NSMutableArray *values = [NSMutableArray array];
    for (id valueObj in array) {
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [values addObject:[NSString stringWithFormat:@"%@",value]];
        }
    }
    [reString appendFormat:@"%@",[values componentsJoinedByString:@":"]];
    [reString appendString:@"]"];
    return reString;
}
+(NSString *) jsonStringWithObject:(id) object{
    NSString *value = nil;
    if (!object) {
        return value;
    }
    if ([object isKindOfClass:[NSString class]]) {
        value = [self jsonStringWithString:object];
    }else if([object isKindOfClass:[NSDictionary class]]){
        value = [self jsonStringWithDictionary:object];
    }else if([object isKindOfClass:[NSArray class]]){
        value = [self jsonStringWithArray:object];
    }
    return value;
}

+(NSString *) jsonStringWithString:(NSString *) string{
    return [NSString stringWithFormat:@"\"%@\"",
            [[string stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"] stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""]
            ];
}
+(NSString *) jsonStringWithDictionary:(NSDictionary *)dictionary{
    NSArray *keys = [dictionary allKeys];
    NSMutableString *reString = [NSMutableString string];
    [reString appendString:@"{"];
    NSMutableArray *keyValues = [NSMutableArray array];
    for (int i=0; i<[keys count]; i++) {
        NSString *name = [keys objectAtIndex:i];
        id valueObj = [dictionary objectForKey:name];
        NSString *value = [self jsonStringWithObject:valueObj];
        if (value) {
            [keyValues addObject:[NSString stringWithFormat:@"\"%@\":%@",name,value]];
        }
    }
    [reString appendFormat:@"%@",[keyValues componentsJoinedByString:@","]];
    [reString appendString:@"}"];
    return reString;
}


+ (NSString *)relpaceingUTF8String:(NSString *)string{
    
    return [NSString stringWithString:[string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
}


+ (NSString *)ReturnMD5String:(NSDictionary *)dictParam{
   ReturnEmptyWhenObjectIsEmpty(dictParam)
    //1. 添加默认'version'参数
    NSArray *keys = [[dictParam allKeys] sortedArrayUsingSelector:@selector(compare:)];
    
    //2. 按照字典顺序拼接url字符串
    NSMutableString *joinedString = [NSMutableString string];
    for (NSString *key in keys) {
        NSObject *value = dictParam[key];
        NSString *newValue = [NSString stringWithFormat:@"%@", [NSObject isEmpty:value] ? @"" : value];
        [joinedString appendFormat:@"%@", newValue];
        
    }
    
    //3. 对参数进行md5加密
    NSString *newString = [NSString stringWithFormat:@"%@", joinedString];
    NSLog(@"newString = %@", newString);
    return [[NSString Sha1Hash:newString] lowercaseString];
    
}


+(NSString*) uuid {
    CFUUIDRef puuid = CFUUIDCreate( nil );
    CFStringRef uuidString = CFUUIDCreateString( nil, puuid );
    NSString * result = (NSString *)CFBridgingRelease(CFStringCreateCopy( NULL, uuidString));
    CFRelease(puuid);
    CFRelease(uuidString);
    if ([self isEmpty:[[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"]]) {
        [[NSUserDefaults standardUserDefaults] setValue:result forKey:@"uuid"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
    }
    
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"uuid"];
}

+ (NSString *)RequestequipmentId{

    NSString * requestIDString = nil;
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"requestID"]!=nil) {
        requestIDString = [[NSUserDefaults standardUserDefaults] objectForKey:@"requestID"];
    }else{
        long tag = 1;
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",tag] forKey:@"requestID"];
    }
    long tag = [[[NSUserDefaults standardUserDefaults] objectForKey:@"requestID"] integerValue];
   NSString *requestId = [NSString stringWithFormat:@"%ld",tag];
    tag++;
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",tag] forKey:@"requestID"];
    return requestId;
}

//一个月第一个周末
+ (NSInteger)firstWeekdayInThisMonth:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
    NSDateComponents *component = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    [component setDay:1];
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:component];
    NSUInteger firstWeekDay = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekDay - 1;
}
//总天数
+ (NSInteger)totaldaysInMonth:(NSDate *)date{
    NSRange daysInOfMonth = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return daysInOfMonth.length;
}
+ (NSDate *)lastMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

+ (NSDate*)nextMonth:(NSDate *)date{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}
+(NSString*)strmethodComma:(NSString*)str
{
    
    NSString *intStr;
    
    NSString *floStr;
    
    if ([str containsString:@"."]) {
        
        NSRange range = [str rangeOfString:@"."];
        
        floStr = [str substringFromIndex:range.location];
        
        intStr = [str substringToIndex:range.location];
        
    }else{
        
        floStr = @"";
        
        intStr = str;
        
    }
    
    if (intStr.length <=3) {
        
        return [intStr stringByAppendingString:floStr];
        
    }else{
        
        NSInteger length = intStr.length;
        
        NSInteger count = length/3;
        
        NSInteger y = length%3;
        
        
        NSString *tit = [intStr substringToIndex:y] ;
        
        NSMutableString *det = [[intStr substringFromIndex:y] mutableCopy];
        
        
        for (int i =0; i < count; i ++) {
            
            NSInteger index = i + i *3;
            
            [det insertString:@","atIndex:index];
            
        }
        
        if (y ==0) {
            
            det = [[det substringFromIndex:1]mutableCopy];
            
        }
        
        intStr = [tit stringByAppendingString:det];
        
        return [intStr stringByAppendingString:floStr];
        
    }
}

#pragma mark - date get: day-month-year

+ (NSInteger)day:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}


+ (NSInteger)month:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

+ (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}


+ (NSString *)getDateForNowWithFormatter:(NSString *)formatter {
    if(formatter){
        NSDate *now = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        //dateFormatter.dateFormat = @"YYYY年MM月dd日";
        dateFormatter.dateFormat = formatter;
        NSString *nowStr = [dateFormatter stringFromDate:now];
        return nowStr;
    }
    else{
        return @"参数错误";
    }
}



+ (BOOL )returnImagFilePath:(NSData *)imageData withImageCurrentCount:(NSString *)account{
    
    //把刚刚图片转换的data对象拷贝至沙盒中 并保存为image.png
    [kDefaultFileManager createDirectoryAtPath:kDefaultDocuments(account) withIntermediateDirectories:YES attributes:nil error:nil];
    
    return  [kDefaultFileManager createFileAtPath:[kDefaultDocuments(account) stringByAppendingString:[NSString stringWithFormat:@"/%@.png",account]] contents:imageData attributes:nil];
    
}

/**
 * 开始到结束的时间差
 */
+ (NSInteger)dateTimeDifferenceWithStartTime:(NSString *)startTime endTime:(NSString *)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *startD =[date dateFromString:startTime];
    NSDate *endD = [date dateFromString:endTime];
    NSTimeInterval start = [startD timeIntervalSince1970]*1;
    NSTimeInterval end = [endD timeIntervalSince1970]*1;
    NSTimeInterval value = end - start;
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    NSString *str;
    if (day != 0) {
        str = [NSString stringWithFormat:@"耗时%d天%d小时%d分%d秒",day,house,minute,second];
    }else if (day==0 && house != 0) {
        str = [NSString stringWithFormat:@"耗时%d小时%d分%d秒",house,minute,second];
    }else if (day== 0 && house== 0 && minute!=0) {
        str = [NSString stringWithFormat:@"耗时%d分%d秒",minute,second];
    }else{
        str = [NSString stringWithFormat:@"耗时%d秒",second];
    }
    return day;
}


+ (NSString *)cacheObjectSize:(NSString *)filePath{
    long long SizeFloat=0.0f;
    SizeFloat=[self fileSizeAtPath:filePath]+[self folderSizeAtPath];
    if (SizeFloat >= pow(10, 9)) { // size >= 1GB
        return [NSString stringWithFormat:@"%.2fGB", SizeFloat / pow(10, 9)];
    } else if (SizeFloat >= pow(10, 6)) { // 1GB > size >= 1MB
        return [NSString stringWithFormat:@"%.2fMB", SizeFloat / pow(10, 6)];
    } else if (SizeFloat >= pow(10, 3)) { // 1MB > size >= 1KB
        return [NSString stringWithFormat:@"%.2fKB", SizeFloat / pow(10, 3)];
    } else { // 1KB > size
        return [NSString stringWithFormat:@"%zdB", SizeFloat];
    }
    
}


+(long long) fileSizeAtPath:(NSString*) filePath{
    // 总大小
    unsigned long long size = 0;
    NSFileManager *manager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    BOOL exist = [manager fileExistsAtPath:filePath isDirectory:&isDir];
    
    // 判断路径是否存在
    if (!exist) return size;
    if (isDir) { // 是文件夹
        NSDirectoryEnumerator *enumerator = [manager enumeratorAtPath:filePath];
        for (NSString *subPath in enumerator) {
            NSString *fullPath = [filePath stringByAppendingPathComponent:subPath];
            size += [manager attributesOfItemAtPath:fullPath error:nil].fileSize;
            
        }
    }else{ // 是文件
        size += [manager attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    return size;
}







+ (long long) folderSizeAtPath{
    
    NSString *folderPath=kDefaultDocuments(@"VideoImage/");
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if (![manager fileExistsAtPath:folderPath]) return 0;
    
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    
    NSString* fileName;
    
    long long folderSize = 0;
    
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
        
    }
    return folderSize;

    
}
- (long long) fileSizeAtPath:(NSString*) filePath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    
    if ([manager fileExistsAtPath:filePath]){
        
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}



+ (NSString *)currentDeviceNumber{
    return [UIDevice currentDevice].identifierForVendor.UUIDString;
}


- (NSString *)replaceByRegex:(NSString *)pattern to:(NSString *)toString options:(NSRegularExpressionOptions)options{
    ReturnEmptyWhenObjectIsEmpty(pattern)
    //方法一：缺点是仅仅用于普通字符串，无法兼容正则表达式的情况
    //	return [self stringByReplacingOccurrencesOfString:pattern withString:toString];
    
    //方法二：
    NSError *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:pattern
                                                                                options:options
                                                                                  error:&error];
    if (error) {
        NSLog(@"Error by creating Regex: %@",[error description]);
        return @"";
    }
    return [expression stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:toString];
}
#pragma mark - 字符串分解
+ (NSArray *)splitString:(NSString *)string byRegex:(NSString *)pattern {
    if ([NSString isEmpty:string]) {
        return @[];
    }
    return [string splitByRegex:pattern options:NSRegularExpressionCaseInsensitive];
}
- (NSArray *)splitByRegex:(NSString *)pattern options:(NSRegularExpressionOptions)options {
    if ([NSString isEmpty:pattern]) {
        return @[];
    }
#define SpecialPlaceholderString @"_&&_"   //特殊占位符
    NSString *newString = [self replaceByRegex:pattern to:SpecialPlaceholderString options:options];
    NSArray *sourceArray = [newString componentsSeparatedByString:SpecialPlaceholderString];
    NSMutableArray *components = [NSMutableArray array];
    for (NSString *component in sourceArray) {
        if (![NSString isEmptyConsiderWhitespace:component]) {
            [components addObject:[component trimString]];
        }
    }
    return components;
}
@end


///////////////////////////////////////////////////////////////////////////////////////////////////
//
//  针对NSString扩展——加密解密
//
///////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSString (Security)

#define DEFAULTKEY      @"&*^YHGd5"                     //默认秘钥
#define DEFAULTIV       { 11, 17, 37, 43, 59, 61, 97, 83 }       //默认向量

#pragma mark - base64加密解密(标准的)
+ (NSString *)Base64Encrypt:(NSString *)string {
    ReturnEmptyWhenObjectIsEmpty(string)
    return [string Base64EncryptString];
}

- (NSString *)Base64EncryptString {
    NSData *sourceData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [sourceData base64EncodedDataWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return [[NSString alloc] initWithData:encryptData encoding:NSUTF8StringEncoding];
}

+ (NSString *)Base64Decrypt:(NSString *)string {
    ReturnEmptyWhenObjectIsEmpty(string)
    return [string Base64DecryptString];
}

- (NSString *)Base64DecryptString {
    NSData *encryptData = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSData *decryptData = [[NSData alloc] initWithBase64EncodedData:encryptData options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}


#pragma mark - AES加密解密
+ (NSString *)AESEncrypt:(NSString *)string {
    if ([NSString isEmpty:string]) {
        return @"";
    }
    return [string AESEncryptString];
}

- (NSString *)AESEncryptString {
    return [NSString AESEncrypt:self useKey:DEFAULTKEY];
}

+ (NSString *)AESEncrypt:(NSString *)string useKey:(NSString *)key {
    ReturnEmptyWhenObjectIsEmpty(string)
    ReturnEmptyWhenObjectIsEmpty(key)
    NSData *sourceData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [self AESEncryptData:sourceData useKey:key];
    return [self dataBytesToHexString:encryptData];
}
//私有方法
+ (NSData *)AESEncryptData:(NSData *)data useKey:(NSString *)key {
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

+ (NSString *)AESDecrypt:(NSString *)string {
    ReturnEmptyWhenObjectIsEmpty(string)
    return [string AESDecryptString];
}

- (NSString *)AESDecryptString {
    return [NSString AESDecrypt:self useKey:DEFAULTKEY];
}

+ (NSString *)AESDecrypt:(NSString *)string useKey:(NSString *)key {
    ReturnEmptyWhenObjectIsEmpty(string)
    ReturnEmptyWhenObjectIsEmpty(key)
    NSData *encryptData = [self hexStringToDataBytes:string];
    NSData *decryptData = [self AESDecryptData:encryptData useKey:key];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}
//私有方法
+ (NSData *)AESDecryptData:(NSData *)data useKey:(NSString *)key {
    char keyPtr[kCCKeySizeAES256 + 1];
    bzero(keyPtr, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          NULL,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

- (NSString *)MD5Hash
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (unsigned)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

#pragma mark - DES加密解密
+ (NSString *)DESEncrypt:(NSString *)string {
    
    ReturnEmptyWhenObjectIsEmpty(string)
    return [string DESEncryptString];
}

- (NSString *)DESEncryptString {
    return [NSString DESEncrypt:self useKey:DEFAULTKEY];
}

+ (NSString *)DESEncrypt:(NSString *)string useKey:(NSString *)key {
    ReturnEmptyWhenObjectIsEmpty(string)
    ReturnEmptyWhenObjectIsEmpty(key)
    NSData *sourceData = [string dataUsingEncoding:NSUTF8StringEncoding];
    NSData *encryptData = [self DESEncryptData:sourceData useKey:key];
    return [self dataBytesToHexString:encryptData];
}
//私有方法
+ (NSData *)DESEncryptData:(NSData *)data useKey:(NSString *)key {
    static Byte iv[] = DEFAULTIV;
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    free(buffer);
    return nil;
}

+ (NSString *)DESDecrypt:(NSString *)string {
    ReturnEmptyWhenObjectIsEmpty(string)
    return [string DESDecryptString];
}

- (NSString *)DESDecryptString {
    return [NSString DESDecrypt:self useKey:DEFAULTKEY];
}

+ (NSString *)DESDecrypt:(NSString *)string useKey:(NSString *)key {
    ReturnEmptyWhenObjectIsEmpty(string)
    ReturnEmptyWhenObjectIsEmpty(key)
    NSData *encryptData = [self hexStringToDataBytes:string];
    NSData *decryptData = [self DESDecryptData:encryptData useKey:key];
    return [[NSString alloc] initWithData:decryptData encoding:NSUTF8StringEncoding];
}
//私有方法
+ (NSData *)DESDecryptData:(NSData *)data useKey:(NSString *)key {
    static Byte iv[] = DEFAULTIV;
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeDES;
    void *buffer = malloc(bufferSize);
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmDES,
                                          kCCOptionPKCS7Padding | kCCOptionECBMode,
                                          [key UTF8String],
                                          kCCKeySizeDES,
                                          iv,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesDecrypted);
    if (cryptStatus == kCCSuccess) {
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    free(buffer);
    return nil;
}

#pragma mark - RSA加密解密
//TODO:需要调用openssl标准函数实现



#pragma mark - MD5加密(标准的)
+ (NSString *)MD5Encrypt:(NSString *)string {
    ReturnEmptyWhenObjectIsEmpty(string)
    return [string MD5EncryptString];
}

- (NSString*)MD5EncryptString {
    NSData *sourceData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5([sourceData bytes], (CC_LONG)[sourceData length], result);
    
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

#pragma mark - SHA1HASH加密
+ (NSString *)Sha1Hash:(NSString *)string {
    ReturnEmptyWhenObjectIsEmpty(string)
    return [string Sha1HashString];
}



- (NSString *)Sha1HashString {
    NSData *sourceData = [self dataUsingEncoding:NSUTF8StringEncoding];
    unsigned char result[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1([sourceData bytes], (CC_LONG)[sourceData length], result);
    
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15],
            result[16], result[17], result[18], result[19]
            ];
}

+ (NSString *) hmacSha1:(NSString*)key text:(NSString*)text

{
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [text cStringUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    //NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:CC_SHA1_DIGEST_LENGTH];
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        
        [output appendFormat:@"%02x", cHMAC[i]];
    
    hash = output;
    
    return hash;
    
}



#pragma mark UTF8编码解码
+ (NSString *)UTF8Encoded:(NSString *)string {
    ReturnEmptyWhenObjectIsEmpty(string)
    return [string UTF8EncodedString];
}

- (NSString *)UTF8EncodedString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                                 (CFStringRef)self,
                                                                                 NULL,
                                                                                 CFSTR("!*'();:@&=+$,/?%#[]"),
                                                                                 kCFStringEncodingUTF8));
}

+ (NSString *)UTF8Decoded:(NSString *)string {
    ReturnEmptyWhenObjectIsEmpty(string)
    return [string UTF8DecodedString];
}

- (NSString *)UTF8DecodedString {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault,
                                                                                                 (CFStringRef)self,
                                                                                                 CFSTR(""),
                                                                                                 kCFStringEncodingUTF8));
}

#pragma mark - 私有方法
/**
 *  将NSData数组转换成十六进制字符串
 *
 */
+ (NSString *)dataBytesToHexString:(NSData *)data {
    NSMutableString *stringBuffer = [NSMutableString stringWithCapacity:([data length] * 2)];
    const unsigned char *dataBuffer = [data bytes];
    int i;
    for (i = 0; i <= [data length]; ++i) {
        [stringBuffer appendFormat:@"%02lX", (unsigned long)dataBuffer[i]];
    }
    return [stringBuffer copy];
}

/**
 *  将十六进制字符串转化成NSData数组
 *
 */
+ (NSData *)hexStringToDataBytes:(NSString *)string {
    NSMutableData *data = [NSMutableData data];
    int idx;
    for (idx = 0; idx + 2 < string.length; idx += 2) {
        NSString *hexStr = [string substringWithRange:NSMakeRange(idx, 2)];
        NSScanner *scanner = [NSScanner scannerWithString:hexStr];
        unsigned int intValue;
        [scanner scanHexInt:&intValue];
        [data appendBytes:&intValue length:1];
    }
    return data;
}

//URLDEcode
+ (NSString *)decodeString:(NSString*)encodedString

{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)encodedString,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}
+ (NSString*)TripleDES:(NSString*)plainText encryptOrDecrypt:(CCOperation)encryptOrDecrypt key:(NSString*)key {
    
    const void *vplainText;
    size_t plainTextBufferSize;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        NSData *EncryptData = [GTMBase64 decodeData:[plainText dataUsingEncoding:NSUTF8StringEncoding]];
        plainTextBufferSize = [EncryptData length];
        vplainText = [EncryptData bytes];
    }
    else
    {
        NSData* data = [plainText dataUsingEncoding:NSUTF8StringEncoding];
        plainTextBufferSize = [data length];
        vplainText = (const void *)[data bytes];
    }
    
    CCCryptorStatus ccStatus;
    uint8_t *bufferPtr = NULL;
    size_t bufferPtrSize = 0;
    size_t movedBytes = 0;
    // uint8_t ivkCCBlockSize3DES;
    
    bufferPtrSize = (plainTextBufferSize + kCCBlockSize3DES) & ~(kCCBlockSize3DES - 1);
    bufferPtr = malloc( bufferPtrSize * sizeof(uint8_t));
    memset((void *)bufferPtr, 0x0, bufferPtrSize);
    // memset((void *) iv, 0x0, (size_t) sizeof(iv));
    
    //    NSString *key = @"123456789012345678901234";
    NSString *initVec = @"p2p_s2iv";
    const void *vkey = (const void *) [key UTF8String];
    const void *vinitVec = (const void *) [initVec UTF8String];
    
    ccStatus = CCCrypt(encryptOrDecrypt,
                       kCCAlgorithm3DES,
                       kCCOptionPKCS7Padding,
                       vkey, //"123456789012345678901234", //key
                       kCCKeySize3DES,
                       vinitVec, //"init Vec", //iv,
                       vplainText, //"Your Name", //plainText,
                       plainTextBufferSize,
                       (void *)bufferPtr,
                       bufferPtrSize,
                       &movedBytes);
    //if (ccStatus == kCCSuccess) NSLog(@"SUCCESS");
    /*else if (ccStatus == kCC ParamError) return @"PARAM ERROR";
     else if (ccStatus == kCCBufferTooSmall) return @"BUFFER TOO SMALL";
     else if (ccStatus == kCCMemoryFailure) return @"MEMORY FAILURE";
     else if (ccStatus == kCCAlignmentError) return @"ALIGNMENT";
     else if (ccStatus == kCCDecodeError) return @"DECODE ERROR";
     else if (ccStatus == kCCUnimplemented) return @"UNIMPLEMENTED"; */
    
    NSString *result;
    
    if (encryptOrDecrypt == kCCDecrypt)
    {
        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)bufferPtr
                                                               length:(NSUInteger)movedBytes]
                                       encoding:NSUTF8StringEncoding]
        ;
    }
    else
    {
        NSData *myData = [NSData dataWithBytes:(const void *)bufferPtr length:(NSUInteger)movedBytes];
        result = [GTMBase64 stringByEncodingData:myData];
    }
    
    return result;
    
}



@end



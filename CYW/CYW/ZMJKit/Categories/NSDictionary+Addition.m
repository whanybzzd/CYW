//
//  NSDictionary+Addition.m
//  Framework
//
//  Created by ZMJ on 16/3/19.
//  Copyright © 2016年 ZMJ. All rights reserved.
//

#import "NSDictionary+Addition.h"

@implementation NSDictionary (Addition)

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if ([NSString isEmpty:jsonString]) {
        
        return nil;
    }else{
        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError *err;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                            options:NSJSONReadingMutableContainers
                                                              error:&err];
        if(err) {
            NSLog(@"json解析失败：%@",err);
            return nil;
        }
        return dic;
        
    }
    
}



+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    
    if ([NSObject isEmpty:dic])
    {
        return nil;
    }
    else
    {
        
        NSError *parseError = nil;
        
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:kNilOptions error:&parseError];
        
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
@end

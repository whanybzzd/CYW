//
//  AppConfigManager.h
//  xcode6
//
//  Created by ZMJ on 15/3/17.
//  Copyright (c) 2015年 MJShareDemo. All rights reserved.
//


#import <Foundation/Foundation.h>

@interface AppConfigManager : NSObject
+ (instancetype)sharedInstance;

#pragma mark - AppConfig.plist管理

- (NSString *)valueInAppConfig:(NSString *)key;

@end

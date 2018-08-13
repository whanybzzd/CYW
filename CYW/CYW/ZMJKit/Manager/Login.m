//
//  Login.m
//  SCSDTrade
//
//  Created by  YangShengchao on 14-2-25.
//  Copyright (c) 2014年  YangShengchao. All rights reserved.
//

#import "Login.h"
@interface Login ()

@property (nonatomic, assign) BOOL isAutoLogin;         //是否自动登录(比如sid过期)
@property (nonatomic, assign) BOOL isLogging;           //是否正在登录中

@end

@implementation Login

+ (Login *)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^ {
        return [[self alloc] init];
    })
}

- (instancetype)init{
    
    if (self=[super init]) {
        
        self.loginObservers=[NSMutableArray array];
        self.user=[ParentModel new];
    }
    return self;
}

#pragma mark - methods called outside

// 供外部调用，重新下载用户资料
- (void)refreshUserInfo {
    
    [AFNManager postDataWithAPI:@"centerHandler"
                  withDictParam:@{@"userId":[self token]}
                  withModelName:@"UserCenterInfoViewModel"
                        isModel:YES
               requestSuccessed:^(id responseObject) {
                   
                   //NSLog(@"个人账户信息：%@",responseObject);
                   if ([NSObject isNotEmpty:responseObject]) {

                       UserCenterInfoViewModel *model=(UserCenterInfoViewModel *)responseObject;
                       [[StorageManager sharedInstance] setUserConfigValue:model forKey:kCachedUserCenterInfoModel];
                   }
               } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                   
                   
               }];
}

- (void)refreshAuthentication{
    
    [AFNManager postDataWithAPI:@"investorPermissionRequestHandler"
                  withDictParam:@{@"userId":[self token]}
                  withModelName:@"AuthenticationViewModel"
                        isModel:YES
               requestSuccessed:^(id responseObject) {
                   NSLog(@"实名认证:%@",responseObject);
                   if ([NSObject isNotEmpty:responseObject]) {
                       AuthenticationViewModel *model=(AuthenticationViewModel *)responseObject;
                       [[StorageManager sharedInstance] setUserConfigValue:model forKey:kCachedUserAuthentication];
                   }
                   
               } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                   
                   
               }];
}


- (void)refreshUserInfos{
    NSObject *userModel = [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserModel];
    ParentModel *model=(ParentModel *)userModel;
    [AFNManager postDataWithAPI:@"loginRequestHandler"
                  withDictParam:@{@"username":model.username,
                                  @"password":[[StorageManager sharedInstance] userConfigValueForKey:@"kCachedUserModel"],
                                  @"isNewVersion":@"yes"}
                  withModelName:@"ParentModel"
                        isModel:YES
               requestSuccessed:^(id responseObject) {
                   ParentModel *model=(ParentModel *)responseObject;
                   if ([NSObject isNotEmpty:model]) {
                       //NSLog(@"刷新个人登录信息:%@",model);
                       
                       [[StorageManager sharedInstance] setUserConfigValue:model forKey:kCachedUserModel];
                       
                   }
               } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                   
               }];
    
}

- (void)autoTender{
    
    [AFNManager postDataWithAPI:@"mmmpayAutoInvestHandler"
                  withDictParam:@{@"userId":[Login sharedInstance].token,
                                  @"op":@"2"}
                  withModelName:@"AutomaticallySaveViewModel"
                        isModel:YES
               requestSuccessed:^(id responseObject) {
                   if ([NSObject isNotEmpty:responseObject]) {
                       
                       AutomaticallySaveViewModel *model=(AutomaticallySaveViewModel *)responseObject;
                       [[StorageManager sharedInstance] setUserConfigValue:model forKey:kCachedUserAuto];
                   }
                   
               } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                   
               }];
}
- (void)logout{
    
    
}

#pragma mark - 用户登录/重新登录/退出登录

// 判断是否登录过了
- (BOOL)isLogged {
    NSObject *userModel = [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserModel];
    return [NSObject isNotEmpty:userModel];
}

// 用户ID
- (NSString *)token {
    NSObject *userModel = [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserModel];
    ParentModel *model=(ParentModel *)userModel;
    [[NSUserDefaults standardUserDefaults] setValue:model.photo forKey:@"photo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return [NSString stringWithFormat:@"%@", model.id];
}

/**
 *  清除登录信息
 */
- (void)clearLoginData {
    
    self.user = nil;
    self.token = nil;
    [[StorageManager sharedInstance] setUserConfigValue:[NSNull null] forKey:kCachedUserModel];
    [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserToken];
    
    //清空个人实名认证（防止切换用户  该用户没有实名认证）
    [[StorageManager sharedInstance] setUserConfigValue:[NSNull null] forKey:kCachedUserAuthentication];
    [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserAuthentication];
    
    
    //清空个人资产
    [[StorageManager sharedInstance] setUserConfigValue:[NSNull null] forKey:kCachedUserCenterInfoModel];
    [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserCenterInfoModel];
    
    
    //清空个人银行卡管理信息
    [[StorageManager sharedInstance] setUserConfigValue:[NSNull null] forKey:kCachedUserCarManager];
    [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserCarManager];
    
    
    //清空自动投标数据
    [[StorageManager sharedInstance] setUserConfigValue:[NSNull null] forKey:kCachedUserAuto];
    [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserAuto];
}

#pragma mark - Login Private Methods

// 重置self.loginUser 对象
- (void)resetUser:(ParentModel *)userModel {
    [[StorageManager sharedInstance] setUserConfigValue:userModel forKey:kCachedUserModel];
    self.user = [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserModel];
    //[[StorageManager sharedInstance] setUserConfigValue:[NSString trimString:userModel]
    // forKey:kCachedUserToken];
}
@end

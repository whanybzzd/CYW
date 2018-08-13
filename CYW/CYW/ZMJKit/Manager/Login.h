//
//  Login.h
//  SCSDTrade
//
//  Created by  YangShengchao on 14-2-25.
//  Copyright (c) 2014年  YangShengchao. All rights reserved.
//

#define kCachedUserModel        @"UserModel"
#define kCachedUserToken        @"UserToken"
#define kCachedUserCenterInfoModel  @"kCachedUserCenterInfoModel"
#define kCachedUserCarManager       @"kCachedUserCarManager"
#define kCachedUserAuthentication       @"kCachedUserAuthentication"
#define kCachedUserGuestPasswordOne     @"kCachedUserGuestPasswordOne"
#define kCachedUserGuestPasswordTwo     @"kCachedUserGuestPasswordTwo"
#define kCachedUserAuto                 @"kCachedUserAuto"
#import <UIKit/UIKit.h>
typedef void(^LoginSuccessed)(void);
typedef void(^LoginFailedWithError)(NSString *errorMessage);


@protocol LoginObserverDelegate;

@interface Login : NSObject

@property (nonatomic, strong) ParentModel *user;                      //当前登录用户对象
@property (nonatomic, strong) NSString *token;                      //用户登录有效期控制
@property (nonatomic, assign) BOOL isUserChanged;                   //当前用户对象是否更新过（用于监控user对象的变化）
@property (nonatomic, strong) NSMutableArray *loginObservers;
+ (Login *)sharedInstance;
- (void)refreshUserInfo;
//判断实名认证
- (void)refreshAuthentication;
- (void)refreshUserInfos;
#pragma mark - 用户登录/重新登录/退出登录

- (BOOL)isLogged;                   //判断是否登录了
- (void)clearLoginData;
- (void)autoTender;

- (void)resetUser:(ParentModel *)userModel;

- (void)logout;

@end

@protocol LoginObserverDelegate <NSObject>

@required
- (void)loginSucceededWithUserId:(NSString *)theUserId session:(NSString *)theSession;
- (void)loginFailedWithError:(NSString *)errorMessage;
- (void)loggedOut;

@end

//
//  AppDelegate+Addition.m
//  CYW
//
//  Created by jktz on 2018/5/23.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import "AppDelegate+Addition.h"
//分享
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
//腾讯开放平台(对应QQ和QQ空间)SDK文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <WXApi.h>
#import "JCAlertView.h"
#import <JANALYTICSService.h>
#import <Aspects/Aspects.h>
@implementation AppDelegate (Addition)

- (void)applicationAddition:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    
    [self applicationRegisterInfo:launchOptions];
    [self checkNewVersion];
     [self setupWithConfiguration];
}



//所有配置信息
- (void)applicationRegisterInfo:(NSDictionary *)launchOptions{
    
#pragma mark Mob.com的配置文件信息
    
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    
    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeWechat),
                                        @(SSDKPlatformTypeQQ)]
                             onImport:^(SSDKPlatformType platformType) {
                                 
                                 switch (platformType)
                                 {
                                     case SSDKPlatformTypeWechat:
                                         [ShareSDKConnector connectWeChat:[WXApi class]];
                                         break;
                                     case SSDKPlatformTypeQQ:
                                         [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                                         break;
                                     default:
                                         break;
                                 }
                             } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
                                 
                                 switch (platformType)
                                 {
                                     case SSDKPlatformTypeWechat:
                                         [appInfo SSDKSetupWeChatByAppId:@"wx2241d924b62b08a1"
                                                               appSecret:@"3bf7b3bcf4a76fc6679e7838f56539b9"];
                                         break;
                                     case SSDKPlatformTypeQQ:
                                         [appInfo SSDKSetupQQByAppId:@"1106279244"
                                                              appKey:@"mseY2rMc2MeRoCTK"
                                                            authType:SSDKAuthTypeBoth];
                                         break;
                                     default:
                                         break;
                                 }
                                 
                             }];
    
    
    
    //极光错误收集日志
    JANALYTICSLaunchConfig * config = [[JANALYTICSLaunchConfig alloc] init];
    config.appKey = @"f13ae961af08a448b36ceb4c";
    config.channel = @"App Store";
    [JANALYTICSService setupWithConfig:config];
    
    [JANALYTICSService crashLogON];//开始日志统计
    
}




#pragma mark 新版本检测
- (void)checkNewVersion{
    
    
    [AFNManager postDataWithAPI:@"versionRequestHandler"
                  withDictParam:@{@"type":@"ios"}
                  withModelName:@"VersionModel"
                        isModel:YES
               requestSuccessed:^(id responseObject) {
                   //NSLog(@"版本:%@",responseObject);
                   if ([NSObject isNotEmpty:responseObject]) {
                       
                       VersionModel *model=(VersionModel *)responseObject;
                       NSUInteger newVersionNumber=[NSString compareWithVersion:model.version];
                       NSUInteger localVersionNumber=[NSString compareWithVersion:VersionNumber];
                       
                       //如果本地版本小于服务器版本就提示
                       if (localVersionNumber<newVersionNumber) {
                           
                           BOOL isSkipTheVersion = [[NSUserDefaults standardUserDefaults] boolForKey:SkipVersion];
                           if ((! isSkipTheVersion)) {
                               NSString *title = [NSString stringWithFormat:@"有版本%@需要更新", model.version];
                               
                               
                               [JCAlertView showTwoButtonsWithTitle:title Message:model.content ButtonType:JCAlertViewButtonTypeCancel ButtonTitle:@"取消" Click:^{
                                   
                               } ButtonType:JCAlertViewButtonTypeDefault ButtonTitle:@"更新" Click:^{
                                   
                                   [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APP_StoreUrl]];
                                   exit(0);
                                   
                               }];
                           }
                       }
                   }
                   
               } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                   
               }];
    
}


#pragma mark- AOP编程思想
- (void)setupWithConfiguration{
    NSDictionary *configs = [self dictionaryFromUserStatisticsConfigPlist];
    for (NSString *className in configs) {
        Class clazz = NSClassFromString(className);
        NSDictionary *config = configs[className];
        if (config[@"GLLoggingTrackedEvents"]) {
            for (NSDictionary *event in config[@"GLLoggingTrackedEvents"]) {
                SEL selector = NSSelectorFromString(event[@"GLLoggingDidAppear"]);
                SEL selector1 = NSSelectorFromString(event[@"GLLoggingDidDisappear"]);
                [clazz aspect_hookSelector:selector
                               withOptions:AspectPositionAfter
                                usingBlock:^(id<AspectInfo> aspectInfo) {
                                    //NSLog(@"start");
                                    [JANALYTICSService startLogPageView:event[@"GLLoggingName"]];
                                    
                                } error:NULL];
                
                [clazz aspect_hookSelector:selector1
                               withOptions:AspectPositionAfter
                                usingBlock:^(id<AspectInfo> aspectInfo) {
                                    //NSLog(@"stop");
                                    [JANALYTICSService stopLogPageView:event[@"GLLoggingName"]];
                                    
                                } error:NULL];
            }
        }
    }
}



- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Assetslist" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}
@end

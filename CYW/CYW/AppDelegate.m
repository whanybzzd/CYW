//
//  AppDelegate.m
//  CYW
//
//  Created by ZMJ on 2018/5/16.
//  Copyright © 2018年 ZMJ. All rights reserved.
//

#import "AppDelegate.h"
#import "BaseTabBarController.h"
#import "MLNavigationController.h"
#import "DHGuidePageHUD.h"
#import "CYWloginViewController.h"
#import "CYWAssetsMessageViewController.h"

#import "CYWMoreForgetGesturesViewController.h"

#import "EaseStartView.h"
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#import "AppDelegate+Addition.h"
#endif
@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self applicationRegisterInfo:launchOptions];
    [self applicationAddition:application didFinishLaunchingWithOptions:launchOptions];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //判断用户是否登录
    if ([Login sharedInstance].isLogged) {
        
        [self setTabbarController];
    }else{
        NSString *swithch=[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"];
        if ([NSString isNotEmpty:swithch]&&1==[swithch integerValue]) {
            
            [self setUpGueTabbarController];//手势登录
            
        }else{
            
            [self setUpTabbarController];//setUpTabbarController
        }
        
    }
    [self setNavBarAppearence];
    
    //启动欢迎界面
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:Welcome] boolValue]) {
        [[NSURLCache sharedURLCache] removeAllCachedResponses];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"DEBUG"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self setStaticGuidePage];
    }else{
        
        //广告位
        //[EaseStartView startView];
    }
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"tabbarClick" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        self.tabBarController.selectedIndex=1;
    }];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"55555555555555555");
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"4444444444444");
    if ([NSString isEmpty:[[NSUserDefaults standardUserDefaults] objectForKey:@"share"]]) {
        
        [[Login sharedInstance] clearLoginData];//退到后台后  清空本地缓存信息   需要重新登录
        NSString *swithch=[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"];
        if ([NSString isNotEmpty:swithch]&&1==[swithch integerValue]) {
            
            [self setUpGueTabbarController];//手势登录
            
        }else{
            
            [self setUpTabbarController];
        }
    }
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"1111111111");
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"2222222222");
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"share"];//删除分享标记
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    [[Login sharedInstance] clearLoginData];//退到后台后  清空本地缓存信息   需要重新登录
    NSLog(@"333333333333");
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
}


- (UIViewController *)rootViewController{
    //return [[NSClassFromString(@"CHDUserVipOrderViewController") alloc] init];CYWAssetsRecordViewController
    //return [[UINavigationController alloc] initWithRootViewController:[[NSClassFromString(@"CYWAssetsRecordViewController") alloc] init]];
    NSArray *tabClassArray = @[@"CYWHomeViewController",
                               @"CYWProjectViewController",
                               @"CYWAssetsViewController",
                               @"CYWMoreViewController"];
    //icon
    NSArray *tabItemUnSeletedImageArray = @[@"首页",
                                            @"项目",
                                            @"资产",
                                            @"更多"];
    
    NSArray *tabItemSeletedImageArray = @[@"首页选中",
                                          @"项目选中",
                                          @"资产选中",
                                          @"更多选中"];
    //名字
    /*
     此处集中设置了controller的title
     请勿在相应的Controller中再次设置 self.title
     */
    NSArray *tabItemNamesArray = @[@"首页",
                                   @"项目",
                                   @"资产",
                                   @"更多"];
    
    
    self.viewControllers = [NSMutableArray array];
    for (int index = 0; index < tabClassArray.count; index++) {
        UIViewController *contentController = [[NSClassFromString(tabClassArray[index]) alloc] initWithNibName:nil bundle:nil];
        
        
        UITabBarItem *tabbaritem= [[UITabBarItem alloc]initWithTitle:tabItemNamesArray[index]
                                                               image:[[UIImage imageNamed:tabItemUnSeletedImageArray[index]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                                       selectedImage:[[UIImage imageNamed:tabItemSeletedImageArray[index]]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal ]];
        
        //修改选中的字体颜色
        [tabbaritem setTitleTextAttributes:[NSDictionary
                                            dictionaryWithObjectsAndKeys: [UIColor colorWithHexString:@"#f52735"],
                                            UITextAttributeTextColor, nil] forState:UIControlStateSelected];
        
        
        //以下两行代码是调整image和label的位置上左下右
        //tabbaritem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
        tabbaritem.imageInsets = UIEdgeInsetsMake(-1, 0, 1, 0);
        [tabbaritem setTitlePositionAdjustment:UIOffsetMake(0, -2)];
        
        //创建navigationController
        MLNavigationController *navigationController = [[MLNavigationController alloc] initWithRootViewController:contentController];
        navigationController.navigationController.navigationBar.translucent = YES;
        navigationController.tabBarItem = tabbaritem;
        [self.viewControllers addObject:navigationController];
    }
    self.tabBarController = [[BaseTabBarController alloc] init];
    //self.tabBarController.delegate = self;
    self.tabBarController.viewControllers = self.viewControllers;
    //self.tabBarController.tabBar.barStyle = UIBarStyleBlack;//去掉tabbar的边框线
    self.tabBarController.tabBar.backgroundImage = [UIImage imageNamed:@"矩形-5"];
    //self.tabBarController.tabBar.backgroundColor=[UIColor whiteColor];
    
    return self.tabBarController;
    
}

- (void)setNavBarAppearence
{
    
    //将状态栏字体改为白色（前提是要设置[View controller-based status bar appearance]为NO）
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    //改变Navibar的颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    //设置字体为白色
    [[UINavigationBar appearance] setTintColor:[UIColor colorWithHexString:@"#222222"]];
    // [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"bg_navigationbar"]
    //                                    forBarMetrics:UIBarMetricsDefault];
    //设置Title为白色,Title大小为18
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : [UIColor colorWithHexString:@"#222222"],
                                                            NSFontAttributeName : [UIFont boldSystemFontOfSize:18]}];
    //[[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];//隐藏底部线条
    
    //导航栏添加线条
    [[UINavigationBar appearance] setShadowImage:[UIImage createImageWithColor:[UIColor colorWithHexString:@"#efefef"]]];
    
    
    
}
- (void)setTabbarController{
    
    self.window.rootViewController=[self rootViewController];
    //[self setUpTabbarController];
}


- (void)setUpTabbarController{
    
    CYWloginViewController *loginViewController=[[CYWloginViewController alloc] init];
    MLNavigationController *nav=[[MLNavigationController alloc] initWithRootViewController:loginViewController];
    self.window.rootViewController=nav;
    
}


- (void)setUpGueTabbarController{
    
    CYWMoreForgetGesturesViewController *loginViewController=[[CYWMoreForgetGesturesViewController alloc] init];
    MLNavigationController *nav=[[MLNavigationController alloc] initWithRootViewController:loginViewController];
    self.window.rootViewController=nav;
}


#pragma mark - 设置APP静态图片引导页
- (void)setStaticGuidePage {
    NSArray *imageNameArray = nil;
    if (kDevice_Is_iPhoneX) {
        
        imageNameArray = @[@"引导页1",@"引导页2",@"引导页3",@"引导页4"];
    }else{
        
        imageNameArray = @[@"引导1",@"引导2",@"引导3",@"引导4"];
        
    }
    DHGuidePageHUD *guidePage = [[DHGuidePageHUD alloc] dh_initWithFrame:[UIScreen mainScreen].bounds imageNameArray:imageNameArray buttonIsHidden:YES];
    guidePage.slideInto = YES;
    [self.window addSubview:guidePage];
}
//所有配置信息
- (void)applicationRegisterInfo:(NSDictionary *)launchOptions{
    
    //#pragma mark 极光推送配置文件
    //极光推送配置
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert|UNAuthorizationOptionBadge|UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    } else  if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //       categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    } else {
        //categories    nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }
    
    
    //apsForProduction如果是开发  为NO   生产要改为  YES
    [JPUSHService setupWithOption:launchOptions appKey:@"f13ae961af08a448b36ceb4c" channel:@"App Store" apsForProduction:Production];
    
    //JPUsh自定义消息发送
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(networkDidReceiveMessage:) name:kJPFNetworkDidReceiveMessageNotification object:nil];
    
    if (launchOptions) {
        NSDictionary * remoteNotification = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        //这个判断是在程序没有运行的情况下收到通知，点击通知跳转页面
        if (remoteNotification) {
            NSLog(@"推送消息==== %@",remoteNotification);
            [self goToMssageViewControllerWith:remoteNotification];
        }
    }
    
}


//方法回调
- (void)networkDidReceiveMessage:(NSNotification *)notification {
    NSDictionary * userInfo = [notification userInfo];
    NSLog(@"自定义消息userInfo:%@",userInfo);
    
}


#pragma mark --通知处理
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken{
    
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error{
    
    NSLog(@"did fail To Register For Remote Notifications With Error");
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"userInfo--1:%@",userInfo);
    // 取得 APNs 标准信息内容，如果没需要可以不取
    //NSDictionary *aps = [userInfo valueForKey:@"aps"];
    //NSString *content = [aps valueForKey:@"alert"]; //推送显示的内容
    //NSInteger badge = [[aps valueForKey:@"badge"] integerValue];
    //NSString *sound = [aps valueForKey:@"sound"]; //播放的声音
    // 取得自定义字段内容，userInfo就是后台返回的JSON数据，是一个字典
    [JPUSHService handleRemoteNotification:userInfo];
    application.applicationIconBadgeNumber = 0;
    [self goToMssageViewControllerWith:userInfo];
}


- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    
    NSLog(@"userInfo--2:%@",userInfo);
    [self loadCacheNoticel:userInfo application:application];
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    
}

- (void)application:(UIApplication *)application
didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"userInfo-------");
    [JPUSHService showLocalNotificationAtFront:notification identifierKey:nil];
}

#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#pragma mark- JPUSHRegisterDelegate
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    NSDictionary * userInfo = notification.request.content.userInfo;
    NSLog(@"userInfo--3:%@",userInfo);
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService clearAllLocalNotifications];
        [JPUSHService setBadge:0];
        
        [AudioUtils playSoundType:SoundTypePush loopCount:0];
        
        [JPUSHService handleRemoteNotification:userInfo];
        // [self goToMssageViewControllerWith:userInfo];
        
    }
    completionHandler(UNNotificationPresentationOptionBadge|UNNotificationPresentationOptionSound|UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以设置
}

//处理消息通知
- (void)loadCacheNoticel:(NSDictionary *)userInfo application:(UIApplication *)application{
    
    [JPUSHService clearAllLocalNotifications];
    [JPUSHService setBadge:0];
    
    [AudioUtils playSoundType:SoundTypePush loopCount:0];
}
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    NSLog(@"userInfo--4:%@",userInfo);
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        
        [JPUSHService handleRemoteNotification:userInfo];
        [self goToMssageViewControllerWith:userInfo];
    }
    
    completionHandler();  // 系统要求执行这个方法
}
#endif
- (void)goToMssageViewControllerWith:(NSDictionary*)msgDic{
    //NSLog(@"我要跳转界面了：%@",msgDic);
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    UIViewController *currentVC = nil;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
        //有模态情况下的根视图
        currentVC = [topVC.childViewControllers lastObject];
    } else {
        //获取非模态情况下的根视图 CYWJpushViewController
        if (![[BaseViewController currentVC] isKindOfClass:[CYWAssetsMessageViewController class]]) {
            
            CYWAssetsMessageViewController *message = [[CYWAssetsMessageViewController alloc] init];
            message.hidesBottomBarWhenPushed = YES;
            [currentVC.navigationController pushViewController:message animated:YES];
        }
    }
    
}

@end

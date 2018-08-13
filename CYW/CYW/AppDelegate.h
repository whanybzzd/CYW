//
//  AppDelegate.h
//  CYW
//
//  Created by ZMJ on 2018/5/16.
//  Copyright © 2018年 ZMJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class BaseTabBarController;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) BaseTabBarController *tabBarController;
@property (nonatomic, strong) NSMutableArray *viewControllers;

- (void)setTabbarController;
- (void)setUpTabbarController;
- (void)setUpGueTabbarController;


@end


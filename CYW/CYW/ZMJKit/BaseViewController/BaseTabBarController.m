//
//  BaseTabBarController.m
//  ZXVideoPlayer
//
//  Created by Shawn on 16/4/29.
//  Copyright © 2016年 Shawn. All rights reserved.
//

#import "BaseTabBarController.h"

@interface BaseTabBarController ()

@end

@implementation BaseTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
   
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    //UINavigationController *nav = self.viewControllers[0];
    //if ([nav.topViewController isKindOfClass://[CHDHomeParadiseViewController class]]) {
    //    return UIInterfaceOrientationMaskAllButUpsideDown;
    //}//UIInterfaceOrientationMaskPortrait  UIInterfaceOrientationMaskAllButUpsideDown
    
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end

//
//  CYWPlayVideoViewController.m
//  CYW
//
//  Created by jktz on 2018/7/23.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import "CYWPlayVideoViewController.h"
#import "ZXVideoPlayerController.h"
#import "ZXVideo.h"
@interface CYWPlayVideoViewController ()
@property (nonatomic, strong) ZXVideoPlayerController *videoController;
@end

@implementation CYWPlayVideoViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)playVideo
{
    if (!self.videoController) {
        self.videoController = [[ZXVideoPlayerController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        
        __weak typeof(self) weakSelf = self;
        self.videoController.videoPlayerGoBackBlock = ^{
            __strong typeof(self) strongSelf = weakSelf;
            
            [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
            
            [strongSelf.navigationController popViewControllerAnimated:YES];
            
            [[NSUserDefaults standardUserDefaults] setObject:@0 forKey:@"ZXVideoPlayer_DidLockScreen"];
            
            strongSelf.videoController = nil;
            NSLog(@"返回回去");
        };
        
        self.videoController.videoPlayerWillChangeToOriginalScreenModeBlock = ^(){
            NSLog(@"切换为竖屏模式");
        };
        self.videoController.videoPlayerWillChangeToFullScreenModeBlock = ^(){
            NSLog(@"切换为全屏模式");
        };
        
        [self.videoController showInView:self.view];
    }
    
    self.videoController.video = self.video;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self playVideo];
}
- (void)dealloc{
    
    postN(@"backButtonClick");
    NSLog(@"%@ dealloc",self.class);
}
@end

//
//  CYWBannerDetailViewController.m
//  CYW
//
//  Created by jktz on 2017/10/10.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWBannerDetailViewController.h"
#import <NJKWebViewProgress/NJKWebViewProgressView.h>
#import <NJKWebViewProgress/NJKWebViewProgress.h>
@interface CYWBannerDetailViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate,UIAlertViewDelegate>
{
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property (nonatomic, retain) UIWebView *webView;
@end

@implementation CYWBannerDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=self.params[@"title"];
    [self webView];
}

/**
 加载WebView
 */

- (UIWebView *)webView{
    
    if (!_webView) {
        
        
        _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-getRectNavAndStatusHight-40)];
        _webView.scalesPageToFit = YES;
        [self.view addSubview:_webView];
        
        
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _webView.delegate = _progressProxy;
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
        
        
        CGFloat progressBarHeight = 2.f;
        CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        
        NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",self.params[@"url"]]];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
        [_webView loadRequest:request];//加载
    }
    return _webView;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [_progressView removeFromSuperview];
}
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    
    [_progressView setProgress:progress animated:YES];
    
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self.navigationController.navigationBar addSubview:_progressView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [_progressView removeFromSuperview];
}

- (void)dealloc{
    NSLog(@"活动banner销毁");
}
@end

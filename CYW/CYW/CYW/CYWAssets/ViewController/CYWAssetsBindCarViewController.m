//
//  CYWAssetsBindCarViewController.m
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsBindCarViewController.h"
#import "CYWMoreUserCenterAuthenticationViewModel.h"
#import "CYWMoreAutomaticViewModel.h"
#import "LoginViewModel.h"
#import <NJKWebViewProgress/NJKWebViewProgressView.h>
#import <NJKWebViewProgress/NJKWebViewProgress.h>
@interface CYWAssetsBindCarViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
{
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property (nonatomic, retain) CYWMoreUserCenterAuthenticationViewModel *authViewModel;
@property (nonatomic, retain) CYWMoreAutomaticViewModel *autoViewModel;
@property (nonatomic, retain) LoginViewModel *loginViewModel;


@property (nonatomic, retain) UIWebView *webView;
@end
@implementation CYWAssetsBindCarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.authViewModel=[[CYWMoreUserCenterAuthenticationViewModel alloc] init];
    self.autoViewModel=[[CYWMoreAutomaticViewModel alloc] init];
    self.loginViewModel=[[LoginViewModel alloc] init];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=self.params[@"title"];
    [self webView];
}

/**
 加载WebView
 */

- (UIWebView *)webView{
    
    if (!_webView) {
        
        
        _webView=[[UIWebView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-getRectNavAndStatusHight)];
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
        //            NSURL *url = [[NSURL alloc]initWithString:[NSString stringWithFormat:@"%@",self.params[@"url"]]];
        //            NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: url];
        //            [_webView loadRequest:request];//加载
        [_webView loadHTMLString:self.params[@"url"] baseURL:nil];
        
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

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString * urlString = [NSString stringWithFormat:@"%@",request.mainDocumentURL];
    
    NSRange range = [urlString rangeOfString:@"mobile/user/userBill"];
    NSRange rangeError = [urlString rangeOfString:@"mobile/user/center"];
    NSString *errorString = @"";
    if (rangeError.location != NSNotFound) {
        [webView stopLoading];
        
        if ([self.navigationItem.title isEqualToString:@"提现"] ) {
            NSArray *errorArray = [urlString componentsSeparatedByString:@"/"];
            NSString *errorStr = [errorArray lastObject];
            errorString = [NSString decodeString:errorStr];
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@失败",self.navigationItem.title] message:errorString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        if ([self.navigationItem.title isEqualToString:@"投资"]) {
            errorString = @"投资失败";
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@失败",self.navigationItem.title] message:errorString delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alertView show];
        }
        if ([self.navigationItem.title isEqualToString:@"实名认证"]) {
            
            @weakify(self)
            [[self.authViewModel.refreshRealCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                
                
                
                UIAlertView *alertView=[UIAlertView bk_alertViewWithTitle:@"实名认证成功" message:errorString];
                [alertView bk_addButtonWithTitle:@"确定" handler:^{
                    @strongify(self)
                    [self backViewControllerIndex:0];
                }];
                [alertView show];
                
            } error:^(NSError * _Nullable error) {
                
                UIAlertView *alertView=[UIAlertView bk_alertViewWithTitle:@"实名认证失败" message:errorString];
                [alertView bk_addButtonWithTitle:@"确定" handler:^{
                    @strongify(self)
                    [self backViewControllerIndex:0];
                }];
                [alertView show];
                
                
            }];
            
            
            
        }
        
        
    }
    NSRange range1 = [urlString rangeOfString:@"trusteeship_return_web"];
    NSRange range2 = [urlString rangeOfString:@"trusteeship_return_s2s"];
    if (range.location != NSNotFound) {
        if (range1.location == NSNotFound &&range2.location == NSNotFound) {
            [webView stopLoading];
            [self showHUDLoading:nil];
            if ([self.navigationItem.title isEqualToString:@"自动投标"]) {
                [[self.autoViewModel.autoSuccessCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                    
                    [self showResultThenBack:@"自动投标操作成功"];
                    
                } error:^(NSError * _Nullable error) {
                    
                    [self showResultThenBack:@"自动投标操作失败"];
                }];
                
                
            }else if ([self.navigationItem.title isEqualToString:@"实名认证"]) {
                @weakify(self)
                [[self.authViewModel.refreshRealCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                    
                    @strongify(self)
                    [self showResultThenHide:@"实名认证成功"];
                    [self backViewControllerIndex:0];
                    
                } error:^(NSError * _Nullable error) {
                    
                    @strongify(self)
                    [self showResultThenHide:@"实名认证失败"];
                    [self backViewControllerIndex:0];
                }];
            }else if ([self.navigationItem.title isEqualToString:@"投资"]) {
                
                WeakSelfType blockSelf=self;
                [self showResultThenHide:@"投资操作成功"];
                [self bk_performBlock:^(id obj) {
                    [[Login sharedInstance] refreshUserInfo];
                    [blockSelf backViewControllerIndex:0];
                    
                } afterDelay:1.5];
                
            }else{
                @weakify(self)
                [[self.loginViewModel.loginViewCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                    
                    @strongify(self)
                    NSString *str=  [NSString stringWithFormat:@"%@操作成功",self.navigationItem.title];
                    [self showResultThenBack:str];
                    
                } error:^(NSError * _Nullable error) {
                    
                    
                }];
            }
            
            
        }
    }
    
    return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    [self backViewController];
}


//- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
//    NSString * urlString = [NSString stringWithFormat:@"%@",request.mainDocumentURL];
//
//    NSRange range = [urlString rangeOfString:@"mobile/user/userBill"];
//    NSRange rangeError = [urlString rangeOfString:@"mobile/user/center"];
//    NSString *errorString = @"";
//    if (rangeError.location != NSNotFound) {
//        [webView stopLoading];
//
//        if ([self.navigationItem.title isEqualToString:@"提现"] ||
//            [self.navigationItem.title isEqualToString:@"实名认证"]||
//            [self.navigationItem.title isEqualToString:@"充值"]) {
//            NSArray *errorArray = [urlString componentsSeparatedByString:@"/"];
//            NSString *errorStr = [errorArray lastObject];
//            errorString = [NSString decodeString:errorStr];
//
//        }
//        if ([self.navigationItem.title isEqualToString:@"投资"]) {
//            errorString = @"投资失败";
//
//        }
//        @weakify(self)
//        UIAlertView *alertView=[[UIAlertView alloc] bk_initWithTitle:[NSString stringWithFormat:@"%@失败",self.navigationItem.title] message:errorString];
//        [alertView bk_setCancelButtonWithTitle:@"确定" handler:^{
//            @strongify(self)
//            [self backViewController];
//        }];
//        [alertView show];
//
//    }
//    NSRange range1 = [urlString rangeOfString:@"trusteeship_return_web"];
//    NSRange range2 = [urlString rangeOfString:@"trusteeship_return_s2s"];
//    if (range.location != NSNotFound) {
//        if (range1.location == NSNotFound &&range2.location == NSNotFound) {
//            [webView stopLoading];
//            [self showHUDLoading:nil];
//            if ([self.navigationItem.title isEqualToString:@"自动投标"]) {
//
//                [[self.autoViewModel.autoSuccessCommand execute:nil] subscribeNext:^(id  _Nullable x) {
//
//                    [self showResultThenBack:@"自动投标操作成功"];
//
//                } error:^(NSError * _Nullable error) {
//
//                    [self showResultThenBack:@"自动投标操作失败"];
//                }];
//
//
//
//            }else if ([self.navigationItem.title isEqualToString:@"实名认证"]) {
//
//                @weakify(self)
//                [[self.authViewModel.refreshRealCommand execute:nil] subscribeNext:^(id  _Nullable x) {
//
//                    @strongify(self)
//                    [self showResultThenHide:@"实名认证成功"];
//                    [self backViewControllerIndex:0];
//
//                } error:^(NSError * _Nullable error) {
//
//                    @strongify(self)
//                    [self showResultThenHide:@"实名认证失败"];
//                    [self backViewControllerIndex:0];
//                }];
//
//            }else if ([self.navigationItem.title isEqualToString:@"投资"]) {
//
//                WeakSelfType blockSelf=self;
//                [self showResultThenHide:@"投资操作成功"];
//                [self bk_performBlock:^(id obj) {
//                    [[Login sharedInstance] refreshUserInfo];
//                    [blockSelf backViewControllerIndex:0];
//
//                } afterDelay:1.5];
//
//
//            }else{
//
//
//                @weakify(self)
//                [[self.loginViewModel.loginViewCommand execute:nil] subscribeNext:^(id  _Nullable x) {
//
//                    @strongify(self)
//                    NSString *str=  [NSString stringWithFormat:@"%@操作成功",self.navigationItem.title];
//                    [self showResultThenBack:str];
//
//                } error:^(NSError * _Nullable error) {
//
//
//                }];
//
//
//            }
//
//
//        }
//    }
//
//    return YES;
//}


@end

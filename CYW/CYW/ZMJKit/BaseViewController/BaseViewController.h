//
//  BaseViewController.h
//  xcode6
//
//  Created by ZMJ on 15/3/10.
//  Copyright (c) 2015年 MJShareDemo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#define kHudIntervalNormal 2.0f
@interface BaseViewController : UIViewController<UITextFieldDelegate,UITextViewDelegate>
@property (nonatomic, strong) NSDictionary *params;//Toggle parameters passed by the view
@property (nonatomic, assign) BOOL isAppered;




#pragma mark - push
- (UIViewController *)pushViewController:(NSString *)className;
- (UIViewController *)pushViewController:(NSString *)className withParams:(NSDictionary *)paramsDict;

//go back to the next,up to the root
- (UIViewController *)popViewController;
//go back to the next,up to the dismiss
- (UIViewController *)backViewController;
//returns to the specified directory
- (UIViewController *)backViewControllerIndex:(NSInteger)index;
//return to root
- (UIViewController *)popToRootViewController;

#pragma mark - present
- (UIViewController *)presentingViewController:(NSString *)className;
- (UIViewController *)presentingViewController:(NSString *)className withParams:(NSDictionary *)paramsDict;
- (void)dismissPrestedViewController;
- (void)dismissPrestingViewController;

#pragma mark show&hide
- (MBProgressHUD *)showHUDLoading:(NSString *)hintString;
- (void)hideHUDLoading;
- (void)showResultThenHide:(NSString *)resultString;
- (void)showResultThenBack:(NSString *)resultString;
- (void)showResultThenPop:(NSString *)resultString;

#pragma mark Cache
- (id)cachedObjectForKey:(NSString *)cachedKey;
- (id)cachedObjectForKey:(NSString *)cachedKey withSuffix:(NSString *)suffix;
- (void)saveObject:(id)object forKey:(NSString *)cachedKey;
- (void)saveObject:(id)object forKey:(NSString *)cachedKey withSuffix:(NSString *)suffix;
- (NSMutableArray *)commonLoadCaches:(NSString *)cacheKey;          //Read cache data

#pragma mark - network states
- (BOOL)netWorkState;

#pragma mark - Business editor
- (void)hideKeyboard;
#pragma mark -- 开线程来下载视频
- (void)downloadMove;

#pragma mark -- alertView
- (UIAlertView *)alertViewTitle:(NSString *)titleMessage withMessage:(NSString *)alertMessageString;

#pragma mark -- gets the viewcontroller of the current screen display
+ (UIViewController *)currentVC;
@end

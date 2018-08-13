//
//  BaseViewController.m
//  xcode6
//
//  Created by ZMJ on 15/3/10.
//  Copyright (c) 2015年 MJShareDemo. All rights reserved.
//
NSString *const JDStatusBarStyleError   = @"JDStatusBarStyleError";
NSString *const JDNotificationText      =@"网络错误";
#import "BaseViewController.h"
#import "BaseTabBarController.h"
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
@interface BaseViewController ()
@property (nonatomic, strong) UIStoryboard *storyboard;
@property (nonatomic, assign) NSInteger notWorkingState;//network states
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, assign) BackType backType;    //The return type is the upper or the sidebar. The default is pop on the next level
@end

@implementation BaseViewController
@synthesize storyboard;
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self AFNManagerNetWorking];
    self.view.layer.masksToBounds = YES;//Solves the delay when custom navigation bars move out

    [self configBackButton];
}

- (void)AFNManagerNetWorking{
    
    WeakSelfType blockSelf=self;
    AFNetworkReachabilityManager *mgr = [AFNetworkReachabilityManager sharedManager];
    [mgr setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"network state:%zd",status);
        blockSelf.notWorkingState=status;
    }];
    
    // 3.start monitoring
    [mgr startMonitoring];
}

- (BOOL)netWorkState{
    
    if (self.notWorkingState>0) {
        
        return YES;
    }
    [JDStatusBarNotification showWithStatus:JDNotificationText
                               dismissAfter:2.0
                                  styleName:JDStatusBarStyleError];
    return NO;
}

- (UIViewController *)pushViewController:(NSString *)className{
    return  [self pushViewController:className withParams:nil];
}

- (UIViewController *)pushViewController:(NSString *)className withParams:(NSDictionary *)paramsDict{
    [self hideKeyboard];
    UIViewController *newViewController=[self createViewController:className];
    NSMutableDictionary *mutableDictionary=[paramsDict mutableCopy];
    if ([newViewController isKindOfClass:[BaseViewController class]]) {
        [(BaseViewController *)newViewController setParams:mutableDictionary];
    }
    
    
    //Uniform return button
    newViewController.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"button_arrow_left"] style:UIBarButtonItemStylePlain target:self action:@selector(backItemClick)];
    [newViewController.navigationController.navigationBar setBarTintColor:[UIColor redColor]];
    [self.navigationController pushViewController:newViewController animated:YES];
    
    
    
    
    return newViewController;
}
- (void)backItemClick{
    
    [self.navigationController popViewControllerAnimated:YES];
}
- (UIViewController *)createViewController:(NSString *)className{
    UIViewController *pushViewController=nil;
    //check for layout
    if (!pushViewController) {
        @try {
            pushViewController=[self.storyboard instantiateViewControllerWithIdentifier:className];
        }
        @catch (NSException *exception) {
            NSLog(@"xib[%@]no existence",className);
        }
        @finally {
            
        }
    }
    //Check to see if there are any class files that are compatible with Xib
    if (!pushViewController) {
        pushViewController=[[NSClassFromString(className) alloc]initWithNibName:nil bundle:nil];
    }
    NSLog(@"enter the page:%@",className);
    pushViewController.hidesBottomBarWhenPushed=YES;
    return pushViewController;
}
//返回上一层,最多到根
- (UIViewController *)popViewController{
    [self hideKeyboard];
    if(self.navigationController){
        //得到视图下标
        NSInteger index=[self.navigationController.viewControllers indexOfObject:self];
        UIViewController *newTopViewController=[self.navigationController.viewControllers objectAtIndex:MAX(index-1, 0)];
        [self.navigationController popViewControllerAnimated:YES];
        return newTopViewController;
    }else{
        [self dismissPrestingViewController];
        return self.presentingViewController;
    }
}

//返回到上一层，知道dismiss
- (UIViewController *)backViewController{
    [self hideKeyboard];
    if (self.navigationController) {
        NSInteger index=[self.navigationController.viewControllers indexOfObject:self];
        if (index>0) {  //不是root，就返回到上一级
            UIViewController *presentViewController=[self.navigationController.viewControllers objectAtIndex:MAX(index-1, 0)];
            [self.navigationController popViewControllerAnimated:YES];
            return presentViewController;
        }else{
            [self dismissPrestingViewController];
            return self.presentingViewController;
        }
    }else{
        [self dismissPrestingViewController];
        return  self.presentingViewController;
    }
}

//返回到制定的目录
- (UIViewController *)backViewControllerIndex:(NSInteger)index{
    if (self.navigationController) {
        
        UIViewController *backViewController=(UIViewController *)[self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:index] animated:YES];
        return backViewController;
    }else{
        return self.backViewController;
    }
}
//返回到顶层
- (UIViewController *)popToRootViewController{
    if(self.navigationController){
        UIViewController *newTopViewController=[self.navigationController.viewControllers objectAtIndex:0];
        [self.navigationController popToViewController:newTopViewController animated:YES];
        return newTopViewController;
    }else{
        return nil;
    }
}


#pragma mark - presentViewController

- (UIViewController *)presentingViewController:(NSString *)className{
    return [self presentingViewController:className withParams:nil];
}

- (UIViewController *)presentingViewController:(NSString *)className withParams:(NSDictionary *)paramsDict{
    [self hideKeyboard];
    UIViewController *presentViewController=[self createViewController:className];
    NSMutableDictionary *mutalbleDictionary=[NSMutableDictionary dictionaryWithDictionary:paramsDict];
    if ([presentViewController isKindOfClass:[BaseViewController class]]) {
        [(BaseViewController *)presentViewController setParams:[NSDictionary dictionaryWithDictionary:mutalbleDictionary]];
    }
    UINavigationController *navigationController=[[UINavigationController alloc] initWithRootViewController:presentViewController];
    [self.navigationController presentViewController:navigationController animated:YES completion:NULL];
    return navigationController;
}

- (void)dismissPrestedViewController{
    if (self.presentedViewController) {
        [self.presentedViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}

- (void)dismissPrestingViewController{
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
    }
}
//在self上一级viewController调用dismiss（通常情况下使用该方法）
- (void)dismissOnPresentingViewController {
    if (self.presentingViewController) {
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}
#pragma mark - show &hide
- (void)hideHUDLoading{
    [self hideHUDOnView:self.view];
}

- (void)showResultThenHide:(NSString *)resultString{
    [self showResultThenHide:resultString afterDelay:kHudIntervalNormal onView:self.view];
}


- (void)showResultThenBack:(NSString *)resultString{
    
    [self showResultThenHide:resultString afterDelay:kHudIntervalNormal onView:self.view];
    [self performSelector:@selector(backViewController) withObject:nil afterDelay:kHudIntervalNormal];
}
//延迟隐藏self.view上的hud,返回上一级
- (void)showResultThenPop:(NSString *)resultString {
    [self showResultThenHide:resultString afterDelay:kHudIntervalNormal onView:self.view];
    [self performSelector:@selector(popViewController) withObject:nil afterDelay:kHudIntervalNormal];
}
//隐藏hud的通用方法
- (void)hideHUDOnView:(UIView *)view{
    MBProgressHUD *hud=[MBProgressHUD HUDForView:view];
    [hud hide:YES];
}
//延迟隐藏view上hud的通用方法
- (void)showResultThenHide:(NSString *)resultString afterDelay:(NSTimeInterval)delay onView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.labelText = resultString;
    hud.mode = MBProgressHUDModeText;
    [hud show:YES];
    [hud hide:YES afterDelay:delay];
}
//在self.view上显示hud
- (MBProgressHUD *)showHUDLoading:(NSString *)hintString {
    return [self showHUDLoading:hintString onView:self.view];
}


//显示hud的通用方法
- (MBProgressHUD *)showHUDLoading:(NSString *)hintString onView:(UIView *)view {
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (hud) {
        [hud show:YES];
    }
    else {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.labelText = hintString;
    hud.mode = MBProgressHUDModeIndeterminate;
    return hud;
}
#pragma mark - 私有方法

/**
 *  设置返回按钮（左上角）
 */
- (void)configBackButton {
    if ([NSObject isNotEmpty:self.params[kParamBackType]]) {
        self.backType = [self.params[kParamBackType] intValue];
        
        NSLog(@"跳转类型:%@",self.params[kParamBackType]);
        if (self.backType == BackTypeBack) { //设置返回按钮(默认)
            self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(2, 22, 44, 40)];
            self.backButton.contentEdgeInsets = UIEdgeInsetsMake(4, 0, 4, 12);
            self.backButton.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
            self.backButton.backgroundColor = [UIColor clearColor];
            [self.backButton setTitle:nil forState:UIControlStateNormal];
            [self.backButton setImage:[UIImage imageNamed:@"button_arrow_left"] forState:UIControlStateNormal];
            
            [self.backButton addTarget:self action:@selector(popButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            self.navigationItem.leftBarButtonItems = [self customBarButtonOnNavigationBar:self.backButton withFixedSpaceWidth:-10];
            
            
            
        }
        else if (self.backType == BackTypeSliding) { //设置侧边栏按钮
            UIButton *slideButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 40)];
            [slideButton addTarget:self action:@selector(leftSlideButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [slideButton setImageEdgeInsets:UIEdgeInsetsMake(4, -4, 4, 16)];
            [slideButton setImage:[UIImage imageNamed:@"button_leftslide"] forState:UIControlStateNormal];
            slideButton.tintColor = [UIColor blackColor];
            self.navigationItem.hidesBackButton = YES;
            self.navigationItem.leftBarButtonItems = [self customBarButtonOnNavigationBar:slideButton withFixedSpaceWidth:-10];
            
        }
        else if (self.backType == BackTypeDismiss) {//设置dismiss按钮
            UIButton *dismissButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 40)];
            [dismissButton addTarget:self action:@selector(dismissOnPresentingViewController) forControlEvents:UIControlEventTouchUpInside];
            [dismissButton setImageEdgeInsets:UIEdgeInsetsMake(4, -4, 4, 16)];
            [dismissButton setImage:[UIImage imageNamed:@"button_arrow_left"] forState:UIControlStateNormal];
            dismissButton.tintColor = [UIColor blackColor];
            self.navigationItem.leftBarButtonItems = [self customBarButtonOnNavigationBar:dismissButton withFixedSpaceWidth:-10];
        }
        else {
            NSAssert(YES, @"self.backType = [%zd] 不支持该类型！", self.backType);
        }
    }
}



/**
 返回自定义的在navigationBar上的按钮
 
 @param customButton customButton
 @param width -10
 @return NSArray
 */
- (NSArray *)customBarButtonOnNavigationBar:(UIView *)customButton withFixedSpaceWidth:(NSInteger)width {
    UIBarButtonItem *leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customButton];
    UIBarButtonItem *flexSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                target:self
                                                                                action:nil];
    flexSpacer.width = width;
    return [NSArray arrayWithObjects:flexSpacer, leftButtonItem, nil];
}



/**
 返回上一级
 
 @param sender 按钮
 */
- (void)popButtonClicked:(id)sender {
    [self popViewController];
}


/**
 Click on the sidebar
 
 @param sender button
 */
- (void)leftSlideButtonClicked:(id)sender {
    [self hideKeyboard];
}


#pragma mark - 业务编辑
- (void)hideKeyboard {
    [self.view endEditing:YES];
}
- (BOOL)showCustomTitleBarView {
    return NO;
}

#pragma mark cache data
- (NSString *)cacheFilePath:(NSString *)suffix {
    NSString *fileName = [NSString stringWithFormat:@"%@%@.dat",
                          NSStringFromClass(self.class),
                          [NSString isEmpty:suffix] ? @"" :[NSString stringWithFormat:@"_%@",suffix]]; //Cache file name
    return [[[StorageManager sharedInstance] directoryPathOfLibraryCachesCommon] stringByAppendingPathComponent:fileName];
}



- (id)cachedObjectForKey:(NSString *)cachedKey {
    return [self cachedObjectForKey:cachedKey withSuffix:nil];
}

- (id)cachedObjectForKey:(NSString *)cachedKey withSuffix:(NSString *)suffix {
    NSDictionary *cacheInfo = [[StorageManager sharedInstance] unarchiveDictionaryFromFilePath:[self cacheFilePath:suffix]];
    if ([cacheInfo objectForKey:cachedKey]) {
        return cacheInfo[cachedKey];
    }
    else {
        return nil;
    }
}

- (void)saveObject:(id)object forKey:(NSString *)cachedKey{
    [self saveObject:object forKey:cachedKey withSuffix:nil];
}

- (void)saveObject:(id)object forKey:(NSString *)cachedKey withSuffix:(NSString *)suffix{
    //判断是否为空
    if ([NSString isEmpty:cachedKey]) {
        return;
    }
    @try {
        BOOL isSuccess = [[StorageManager sharedInstance] archiveDictionary:@{ cachedKey : object }
                                                                 toFilePath:[self cacheFilePath:suffix]
                                                                  overwrite:NO];
        if (isSuccess) {
            NSLog(@"缓存成功！");
        }
        else {
            NSLog(@"缓存失败！");
        }
    }
    @catch (NSException *exception) {
        NSLog(@"数组缓存到本地失败:%@",exception);
    }
    @finally {
    }
}

//加载本地缓存的数据
- (NSMutableArray *)commonLoadCaches:(NSString *)cacheKey{
    NSMutableArray *cacheArray = [NSMutableArray array];
    NSArray *tempArray = [self cachedObjectForKey:cacheKey];
    if ([tempArray isKindOfClass:[NSArray class]] && [NSArray isNotEmpty:tempArray]) {
        [cacheArray addObjectsFromArray:tempArray];
    }
    return cacheArray;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self hideKeyboard];
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [self hideKeyboard];
        return NO;
    }
    
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField.maxLength > 0) {
        NSMutableString *newText = [textField.text mutableCopy];
        [newText replaceCharactersInRange:range withString:string]; //兼容从中间插入内容的情况！
        return [newText length] <= textField.maxLength;
    }
    return YES;
}


- (void)textFieldChanged:(NSNotification *)note {
    UITextField *textField = (UITextField *)note.object;
    if (![textField isKindOfClass:[UITextField class]]) {
        return;
    }
}



- (void)downloadMove{
    
    //开新的线程
    dispatch_queue_t  Queue=dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(Queue, ^{
        
        //通知主线程更新界面
        dispatch_async(dispatch_get_main_queue(),^{
            
            
            
            
        });
        
    });
}

- (UIAlertView *)alertViewTitle:(NSString *)titleMessage withMessage:(NSString *)alertMessageString{
    UIAlertView *alertView=[UIAlertView bk_alertViewWithTitle:titleMessage message:alertMessageString];
    [alertView bk_setCancelButtonWithTitle:@"确定" handler:^{
        
    }];
    [alertView show];
    return alertView;
}

+ (UIViewController *)currentVC{

    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    UIViewController *currentVC = nil;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
        NSLog(@"数组:%@", topVC.childViewControllers);
        NSLog(@"模态出最外层的视图%@", [topVC.childViewControllers lastObject]);
        //有模态情况下的根视图
        currentVC = [topVC.childViewControllers lastObject];
    } else {
        //获取非模态情况下的根视图
        currentVC = [self getCurrentVC];
    
    }
    return currentVC;
}


//获取当前屏幕显示的viewcontroller
+ (UIViewController *)getCurrentVC {
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    /*
     *  在此判断返回的视图是不是你的根视图--我的根视图是tabbar
     */
    if ([result isKindOfClass:[BaseTabBarController class]]) {
        BaseTabBarController *mainTabBarVC = (BaseTabBarController *)result;
        result = [mainTabBarVC selectedViewController];
        result = [result.childViewControllers lastObject];
       
    }
    
    return result;
}


@end

//
//  UIView+Addition.m
//  GeneralFramework
//
//  Created by ZMJ on 15/4/19.
//  Copyright (c) 2015年 ZMJ. All rights reserved.
//
#import "UIView+Addition.h"
#import <MobileCoreServices/MobileCoreServices.h>
static CGRect oldframe;
#define kTagLineView 1007
@implementation UIView (Addition)

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



+ (void)makeCircleForImageView:(UIView *)imageView{
    imageView.layer.cornerRadius = imageView.bounds.size.width / 2;
    imageView.layer.masksToBounds = YES;
}

+ (PQActionSheet *)showImagePickerCirImageDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)delegate onViewController:(UIViewController *)viewController{

    PQActionSheet *actionSheet = [[PQActionSheet alloc]initWithTitle:nil clickedAtIndex:^(NSInteger index) {
        
        if (0==index) {
            //拍照
            if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypeCamera;
                if ([self isFrontCameraAvailable]) {
                    controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
                }
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = delegate;
                [viewController presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
        }
        else if (1==index){
            //手机选择
            if ([self isPhotoLibraryAvailable]) {
                UIImagePickerController *controller = [[UIImagePickerController alloc] init];
                controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
                [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
                controller.mediaTypes = mediaTypes;
                controller.delegate = delegate;
                [viewController presentViewController:controller
                                   animated:YES
                                 completion:^(void){
                                     NSLog(@"Picker View Controller is presented");
                                 }];
            }
        }
        
        
    } cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择",nil];
    [actionSheet show];
    return actionSheet;
    
}
#pragma mark camera utility
+ (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

+ (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

+ (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

+ (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
+ (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
+ (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}


+ (void)showImagePickerZYQActionSheetWithDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate>)delegate allowsEditing:(BOOL)allowsEditing singleImage:(BOOL)singleImage numberOfSelection:(NSInteger)numberOfSelection onViewController:(UIViewController *)viewController{



    UIActionSheet *sheetView=[UIActionSheet bk_actionSheetWithTitle:nil];
    [sheetView bk_addButtonWithTitle:@"拍照" handler:^{

        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ( ! [UIImagePickerController isSourceTypeAvailable:sourceType]) {
            [UIView showResultThenHide:@"您的设备无法通过此方式获取照片"];
            return;
        }
        else {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = delegate;
            imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagePickerController.allowsEditing = allowsEditing;
            imagePickerController.sourceType = sourceType;
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
        }
    }];
    [sheetView bk_addButtonWithTitle:@"从手机中选择" handler:^{

        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ( ! [UIImagePickerController isSourceTypeAvailable:sourceType]) {
            [UIView showResultThenHide:@"您的设备无法通过此方式获取照片"];
            return;
        }
        else {
            if (singleImage) {//选择相册里单张图片
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = delegate;
                imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                imagePickerController.allowsEditing = allowsEditing;
                imagePickerController.sourceType = sourceType;
                [viewController presentViewController:imagePickerController animated:YES completion:nil];
            }
            else {//多张图片
                ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
                picker.delegate = delegate;
                picker.maximumNumberOfSelection = numberOfSelection;
                picker.assetsFilter = [ALAssetsFilter allPhotos];
                picker.showEmptyGroups = NO;
                picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                        NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                        return duration >= 5;
                    } else {
                        return YES;
                    }
                }];
                [viewController presentViewController:picker animated:YES completion:NULL];
            }
        }

    }];
    [sheetView bk_setCancelButtonWithTitle:@"取消" handler:^{


    }];
    [sheetView showInView:viewController.view];

    
    
}


+ (void)showImagePickerZYQActionSheetWithDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate>)delegate allowsEditing:(BOOL)allowsEditing singleImage:(BOOL)singleImage numberOfSelection:(NSInteger)numberOfSelection onViewController:(UIViewController *)viewController sign:(BOOL)sign{
    
    if (!sign) {//相册选中
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        if ( ! [UIImagePickerController isSourceTypeAvailable:sourceType]) {
            [UIView showResultThenHide:@"您的设备无法通过此方式获取照片"];
            return;
        }
        else {
            if (singleImage) {//选择相册里单张图片
                UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
                imagePickerController.delegate = delegate;
                imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
                imagePickerController.allowsEditing = allowsEditing;
                imagePickerController.sourceType = sourceType;
                [viewController presentViewController:imagePickerController animated:YES completion:nil];
            }
            else {//多张图片
                ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
                picker.delegate = delegate;
                picker.maximumNumberOfSelection = numberOfSelection;
                picker.assetsFilter = [ALAssetsFilter allPhotos];
                picker.showEmptyGroups = NO;
                picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                    if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                        NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                        return duration >= 5;
                    } else {
                        return YES;
                    }
                }];
                [viewController presentViewController:picker animated:YES completion:NULL];
            }
        }
        
    }else{//拍照
        
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ( ! [UIImagePickerController isSourceTypeAvailable:sourceType]) {
            [UIView showResultThenHide:@"您的设备无法通过此方式获取照片"];
            return;
        }
        else {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.delegate = delegate;
            imagePickerController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            imagePickerController.allowsEditing = allowsEditing;
            imagePickerController.sourceType = sourceType;
            [viewController presentViewController:imagePickerController animated:YES completion:nil];
        }
    }
    
    
}



#pragma mark - 添加手势
/**
 *	实现水平方向上左右滑动的动画效果
 *
 *	@param	view	需要做动画的view
 *	@param	subtype	方向 kCATransitionFromRight、kCATransitionFromLeft
 */
+ (void)animateHorizontalSwipe:(UIView *)view withSubType:(NSString *)subtype {
    ReturnWhenObjectIsEmpty(view);
    [view animateHorizontalSwipeWithSubType:subtype];
}
- (void)animateHorizontalSwipeWithSubType:(NSString *)subtype {
    CATransition *animation = [CATransition animation];
    animation.duration = 0.3;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.type = kCATransitionPush;
    animation.subtype = subtype;
    [self.layer addAnimation:animation forKey:@"animation"];
}

+(void)showImage:(UIImageView *)avatarImageView{
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIView *backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: tap];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2, [UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    UIView *backgroundView=tap.view;
    UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=oldframe;
        backgroundView.alpha=0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

//用于不是继承BaseViewController的时候用的
+ (MBProgressHUD *)showHUDLoading:(NSString *)hintString{
    UIView *view=[UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud=[MBProgressHUD HUDForView:view];
    if (hud) {
        [hud show:YES];
    }else{
        hud=[MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.labelText=hintString;
    hud.mode=MBProgressHUDModeIndeterminate;
    return hud;
}
+ (void)hideHUDLoading{
    UIView *view=[UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud=[MBProgressHUD HUDForView:view];
    [hud hide:YES];
}
+ (void)showResultThenHide:(NSString *)resultString {
    UIView *view = [UIApplication sharedApplication].keyWindow;
    MBProgressHUD *hud = [MBProgressHUD HUDForView:view];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud.labelText = resultString;
    hud.mode = MBProgressHUDModeText;
    [hud show:YES];
    [hud hide:YES afterDelay:1];
}



#pragma mark - current view controller
+ (UIViewController *)currentViewController {
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [UIView getVisibleViewControllerFrom:viewController];
    return viewController;
}

+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)viewController {
    if ([viewController isKindOfClass:[UINavigationController class]]) {
        return [UIView getVisibleViewControllerFrom:[((UINavigationController *) viewController) visibleViewController]];
    } else if ([viewController isKindOfClass:[UITabBarController class]]) {
        return [UIView getVisibleViewControllerFrom:[((UITabBarController *) viewController) selectedViewController]];
    } else {
        if (viewController.presentedViewController) {
            return [UIView getVisibleViewControllerFrom:viewController.presentedViewController];
        } else {
            return viewController;
        }
    }
}




- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color{
    [self removeViewWithTag:kTagLineView];
    if (hasUp) {
        UIView *upView = [UIView lineViewWithPointYY:0 andColor:color];
        upView.tag = kTagLineView;
        [self addSubview:upView];
    }
    if (hasDown) {
        UIView *downView = [UIView lineViewWithPointYY:CGRectGetMaxY(self.bounds)-0.5 andColor:color];
        downView.tag = kTagLineView;
        [self addSubview:downView];
    }
    return [self addLineUp:hasUp andDown:hasDown andColor:color andLeftSpace:0];
}
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace{
    [self removeViewWithTag:kTagLineView];
    if (hasUp) {
        UIView *upView = [UIView lineViewWithPointYY:0 andColor:color andLeftSpace:leftSpace];
        upView.tag = kTagLineView;
        [self addSubview:upView];
    }
    if (hasDown) {
        UIView *downView = [UIView lineViewWithPointYY:CGRectGetMaxY(self.bounds)-0.5 andColor:color andLeftSpace:leftSpace];
        downView.tag = kTagLineView;
        [self addSubview:downView];
    }
}
- (void)removeViewWithTag:(NSInteger)tag{
    for (UIView *aView in [self subviews]) {
        if (aView.tag == tag) {
            [aView removeFromSuperview];
        }
    }
}
+ (UIView *)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor *)color{
    return [self lineViewWithPointYY:pointY andColor:color andLeftSpace:0];
}


+ (UIView *)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace{
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(leftSpace, pointY, SCREEN_WIDTH - leftSpace, 0.5)];
    lineView.backgroundColor = color;
    return lineView;
}

@end

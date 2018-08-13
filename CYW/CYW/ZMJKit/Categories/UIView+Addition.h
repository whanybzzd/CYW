//
//  UIView+Addition.h
//  GeneralFramework
//
//  Created by ZMJ on 15/4/19.
//  Copyright (c) 2015年 ZMJ. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <PQActionSheet/PQActionSheet.h>
#import <ZYQAssetPickerController/ZYQAssetPickerController.h>
#import "MBProgressHUD.h"
@interface UIView (Addition)




+ (void)makeCircleForImageView:(UIView *)imageView;



/**
 调用相册

 @param delegate delegate
 @param allowsEditing 是否可以编辑
 @param singleImage 是否选择多张图片
 @param numberOfSelection 最大限制
 @param viewController 视图
 */
+ (void)showImagePickerZYQActionSheetWithDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate>)delegate allowsEditing:(BOOL)allowsEditing singleImage:(BOOL)singleImage numberOfSelection:(NSInteger)numberOfSelection onViewController:(UIViewController *)viewController;

+ (void)showImagePickerZYQActionSheetWithDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate,ZYQAssetPickerControllerDelegate>)delegate allowsEditing:(BOOL)allowsEditing singleImage:(BOOL)singleImage numberOfSelection:(NSInteger)numberOfSelection onViewController:(UIViewController *)viewController sign:(BOOL)sign;


+ (PQActionSheet *)showImagePickerCirImageDelegate:(id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)delegate onViewController:(UIViewController *)viewController;
#pragma mark - 添加手势
/**
 *	实现水平方向上左右滑动的动画效果
 *
 *	@param	view	需要做动画的view
 *	@param	subtype	方向 kCATransitionFromRight、kCATransitionFromLeft
 */
+ (void)animateHorizontalSwipe:(UIView *)view withSubType:(NSString *)subtype;
- (void)animateHorizontalSwipeWithSubType:(NSString *)subtype;


/**
 浏览头像

 @param avatarImageView 头像所在的imageView
 */
+(void)showImage:(UIImageView*)avatarImageView;


/**
 *  如果不是继承BaseViewController的时候用的
 */
#pragma mark show&hide
+ (MBProgressHUD *)showHUDLoading:(NSString *)hintString;
+ (void)hideHUDLoading;
+ (void)showResultThenHide:(NSString *)resultString;


#pragma mark - current view controller
+ (UIViewController *)currentViewController;
+ (UIViewController *)getVisibleViewControllerFrom:(UIViewController *)viewController;



- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color;
+ (BOOL) isCameraAvailable;
+ (BOOL) isRearCameraAvailable;
+ (BOOL) isFrontCameraAvailable;
+ (BOOL) doesCameraSupportTakingPhotos;
+ (BOOL) isPhotoLibraryAvailable;
+ (BOOL) canUserPickVideosFromPhotoLibrary;
+ (BOOL) canUserPickPhotosFromPhotoLibrary;
+ (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType;
@end

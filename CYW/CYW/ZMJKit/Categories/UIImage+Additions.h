//
//  UIImage+Additions.h
//  GeneralFramework
//
//  Created by ZMJ on 15/5/7.
//  Copyright (c) 2015年 ZMJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
// 设置颜色
#define BXColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define BXAlphaColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]


@interface UIImage (Additions)
+(UIImage *)imageWithColor:(UIColor *)aColor;
+ (UIImage *)createImageWithColor:(UIColor *)color;
/**
 *  用颜色返回一张图片
 */
+(UIImage *)createImageFromColor:(UIColor *)color imgSize:(CGSize)size;

//判断图片是否为透明
+ (BOOL)hasPrefx:(UIImage *)image;
//图片拉伸
+ (UIImage *)stretchableImag:(UIImage *)image withPoint:(CGPoint) point;
//调整图片的大小
//+ (UIImage *)resizeImage:(UIImage *)image toSize:(CGSize)size;
//压缩图片
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize;



/**
 *  给头像设置为圆形
 *
 *  @param sourceImage 传入的图片
 *
 *  @return 返回新的图片
 */
+ (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage;

+(UIImage*) circleImage:(UIImage*) image withParam:(CGFloat) inset;

+ (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize;

+(UIImage *)watermarkImage:(UIImage *)img withName:(NSString *)name;
//获取视频封面  videoURL:视频网络地址
+ (UIImage*)thumbnailImageForVideo:(NSURL *)videoURL withTitle:(NSString *)title;


+ (instancetype)st_imageFromVideoOutput:(AVPlayerItemVideoOutput *)output itemTime:(CMTime)itemTime;


//根据图片地址计算大小
+(CGSize)getImageSizeWithURL:(id)imageURL;

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

- (void)hq_imageWithCorner:(CGSize)size fillCorlor:(UIColor *)fillCorlor completion:(void(^)(UIImage *image))completion;
@end

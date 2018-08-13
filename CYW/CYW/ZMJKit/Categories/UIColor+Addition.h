//
//  UIColor+Addition.h
//  abbkbb
//
//  Created by APPLE on 2016/10/25.
//  Copyright © 2016年 ZMJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Addition)
//颜色转换
+ (UIColor*)colorWithHexString:(NSString*)stringToConvert;

+ (UIColor *)colorWithHex:(long)hexColor;

+ (UIColor *)colorWithHex:(long)hexColor alpha:(CGFloat)alpha;


@end

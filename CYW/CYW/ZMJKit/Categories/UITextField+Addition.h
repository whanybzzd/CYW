//
//  UITextField+Addition.h
//  GeneralFramework
//
//  Created by ZMJ on 15/4/19.
//  Copyright (c) 2015年 ZMJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Addition)<UITextFieldDelegate>
@property (assign, nonatomic) NSInteger maxLength;

extern CGFloat CGFloatIn320(CGFloat value);

/**
 简化TextField

 @param font 字体大小
 @param keyboardType 键盘
 @param placeholder 文字提示
 @param color 字体颜色
 @return 文本框
 */
- (instancetype)initWithFont:(CGFloat)font keyboardType:(UIKeyboardType)keyboardType placeholder:(NSString *)placeholder textColor:(NSString *)color;


/**
 设置文本框编剧

 @param textField 文本框
 @param leftWidth 编剧
 */
+(void)setTextFieldLeftPadding:(UITextField *)textField forWidth:(CGFloat)leftWidth;
@end

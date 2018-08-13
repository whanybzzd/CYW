//
//  NSMutableAttributedString+Addition.h
//  abbkbb
//
//  Created by APPLE on 2017/2/21.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableAttributedString (Addition)

+ (NSMutableAttributedString *)withTitleString:(NSString *)string RangeString:(NSString *)range ormoreString:(NSString *)moreString color:(UIColor *)color;


+ (NSMutableAttributedString *)withTitleString:(NSString *)string RangeString:(NSString *)range color:(UIColor *)color withFont:(UIFont *)font;

@end

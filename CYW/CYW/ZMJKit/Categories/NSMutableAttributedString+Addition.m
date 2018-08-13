//
//  NSMutableAttributedString+Addition.m
//  abbkbb
//
//  Created by APPLE on 2017/2/21.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "NSMutableAttributedString+Addition.h"

@implementation NSMutableAttributedString (Addition)

+ (NSMutableAttributedString *)withTitleString:(NSString *)string RangeString:(NSString *)range ormoreString:(NSString *)moreString color:(UIColor *)color{

    NSMutableAttributedString *noteStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",string]];
    NSRange redRange = NSMakeRange([[noteStr string] rangeOfString:range].location, [[noteStr string] rangeOfString:range].length);
    //需要设置的位置
    [noteStr addAttribute:NSForegroundColorAttributeName value:color range:redRange];
    if ([NSString isNotEmpty:moreString]) {

        NSRange redRanges = NSMakeRange([[noteStr string] rangeOfString:moreString].location, [[noteStr string] rangeOfString:moreString].length);
        //需要设置的位置
        [noteStr addAttribute:NSForegroundColorAttributeName value:color range:redRanges];
    }
    return noteStr;



}

+ (NSMutableAttributedString *)withTitleString:(NSString *)string RangeString:(NSString *)range color:(UIColor *)color withFont:(UIFont *)font{

    NSMutableAttributedString * noteStr = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@",string]];
    NSRange redRangeTwo = NSMakeRange([[noteStr string] rangeOfString:range].location, [[noteStr string] rangeOfString:range].length);
    //NSLog(@"redRangeTwo:%zd====%lf",redRangeTwo.length,redRangeTwo.location);
    [noteStr addAttribute:NSFontAttributeName value:font range:redRangeTwo];
    [noteStr addAttribute:NSForegroundColorAttributeName value:color range:redRangeTwo];
    return noteStr;
}
@end

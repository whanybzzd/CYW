//
//  UILabel+Additions.m
//  GeneralFramework
//
//  Created by ZMJ on 15/5/14.
//  Copyright (c) 2015年 ZMJ. All rights reserved.
//

#import "UILabel+Additions.h"

@implementation UILabel (Additions)

- (CGSize)boundingRectWithSize:(CGSize)size
{
    NSDictionary *attribute = @{NSFontAttributeName: self.font};

    CGSize retSize = [self.text boundingRectWithSize:size
                                             options:\
                      NSStringDrawingTruncatesLastVisibleLine |
                      NSStringDrawingUsesLineFragmentOrigin |
                      NSStringDrawingUsesFontLeading
                                          attributes:attribute
                                             context:nil].size;
    
    return retSize;
}
@end

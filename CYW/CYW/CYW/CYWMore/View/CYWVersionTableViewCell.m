//
//  CYWVersionTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/11/16.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWVersionTableViewCell.h"

@implementation CYWVersionTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        
    }
    return self;
    
}

@end

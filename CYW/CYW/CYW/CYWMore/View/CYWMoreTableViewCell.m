//
//  CYWMoreTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/19.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreTableViewCell.h"
@interface CYWMoreTableViewCell()

@property (nonatomic, retain) UILabel *label;
@end
@implementation CYWMoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
        [self label];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    
}


- (void)setValueString:(NSString *)valueString{
    
    self.label.text=valueString;
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    if (2==indexPath.section&&2==indexPath.row){
        
        
        [self.label setAttributedText:[NSMutableAttributedString
                                       withTitleString:@"400-863-9333"
                                       RangeString:@"400-863-9333"
                                       ormoreString:nil
                                       color:[UIColor colorWithHexString:@"#f52735"]]];
        
        [self.label sizeToFit];
        
        
    }
}
- (UILabel *)label{
    if (!_label) {
        
        _label=[UILabel new];
        _label.text=@"";
        _label.textColor=[UIColor colorWithHexString:@"#888888"];
        _label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [self.contentView addSubview:_label];
        _label.sd_layout
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, CGFloatIn320(5))
        .heightIs(14);
        [_label setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _label;
}
@end

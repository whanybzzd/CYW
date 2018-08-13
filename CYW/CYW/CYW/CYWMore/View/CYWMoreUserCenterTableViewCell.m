//
//  CYWMoreUserCenterTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreUserCenterTableViewCell.h"
@interface CYWMoreUserCenterTableViewCell()
@property (nonatomic, retain) UILabel *detailabel;
@end
@implementation CYWMoreUserCenterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self detailabel];
    }
    return self;
}
- (UILabel *)detailabel{
    if (!_detailabel) {
        
        _detailabel=[UILabel new];
        _detailabel.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        _detailabel.text=@"";
        _detailabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [self.contentView addSubview:_detailabel];
        _detailabel.sd_layout
        .rightSpaceToView(self.contentView, CGFloatIn320(15))
        .heightIs(11)
        .centerYEqualToView(self.contentView);
        [_detailabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _detailabel;
}


- (void)setDetailString:(NSString *)detailString{
    
    self.detailabel.text=detailString;
    [self.detailabel sizeToFit];
    
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==1&&indexPath.row==0) {
        
        
    }else{
        
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    

}
@end

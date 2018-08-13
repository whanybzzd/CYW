//
//  CYWAssetsTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/12.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsTableViewCell.h"
@interface CYWAssetsTableViewCell()
@property (nonatomic, retain) UILabel *detailabel;
@end
@implementation CYWAssetsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self detailabel];
    }
    return self;
}
- (void)setDetailString:(NSString *)detailString{
    
    [self.detailabel setAttributedText:[NSMutableAttributedString withTitleString:detailString RangeString:@"元" ormoreString:nil color:[UIColor colorWithHexString:@"#888888"]]];
    
    [self.detailabel sizeToFit];
    
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section!=0) {
        
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    if (indexPath.section==1||indexPath.section==2) {
        
        [self.detailabel setHidden:YES];
    }
    if (indexPath.section==3) {
        _detailabel.sd_layout
        .rightSpaceToView(self.contentView, CGFloatIn320(0));
        
        NSString *count=[[NSUserDefaults standardUserDefaults] objectForKey:@"envelope"];
        if ([NSString isNotEmpty:count]) {
            
            [self.detailabel setAttributedText:[NSMutableAttributedString withTitleString:[NSString stringWithFormat:@"%@个红包可用",count] RangeString:@"个红包可用" ormoreString:nil color:[UIColor colorWithHexString:@"#888888"]]];
        }else{
            
            self.detailabel.text=nil;
        }
        
    }


}

#pragma mark --懒加载

- (UILabel *)iconlabel{
    if (!_iconlabel) {
        
        _iconlabel=[UILabel new];
        _iconlabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _iconlabel.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_iconlabel];
        _iconlabel.sd_layout
        .leftSpaceToView(self.imageView, CGFloatIn320(20))
        .centerYEqualToView(self.contentView)
        .heightIs(14);
        [_iconlabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _iconlabel;
}

- (UILabel *)detailabel{
    if (!_detailabel) {
        
        _detailabel=[UILabel new];
        _detailabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _detailabel.textColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_detailabel];
        _detailabel.sd_layout
        .rightSpaceToView(self.contentView, CGFloatIn320(15))
        .centerYEqualToView(self.contentView)
        .heightIs(12);
        [_detailabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
    }
    return _detailabel;
}

@end

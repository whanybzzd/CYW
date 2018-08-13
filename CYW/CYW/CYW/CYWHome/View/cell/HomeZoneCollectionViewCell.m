//
//  HomeZoneCollectionViewCell.m
//  CYW
//
//  Created by jktz on 2018/5/22.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import "HomeZoneCollectionViewCell.h"

@implementation HomeZoneCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=[UIColor whiteColor];
        [self iconImageView];
        [self detaillabel];
        
    }
    return self;
}

- (UIImageView *)iconImageView{
    
    if (!_iconImageView) {
        
        _iconImageView=[UIImageView new];
        [self.contentView addSubview:_iconImageView];
        _iconImageView.sd_layout
        .topSpaceToView(self.contentView, 13)
        .centerXEqualToView(self.contentView)
        .widthIs(50)
        .heightIs(50);
    }
    return _iconImageView;
}

- (UILabel *)detaillabel{
    
    if (!_detaillabel) {
        
        _detaillabel=[UILabel new];
        _detaillabel.textColor=[UIColor colorWithHexString:@"#333333"];
        _detaillabel.font=[UIFont systemFontOfSize:12];
        [self.contentView addSubview:_detaillabel];
        _detaillabel.sd_layout
        .centerXEqualToView(self.contentView)
        .topSpaceToView(self.iconImageView, 12)
        .heightIs(12);
        [_detaillabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _detaillabel;
}
@end

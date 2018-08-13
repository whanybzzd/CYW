//
//  CYWAssetsCollectionViewCell.m
//  CYW
//
//  Created by jktz on 2017/11/21.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsCollectionViewCell.h"
#import "DCHDateHelper.h"
@implementation CYWAssetsCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        [self rightView];
        [self timelabel];
        [self pricelabel];
        
        
    }
    return self;
}

- (UIView *)rightView{
    if (!_rightView) {
        
        _rightView=[UIView new];
        [self.contentView addSubview:_rightView];
        _rightView.sd_layout
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .heightIs(30)
        .widthIs(30);
        UIImageView *imageView=[UIImageView new];
        imageView.image=[UIImage imageNamed:@"水滴拷贝"];
        [_rightView addSubview:imageView];
        imageView.sd_layout
        .spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
        self.numberlabel=[UILabel new];
        self.numberlabel.textColor=[UIColor whiteColor];
        self.numberlabel.font=[UIFont systemFontOfSize:12];
        [_rightView addSubview:self.numberlabel];
        self.numberlabel.sd_layout
        .centerXEqualToView(_rightView)
        .heightIs(12)
        .centerYEqualToView(_rightView);
        [self.numberlabel setSingleLineAutoResizeWithMaxWidth:30];
        
    }
    return _rightView;
}

- (UILabel *)timelabel{
    if (!_timelabel) {
        
        _timelabel=[UILabel new];
        _timelabel.font=[UIFont systemFontOfSize:12];
        _timelabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_timelabel];
        _timelabel.sd_layout
        .centerXEqualToView(self.contentView)
        .topSpaceToView(_rightView, 0)
        .heightIs(12);
        [self.timelabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _timelabel;
}
- (UILabel *)pricelabel{
    if (!_pricelabel) {
        
        _pricelabel=[UILabel new];
        _pricelabel.font=[UIFont systemFontOfSize:12];
        _pricelabel.textColor=[UIColor colorWithHexString:@"#eb4064"];
        [self.contentView addSubview:_pricelabel];
        _pricelabel.sd_layout
        .centerXEqualToView(self.contentView)
        .topSpaceToView(_timelabel, 7)
        .heightIs(12);
        [self.pricelabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _pricelabel;
}
-(void)setSelected:(BOOL)selected{
    
    [super setSelected:selected];
}

- (void)setCellDate:(NSDate *)cellDate {
    _cellDate = cellDate;
     self.timelabel.text = [DCHDateHelper getStrFromDateFormat:@"d" Date:_cellDate];
    //判断月份是否一样
    if (![DCHDateHelper checkSameMonth:_cellDate AnotherMonth:_curDate]) {
       self.timelabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [self.rightView setHidden:YES];
        [self.pricelabel setHidden:YES];
        self.hidden=YES;
    }else{
        
        self.timelabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.rightView setHidden:NO];
        [self.pricelabel setHidden:NO];
        self.hidden=NO;
    }


}

@end

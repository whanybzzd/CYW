//
//  AssetsWithdrawalsTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/16.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "AssetsWithdrawalsTableViewCell.h"
@interface AssetsWithdrawalsTableViewCell()


@end
@implementation AssetsWithdrawalsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self titlabel];
        [self detailabel];
        [self initSubView];
        
    }
    return self;
}

- (void)initSubView{
    
    @weakify(self)
    UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc] init];
    [[tapView rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self)
        if ([self.delegate respondsToSelector:@selector(labelClick)]) {
            
            [self.delegate labelClick];
        }
        
    }];
    [self.titlabel addGestureRecognizer:tapView];
}

- (void)setTitlestring:(NSString *)titlestring{
    
    _titlestring=titlestring;
    [self.detailabel setAttributedText:[NSMutableAttributedString withTitleString:titlestring RangeString:@"已实名认证用户，无需再登陆乾多多实名认证，请忽略乾多多充值页面提示。" ormoreString:@"" color:[UIColor redColor]]];
    [self.detailabel sizeToFit];
    
}
- (UILabel *)titlabel{
    if (!_titlabel) {
        
        _titlabel=[UILabel new];
        _titlabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _titlabel.text=@"温馨提示:";
        _titlabel.userInteractionEnabled=YES;
        _titlabel.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_titlabel];
        _titlabel.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(15))
        .heightIs(14)
        .topSpaceToView(self.contentView, 30);
        [_titlabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _titlabel;
}
- (UILabel *)detailabel{
    if (!_detailabel) {
        
        _detailabel=[UILabel new];
        _detailabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _detailabel.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_detailabel];
        _detailabel.sd_layout
        .leftEqualToView(_titlabel)
        .autoHeightRatio(0)
        .topSpaceToView(_titlabel, CGFloatIn320(15))
        .rightSpaceToView(self.contentView, CGFloatIn320(15));
    }
    return _detailabel;
}
@end

//
//  CYWMoreUserCenterIntegralTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreUserCenterIntegralTableViewCell.h"
@interface CYWMoreUserCenterIntegralTableViewCell()
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *label1;
@property (nonatomic, retain) UILabel *label2;
@property (nonatomic, retain) UILabel *label3;
@end
@implementation CYWMoreUserCenterIntegralTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self label];
        [self label3];
        [self label2];
        [self label1];
        
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(IntegralViewModel *viewModel) {
        
        @strongify(self);
        
        [self.label setAttributedText:[NSMutableAttributedString withTitleString:[NSString stringWithFormat:@"VIP%@",viewModel.level] RangeString:[NSString stringWithFormat:@"%@",viewModel.level] color:[UIColor colorWithHexString:@"#f53756"] withFont:[UIFont systemFontOfSize:CGFloatIn320(11)]]];
        [self.label sizeToFit];
        
        
        self.label3.text=[NSString stringWithFormat:@"%@倍",viewModel.acceleration];
        [self.label3 sizeToFit];
        
        
        self.label2.text=[NSString stringWithFormat:@"%@次",viewModel.withDrawFreeCount];
        [self.label2 sizeToFit];
        
        self.label1.text=[NSString stringWithFormat:@"%@%%",viewModel.feeRateCut];
        [self.label1 sizeToFit];
    }];
    
    
    
}
- (UILabel *)label{
    if (!_label) {
        
        _label=[UILabel new];
        _label.text=@"VIP0";
        _label.textColor=[UIColor colorWithHexString:@"#f53756"];
        _label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [self.contentView addSubview:_label];
        _label.sd_layout
        .centerYEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, CGFloatIn320(20))
        .heightIs(14);
        [_label setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _label;
}

- (UILabel *)label3{
    if (!_label3) {
        
        _label3=[UILabel new];
        _label3.text=@"1.1倍";
        _label3.textColor=[UIColor colorWithHexString:@"#888888"];
        _label3.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        [self.contentView addSubview:_label3];
        _label3.sd_layout
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, CGFloatIn320(20))
        .heightIs(11);
        [_label3 setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _label3;
}

- (UILabel *)label2{
    if (!_label2) {
        
        _label2=[UILabel new];
        _label2.text=@"3次";
        _label2.textColor=[UIColor colorWithHexString:@"#888888"];
        _label2.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        [self.contentView addSubview:_label2];
        _label2.sd_layout
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(_label3, CGFloatIn320(86))
        .heightIs(11);
        [_label2 setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _label2;
}


- (UILabel *)label1{
    if (!_label1) {
        
        _label1=[UILabel new];
        _label1.text=@"7%";
        _label1.textColor=[UIColor colorWithHexString:@"#888888"];
        _label1.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        [self.contentView addSubview:_label1];
        _label1.sd_layout
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(_label2, CGFloatIn320(86))
        .heightIs(11);
        [_label1 setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _label1;
}
@end

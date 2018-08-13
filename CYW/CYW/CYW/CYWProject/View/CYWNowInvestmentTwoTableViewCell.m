//
//  CYWNowInvestmentTwoTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/31.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWNowInvestmentTwoTableViewCell.h"
@interface CYWNowInvestmentTwoTableViewCell()
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) UILabel *label1;
@property (nonatomic, retain) UILabel *label2;
@property (nonatomic, retain) UILabel *label3;
@end
@implementation CYWNowInvestmentTwoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self label];
        [self label1];
        [self label2];
        [self label3];
        [self setupSignal];
    }
    return self;
}

- (void)setupSignal{
    
    @weakify(self)
    //债权列表
    [RACObserve(self, model) subscribeNext:^(NowProjectDetailViewModel *viewModel) {
        
        @strongify(self);
        
        self.label.text=viewModel.investMoney;
        [self.label sizeToFit];
        
        NSString *bankNo = [viewModel.userName substringToIndex:1];
        self.label1.text=[NSString stringWithFormat:@"%@*****",bankNo];
        [self.label sizeToFit];
        
        NSArray *arry = [viewModel.time componentsSeparatedByString:@" "];
        self.label2.text=[arry firstObject];
        [self.label2 sizeToFit];
        
        self.label3.text=[arry lastObject];
        [self.label3 sizeToFit];
    }];
    
}
- (UILabel *)label{
    if (!_label) {
        
        _label=[UILabel new];
        _label.text=@"0.0";
        _label.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _label.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_label];
        _label.sd_layout
        .centerXEqualToView(self.contentView)
        .heightIs(13)
        .centerYEqualToView(self.contentView);
        [_label setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _label;
}
- (UILabel *)label1{
    if (!_label1) {
        
        _label1=[UILabel new];
        _label1.text=@"王**";
        _label1.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _label1.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_label1];
        _label1.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(40))
        .heightIs(12)
        .centerYEqualToView(self.contentView);
        [_label1 setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _label1;
}

- (UILabel *)label2{
    if (!_label2) {
        
        _label2=[UILabel new];
        _label2.text=@"王**";
        _label2.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _label2.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_label2];
        _label2.sd_layout
        .rightSpaceToView(self.contentView, CGFloatIn320(25))
        .topSpaceToView(self.contentView, CGFloatIn320(10))
        .heightIs(12);
        [_label2 setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _label2;
}

- (UILabel *)label3{
    if (!_label3) {
        
        _label3=[UILabel new];
        _label3.text=@"王**";
        _label3.font=[UIFont systemFontOfSize:CGFloatIn320(10)];
        _label3.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_label3];
        _label3.sd_layout
        .rightSpaceToView(self.contentView, CGFloatIn320(25))
        .topSpaceToView(_label2, CGFloatIn320(5))
        .heightIs(13);
        [_label3 setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _label3;
}
@end

//
//  CYWMoreUserCenterefereesTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreUserCenterefereesTableViewCell.h"
@interface CYWMoreUserCenterefereesTableViewCell()
@property (nonatomic, retain) UILabel *answerlabel;
@property (nonatomic, retain) UILabel *answerlabel1;
@property (nonatomic, retain) UILabel *answerlabel2;

@end
@implementation CYWMoreUserCenterefereesTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self answerlabel];
        [self answerlabel1];
        [self answerlabel2];
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(ReferrerViewModel *viewModel) {
        
        @strongify(self);
        self.answerlabel.text=[NSString stringWithFormat:@"%@元",viewModel.money];
        [self.answerlabel sizeToFit];
        
        
        self.answerlabel1.text=[NSString stringWithFormat:@"%@",viewModel.time];
        [self.answerlabel1 sizeToFit];
        
        self.answerlabel2.text=[NSString stringWithFormat:@"%@",viewModel.investor];
        [self.answerlabel2 sizeToFit];
    }];
}

- (UILabel *)answerlabel{
    if (!_answerlabel) {
        
        _answerlabel=[UILabel new];
        _answerlabel.text=@"1000";
        _answerlabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _answerlabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [self.contentView addSubview:_answerlabel];
        _answerlabel.sd_layout
        .centerXEqualToView(self.contentView)
        .centerYEqualToView(self.contentView)
        .heightIs(12);
        [_answerlabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _answerlabel;
}
- (UILabel *)answerlabel1{
    if (!_answerlabel1) {
        
        _answerlabel1=[UILabel new];
        _answerlabel1.text=@"2017-08-12";
        _answerlabel1.numberOfLines=0;
        _answerlabel1.textColor=[UIColor colorWithHexString:@"#888888"];
        _answerlabel1.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [self.contentView addSubview:_answerlabel1];
        _answerlabel1.sd_layout
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, CGFloatIn320(11))
        .autoHeightRatio(0);
        [_answerlabel1 setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _answerlabel1;
}


- (UILabel *)answerlabel2{
    if (!_answerlabel2) {
        
        _answerlabel2=[UILabel new];
        _answerlabel2.text=@"被推荐人";
        _answerlabel2.textColor=[UIColor colorWithHexString:@"#333333"];
        _answerlabel2.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [self.contentView addSubview:_answerlabel2];
        _answerlabel2.sd_layout
        .centerYEqualToView(self.contentView)
        .heightIs(14)
        .leftSpaceToView(self.contentView, CGFloatIn320(10));
        [_answerlabel2 setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _answerlabel2;
}


@end

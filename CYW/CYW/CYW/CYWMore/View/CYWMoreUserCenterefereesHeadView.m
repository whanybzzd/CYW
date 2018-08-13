//
//  CYWMoreUserCenterefereesHeadView.m
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreUserCenterefereesHeadView.h"
@interface CYWMoreUserCenterefereesHeadView()

@property (nonatomic, retain) UILabel *answerlabel;
@property (nonatomic, retain) UILabel *answerlabel1;
@property (nonatomic, retain) UILabel *answerlabel2;

@end
@implementation CYWMoreUserCenterefereesHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.height=50.0f;
        self.backgroundColor=[UIColor colorWithHexString:@"#F5F5F9"];
        [self answerlabel];
        [self answerlabel1];
        [self answerlabel2];
    }
    return self;
}

- (UILabel *)answerlabel{
    if (!_answerlabel) {
        
        _answerlabel=[UILabel new];
        _answerlabel.text=@"投资金额";
        _answerlabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _answerlabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [self addSubview:_answerlabel];
        _answerlabel.sd_layout
        .centerXEqualToView(self)
        .centerYEqualToView(self)
        .heightIs(14);
        [_answerlabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _answerlabel;
}
- (UILabel *)answerlabel1{
    if (!_answerlabel1) {
        
        _answerlabel1=[UILabel new];
        _answerlabel1.text=@"时间";
        _answerlabel1.textColor=[UIColor colorWithHexString:@"#888888"];
        _answerlabel1.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [self addSubview:_answerlabel1];
        _answerlabel1.sd_layout
        .centerYEqualToView(self)
        .heightIs(14)
        .rightSpaceToView(self, CGFloatIn320(24));
        [_answerlabel1 setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _answerlabel1;
}


- (UILabel *)answerlabel2{
    if (!_answerlabel2) {
        
        _answerlabel2=[UILabel new];
        _answerlabel2.text=@"被推荐人";
        _answerlabel2.textColor=[UIColor colorWithHexString:@"#888888"];
        _answerlabel2.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [self addSubview:_answerlabel2];
        _answerlabel2.sd_layout
        .centerYEqualToView(self)
        .heightIs(14)
        .leftSpaceToView(self, CGFloatIn320(10));
        [_answerlabel2 setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _answerlabel2;
}
@end

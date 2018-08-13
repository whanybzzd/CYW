//
//  CYWMoreUserCenterefereesFootView.m
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreUserCenterefereesFootView.h"
@interface CYWMoreUserCenterefereesFootView()
@property (nonatomic, retain) UILabel *answerlabel;
@property (nonatomic, retain) UIButton *phoneButton;

@end
@implementation CYWMoreUserCenterefereesFootView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.height=100.0f;
        self.backgroundColor=[UIColor colorWithHexString:@"#F5F5F9"];
        [self answerlabel];
        [self phoneButton];
        [self initSubView];
        
    }
    return self;
}

- (void)initSubView{
    
    [[_phoneButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
    
        CallPhone(_phoneButton.titleLabel.text);
        
    }];
}
- (UILabel *)answerlabel{
    if (!_answerlabel) {
        
        _answerlabel=[UILabel new];
        _answerlabel.text=@"如有疑问，请联系客服";
        _answerlabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _answerlabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [self addSubview:_answerlabel];
        _answerlabel.sd_layout
        .leftSpaceToView(self, CGFloatIn320(15))
        .topSpaceToView(self, CGFloatIn320(12))
        .heightIs(12);
        [_answerlabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _answerlabel;
}

- (UIButton *)phoneButton{
    if (!_phoneButton) {
        
        _phoneButton=[UIButton new];
        [_phoneButton setTitle:@"400-863-9333" forState:UIControlStateNormal];
        _phoneButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _phoneButton.layer.borderColor=[UIColor colorWithHexString:@"#cccccc"].CGColor;
        _phoneButton.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [_phoneButton setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        _phoneButton.layer.borderWidth=1.0f;
        _phoneButton.layer.cornerRadius=CGFloatIn320(16.5);
        [self addSubview:_phoneButton];
        _phoneButton.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(_answerlabel, CGFloatIn320(45))
        .heightIs(CGFloatIn320(33))
        .widthIs(CGFloatIn320(120));
    }
    return _phoneButton;
}
@end

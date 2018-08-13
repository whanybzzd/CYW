//
//  CricleView.m
//  CYW
//
//  Created by jktz on 2017/10/19.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CricleView.h"
@interface CricleView()
@property (nonatomic, retain) UIImageView *cricleImageView;

@end
@implementation CricleView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        [self cricleImageView];
        [self imageView2];
        [self centerImageView];
    }
    return self;
}

- (UIImageView *)cricleImageView{
    
    if (!_cricleImageView) {
        
        _cricleImageView=[UIImageView new];
        _cricleImageView.layer.cornerRadius=CGFloatIn320(self.frame.size.width/2);
        _cricleImageView.backgroundColor=[UIColor colorWithHexString:@"#A9CEF0"];
        [self addSubview:_cricleImageView];
        _cricleImageView.sd_layout
        .centerYEqualToView(self)
        .centerXEqualToView(self)
        .widthIs(CGFloatIn320(self.frame.size.width))
        .heightIs(CGFloatIn320(self.frame.size.height));
    }
    return _cricleImageView;
}


- (UIImageView *)imageView2{
    
    if (!_imageView2) {
        
        _imageView2=[UIImageView new];
        _imageView2.layer.cornerRadius=CGFloatIn320(9);
        [self addSubview:_imageView2];
        _imageView2.sd_layout
        .centerYEqualToView(self)
        .centerXEqualToView(self)
        .widthIs(CGFloatIn320(18))
        .heightIs(CGFloatIn320(18));
    }
    return _imageView2;
}

- (UIImageView *)centerImageView{
    
    if (!_centerImageView) {
        
        _centerImageView=[UIImageView new];
        [self addSubview:_centerImageView];
        _centerImageView.sd_layout
        .centerYEqualToView(self)
        .centerXEqualToView(self)
        .widthIs(CGFloatIn320(11))
        .heightIs(CGFloatIn320(10));
    }
    return _centerImageView;
}
@end

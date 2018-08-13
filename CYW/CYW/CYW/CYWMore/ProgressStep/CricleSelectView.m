//
//  CricleSelectView.m
//  CYW
//
//  Created by jktz on 2017/10/19.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CricleSelectView.h"
@interface CricleSelectView()

@property (nonatomic, retain) UIImageView *cricleImageView;
@property (nonatomic, retain) UIImageView *avaterImageView;
@property (nonatomic, retain) UIImageView *bottomImageView;
@property (nonatomic, retain) UILabel *viplabel;
@end
@implementation CricleSelectView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        [self cricleImageView];
        [self avaterImageView];
        [self bottomImageView];
        [self viplabel];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    
    ParentModel *mo=(ParentModel *)[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserModel];
    
    if ([NSObject isNotEmpty:mo]) {
        
        self.viplabel.text=[NSString isEmpty:mo.userLevel]?@"":mo.userLevel;
        [self.viplabel sizeToFit];//photo
        
        [self.avaterImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,mo.photo]] placeholder:[UIImage imageNamed:@"icon_avater"]];
        
    }
    
}

- (UIImageView *)cricleImageView{
    
    if (!_cricleImageView) {
        
        _cricleImageView=[UIImageView new];
        _cricleImageView.layer.cornerRadius=CGFloatIn320(self.frame.size.width/2);
        _cricleImageView.backgroundColor=[UIColor colorWithHexString:@"#A9CEF0"];
        [self addSubview:_cricleImageView];
        _cricleImageView.sd_layout
        .leftSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .widthIs(CGFloatIn320(self.frame.size.width))
        .heightIs(CGFloatIn320(self.frame.size.width));
    }
    return _cricleImageView;
}

- (UIImageView *)avaterImageView{
    
    if (!_avaterImageView) {
        
        _avaterImageView=[UIImageView new];
        _avaterImageView.layer.masksToBounds=YES;
        _avaterImageView.layer.cornerRadius=CGFloatIn320(17);
        _avaterImageView.backgroundColor=[UIColor clearColor];
        [self addSubview:_avaterImageView];
        _avaterImageView.sd_layout
        .leftSpaceToView(self, CGFloatIn320(3))
        .topSpaceToView(self, CGFloatIn320(3))
        .widthIs(CGFloatIn320(34))
        .heightIs(CGFloatIn320(34));
    }
    return _avaterImageView;
}


- (UIImageView *)bottomImageView{
    
    if (!_bottomImageView) {
        
        _bottomImageView=[UIImageView new];
        _bottomImageView.image=[UIImage imageNamed:@"icon_vip_select"];
        [self addSubview:_bottomImageView];
        _bottomImageView.sd_layout
        .leftSpaceToView(self, 0)
        .topSpaceToView(self, 30)
        .rightSpaceToView(self, 0)
        .bottomSpaceToView(self, 0);
    }
    return _bottomImageView;
}


- (UILabel *)viplabel{
    if (!_viplabel) {
        
        _viplabel=[UILabel new];
        _viplabel.text=@"VIP 4";
        _viplabel.font=[UIFont systemFontOfSize:CGFloatIn320(10)];
        _viplabel.textColor=[UIColor whiteColor];
        [self addSubview:_viplabel];
        _viplabel.sd_layout
        .heightIs(10)
        .topSpaceToView(self, 31)
        .centerXEqualToView(self);
        [_viplabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _viplabel;
}
@end

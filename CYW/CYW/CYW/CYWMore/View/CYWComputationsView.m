//
//  CYWComputationsView.m
//  CYW
//
//  Created by jktz on 2017/11/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWComputationsView.h"
@interface CYWComputationsView()
@property (nonatomic, retain) UIView *alertView;
@property (nonatomic, retain) UIImageView *closeImageView;
@property (nonatomic, retain) UILabel *titlelabel;
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) UILabel *titlelabel1;
@property (nonatomic, retain) UILabel *titlelabel2;
@end
@implementation CYWComputationsView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        [self alertView];
        [self closeImageView];
        [self titlelabel];
        [self lineView];
        [self titlelabel1];
        [self titlelabel2];
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
    @weakify(self)
    UITapGestureRecognizer *forgetTap1=[[UITapGestureRecognizer alloc] init];
    [[forgetTap1 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self)
        [self hide];
    }];
    [self.closeImageView addGestureRecognizer:forgetTap1];
}

- (UILabel *)titlelabel{
    
    if (!_titlelabel) {
        
        _titlelabel=[UILabel new];
        _titlelabel.font=[UIFont boldSystemFontOfSize:16];
        _titlelabel.textColor=[UIColor whiteColor];
        _titlelabel.text=@"计算规则";
        [_alertView addSubview:_titlelabel];
        _titlelabel.sd_layout
        .heightIs(14)
        .centerXEqualToView(_alertView)
        .topSpaceToView(_alertView, 15);
        [_titlelabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _titlelabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor whiteColor];
        [_alertView addSubview:_lineView];
        _lineView.sd_layout
        .leftSpaceToView(_alertView, 27)
        .rightSpaceToView(_alertView, 27)
        .topSpaceToView(_titlelabel, 10)
        .heightIs(1.0);
    }
    return _lineView;
}

- (UILabel *)titlelabel1{
    
    if (!_titlelabel1) {
        
        _titlelabel1=[UILabel new];
        _titlelabel1.font=[UIFont boldSystemFontOfSize:13];
        _titlelabel1.textColor=[UIColor whiteColor];
        _titlelabel1.text=@"本月投资排行榜以年化投资金额作为排名的唯一标准:";
        _titlelabel1.numberOfLines=0;
        [_alertView addSubview:_titlelabel1];
        _titlelabel1.sd_layout
        .autoHeightRatio(0)
        .topSpaceToView(_lineView, 15)
        .leftEqualToView(_lineView)
        .rightEqualToView(_lineView);
    }
    return _titlelabel1;
}
- (UILabel *)titlelabel2{
    
    if (!_titlelabel2) {
        
        _titlelabel2=[UILabel new];
        _titlelabel2.font=[UIFont boldSystemFontOfSize:11];
        _titlelabel2.textColor=[UIColor whiteColor];
        _titlelabel2.text=[self str];
        _titlelabel2.numberOfLines=0;
        [_alertView addSubview:_titlelabel2];
        _titlelabel2.sd_layout
        .autoHeightRatio(0)
        .topSpaceToView(_titlelabel1, 15)
        .leftEqualToView(_titlelabel1)
        .rightEqualToView(_titlelabel1);
    }
    return _titlelabel2;
}

- (UIImageView *)closeImageView{
    
    if (!_closeImageView) {
        
        _closeImageView=[UIImageView new];
        _closeImageView.userInteractionEnabled=YES;
        _closeImageView.image=[UIImage imageNamed:@"X"];
        [_alertView addSubview:self.closeImageView];
        _closeImageView.sd_layout
        .topSpaceToView(_alertView, 15)
        .rightSpaceToView(_alertView, 20)
        .widthIs(18)
        .heightIs(17);
        
    }
    return _closeImageView;
}

- (UIView *)alertView{
    
    if (!_alertView) {
        
        _alertView=[[UIView alloc] initWithFrame:CGRectMake(61, ([UIScreen mainScreen].bounds.size.height-394)/2-30, [UIScreen mainScreen].bounds.size.width-61*2,394)];
        _alertView.layer.cornerRadius=10;
        UIImageView *imageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _alertView.frame.size.width, _alertView.frame.size.height)];
        imageView.image=[UIImage imageNamed:@"圆角矩形1"];
        [_alertView addSubview:imageView];
        [self addSubview:_alertView];
        
    }
    return _alertView;
}

- (void)show{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alertView.alpha = 0.0;
    [UIView animateWithDuration:0.4 animations:^{
        self.alertView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (NSString *)str{
    
    NSString *string=@"1.什么是年化投资金额:\n\n年化投资金额是根据投资人投资的投资计划或标的期限和金额，以“年”为单位提现出来。\n\n2.计算公式:\n\n年化投资额=投资金额*投资期限/12个月。\n\n3.举个例子:\n\n王先生投资了一个3月标，投资金额为10000元，根据计算公式他的年化投资额=10000*3/12=2500元\n\n张女士投资了一个6月标，投资金额为10000元，根据计算公式她的年化投资额=10000*6/12=5000元";
    return string;
}

@end

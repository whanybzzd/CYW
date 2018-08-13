//
//  CYWAssetsInvestHeadView.m
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsInvestHeadView.h"
@interface CYWAssetsInvestHeadView()
@property (nonatomic, retain) UILabel *repaymentslabel;
@property (nonatomic, retain) UILabel *repaymentslabel1;
@property (nonatomic, retain) UILabel *repaymentslabel2;

@property (nonatomic, retain) UIView *leftView;
@property (nonatomic, retain) UIView *rightView;

@property (nonatomic, retain) UILabel *investlabel;
@property (nonatomic, retain) UILabel *investlabel1;
@property (nonatomic, retain) UILabel *investlabel2;

@property (nonatomic, retain) UILabel *interestlabel;
@property (nonatomic, retain) UILabel *interestlabel1;
@property (nonatomic, retain) UILabel *interestlabel2;
@end
@implementation CYWAssetsInvestHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        UIImageView *imageView=[UIImageView new];
        imageView.image=[UIImage imageNamed:@"我的投资1"];
        [self addSubview:imageView];
        imageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        self.height=CGFloatIn320(217);
        UIView *lineView=[UIView new];
        lineView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self addSubview:lineView];
        lineView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .bottomSpaceToView(self, 0)
        .heightIs(CGFloatIn320(10));
        
        [self repaymentslabel];
         [self repaymentslabel1];
        [self repaymentslabel2];
        
        [self leftView];
        [self rightView];
        
        [self investlabel];
        [self investlabel1];
        [self investlabel2];
        
        [self interestlabel];
        [self interestlabel1];
        [self interestlabel2];
        
        
        [self.repaymentslabel setAttributedText:[NSMutableAttributedString withTitleString:@"应收还款(元)" RangeString:@"应收还款" color:[UIColor whiteColor] withFont:[UIFont systemFontOfSize:CGFloatIn320(14)]]];
        
        //investlabel //interestlabel
        [self.investlabel setAttributedText:[NSMutableAttributedString withTitleString:@"投资本金(元)" RangeString:@"投资本金" color:[UIColor whiteColor] withFont:[UIFont systemFontOfSize:CGFloatIn320(14)]]];
        
        [self.interestlabel setAttributedText:[NSMutableAttributedString withTitleString:@"应收利息(元)" RangeString:@"应收利息" color:[UIColor whiteColor] withFont:[UIFont systemFontOfSize:CGFloatIn320(14)]]];
        
        
        
        
        
        @weakify(self);
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"postInvestName" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
          
            //NSLog(@"xxx:%@",x);
            @strongify(self)
            self.investlabel1.text=x.object[@"investTotal"];
            [self.investlabel1 sizeToFit];
            
            self.investlabel2.text=[NSString stringWithFormat:@"还款中:%@",x.object[@"hkTotal"]];
            [self.investlabel2 sizeToFit];
            
            self.interestlabel1.text=x.object[@"reimbursementTotal"];
            [self.interestlabel1 sizeToFit];
            
            
            
            self.repaymentslabel1.text=[NSString stringWithFormat:@"%.2lf",[self.investlabel1.text floatValue]+[self.interestlabel1.text floatValue]];//total
            [self.repaymentslabel1 sizeToFit];
            
            
            self.interestlabel2.text=[NSString stringWithFormat:@"已收利息:%@元",x.object[@"total"]];
            [self.interestlabel2 sizeToFit];//total
            
            self.repaymentslabel2.text=[NSString stringWithFormat:@"未收合计:%.2lf元",[x.object[@"whTotal"] floatValue]];
            [self.repaymentslabel2 sizeToFit];
        }];
    }
    return self;
}

- (UILabel *)repaymentslabel{
    if (!_repaymentslabel) {
        
        _repaymentslabel=[UILabel new];
        _repaymentslabel.textColor=[UIColor whiteColor];
        _repaymentslabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _repaymentslabel.text=@"应收还款(元)";
        [self addSubview:_repaymentslabel];
        _repaymentslabel.sd_layout
        .centerXEqualToView(self)
        .heightIs(14)
        .topSpaceToView(self, CGFloatIn320(23));
        [_repaymentslabel setSingleLineAutoResizeWithMaxWidth:250];
    }
    return _repaymentslabel;
}

- (UILabel *)repaymentslabel1{
    if (!_repaymentslabel1) {
        
        _repaymentslabel1=[UILabel new];
        _repaymentslabel1.textColor=[UIColor whiteColor];
        _repaymentslabel1.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _repaymentslabel1.text=@"0.0";
        [self addSubview:_repaymentslabel1];
        _repaymentslabel1.sd_layout
        .centerXEqualToView(self)
        .heightIs(14)
        .topSpaceToView(_repaymentslabel, CGFloatIn320(14));
        [_repaymentslabel1 setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _repaymentslabel1;
}


- (UILabel *)repaymentslabel2{
    if (!_repaymentslabel2) {
        
        _repaymentslabel2=[UILabel new];
        _repaymentslabel2.textColor=[UIColor whiteColor];
        _repaymentslabel2.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _repaymentslabel2.text=@"未收合计:0.0元";
        [self addSubview:_repaymentslabel2];
        _repaymentslabel2.sd_layout
        .centerXEqualToView(self)
        .heightIs(12)
        .topSpaceToView(_repaymentslabel1, CGFloatIn320(14));
        [_repaymentslabel2 setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _repaymentslabel2;
}

- (UIView *)leftView{
    if (!_leftView) {
        
        _leftView=[UIView new];
        [self addSubview:_leftView];
        _leftView.sd_layout
        .leftSpaceToView(self, 0)
        .bottomSpaceToView(self, CGFloatIn320(25))
        .widthIs(SCREEN_WIDTH/2)
        .topSpaceToView(_repaymentslabel2, CGFloatIn320(40));
    }
    return _leftView;
}

- (UIView *)rightView{
    if (!_rightView) {
        
        _rightView=[UIView new];
        [self addSubview:_rightView];
        _rightView.sd_layout
        .rightSpaceToView(self, 0)
        .bottomSpaceToView(self, CGFloatIn320(25))
        .widthIs(SCREEN_WIDTH/2)
        .topSpaceToView(_repaymentslabel2, CGFloatIn320(40));
    }
    return _rightView;
}

- (UILabel *)investlabel{
    if (!_investlabel) {

        _investlabel=[UILabel new];
        _investlabel.textColor=[UIColor whiteColor];
        _investlabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _investlabel.text=@"投资本金(元)";
        [_leftView addSubview:_investlabel];
        _investlabel.sd_layout
        .centerXEqualToView(_leftView)
        .heightIs(14)
        .topSpaceToView(_leftView, 0);
        [_investlabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _investlabel;
}

- (UILabel *)investlabel1{
    if (!_investlabel1) {

        _investlabel1=[UILabel new];
        _investlabel1.textColor=[UIColor whiteColor];
        _investlabel1.font=[UIFont systemFontOfSize:CGFloatIn320(18)];
        _investlabel1.text=@"0.0";
        [_leftView addSubview:_investlabel1];
        _investlabel1.sd_layout
        .centerXEqualToView(_leftView)
        .heightIs(18)
        .topSpaceToView(_investlabel, CGFloatIn320(9));
        [_investlabel1 setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _investlabel1;
}


- (UILabel *)investlabel2{
    if (!_investlabel2) {

        _investlabel2=[UILabel new];
        _investlabel2.textColor=[UIColor whiteColor];
        _investlabel2.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _investlabel2.text=@"还款中:0.0元";
        [_leftView addSubview:_investlabel2];
        _investlabel2.sd_layout
        .centerXEqualToView(_leftView)
        .heightIs(12)
        .topSpaceToView(_investlabel1, CGFloatIn320(8));
        [_investlabel2 setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _investlabel2;
}



- (UILabel *)interestlabel{
    if (!_interestlabel) {
        
        _interestlabel=[UILabel new];
        _interestlabel.textColor=[UIColor whiteColor];
        _interestlabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _interestlabel.text=@"应收利息(元)";
        [_rightView addSubview:_interestlabel];
        _interestlabel.sd_layout
        .centerXEqualToView(_rightView)
        .heightIs(14)
        .topSpaceToView(_rightView, 0);
        [_interestlabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _interestlabel;
}

- (UILabel *)interestlabel1{
    if (!_interestlabel1) {
        
        _interestlabel1=[UILabel new];
        _interestlabel1.textColor=[UIColor whiteColor];
        _interestlabel1.font=[UIFont systemFontOfSize:CGFloatIn320(18)];
        _interestlabel1.text=@"0.0";
        [_rightView addSubview:_interestlabel1];
        _interestlabel1.sd_layout
        .centerXEqualToView(_rightView)
        .heightIs(18)
        .topSpaceToView(_interestlabel, CGFloatIn320(9));
        [_interestlabel1 setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _interestlabel1;
}


- (UILabel *)interestlabel2{
    if (!_interestlabel2) {
        
        _interestlabel2=[UILabel new];
        _interestlabel2.textColor=[UIColor whiteColor];
        _interestlabel2.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _interestlabel2.text=@"已收利息:0.0元";
        [_rightView addSubview:_interestlabel2];
        _interestlabel2.sd_layout
        .centerXEqualToView(_rightView)
        .heightIs(12)
        .topSpaceToView(_interestlabel1, CGFloatIn320(8));
        [_interestlabel2 setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _interestlabel2;
}
@end

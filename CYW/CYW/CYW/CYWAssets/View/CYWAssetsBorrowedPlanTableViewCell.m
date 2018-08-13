//
//  CYWAssetsBorrowedPlanTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/26.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsBorrowedPlanTableViewCell.h"
@interface CYWAssetsBorrowedPlanTableViewCell()
@property (nonatomic, retain) UIButton *repaymentsButton;
@property (nonatomic, retain) UILabel *namelabel;
@property (nonatomic, retain) UIImageView *claimsImageView;
@property (nonatomic, retain) UIImageView *amountimeImageView;
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) UIView *lineView1;
@property (nonatomic, retain) UILabel *moneylabel;
@property (nonatomic, retain) UILabel *timelabel;
@property (nonatomic, retain) UILabel *Interestlabel;
@property (nonatomic, retain) UIImageView *InterestImageView;

@property (nonatomic, retain) UILabel *repaymentslabel;
@property (nonatomic, retain) UIImageView *repaymentsImageView;
@property (nonatomic, retain) UIImageView *stateImageView;

@property (nonatomic, retain) UILabel *label;
@end
@implementation CYWAssetsBorrowedPlanTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self lineView];
        
        [self namelabel];
        [self repaymentsButton];
        [self lineView1];
        [self claimsImageView];
        [self amountimeImageView];
        [self moneylabel];
        [self timelabel];
        
        [self InterestImageView];
        [self Interestlabel];
        
        [self repaymentsImageView];
        [self repaymentslabel];
        [self stateImageView];
        [self label];
        
        [self initSubView];
        
    }
    return self;
}

- (void)setName:(NSString *)name{
    
    self.namelabel.text=name;
    [self.namelabel sizeToFit];
    
}
- (void)initSubView{
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(BorrowedPlanViewModel *viewModel) {
        
        @strongify(self);
        
        self.moneylabel.text=[NSString stringWithFormat:@"本金:%.2lf元",[viewModel.corpus floatValue]];
        [self.moneylabel sizeToFit];
        
        self.timelabel.text=[NSString stringWithFormat:@"利息:%.2lf元",[viewModel.interest floatValue]+[viewModel.corpus floatValue]];
        [self.timelabel sizeToFit];
        
        [self.repaymentsButton setTitle:[NSString stringWithFormat:@"第%zd期",[viewModel.period intValue]] forState:UIControlStateNormal];
        
        self.Interestlabel.text=[NSString stringWithFormat:@"手续费:%@元",[NSString isEmpty:viewModel.fee]?@"0":viewModel.fee];
        
        self.repaymentslabel.text=[NSString stringWithFormat:@"还款日:%@",[NSString isEmpty:viewModel.repayDay]?@"0":viewModel.repayDay];
        [self.repaymentslabel sizeToFit];
        if ([viewModel.status isEqualToString:@"repaying"]) {
            
            self.stateImageView.image=[UIImage imageNamed:@"还款中"];
            
            
        }else if ([viewModel.status isEqualToString:@"overdue"]){
            
            self.stateImageView.image=[UIImage imageNamed:@"逾期"];
        }
        else{
            
            self.stateImageView.image=[UIImage imageNamed:@"完成"];
        }
        
        if ([viewModel.repaying isEqualToString:@"1"]) {
            
            self.label.hidden=NO;
        }else{
            
            self.label.hidden=YES;
        }
        
    }];
}

- (UIView *)lineView{
    
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self.contentView addSubview:_lineView];
        _lineView.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0)
        .heightIs(CGFloatIn320(10));
    }
    return _lineView;
}

- (UIView *)lineView1{
    
    if (!_lineView1) {
        
        _lineView1=[UIView new];
        _lineView1.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self.contentView addSubview:_lineView1];
        _lineView1.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(_namelabel, CGFloatIn320(12))
        .heightIs(1);
    }
    return _lineView1;
}



- (UILabel *)namelabel{
    
    if (!_namelabel) {
        
        _namelabel=[UILabel new];
        _namelabel.text=@"水电费违法颠三倒四防守打法";
        _namelabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _namelabel.textColor=[UIColor colorWithHexString:@"#333333"];
        _namelabel.numberOfLines=0;
        [self.contentView addSubview:_namelabel];
        _namelabel.sd_layout
        .topSpaceToView(self.contentView, CGFloatIn320(12))
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .heightIs(14);
        [_namelabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _namelabel;
}

-(UIButton *)repaymentsButton{
    if (!_repaymentsButton) {
        
        _repaymentsButton=[UIButton new];
        [_repaymentsButton setTitle:@"还款计划" forState:UIControlStateNormal];
        _repaymentsButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(10)];
        [_repaymentsButton setTitleColor:[UIColor colorWithHexString:@"#ffc000"] forState:UIControlStateNormal];
        _repaymentsButton.layer.borderColor=[UIColor colorWithHexString:@"#ffc000"].CGColor;
        _repaymentsButton.layer.borderWidth=1.0f;
        _repaymentsButton.layer.cornerRadius=CGFloatIn320(9);
        [self.contentView addSubview:_repaymentsButton];
        _repaymentsButton.sd_layout
        .leftSpaceToView(_namelabel, CGFloatIn320(10))
        .topSpaceToView(self.contentView, CGFloatIn320(10))
        .widthIs(CGFloatIn320(55))
        .heightIs(CGFloatIn320(18));
    }
    return _repaymentsButton;
}

- (UIImageView *)claimsImageView{
    
    if (!_claimsImageView) {
        
        _claimsImageView=[UIImageView new];
        _claimsImageView.image=[UIImage imageNamed:@"icon_claims"];
        [self.contentView addSubview:_claimsImageView];
        _claimsImageView.sd_layout
        .leftEqualToView(_namelabel)
        .topSpaceToView(_namelabel, CGFloatIn320(30))
        .widthIs(CGFloatIn320(12))
        .heightIs(CGFloatIn320(13));
    }
    return _claimsImageView;
}


- (UILabel *)moneylabel{
    
    if (!_moneylabel) {
        
        _moneylabel=[UILabel new];
        _moneylabel.text=@"本金:水电费违法颠三倒四防守打法";
        _moneylabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _moneylabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [self.contentView addSubview:_moneylabel];
        _moneylabel.sd_layout
        .topSpaceToView(_namelabel, CGFloatIn320(30))
        .leftSpaceToView(_claimsImageView, CGFloatIn320(5))
        .heightIs(12);
        [_moneylabel setSingleLineAutoResizeWithMaxWidth:150];
    }
    return _moneylabel;
}

- (UIImageView *)amountimeImageView{
    
    if (!_amountimeImageView) {
        
        _amountimeImageView=[UIImageView new];
        _amountimeImageView.image=[UIImage imageNamed:@"本金利息"];
        [self.contentView addSubview:_amountimeImageView];
        _amountimeImageView.sd_layout
        .leftEqualToView(_namelabel)
        .topSpaceToView(_claimsImageView, CGFloatIn320(20))
        .widthIs(CGFloatIn320(12))
        .heightIs(CGFloatIn320(12));
    }
    return _amountimeImageView;
}

- (UILabel *)timelabel{
    
    if (!_timelabel) {
        
        _timelabel=[UILabel new];
        _timelabel.text=@"利息:2017-05-12";
        _timelabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _timelabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [self.contentView addSubview:_timelabel];
        _timelabel.sd_layout
        .topSpaceToView(_moneylabel, CGFloatIn320(22))
        .leftSpaceToView(_amountimeImageView, CGFloatIn320(5))
        .heightIs(12);
        [_timelabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _timelabel;
}



- (UIImageView *)InterestImageView{
    
    if (!_InterestImageView) {
        
        _InterestImageView=[UIImageView new];
        _InterestImageView.image=[UIImage imageNamed:@"手续费"];
        [self.contentView addSubview:_InterestImageView];
        _InterestImageView.sd_layout
        .topSpaceToView(_namelabel, CGFloatIn320(28))
        .centerXEqualToView(self.contentView)
        .widthIs(CGFloatIn320(14))
        .heightIs(CGFloatIn320(15));
    }
    return _InterestImageView;
}

- (UILabel *)Interestlabel{
    
    if (!_Interestlabel) {
        
        _Interestlabel=[UILabel new];
        _Interestlabel.text=@"手续费:12.5%";
        _Interestlabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _Interestlabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [self.contentView addSubview:_Interestlabel];
        _Interestlabel.sd_layout
        .topSpaceToView(_namelabel, CGFloatIn320(30))
        .leftSpaceToView(_InterestImageView, CGFloatIn320(5))
        .heightIs(12);
        [_Interestlabel setSingleLineAutoResizeWithMaxWidth:150];
    }
    return _Interestlabel;
}

- (UIImageView *)repaymentsImageView{
    
    if (!_repaymentsImageView) {
        
        _repaymentsImageView=[UIImageView new];
        _repaymentsImageView.image=[UIImage imageNamed:@"icon_amount_time"];
        [self.contentView addSubview:_repaymentsImageView];
        _repaymentsImageView.sd_layout
        .leftEqualToView(_InterestImageView)
        .topSpaceToView(_claimsImageView, CGFloatIn320(20))
        .widthIs(CGFloatIn320(14))
        .heightIs(CGFloatIn320(15));
    }
    return _repaymentsImageView;
}

- (UILabel *)repaymentslabel{
    
    if (!_repaymentslabel) {
        
        _repaymentslabel=[UILabel new];
        _repaymentslabel.text=@"还款日:2017-5-12";
        _repaymentslabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _repaymentslabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [self.contentView addSubview:_repaymentslabel];
        _repaymentslabel.sd_layout
        .topSpaceToView(_moneylabel, CGFloatIn320(22))
        .leftSpaceToView(_repaymentsImageView, CGFloatIn320(5))
        .heightIs(12);
        [_repaymentslabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _repaymentslabel;
}


- (UIImageView *)stateImageView{
    
    if (!_stateImageView) {
        
        _stateImageView=[UIImageView new];
        _stateImageView.image=[UIImage imageNamed:@"完成"];
        [self.contentView addSubview:_stateImageView];
        _stateImageView.sd_layout
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView,0)
        .widthIs(CGFloatIn320(40))
        .heightIs(CGFloatIn320(39));
    }
    return _stateImageView;
}


- (UILabel *)label{
    
    if (!_label) {
        
        _label=[UILabel new];
        _label.text=@"还款";
        _label.hidden=YES;
        _label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _label.textColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_label];
        _label.sd_layout
        .leftSpaceToView(_repaymentsButton, 15)
        .topSpaceToView(self.contentView, CGFloatIn320(10))
        .heightIs(14);
        [_label setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _label;
}
@end

//
//  CYWAssetsInvestTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsInvestTableViewCell.h"
@interface CYWAssetsInvestTableViewCell()
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

@property (nonatomic, retain) UIImageView *stateImageView;

@property (nonatomic, retain) UILabel *ratelabel;
@property (nonatomic, retain) UIImageView *rateImageView;
@end
@implementation CYWAssetsInvestTableViewCell

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
        [self Interestlabel];
        [self InterestImageView];
        [self stateImageView];
        [self ratelabel];
        [self rateImageView];
        [self initSubView];
        
        @weakify(self)
        [[self.repaymentsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
           
            @strongify(self)
            if (self.clickCell) {
                
                self.clickCell(self.indexPath);
            }
        }];
    }
    return self;
}

- (void)initSubView{
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(InvestViewModel *viewModel) {
        
        @strongify(self);
        
        self.namelabel.text=viewModel.loanName;
        [self.namelabel sizeToFit];
        
        self.moneylabel.text=[NSString stringWithFormat:@"投资金额:%@元",viewModel.investMoney];
        [self.moneylabel sizeToFit];
        
        self.timelabel.text=[NSString stringWithFormat:@"投资时间:%@",viewModel.time];
        [self.timelabel sizeToFit];
        
        self.Interestlabel.text=[NSString stringWithFormat:@"预期年化:%.2f%@",[viewModel.jdRate floatValue] * 100.00,@"%"];
        [self.Interestlabel sizeToFit];
        
        self.ratelabel.text=[NSString stringWithFormat:@"投资预期年化:%.2f%@",[viewModel.rate floatValue] * 100.00,@"%"];
        [self.ratelabel sizeToFit];
        
        
        if ([viewModel.status isEqualToString:@"bid_success"]) {
            
            self.stateImageView.image=[UIImage imageNamed:@"投资成"];
            [self.repaymentsButton setHidden:YES];
        }
        else if ([viewModel.status isEqualToString:@"repaying"]) {
            
            self.stateImageView.image=[UIImage imageNamed:@"还款中"];
            [self.repaymentsButton setHidden:NO];
        }
        else if ([viewModel.status isEqualToString:@"complete"]) {
            
            self.stateImageView.image=[UIImage imageNamed:@"已完结"];
            [self.repaymentsButton setHidden:YES];
        }
        else if ([viewModel.status isEqualToString:@"cancel"]) {
            
            self.stateImageView.image=[UIImage imageNamed:@"失败"];
            [self.repaymentsButton setHidden:YES];
        }
        else if ([viewModel.status isEqualToString:@"wait_affirm"]) {
            
            self.stateImageView.image=[UIImage imageNamed:@"等待付款"];
            [self.repaymentsButton setHidden:YES];
        }
        else if ([viewModel.status isEqualToString:@"transfered"]) {
            
            self.stateImageView.image=[UIImage imageNamed:@"已转让"];
            [self.repaymentsButton setHidden:YES];
        }
        else if ([viewModel.status isEqualToString:@"overdue"]) {
            
            self.stateImageView.image=[UIImage imageNamed:@"逾期"];
            [self.repaymentsButton setHidden:YES];
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

-(UIButton *)repaymentsButton{
    if (!_repaymentsButton) {
        
        _repaymentsButton=[UIButton new];
        [_repaymentsButton setHidden:YES];
        [_repaymentsButton setTitle:@"还款计划" forState:UIControlStateNormal];
        _repaymentsButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [_repaymentsButton setTitleColor:[UIColor colorWithHexString:@"#ffc000"] forState:UIControlStateNormal];
        _repaymentsButton.layer.borderColor=[UIColor colorWithHexString:@"#ffc000"].CGColor;
        _repaymentsButton.layer.borderWidth=1.0f;
        _repaymentsButton.layer.cornerRadius=CGFloatIn320(12);
        [self.contentView addSubview:_repaymentsButton];
        _repaymentsButton.sd_layout
        .leftSpaceToView(_namelabel, CGFloatIn320(10))
        .topSpaceToView(self.contentView, CGFloatIn320(10))
        .widthIs(CGFloatIn320(60))
        .heightIs(CGFloatIn320(24));
    }
    return _repaymentsButton;
}

- (UILabel *)namelabel{
    
    if (!_namelabel) {
        
        _namelabel=[UILabel new];
        _namelabel.text=@"水电费违法颠三倒四防守打法";
        _namelabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _namelabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_namelabel];
        _namelabel.sd_layout
        .topSpaceToView(self.contentView, CGFloatIn320(12))
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .heightIs(14);
        [_namelabel setSingleLineAutoResizeWithMaxWidth:250];
    }
    return _namelabel;
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
        _moneylabel.text=@"投资金额:水电费违法颠三倒四防守打法";
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
        _amountimeImageView.image=[UIImage imageNamed:@"icon_amount_time"];
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
        _timelabel.text=@"投资时间:2017-05-12";
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

- (UILabel *)Interestlabel{
    
    if (!_Interestlabel) {
        
        _Interestlabel=[UILabel new];
        _Interestlabel.text=@"预期年化率:12.5%";
        _Interestlabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _Interestlabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [self.contentView addSubview:_Interestlabel];
        _Interestlabel.sd_layout
        .topSpaceToView(_namelabel, CGFloatIn320(30))
        .rightSpaceToView(self.contentView, CGFloatIn320(28))
        .heightIs(12);
        [_Interestlabel setSingleLineAutoResizeWithMaxWidth:150];
    }
    return _Interestlabel;
}

- (UIImageView *)InterestImageView{
    
    if (!_InterestImageView) {
        
        _InterestImageView=[UIImageView new];
        _InterestImageView.image=[UIImage imageNamed:@"icon_Interest-1"];
        [self.contentView addSubview:_InterestImageView];
        _InterestImageView.sd_layout
        .topSpaceToView(_namelabel, CGFloatIn320(28))
        .rightSpaceToView(_Interestlabel, CGFloatIn320(5))
        .widthIs(CGFloatIn320(14))
        .heightIs(CGFloatIn320(15));
    }
    return _InterestImageView;
}


- (UILabel *)ratelabel{
    
    if (!_ratelabel) {
        
        _ratelabel=[UILabel new];
        _ratelabel.text=@"投资时间:2017-05-12";
        _ratelabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _ratelabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [self.contentView addSubview:_ratelabel];
        _ratelabel.sd_layout
        .topSpaceToView(_Interestlabel, CGFloatIn320(22))
        .rightSpaceToView(self.contentView, 3)
        .heightIs(12);
        [_ratelabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _ratelabel;
}

- (UIImageView *)rateImageView{
    
    if (!_rateImageView) {
        
        _rateImageView=[UIImageView new];
        _rateImageView.image=[UIImage imageNamed:@"icon_Interest-1"];
        [self.contentView addSubview:_rateImageView];
        _rateImageView.sd_layout
        .topSpaceToView(_InterestImageView, CGFloatIn320(20))
        .rightSpaceToView(_ratelabel, CGFloatIn320(5))
        .widthIs(CGFloatIn320(14))
        .heightIs(CGFloatIn320(15));
    }
    return _rateImageView;
}





- (UIImageView *)stateImageView{
    
    if (!_stateImageView) {
        
        _stateImageView=[UIImageView new];
        _stateImageView.image=[UIImage imageNamed:@"完成"];
        [self.contentView addSubview:_stateImageView];
        _stateImageView.sd_layout
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView,0)
        .widthIs(CGFloatIn320(50))
        .heightIs(CGFloatIn320(55));
    }
    return _stateImageView;
}
@end

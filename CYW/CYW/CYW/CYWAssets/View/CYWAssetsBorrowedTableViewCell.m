//
//  CYWAssetsBorrowedTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/19.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsBorrowedTableViewCell.h"
@interface CYWAssetsBorrowedTableViewCell()
@property (nonatomic, retain) UILabel *browedtimelabel;
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) UILabel *Interestlabel1;
@property (nonatomic, retain) UILabel *Interestlabel2;
@property (nonatomic, retain) UIImageView *amountimeImageView;
@property (nonatomic, retain) UILabel *browedNamelabel;
@property (nonatomic, retain) UIImageView *amountImageView;
@property (nonatomic, retain) UILabel *browedMoneylabel;
@property (nonatomic, retain) UIImageView *amountimeImageView1;
@property (nonatomic, retain) UILabel *browedDaylabel;
@property (nonatomic, retain) UIView *lineView2;
@property (nonatomic, retain) UIButton *repaymentsButton;
@end
@implementation CYWAssetsBorrowedTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self browedtimelabel];
        [self repaymentsButton];
        [self lineView];
        [self Interestlabel1];
        [self Interestlabel2];
        [self amountimeImageView];
        [self browedNamelabel];
        
        [self amountImageView];
        [self browedMoneylabel];
        [self amountimeImageView1];
        [self browedDaylabel];
        [self lineView2];
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(ProjectViewModel *viewModel) {
        
        InvestRepayRoadmapViewModel *mapModel=(InvestRepayRoadmapViewModel *)viewModel.repayRoadmap;
        @strongify(self);
        self.Interestlabel1.sd_layout.maxHeightIs(40);
         NSString *bfb=[NSString stringWithFormat:@"%.2f%%",viewModel.jkRate* 100.00];
        self.Interestlabel1.attributedText = [NSMutableAttributedString withTitleString:bfb RangeString:[NSString stringWithFormat:@"%.2f",viewModel.jkRate * 100.00] color:[UIColor colorWithHexString:@"#f52735"] withFont:[UIFont systemFontOfSize:CGFloatIn320(18)]];
        [self.Interestlabel1 sizeToFit];
        
        
        if (0==[[[NSUserDefaults standardUserDefaults] objectForKey:@"browedkey"] integerValue]) {
            
            [self.repaymentsButton setHidden:NO];
            self.browedtimelabel.text=viewModel.name;
            [self.browedtimelabel sizeToFit];
            
            
            self.browedNamelabel.text=[NSString stringWithFormat:@"放款时间: %@",viewModel.giveMoneyTime];
            [self.browedNamelabel sizeToFit];
            
            NSString *money=[NSString isEmpty:viewModel.loanMoney]?@"0":viewModel.loanMoney;
            [self.browedMoneylabel setAttributedText:[NSMutableAttributedString
                                                      withTitleString:[NSString stringWithFormat:@"借款金额:%.2lf元",[money floatValue]]
                                                      RangeString:[NSString stringWithFormat:@"%.2lf",[money floatValue]]
                                                      ormoreString:nil
                                                      color:[UIColor colorWithHexString:@"#f52735"]]];
            
            self.browedDaylabel.text=[NSString stringWithFormat:@"还清时间: %@",[[mapModel.nextRepayDate componentsSeparatedByString:@" "] firstObject]];
            [self.browedDaylabel sizeToFit];
            
            
        }else if (1==[[[NSUserDefaults standardUserDefaults] objectForKey:@"browedkey"] integerValue]){
            [self.repaymentsButton setHidden:YES];
            self.browedtimelabel.text=viewModel.name;
            [self.browedtimelabel sizeToFit];
            
            
            self.browedNamelabel.text=[NSString stringWithFormat:@"发标时间: %@",viewModel.verifyTime];
            [self.browedNamelabel sizeToFit];
            
            NSString *money=[NSString isEmpty:viewModel.loanMoney]?@"0":viewModel.loanMoney;
            [self.browedMoneylabel setAttributedText:[NSMutableAttributedString
                                                      withTitleString:[NSString stringWithFormat:@"借款金额:%.2lf元",[money floatValue]]
                                                      RangeString:[NSString stringWithFormat:@"%.2lf",[money floatValue]]
                                                      ormoreString:nil
                                                      color:[UIColor colorWithHexString:@"#f52735"]]];
            [self.browedMoneylabel sizeToFit];
            
            NSString *day=[NSString isEmpty:viewModel.repayDay]?@"0":viewModel.repayDay;
            [self.browedDaylabel setAttributedText:[NSMutableAttributedString
                                                      withTitleString:[NSString stringWithFormat:@"期限:%@天",day]
                                                      RangeString:day
                                                      ormoreString:nil
                                                      color:[UIColor colorWithHexString:@"#f52735"]]];
            [self.browedDaylabel sizeToFit];
            
        }else if (2==[[[NSUserDefaults standardUserDefaults] objectForKey:@"browedkey"] integerValue]){
            
            
            [self.repaymentsButton setHidden:YES];
            self.browedtimelabel.text=viewModel.name;
            [self.browedtimelabel sizeToFit];
            
            
            self.browedNamelabel.text=[NSString stringWithFormat:@"完结时间: %@",viewModel.completeTime];
            [self.browedNamelabel sizeToFit];
            
            NSString *day=[NSString isEmpty:mapModel.paidCorpus]?@"0":mapModel.paidCorpus;
            NSString *money=[NSString isEmpty:mapModel.paidInterest]?@"0":mapModel.paidInterest;
            
            [self.browedMoneylabel setAttributedText:[NSMutableAttributedString
                                                    withTitleString:[NSString stringWithFormat:@"放款金额:%.2lf元",[day floatValue]+[money floatValue]]
                                                    RangeString:[NSString stringWithFormat:@"%.2lf",[day floatValue]+[money floatValue]]
                                                    ormoreString:nil
                                                    color:[UIColor colorWithHexString:@"#f52735"]]];
            
            [self.browedMoneylabel sizeToFit];
            
            
            //repayDay
            
            self.browedDaylabel.text=[NSString stringWithFormat:@"还清时间: %@",[[viewModel.completeTime componentsSeparatedByString:@" "] firstObject]];
            [self.browedDaylabel sizeToFit];
            
        }
        else if (3==[[[NSUserDefaults standardUserDefaults] objectForKey:@"browedkey"] integerValue]){
            [self.repaymentsButton setHidden:YES];
            self.browedtimelabel.text=viewModel.name;
            [self.browedtimelabel sizeToFit];
            
            
            self.browedNamelabel.text=[NSString stringWithFormat:@"流标时间: %@",viewModel.cancelTime];
            [self.browedNamelabel sizeToFit];
            
            
            NSString *day=[NSString isEmpty:viewModel.loanMoney]?@"0":viewModel.loanMoney;
            [self.browedMoneylabel setAttributedText:[NSMutableAttributedString
                                                      withTitleString:[NSString stringWithFormat:@"借款金额:%.2lf元",[day floatValue]]
                                                      RangeString:[NSString stringWithFormat:@"%.2lf",[day floatValue]]
                                                      ormoreString:nil
                                                      color:[UIColor colorWithHexString:@"#f52735"]]];
            [self.browedMoneylabel sizeToFit];
            
            
            //repayDay
            
            self.browedDaylabel.text=[NSString stringWithFormat:@"投资状态: %@",viewModel.status];
            [self.browedDaylabel sizeToFit];
        }
        
    }];
    
    
    [[self.repaymentsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
       
        if (self.borrowedTableViewcell) {
            
            self.borrowedTableViewcell(self.indexPath);
        }
    }];
    
}




- (UILabel *)browedtimelabel{
    if (!_browedtimelabel) {
        _browedtimelabel=[UILabel new];
        _browedtimelabel.text=@"借款时间: 2017-05-01  15:52:22";
        _browedtimelabel.textColor=[UIColor colorWithHexString:@"#333333"];
        _browedtimelabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [self.contentView addSubview:_browedtimelabel];
        _browedtimelabel.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(8))
        .topSpaceToView(self.contentView, CGFloatIn320(14))
        .heightIs(12);
        [_browedtimelabel setSingleLineAutoResizeWithMaxWidth:300];
        
    }
    return _browedtimelabel;
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
        .rightSpaceToView(self.contentView, 11)
        .topSpaceToView(self.contentView, CGFloatIn320(10))
        .widthIs(CGFloatIn320(55))
        .heightIs(CGFloatIn320(18));
    }
    return _repaymentsButton;
}

- (UIView *)lineView{
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self.contentView addSubview:_lineView];
        _lineView.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(1)
        .topSpaceToView(_browedtimelabel, CGFloatIn320(9));
    }
    return _lineView;
}

- (UILabel *)Interestlabel1{
    
    if (!_Interestlabel1) {
        
        _Interestlabel1=[UILabel new];
        _Interestlabel1.text=@"预期年化";
        _Interestlabel1.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _Interestlabel1.textColor=[UIColor colorWithHexString:@"#666666"];
        _Interestlabel1.numberOfLines=0;
        [self.contentView addSubview:_Interestlabel1];
        _Interestlabel1.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(5))
        .centerYEqualToView(self.contentView)
        .autoHeightRatio(0);
        [_Interestlabel1 setSingleLineAutoResizeWithMaxWidth:80];
    }
    return _Interestlabel1;
}
- (UILabel *)Interestlabel2{
    
    if (!_Interestlabel2) {
        
        _Interestlabel2=[UILabel new];
        _Interestlabel2.text=@"预期年化";
        _Interestlabel2.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _Interestlabel2.textColor=[UIColor colorWithHexString:@"#666666"];
        _Interestlabel2.numberOfLines=0;
        [self.contentView addSubview:_Interestlabel2];
        _Interestlabel2.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(5))
        .topSpaceToView(_Interestlabel1, 10)
        .heightIs(14);
        [_Interestlabel2 setSingleLineAutoResizeWithMaxWidth:80];
    }
    return _Interestlabel2;
}


///////////////////// 时间

- (UIImageView *)amountimeImageView{
    
    if (!_amountimeImageView) {
        
        _amountimeImageView=[UIImageView new];
        _amountimeImageView.image=[UIImage imageNamed:@"icon_amount_time"];
        [self.contentView addSubview:_amountimeImageView];
        _amountimeImageView.sd_layout
        .leftSpaceToView(_Interestlabel2, 15)
        .topSpaceToView(_lineView, 10)
        .widthIs(CGFloatIn320(12))
        .heightIs(CGFloatIn320(12));
    }
    return _amountimeImageView;
}
- (UILabel *)browedNamelabel{
    if (!_browedNamelabel) {
        _browedNamelabel=[UILabel new];
        _browedNamelabel.text=@"借款时间: 2017-05-01  15:52:22";
        _browedNamelabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _browedNamelabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [self.contentView addSubview:_browedNamelabel];
        _browedNamelabel.sd_layout
        .leftSpaceToView(_amountimeImageView, 5)
        .topSpaceToView(_lineView, 10)
        .autoHeightRatio(0)
        .rightSpaceToView(self.contentView, CGFloatIn320(8));
        
    }
    return _browedNamelabel;
}

- (UIImageView *)amountImageView{
    
    if (!_amountImageView) {
        
        _amountImageView=[UIImageView new];
        _amountImageView.image=[UIImage imageNamed:@"icon_amount"];
        [self.contentView addSubview:_amountImageView];
        _amountImageView.sd_layout
        .leftEqualToView(_amountimeImageView)
        .topSpaceToView(_browedNamelabel, 15)
        .widthIs(CGFloatIn320(16))
        .heightIs(CGFloatIn320(12));
    }
    return _amountImageView;
}
- (UILabel *)browedMoneylabel{
    if (!_browedMoneylabel) {
        _browedMoneylabel=[UILabel new];
        _browedMoneylabel.text=@"借款总额:10 万";
        _browedMoneylabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _browedMoneylabel.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        [self.contentView addSubview:_browedMoneylabel];
        _browedMoneylabel.sd_layout
        .leftSpaceToView(_amountImageView, 5)
        .topSpaceToView(_browedNamelabel, 15)
        .heightIs(11);
        [_browedMoneylabel setSingleLineAutoResizeWithMaxWidth:200];
        
    }
    return _browedMoneylabel;
}


- (UIImageView *)amountimeImageView1{
    
    if (!_amountimeImageView1) {
        
        _amountimeImageView1=[UIImageView new];
        _amountimeImageView1.image=[UIImage imageNamed:@"icon_amount_time"];
        [self.contentView addSubview:_amountimeImageView1];
        _amountimeImageView1.sd_layout
        .leftEqualToView(_amountImageView)
        .topSpaceToView(_browedMoneylabel, 15)
        .widthIs(CGFloatIn320(12))
        .heightIs(CGFloatIn320(12));
    }
    return _amountimeImageView1;
}
- (UILabel *)browedDaylabel{
    if (!_browedDaylabel) {
        _browedDaylabel=[UILabel new];
        _browedDaylabel.text=@"期限:63天";
        _browedDaylabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _browedDaylabel.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        [self.contentView addSubview:_browedDaylabel];
        _browedDaylabel.sd_layout
        .topSpaceToView(_browedMoneylabel, 15)
        .heightIs(11)
        .leftSpaceToView(_amountimeImageView1, 5);
        [_browedDaylabel setSingleLineAutoResizeWithMaxWidth:200];
        
    }
    return _browedDaylabel;
}
- (UIView *)lineView2{
    if (!_lineView2) {
        
        _lineView2=[UIView new];
        _lineView2.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self.contentView addSubview:_lineView2];
        _lineView2.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(10)
        .bottomSpaceToView(self.contentView, 0);
    }
    return _lineView2;
}
@end

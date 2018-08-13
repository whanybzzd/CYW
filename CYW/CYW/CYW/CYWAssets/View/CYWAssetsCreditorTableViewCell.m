//
//  CYWAssetsCreditorTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsCreditorTableViewCell.h"
@interface CYWAssetsCreditorTableViewCell()
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) UIView *lineView1;
@property (nonatomic, retain) UILabel *namelabel;
@property (nonatomic, retain) UILabel *lookDetailabel;
@property (nonatomic, retain) UILabel *Interestlabel;
@property (nonatomic, retain) UILabel *Interestlabel1;
@property (nonatomic, retain) UIImageView *amountImageView;
@property (nonatomic, retain) UILabel *amountlabel;

@property (nonatomic, retain) UIImageView *claimsImageView;
@property (nonatomic, retain) UILabel *claimslabel;

@property (nonatomic, retain) UIImageView *amountimeImageView;
@property (nonatomic, retain) UILabel *amountimelabel;
@property (nonatomic, strong) UILabel *lookTime;
@property (nonatomic, strong) UIButton *extensionButton;
@end
@implementation CYWAssetsCreditorTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self lineView];
        [self namelabel];
        [self lookDetailabel];
        [self lookTime];
        [self lineView1];
        [self Interestlabel];
        [self Interestlabel1];
        
        [self amountImageView];
        [self amountlabel];
        
        [self claimsImageView];
        [self claimslabel];
        
        [self amountimeImageView];
        [self amountimelabel];
        [self extensionButton];
        [self initSubView];
        [self initSubViews];
    }
    return self;
}

- (void)initSubView{
    @weakify(self)
        UITapGestureRecognizer *forgetTap1=[[UITapGestureRecognizer alloc] init];
        [[forgetTap1 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
    
            @strongify(self)
            if ([self.delegate respondsToSelector:@selector(tableViewCellIdenti:indexPath:)]) {
    
                [self.delegate tableViewCellIdenti:@"lookDetail" indexPath:self.indexPath];
            }
        }];
        [self.lookDetailabel addGestureRecognizer:forgetTap1];
    
    
        [[self.extensionButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
    
             @strongify(self)
            if ([self.delegate respondsToSelector:@selector(tableViewCellIdenti:indexPath:)]) {
    
                [self.delegate tableViewCellIdenti:@"extenButton" indexPath:self.indexPath];
            }
        }];
    
}


- (void)initSubViews{

    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(CreditorViewModel *viewModel) {

        @strongify(self);
        //名称
        self.namelabel.text=viewModel.loanName;
        [self.namelabel sizeToFit];
        self.Interestlabel1.sd_layout.maxHeightIs(40);

        NSString *bfb=[NSString stringWithFormat:@"%.2f%%",[viewModel.rate floatValue] * 100.00];


        self.Interestlabel.attributedText = [NSMutableAttributedString withTitleString:bfb RangeString:[NSString stringWithFormat:@"%.2f",[viewModel.rate floatValue] * 100.00] color:[UIColor colorWithHexString:@"#f52735"] withFont:[UIFont systemFontOfSize:CGFloatIn320(18)]];
        [self.Interestlabel sizeToFit];






        if (0==[[[NSUserDefaults standardUserDefaults] objectForKey:@"keys"] integerValue]) {

            [self.lookDetailabel setHidden:NO];
            [self.lookTime setHidden:YES];
            [self.extensionButton setHidden:YES];
            self.Interestlabel1.text=@"预期年化率";
            NSString *amount=[viewModel.investMoney floatValue]>10000?[NSString stringWithFormat:@"投资总额:%.2lf万元",[viewModel.investMoney floatValue]/10000]:[NSString stringWithFormat:@"投资总额:%.2lf元",[viewModel.investMoney floatValue]];
            //投资总额
            self.amountlabel.text=amount;
            [self.amountlabel sizeToFit];

            //投资时间
            self.amountimelabel.text=[NSString stringWithFormat:@"投资时间:%@",viewModel.investTime];
            [self.amountimelabel sizeToFit];

            //代收本息
            self.claimslabel.text=[NSString stringWithFormat:@"代收本息:%.2lf元",[viewModel.unPaidMoney floatValue]];
            [self.claimslabel sizeToFit];


        }else if (1==[[[NSUserDefaults standardUserDefaults] objectForKey:@"keys"] integerValue]){

            [self.lookDetailabel setHidden:NO];
            [self.lookTime setHidden:YES];
            [self.extensionButton setHidden:YES];
             self.Interestlabel1.text=@"预期年化率";
            NSString *amount=[viewModel.investMoney floatValue]>10000?[NSString stringWithFormat:@"投资总额:%.2lf万元",[viewModel.investMoney floatValue]/10000]:[NSString stringWithFormat:@"投资总额:%.2lf元",[viewModel.investMoney floatValue]];
            //投资总额
            self.amountlabel.text=amount;
            [self.amountlabel sizeToFit];

            //投资时间
            self.amountimelabel.text=[NSString stringWithFormat:@"投资时间:%@",viewModel.investTime];
            [self.amountimelabel sizeToFit];

            //债权价值
            NSString *claims=[viewModel.investMoney floatValue]>10000?[NSString stringWithFormat:@"债权价值:%.2lf万元",[viewModel.debitWorth floatValue]/10000]:[NSString stringWithFormat:@"债权价值:%.2lf元",[viewModel.debitWorth floatValue]];
            self.claimslabel.text=claims;
            [self.claimslabel sizeToFit];
        }
        else if (2==[[[NSUserDefaults standardUserDefaults] objectForKey:@"keys"] integerValue]){

            [self.lookDetailabel setHidden:YES];
            [self.lookTime setHidden:YES];
            [self.extensionButton setHidden:YES];
             self.Interestlabel1.text=@"预期年化率";
            //transferWorth
            NSString *claims=[viewModel.investMoney floatValue]>10000?[NSString stringWithFormat:@"债权价值:%.2lf万元",[viewModel.debitWorth floatValue]/10000]:[NSString stringWithFormat:@"债权价值:%.2lf元",[viewModel.debitWorth floatValue]];
            self.claimslabel.text=claims;
            [self.claimslabel sizeToFit];

            //到期时间
            self.amountimelabel.text=[NSString stringWithFormat:@"到期时间:%@",viewModel.deadline];
            [self.amountimelabel sizeToFit];

            //利率
            self.amountlabel.text=[NSString stringWithFormat:@"利率:%.2f",[viewModel.rate floatValue] * 100.00];
            [self.amountlabel sizeToFit];



        }
        else if (3==[[[NSUserDefaults standardUserDefaults] objectForKey:@"keys"] integerValue]){

            [self.lookDetailabel setHidden:YES];
            [self.lookTime setHidden:YES];
            [self.extensionButton setHidden:YES];
             self.Interestlabel1.text=@"预期年化率";
            //转让本金
            self.amountlabel.text=[NSString stringWithFormat:@"转让本金:%.2lf元",[viewModel.transferCorpus floatValue]];
            [self.amountlabel sizeToFit];

            //转让金
            self.claimslabel.text=[NSString stringWithFormat:@"转让金:%.2lf元",[viewModel.premium floatValue]];
            [self.claimslabel sizeToFit];


            //到期时间
            self.amountimelabel.text=[NSString stringWithFormat:@"到期时间:%@",viewModel.deadline];
            [self.amountimelabel sizeToFit];

        }else if (4==[[[NSUserDefaults standardUserDefaults] objectForKey:@"keys"] integerValue]){

            [self.lookTime setHidden:NO];
            [self.lookDetailabel setHidden:YES];
            [self.extensionButton setHidden:NO];
             self.Interestlabel1.text=@"展期年化率";

            NSString *amount=[viewModel.investMoney floatValue]>10000?[NSString stringWithFormat:@"投资总额:%.2lf万元",[viewModel.investMoney floatValue]/10000]:[NSString stringWithFormat:@"投资总额:%.2lf元",[viewModel.investMoney floatValue]];
            //投资总额
            self.amountlabel.text=amount;
            [self.amountlabel sizeToFit];

            //投资时间
            self.amountimelabel.text=[NSString stringWithFormat:@"投资时间:%@",viewModel.investTime];
            [self.amountimelabel sizeToFit];

            //债权价值
            NSString *claims=[viewModel.investMoney floatValue]>10000?[NSString stringWithFormat:@"展期价值:%.2lf万元",[viewModel.debitWorth floatValue]/10000]:[NSString stringWithFormat:@"展期价值:%.2lf元",[viewModel.debitWorth floatValue]];
            self.claimslabel.text=claims;
            [self.claimslabel sizeToFit];


            self.lookTime.text=[NSString stringWithFormat:@"展期期限:%@月",viewModel.extensionPeriod];
            [self.lookTime sizeToFit];

            NSString *bfb1=[NSString stringWithFormat:@"%.2f%%",[viewModel.extensionRate floatValue] * 100.00];
            self.Interestlabel.attributedText = [NSMutableAttributedString withTitleString:bfb1 RangeString:[NSString stringWithFormat:@"%.2f",[viewModel.extensionRate floatValue] * 100.00] color:[UIColor colorWithHexString:@"#f52735"] withFont:[UIFont systemFontOfSize:CGFloatIn320(18)]];
            [self.Interestlabel sizeToFit];


            //状态判断 不可转让状态
            BOOL status=[viewModel.extensionStatus isEqualToString:@"extensioning"]||[viewModel.extensionStatus isEqualToString:@"repaying"];
            self.extensionButton.userInteractionEnabled=!status;

            self.extensionButton.backgroundColor=status?[UIColor lightGrayColor]:[UIColor colorWithHexString:@"#f52735"];


        }

    }];


}

#pragma mark --懒加载
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

- (UIButton *)extensionButton{
    
    if (!_extensionButton) {
        
        _extensionButton=[UIButton new];
        [_extensionButton setTitle:@"可转让" forState:UIControlStateNormal];
        [_extensionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _extensionButton.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
        _extensionButton.layer.cornerRadius=17.5;
        _extensionButton.titleLabel.font=[UIFont systemFontOfSize:15];
        [self.contentView addSubview:_extensionButton];
        _extensionButton.sd_layout
        .leftSpaceToView(self.contentView, 60)
        .rightSpaceToView(self.contentView, 60)
        .heightIs(35)
        .bottomSpaceToView(_lineView, 10);
    }
    return _extensionButton;
}

- (UILabel *)namelabel{
    
    if (!_namelabel) {
        
        _namelabel=[UILabel new];
        _namelabel.text=@"投资红包";
        _namelabel.font=[UIFont systemFontOfSize:CGFloatIn320(16)];
        _namelabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_namelabel];
        _namelabel.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .topSpaceToView(self.contentView, CGFloatIn320(17))
        .heightIs(16);
        [_namelabel setSingleLineAutoResizeWithMaxWidth:250];
    }
    return _namelabel;
}

- (UILabel *)lookDetailabel{
    
    if (!_lookDetailabel) {
        
        _lookDetailabel=[UILabel new];
        _lookDetailabel.text=@"查看详情";
        _lookDetailabel.userInteractionEnabled=YES;
        _lookDetailabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _lookDetailabel.textColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_lookDetailabel];
        _lookDetailabel.sd_layout
        .rightSpaceToView(self.contentView, 5)
        .topSpaceToView(self.contentView, CGFloatIn320(19))
        .heightIs(12);
        [_lookDetailabel setSingleLineAutoResizeWithMaxWidth:200];
        
        // 下划线
        NSDictionary *attribtDic = @{NSUnderlineStyleAttributeName: [NSNumber numberWithInteger:NSUnderlineStyleSingle]};
        NSMutableAttributedString *attribtStr = [[NSMutableAttributedString alloc]initWithString:@"查看详情" attributes:attribtDic];
        _lookDetailabel.attributedText = attribtStr;
    }
    return _lookDetailabel;
}
- (UILabel *)lookTime{
    
    if (!_lookTime) {
        
        _lookTime=[UILabel new];
        _lookTime.text=@"展期期限月份(4)";
        _lookTime.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _lookTime.textColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_lookTime];
        _lookTime.sd_layout
        .rightSpaceToView(self.contentView, 5)
        .topSpaceToView(self.contentView, CGFloatIn320(19))
        .heightIs(12);
        [_lookTime setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _lookTime;
}
- (UIView *)lineView1{
    if (!_lineView1) {
        
        _lineView1=[UIView new];
        _lineView1.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self.contentView addSubview:_lineView1];
        _lineView1.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(_lookDetailabel, CGFloatIn320(12))
        .heightIs(1);
    }
    return _lineView1;
}

- (UILabel *)Interestlabel{
    
    if (!_Interestlabel) {
        
        _Interestlabel=[UILabel new];
        _Interestlabel.text=@"14.8%";
        _Interestlabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _Interestlabel.textColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_Interestlabel];
        _Interestlabel.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(15))
        .topSpaceToView(_namelabel, CGFloatIn320(30))
        .heightIs(18);
        [_Interestlabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
    }
    return _Interestlabel;
}

- (UILabel *)Interestlabel1{
    
    if (!_Interestlabel1) {
        
        _Interestlabel1=[UILabel new];
        _Interestlabel1.text=@"预期年化率";
        _Interestlabel1.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _Interestlabel1.textColor=[UIColor colorWithHexString:@"#666666"];
        _Interestlabel1.numberOfLines=0;
        [self.contentView addSubview:_Interestlabel1];
        _Interestlabel1.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(5))
        .topSpaceToView(_Interestlabel, CGFloatIn320(6))
        .autoHeightRatio(0);
        [_Interestlabel1 setSingleLineAutoResizeWithMaxWidth:80];
    }
    return _Interestlabel1;
}

- (UIImageView *)amountImageView{
    
    if (!_amountImageView) {
        
        _amountImageView=[UIImageView new];
        _amountImageView.image=[UIImage imageNamed:@"icon_amount"];
        [self.contentView addSubview:_amountImageView];
        _amountImageView.sd_layout
        .leftSpaceToView(_Interestlabel, CGFloatIn320(12))
        .topSpaceToView(_lineView1, 9)
        .widthIs(CGFloatIn320(16))
        .heightIs(CGFloatIn320(12));
    }
    return _amountImageView;
}

- (UILabel *)amountlabel{
    
    if (!_amountlabel) {
        
        _amountlabel=[UILabel new];
        _amountlabel.text=@"投资总额:1元";
        _amountlabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _amountlabel.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_amountlabel];
        _amountlabel.sd_layout
        .leftSpaceToView(_amountImageView, CGFloatIn320(5))
        .topEqualToView(_amountImageView)
        .heightIs(12);
        [_amountlabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _amountlabel;
}

- (UIImageView *)claimsImageView{
    
    if (!_claimsImageView) {
        
        _claimsImageView=[UIImageView new];
        _claimsImageView.image=[UIImage imageNamed:@"icon_claims"];
        [self.contentView addSubview:_claimsImageView];
        _claimsImageView.sd_layout
        .leftEqualToView(_amountImageView)
        .topSpaceToView(_amountlabel, CGFloatIn320(19))
        .widthIs(CGFloatIn320(12))
        .heightIs(CGFloatIn320(13));
    }
    return _claimsImageView;
}

- (UILabel *)claimslabel{
    
    if (!_claimslabel) {
        
        _claimslabel=[UILabel new];
        _claimslabel.text=@"债权价值:1元";
        _claimslabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _claimslabel.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_claimslabel];
        _claimslabel.sd_layout
        .leftSpaceToView(_claimsImageView, CGFloatIn320(5))
       .topSpaceToView(_amountlabel, CGFloatIn320(19))
        .heightIs(12);
        [_claimslabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _claimslabel;
}

- (UIImageView *)amountimeImageView{
    
    if (!_amountimeImageView) {
        
        _amountimeImageView=[UIImageView new];
        _amountimeImageView.image=[UIImage imageNamed:@"icon_amount_time"];
        [self.contentView addSubview:_amountimeImageView];
        _amountimeImageView.sd_layout
        .leftEqualToView(_amountImageView)
        .topSpaceToView(_claimslabel, CGFloatIn320(15))
        .widthIs(CGFloatIn320(12))
        .heightIs(CGFloatIn320(12));
    }
    return _amountimeImageView;
}

- (UILabel *)amountimelabel{
    
    if (!_amountimelabel) {
        
        _amountimelabel=[UILabel new];
        _amountimelabel.text=@"投资时间:2017-02-12";
        _amountimelabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _amountimelabel.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_amountimelabel];
        _amountimelabel.sd_layout
        .leftSpaceToView(_amountimeImageView, CGFloatIn320(5))
        .topSpaceToView(_claimslabel, CGFloatIn320(15))
        .heightIs(12);
        [_amountimelabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _amountimelabel;
}


@end

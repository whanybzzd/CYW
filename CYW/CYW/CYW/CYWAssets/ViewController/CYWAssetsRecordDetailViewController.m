//
//  CYWAssetsRecordDetailViewController.m
//  CYW
//
//  Created by jktz on 2017/10/24.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsRecordDetailViewController.h"

@interface CYWAssetsRecordDetailViewController ()
@property (nonatomic, retain) UILabel *repaymentslabel;
@property (nonatomic, retain) UIImageView *repaymentsImageView;
@property (nonatomic, retain) UILabel *repaymentsMoneylabel;
@property (nonatomic, retain) UILabel *repaymentsStatelabel;
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) UILabel *Tradinglabel;
@property (nonatomic, retain) UILabel *Tradingdetaillabel;
@property (nonatomic, retain) UIView *lineView1;

@property (nonatomic, retain) UILabel *balancelabel;
@property (nonatomic, retain) UILabel *balancedetaillabel;
@property (nonatomic, retain) UIView *lineView2;

@property (nonatomic, retain) UILabel *freezelabel;
@property (nonatomic, retain) UILabel *freezedetaillabel;
@property (nonatomic, retain) UIView *lineView3;

@property (nonatomic, retain) UILabel *remarklabel;
@property (nonatomic, retain) UILabel *remarketaillabel;
@property (nonatomic, retain) UIView *lineView4;

@end

@implementation CYWAssetsRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"交易详情";
    self.view.backgroundColor=[UIColor whiteColor];
    
    [self repaymentslabel];
    [self repaymentsImageView];
    [self repaymentsMoneylabel];
    [self repaymentsStatelabel];
    [self lineView];
    [self Tradinglabel];
    [self Tradingdetaillabel];
    [self lineView1];
    
    [self balancelabel];
    [self balancedetaillabel];
    [self lineView2];
    
    
    [self freezelabel];
    [self freezedetaillabel];
    [self lineView3];
    
    [self remarklabel];
    [self remarketaillabel];
    [self lineView4];
    
    [self initSubView];
}

- (void)initSubView{
    
    TransactViewModel *model=(TransactViewModel *)self.params[@"model"];
    //正常还款 repaymentslabel
    
    
    //正常还款图片 repaymentsImageView
    
    //具体金额  repaymentsMoneylabel
    
    //状态  repaymentsStatelabel
    
    //交易具体时间   Tradingdetaillabel
    
    //可用余额  balancedetaillabel
    
    //冻结金额  freezedetaillabel
    
    //备注 remarketaillabel  time
    self.freezedetaillabel.text=[NSString stringWithFormat:@"0.0元"];;
    self.repaymentsStatelabel.text=model.type;
    [self.repaymentsStatelabel sizeToFit];
    
    self.repaymentslabel.text=model.typeInfo;
    [self.repaymentslabel sizeToFit];
    
    self.balancedetaillabel.text=model.balance;
    [self.balancedetaillabel sizeToFit];
    
    self.Tradingdetaillabel.text=model.time;
    [self.Tradingdetaillabel sizeToFit];
    
    
    if ([NSString isEmpty:[self loadString:model.detail]]) {
        
        self.remarketaillabel.text=nil;
    }else{
        
        self.remarketaillabel.text=[NSString stringWithFormat:@"借款编号:%@",[self loadString:model.detail]];
    }
    
    
    if ([model.type isEqualToString:@"出账"]) {
        
        self.repaymentsImageView.image=[UIImage imageNamed:@"出账记录"];
        
        
        self.repaymentsMoneylabel.text=[NSString stringWithFormat:@"-%@元",model.moneyStr];
        [self.repaymentsMoneylabel sizeToFit];
        
        
    }else if ([model.type isEqualToString:@"入账"]){
        
        self.repaymentsImageView.image=[UIImage imageNamed:@"入账记录"];
        
        
        self.repaymentsMoneylabel.text=[NSString stringWithFormat:@"+%@元",model.moneyStr];
        [self.repaymentsMoneylabel sizeToFit];
        
        
        
    }else if ([model.type isEqualToString:@"冻结"]){
        
        self.repaymentsImageView.image=[UIImage imageNamed:@"冻结记录"];
        
        
        self.repaymentsMoneylabel.text=[NSString stringWithFormat:@"%@元",model.moneyStr];
        [self.repaymentsMoneylabel sizeToFit];
        
        self.balancedetaillabel.text=[NSString stringWithFormat:@"%@元",model.moneyStr];
        [self.balancedetaillabel sizeToFit];
        
    }
    else if ([model.type isEqualToString:@"解冻"]){
        
        self.repaymentsImageView.image=[UIImage imageNamed:@"解冻记录"];
        
        
        self.repaymentsMoneylabel.text=[NSString stringWithFormat:@"%@元",model.moneyStr];
        [self.repaymentsMoneylabel sizeToFit];
        
        
        
    }
    else if ([model.type isEqualToString:@"充值"]){
        
        self.repaymentsImageView.image=[UIImage imageNamed:@"充值记录"];
        
        
        self.repaymentsMoneylabel.text=[NSString stringWithFormat:@"+%@元",model.moneyStr];
        [self.repaymentsMoneylabel sizeToFit];
        
        
        
    }
    else if ([model.type isEqualToString:@"提现"]){
        
        self.repaymentsImageView.image=[UIImage imageNamed:@"提现记录"];
        
        
        self.repaymentsMoneylabel.text=[NSString stringWithFormat:@"-%@元",model.moneyStr];
        [self.repaymentsMoneylabel sizeToFit];
        
    }
    else if ([model.type isEqualToString:@"从余额转出"]){
        
        self.repaymentsImageView.image=[UIImage imageNamed:@"出账记录"];
        
        
        self.repaymentsMoneylabel.text=[NSString stringWithFormat:@"-%@元",model.moneyStr];
        [self.repaymentsMoneylabel sizeToFit];
        
    }
    else if ([model.type isEqualToString:@"转入到余额"]){
        
        self.repaymentsImageView.image=[UIImage imageNamed:@"入账记录"];
        
        
        
        self.repaymentsMoneylabel.text=[NSString stringWithFormat:@"+%@元",model.moneyStr];
        [self.repaymentsMoneylabel sizeToFit];
        
    }
    else if ([model.type isEqualToString:@"从冻结金额中转出"]){
        
        self.repaymentsImageView.image=[UIImage imageNamed:@"出账记录"];
        
        
        
        self.repaymentsMoneylabel.text=[NSString stringWithFormat:@"-%@元",model.moneyStr];
        [self.repaymentsMoneylabel sizeToFit];
    }
    
}


- (NSString *)loadString:(NSString *)string{
    
    NSString *str3 = [string stringByReplacingOccurrencesOfString:@"：" withString:@":"];
    NSString *numberString=nil;
    if([str3 rangeOfString:@"借款ID:"].location !=NSNotFound)//_roaldSearchText
    {
        NSArray *numberArray=[str3 componentsSeparatedByString:@"借款ID:"];
        numberString=[numberArray[1] substringToIndex:14];
    }
    else
    {
        NSLog(@"");
    }
    return numberString;
    
}

#pragma mark --懒加载
- (UILabel *)repaymentslabel{
    
    if (!_repaymentslabel) {
        
        _repaymentslabel=[UILabel new];
        _repaymentslabel.font=[UIFont systemFontOfSize:CGFloatIn320(16)];
        _repaymentslabel.textColor=[UIColor colorWithHexString:@"#333333"];
        _repaymentslabel.text=@"正常还款";
        [self.view addSubview:_repaymentslabel];
        _repaymentslabel.sd_layout
        .centerXEqualToView(self.view)
        .heightIs(16)
        .topSpaceToView(self.view, kDevice_Is_iPhoneX?CGFloatIn320(88+32):CGFloatIn320(64+32));
        [_repaymentslabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _repaymentslabel;
}
- (UIImageView *)repaymentsImageView{
    if (!_repaymentsImageView) {
        
        _repaymentsImageView=[UIImageView new];
        _repaymentsImageView.layer.masksToBounds=YES;
        _repaymentsImageView.layer.cornerRadius=CGFloatIn320(16);
        [self.view addSubview:_repaymentsImageView];
        _repaymentsImageView.sd_layout
        .widthIs(CGFloatIn320(32))
        .heightIs(CGFloatIn320(32))
        .rightSpaceToView(_repaymentslabel, CGFloatIn320(13))
        .topSpaceToView(self.view, kDevice_Is_iPhoneX?CGFloatIn320(88+25):CGFloatIn320(64+25));
    }
    return _repaymentsImageView;
}

- (UILabel *)repaymentsMoneylabel{
    
    if (!_repaymentsMoneylabel) {
        
        _repaymentsMoneylabel=[UILabel new];
        _repaymentsMoneylabel.font=[UIFont systemFontOfSize:CGFloatIn320(34)];
        _repaymentsMoneylabel.textColor=[UIColor colorWithHexString:@"#f52b39"];
        _repaymentsMoneylabel.text=@"-38.5";
        [self.view addSubview:_repaymentsMoneylabel];
        _repaymentsMoneylabel.sd_layout
        .centerXEqualToView(self.view)
        .heightIs(34)
        .topSpaceToView(_repaymentsImageView, CGFloatIn320(22));
        [_repaymentsMoneylabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _repaymentsMoneylabel;
}
- (UILabel *)repaymentsStatelabel{
    
    if (!_repaymentsStatelabel) {
        
        _repaymentsStatelabel=[UILabel new];
        _repaymentsStatelabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _repaymentsStatelabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _repaymentsStatelabel.text=@"出账";
        [self.view addSubview:_repaymentsStatelabel];
        _repaymentsStatelabel.sd_layout
        .centerXEqualToView(self.view)
        .heightIs(14)
        .topSpaceToView(_repaymentsMoneylabel, CGFloatIn320(12));
        [_repaymentsStatelabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _repaymentsStatelabel;
}

- (UIView *)lineView{
    
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self.view addSubview:_lineView];
        _lineView.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .heightIs(10)
        .topSpaceToView(_repaymentsStatelabel, CGFloatIn320(25));
    }
    return _lineView;
}

- (UILabel *)Tradinglabel{
    
    if (!_Tradinglabel) {
        
        _Tradinglabel=[UILabel new];
        _Tradinglabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _Tradinglabel.textColor=[UIColor colorWithHexString:@"#333333"];
        _Tradinglabel.text=@"交易时间";
        [self.view addSubview:_Tradinglabel];
        _Tradinglabel.sd_layout
        .leftSpaceToView(self.view, CGFloatIn320(9))
        .heightIs(14)
        .topSpaceToView(_lineView, CGFloatIn320(17));
        [_Tradinglabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _Tradinglabel;
}

- (UILabel *)Tradingdetaillabel{
    
    if (!_Tradingdetaillabel) {
        
        _Tradingdetaillabel=[UILabel new];
        _Tradingdetaillabel.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        _Tradingdetaillabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _Tradingdetaillabel.text=@"2017-08-22";
        [self.view addSubview:_Tradingdetaillabel];
        _Tradingdetaillabel.sd_layout
        .rightSpaceToView(self.view, CGFloatIn320(5))
        .heightIs(11)
        .topSpaceToView(_lineView, CGFloatIn320(22));
        [_Tradingdetaillabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _Tradingdetaillabel;
}

- (UIView *)lineView1{
    
    if (!_lineView1) {
        
        _lineView1=[UIView new];
        _lineView1.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self.view addSubview:_lineView1];
        _lineView1.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .heightIs(1)
        .topSpaceToView(_Tradinglabel, CGFloatIn320(17));
    }
    return _lineView1;
}


- (UILabel *)balancelabel{
    
    if (!_balancelabel) {
        
        _balancelabel=[UILabel new];
        _balancelabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _balancelabel.textColor=[UIColor colorWithHexString:@"#333333"];
        _balancelabel.text=@"可用余额";
        [self.view addSubview:_balancelabel];
        _balancelabel.sd_layout
        .leftSpaceToView(self.view, CGFloatIn320(9))
        .heightIs(14)
        .topSpaceToView(_lineView1, CGFloatIn320(17));
        [_balancelabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _balancelabel;
}

- (UILabel *)balancedetaillabel{
    
    if (!_balancedetaillabel) {
        
        _balancedetaillabel=[UILabel new];
        _balancedetaillabel.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        _balancedetaillabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _balancedetaillabel.text=@"1146.5元";
        [self.view addSubview:_balancedetaillabel];
        _balancedetaillabel.sd_layout
        .rightSpaceToView(self.view, CGFloatIn320(5))
        .heightIs(11)
        .topSpaceToView(_lineView1, CGFloatIn320(22));
        [_balancedetaillabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _balancedetaillabel;
}

- (UIView *)lineView2{
    
    if (!_lineView2) {
        
        _lineView2=[UIView new];
        _lineView2.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self.view addSubview:_lineView2];
        _lineView2.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .heightIs(1)
        .topSpaceToView(_balancelabel, CGFloatIn320(17));
    }
    return _lineView2;
}



- (UILabel *)freezelabel{
    
    if (!_freezelabel) {
        
        _freezelabel=[UILabel new];
        _freezelabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _freezelabel.textColor=[UIColor colorWithHexString:@"#333333"];
        _freezelabel.text=@"冻结金额";
        [self.view addSubview:_freezelabel];
        _freezelabel.sd_layout
        .leftSpaceToView(self.view, CGFloatIn320(9))
        .heightIs(14)
        .topSpaceToView(_lineView2, CGFloatIn320(17));
        [_freezelabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _freezelabel;
}

- (UILabel *)freezedetaillabel{
    
    if (!_freezedetaillabel) {
        
        _freezedetaillabel=[UILabel new];
        _freezedetaillabel.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        _freezedetaillabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _freezedetaillabel.text=@"1146.5元";
        [self.view addSubview:_freezedetaillabel];
        _freezedetaillabel.sd_layout
        .rightSpaceToView(self.view, CGFloatIn320(5))
        .heightIs(11)
        .topSpaceToView(_lineView2, CGFloatIn320(22));
        [_freezedetaillabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _freezedetaillabel;
}

- (UIView *)lineView3{
    
    if (!_lineView3) {
        
        _lineView3=[UIView new];
        _lineView3.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self.view addSubview:_lineView3];
        _lineView3.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .heightIs(1)
        .topSpaceToView(_freezelabel, CGFloatIn320(17));
    }
    return _lineView3;
}


- (UILabel *)remarklabel{
    
    if (!_remarklabel) {
        
        _remarklabel=[UILabel new];
        _remarklabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _remarklabel.textColor=[UIColor colorWithHexString:@"#333333"];
        _remarklabel.text=@"备注";
        [self.view addSubview:_remarklabel];
        _remarklabel.sd_layout
        .leftSpaceToView(self.view, CGFloatIn320(9))
        .heightIs(14)
        .topSpaceToView(_lineView3, CGFloatIn320(17));
        [_remarklabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _remarklabel;
}

- (UILabel *)remarketaillabel{
    
    if (!_remarketaillabel) {
        
        _remarketaillabel=[UILabel new];
        _remarketaillabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _remarketaillabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _remarketaillabel.text=@"投资:6463546434313134";
        [self.view addSubview:_remarketaillabel];
        _remarketaillabel.sd_layout
        .leftSpaceToView(self.view, CGFloatIn320(9))
        .heightIs(12)
        .topSpaceToView(_remarklabel, CGFloatIn320(15));
        [_remarketaillabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _remarketaillabel;
}

- (UIView *)lineView4{
    
    if (!_lineView4) {
        
        _lineView4=[UIView new];
        _lineView4.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self.view addSubview:_lineView4];
        _lineView4.sd_layout
        .leftSpaceToView(self.view, 0)
        .rightSpaceToView(self.view, 0)
        .heightIs(1)
        .topSpaceToView(_remarketaillabel, CGFloatIn320(12));
    }
    return _lineView4;
}
@end

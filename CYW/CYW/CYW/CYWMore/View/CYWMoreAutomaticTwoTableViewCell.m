//
//  CYWMoreAutomaticTwoTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/20.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreAutomaticTwoTableViewCell.h"
#import "CYWMoreAutomaticViewModel.h"
#import "LTPickerView.h"
@interface CYWMoreAutomaticTwoTableViewCell()<UITextFieldDelegate>
@property (nonatomic, retain) UILabel *availablebalancelabel;
@property (nonatomic, retain) UILabel *availablebalancemoneylabel;
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) UILabel *bidtypelabel;

//投标类型
@property (nonatomic, retain) UIImageView *immobilizationImageView;
@property (nonatomic, retain) UILabel *immobilizationlabel;
@property (nonatomic, retain) UIImageView *balanceImageView;
@property (nonatomic, retain) UILabel *balancelabel;

@property (nonatomic, retain) UIView *moneyView;
@property (nonatomic, retain) UITextField *moneyTextField;

//////////
@property (nonatomic, retain) UILabel *filllabel;
@property (nonatomic, retain) UIView *fillmoneyView;
@property (nonatomic, retain) UITextField *fillmoneyTextField;

@property (nonatomic, retain) UILabel *savelabel;
@property (nonatomic, retain) UIView *savemoneyView;
@property (nonatomic, retain) UITextField *savemoneyTextField;
@property (nonatomic, retain) UILabel *validitylabel;





@property (nonatomic, retain) UIView *rangeView;
@property (nonatomic, retain) UITextField *rangeTextField1;
@property (nonatomic, retain) UITextField *rangeTextField2;


@property (nonatomic, retain) UIView *limitView;
@property (nonatomic, retain) UITextField *limitTextField1;
@property (nonatomic, retain) UITextField *limitTextField2;

@property (nonatomic, retain) UILabel *rankinglabel;
@property (nonatomic, retain) UILabel *rangkingMoneylabel;

@property (nonatomic, retain) UIButton *sutmitButton;

@property (nonatomic, retain) UIView *immobilizationlabelView;
@property (nonatomic, retain) UIView *immobilizationlabelView2;


@property (nonatomic, retain) CYWMoreAutomaticViewModel *automaticViewModel;
@property (nonatomic, retain) NSString *type;

@end
@implementation CYWMoreAutomaticTwoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.automaticViewModel=[[CYWMoreAutomaticViewModel alloc] init];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self availablebalancelabel];
        [self availablebalancemoneylabel];
        [self lineView];
        [self bidtypelabel];
        [self immobilizationImageView];
        //
        [self immobilizationlabelView];
        [self immobilizationlabel];
        [self balanceImageView];
        [self immobilizationlabelView2];
        [self balancelabel];
        [self moneyView];
        [self moneyTextField];
        [self filllabel];
        [self fillmoneyView];
        [self fillmoneyTextField];
        [self savelabel];
        [self savemoneyView];
        [self savemoneyTextField];
        [self validitylabel];
        
        
        [self rangeView];
        [self limitView];
        
        [self rankinglabel];
        [self rangkingMoneylabel];
        [self sutmitButton];
        
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
    NSObject *userModel = [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserAuto];
    AutomaticallySaveViewModel *automodel=(AutomaticallySaveViewModel *)userModel;
    if ([NSObject isNotEmpty:automodel]) {
        
        self.moneyTextField.text=automodel.investMoney;
        self.fillmoneyTextField.text=automodel.remainMoney;
        self.rangeTextField1.text=[NSString stringWithFormat:@"%.0f",[automodel.minRate floatValue]*100];
        self.rangeTextField2.text=[NSString stringWithFormat:@"%.0f",[automodel.maxRate floatValue]*100];
        self.limitTextField1.text=[NSString stringWithFormat:@"%@",automodel.minDeadline];
        self.limitTextField2.text=[NSString stringWithFormat:@"%@",automodel.maxDeadline];
        
        self.rankinglabel.text=[NSString stringWithFormat:@"当前排名：%@",automodel.queueOrder];
        [self.rankinglabel sizeToFit];
        
        self.rangkingMoneylabel.text=[NSString stringWithFormat:@"排队金额：%@",automodel.queueAmount];
        [self.rangkingMoneylabel sizeToFit];
    }
    
    
    self.type=@"fixed";//默认为固定值
    NSObject *centerModel= [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserCenterInfoModel];
    UserCenterInfoViewModel *model=(UserCenterInfoViewModel *)centerModel;
    
    
    @weakify(self)
    UITapGestureRecognizer *forgetTap=[[UITapGestureRecognizer alloc] init];
    [[forgetTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self)
        self.moneyTextField.userInteractionEnabled=YES;
        self.moneyTextField.text=nil;
        self.immobilizationImageView.image=[UIImage imageNamed:@"确定-副本"];
        self.balanceImageView.image=[UIImage imageNamed:@"确定"];
        
        self.type=@"fixed";
    }];
    [self.immobilizationlabelView addGestureRecognizer:forgetTap];
    
    
    UITapGestureRecognizer *forgetTap1=[[UITapGestureRecognizer alloc] init];
    [[forgetTap1 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self)
        self.moneyTextField.userInteractionEnabled=NO;
        self.moneyTextField.text=model.balcance;
        self.immobilizationImageView.image=[UIImage imageNamed:@"确定"];
        self.balanceImageView.image=[UIImage imageNamed:@"确定-副本"];
        self.type=@"possible";
    }];
    [self.immobilizationlabelView2 addGestureRecognizer:forgetTap1];
    
    
    [[self.sutmitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        
        
        
        NSString *money=[StringUtils trimString:self.moneyTextField.text];
        NSString *fill=[StringUtils trimString:self.fillmoneyTextField.text];
         NSString *save=[StringUtils trimString:self.savemoneyTextField.text];
        NSString *rang=[StringUtils trimString:self.rangeTextField1.text];
        
        NSString *range=[StringUtils trimString:self.rangeTextField2.text];
        NSString *limit=[StringUtils trimString:self.limitTextField1.text];
        NSString *limit1=[StringUtils trimString:self.limitTextField2.text];
        
        
        if ([NSString isEmpty:money]) {
            
            [UIView showResultThenHide:@"请输入投资金额"];
            return ;
        }
        if ([money floatValue]<=0.0) {
            
            [UIView showResultThenHide:@"投标金额输入有误"];
            return ;
        }
        if ([NSString isEmpty:fill]) {
            
            [UIView showResultThenHide:@"请输入保留账户金额"];
            return ;
        }
        if ([fill floatValue]<=0.0) {
            
            [UIView showResultThenHide:@"账户保留输入有误"];
            return ;
        }
        if ([NSString isEmpty:save]) {
            
            [UIView showResultThenHide:@"请输入最小投资金额"];
            return ;
        }
        if ([save floatValue]<=0.0) {
            
            [UIView showResultThenHide:@"最小投资金额不能小于0"];
            return ;
        }
        if ([NSString isEmpty:rang]) {
            
            [UIView showResultThenHide:@"请输入最小利率范围"];
            return ;
        }
        if ([rang integerValue]<5) {
            
            [UIView showResultThenHide:@"利率范围最小为5%"];
            return ;
        }
        if ([NSString isEmpty:range]) {
            
            [UIView showResultThenHide:@"请输入最大利率范围"];
            return ;
        }
        if ([range integerValue]>24) {
            
            [UIView showResultThenHide:@"利率范围最大为24%"];
            return ;
        }
        if ([range integerValue]<[rang integerValue]) {
            
            [UIView showResultThenHide:[NSString stringWithFormat:@"最大利率范围要大于%@%%",self.rangeTextField1.text]];
            return ;
        }
        if ([NSString isEmpty:limit]) {
            
            [UIView showResultThenHide:@"请选择最小期限"];
            return;
        }
        if ([NSString isEmpty:limit1]) {
            
            [UIView showResultThenHide:@"请选择最大期限"];
            return;
        }
        if ([limit1 integerValue]<[limit integerValue]) {
            
            [UIView showResultThenHide:[NSString stringWithFormat:@"最大借款期限要大于%@期",self.limitTextField1.text]];
            return ;
        }
        [self endEditing:YES];
        self.automaticViewModel.type=self.type;
        self.automaticViewModel.investMoney=money;
        self.automaticViewModel.remainMoney=fill;
        self.automaticViewModel.save=save;
        self.automaticViewModel.minRate=rang;
        self.automaticViewModel.maxRate=range;
        self.automaticViewModel.minDeadline=limit;
        self.automaticViewModel.maxDeadline=limit1;
        [UIView showHUDLoading:@"正在保存"];
        [[self.automaticViewModel.autoCommand execute:x] subscribeNext:^(id  _Nullable x) {
            
            [UIView showResultThenHide:@"保存成功"];
        } error:^(NSError * _Nullable error) {
            [UIView showResultThenHide:(NSString *)error];
        }];
        
    }];
    
    if ([NSObject isNotEmpty:model]) {
        
        [self.availablebalancemoneylabel setAttributedText:[NSMutableAttributedString withTitleString:[NSString stringWithFormat:@"%@元",model.balcance] RangeString:@"元" color:[UIColor colorWithHexString:@"#f52735"] withFont:[UIFont systemFontOfSize:CGFloatIn320(12)]]];
        [self.availablebalancemoneylabel sizeToFit];
        
        
    }
    
    
    
}

//账户可用余额
- (UILabel *)availablebalancelabel{
    
    if (!_availablebalancelabel) {
        
        _availablebalancelabel=[UILabel new];
        _availablebalancelabel.text=@"账户可用余额";
        _availablebalancelabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _availablebalancelabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [self.contentView addSubview:_availablebalancelabel];
        _availablebalancelabel.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .topSpaceToView(self.contentView, CGFloatIn320(22))
        .heightIs(14);
        [_availablebalancelabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _availablebalancelabel;
}
//账户可用余额具体金额
- (UILabel *)availablebalancemoneylabel{
    
    if (!_availablebalancemoneylabel) {
        
        _availablebalancemoneylabel=[UILabel new];
        _availablebalancemoneylabel.text=@"100元";
        _availablebalancemoneylabel.font=[UIFont systemFontOfSize:CGFloatIn320(15)];
        _availablebalancemoneylabel.textColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_availablebalancemoneylabel];
        _availablebalancemoneylabel.sd_layout
        .rightSpaceToView(self.contentView, CGFloatIn320(10))
        .topSpaceToView(self.contentView, CGFloatIn320(24))
        .heightIs(15);
        [_availablebalancemoneylabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _availablebalancemoneylabel;
}

//账户可用余额下面的线条
- (UIView *)lineView{
    
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:_lineView];
        _lineView.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(15))
        .rightSpaceToView(self.contentView, CGFloatIn320(15))
        .heightIs(1)
        .topSpaceToView(_availablebalancelabel, CGFloatIn320(15));
    }
    return _lineView;
}
///////////////////////
//投标类型
- (UILabel *)bidtypelabel{
    
    if (!_bidtypelabel) {
        
        _bidtypelabel=[UILabel new];
        _bidtypelabel.text=@"投标类型";
        _bidtypelabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _bidtypelabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [self.contentView addSubview:_bidtypelabel];
        _bidtypelabel.sd_layout
        .leftEqualToView(_availablebalancelabel)
        .topSpaceToView(_lineView, CGFloatIn320(22))
        .heightIs(14);
        [_bidtypelabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _bidtypelabel;
}

- (UIImageView *)immobilizationImageView{
    
    if (!_immobilizationImageView) {
        
        _immobilizationImageView=[UIImageView new];
        _immobilizationImageView.image=[UIImage imageNamed:@"确定-副本"];
        [self.contentView addSubview:_immobilizationImageView];
        _immobilizationImageView.sd_layout
        .centerXEqualToView(self.contentView)
        .widthIs(CGFloatIn320(13))
        .heightIs(CGFloatIn320(13))
        .topSpaceToView(_lineView, CGFloatIn320(24));
    }
    return _immobilizationImageView;
}

- (UIView *)immobilizationlabelView{
    if (!_immobilizationlabelView) {
        
        _immobilizationlabelView=[UIView new];
        _immobilizationlabelView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        _immobilizationlabelView.userInteractionEnabled=YES;
        //_immobilizationlabelView.backgroundColor=[UIColor redColor];
        [self.contentView addSubview:_immobilizationlabelView];
        _immobilizationlabelView.sd_layout
        .leftSpaceToView(_immobilizationImageView, 1)
        .topSpaceToView(_lineView, 5)
        .heightIs(35)
        .widthIs(70);
    }
  
    return _immobilizationlabelView;
}
- (UILabel *)immobilizationlabel{
    
    if (!_immobilizationlabel) {
        
        _immobilizationlabel=[UILabel new];
        _immobilizationlabel.text=@"按固定金额";
        //_immobilizationlabel.userInteractionEnabled=YES;
        _immobilizationlabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _immobilizationlabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [_immobilizationlabelView addSubview:_immobilizationlabel];
        _immobilizationlabel.sd_layout
        .leftSpaceToView(_immobilizationlabelView, 8)
        .topSpaceToView(_immobilizationlabelView, 20)
        .heightIs(12);
        [_immobilizationlabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _immobilizationlabel;
}

- (UIImageView *)balanceImageView{
    
    if (!_balanceImageView) {
        
        _balanceImageView=[UIImageView new];
        _balanceImageView.image=[UIImage imageNamed:@"确定"];
        [self.contentView addSubview:_balanceImageView];
        _balanceImageView.sd_layout
        .leftSpaceToView(_immobilizationlabelView, CGFloatIn320(10))
        .widthIs(CGFloatIn320(13))
        .heightIs(CGFloatIn320(13))
        .topSpaceToView(_lineView, CGFloatIn320(24));
    }
    return _balanceImageView;
}
- (UIView *)immobilizationlabelView2{
    
    if (!_immobilizationlabelView2) {
        _immobilizationlabelView2=[UIView new];
        _immobilizationlabelView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        _immobilizationlabelView2.userInteractionEnabled=YES;
        [self.contentView addSubview:_immobilizationlabelView2];
        _immobilizationlabelView2.sd_layout
        .leftSpaceToView(_balanceImageView, 1)
        .topSpaceToView(_lineView, 5)
        .heightIs(35)
        .widthIs(70);
        
    }
   
    return _immobilizationlabelView2;
}

- (UILabel *)balancelabel{
    
    if (!_balancelabel) {
        
        _balancelabel=[UILabel new];
        _balancelabel.text=@"按账户余额";
        //_balancelabel.userInteractionEnabled=YES;
        _balancelabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _balancelabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [_immobilizationlabelView2 addSubview:_balancelabel];
        _balancelabel.sd_layout
        .leftSpaceToView(_immobilizationlabelView2, 8)
        .topSpaceToView(_immobilizationlabelView2, 20)
        .heightIs(12);
        [_balancelabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _balancelabel;
}
- (UIView *)moneyView{
    if (!_moneyView) {
        
        _moneyView=[UIView new];
        _moneyView.backgroundColor=[UIColor whiteColor];
        _moneyView.layer.borderColor=[UIColor colorWithHexString:@"#efefef"].CGColor;
        _moneyView.layer.borderWidth=1.0f;
        [self.contentView addSubview:_moneyView];
        _moneyView.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .rightSpaceToView(self.contentView, CGFloatIn320(10))
        .topSpaceToView(_immobilizationlabelView2, CGFloatIn320(13))
        .heightIs(CGFloatIn320(50));
        
        self.moneyTextField=[UITextField new];
        self.moneyTextField.placeholder=@"每次投标金额";
        self.moneyTextField.delegate=self;
        self.moneyTextField.tag=1;
        self.moneyTextField.font=[UIFont systemFontOfSize:14];
        [_moneyView addSubview:self.moneyTextField];
        self.moneyTextField.sd_layout
        .leftSpaceToView(_moneyView, CGFloatIn320(5))
        .topSpaceToView(_moneyView, 10)
        .bottomSpaceToView(_moneyView, 10)
        .rightSpaceToView(_moneyView, 100);
        
        UILabel *label=[UILabel new];
        label.text=@"元";
        label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        label.textColor=[UIColor colorWithHexString:@"#666666"];
        [_moneyView addSubview:label];
        label.sd_layout
        .rightSpaceToView(_moneyView, CGFloatIn320(5))
        .centerYEqualToView(_moneyView)
        .heightIs(14);
        [label setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _moneyView;
    
}


- (UILabel *)filllabel{
    
    if (!_filllabel) {
        
        _filllabel=[UILabel new];
        _filllabel.text=@"填写一个金额,这部分钱不会加入自动投标";
        _filllabel.userInteractionEnabled=YES;
        _filllabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _filllabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [self.contentView addSubview:_filllabel];
        _filllabel.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .topSpaceToView(_moneyView, CGFloatIn320(22))
        .heightIs(14);
        [_filllabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _filllabel;
}


- (UIView *)fillmoneyView{
    if (!_fillmoneyView) {
        
        _fillmoneyView=[UIView new];
        _fillmoneyView.backgroundColor=[UIColor whiteColor];
        _fillmoneyView.layer.borderColor=[UIColor colorWithHexString:@"#efefef"].CGColor;
        _fillmoneyView.layer.borderWidth=1.0f;
        [self.contentView addSubview:_fillmoneyView];
        _fillmoneyView.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .rightSpaceToView(self.contentView, CGFloatIn320(10))
        .topSpaceToView(_filllabel, CGFloatIn320(15))
        .heightIs(CGFloatIn320(50));
        
        self.fillmoneyTextField=[UITextField new];
        self.fillmoneyTextField.delegate=self;
        self.fillmoneyTextField.tag=2;
        self.fillmoneyTextField.placeholder=@"账户保留金额";
        self.fillmoneyTextField.font=[UIFont systemFontOfSize:14];
        [_fillmoneyView addSubview:self.fillmoneyTextField];
        self.fillmoneyTextField.sd_layout
        .leftSpaceToView(_fillmoneyView, CGFloatIn320(5))
        .topSpaceToView(_fillmoneyView, 10)
        .bottomSpaceToView(_fillmoneyView, 10)
        .rightSpaceToView(_fillmoneyView, 100);
        
        UILabel *label=[UILabel new];
        label.text=@"元";
        label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        label.textColor=[UIColor colorWithHexString:@"#666666"];
        [_fillmoneyView addSubview:label];
        label.sd_layout
        .rightSpaceToView(_fillmoneyView, CGFloatIn320(5))
        .centerYEqualToView(_fillmoneyView)
        .heightIs(14);
        [label setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _fillmoneyView;
    
}


- (UILabel *)savelabel{
    
    if (!_savelabel) {
        
        _savelabel=[UILabel new];
        _savelabel.text=@"当账户余额大于此金额时,才进行按余额自动投标";
        _savelabel.userInteractionEnabled=YES;
        _savelabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _savelabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [self.contentView addSubview:_savelabel];
        _savelabel.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .topSpaceToView(_fillmoneyView, CGFloatIn320(22))
        .heightIs(14);
        [_savelabel setSingleLineAutoResizeWithMaxWidth:320];
    }
    return _savelabel;
}

- (UIView *)savemoneyView{
    if (!_savemoneyView) {
        
        _savemoneyView=[UIView new];
        _savemoneyView.backgroundColor=[UIColor whiteColor];
        _savemoneyView.layer.borderColor=[UIColor colorWithHexString:@"#efefef"].CGColor;
        _savemoneyView.layer.borderWidth=1.0f;
        [self.contentView addSubview:_savemoneyView];
        _savemoneyView.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .rightSpaceToView(self.contentView, CGFloatIn320(10))
        .topSpaceToView(_savelabel, CGFloatIn320(15))
        .heightIs(CGFloatIn320(50));
        
        self.savemoneyTextField=[UITextField new];
        self.savemoneyTextField.delegate=self;
        self.savemoneyTextField.placeholder=@"最小投资金额";
        self.savemoneyTextField.font=[UIFont systemFontOfSize:14];
        [_savemoneyView addSubview:self.savemoneyTextField];
        self.savemoneyTextField.sd_layout
        .leftSpaceToView(_savemoneyView, CGFloatIn320(5))
        .topSpaceToView(_savemoneyView, 10)
        .bottomSpaceToView(_savemoneyView, 10)
        .rightSpaceToView(_savemoneyView, 100);
        
        UILabel *label=[UILabel new];
        label.text=@"元";
        label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        label.textColor=[UIColor colorWithHexString:@"#666666"];
        [_savemoneyView addSubview:label];
        label.sd_layout
        .rightSpaceToView(_savemoneyView, CGFloatIn320(5))
        .centerYEqualToView(_savemoneyView)
        .heightIs(14);
        [label setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _savemoneyView;
    
}

- (UILabel *)validitylabel{
    
    if (!_validitylabel) {
        
        _validitylabel=[UILabel new];
        _validitylabel.text=@"5%~24%为有效利率";
        _validitylabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _validitylabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [self.contentView addSubview:_validitylabel];
        _validitylabel.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .topSpaceToView(_savemoneyView, CGFloatIn320(17))
        .heightIs(14);
        [_validitylabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _validitylabel;
}


- (UIView *)rangeView{
    if (!_rangeView) {
        
        _rangeView=[UIView new];
        //_rangeView.backgroundColor=[UIColor whiteColor];
        _rangeView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _rangeView.layer.borderWidth=1.0f;
        [self.contentView addSubview:_rangeView];
        _rangeView.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .rightSpaceToView(self.contentView, CGFloatIn320(10))
        .topSpaceToView(_validitylabel, CGFloatIn320(17))
        .heightIs(CGFloatIn320(50));
        
        
        UILabel *label=[UILabel new];
        label.text=@"利率范围";
        label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        [_rangeView addSubview:label];
        label.sd_layout
        .leftSpaceToView(_rangeView, CGFloatIn320(10))
        .centerYEqualToView(_rangeView)
        .heightIs(14);
        [label setSingleLineAutoResizeWithMaxWidth:200];
        
        
        
        self.rangeTextField1=[UITextField new];
        self.rangeTextField1.delegate=self;
        self.rangeTextField1.keyboardType=UIKeyboardTypeNumberPad;
        self.rangeTextField1.maxLength=4;
        self.rangeTextField1.tag=3;
        self.rangeTextField1.placeholder=@"";
        self.rangeTextField1.font=[UIFont systemFontOfSize:14];
        [_rangeView addSubview:self.rangeTextField1];
        self.rangeTextField1.sd_layout
        .leftSpaceToView(label, CGFloatIn320(50))
        .topSpaceToView(_rangeView, 5)
        .bottomSpaceToView(_rangeView, 5)
        .widthIs(80);
        
        
        UILabel *label2=[UILabel new];
        label2.text=@"%  ~";
        label2.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        label2.textColor=[UIColor colorWithHexString:@"#888888"];
        [_rangeView addSubview:label2];
        label2.sd_layout
        .leftSpaceToView(self.rangeTextField1, CGFloatIn320(5))
        .centerYEqualToView(_rangeView)
        .heightIs(14);
        [label2 setSingleLineAutoResizeWithMaxWidth:200];
        
        
        
        self.rangeTextField2=[UITextField new];
        self.rangeTextField2.placeholder=@"";
        self.rangeTextField2.delegate=self;
        self.rangeTextField2.tag=4;
        self.rangeTextField2.keyboardType=UIKeyboardTypeNumberPad;
        self.rangeTextField2.maxLength=4;
        self.rangeTextField2.font=[UIFont systemFontOfSize:14];
        [_rangeView addSubview:self.rangeTextField2];
        self.rangeTextField2.sd_layout
        .leftSpaceToView(label2, CGFloatIn320(20))
        .topSpaceToView(_rangeView, 5)
        .bottomSpaceToView(_rangeView, 5)
        .widthIs(80);
        
        UILabel *label1=[UILabel new];
        label1.text=@"%";
        label1.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        label1.textColor=[UIColor colorWithHexString:@"#888888"];
        [_rangeView addSubview:label1];
        label1.sd_layout
        .rightSpaceToView(_rangeView, CGFloatIn320(10))
        .centerYEqualToView(_rangeView)
        .heightIs(14);
        [label1 setSingleLineAutoResizeWithMaxWidth:200];
        
    }
    return _rangeView;
    
}



- (UIView *)limitView{
    if (!_limitView) {
        
        _limitView=[UIView new];
        //_rangeView.backgroundColor=[UIColor whiteColor];
        _limitView.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _limitView.layer.borderWidth=1.0f;
        [self.contentView addSubview:_limitView];
        _limitView.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .rightSpaceToView(self.contentView, CGFloatIn320(10))
        .topSpaceToView(_rangeView, -1)
        .heightIs(CGFloatIn320(50));
        
        
        UILabel *label=[UILabel new];
        label.text=@"借款期限";
        label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        [_limitView addSubview:label];
        label.sd_layout
        .leftSpaceToView(_limitView, CGFloatIn320(10))
        .centerYEqualToView(_limitView)
        .heightIs(14);
        [label setSingleLineAutoResizeWithMaxWidth:200];
        
        
        
        self.limitTextField1=[UITextField new];
        self.limitTextField1.placeholder=@"";
        self.limitTextField1.tag=5;
        self.limitTextField1.delegate=self;
        self.limitTextField1.font=[UIFont systemFontOfSize:14];
        [_limitView addSubview:self.limitTextField1];
        self.limitTextField1.sd_layout
        .leftSpaceToView(label, CGFloatIn320(50))
        .topSpaceToView(_limitView, 5)
        .bottomSpaceToView(_limitView, 5)
        .widthIs(80);
        
        
        UILabel *label2=[UILabel new];
        label2.text=@"个月  ~";
        label2.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        label2.textColor=[UIColor colorWithHexString:@"#888888"];
        [_limitView addSubview:label2];
        label2.sd_layout
        .leftSpaceToView(self.rangeTextField1, CGFloatIn320(5))
        .centerYEqualToView(_limitView)
        .heightIs(14);
        [label2 setSingleLineAutoResizeWithMaxWidth:200];
        
        
        
        self.limitTextField2=[UITextField new];
        self.limitTextField2.placeholder=@"";
        self.limitTextField2.tag=6;
        self.limitTextField2.delegate=self;
        self.limitTextField2.font=[UIFont systemFontOfSize:14];
        [_limitView addSubview:self.limitTextField2];
        self.limitTextField2.sd_layout
        .leftSpaceToView(label2, CGFloatIn320(20))
        .topSpaceToView(_limitView, 5)
        .bottomSpaceToView(_limitView, 5)
        .widthIs(80);
        
        UILabel *label1=[UILabel new];
        label1.text=@"个月";
        label1.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        label1.textColor=[UIColor colorWithHexString:@"#888888"];
        [_limitView addSubview:label1];
        label1.sd_layout
        .rightSpaceToView(_limitView, CGFloatIn320(10))
        .centerYEqualToView(_limitView)
        .heightIs(14);
        [label1 setSingleLineAutoResizeWithMaxWidth:200];
        
    }
    return _limitView;
    
}

- (UILabel *)rankinglabel{
    
    if (!_rankinglabel) {
        
        _rankinglabel=[UILabel new];
        _rankinglabel.text=@"当前排名:0";
        _rankinglabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _rankinglabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [self.contentView addSubview:_rankinglabel];
        _rankinglabel.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .topSpaceToView(_limitView, CGFloatIn320(10))
        .heightIs(12);
        [_rankinglabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _rankinglabel;
}

- (UILabel *)rangkingMoneylabel{
    
    if (!_rangkingMoneylabel) {
        
        _rangkingMoneylabel=[UILabel new];
        _rangkingMoneylabel.text=@"排队金额:0";
        _rangkingMoneylabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _rangkingMoneylabel.textColor=[UIColor colorWithHexString:@"#888888"];
        [self.contentView addSubview:_rangkingMoneylabel];
        _rangkingMoneylabel.sd_layout
        .leftSpaceToView(_rankinglabel, CGFloatIn320(20))
        .topSpaceToView(_limitView, CGFloatIn320(10))
        .heightIs(12);
        [_rangkingMoneylabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _rangkingMoneylabel;
}

- (UIButton *)sutmitButton{
    if (!_sutmitButton) {
        
        _sutmitButton=[UIButton new];
        [_sutmitButton setTitle:@"保存" forState:UIControlStateNormal];
        _sutmitButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_sutmitButton setHidden:NO];
        [_sutmitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _sutmitButton.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_sutmitButton];
        _sutmitButton.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(10))
        .rightSpaceToView(self.contentView, CGFloatIn320(10))
        .heightIs(CGFloatIn320(40))
        .topSpaceToView(_rangkingMoneylabel, CGFloatIn320(17));
    }
    return _sutmitButton;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //[self endEditing:YES];
    if (textField.tag==5||textField.tag==6) {
        [textField resignFirstResponder];
        LTPickerView* pickerView = [LTPickerView new];
        pickerView.dataSource = @[@"1",@"2",@"3",@"6",@"9",@"12",@"18",@"24",@"32"];//设置要显示的数据
        pickerView.defaultStr = @"1";//默认选择的数据
        [pickerView show];//显示
        //回调block
        @weakify(self)
        pickerView.block = ^(LTPickerView* obj,NSString* str,int num){
            @strongify(self)
            if (textField.tag==5) {
                
                self.limitTextField1.text=str;
            }
            else if (textField.tag==6) {
                
                self.limitTextField2.text=str;
            }
            //NSLog(@"选择了第%d行的%@",num,str);
        };
        return NO;
    }
    
    return YES;
}

//设置文本框只能输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //如果是限制只能输入数字的文本框
    if (self.moneyTextField==textField||self.fillmoneyTextField==textField||self.savemoneyTextField==textField) {
        
        return [self validateNumber:string];
        
    }
    //否则返回yes,不限制其他textfield
    return YES;
    
}


- (BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}
@end

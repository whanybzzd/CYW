//
//  CYWAlertView.m
//  CYW
//
//  Created by jktz on 2017/10/27.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAlertView.h"
#import "CYWAssetsCreditorViewModel.h"
@interface CYWAlertView()<UITextFieldDelegate>
@property (nonatomic, retain) CYWAssetsCreditorViewModel *creditorViewModel;

@property (nonatomic, retain) UIView *alertView;

@property (nonatomic, retain) UILabel *caninvestmentlabel;//可转让投资额
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) UILabel *label;


@property (nonatomic, retain) UILabel *transferlabel;//转让投资额
@property (nonatomic, retain) UITextField *transTextField;
@property (nonatomic, retain) UIView *lineView1;



@property (nonatomic, retain) UILabel *discountlabel;//折让金
@property (nonatomic, retain) UITextField *discounTextField;
@property (nonatomic, retain) UIView *lineView2;


@property (nonatomic, retain) UILabel *transferTotallabel;//转让总金额
@property (nonatomic, retain) UIView *lineView3;
@property (nonatomic, retain) UILabel *label1;


@property (nonatomic, retain) UILabel *transferFreelabel;//转让费用
@property (nonatomic, retain) UIView *lineView4;
@property (nonatomic, retain) UILabel *label2;

@property (nonatomic, retain) UILabel *expectedlabel;//转让费用
@property (nonatomic, retain) UIView *lineView5;
@property (nonatomic, retain) UILabel *label3;


@property (nonatomic, retain) UIButton *cancelButton;//取消
@property (nonatomic, retain) UIButton *submitButton;//确定

@property (nonatomic, retain) NSObject *object;

@property (nonatomic, assign) NSInteger dataCount;
@property (nonatomic, copy) NSString *action;
@property (nonatomic, assign) BOOL reBool;
@end

@implementation CYWAlertView

- (id)initWithAlertView:(CreditorViewModel *)model action:(NSString *)action transSuccess:(transSuccess)success transFailer:(transFailer)failer withCount:(NSInteger)count reBool:(BOOL)bo{
    
    if (self=[super init]) {
        
        self.success=success;
        self.failer =failer;
        self.object=model;
        self.dataCount=count;
        self.action=action;
        self.reBool=bo;
        self.backgroundColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:0.3];
        [self addSubview:self.alertView];
        [self caninvestmentlabel];
        [self label];
        [self lineView];
        
        [self transferlabel];
        [self transTextField];
        [self lineView1];
        
        [self discountlabel];
        [self discounTextField];
        [self lineView2];
        
        [self transferTotallabel];
        [self label1];
        [self lineView3];
        
        [self transferFreelabel];
        [self label2];
        [self   lineView4];
        
        
        [self expectedlabel];
        [self label3];
        [self lineView5];
        
        [self cancelButton];
        [self submitButton];
        
        [self initSubView];
        
    }
    return self;
}


- (void)initSubView{
    
    self.creditorViewModel=[[CYWAssetsCreditorViewModel alloc] init];
    
    @weakify(self)
    CreditorViewModel *model=(CreditorViewModel *)self.object;
    self.label.text=model.investMoney;
    [self.label sizeToFit];
    
    
    
    
    RAC(self.submitButton,backgroundColor)=[[RACSignal combineLatest:@[self.transTextField.rac_textSignal] reduce:^(NSString *username){
        
        return @([NSString isNotEmpty:username]&&[username floatValue]>0.0);
    }]map:^id _Nullable(id  _Nullable value) {
        @strongify(self)
        self.submitButton.userInteractionEnabled=[value boolValue]?YES:NO;
        return [value boolValue]?[UIColor colorWithHexString:@"#ff5978"]:[UIColor lightGrayColor];
    }];
    
    
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
      
        @strongify(self)
        [self hide];
    }];
    
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
       
        @strongify(self)
        [self hide];
        [UIView showHUDLoading:nil];
        
        NSString *perium=[NSString isEmpty:self.discounTextField.text]?@"0":self.discounTextField.text;
        
        NSString *investId=nil;
        NSString *extensionId=nil;
        if (self.reBool) {
            
            investId=model.investId;
            extensionId=@"";
        }else{
            
            investId=@"";
            extensionId=model.investExtensionId;
        }
        
        
        [[[self.creditorViewModel transfer:investId extensionId:extensionId trans:self.transTextField.text perium:perium action:self.action] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
            
            @strongify(self)
            [UIView showResultThenHide:(NSString *)error];
            self.failer();
            return [RACSignal empty];
            
        }] subscribeNext:^(id  _Nullable x) {
          
            @strongify(self)
            [UIView showResultThenHide:@"转让成功"];
            self.success();
        }];
        
        
    }];
    
    
    
    [[self.transTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
       
        
        if ([x floatValue]>[model.investMoney floatValue]) {
            
            [UIView showResultThenHide:@"不能超过总金额"];
            self.transTextField.text=[NSString stringWithFormat:@"%@",[x substringToIndex:x.length-1]];
            return;
        }
    }];
    
    [[self.discounTextField rac_textSignal] subscribeNext:^(NSString * _Nullable x) {
        
        
        if ([x floatValue]>[model.investMoney floatValue]) {
            
            [UIView showResultThenHide:@"折让金不能超过总金额"];
            self.discounTextField.text=[NSString stringWithFormat:@"%@",[x substringToIndex:x.length-1]];
            return;
        }
    }];
    
}


#pragma mark 文本框代理
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    
    BOOL isHaveDian=NO;
    if ([textField.text containsString:@"."]) {
        isHaveDian = YES;
    }else{
        isHaveDian = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.'))
        {
            return NO;
        }
        
        // 只能有一个小数点
        if (isHaveDian && single == '.') {
            return NO;
        }
        
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
                    return NO;
                }
            }
        }
        
        // 小数点后最多能输入两位
        if (isHaveDian) {
            NSRange ran = [textField.text rangeOfString:@"."];
            if (range.location > ran.location) {
                if ([textField.text pathExtension].length > 1) {
                    return NO;
                }
            }
        }
        
    }
    
    NSString *str = [textField.text stringByAppendingString:string];
    if (range.length == 1) {
        str = [textField.text substringToIndex:range.location];
        if (range.location == 0) {
            str = @"0";
        }
    }
    
    CreditorViewModel *model=(CreditorViewModel *)self.object;
    //当输入的值大于了本自身的值   就截取掉最后一个
    if ([str floatValue]>[model.investMoney floatValue]) {
        
        str=[NSString stringWithFormat:@"%@",[str substringToIndex:str.length-1]];
    }
    
    if (textField==self.transTextField) {
        
        self.label1.text = [NSString stringWithFormat:@"%.2f",[str floatValue]-[self.discounTextField.text floatValue]];
        [self.label1 sizeToFit];
        
        if (self.dataCount>=5) {
            
            self.label2.text = @"0.00";
        }else{
            
            self.label2.text = [NSString stringWithFormat:@"%.2f",[str floatValue]*[model.feeRate floatValue]];
        }
        
        [self.label2 sizeToFit];
        
        
        self.label3.text = [NSString stringWithFormat:@"%.2f",[str floatValue]*[model.debitWorth floatValue]/[model.investMoney floatValue]-[self.discounTextField.text floatValue]-(self.dataCount>=5?[str floatValue]*0:[str floatValue]*[model.feeRate floatValue])];
        [self.label3 sizeToFit];
    }
    if(textField ==self.discounTextField){
        
        self.label1.text = [NSString stringWithFormat:@"%.2f",[self.transTextField.text floatValue]-[str floatValue]];
        [self.label1 sizeToFit];
        
        if (self.dataCount>=5) {
            
            self.label2.text = @"0.00";
        }else{
            
            self.label2.text = [NSString stringWithFormat:@"%.2f",[self.transTextField.text floatValue]*[model.feeRate floatValue]];
        }
        
        [self.label2 sizeToFit];
        
        self.label3.text = [NSString stringWithFormat:@"%.2f",[self.transTextField.text floatValue]*[model.debitWorth floatValue]/[model.investMoney floatValue]-[str floatValue]-(self.dataCount>=5?[self.transTextField.text floatValue]*0:[self.transTextField.text floatValue]*[model.feeRate floatValue])];
        [self.label3 sizeToFit];
    }
   
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    
}



-(UIButton *)submitButton{
    
    if (!_submitButton) {
        
        _submitButton=[UIButton new];
        [_submitButton setTitle:@"确认转让" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(15)];
        _submitButton.backgroundColor=[UIColor colorWithHexString:@"#ff5978"];
        _submitButton.layer.cornerRadius=CGFloatIn320(16.5);
        [_alertView addSubview:_submitButton];
        _submitButton.sd_layout
        .rightSpaceToView(_alertView, CGFloatIn320(8))
        .bottomSpaceToView(_alertView, CGFloatIn320(14))
        .heightIs(CGFloatIn320(33))
        .widthIs(_alertView.width/2-16);
    }
    return _submitButton;
}

-(UIButton *)cancelButton{
    
    if (!_cancelButton) {
        
        _cancelButton=[UIButton new];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(15)];
        _cancelButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _cancelButton.layer.borderWidth=1.0f;
        _cancelButton.layer.cornerRadius=CGFloatIn320(16.5);
        [_alertView addSubview:_cancelButton];
        _cancelButton.sd_layout
        .leftSpaceToView(_alertView, CGFloatIn320(8))
        .bottomSpaceToView(_alertView, CGFloatIn320(14))
        .heightIs(CGFloatIn320(33))
        .widthIs(_alertView.width/2-16);
    }
    return _cancelButton;
}
- (UIView *)lineView5{
    if (!_lineView5) {
        
        _lineView5=[UIView new];
        _lineView5.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [_alertView addSubview:_lineView5];
        _lineView5.sd_layout
        .leftEqualToView(_lineView1)
        .rightEqualToView(_lineView1)
        .heightIs(1)
        .topSpaceToView(_expectedlabel, CGFloatIn320(14));
    }
    return _lineView5;
}

- (UILabel *)label3{
    if (!_label3) {
        
        _label3=[UILabel new];
        _label3.text=@"0.0";
        _label3.textColor=[UIColor colorWithHexString:@"#888888"];
        _label3.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_alertView addSubview:_label3];
        _label3.sd_layout
        .centerXEqualToView(_alertView)
        .topSpaceToView(_lineView4, CGFloatIn320(17))
        .heightIs(14);
        [_label3 setSingleLineAutoResizeWithMaxWidth:200];
        
        
    }
    return _label3;
}

- (UILabel *)expectedlabel{
    if (!_expectedlabel) {
        
        _expectedlabel=[UILabel new];
        _expectedlabel.text=@"预计收入金额:";
        _expectedlabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _expectedlabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_alertView addSubview:_expectedlabel];
        _expectedlabel.sd_layout
        .leftEqualToView(_caninvestmentlabel)
        .topSpaceToView(_lineView4, CGFloatIn320(17))
        .heightIs(14);
        [_expectedlabel setSingleLineAutoResizeWithMaxWidth:200];
        
        UILabel *label=[UILabel new];
        label.text=@"元";
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_alertView addSubview:label];
        label.sd_layout
        .rightSpaceToView(_alertView, CGFloatIn320(19))
        .heightIs(14)
        .topSpaceToView(_lineView4, CGFloatIn320(23));
        [label setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _expectedlabel;
}
- (UIView *)lineView4{
    if (!_lineView4) {
        
        _lineView4=[UIView new];
        _lineView4.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [_alertView addSubview:_lineView4];
        _lineView4.sd_layout
        .leftEqualToView(_lineView1)
        .rightEqualToView(_lineView1)
        .heightIs(1)
        .topSpaceToView(_transferFreelabel, CGFloatIn320(14));
    }
    return _lineView4;
}

- (UILabel *)label2{
    if (!_label2) {
        
        _label2=[UILabel new];
        _label2.text=@"0.0";
        _label2.textColor=[UIColor colorWithHexString:@"#888888"];
        _label2.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_alertView addSubview:_label2];
        _label2.sd_layout
        .centerXEqualToView(_alertView)
        .topSpaceToView(_lineView3, CGFloatIn320(17))
        .heightIs(14);
        [_label2 setSingleLineAutoResizeWithMaxWidth:200];
        
        
    }
    return _label2;
}

- (UILabel *)transferFreelabel{
    if (!_transferFreelabel) {
        
        _transferFreelabel=[UILabel new];
        _transferFreelabel.text=@"       转让费用:";
        _transferFreelabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _transferFreelabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_alertView addSubview:_transferFreelabel];
        _transferFreelabel.sd_layout
        .leftEqualToView(_caninvestmentlabel)
        .topSpaceToView(_lineView3, CGFloatIn320(17))
        .heightIs(14);
        [_transferFreelabel setSingleLineAutoResizeWithMaxWidth:200];
        
        UILabel *label=[UILabel new];
        label.text=@"元";
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_alertView addSubview:label];
        label.sd_layout
        .rightSpaceToView(_alertView, CGFloatIn320(19))
        .heightIs(14)
        .topSpaceToView(_lineView3, CGFloatIn320(23));
        [label setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _transferFreelabel;
}

- (UIView *)lineView3{
    if (!_lineView3) {
        
        _lineView3=[UIView new];
        _lineView3.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [_alertView addSubview:_lineView3];
        _lineView3.sd_layout
        .leftEqualToView(_lineView1)
        .rightEqualToView(_lineView1)
        .heightIs(1)
        .topSpaceToView(_transferTotallabel, CGFloatIn320(14));
    }
    return _lineView3;
}

- (UILabel *)label1{
    if (!_label1) {
        
        _label1=[UILabel new];
        _label1.text=@"0.0";
        _label1.textColor=[UIColor colorWithHexString:@"#888888"];
        _label1.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_alertView addSubview:_label1];
        _label1.sd_layout
        .centerXEqualToView(_alertView)
        .topSpaceToView(_lineView2, CGFloatIn320(17))
        .heightIs(14);
        [_label1 setSingleLineAutoResizeWithMaxWidth:200];
        
        
    }
    return _label1;
}


- (UILabel *)transferTotallabel{
    if (!_transferTotallabel) {
        
        _transferTotallabel=[UILabel new];
        _transferTotallabel.text=@"    转让总金额:";
        _transferTotallabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _transferTotallabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_alertView addSubview:_transferTotallabel];
        _transferTotallabel.sd_layout
        .leftEqualToView(_caninvestmentlabel)
        .topSpaceToView(_lineView2, CGFloatIn320(17))
        .heightIs(14);
        [_transferTotallabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        UILabel *label=[UILabel new];
        label.text=@"元";
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_alertView addSubview:label];
        label.sd_layout
        .rightSpaceToView(_alertView, CGFloatIn320(19))
        .heightIs(14)
        .topSpaceToView(_lineView2, CGFloatIn320(23));
        [label setSingleLineAutoResizeWithMaxWidth:100];
        
    }
    return _transferTotallabel;
}


- (UIView *)lineView2{
    if (!_lineView2) {
        
        _lineView2=[UIView new];
        _lineView2.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [_alertView addSubview:_lineView2];
        _lineView2.sd_layout
        .leftEqualToView(_lineView1)
        .rightEqualToView(_lineView1)
        .heightIs(1)
        .topSpaceToView(_discountlabel, CGFloatIn320(14));
    }
    return _lineView2;
}

- (UITextField *)discounTextField{
    if (!_discounTextField) {
        
        _discounTextField=[UITextField new];
        _discounTextField.delegate=self;
        _discounTextField.tag=12;
        _discounTextField.keyboardType=UIKeyboardTypeDecimalPad;
        _discounTextField.backgroundColor=[UIColor whiteColor];
        [_alertView addSubview:_discounTextField];
        _discounTextField.sd_layout
        .centerXEqualToView(_alertView)
        .topSpaceToView(_lineView1, 1)
        .heightIs(40)
        .leftEqualToView(_transTextField)
        .widthIs(140);
    }
    return _discounTextField;
}

- (UILabel *)discountlabel{
    if (!_discountlabel) {
        
        _discountlabel=[UILabel new];
        _discountlabel.text=@"           折让金:";
        _discountlabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _discountlabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_alertView addSubview:_discountlabel];
        _discountlabel.sd_layout
        .leftEqualToView(_caninvestmentlabel)
        .topSpaceToView(_lineView1, CGFloatIn320(17))
        .heightIs(14);
        [_discountlabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        UILabel *label=[UILabel new];
        label.text=@"元";
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_alertView addSubview:label];
        label.sd_layout
        .rightSpaceToView(_alertView, CGFloatIn320(19))
        .heightIs(14)
        .topSpaceToView(_lineView1, CGFloatIn320(23));
        [label setSingleLineAutoResizeWithMaxWidth:100];
        
    }
    return _discountlabel;
}


- (UIView *)lineView1{
    if (!_lineView1) {
        
        _lineView1=[UIView new];
        _lineView1.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [_alertView addSubview:_lineView1];
        _lineView1.sd_layout
        .leftEqualToView(_lineView)
        .rightEqualToView(_lineView)
        .heightIs(1)
        .topSpaceToView(_transferlabel, CGFloatIn320(14));
    }
    return _lineView1;
}
- (UITextField *)transTextField{
    if (!_transTextField) {
        
        _transTextField=[UITextField new];
        _transTextField.delegate=self;
        _transTextField.tag=11;
        _transTextField.keyboardType=UIKeyboardTypeDecimalPad;
        _transTextField.backgroundColor=[UIColor whiteColor];
        [_alertView addSubview:_transTextField];
        _transTextField.sd_layout
        .centerXEqualToView(_alertView)
        .topSpaceToView(_lineView, 1)
        .heightIs(40)
        .leftEqualToView(self.label)
        .widthIs(140);
    }
    return _transTextField;
}

- (UILabel *)transferlabel{
    if (!_transferlabel) {
        
        _transferlabel=[UILabel new];
        _transferlabel.text=@"   转让投资额:";
        _transferlabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _transferlabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_alertView addSubview:_transferlabel];
        _transferlabel.sd_layout
        .leftSpaceToView(_alertView, CGFloatIn320(19))
        .topSpaceToView(_lineView, CGFloatIn320(17))
        .heightIs(14);
        [_transferlabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        UILabel *label=[UILabel new];
        label.text=@"元";
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_alertView addSubview:label];
        label.sd_layout
        .rightSpaceToView(_alertView, CGFloatIn320(19))
        .heightIs(14)
        .topSpaceToView(_lineView, CGFloatIn320(23));
        [label setSingleLineAutoResizeWithMaxWidth:100];
        
    }
    return _transferlabel;
}

- (UIView *)lineView{
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [_alertView addSubview:_lineView];
        _lineView.sd_layout
        .leftEqualToView(_caninvestmentlabel)
        .rightSpaceToView(_alertView, CGFloatIn320(19))
        .heightIs(1)
        .topSpaceToView(_caninvestmentlabel, CGFloatIn320(14));
    }
    return _lineView;
}


- (UILabel *)label{
    if (!_label) {
        
        _label=[UILabel new];
        _label.text=@"0.0";
        _label.textColor=[UIColor colorWithHexString:@"#888888"];
        _label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_alertView addSubview:_label];
        _label.sd_layout
        .centerXEqualToView(_alertView)
        .topSpaceToView(_alertView, CGFloatIn320(23))
        .heightIs(14);
        [_label setSingleLineAutoResizeWithMaxWidth:200];
        
        
    }
    return _label;
}


- (UILabel *)caninvestmentlabel{
    if (!_caninvestmentlabel) {
        
        _caninvestmentlabel=[UILabel new];
        _caninvestmentlabel.text=@"可转让投资额:";
        _caninvestmentlabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _caninvestmentlabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_alertView addSubview:_caninvestmentlabel];
        _caninvestmentlabel.sd_layout
        .leftSpaceToView(_alertView, CGFloatIn320(19))
        .topSpaceToView(_alertView, CGFloatIn320(23))
        .heightIs(14);
        [_caninvestmentlabel setSingleLineAutoResizeWithMaxWidth:200];
        
        UILabel *label=[UILabel new];
        label.text=@"元";
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_alertView addSubview:label];
        label.sd_layout
        .rightSpaceToView(_alertView, CGFloatIn320(19))
        .heightIs(14)
        .topSpaceToView(_alertView, CGFloatIn320(23));
        [label setSingleLineAutoResizeWithMaxWidth:100];
        
    }
    return _caninvestmentlabel;
}
- (UIView *)alertView{
    
    if (!_alertView) {
        
        _alertView=[[UIView alloc] initWithFrame:CGRectMake(17, ([UIScreen mainScreen].bounds.size.height-366)/2-7, [UIScreen mainScreen].bounds.size.width-17*2,366)];
        _alertView.layer.cornerRadius=10;
        _alertView.backgroundColor=[UIColor whiteColor];
        
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
@end

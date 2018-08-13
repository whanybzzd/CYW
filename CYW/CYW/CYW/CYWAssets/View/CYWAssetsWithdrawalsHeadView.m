//
//  CYWAssetsWithdrawalsHeadView.m
//  CYW
//
//  Created by jktz on 2017/10/16.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsWithdrawalsHeadView.h"
#import "CYWAssetsWithdrawalsViewModel.h"
#import "BankCardView.h"
#import "CYWAssetsCarManagerViewModel.h"
@interface CYWAssetsWithdrawalsHeadView()<UITextFieldDelegate>
@property (nonatomic, retain) UIView *topView;
@property (nonatomic, retain) UILabel *balancelabel;
@property (nonatomic, retain) UILabel *balancemoneylabel;
@property (nonatomic, retain) UIView *textView;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) UILabel *cashlabel;
@property (nonatomic, retain) UILabel *cashlabel1;

@property (nonatomic, retain) UIView *carView;
@property (nonatomic, retain) UITextField *cartextField;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) CYWAssetsWithdrawalsViewModel *withdrawalsViewModel;
@property (nonatomic, retain) CYWAssetsCarManagerViewModel *managerViewModel;
@property (nonatomic, assign) BOOL editerBool;
@property (nonatomic, retain) NSString *carid;
@property (nonatomic, retain) NSString *free;
@end
@implementation CYWAssetsWithdrawalsHeadView


- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [[Login sharedInstance] refreshUserInfo];//刷新个人账户信息:TODO   因为提现和充值都是调用的网页，所以暂时就放这里刷新
        self.height=CGFloatIn320(320);
        [self topView];
        [self balancelabel];
        [self balancemoneylabel];
        [self textView];
        [self cashlabel];
        [self cashlabel1];
        [self carView];
        [self cartextField];
        [self submitButton];
        [self initSubView];
    }
    return self;
}

- (void)loadMoney{
    
    NSObject *userModel = [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserCenterInfoModel];
    UserCenterInfoViewModel *model=(UserCenterInfoViewModel *)userModel;
    self.balancemoneylabel.text=[NSString stringWithFormat:@"%.2lf元",[model.balcance floatValue]];
    [self.balancemoneylabel sizeToFit];
}

- (void)initSubView{
    
    //删除掉选择银行卡中默认的选项
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"carNo"];
    
    
    
    self.withdrawalsViewModel=[[CYWAssetsWithdrawalsViewModel alloc] init];
    self.managerViewModel=[[CYWAssetsCarManagerViewModel alloc] init];
    [self.managerViewModel.refreshDataCommand execute:nil];//请求银行列表
    [self loadMoney];
    
    
    @weakify(self)
    [self.balancelabel setAttributedText:[NSMutableAttributedString withTitleString:@"可用余额(元)" RangeString:@"(元)" color:[UIColor whiteColor] withFont:[UIFont systemFontOfSize:CGFloatIn320(11)]]];
    
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self endEditing:YES];
        if (self.editerBool) {
            
            //充值
            
            [self recharge];
        }else{
            
            [self withdrawal];//提现
        }
        
    }];
    
    //文本框编辑事件
    
    [[self.textField.rac_textSignal filter:^BOOL(NSString * _Nullable value) {
        
        return [NSString isNotEmpty:value]&&[value integerValue]>1;
        
    }] subscribeNext:^(NSString * _Nullable x) {
        
        self.withdrawalsViewModel.value=x;
        self.withdrawalsViewModel.type=self.editerBool==YES?@"chongzhi":@"tixian";
        [self loadFree];
        
        NSLog(@"x:%@",x);
    }];
    
    
    
    RAC(self.submitButton,backgroundColor)=[[RACSignal combineLatest:@[self.textField.rac_textSignal] reduce:^(NSString *username){
        
        return @([NSString isNotEmpty:username]&&[username integerValue]>1);
    }]map:^id _Nullable(id  _Nullable value) {
        @strongify(self)
        self.submitButton.userInteractionEnabled=[value boolValue]?YES:NO;
        return [value boolValue]?[UIColor colorWithHexString:@"#D72F3A"]:[UIColor lightGrayColor];
    }];
    
    
    
    
}

- (void)loadFree{
    
    
    @weakify(self)
    [[self.withdrawalsViewModel.refresWithdrawalsCommand execute:nil] subscribeNext:^(id x) {
        
        NSLog(@"刷新视图");
        @strongify(self)
        FreeViewModel *model=(FreeViewModel *)x;
        self.free=model.fee;
        self.cashlabel.text=[NSString stringWithFormat:@"提现费用:%.2lf",[model.fee floatValue]];
        [self.cashlabel sizeToFit];
        
        CGFloat value=[self.textField.text floatValue]-[model.fee floatValue];
        NSString *textValue=value<=0.0?@"0.0":[NSString stringWithFormat:@"%.2lf",value];
        self.cashlabel1.text=[NSString stringWithFormat:@"实际提现费用:%@",textValue];
        [self.cashlabel1 sizeToFit];
        
    } error:^(NSError * _Nullable error) {
        
        
        NSLog(@"计算手续费不能输入小数点");
    }];
}

//充值
- (void)recharge{
    if ([NSString isEmpty:self.free]) {
        
        [UIView showResultThenHide:@"当前请求错误"];
        return;
    }
    self.withdrawalsViewModel.price=self.textField.text;
    self.withdrawalsViewModel.free=self.free;
    [UIView showHUDLoading:nil];
    [[self.withdrawalsViewModel.refresrechargeCommand execute:nil] subscribeNext:^(id x) {
        
        [UIView hideHUDLoading];
        NSLog(@"刷新视图");
        //NSLog(@"x:%@",x);
        BaseViewController *currentViewController=(BaseViewController *)[UIView currentViewController];
        [currentViewController pushViewController:@"CYWAssetsBindCarViewController" withParams:@{@"url":x,@"title":@"充值"}];
    } error:^(NSError * _Nullable error) {
        [UIView showResultThenHide:(NSString *)error];
    }];
}
//提现
- (void)withdrawal{
    if ([NSString isEmpty:self.free]) {
        
        [UIView showResultThenHide:@"当前请求错误"];
        return;
    }
    if ([NSString isEmpty:self.carid]) {
        
        [UIView showResultThenHide:@"请选择银行卡"];
        return;
    }
    self.withdrawalsViewModel.price=self.textField.text;
    self.withdrawalsViewModel.free=self.free;
    self.withdrawalsViewModel.carId=self.carid;
    [UIView showHUDLoading:nil];
    // NSLog(@"price:%@===free:%@,carid:%@",self.textField.text,self.free,self.carid);
    [[self.withdrawalsViewModel.refresrewithdrawalCommand execute:nil] subscribeNext:^(id x) {
        
        NSLog(@"刷新视图");
        //NSLog(@"x:%@",x);
        [UIView hideHUDLoading];
        BaseViewController *currentViewController=(BaseViewController *)[UIView currentViewController];
        [currentViewController pushViewController:@"CYWAssetsBindCarViewController" withParams:@{@"url":x,@"title":@"提现"}];
    } error:^(NSError * _Nullable error) {
        
        [UIView showResultThenHide:(NSString *)error];
    }];
}

- (void)setHide:(BOOL)hide{
    
    self.editerBool=hide;
    [self.carView setHidden:hide];
    [self.cashlabel setHidden:hide];
    [self.cashlabel1 setHidden:hide];
    if (hide) {
        
        _submitButton.sd_layout
        .topSpaceToView(_textView, CGFloatIn320(10));
        //充值
        [self.submitButton setTitle:@"充值" forState:UIControlStateNormal];
    }else{
        
        [self.submitButton setTitle:@"申请提现" forState:UIControlStateNormal];
    }
    
}



#pragma mark --懒加载
- (UIView *)topView{
    
    if (!_topView) {
        
        _topView=[UIView new];
        //_topView.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
        [self addSubview:_topView];
        _topView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .heightIs(CGFloatIn320(120));
        
        UIImageView *imageView=[UIImageView new];
        imageView.image=[UIImage imageNamed:@"充值提现1"];
        [_topView addSubview:imageView];
        imageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    return _topView;
}

- (UILabel *)balancelabel{
    
    if (!_balancelabel) {
        
        _balancelabel=[UILabel new];
        _balancelabel.text=@"可用余额(元)";
        _balancelabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _balancelabel.textColor=[UIColor whiteColor];
        [_topView addSubview:_balancelabel];
        _balancelabel.sd_layout
        .centerXEqualToView(_topView)
        .heightIs(14)
        .topSpaceToView(_topView, CGFloatIn320(39));
        [_balancelabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _balancelabel;
}
- (UILabel *)balancemoneylabel{
    
    if (!_balancemoneylabel) {
        
        _balancemoneylabel=[UILabel new];
        _balancemoneylabel.text=@"0.0";
        _balancemoneylabel.font=[UIFont systemFontOfSize:CGFloatIn320(19)];
        _balancemoneylabel.textColor=[UIColor whiteColor];
        [_topView addSubview:_balancemoneylabel];
        _balancemoneylabel.sd_layout
        .centerXEqualToView(_topView)
        .heightIs(19)
        .topSpaceToView(_balancelabel, CGFloatIn320(15));
        [_balancemoneylabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _balancemoneylabel;
}
- (UIView *)textView{
    
    if (!_textView) {
        
        _textView=[UIView new];
        _textView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_textView];
        _textView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_topView, CGFloatIn320(15))
        .heightIs(CGFloatIn320(45));
        
        UIImageView *leftImageView=[UIImageView new];
        leftImageView.image=[UIImage imageNamed:@"充值-1"];
        [_textView addSubview:leftImageView];
        leftImageView.sd_layout
        .leftSpaceToView(_textView, CGFloatIn320(10))
        .centerYEqualToView(_textView)
        .widthIs(CGFloatIn320(20))
        .heightIs(CGFloatIn320(20));
        
        UILabel *label=[UILabel new];
        label.text=@"元";
        label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        label.textColor=[UIColor colorWithHexString:@"#333333"];
        [_textView addSubview:label];
        label.sd_layout
        .centerYEqualToView(_textView)
        .rightSpaceToView(_textView, CGFloatIn320(10))
        .heightIs(14);
        [label setSingleLineAutoResizeWithMaxWidth:200];
        
        self.textField=[UITextField new];
        self.textField.placeholder=@"请输入提现金额(同卡充值、同卡提现)";
        self.textField.font=[UIFont systemFontOfSize:14];
        self.textField.delegate=self;
        self.textField.keyboardType=UIKeyboardTypeDecimalPad;
        [_textView addSubview:self.textField];
        self.textField.sd_layout
        .leftSpaceToView(leftImageView, CGFloatIn320(10))
        .rightSpaceToView(label, CGFloatIn320(10))
        .topSpaceToView(_textView, CGFloatIn320(5))
        .bottomSpaceToView(_textView, CGFloatIn320(5));
    }
    return _textView;
}
- (UILabel *)cashlabel{
    
    if (!_cashlabel) {
        
        _cashlabel=[UILabel new];
        _cashlabel.text=@"提现费用:0.0";
        _cashlabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _cashlabel.textColor=[UIColor colorWithHexString:@"#666666"];
        [self addSubview:_cashlabel];
        _cashlabel.sd_layout
        .heightIs(14)
        .leftSpaceToView(self, CGFloatIn320(40))
        .topSpaceToView(_textView, CGFloatIn320(10));
        [_cashlabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _cashlabel;
}

- (UILabel *)cashlabel1{
    
    if (!_cashlabel1) {
        
        _cashlabel1=[UILabel new];
        _cashlabel1.text=@"实际提现费用:0.0";
        _cashlabel1.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _cashlabel1.textColor=[UIColor colorWithHexString:@"#666666"];
        [self addSubview:_cashlabel1];
        _cashlabel1.sd_layout
        .heightIs(14)
        .leftSpaceToView(_cashlabel, CGFloatIn320(40))
        .topSpaceToView(_textView, CGFloatIn320(10));
        [_cashlabel1 setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _cashlabel1;
}


- (UIView *)carView{
    
    if (!_carView) {
        
        _carView=[UIView new];
        _carView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_carView];
        _carView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_cashlabel, CGFloatIn320(13))
        .heightIs(CGFloatIn320(45));
        
        UIImageView *leftImageView=[UIImageView new];
        leftImageView.image=[UIImage imageNamed:@"银行卡"];
        [_carView addSubview:leftImageView];
        leftImageView.sd_layout
        .leftSpaceToView(_carView, CGFloatIn320(10))
        .centerYEqualToView(_carView)
        .widthIs(CGFloatIn320(23))
        .heightIs(CGFloatIn320(21));
        
        
        self.cartextField=[UITextField new];
        self.cartextField.placeholder=@"请选择银行卡";
        self.cartextField.delegate=self;
        self.cartextField.tag=2;
        self.cartextField.font=[UIFont systemFontOfSize:14];
        [_carView addSubview:self.cartextField];
        self.cartextField.sd_layout
        .leftSpaceToView(leftImageView, CGFloatIn320(10))
        .rightSpaceToView(_carView, CGFloatIn320(10))
        .topSpaceToView(_carView, CGFloatIn320(5))
        .bottomSpaceToView(_carView, CGFloatIn320(5));
    }
    return _carView;
}

- (UIButton *)submitButton{
    
    if (!_submitButton) {
        
        _submitButton=[UIButton new];
        [_submitButton setBackgroundColor:[UIColor colorWithHexString:@"#f52735"]];
        [_submitButton setTitle:@"申请提现" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [self addSubview:_submitButton];
        _submitButton.sd_layout
        .leftSpaceToView(self, CGFloatIn320(10))
        .rightSpaceToView(self, CGFloatIn320(10))
        .topSpaceToView(_carView, CGFloatIn320(10))
        .heightIs(CGFloatIn320(40));
    }
    return _submitButton;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField.tag==2) {
        [self endEditing:YES];
        @weakify(self)
        BankCardView *view=[BankCardView bankCarView:^(NSString *selectValue,NSString *carid) {
            @strongify(self)
            self.carid=carid;
            
            NSString *bankNo = [selectValue substringFromIndex:selectValue.length - 4];
            self.cartextField.text = [NSString stringWithFormat:@"%@ **** **** %@",[selectValue substringToIndex:4],bankNo];
            
            
            
            
        }];
        [view show];
        
        return NO;
    }
    return YES;
}

//设置文本框只能输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (self.textField==textField) {
        
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
    }
    
    return YES;
    
    
}

@end

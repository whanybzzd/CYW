//
//  CYWForgetViewController.m
//  CYW
//
//  Created by jktz on 2017/9/30.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWForgetViewController.h"
#import "CYWForgetViewModel.h"
@interface CYWForgetViewController ()<UITextFieldDelegate>
@property (nonatomic, retain) UITextField *newpasswordTextField;
@property (nonatomic, retain) UITextField *agaginpasswordTextField;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) CYWForgetViewModel *forgetViewModel;
@property (nonatomic, retain) UIButton *codeButton;
@property (nonatomic, copy) NSString *userid;
@end

@implementation CYWForgetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=self.params[@"title"];
    self.view.backgroundColor=[UIColor whiteColor];
    [self newpasswordTextField];
    [self codeButton];
    [self agaginpasswordTextField];
    [self submitButton];
    
    [self initSubView];
}

- (void)initSubView{
    self.forgetViewModel=[[CYWForgetViewModel alloc] init];
    RAC(self.forgetViewModel,phonenumber)=self.newpasswordTextField.rac_textSignal;
    RAC(self.forgetViewModel,code)=self.agaginpasswordTextField.rac_textSignal;
    
    
    @weakify(self);
    RAC(self.submitButton,backgroundColor)=[[RACSignal combineLatest:@[self.newpasswordTextField.rac_textSignal,self.agaginpasswordTextField.rac_textSignal] reduce:^(NSString *phonenumber,NSString *password){
        
        return @([NSString isNotEmpty:phonenumber]&&[NSString isNotEmpty:password]);
    }]map:^id _Nullable(id  _Nullable value) {
        @strongify(self)
        self.submitButton.userInteractionEnabled=[value boolValue]?YES:NO;
        return [value boolValue]?[UIColor colorWithHexString:@"#f52735"]:[UIColor colorWithHexString:@"d5d6db"];
    }];
    
    
    
    
    [[self.codeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        if ([NSString isEmpty:self.newpasswordTextField.text]) {
            
            [self showResultThenHide:@"请输入手机号码"];
            return ;
        }
        [self hideKeyboard];
        [self showHUDLoading:nil];
        [[self.forgetViewModel.forgetCommand execute:x] subscribeNext:^(id  _Nullable x) {
            
            [self hideHUDLoading];
            
            [self submitAction:x];
        } error:^(NSError * _Nullable error) {
            
            [self showResultThenHide:(NSString *)error];
            
        }];//发送一个信号
        
    }];
    
    [self submitAction:nil];
    
    
}

- (void)submitAction:(NSString *)str{
    @weakify(self);
    
    
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        
        
        if ([NSString isNotEmpty:str]) {
            
            [self hideKeyboard];
            [self showHUDLoading:nil];
            [[self.forgetViewModel.nextCommand execute:x] subscribeNext:^(id  _Nullable x) {
                
                @strongify(self);
                [self hideHUDLoading];
                [self pushViewController:@"CYWForgetwoViewController"];
                
            } error:^(NSError * _Nullable error) {
                @strongify(self);
                [self showResultThenHide:(NSString *)error];
            }];//发送一个信号
            
        }else{
            @strongify(self);
            [self showResultThenHide:@"请获取验证码失败"];
        }
        
    }];
    
}


#pragma mark --懒加载
- (UITextField *)newpasswordTextField{
    
    if (!_newpasswordTextField) {
        
        _newpasswordTextField=[[UITextField alloc] initWithFont:14 keyboardType:UIKeyboardTypeDefault placeholder:@"请输入手机号码" textColor:@"#CBCBCB"];
        _newpasswordTextField.layer.borderWidth=1.0f;
        _newpasswordTextField.layer.borderColor=[UIColor colorWithHexString:@"#DEDEDE"].CGColor;
        _newpasswordTextField.delegate=self;
        _newpasswordTextField.maxLength=11;
        _newpasswordTextField.keyboardType=UIKeyboardTypeNumberPad;
        [UITextField setTextFieldLeftPadding:_newpasswordTextField forWidth:15];
        [self.view addSubview:_newpasswordTextField];
        _newpasswordTextField.sd_layout
        .leftSpaceToView(self.view, CGFloatIn320(15))
        .rightSpaceToView(self.view, CGFloatIn320(15))
        .topSpaceToView(self.view, CGFloatIn320(kDevice_Is_iPhoneX?111:87))
        .heightIs(CGFloatIn320(40));
    }
    return _newpasswordTextField;
}

- (UITextField *)agaginpasswordTextField{
    
    if (!_agaginpasswordTextField) {
        
        _agaginpasswordTextField=[[UITextField alloc] initWithFont:14 keyboardType:UIKeyboardTypeDefault placeholder:@"请输入验证码" textColor:@"#CBCBCB"];
        _agaginpasswordTextField.layer.borderWidth=1.0f;
        _agaginpasswordTextField.layer.borderColor=[UIColor colorWithHexString:@"#DEDEDE"].CGColor;
        _agaginpasswordTextField.delegate=self;
        _agaginpasswordTextField.maxLength=6;
        _agaginpasswordTextField.keyboardType=UIKeyboardTypeNumberPad;
        [UITextField setTextFieldLeftPadding:_agaginpasswordTextField forWidth:15];
        [self.view addSubview:_agaginpasswordTextField];
        _agaginpasswordTextField.sd_layout
        .leftSpaceToView(self.view, CGFloatIn320(15))
        .rightSpaceToView(_codeButton, 0)
        .topSpaceToView(_newpasswordTextField, CGFloatIn320(15))
        .heightIs(CGFloatIn320(40));
    }
    return _agaginpasswordTextField;
}

- (UIButton *)codeButton{
    
    if (!_codeButton) {
        
        _codeButton=[UIButton new];
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        _codeButton.layer.borderWidth=1.0f;
        _codeButton.layer.borderColor=[UIColor colorWithHexString:@"#DEDEDE"].CGColor;
        [_codeButton setTitleColor:[UIColor colorWithHexString:@"#f52735"] forState:UIControlStateNormal];
        _codeButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [self.view addSubview:_codeButton];
        _codeButton.sd_layout
        .rightSpaceToView(self.view, CGFloatIn320(15))
        .heightIs(CGFloatIn320(40))
        .widthIs(CGFloatIn320(80))
        .topSpaceToView(_newpasswordTextField, CGFloatIn320(15));
        
    }
    return _codeButton;
}



- (UIButton *)submitButton{
    
    if (!_submitButton) {
        
        _submitButton=[UIButton new];
        [_submitButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(18)];
        _submitButton.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
        [self.view addSubview:_submitButton];
        _submitButton.sd_layout
        .leftEqualToView(_agaginpasswordTextField)
        .rightSpaceToView(self.view, CGFloatIn320(15))
        .heightIs(CGFloatIn320(40))
        .topSpaceToView(_agaginpasswordTextField, CGFloatIn320(58));
        
    }
    return _submitButton;
}



#pragma mark -- 手机屏幕方向
- (BOOL)shouldAutorotate
{
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
@end

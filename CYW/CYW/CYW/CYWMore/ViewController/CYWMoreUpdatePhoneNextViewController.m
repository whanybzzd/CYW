//
//  CYWMoreUpdatePhoneNextViewController.m
//  CYW
//
//  Created by jktz on 2017/11/9.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreUpdatePhoneNextViewController.h"
#import "CYWMoreUpdatePhoneViewModel.h"
@interface CYWMoreUpdatePhoneNextViewController ()<UITextFieldDelegate>
@property (nonatomic, retain) UITextField *newpasswordTextField;
@property (nonatomic, retain) UITextField *agaginpasswordTextField;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UIButton *codeButton;
@property (nonatomic, copy) NSString *userid;
@property (nonatomic, retain) CYWMoreUpdatePhoneViewModel *updateViewModel;
@end

@implementation CYWMoreUpdatePhoneNextViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"修改手机号码";
    self.view.backgroundColor=[UIColor whiteColor];
    [self newpasswordTextField];
    [self codeButton];
    [self agaginpasswordTextField];
    [self submitButton];
    
    [self initSubView];
}

- (void)initSubView{
    self.updateViewModel=[[CYWMoreUpdatePhoneViewModel alloc] init];
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
        self.updateViewModel.phone=[StringUtils trimString:self.newpasswordTextField.text];
        self.updateViewModel.type=@"update_phone2";
        [self showHUDLoading:nil];
        
        [[self.updateViewModel.refreshSendCodeCommand execute:self.codeButton] subscribeNext:^(id  _Nullable x) {
            
            [self hideHUDLoading];
        } error:^(NSError * _Nullable error) {
            
            [self showResultThenHide:(NSString *)error];
            
        }];
        
    }];
    
    
    
    
    
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        self.updateViewModel.code=[StringUtils trimString:self.agaginpasswordTextField.text];
        self.updateViewModel.phone=[StringUtils trimString:self.newpasswordTextField.text];
        [self hideKeyboard];
        self.updateViewModel.op=@"2";
        [self showHUDLoading:nil];
        
        [[self.updateViewModel.refreshsubmitCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self showResultThenHide:@"更换成功"];
            [[Login sharedInstance]refreshUserInfos];
            [self bk_performBlock:^(id obj) {
                
                [self backViewControllerIndex:0];
                
            } afterDelay:1.5];
            
        } error:^(NSError * _Nullable error) {
            
            [self showResultThenHide:(NSString *)error];
            
        }];
        
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
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
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
@end

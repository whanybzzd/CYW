//
//  CYWForgetwoViewController.m
//  CYW
//
//  Created by jktz on 2017/10/10.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWForgetwoViewController.h"
#import "CYWForgetViewModel.h"
@interface CYWForgetwoViewController ()

@property (nonatomic, retain) UITextField *newpasswordTextField;
@property (nonatomic, retain) UITextField *agaginpasswordTextField;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) CYWForgetViewModel *forgetViewModel;

@end

@implementation CYWForgetwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"忘记密码";
    [self newpasswordTextField];
    [self agaginpasswordTextField];
    [self submitButton];
    
    [self initSubView];
}
- (void)initSubView{
    
    self.forgetViewModel=[[CYWForgetViewModel alloc] init];
    RAC(self.forgetViewModel,newpassword)=self.newpasswordTextField.rac_textSignal;
    RAC(self.forgetViewModel,againpassword)=self.agaginpasswordTextField.rac_textSignal;
    
    
    @weakify(self);
    RAC(self.submitButton,backgroundColor)=[[RACSignal combineLatest:@[self.newpasswordTextField.rac_textSignal,self.agaginpasswordTextField.rac_textSignal] reduce:^(NSString *password,NSString *newpassword){
        
        return @([NSString isNotEmpty:password]&&[NSString isNotEmpty:newpassword]);
    }]map:^id _Nullable(id  _Nullable value) {
        @strongify(self)
        self.submitButton.userInteractionEnabled=[value boolValue]?YES:NO;
        return [value boolValue]?[UIColor colorWithHexString:@"#f52735"]:[UIColor lightGrayColor];
    }];
    
    
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        @strongify(self);
        if (![self.newpasswordTextField.text isEqualToString:self.agaginpasswordTextField.text]) {
            
            [self showResultThenHide:@"两次密码不一致"];
            return ;
        }
        [self hideKeyboard];
        [self showHUDLoading:nil];
        [[self.forgetViewModel.submitCommand execute:x] subscribeNext:^(id  _Nullable x) {
            
            [self showResultThenHide:@"修改密码成功"];
        } error:^(NSError * _Nullable error) {
            [self showResultThenHide:(NSString *)error];
            
        }];//发送一个信号
    }];
    
}

#pragma mark --懒加载
- (UITextField *)newpasswordTextField{
    
    if (!_newpasswordTextField) {
        
        _newpasswordTextField=[[UITextField alloc] initWithFont:14 keyboardType:UIKeyboardTypeDefault placeholder:@"请输入密码" textColor:@"#CBCBCB"];
        _newpasswordTextField.layer.borderWidth=1.0f;
        _newpasswordTextField.layer.borderColor=[UIColor colorWithHexString:@"#DEDEDE"].CGColor;
        [UITextField setTextFieldLeftPadding:_newpasswordTextField forWidth:15];
        [self.view addSubview:_newpasswordTextField];
        _newpasswordTextField.sd_layout
        .leftSpaceToView(self.view, CGFloatIn320(15))
        .rightSpaceToView(self.view, CGFloatIn320(15))
        .topSpaceToView(self.view, CGFloatIn320(23))
        .heightIs(CGFloatIn320(40));
    }
    return _newpasswordTextField;
}

- (UITextField *)agaginpasswordTextField{
    
    if (!_agaginpasswordTextField) {
        
        _agaginpasswordTextField=[[UITextField alloc] initWithFont:14 keyboardType:UIKeyboardTypeDefault placeholder:@"请再次输入密码" textColor:@"#CBCBCB"];
        _agaginpasswordTextField.layer.borderWidth=1.0f;
        _agaginpasswordTextField.layer.borderColor=[UIColor colorWithHexString:@"#DEDEDE"].CGColor;
        [UITextField setTextFieldLeftPadding:_agaginpasswordTextField forWidth:15];
        [self.view addSubview:_agaginpasswordTextField];
        _agaginpasswordTextField.sd_layout
        .leftSpaceToView(self.view, CGFloatIn320(15))
        .rightSpaceToView(self.view, CGFloatIn320(15))
        .topSpaceToView(_newpasswordTextField, CGFloatIn320(15))
        .heightIs(CGFloatIn320(40));
    }
    return _agaginpasswordTextField;
}


- (UIButton *)submitButton{
    
    if (!_submitButton) {
        
        _submitButton=[UIButton new];
        [_submitButton setTitle:@"完成" forState:UIControlStateNormal];
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

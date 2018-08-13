//
//  CYWregisterViewController.m
//  CYW
//
//  Created by jktz on 2017/8/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWregisterViewController.h"
#import "CYWRegisteViewModel.h"
@interface CYWregisterViewController ()<UITextFieldDelegate>
@property (nonatomic, retain) UIImageView *backImageView;

@property (nonatomic, retain) UIImageView *loginImageView;
@property (nonatomic, retain) UILabel *registerlabel;
@property (nonatomic, retain) UIImageView *usernameImageView;
@property (nonatomic, retain) UITextField *loginNameTextField;
@property (nonatomic, retain) UIView *usernameView;

@property (nonatomic, retain) UIImageView *phoneImageView;
@property (nonatomic, retain) UITextField *phoneTextField;
@property (nonatomic, retain) UIView *phoneView;

@property (nonatomic, retain) UIImageView *yzmImageView;
@property (nonatomic, retain) UITextField *yzmTextField;
@property (nonatomic, retain) UIView *yzmView;
@property (nonatomic, retain) UIButton *codeButton;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UIImageView *logoImageView;
@property (nonatomic, retain) CYWRegisteViewModel *registerModel;
@property (nonatomic, retain) UIImageView *closeImageView;
@end

@implementation CYWregisterViewController
- (void) viewWillAppear: (BOOL)animated {
    self.navigationController.navigationBar.hidden=YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self backImageView];
    
    [self loginImageView];
    [self registerlabel];
    
    [self usernameImageView];
    [self loginNameTextField];
    [self usernameView];
    
    [self phoneImageView];
    [self phoneTextField];
    [self phoneView];
    
    [self yzmImageView];
    [self yzmTextField];
    [self yzmView];
    
    [self codeButton];
    [self submitButton];
    
    [self logoImageView];
    [self closeImageView];
    
    [self initSubView];
    
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        
        _backImageView=[UIImageView new];
        _backImageView.image=[UIImage imageNamed:@"注册1.png"];
        [self.view addSubview:_backImageView];
        _backImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    return _backImageView;
}



- (void)initSubView{
    
    [self.loginImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"photo"]]] placeholder:[UIImage imageNamed:@"icon_avater"]];
    
    self.registerModel=[[CYWRegisteViewModel alloc] init];
    
    
    
    @weakify(self);
    RAC(self.registerModel,username)=self.loginNameTextField.rac_textSignal;
    RAC(self.registerModel,password)=self.phoneTextField.rac_textSignal;
    
    RAC(self.submitButton,backgroundColor)=[[RACSignal combineLatest:@[self.loginNameTextField.rac_textSignal,self.phoneTextField.rac_textSignal,self.yzmTextField.rac_textSignal] reduce:^(NSString *username,NSString *phonenumber,NSString *code){
        
        return @([NSString isNotEmpty:username]&&[NSString isNotEmpty:phonenumber]&&[NSString isNotEmpty:code]);
    }]map:^id _Nullable(id  _Nullable value) {
        @strongify(self)
        self.submitButton.userInteractionEnabled=[value boolValue]?YES:NO;
        return [value boolValue]?[UIColor colorWithHexString:@"#f52735"]:[UIColor colorWithHexString:@"d5d6db"];
    }];
    
    
    UITapGestureRecognizer *tapView2=[[UITapGestureRecognizer alloc] init];
    [[tapView2 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self)
        [self backViewController];
        NSLog(@"返回")
        
    }];
    [_closeImageView addGestureRecognizer:tapView2];
    
    [[self.codeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        if ([NSString isEmpty:self.phoneTextField.text]&&self.phoneTextField.text.length<11) {
            
            [self showResultThenHide:@"请输入正确的手机号码"];
            return ;
        }
        [self hideKeyboard];
        [self showHUDLoading:nil];
        [[self.registerModel.codeCommand execute:x] subscribeNext:^(id  _Nullable x) {
            
            @strongify(self);
            [self hideHUDLoading];
            [self submitAction:x];//当正常收到验证码后才能点击下一步
            
        } error:^(NSError * _Nullable error) {
            
            @strongify(self);
            [self showResultThenHide:(NSString *)error];
        }];
        
        
    }];
    
    [self submitAction:nil];
    
    //next button
    
    
    
}

- (void)submitAction:(NSString *)str{
    
    @weakify(self);
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self);
        if ([NSString isNotEmpty:str]) {
            
            
            
            if ([self.loginNameTextField.text isEqualToString:self.phoneTextField.text]) {
                
                [self showResultThenHide:@"用户名不能为手机号"];
                return;
            }
            
            [self pushViewController:@"CYWRegisterOverViewController" withParams:@{kParamBackType:@"0",
                                                                                   @"username":self.loginNameTextField.text,
                                                                                   @"phone":self.phoneTextField.text,
                                                                                   @"yzm":self.yzmTextField.text}];
        }else{
            
            [self showResultThenHide:@"验证码获取失败"];
        }
    }];
}

- (UIImageView *)closeImageView{
    
    if (!_closeImageView) {
        
        _closeImageView=[UIImageView new];
        _closeImageView.userInteractionEnabled=YES;
        _closeImageView.image=[UIImage imageNamed:@"X"];
        [self.view addSubview:_closeImageView];
        _closeImageView.sd_layout
        .topSpaceToView(self.view, getRectNavAndStatusHight)
        .leftSpaceToView(self.view, CGFloatIn320(20))
        .widthIs(15)
        .heightIs(14);
        
    }
    return _closeImageView;
}


#pragma mark --懒加载
- (UIImageView *)loginImageView{
    
    if (!_loginImageView) {
        
        _loginImageView=[UIImageView new];
        _loginImageView.image=[UIImage imageNamed:@"icon_avater"];
        _loginImageView.layer.masksToBounds=YES;
        _loginImageView.layer.cornerRadius=CGFloatIn320(28);
        [self.view addSubview:_loginImageView];
        _loginImageView.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(self.view, CGFloatIn320(73))
        .widthIs(CGFloatIn320(56))
        .heightIs(CGFloatIn320(56));
        
    }
    return _loginImageView;
}
- (UILabel *)registerlabel{
    if (!_registerlabel) {
        
        _registerlabel=[UILabel new];
        _registerlabel.text=@"注册享新手红包";
        _registerlabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _registerlabel.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.view addSubview:_registerlabel];
        _registerlabel.sd_layout
        .centerXEqualToView(self.view)
        .heightIs(14)
        .topSpaceToView(_loginImageView, CGFloatIn320(22));
        [_registerlabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _registerlabel;
}
- (UIImageView *)usernameImageView{
    
    if (!_usernameImageView) {
        
        _usernameImageView=[UIImageView new];
        _usernameImageView.image=[UIImage imageNamed:@"icon_username"];
        _usernameImageView.layer.cornerRadius=CGFloatIn320(16.5);
        [self.view addSubview:_usernameImageView];
        _usernameImageView.sd_layout
        .leftSpaceToView(self.view, CGFloatIn320(57.5))
        .topSpaceToView(_loginImageView, CGFloatIn320(59))
        .widthIs(CGFloatIn320(33))
        .heightIs(CGFloatIn320(33));
    }
    return _usernameImageView;
}

- (UITextField *)loginNameTextField{
    
    if (!_loginNameTextField) {
        
        _loginNameTextField=[[UITextField alloc] initWithFont:14 keyboardType:UIKeyboardTypeDefault placeholder:@"5~16位字母/数字/下划线" textColor:@"#888888"];
        [self.view addSubview:_loginNameTextField];
        _loginNameTextField.sd_layout
        .leftSpaceToView(_usernameImageView, CGFloatIn320(30))
        .rightSpaceToView(self.view, CGFloatIn320(57.5))
        .topSpaceToView(_loginImageView, CGFloatIn320(58))
        .heightIs(CGFloatIn320(40));
    }
    return _loginNameTextField;
}

- (UIView *)usernameView{
    if (!_usernameView) {
        
        _usernameView=[UIView new];
        _usernameView.backgroundColor=[UIColor redColor];
        [self.view addSubview:_usernameView];
        _usernameView.sd_layout
        .leftSpaceToView(_usernameImageView, CGFloatIn320(19))
        .rightSpaceToView(self.view, CGFloatIn320(50))
        .heightIs(0.5)
        .topSpaceToView(_loginNameTextField, -8);
    }
    return _usernameView;
}

- (UIImageView *)phoneImageView{
    
    if (!_phoneImageView) {
        
        _phoneImageView=[UIImageView new];
        _phoneImageView.image=[UIImage imageNamed:@"icon_phone"];
        _phoneImageView.layer.cornerRadius=CGFloatIn320(16.5);
        [self.view addSubview:_phoneImageView];
        _phoneImageView.sd_layout
        .leftSpaceToView(self.view, CGFloatIn320(57.5))
        .topSpaceToView(_usernameImageView, CGFloatIn320(45))
        .widthIs(CGFloatIn320(33))
        .heightIs(CGFloatIn320(33));
    }
    return _phoneImageView;
}
- (UITextField *)phoneTextField{
    
    if (!_phoneTextField) {
        
        _phoneTextField=[[UITextField alloc] initWithFont:14 keyboardType:UIKeyboardTypeDefault placeholder:@"请输入手机号" textColor:@"#888888"];
        _phoneTextField.delegate=self;
        _phoneTextField.maxLength=11;
        _phoneTextField.keyboardType=UIKeyboardTypeNumberPad;
        [self.view addSubview:_phoneTextField];
        _phoneTextField.sd_layout
        .leftEqualToView(_loginNameTextField)
        .rightEqualToView(_loginNameTextField)
        .topSpaceToView(_usernameView, CGFloatIn320(48))
        .heightIs(CGFloatIn320(40));
    }
    return _phoneTextField;
}

- (UIView *)phoneView{
    if (!_phoneView) {
        
        _phoneView=[UIView new];
        _phoneView.backgroundColor=[UIColor redColor];
        [self.view addSubview:_phoneView];
        _phoneView.sd_layout
        .leftSpaceToView(_phoneImageView, CGFloatIn320(19))
        .rightSpaceToView(self.view, CGFloatIn320(50))
        .heightIs(0.5)
        .topSpaceToView(_phoneTextField, -8);
    }
    return _phoneView;
}



- (UIImageView *)yzmImageView{
    
    if (!_yzmImageView) {
        
        _yzmImageView=[UIImageView new];
        _yzmImageView.image=[UIImage imageNamed:@"icon_yzm"];
        _yzmImageView.layer.cornerRadius=CGFloatIn320(16.5);
        [self.view addSubview:_yzmImageView];
        _yzmImageView.sd_layout
        .leftSpaceToView(self.view, CGFloatIn320(57.5))
        .topSpaceToView(_phoneImageView, CGFloatIn320(45))
        .widthIs(CGFloatIn320(33))
        .heightIs(CGFloatIn320(33));
    }
    return _yzmImageView;
}
- (UITextField *)yzmTextField{
    
    if (!_yzmTextField) {
        
        _yzmTextField=[[UITextField alloc] initWithFont:14 keyboardType:UIKeyboardTypeDefault placeholder:@"请输入验证码" textColor:@"#888888"];
        _yzmTextField.delegate=self;
        _yzmTextField.maxLength=6;
        _yzmTextField.keyboardType=UIKeyboardTypeNumberPad;
        [self.view addSubview:_yzmTextField];
        _yzmTextField.sd_layout
        .leftEqualToView(_phoneTextField)
        .topSpaceToView(_phoneView, CGFloatIn320(45))
        .heightIs(CGFloatIn320(40))
        .widthIs(CGFloatIn320(120));
    }
    return _yzmTextField;
}

- (UIView *)yzmView{
    if (!_yzmView) {
        
        _yzmView=[UIView new];
        _yzmView.backgroundColor=[UIColor redColor];
        [self.view addSubview:_yzmView];
        _yzmView.sd_layout
        .leftSpaceToView(_yzmImageView, CGFloatIn320(19))
        .rightSpaceToView(self.view, CGFloatIn320(50))
        .heightIs(0.5)
        .topSpaceToView(_yzmTextField, -8);
    }
    return _yzmView;
}
- (UIButton *)codeButton{
    if (!_codeButton) {
        
        _codeButton=[UIButton new];
        [_codeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_codeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_codeButton setBackgroundColor:[UIColor colorWithHexString:@"#E5939A"]];
        _codeButton.titleLabel.font=[UIFont systemFontOfSize:13];
        [self.view addSubview:_codeButton];
        _codeButton.sd_layout
        .rightEqualToView(_loginNameTextField)
        .heightIs(CGFloatIn320(26))
        .widthIs(CGFloatIn320(80))
        .bottomSpaceToView(_yzmView, CGFloatIn320(7));
    }
    return _codeButton;
}

- (UIButton *)submitButton{
    if (!_submitButton) {
        
        _submitButton=[UIButton new];
        [_submitButton setTitle:@"下一步" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_submitButton setBackgroundColor:[UIColor colorWithHexString:@"#D82F3A"]];
        [self.view addSubview:_submitButton];
        _submitButton.layer.cornerRadius=CGFloatIn320(25);
        _submitButton.sd_layout
        .leftSpaceToView(self.view, CGFloatIn320(58))
        .rightSpaceToView(self.view, CGFloatIn320(58))
        .topSpaceToView(_yzmView, CGFloatIn320(47))
        .heightIs(CGFloatIn320(50));
    }
    return _submitButton;
}

- (UIImageView *)logoImageView{
    
    if (!_logoImageView) {
        
        _logoImageView=[UIImageView new];
        _logoImageView.image=[UIImage imageNamed:@"echangyun.com"];
        [self.view addSubview:_logoImageView];
        _logoImageView.sd_layout
        .centerXEqualToView(self.view)
        .bottomSpaceToView(self.view, CGFloatIn320(23))
        .widthIs(CGFloatIn320(128))
        .heightIs(CGFloatIn320(32));
    }
    return _logoImageView;
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

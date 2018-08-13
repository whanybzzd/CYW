//
//  CYWForgetagainGestureViewController.m
//  CYW
//
//  Created by jktz on 2017/11/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWForgetagainGestureViewController.h"
#import "CYWLoginViewModel.h"
@interface CYWForgetagainGestureViewController ()

@property (nonatomic, retain) UIImageView *loginImageView;
@property (nonatomic, retain) UIImageView *usernameImageView;
@property (nonatomic, retain) UIImageView *passwordImageView;
@property (nonatomic, retain) UITextField *loginNameTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@property (nonatomic, retain) UIView *usernameView;
@property (nonatomic, retain) UIView *passwordView;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) CYWLoginViewModel *loginModel;

@end

@implementation CYWForgetagainGestureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"密码验证";
    self.view.backgroundColor=[UIColor whiteColor];
    [self loginImageView];
    [self usernameImageView];
    [self passwordImageView];
    [self loginNameTextField];
    [self usernameView];
    [self passwordTextField];
    [self passwordView];
    [self loginButton];
    
    
    [self initSubView];
    
}


- (void)initSubView{
   
    @weakify(self)
    //将用户的头像保存在本地
    [self.loginImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"photo"]]] placeholder:[UIImage imageNamed:@"icon_avater"]];
    
    self.loginModel=[[CYWLoginViewModel alloc] init];
    RAC(self.loginButton,backgroundColor)=[[RACSignal combineLatest:@[self.loginNameTextField.rac_textSignal,self.passwordTextField.rac_textSignal] reduce:^(NSString *username,NSString *password){
        
        return @([NSString isNotEmpty:username]&&[NSString isNotEmpty:password]);
    }]map:^id _Nullable(id  _Nullable value) {
        @strongify(self)
        self.loginButton.userInteractionEnabled=[value boolValue]?YES:NO;
        return [value boolValue]?[UIColor colorWithHexString:@"#f52735"]:[UIColor colorWithHexString:@"d5d6db"];
    }];
    
    //login
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        @strongify(self);
        [self hideKeyboard];
        self.loginModel.username=[StringUtils trimString:self.loginNameTextField.text];
        self.loginModel.password=[StringUtils trimString:self.passwordTextField.text];
        
        [self showHUDLoading:nil];
        [[self.loginModel.guestCommand execute:x] subscribeNext:^(id  _Nullable x) {
            
            @strongify(self);
            [self showResultThenHide:@"验证成功"];
            [self bk_performBlock:^(id obj) {
                
                @strongify(self);
                [self backViewControllerIndex:0];
                
            } afterDelay:1.5];
            
            
        } error:^(NSError * _Nullable error) {
            
            @strongify(self);
            [self showResultThenHide:(NSString *)error];
        }];//发送一个信号
        
        
    }];
    
}


- (UIImageView *)loginImageView{
    
    if (!_loginImageView) {
        
        _loginImageView=[UIImageView new];
        _loginImageView.image=[UIImage imageNamed:@"icon_avater"];
        _loginImageView.layer.masksToBounds=YES;
        _loginImageView.layer.cornerRadius=CGFloatIn320(28);
        [self.view addSubview:_loginImageView];
        _loginImageView.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(self.view, CGFloatIn320(kDevice_Is_iPhoneX?108:98))
        .widthIs(CGFloatIn320(56))
        .heightIs(CGFloatIn320(56));
        
    }
    return _loginImageView;
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
        
        _loginNameTextField=[[UITextField alloc] initWithFont:14 keyboardType:UIKeyboardTypeDefault placeholder:@"请输入用户名" textColor:@"#888888"];
        _loginNameTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"kCachedUserName"];
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

- (UIImageView *)passwordImageView{
    
    if (!_passwordImageView) {
        
        _passwordImageView=[UIImageView new];
        _passwordImageView.image=[UIImage imageNamed:@"icon_password"];
        _passwordImageView.layer.cornerRadius=CGFloatIn320(16.5);
        [self.view addSubview:_passwordImageView];
        _passwordImageView.sd_layout
        .leftSpaceToView(self.view, CGFloatIn320(57.5))
        .topSpaceToView(_usernameImageView, CGFloatIn320(45))
        .widthIs(CGFloatIn320(33))
        .heightIs(CGFloatIn320(33));
    }
    return _passwordImageView;
}
- (UITextField *)passwordTextField{
    
    if (!_passwordTextField) {
        
        _passwordTextField=[[UITextField alloc] initWithFont:14 keyboardType:UIKeyboardTypeDefault placeholder:@"请输入密码" textColor:@"#888888"];
        _passwordTextField.secureTextEntry = YES;
        [self.view addSubview:_passwordTextField];
        _passwordTextField.sd_layout
        .leftEqualToView(_loginNameTextField)
        .rightEqualToView(_loginNameTextField)
        .topSpaceToView(_usernameView, CGFloatIn320(48))
        .heightIs(CGFloatIn320(40));
    }
    return _passwordTextField;
}

- (UIView *)passwordView{
    if (!_passwordView) {
        
        _passwordView=[UIView new];
        _passwordView.backgroundColor=[UIColor redColor];
        [self.view addSubview:_passwordView];
        _passwordView.sd_layout
        .leftSpaceToView(_passwordImageView, CGFloatIn320(19))
        .rightSpaceToView(self.view, CGFloatIn320(50))
        .heightIs(0.5)
        .topSpaceToView(_passwordTextField, -8);
    }
    return _passwordView;
}

- (UIButton *)loginButton{
    
    if (!_loginButton) {
        
        _loginButton=[UIButton new];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_loginButton setBackgroundColor:[UIColor redColor]];
        _loginButton.layer.cornerRadius=CGFloatIn320(25);
        [self.view addSubview:_loginButton];
        _loginButton.sd_layout
        .topSpaceToView(_passwordView, CGFloatIn320(65))
        .leftSpaceToView(self.view, CGFloatIn320(58))
        .rightSpaceToView(self.view, CGFloatIn320(58))
        .heightIs(CGFloatIn320(50));
    }
    return _loginButton;
}

@end

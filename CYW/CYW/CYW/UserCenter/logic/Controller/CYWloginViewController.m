//
//  CYWloginViewController.m
//  CYW
//
//  Created by jktz on 2017/8/17.
//  Copyright © 2017年 jktz. All rights reserved.
//
#define kCachedUserPassword    @"kCachedUserModel"
#define kCachedUserName        @"kCachedUserName"
#import "CYWloginViewController.h"
#import "CYWLoginViewModel.h"
@interface CYWloginViewController ()
@property (nonatomic, retain) UIImageView *loginImageView;
@property (nonatomic, retain) UIImageView *usernameImageView;
@property (nonatomic, retain) UIImageView *passwordImageView;
@property (nonatomic, retain) UITextField *loginNameTextField;
@property (nonatomic, retain) UITextField *passwordTextField;
@property (nonatomic, retain) UIView *usernameView;
@property (nonatomic, retain) UIView *passwordView;
@property (nonatomic, retain) UIButton *loginButton;
@property (nonatomic, retain) UIButton *registerButton;
@property (nonatomic, retain) UILabel *forgetlabel;
@property (nonatomic, retain) UILabel *rememberlabel;
@property (nonatomic, retain) UIImageView *rememberImageView;
@property (nonatomic, retain) CYWLoginViewModel *loginModel;
@property (nonatomic, assign) BOOL isRember;
@property (nonatomic, retain) UIImageView *logoImageView;
@property (nonatomic, retain) UIImageView *closeImageView;
@end

@implementation CYWloginViewController

- (void) viewWillAppear: (BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void) viewWillDisappear: (BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self loginImageView];
    [self usernameImageView];
    [self passwordImageView];
    [self loginNameTextField];
    [self usernameView];
    [self passwordTextField];
    [self passwordView];
    [self loginButton];
    [self registerButton];
    [self forgetlabel];
    [self rememberlabel];
    [self rememberImageView];
    [self logoImageView];
    //[self closeImageView];
    [self initSubView];
    
}


- (void)initSubView{
    @weakify(self);
    //当用户设置了手势密码  就要清空本地保存的用户密码
    NSString *swithch=[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"];
    if ([NSString isNotEmpty:swithch]&&1==[swithch integerValue]) {
        
        [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserPassword];
    }
    
    if (!(self.params[@"forget"] ==nil)) {
        UITapGestureRecognizer *forgetTap1=[[UITapGestureRecognizer alloc] init];
        [[forgetTap1 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            
            @strongify(self)
            [self backViewController];
        }];
        [self.closeImageView addGestureRecognizer:forgetTap1];
    }
    //将用户的头像保存在本地
    [self.loginImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"photo"]]] placeholder:[UIImage imageNamed:@"icon_avater"]];
    
    //判断是否记住了密码
    self.isRember=[NSObject isEmpty:[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserPassword]]?NO:YES;
    
    
    self.loginModel=[[CYWLoginViewModel alloc] init];
    
    RAC(self.loginModel,username)=self.loginNameTextField.rac_textSignal;
    RAC(self.loginModel,password)=self.passwordTextField.rac_textSignal;
    
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
        [[NSUserDefaults standardUserDefaults] setValue:self.loginNameTextField.text forKey:kCachedUserName];
        [[StorageManager sharedInstance] setUserConfigValue:self.passwordTextField.text forKey:@"kCacheRemberPassword"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (self.isRember) {
            //记住密码
            [[StorageManager sharedInstance] setUserConfigValue:self.passwordTextField.text forKey:kCachedUserPassword];
        }else{
            //没有记住密码
            [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserPassword];
        }
        
        [self showHUDLoading:nil];
        [[self.loginModel.loginCommand execute:x] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            [self showResultThenHide:@"登录成功"];

        } error:^(NSError * _Nullable error) {
            NSLog(@"错误:%@",(NSString *)error);
            @strongify(self);
            [self showResultThenHide:(NSString *)error];
        }];//发送一个信号
        
        
    }];
    
    
    // register button
    [[self.registerButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self pushViewController:@"CYWregisterViewController" withParams:@{kParamBackType:@"0"}];
    }];
    
    
    //Remember password
    UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc] init];
    [[tapView rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self)
        self.isRember=!self.isRember;
        
    }];
    [self.rememberlabel addGestureRecognizer:tapView];
    
    //Forgot password
    UITapGestureRecognizer *forgetTap=[[UITapGestureRecognizer alloc] init];
    [[forgetTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self)
        [self pushViewController:@"CYWForgetViewController" withParams:@{kParamBackType:@"0",@"title":@"忘记密码"}];
    }];
    [self.forgetlabel addGestureRecognizer:forgetTap];
    
    
    
}

#pragma mark ---记住密码
- (void)setIsRember:(BOOL)isRember{
    
    _isRember=isRember;
    if (isRember) {
        //记住密码
        self.rememberImageView.image=[UIImage imageNamed:@"icon_select"];
    }else{
        
        self.rememberImageView.image=[UIImage imageNamed:@"icon_noselect"];
    }
}


#pragma mark --懒加载

- (UIImageView *)closeImageView{
    
    if (!_closeImageView) {
        
        _closeImageView=[UIImageView new];
        _closeImageView.userInteractionEnabled=YES;
        _closeImageView.image=[UIImage imageNamed:@"X"];
        [self.view addSubview:self.closeImageView];
        _closeImageView.sd_layout
        .topSpaceToView(self.view, CGFloatIn320(30))
        .leftSpaceToView(self.view, CGFloatIn320(20))
        .widthIs(18)
        .heightIs(17);
        
    }
    return _closeImageView;
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
        .topSpaceToView(self.view, CGFloatIn320(73))
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
        _loginNameTextField.text = [[NSUserDefaults standardUserDefaults] stringForKey:kCachedUserName];
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
        //读取缓存密码
        _passwordTextField.text=[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserPassword];
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
- (UILabel *)rememberlabel{
    if (!_rememberlabel) {
        
        _rememberlabel=[UILabel new];
        _rememberlabel.text=@"记住密码";
        _rememberlabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _rememberlabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _rememberlabel.userInteractionEnabled=YES;
        [self.view addSubview:_rememberlabel];
        _rememberlabel.sd_layout
        .rightSpaceToView(self.view, CGFloatIn320(50))
        .topSpaceToView(_passwordView, CGFloatIn320(9))
        .heightIs(14);
        [_rememberlabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _rememberlabel;
}
- (UIImageView *)rememberImageView{
    
    if (!_rememberImageView) {
        
        _rememberImageView=[UIImageView new];
        _rememberImageView.image=[UIImage imageNamed:@"icon_noselect"];
        _rememberImageView.layer.cornerRadius=CGFloatIn320(6);
        [self.view addSubview:_rememberImageView];
        _rememberImageView.sd_layout
        .rightSpaceToView(_rememberlabel, CGFloatIn320(7))
        .topSpaceToView(_passwordView, CGFloatIn320(11))
        .widthIs(CGFloatIn320(12))
        .heightIs(CGFloatIn320(12));
    }
    return _rememberImageView;
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


- (UIButton *)registerButton{
    
    if (!_registerButton) {
        
        _registerButton=[UIButton new];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
        [_registerButton setBackgroundColor:[UIColor whiteColor]];
        _registerButton.layer.borderColor=[UIColor colorWithHexString:@"#EAB3B6"].CGColor;
        _registerButton.layer.borderWidth=1.0f;
        _registerButton.layer.cornerRadius=CGFloatIn320(25);
        [self.view addSubview:_registerButton];
        _registerButton.sd_layout
        .topSpaceToView(_loginButton, CGFloatIn320(9))
        .leftEqualToView(_loginButton)
        .rightEqualToView(_loginButton)
        .heightIs(CGFloatIn320(50));
    }
    return _registerButton;
}

- (UILabel *)forgetlabel{
    if (!_forgetlabel) {
        
        _forgetlabel=[UILabel new];
        _forgetlabel.text=@"忘记密码?";
        _forgetlabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _forgetlabel.font=[UIFont systemFontOfSize:15];
        _forgetlabel.userInteractionEnabled=YES;
        [self.view addSubview:_forgetlabel];
        _forgetlabel.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(_registerButton, CGFloatIn320(65))
        .heightIs(15);
        [_forgetlabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _forgetlabel;
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

- (BOOL)shouldAutorotate
{
    
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
@end

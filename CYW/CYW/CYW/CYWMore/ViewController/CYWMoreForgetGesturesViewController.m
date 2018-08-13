//
//  CYWMoreForgetGesturesViewController.m
//  CYW
//
//  Created by jktz on 2017/10/25.
//  Copyright © 2017年 jktz. All rights reserved.
//
#import "AppDelegate.h"
#import "CYWMoreForgetGesturesViewController.h"
#import "LockView.h"
#import "UIView+Extension.h"
#import "CYWMoreGestureViewModel.h"
@interface CYWMoreForgetGesturesViewController ()<LockViewDelegate>
@property (nonatomic, retain) UIImageView *loginImageView;
@property (nonatomic, retain) UILabel *guestlabel;
@property (nonatomic, retain) UIImageView *closeImageView;
@property (nonatomic, retain) UIView *bottomView;
@property(retain,nonatomic)LockView *lockview;
@property (nonatomic, retain) UILabel *otherlabel;
@property (nonatomic, retain) UILabel *guestpasswordlabel;
@property (nonatomic, retain) CYWMoreGestureViewModel *gestureViewModel;
//标记是否是重置密码
@property(nonatomic ,assign,getter=isresetpassword)BOOL resetpassword;
//判断是否是两次确认密码
@property(nonatomic,assign,getter=istwopassword)BOOL twopassword;
//标记登录的方式
@property(nonatomic,assign,getter=isloginType)BOOL loginType;
@property (nonatomic, assign) BOOL closeGuest;
@end

@implementation CYWMoreForgetGesturesViewController


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self initBarManager];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [MXNavigationBarManager reStoreToSystemNavigationBar];
}


- (void)initBarManager {
    //optional, save navigationBar status
    
    //required
    [MXNavigationBarManager managerWithController:self];
    [MXNavigationBarManager setBarColor:[UIColor clearColor]];
    
    //optional
    [MXNavigationBarManager setTintColor:[UIColor blackColor]];
    [MXNavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.gestureViewModel=[[CYWMoreGestureViewModel alloc] init];
    self.resetpassword=NO;
    self.twopassword = NO;
    self.closeGuest=NO;
    self.loginType=NO;
    [self loginImageView];
    [self guestlabel];
    [self lockview];
    [self bottomView];
    [self initSubView];
}

- (void)initSubView{
    
    
    if ([self.params[@"pushType"] isEqualToString:@"1"]) {
        [self.view addSubview:self.closeImageView];
        self.navigationItem.title=@"忘记手势密码";
        self.guestlabel.text=@"请输入原手势密码";
        //忘记密码
        self.resetpassword=YES;
        [self.bottomView setHidden:YES];
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"guesture"];
        
    }else if ([self.params[@"pushType"] isEqualToString:@"2"]){
        
        [self.view addSubview:self.closeImageView];
        self.navigationItem.title=@"关闭手势密码";
        self.guestlabel.text=@"请输入原手势密码";
        self.resetpassword=NO;
        self.closeGuest=YES;
        [self.bottomView setHidden:YES];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"guesture"];
        
    }
    else{
        
        self.guestlabel.text=@"请输入手势密码";
        //直接登录
        self.resetpassword=NO;
        self.closeGuest=NO;
        [self.bottomView setHidden:NO];
        
        [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"guesture"];
        
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    @weakify(self)
    [self.loginImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"photo"]]] placeholder:[UIImage imageNamed:@"icon_avater"]];
    
    
    UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc] init];
    [[tapView rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self)
        [self pushViewController:@"CYWloginViewController" withParams:@{@"forget":@"1"}];
        
    }];
    [self.otherlabel addGestureRecognizer:tapView];
    
    
    UITapGestureRecognizer *tapView1=[[UITapGestureRecognizer alloc] init];
    [[tapView1 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"switch" object:nil];
        [self dismissPrestingViewController];
        
    }];
    [_closeImageView addGestureRecognizer:tapView1];
    
    
}


//lockview的代理方法
- (BOOL)unlockView:(LockView *)unlockView withPassword:(NSString *)password
{
    
    NSLog(@"password:%@",password);
    
    NSString *localpasswordone = [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserGuestPasswordOne];
    NSString *localpasswordtwo = [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserGuestPasswordTwo];
    
    
    NSLog(@"localpasswordone==:%@ localpasswordtwo:%@",localpasswordone,localpasswordtwo);
    
    if (self.resetpassword) {
        
        if (!self.twopassword) {
            
            NSLog(@"验证通过");
            self.twopassword=[self validation:password];
            return NO;
        }else{
            
            if (![localpasswordone isEqualToString:localpasswordtwo]){
                
                self.guestlabel.text=@"两次密码不一致";
                [self.guestlabel sizeToFit];
                self.guestlabel.textColor=[UIColor colorWithHexString:@"#f52735"];
                [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserGuestPasswordTwo];
                
            }else{
                
                self.guestlabel.text=@"手势密码更新中...";
                self.guestlabel.textColor=[UIColor colorWithHexString:@"#666666"];
                [self.guestlabel sizeToFit];
                
                @weakify(self)
                NSLog(@"111111111==:%@ 22222222:%@",localpasswordone,localpasswordtwo);
                self.gestureViewModel.password=localpasswordtwo;
                [self showHUDLoading:@"修改中..."];
                [[self.gestureViewModel.refreshforgetCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                    
                    NSLog(@"成功");
                    @strongify(self)
                    [self showResultThenBack:@"修改成功"];
                    
                } error:^(NSError * _Nullable error) {
                    @strongify(self)
                    [self showResultThenHide:@"修改手势密码失败"];
                    self.guestlabel.text=@"修改手势密码失败";
                    
                }];
                
                
            }
            
        }
        
    }else{
        
        if (!self.closeGuest) {
            
            
            //直接登录
            self.guestlabel.text=@"正在登录";
            self.guestlabel.textColor=[UIColor colorWithHexString:@"#666666"];
            
            @weakify(self)
            
            self.gestureViewModel.password=password;
            [self showHUDLoading:@"正在登录..."];
            [[self.gestureViewModel.refreshUnlockloginCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                
                @strongify(self)
                NSLog(@"登录成功");
                [self showResultThenHide:@"登录成功"];
                
            } error:^(NSError * _Nullable error) {
                @strongify(self)
                self.guestlabel.textColor=[UIColor colorWithHexString:@"#f52735"];
                [self showResultThenHide:@"登录失败"];
                self.guestlabel.text=@"登录失败";
            }];
            
        }else{
            
            //关闭手势密码_refreshvalidationCommand
            NSLog(@"关闭手势密码：%@",password);
            
            
            
            self.guestlabel.text=@"正在验证";
            self.guestlabel.textColor=[UIColor colorWithHexString:@"#666666"];
            
            
            @weakify(self)
            self.gestureViewModel.password=password;
            [self showHUDLoading:@"正在验证..."];
            [[self.gestureViewModel.refreshvalidationCommand execute:nil] subscribeNext:^(id  _Nullable x) {
                
                
                NSLog(@"关闭成功");
                @strongify(self)
                
                [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"switch"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"switch" object:nil];
                [self showResultThenBack:@"关闭成功"];
                
            } error:^(NSError * _Nullable error) {
                @strongify(self)
                [[NSNotificationCenter defaultCenter] postNotificationName:@"switch" object:nil];
                self.guestlabel.textColor=[UIColor colorWithHexString:@"#f52735"];
                [self showResultThenHide:@"关闭失败"];
                self.guestlabel.text=@"手势密码错误";
            }];
            
            
            
        }
        
        
    }
    
    return NO;
    
    
    
}

- (void)setPassWordSuccess:(NSString *)tabelname{
    self.twopassword=YES;
    self.guestlabel.text=tabelname;
    self.guestlabel.textColor=[UIColor colorWithHexString:@"#666666"];
    [self.guestlabel sizeToFit];
}

- (void)setPassWordFailer:(NSString *)name{
    
    self.guestlabel.text=name;
    self.guestlabel.textColor=[UIColor colorWithHexString:@"#f52735"];
    [self.guestlabel sizeToFit];
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
        .topSpaceToView(self.view, CGFloatIn320(kDevice_Is_iPhoneX?88:78))
        .widthIs(CGFloatIn320(56))
        .heightIs(CGFloatIn320(56));
        
    }
    return _loginImageView;
}
- (UILabel *)guestlabel{
    if (!_guestlabel) {
        
        _guestlabel=[UILabel new];
        _guestlabel.text=@"确认手势密码";
        _guestlabel.textColor=[UIColor colorWithHexString:@"#666666"];
        _guestlabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [self.view addSubview:_guestlabel];
        _guestlabel.sd_layout
        .centerXEqualToView(self.view)
        .topSpaceToView(_loginImageView, CGFloatIn320(42))
        .heightIs(14);
        [_guestlabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _guestlabel;
}

- (LockView *)lockview{
    if (!_lockview) {
        
        _lockview=[LockView new];
        _lockview.backgroundColor=[UIColor whiteColor];
        _lockview.delegate=self;
        _lockview.width = 300;
        _lockview.height = 300;
        _lockview.x = (SCREEN_WIDTH - _lockview.width) * 0.5;
        _lockview.y = CGFloatIn320(220);
        [self.view addSubview:_lockview];
    }
    return _lockview;
}
- (UIView *)bottomView{
    if (!_bottomView) {
        
        _bottomView=[UIView new];
        [_bottomView setHidden:NO];
        [self.view addSubview:_bottomView];
        _bottomView.sd_layout
        .bottomSpaceToView(self.view, CGFloatIn320(60))
        .centerXEqualToView(self.view)
        .widthIs(CGFloatIn320(150))
        .heightIs(CGFloatIn320(15));
        
        
        
        self.otherlabel=[UILabel new];
        self.otherlabel.text=@"其他方式登录";
        self.otherlabel.userInteractionEnabled=YES;
        self.otherlabel.textColor=[UIColor colorWithHexString:@"#4f88fa"];
        self.otherlabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [_bottomView addSubview:self.otherlabel];
        self.otherlabel.sd_layout
        .centerXEqualToView(_bottomView)
        .heightIs(12);
        [self.otherlabel setSingleLineAutoResizeWithMaxWidth:220];
        
        
    }
    return _bottomView;
}

- (UIImageView *)closeImageView{
    
    if (!_closeImageView) {
        
        _closeImageView=[UIImageView new];
        _closeImageView.userInteractionEnabled=YES;
        _closeImageView.image=[UIImage imageNamed:@"X"];
        [self.view addSubview:_closeImageView];
        _closeImageView.sd_layout
        .topSpaceToView(self.view, CGFloatIn320(kDevice_Is_iPhoneX?88:64))
        .leftSpaceToView(self.view, CGFloatIn320(20))
        .widthIs(18)
        .heightIs(17);
        
    }
    return _closeImageView;
}

- (BOOL)validation:(NSString *)password{
    @weakify(self)
    __block BOOL vali=NO;
    self.gestureViewModel.password=password;
    [self showHUDLoading:@"正在验证..."];
    [[self.gestureViewModel.refreshvalidationCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        [self hideHUDLoading];
        [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserGuestPasswordOne];
        [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserGuestPasswordTwo];
        NSLog(@"验证成功");
        self.guestlabel.text=@"请输入手势密码";
        [self.guestlabel sizeToFit];
        self.guestlabel.textColor=[UIColor colorWithHexString:@"#666666"];
        
        vali=YES;
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self hideHUDLoading];
        self.guestlabel.text=@"手势密码错误";
        self.guestlabel.textColor=[UIColor colorWithHexString:@"#f52735"];
        vali=NO;
    }];
    return vali;
}

- (void)dealloc{
    
    self.lockview=nil;
    NSLog(@"忘记手势密码销毁");
}
@end

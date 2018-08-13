//
//  CYWMoreGestureViewController.m
//  CYW
//
//  Created by jktz on 2017/10/20.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreGestureViewController.h"
#import "LockView.h"
#import "UIView+Extension.h"
#import "CYWMoreGestureViewModel.h"
@interface CYWMoreGestureViewController ()<LockViewDelegate>
@property (nonatomic, retain) UIImageView *loginImageView;
@property (nonatomic, retain) UILabel *guestlabel;
@property (nonatomic, retain) UIView *bottomView;

@property (nonatomic, retain) UILabel *otherlabel;
@property (nonatomic, retain) UILabel *guestpasswordlabel;
@property(retain,nonatomic)LockView *lockview;
@property (nonatomic, retain) UIImageView *closeImageView;
//标记是否是重置密码
@property(nonatomic ,assign,getter=isresetpassword)BOOL resetpassword;
//判断是否是两次确认密码
@property(nonatomic,assign,getter=istwopassword)BOOL twopassword;
//标记登录的方式
@property(nonatomic,assign,getter=isloginType)BOOL loginType;
@property (nonatomic, retain) CYWMoreGestureViewModel *gestureViewModel;

@property(nonatomic ,assign,getter=isresetpassword)BOOL resetpasswordfirst;
@property (nonatomic, retain) UIView *typeView;
@property (nonatomic, retain) UILabel *typelabel;



@end

@implementation CYWMoreGestureViewController

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
    self.resetpasswordfirst=NO;//是否为第一次设置手势密码
    self.twopassword = NO;
    self.loginType=NO;
    [self loginImageView];
    [self guestlabel];
    [self bottomView];
    [self typeView];
    [self lockview];//type 1   present
    if (1==[self.params[@"type"] integerValue]) {
        
        [self closeImageView];
        [self.bottomView setHidden:YES];
        [self.typeView setHidden:NO];
        self.twopassword=YES;
        self.guestlabel.text=@"设置手势密码";
        
    }
    if (1==[self.params[@"forget"]integerValue]) {
        
        self.navigationItem.title=@"忘记手势密码";
        self.guestlabel.text=@"请输入原手势密码";
        self.resetpassword=YES;
        [self.guestlabel sizeToFit];
        [self.bottomView setHidden:YES];
    }
    
    [self initSubView];
    
}

- (void)initSubView{
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
        [self pushViewController:@"CYWMoreGestureViewController" withParams:@{@"forget":@"1"}];
    }];
    [self.guestpasswordlabel addGestureRecognizer:tapView1];
    
    
    UITapGestureRecognizer *tapView12=[[UITapGestureRecognizer alloc] init];
    [[tapView12 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        
        @strongify(self)
        [self pushViewController:@"CYWMoreGestureViewController" withParams:@{@"forget":@"1"}];
    }];
    [self.typelabel addGestureRecognizer:tapView12];
    
    
    UITapGestureRecognizer *tapView2=[[UITapGestureRecognizer alloc] init];
    [[tapView2 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self)
        [self dismissPrestingViewController];
        
    }];
    [_closeImageView addGestureRecognizer:tapView2];
    
}
//lockview的代理方法
- (BOOL)unlockView:(LockView *)unlockView withPassword:(NSString *)password
{
    NSLog(@"password:%@",password);
    
    NSString *localpasswordone = [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserGuestPasswordOne];
    NSString *localpasswordtwo = [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserGuestPasswordTwo];
    
    
    NSLog(@"localpasswordone==:%@ localpasswordtwo:%@",localpasswordone,localpasswordtwo);
    
        
        if (self.twopassword) {
            if ([localpasswordone isEqualToString:localpasswordtwo]) {
                
                self.guestlabel.text=@"请再次输入手势密码";
                self.twopassword = NO;
                self.resetpasswordfirst=YES;
                self.resetpassword=NO;
                return YES;
            }
            else
            {
                [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserGuestPasswordOne];
                [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserGuestPasswordTwo];
                self.guestlabel.text=@"设置密码";
                return NO;
            }
        }
        
        else
            
        {
            if ([password isEqualToString:localpasswordone]) {
                if (self.isresetpassword) {
                    [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserGuestPasswordOne];
                    [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserGuestPasswordTwo];
                    self.guestlabel.text=@"设置新密码";
                    self.guestlabel.textColor=[UIColor colorWithHexString:@"#666666"];
                    self.resetpassword = NO;
                    self.loginType=YES;
                }
                else
                {
                    if (self.resetpasswordfirst) {
                        
                        self.guestlabel.text=@"第一次设置手势密码";
                        self.guestlabel.textColor=[UIColor colorWithHexString:@"#666666"];
                    }else{
                        
                        
                        if (self.loginType) {
                            
                            self.guestlabel.text=@"访问后台重置手势密码";
                            self.guestlabel.textColor=[UIColor colorWithHexString:@"#666666"];
                        }else{
                            
                            self.guestlabel.text=@"访问后台登录";
                            self.guestlabel.textColor=[UIColor colorWithHexString:@"#666666"];
                        }
                    }
                    
                    
                    
                }
                return YES;
            }
            else {
                
                self.guestlabel.text=@"密码错误";
                [self.guestlabel sizeToFit];
                self.guestlabel.textColor=[UIColor colorWithHexString:@"#f52735"];
                
                return NO;
            }
            return NO;
        }
    
    
    
}

- (void)setPassWordSuccess:(NSString *)tabelname{
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
        .rightSpaceToView(_bottomView, 0)
        .heightIs(12);
        [self.otherlabel setSingleLineAutoResizeWithMaxWidth:120];
        
        
        self.guestpasswordlabel=[UILabel new];
        self.guestpasswordlabel.text=@"忘记手势密码";
        self.guestpasswordlabel.userInteractionEnabled=YES;
        self.guestpasswordlabel.textColor=[UIColor colorWithHexString:@"#4f88fa"];
        self.guestpasswordlabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [_bottomView addSubview:self.guestpasswordlabel];
        self.guestpasswordlabel.sd_layout
        .leftSpaceToView(_bottomView, 0)
        .heightIs(12);
        [self.guestpasswordlabel setSingleLineAutoResizeWithMaxWidth:120];

    }
    return _bottomView;
}

- (UIView *)typeView{
    
    if (!_typeView) {
        
        _typeView=[UIView new];
        [_typeView setHidden:YES];
        [self.view addSubview:_typeView];
        _typeView.sd_layout
        .bottomSpaceToView(self.view, CGFloatIn320(60))
        .centerXEqualToView(self.view)
        .widthIs(CGFloatIn320(150))
        .heightIs(CGFloatIn320(15));
        
        self.typelabel=[UILabel new];
        self.typelabel.text=@"忘记手势密码";
        self.typelabel.userInteractionEnabled=YES;
        self.typelabel.textColor=[UIColor colorWithHexString:@"#4f88fa"];
        self.typelabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [_typeView addSubview:self.typelabel];
        self.typelabel.sd_layout
        .centerXEqualToView(_typeView)
        .heightIs(12);
        [self.typelabel setSingleLineAutoResizeWithMaxWidth:120];
    }
    return _typeView;
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

- (UIImageView *)closeImageView{
    
    if (!_closeImageView) {
        
        _closeImageView=[UIImageView new];
        _closeImageView.userInteractionEnabled=YES;
        _closeImageView.image=[UIImage imageNamed:@"X"];
        [self.view addSubview:_closeImageView];
        _closeImageView.sd_layout
        .topSpaceToView(self.view, CGFloatIn320(kDevice_Is_iPhoneX?88:64))
        .leftSpaceToView(self.view, CGFloatIn320(20))
        .widthIs(15)
        .heightIs(14);
        
    }
    return _closeImageView;
}
@end

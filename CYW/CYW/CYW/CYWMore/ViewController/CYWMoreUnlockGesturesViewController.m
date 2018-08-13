//
//  CYWMoreUnlockGesturesViewController.m
//  CYW
//
//  Created by jktz on 2017/10/25.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreUnlockGesturesViewController.h"
#import "LockView.h"
#import "UIView+Extension.h"
#import "CYWMoreGestureViewModel.h"
@interface CYWMoreUnlockGesturesViewController ()<LockViewDelegate>
@property (nonatomic, retain) UIImageView *loginImageView;
@property (nonatomic, retain) UILabel *guestlabel;
@property(retain,nonatomic)LockView *lockview;
@property (nonatomic, retain) UIImageView *closeImageView;
@property (nonatomic, retain) CYWMoreGestureViewModel *gestureViewModel;
//标记是否是重置密码
@property(nonatomic ,assign,getter=isresetpassword)BOOL resetpassword;
//判断是否是两次确认密码
@property(nonatomic,assign,getter=istwopassword)BOOL twopassword;
//标记登录的方式
@property(nonatomic,assign,getter=isloginType)BOOL loginType;

@end

@implementation CYWMoreUnlockGesturesViewController

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
    self.loginType=NO;
    [self loginImageView];
    [self guestlabel];
    [self lockview];
    [self closeImageView];
    [self initSubView];
     [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"guesture"];
}

- (void)initSubView{
    
    self.resetpassword=YES;
    @weakify(self)
    [self.loginImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,[[NSUserDefaults standardUserDefaults] objectForKey:@"photo"]]] placeholder:[UIImage imageNamed:@"icon_avater"]];
    
    
    UITapGestureRecognizer *tapView2=[[UITapGestureRecognizer alloc] init];
    [[tapView2 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"switch" object:nil];
        [self dismissPrestingViewController];
        
        
        
    }];
    [_closeImageView addGestureRecognizer:tapView2];
    
    //清空掉缓存下来的密码
    [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserGuestPasswordOne];
    [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserGuestPasswordTwo];
    
}


//lockview的代理方法
- (BOOL)unlockView:(LockView *)unlockView withPassword:(NSString *)password
{
    NSLog(@"password:%@",password);
    
    NSString *localpasswordone = [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserGuestPasswordOne];
    NSString *localpasswordtwo = [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserGuestPasswordTwo];
    
    
    NSLog(@"localpasswordone==:%@ localpasswordtwo:%@",localpasswordone,localpasswordtwo);
    
    if ([password isEqualToString:localpasswordone]) {
        self.guestlabel.text=@"开启手势密码中";
        self.guestlabel.textColor=[UIColor colorWithHexString:@"#666666"];
        
        NSString *localpasswordone = [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserGuestPasswordOne];
        NSString *localpasswordtwo = [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserGuestPasswordTwo];
        
        @weakify(self)
        NSLog(@"111111111==:%@ 22222222:%@",localpasswordone,localpasswordtwo);
        self.gestureViewModel.password=localpasswordtwo;
        [self showHUDLoading:@"开启手势密码中..."];
        [[self.gestureViewModel.refreshUnlockCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            
            @strongify(self)
            [self bk_performBlock:^(id obj) {
                @strongify(self)
                [self showHUDLoading:@"开启手势密码成功"];
                [self dismissPrestingViewController];
            } afterDelay:1.5];
            
            
        } error:^(NSError * _Nullable error) {
            @strongify(self)
            [self showResultThenHide:@"开启手势密码错误..."];
        }];
        
    }else if (![localpasswordone isEqualToString:localpasswordtwo]){
        self.guestlabel.text=@"两次密码不一致";
        [self.guestlabel sizeToFit];
        self.guestlabel.textColor=[UIColor colorWithHexString:@"#f52735"];
        [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserGuestPasswordTwo];
        return NO;
    }
    
    return NO;
    
    
    
    
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
        .topSpaceToView(self.view, CGFloatIn320(68))
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

- (void)dealloc{
    self.lockview=nil;
    NSLog(@"销毁");
}
@end

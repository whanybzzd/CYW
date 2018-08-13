//
//  CYWMoreBottomView.m
//  CYW
//
//  Created by jktz on 2017/10/19.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreBottomView.h"
#import "AppDelegate.h"
@interface CYWMoreBottomView()
@property (nonatomic, retain) UIButton *outButton;

@end
@implementation CYWMoreBottomView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        self.height=CGFloatIn320(150);
        [self outButton];
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
    [[self.outButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
       
        UIAlertView *alertView=[[UIAlertView alloc] bk_initWithTitle:@"提示" message:@"确定退出吗?"];
        [alertView bk_addButtonWithTitle:@"确定" handler:^{
            
            [[Login sharedInstance] clearLoginData];
            
            
            NSString *swithch=[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"];
            if ([NSString isNotEmpty:swithch]&&1==[swithch integerValue]) {
                
                [((AppDelegate *)[UIApplication sharedApplication].delegate) setUpGueTabbarController];//手势登录
                
            }else{
                
                [((AppDelegate *)[UIApplication sharedApplication].delegate) setUpTabbarController];//setUpTabbarController
            }
        }];
        [alertView bk_addButtonWithTitle:@"取消" handler:^{
            
        }];
        [alertView show];
    }];
}
- (UIButton *)outButton{
    if (!_outButton) {
        
        _outButton=[UIButton new];
        [_outButton setTitle:@"退出" forState:UIControlStateNormal];
        _outButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _outButton.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
        [_outButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:_outButton];
        _outButton.sd_layout
        .leftSpaceToView(self, 15)
        .rightSpaceToView(self, 15)
        .topSpaceToView(self, CGFloatIn320(30))
        .heightIs(CGFloatIn320(40));
    }
    return _outButton;
}

@end

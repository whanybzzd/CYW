//
//  ViewController.m
//  CYW
//
//  Created by ZMJ on 2018/5/16.
//  Copyright © 2018年 ZMJ. All rights reserved.
//

#import "ViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIButton *but=[UIButton new];
    but.backgroundColor=[UIColor redColor];
    [but setTitle:@"登录" forState:UIControlStateNormal];
    [but setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    but.layer.cornerRadius=5;
    [self.view addSubview:but];
    
    but.sd_layout
    .leftSpaceToView(self.view, 15)
    .rightSpaceToView(self.view, 15)
    .topSpaceToView(self.view, 100)
    .heightIs(40);
    
}




@end

//
//  CYWAssetsWithdrawalsViewController.m
//  CYW
//
//  Created by jktz on 2017/10/16.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsWithdrawalsViewController.h"
#import "AssetsWithdrawalsTableViewCell.h"
#import "CYWAssetsWithdrawalsHeadView.h"
#import "CYWArctileViewController.h"
@interface CYWAssetsWithdrawalsViewController ()<UITableViewDelegate,UITableViewDataSource,AssetsWithdrawalsTableViewCellDelegate>
@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) CYWAssetsWithdrawalsHeadView *withdrawalsHeadView;
@property (nonatomic, retain) UIButton *button;
@end

@implementation CYWAssetsWithdrawalsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.withdrawalsHeadView loadMoney];//重新赋值
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.view.backgroundColor=[UIColor whiteColor];
  
    //1  充值   2 提现
    if (1==[self.params[@"type"] integerValue]) {
        
         self.navigationItem.title=@"充值";
        self.withdrawalsHeadView.height=CGFloatIn320(240);
        self.withdrawalsHeadView.hide=YES;
        
    }else{
        
         self.navigationItem.title=@"提现";
        self.withdrawalsHeadView.height=CGFloatIn320(320);
         self.withdrawalsHeadView.hide=NO;
    }
    
    
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self.button setTitle:[NSString stringWithFormat:@"%@记录",self.navigationItem.title] forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    self.button.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.button];
    
    [self tableView];
}

- (void)buttonClick:(UIButton *)sender{
    
    [self pushViewController:@"CYWAssetsRecordViewController"];
}

#pragma mark 懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-getRectNavAndStatusHight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=NO;
        _tableView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        _tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[AssetsWithdrawalsTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        _tableView.tableHeaderView=self.withdrawalsHeadView;
        [self.view addSubview:_tableView];
        
    }
    return _tableView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 210.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AssetsWithdrawalsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    if (1==[self.params[@"type"] integerValue]) {
        
        cell.detailabel.text=[self recharge];
        cell.titlestring=[self recharge];
        
    }else{
        cell.delegate=self;
        cell.detailabel.text=[self withdrawal];
        cell.titlestring=[self withdrawal];
        [cell.titlabel setAttributedText:[NSMutableAttributedString withTitleString:@"温馨提示:(提现到账时间表)" RangeString:@"提现到账时间表" ormoreString:nil color:[UIColor colorWithHexString:@"#75a9f7"]]];
        [cell.titlabel sizeToFit];
    }
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CYWAssetsWithdrawalsHeadView *)withdrawalsHeadView{
    
    if (!_withdrawalsHeadView) {
        
        _withdrawalsHeadView=[CYWAssetsWithdrawalsHeadView new];
    }
    return _withdrawalsHeadView;
}

- (void)labelClick{
    
    CYWArctileViewController *arctiVC=[[CYWArctileViewController alloc] init];
    arctiVC.title=@"提现明细";
    NSString *loadUrl=[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,@"/mobile/withdrawtime_app"];
    [arctiVC loadWebURLSring:loadUrl];
    arctiVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:arctiVC animated:YES];
    
}

//充值
- (NSString *)recharge{
    
    return @"1、您的账户资金将通过第三方托管乾多多进行充值。\n2、已实名认证用户，无需再登陆乾多多实名认证，请忽略乾多多充值页面提示。年龄在60岁以上的客户，需登陆第 三方乾多多上传身份证及手持身份证照片认证(my.moneymoremore.com)，审核后即可充值。\n3、禁止洗钱、信用卡套现、虚假交易等行为，一经发现并确认，将终止该账户的使用。\n4、如充值遇到问题，请联系客服400-863-9333、QQ群475668242。";
}

//提现
- (NSString *)withdrawal{
    
    return @"1、您的账户资金将通过第三方托管乾多多进行提现。\n2、已实名认证用户，无需再登陆乾多多实名认证，请忽略乾多多充值页面提示。年龄在60岁以上的客户，需登陆第 三方乾多多上传身份证及手持身份证照片认证(my.moneymoremore.com)，审核后即可充值。\n3、快捷充值提现需同卡进出，请用充值银行卡进行提现，如多张卡充值，请分别提现，网银充值不限。\n4、禁止洗钱、信用卡套现、虚假交易等行为，一经发现并确认，将终止该账户的使用。\n5、如充值遇到问题，请联系客服400-863-9333、QQ群475668242。";
}

- (void)dealloc{
    
    NSLog(@"提现或者充值销毁");
}
@end

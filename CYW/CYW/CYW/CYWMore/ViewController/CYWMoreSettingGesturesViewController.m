//
//  CYWMoreSettingGesturesViewController.m
//  CYW
//
//  Created by jktz on 2017/10/25.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreSettingGesturesViewController.h"
#import "CYWMoreSettingGuesturesTableViewCell.h"
@interface CYWMoreSettingGesturesViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *userCenterItemArray;

@end

@implementation CYWMoreSettingGesturesViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"设置手势密码";
    
    
    [self tableView];
}

- (UITableView *)tableView{
    
    
    if (!_tableView) {
        
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-getRectNavAndStatusHight-20) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[CYWMoreSettingGuesturesTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        [self.view addSubview:_tableView];
        if (@available(ios 11.0,*)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
        
        NSArray *section=@[@"开启手势密码锁",@"修改手势密码"];
        [self.userCenterItemArray addObject:section];
        
        NSArray *section1=@[@"忘记手势密码"];
        [self.userCenterItemArray addObject:section1];
        
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSInteger row= [[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"] integerValue];
    return row==1?[self.userCenterItemArray[section] count]:1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSInteger row= [[[NSUserDefaults standardUserDefaults] objectForKey:@"switch"] integerValue];
    return row==1?[self.userCenterItemArray count]:1;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    @weakify(self)
    NSString *item = ((NSArray *)self.userCenterItemArray[indexPath.section])[indexPath.row];
    CYWMoreSettingGuesturesTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.label.text=item;
    cell.indexPath=indexPath;
    
    [cell setSwitchSelect:^(BOOL select) {
        
        @strongify(self)
        [self selectSwitch:select];
    }];
    return cell;
}

- (void)selectSwitch:(BOOL)select{
    
    
    NSLog(@"select:%zd",select);
    if (select) {
        
        [self presentingViewController:@"CYWMoreUnlockGesturesViewController"];
    }else{
        
        //关闭手势密码
        [self presentingViewController:@"CYWMoreForgetGesturesViewController" withParams:@{@"pushType":@"2"}];
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (indexPath.section==0&&indexPath.row==1) {
        
        [self presentingViewController:@"CYWMoreForgetGesturesViewController" withParams:@{@"pushType":@"1"}];
        
        
    }
    else if (indexPath.section==1){
        
        @weakify(self)
        UIAlertView *alertView=[UIAlertView bk_alertViewWithTitle:nil message:@"忘记手势，可以使用账号密码登录，登录后需要重新绘制手势密码"];
        [alertView bk_addButtonWithTitle:@"取消" handler:nil];
        [alertView bk_addButtonWithTitle:@"密码登录" handler:^{
            
            @strongify(self)
            [self pushViewController:@"CYWForgetagainGestureViewController"];
            
        }];
        [alertView show];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 0.01f;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
- (NSMutableArray *)userCenterItemArray{
    if (!_userCenterItemArray) {
        
        _userCenterItemArray=[NSMutableArray array];
    }
    return _userCenterItemArray;
}

- (void)dealloc{
    
    NSLog(@"设置手势密码销毁");
}

@end

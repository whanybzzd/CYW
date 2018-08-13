//
//  CYWMoreUserCenterAuthenticationViewController.m
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

@interface CYWUserCenterAuthenticationItemModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *viewController;

@end
@implementation CYWUserCenterAuthenticationItemModel @end

#import "CYWMoreUserCenterAuthenticationViewController.h"
#import "CYWMoreUserCenterAuthenticationTableViewCell.h"
#import "CYWMoreUserCenterAuthenticationViewModel.h"
@interface CYWMoreUserCenterAuthenticationViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) UIView *headView;
@property (nonatomic, retain) UIView *footView;
@property (nonatomic, retain) NSMutableArray *userCenterItemArray;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UIImageView *autoImageView;
@property (nonatomic, retain) UILabel *autolabel;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *idCar;

@property (nonatomic, retain) NSObject *object;
@property (nonatomic, retain) CYWMoreUserCenterAuthenticationViewModel *authenticationModel;
@property (nonatomic, retain) NSArray *array;

@end

@implementation CYWMoreUserCenterAuthenticationViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self authentication];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"实名认证";
    self.view.backgroundColor=[UIColor whiteColor];
    self.authenticationModel=[[CYWMoreUserCenterAuthenticationViewModel alloc] init];
    self.array=@[@"请输入真实姓名",@"请输入真实省份证号码"];
    [self tableView];
}

- (void)authentication{
    
    //读取换成实名认证的信息
    self.object=[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserAuthentication];
    if ([NSObject isEmpty:self.object]) {
        
        self.autoImageView.image=[UIImage imageNamed:@"icon_ authentication_no"];
        self.autolabel.text=@"你还未进行实名认证";
        [self.submitButton setHidden:NO];
    }else{
        
        self.autoImageView.image=[UIImage imageNamed:@"icon_user_ authentication"];
        self.autolabel.text=@"你已通过实名认证";
        [self.submitButton setHidden:YES];
    }
}


- (void)initSubView{
    
    @weakify(self)
    [self.userCenterItemArray removeAllObjects];
    
    NSArray *section=@[[self itemNameString:@"姓名" withIcon:@"icon_ authentication_name" withValue:nil withitemController:@""],
                       [self itemNameString:@"身份证" withIcon:@"icon_ authentication_idcar" withValue:nil withitemController:@""]];
    [self.userCenterItemArray addObject:section];
    
    
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        if ([NSString isEmpty:self.name]) {
            [self showResultThenHide:@"请输入姓名"];
            return ;
        }
        if ([NSString isEmpty:self.idCar]) {
            
            [self showResultThenHide:@"请输入身份证号码"];
            return;
        }
        self.authenticationModel.name=self.name;
        self.authenticationModel.idCar=self.idCar;
        [self loadData];
    }];
    
}

- (void)loadData{
    
    @weakify(self)
     [self showHUDLoading:nil];
    [[self.authenticationModel.refreshAuthenticationCommand execute:nil] subscribeNext:^(id x) {
        
        NSLog(@"刷新视图");
        @strongify(self)
        [self pushViewController:@"CYWAssetsBindCarViewController" withParams:@{@"url":x,@"title":@"实名认证"}];
        [self.tableView reloadData];
        [self hideHUDLoading];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        
        [self.tableView reloadData];
        [self showResultThenHide:(NSString *)error];
    }];
}

- (UITableView *)tableView{
    
    
    if (!_tableView) {
        
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-getRectNavAndStatusHight-20) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [_tableView registerClass:[CYWMoreUserCenterAuthenticationTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        _tableView.tableHeaderView=self.headView;
        _tableView.tableFooterView=self.footView;
        [self.view addSubview:_tableView];
        if (@available(ios 11.0,*)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
        
        [self initSubView];
        
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.userCenterItemArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.userCenterItemArray count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CYWUserCenterAuthenticationItemModel *item = ((NSArray *)self.userCenterItemArray[indexPath.section])[indexPath.row];
    CYWMoreUserCenterAuthenticationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.imageView.image=[UIImage imageNamed:item.icon];
    cell.textLabel.text=item.title;
    cell.textLabel.textColor=[UIColor colorWithHexString:@"#333333"];
    cell.textLabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
    cell.textField.tag=indexPath.row;
    cell.textField.placeholder=self.array[indexPath.row];
    [cell.textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
    if ([NSObject isNotEmpty:self.object]) {
        cell.indexPath=indexPath;
        [cell.textField setHidden:YES];
        [cell.detailabel setHidden:NO];
    }else{
        [cell.textField setHidden:NO];
        [cell.detailabel setHidden:YES];
        
    }
    
    return cell;
}
- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 0:
            self.name = textField.text;
            break;
        case 1:
            self.idCar = textField.text;
            break;
        default:
            break;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0f;
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews {
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

//添加头部视图和底部视图
- (UIView *)headView{
    
    if (!_headView) {
        
        _headView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFloatIn320(192))];
        _headView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        
        self.autoImageView=[UIImageView new];
        self.autoImageView.image=[UIImage imageNamed:@"icon_ authentication_no"];
        [_headView addSubview:self.autoImageView];
        self.autoImageView.sd_layout
        .centerXEqualToView(_headView)
        .topSpaceToView(_headView, CGFloatIn320(20))
        .widthIs(CGFloatIn320(76))
        .heightIs(CGFloatIn320(88));
        
        
        self.autolabel=[UILabel new];
        self.autolabel.text=@"你已通过实名认证";
        self.autolabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        self.autolabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [_headView addSubview:self.autolabel];
        self.autolabel.sd_layout
        .centerXEqualToView(_headView)
        .heightIs(14)
        .topSpaceToView(self.autoImageView, CGFloatIn320(20));
        [self.autolabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
       UILabel *autolabel1=[UILabel new];
        autolabel1.text=@"温馨提示:我们将严格对用户的所有资料进行保密";
        autolabel1.font=[UIFont systemFontOfSize:CGFloatIn320(10)];
        autolabel1.textColor=[UIColor colorWithHexString:@"#888888"];
        [_headView addSubview:autolabel1];
        autolabel1.sd_layout
        .centerXEqualToView(_headView)
        .heightIs(10)
        .topSpaceToView(self.autolabel, CGFloatIn320(15));
        [autolabel1 setSingleLineAutoResizeWithMaxWidth:300];
        
    }
    return _headView;
    
}


- (UIView *)footView{
    
    if (!_footView) {
        
        _footView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFloatIn320(300))];
        _footView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        
        self.submitButton=[UIButton new];
        [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.submitButton setTitle:@"确认提交" forState:UIControlStateNormal];
        self.submitButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [self.submitButton setBackgroundColor:[UIColor colorWithHexString:@"#f52735"]];
        [_footView addSubview:self.submitButton];
        self.submitButton.sd_layout
        .leftSpaceToView(_footView, CGFloatIn320(10))
        .rightSpaceToView(_footView, CGFloatIn320(10))
        .topSpaceToView(_footView, CGFloatIn320(32))
        .heightIs(CGFloatIn320(40));
        
    }
    return _footView;
    
}

- (NSMutableArray *)userCenterItemArray{
    if (!_userCenterItemArray) {
        
        _userCenterItemArray=[NSMutableArray array];
    }
    return _userCenterItemArray;
}

- (CYWUserCenterAuthenticationItemModel *)itemNameString:(NSString *)name withIcon:(NSString *)icon withValue:(NSString *)value withitemController:(NSString *)controller{
    
    CYWUserCenterAuthenticationItemModel *items=[CYWUserCenterAuthenticationItemModel new];
    items.title=name;
    items.icon=icon;
    items.value=value;
    items.viewController=controller;
    return items;
}

- (void)dealloc{
    NSLog(@"实名认证销毁");
}
@end

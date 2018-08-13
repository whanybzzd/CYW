//
//  CYWAssetsViewController.m
//  CYW
//
//  Created by jktz on 2017/9/30.
//  Copyright © 2017年 jktz. All rights reserved.
//

//-----------临时创建一个模型用来描述个人中心的入口参数-----------
@interface CYWAssetsItemModels : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *viewController;

@end
@implementation CYWAssetsItemModels @end
//-------------------------END-----------------------------

#import "CYWAssetsViewController.h"
#import "CYWAssetsTableViewCell.h"
#import "CYWAssetsTableHeadView.h"
#import "CYWAssetsEnvelopeViewController.h"
#import <EAFeatureGuideView/UIView+EAFeatureGuideView.h>
#import "CYWAssetsViewModel.h"
@interface CYWAssetsViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *userCenterItemArray;
@property (nonatomic, retain) CYWAssetsTableHeadView *tableHeadView;
@property (nonatomic, retain) CYWAssetsViewModel *viewModel;

@end

@implementation CYWAssetsViewController

- (void)initSubViews{
    
    @weakify(self)
    [[self rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(RACTuple * _Nullable x) {
        
        @strongify(self)
        self.tableView.delegate = self;
        [MXNavigationBarManager managerWithController:self];
        [MXNavigationBarManager setBarColor:[UIColor clearColor]];
        [self.tableHeadView initSubViews];
        
        @weakify(self)
        //请求用户还有多少个可用红包
        [[self.viewModel.refreshEnvelopeCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            
            @strongify(self)
            
            //重新刷新数据
            [self initSubView];
            [self.tableView reloadData];
        } error:^(NSError * _Nullable error) {
            
            
        }];
    }];
    
    [[self rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(RACTuple * _Nullable x) {
        
       @strongify(self)
        self.tableView.delegate = nil;
        [MXNavigationBarManager reStoreToSystemNavigationBar];
    }];
    
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    self.tableView.delegate = self;
//    [self initBarManager];
//    [self.tableHeadView initSubViews];
//
//
//
//        @weakify(self)
//        //请求用户还有多少个可用红包
//        [[self.viewModel.refreshEnvelopeCommand execute:nil] subscribeNext:^(id  _Nullable x) {
//
//            @strongify(self)
//
//            //重新刷新数据
//            [self initSubView];
//            [self.tableView reloadData];
//        } error:^(NSError * _Nullable error) {
//
//
//        }];
//
//
//
//}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//    self.tableView.delegate = nil;
//    [MXNavigationBarManager reStoreToSystemNavigationBar];
//}
//
//
//- (void)initBarManager {
//    //optional, save navigationBar status
//
//    //required
//    [MXNavigationBarManager managerWithController:self];
//    [MXNavigationBarManager setBarColor:[UIColor clearColor]];
//
//    //optional
//    [MXNavigationBarManager setTintColor:[UIColor blackColor]];
//    [MXNavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
//}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewModel=[[CYWAssetsViewModel alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithBtnImage:@"icon_envelopes" target:self action:@selector(rightButtonClick)];
    [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    [self tableView];
    [self showGuideView];
    [self navigationControllerAddButton];
    [self initSubViews];
   
}

- (void)rightButtonClick{
    
    [self pushViewController:@"CYWAssetsMessageViewController"];
}


/**
 遮蔽
 */
- (void)showGuideView
{
    CGPoint center = self.navigationController.navigationBar.center;
    CGRect rect = CGRectMake(7, center.y - kDevice_Is_iPhoneX?46:23, 46, 46);
    EAFeatureItem *title = [[EAFeatureItem alloc] initWithFocusRect:rect focusCornerRadius:23 focusInsets:UIEdgeInsetsZero];
    title.indicatorImageName=@"图层-2-拷贝.png";
    title.introduce = @"进入个人主页.png";
    
    //当version不一致 代表不需要该提示
    [self.navigationController.view showWithFeatureItems:@[title] saveKeyName:@"cell11" inVersion:kGuideNormalVersion];
}



- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY>60.0f) {
        
        self.navigationItem.rightBarButtonItem=nil;
    }else{
        
        self.navigationItem.rightBarButtonItem=[UIBarButtonItem itemWithBtnImage:@"icon_envelopes" target:self action:@selector(rightButtonClick)];
        [self.navigationItem.rightBarButtonItem setTintColor:[UIColor whiteColor]];
    }
    if (offsetY <= 0) {
        self.tableView.bounces = NO;
        
    }
    else
        if (offsetY >= 0){
            self.tableView.bounces = YES;
            
        }
}
- (void)initSubView{
    
    //个人账户信息
    NSObject *centerModel= [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserCenterInfoModel];
    UserCenterInfoViewModel *model=(UserCenterInfoViewModel *)centerModel;
    
    [self.userCenterItemArray removeAllObjects];
    
    NSArray *section=@[[self itemNameString:@"累计投资" withIcon:@"icon_cumulative" withValue:[NSString stringWithFormat:@"%@元",model.accumulativeInvestAmount] withitemController:@""],
                       [self itemNameString:@"在投本金" withIcon:@"icon_reimbursement" withValue:[NSString stringWithFormat:@"%@元",model.repayingInvestAmount] withitemController:@""],
                       [self itemNameString:@"待收利息" withIcon:@"icon_interest" withValue:[NSString stringWithFormat:@"%@元",model.earnedAmount] withitemController:@""],
                       [self itemNameString:@"冻结金额" withIcon:@"icon_freezing" withValue:[NSString stringWithFormat:@"%@元",model.frozen] withitemController:@""]];
    [self.userCenterItemArray addObject:section];
    
    NSArray *section1=@[[self itemNameString:@"银行卡管理" withIcon:@"icon_car" withValue:nil withitemController:@"CYWAssetsCarManagermentViewController"],
                        [self itemNameString:@"交易记录" withIcon:@"icon_transact" withValue:nil withitemController:@"CYWAssetsRecordViewController"],
                        [self itemNameString:@"还款日历" withIcon:@"icon_Calendar" withValue:nil withitemController:@"CYWAssetsCalendarsViewController"]];
    [self.userCenterItemArray addObject:section1];
    
    NSArray *section2=@[[self itemNameString:@"我的投资" withIcon:@"icon_invest" withValue:nil withitemController:@"CYWAssetsInvestViewController"],
                        [self itemNameString:@"我的借款" withIcon:@"icon_borrowed" withValue:nil withitemController:@"CYWAssetsBorrowedViewController"],
                        [self itemNameString:@"我的债权" withIcon:@"icon_creditors" withValue:nil withitemController:@"CYWAssetsCreditorViewController"]];
    [self.userCenterItemArray addObject:section2];
    
    NSArray *section3=@[[self itemNameString:@"我的红包" withIcon:@"icon_envelope" withValue:nil withitemController:@"CYWAssetsEnvelopeViewController"]];
    [self.userCenterItemArray addObject:section3];
    
}

- (UITableView *)tableView{
    
    
    if (!_tableView) {
        
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kDevice_Is_iPhoneX?SCREEN_HEIGHT-78:SCREEN_HEIGHT-44) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor colorWithHexString:@"#f4f4f4"];
        [_tableView registerClass:[CYWAssetsTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        _tableView.tableHeaderView=self.tableHeadView;
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
    CYWAssetsItemModels *item = ((NSArray *)self.userCenterItemArray[indexPath.section])[indexPath.row];
    CYWAssetsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.imageView.image=[UIImage imageNamed:item.icon];
    cell.iconlabel.text=item.title;
    cell.detailString=item.value;
    cell.indexPath=indexPath;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CYWAssetsItemModels *item = ((NSArray *)self.userCenterItemArray[indexPath.section])[indexPath.row];
    [self pushViewController:item.viewController];
    
    
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
- (CYWAssetsTableHeadView *)tableHeadView{
    if (!_tableHeadView) {
        
        _tableHeadView=[CYWAssetsTableHeadView new];
    }
    return _tableHeadView;
}

- (CYWAssetsItemModels *)itemNameString:(NSString *)name withIcon:(NSString *)icon withValue:(NSString *)value withitemController:(NSString *)controller{
    
    CYWAssetsItemModels *items=[CYWAssetsItemModels new];
    items.title=name;
    items.icon=icon;
    items.value=value;
    items.viewController=controller;
    return items;
}
//-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
//    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
//        [cell setLayoutMargins:UIEdgeInsetsZero];
//    }
//    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
//        [cell setSeparatorInset:UIEdgeInsetsZero];
//    }
//}
//
//-(void)viewDidLayoutSubviews {
//
//    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
//
//    }
//    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
//        [_tableView setLayoutMargins:UIEdgeInsetsZero];
//    }
//
//}

//给导航栏添加一个按钮
- (void)navigationControllerAddButton{
    
    @weakify(self)
    UIButton *button=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-150, kDevice_Is_iPhoneX?88:64)];
    button.backgroundColor=[UIColor clearColor];
    [[button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [self pushViewController:@"CYWMoreUserCenterViewController"];
    }];
    UIBarButtonItem *leftBarButtomItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = leftBarButtomItem;
    
}

@end

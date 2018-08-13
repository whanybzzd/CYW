//
//  CYWAssetsInvestViewController.m
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsInvestViewController.h"
#import "CYWAssetsInvestTableViewCell.h"
#import "CYWAssetsInvestHeadView.h"
#import "CYWAssetsInvestViewModel.h"
#import <ODRefreshControl/ODRefreshControl.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "DCSheetAction.h"
@interface CYWAssetsInvestViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) CYWAssetsInvestHeadView *investHeadView;
@property (nonatomic, retain) CYWAssetsInvestViewModel *investViewModel;
@property (nonatomic, retain) ODRefreshControl *refreshControl;
@property (nonatomic, retain) UIButton *button;
@end

@implementation CYWAssetsInvestViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refreshInvest];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.investViewModel=[[CYWAssetsInvestViewModel alloc] init];

    
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"我的投资";
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
    [self.button setTitle:@"筛选" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    self.button.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.button];
    
    
    [self tableView];
    
    
}

- (void)buttonClick:(UIButton *)sender{
    @weakify(self)
    DCSheetAction *sheetView=[DCSheetAction sharedInstanceTypeArray:@[@"还款中",@"已结清",@"投标中"] withTimeArray:@[@"按日查询",@"单月查询",@"双月查询"] withBlock:^(id object) {
        
        @strongify(self)
        //NSLog(@"object:%@",object);//CYWAssetsPlanTwoViewController
        //[blockSelf selectScreenCondition:object];
        
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%zd",[object[@"tag"] integerValue]-100] forKey:@"indexs"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self pushViewController:@"CYWAssetsPlanTwoViewController" withParams:@{@"object":object}];
        
    }];
    [sheetView show];
}



- (void)refreshInvest{
    
    self.investViewModel.refreshIndex=1;
    [self refreshIn];
}

- (void)refreshInvestLoadMore{
    
    self.investViewModel.refreshIndex=2;
    [self refreshIn];
}

- (void)refreshIn{
    
    @weakify(self)
    [[self.investViewModel.refresInvestCommand execute:nil] subscribeNext:^(id x) {
        
        NSLog(@"刷新视图");
        @strongify(self)
        [self.refreshControl endRefreshing];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        
        [self.refreshControl endRefreshing];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    }];
}

#pragma mark 懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-getRectNavAndStatusHight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=NO;
        _tableView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        _tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[CYWAssetsInvestTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        _tableView.tableHeaderView=self.investHeadView;
        [self.view addSubview:_tableView];
        if (@available(ios 11.0,*)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
        //添加上拉刷新和下拉刷新
        self.refreshControl=[[ODRefreshControl alloc] initInScrollView:self.tableView];
        [self.refreshControl addTarget:self action:@selector(refreshInvest) forControlEvents:UIControlEventValueChanged];
        @weakify(self)
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            
            @strongify(self)
            [self refreshInvestLoadMore];
            
        }];
        
    }
    return _tableView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 134.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.investViewModel.datassetslArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    InvestViewModel *model=self.investViewModel.datassetslArray[indexPath.row];
    CYWAssetsInvestTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.model=model;
    cell.indexPath=indexPath;
    [cell setClickCell:^(NSIndexPath *indexPath) {
       
        @strongify(self)
       [self clickPushViewController:indexPath];
    }];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    InvestViewModel *model=self.investViewModel.datassetslArray[indexPath.row];
    if ([NSObject isNotEmpty:model]) {
        
        [self pushViewController:@"CYWNowInvestmentViewController" withParams:@{@"id":model.loanId}];
    }
}

- (void)clickPushViewController:(NSIndexPath *)indexPath{
    InvestViewModel *model=self.investViewModel.datassetslArray[indexPath.row];
    
    if ([NSObject isNotEmpty:model]) {
        
        [self pushViewController:@"CYWAssetsPlanViewController" withParams:@{@"id":model.id,@"name":model.loanName}];
    }
    
    
}
- (CYWAssetsInvestHeadView *)investHeadView{
    if (!_investHeadView) {
        
        _investHeadView=[CYWAssetsInvestHeadView new];
    }
    return _investHeadView;
}
- (void)dealloc{
    self.investHeadView=nil;
    NSLog(@"我的投资销毁");
}
@end

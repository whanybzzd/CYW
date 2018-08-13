//
//  CYWAssetsBorrowedViewController.m
//  CYW
//
//  Created by jktz on 2017/10/19.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsBorrowedViewController.h"
#import "XTSegmentControl.h"
#import "CYWAssetsBorrowedTableViewCell.h"
#import <ODRefreshControl/ODRefreshControl.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "CYWAssetsBorrowedViewModel.h"
#import "CYWBorrowscreenView.h"
@interface CYWAssetsBorrowedViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (retain, nonatomic) UIView *sectionHeaderView;
@property (nonatomic, retain) ODRefreshControl *refreshControl;
@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) CYWAssetsBorrowedViewModel *borrowedViewModel;
@property (nonatomic, copy) NSArray *typeArray;
@property (nonatomic, retain) UIButton *button;
@end

@implementation CYWAssetsBorrowedViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [self refresh];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.borrowedViewModel=[[CYWAssetsBorrowedViewModel alloc] init];
    self.navigationItem.title=@"我的借款";
    self.typeArray=@[@"hk",@"mj",@"jq",@"lb"];
    self.borrowedViewModel.refreshDataType=self.typeArray[0];//默认为请求还款
    [self saveBrowed:0];
    [self tableView];
    @weakify(self)
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54.0) Items:@[@"还款中", @"募集中",@"已结清",@"已流标"] selectedBlock:^(NSInteger index) {
            @strongify(self)
            NSLog(@"index:%zd",index);
            self.borrowedViewModel.refreshDataType=self.typeArray[index];//默认为请求还款
            [self saveBrowed:index];
            [self refreshHome];
        }];
        _sectionHeaderView.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
    }
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
    [self.button setTitle:@"筛选" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    self.button.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.button];
}

- (void)buttonClick:(UIButton *)sender{
 
    @weakify(self)
    CYWBorrowscreenView *view=[CYWBorrowscreenView sharedInstanceViewBlock:^(id object) {
        
        @strongify(self)
        self.borrowedViewModel.object=object;
        [self refreshHome];
    }];
    [view show];
}



- (void)saveBrowed:(NSInteger)index{
    if (index>0) {
        
        self.navigationItem.rightBarButtonItem =nil;
    }else{
        
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.button];
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%zd",index] forKey:@"browedkey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
- (void)refreshHome{
    self.borrowedViewModel.refreshType=1;
     [self refresh];
}
- (void)refreshLoadData{
    self.borrowedViewModel.refreshType=2;
    [self refresh];
}


- (void)refresh{
    
    @weakify(self)
    [[self.borrowedViewModel.refresBorrowedCommand execute:nil] subscribeNext:^(id x) {
        
        NSLog(@"刷新视图");
        @strongify(self)
        [self.refreshControl endRefreshing];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}

#pragma mark 懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-getRectNavAndStatusHight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=NO;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[CYWAssetsBorrowedTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        [self.view addSubview:_tableView];
        if (@available(ios 11.0,*)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
        //添加上拉刷新和下拉刷新
        self.refreshControl=[[ODRefreshControl alloc] initInScrollView:self.tableView];
        [self.refreshControl addTarget:self action:@selector(refreshHome) forControlEvents:UIControlEventValueChanged];
        @weakify(self)
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            
            @strongify(self)
            [self refreshLoadData];
            
        }];
    }
    return _tableView;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 132.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.borrowedViewModel.dataModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ProjectViewModel *model=self.borrowedViewModel.dataModelArray[indexPath.row];
    CYWAssetsBorrowedTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.model=model;
    cell.indexPath=indexPath;
    @weakify(self)
    [cell setBorrowedTableViewcell:^(NSIndexPath *indexPath) {
       
        @strongify(self)
        [self didSelectTableViewCellIndexPath:indexPath];
    }];
    return cell;
}

- (void)didSelectTableViewCellIndexPath:(NSIndexPath *)indexPath{
    
    ProjectViewModel *model=self.borrowedViewModel.dataModelArray[indexPath.row];
    if ([NSObject isNotEmpty:model]) {
        
        [self pushViewController:@"CYWAssetsBorrowedPlanViewController" withParams:@{@"loadId":model.id,@"name":model.name}];
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ProjectViewModel *model=self.borrowedViewModel.dataModelArray[indexPath.row];
    if ([NSObject isNotEmpty:model]) {
        
        [self pushViewController:@"CYWNowInvestmentViewController" withParams:@{@"id":model.id}];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 54.0f;
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon_normal_data"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#888888"],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:@"抱歉!加载失败了~~" attributes:attributes];
}
- (void)dealloc{
    NSLog(@"我的借款销毁");
}
@end

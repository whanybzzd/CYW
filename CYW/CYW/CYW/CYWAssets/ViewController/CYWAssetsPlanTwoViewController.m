//
//  CYWAssetsPlanTwoViewController.m
//  CYW
//
//  Created by jktz on 2017/10/16.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsPlanTwoViewController.h"
#import "CYWAssetsPlanViewModel.h"
#import "CYWAssetsInvestHeadView.h"
#import "CYWAssetsPlanTableViewCell.h"
#import <ODRefreshControl/ODRefreshControl.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "DCSheetAction.h"
@interface CYWAssetsPlanTwoViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) ODRefreshControl *refreshControl;
@property (nonatomic, retain) CYWAssetsPlanViewModel *planViewModel;
@property (nonatomic, retain) CYWAssetsInvestHeadView *investHeadView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, retain) UIButton *button;
@end

@implementation CYWAssetsPlanTwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.index=0;
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
    [self.button setTitle:@"筛选" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    self.button.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.button];
    
    self.planViewModel=[[CYWAssetsPlanViewModel alloc] init];
    self.planViewModel.object=self.params[@"object"];
    self.navigationItem.title=self.params[@"object"][@"title"];
    [self tableView];
    [self refreshHome];
    
}


- (void)buttonClick:(UIButton *)sender{
    
    @weakify(self)
    DCSheetAction *sheetView=[DCSheetAction sharedInstanceTypeArray:@[@"还款中",@"已结清",@"投标中"] withTimeArray:@[@"按日查询",@"单月查询",@"双月查询"] withBlock:^(id object) {
        
        //根据坐标来判断是否需要展示头部视图
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%zd",[object[@"tag"] integerValue]-100] forKey:@"indexs"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        @strongify(self)
        self.planViewModel.object=object;
        [self refreshHome];
        
    }];
    [sheetView show];
}


- (void)refreshHome{
    
    self.planViewModel.refreshIndex=1;
    [self refresh];
}

- (void)refreshLoadData{
    
    self.planViewModel.refreshIndex=2;
    [self refresh];
    
}
- (void)refresh{
    
    @weakify(self)
    [[self.planViewModel.refresPlanCommand execute:nil] subscribeNext:^(id x) {
        
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
        _tableView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        _tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[CYWAssetsPlanTableViewCell class] forCellReuseIdentifier:@"kcells"];
        _tableView.tableHeaderView=self.investHeadView;
        
        [self.view addSubview:_tableView];
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 124.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.planViewModel.datassetslArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ConditionViewModel *model=self.planViewModel.datassetslArray[indexPath.row];
    CYWAssetsPlanTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"kcells"];
    cell.model=model;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (CYWAssetsInvestHeadView *)investHeadView{
    
    if (!_investHeadView) {
        
        _investHeadView=[CYWAssetsInvestHeadView new];
    }
    return _investHeadView;
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
    NSLog(@"筛选条件销毁");
}
@end

//
//  CYWAssetsMessageViewController.m
//  CYW
//
//  Created by jktz on 2017/10/24.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsMessageViewController.h"
#import <ODRefreshControl/ODRefreshControl.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "CYWAssetsMessageTableViewCell.h"
#import "CYWAssetsMessageViewModel.h"
#import "CYWAssetsMessageDetailViewController.h"
@interface CYWAssetsMessageViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) ODRefreshControl *refreshControl;
@property (nonatomic, retain) CYWAssetsMessageViewModel *messaegViewModel;

@end

@implementation CYWAssetsMessageViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"消息中心";
    self.messaegViewModel=[[CYWAssetsMessageViewModel alloc] init];
    [self tableView];
    [self refreshHome];
    
}
#pragma mark 懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-getRectNavAndStatusHight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[CYWAssetsMessageTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
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
       
    }
    return _tableView;
}

- (void)refreshHome{
    [self refresh];
}


- (void)refresh{
    
    @weakify(self)
    [[self.messaegViewModel.refreshMessageCommand execute:nil] subscribeNext:^(id x) {
        
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


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 90.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.messaegViewModel.dataModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    JpushViewModel *model=(JpushViewModel *)self.messaegViewModel.dataModelArray[indexPath.row];
    CYWAssetsMessageTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.model=model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JpushViewModel *model=(JpushViewModel *)self.messaegViewModel.dataModelArray[indexPath.row];
    
    if ([NSString isNotEmpty:model.desc]) {
        
        CYWAssetsMessageDetailViewController *messageVC=[[CYWAssetsMessageDetailViewController alloc] init];
        [messageVC loadWebHTMLSring:model.desc];
        messageVC.title=@"消息详情";
        messageVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:messageVC animated:YES];
        //[self pushViewController:@"CYWAssetsMessageDetailViewController" withParams:@{@"descript":model.desc}];
    }else{
        
        [self showResultThenHide:@"消息不存在"];
    }
    
    
}



- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"消息中"];
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
    
    return [[NSAttributedString alloc] initWithString:@"还没有消息额！" attributes:attributes];
}

- (void)dealloc{
    NSLog(@"消息中心销毁");
}
@end

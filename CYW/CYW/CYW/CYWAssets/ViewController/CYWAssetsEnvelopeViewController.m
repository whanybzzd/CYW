//
//  CYWAssetsEnvelopeViewController.m
//  CYW
//
//  Created by jktz on 2017/10/12.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsEnvelopeViewController.h"
#import "XTSegmentControl.h"
#import "CYWAssetsEnvelopeTableViewCell.h"
#import "CYWAssetsViewModel.h"
#import <ODRefreshControl/ODRefreshControl.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
@interface CYWAssetsEnvelopeViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (retain, nonatomic) UIView *sectionHeaderView;
@property (nonatomic, retain) ODRefreshControl *refreshControl;
@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) CYWAssetsViewModel *assetsViewModel;

@end

@implementation CYWAssetsEnvelopeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"我的红包";
    self.assetsViewModel=[[CYWAssetsViewModel alloc] init];
    self.assetsViewModel.loadId=self.params[@"loadId"];//加载项目标的的红包Id
    NSArray *preferentialArray = @[@"unused",@"used",@"disable"];//请求类型
    self.assetsViewModel.refreshType=preferentialArray[0];//默认为使用
    [self saveAssetsIndex:0];//保存第一个标识符
    
    @weakify(self)
    [self tableView];
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54.0) Items:@[@"未使用", @"已使用",@"已过期"] selectedBlock:^(NSInteger index) {
            @strongify(self)
            NSLog(@"index:%zd",index);
            [self saveAssetsIndex:index];
            self.assetsViewModel.refreshType=preferentialArray[index];
            [self refreshType:Refreshload];
            
        }];
        _sectionHeaderView.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
    }
    [self refreshType:Refreshload];
    
    //[self initSubView];
}

- (void)saveAssetsIndex:(NSInteger)index{
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%zd",index] forKey:@"key"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


////正常刷新
- (void)refreshHome{

    [self refreshType:Refreshload];

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
        [_tableView registerClass:[CYWAssetsEnvelopeTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
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
            [self refreshType:RefreshloadMore];
            
        }];
    }
    return _tableView;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 137.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.assetsViewModel.datassetslArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *model=self.assetsViewModel.datassetslArray[indexPath.row];
    CYWAssetsEnvelopeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.param=model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (0==[[[NSUserDefaults standardUserDefaults] objectForKey:@"key"] integerValue]&&
        [NSString isNotEmpty:self.params[@"loadId"]]) {
        
        NSDictionary *model=self.assetsViewModel.datassetslArray[indexPath.row];

        //NSLog(@"model:%@",model);
        //不想写代理了  所以就保存本地
        [[NSUserDefaults standardUserDefaults] setValue:model[@"id"] forKey:@"envelopeid"];
        [[NSUserDefaults standardUserDefaults] setObject:model[@"coupon"][@"name"] forKey:@"envelopename"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //表示是从项目详情中选择过来的
        [self backViewController];
    }else{
        
        @weakify(self)
        [self bk_performBlock:^(id obj) {
            
            @strongify(self)
            [self backViewControllerIndex:0];
            
        } afterDelay:1.5];
        
        //直接回到TabBar栏目
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarClick" object:nil];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 54.0f;
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon_hb"];
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
    
    return [[NSAttributedString alloc] initWithString:@"您还没有红包" attributes:attributes];
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView{
    return -self.tableView.tableHeaderView.frame.size.height/2.0f;
    
}


- (void)dealloc{
    NSLog(@"我的红包销毁");
}


- (void)refreshType:(RefreshType)type{
    
    @weakify(self)
    [[[self.assetsViewModel loadRefreshDataType:type] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        @strongify(self)
        [self.refreshControl endRefreshing];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
        return [RACSignal empty];
        
    }] subscribeNext:^(id  _Nullable x) {
       
        @strongify(self)
        [self.refreshControl endRefreshing];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    }];
}

@end

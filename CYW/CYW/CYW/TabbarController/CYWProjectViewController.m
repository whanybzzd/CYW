//
//  CYWProjectViewController.m
//  CYW
//
//  Created by jktz on 2017/9/30.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWProjectViewController.h"
#import "XTSegmentControl.h"
#import "CYWProjectTableViewCell.h"
#import "CYWHomeTableViewCell.h"
#import "CYWProjectViewModel.h"
#import <ODRefreshControl/ODRefreshControl.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "BQActivityView.h"
@interface CYWProjectViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>{
    
    NSInteger cellType;
}
@property (retain, nonatomic) XTSegmentControl *sectionHeaderView;
@property (nonatomic, retain) ODRefreshControl *refreshControl;
@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) CYWProjectViewModel *projectViewModel;
@property (nonatomic, retain) NSArray *typeArray;

@end

@implementation CYWProjectViewController

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //self.navigationItem.title=@"项目";
    self.view.backgroundColor=[UIColor whiteColor];
    self.projectViewModel=[[CYWProjectViewModel alloc] init];
    cellType=0;//默认为项目列表
    self.typeArray=@[@"xs",@"pt"];
    
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44.0) Items:@[@"房宝保", @"转让通"] selectedBlock:^(NSInteger index) {
            NSLog(@"index:%zd",index);
            cellType=index;
            //要先屏蔽  不然连续点击  会报错
            [BQActivityView showActiviTy];
            [self refreshHome];
            
            
        }];
        _sectionHeaderView.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
    }
    self.navigationItem.titleView=self.sectionHeaderView;
    [self tableView];
    [self refreshHome];
}


//////////////////=====================项目列表
//正常刷新
- (void)refreshHome{
    
    self.projectViewModel.refreshIndex=1;
    
    if (CellHome==cellType) {//项目列表正常刷新
        
        [self refresh];
    }else{
        
        [self refreshCreditors];//债权列表正常刷新
    }
}
//刷新更多
- (void)refreshLoadData{
    
    self.projectViewModel.refreshIndex=2;
    if (CellHome==cellType) {//项目列表刷新更多
        
        [self refresh];
    }else{
        
        [self refreshCreditors];//债权列表刷新更多
    }
    
}

- (void)refresh{
    
    @weakify(self)
    self.projectViewModel.type=self.typeArray[cellType];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self.projectViewModel.refresProjectCommand execute:nil] subscribeNext:^(id x) {
            
            NSLog(@"刷新视图");
            @strongify(self)
            [self.refreshControl endRefreshing];
            [self.tableView.infiniteScrollingView stopAnimating];
            [self.tableView reloadData];
            
            [BQActivityView hideActiviTy];
        } error:^(NSError * _Nullable error) {
            @strongify(self)
            
            [self.refreshControl endRefreshing];
            [self.tableView.infiniteScrollingView stopAnimating];
            
            [self.tableView reloadData];
            
            [BQActivityView hideActiviTy];
        }];
        
    });
}

////////////////////========债权列表
- (void)refreshCreditors{
    
    @weakify(self)
    self.projectViewModel.type=@"全部";
    [[self.projectViewModel.refreshCreditorsCommand execute:nil] subscribeNext:^(id x) {
        
        NSLog(@"刷新视图");
        @strongify(self)
        [self.refreshControl endRefreshing];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
        
        [BQActivityView hideActiviTy];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.refreshControl endRefreshing];
        [self.tableView.infiniteScrollingView stopAnimating];
        
        [self.tableView reloadData];
        
        [BQActivityView hideActiviTy];
    }];
}

#pragma mark 懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-getRectNavAndStatusHight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=NO;
        _tableView.rowHeight=130.0f;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[CYWHomeTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        [_tableView registerClass:[CYWProjectTableViewCell class] forCellReuseIdentifier:@"cells"];
        [self.view addSubview:_tableView];
        if (@available(ios 11.0,*)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
        //添加上拉刷新和下拉刷新
        self.refreshControl=[[ODRefreshControl alloc] initInScrollView:_tableView];
        [self.refreshControl addTarget:self action:@selector(refreshHome) forControlEvents:UIControlEventValueChanged];
        @weakify(self)
        [self.tableView addInfiniteScrollingWithActionHandler:^{
            
            @strongify(self)
            [self refreshLoadData];
            
        }];
    }
    return _tableView;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.projectViewModel.dataModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (CellHome==cellType) {
        
        CYWHomeTableViewCell *cell=[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        ProjectViewModel *model=(ProjectViewModel *)self.projectViewModel.dataModelArray[indexPath.row];
        cell.model=model;
        //cell.typeIndex=cellType;
        return cell;
        
    }else{
        
        CYWProjectTableViewCell *cells=[tableView dequeueReusableCellWithIdentifier:@"cells"];
        ProjectRightsViewModel *rightmodel=(ProjectRightsViewModel *)self.projectViewModel.dataModelArray[indexPath.row];
        cells.rightModel=rightmodel;
        return cells;
        
    }
    
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (CellHome==cellType) {
        
        ProjectViewModel *model=(ProjectViewModel *)self.projectViewModel.dataModelArray[indexPath.row];
        if ([NSObject isNotEmpty:model]) {
            
            [self pushViewController:@"CYWNowInvestmentViewController" withParams:@{@"id":model.id,@"load":@"test"}];//此处的test无效  只是为了区分
        }
    }else{
        
        ProjectRightsViewModel *rightmodel=(ProjectRightsViewModel *)self.projectViewModel.dataModelArray[indexPath.row];
        if ([NSObject isNotEmpty:rightmodel]) {
            
            [self pushViewController:@"CYWNowInvestmentViewController" withParams:@{@"id":rightmodel.id,@"load":@"transferInvest"}];
        }
        
    }
    
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon_normal_data"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#888888"],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:@"暂时没数据" attributes:attributes];
}

@end

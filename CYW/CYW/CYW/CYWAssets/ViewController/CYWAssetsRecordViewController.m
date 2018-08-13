//
//  CYWAssetsRecordViewController.m
//  CYW
//
//  Created by jktz on 2017/10/16.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsRecordViewController.h"
#import <ODRefreshControl/ODRefreshControl.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "CYWAssetsRecordTableViewCell.h"
#import "CYWAssetsRecordViewModel.h"
#import "CYWTransactView.h"
@interface CYWAssetsRecordViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (retain, nonatomic) UIView *sectionHeaderView;
@property (nonatomic, retain) ODRefreshControl *refreshControl;
@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) CYWAssetsRecordViewModel *recordViewModle;
@property (nonatomic, retain) UIButton *button;
@property (nonatomic, assign) BOOL selectBool;
@property (nonatomic, retain) UIView *topView;
@property (nonatomic, retain) UILabel *toplabel;
@end

@implementation CYWAssetsRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"交易记录";
    self.selectBool=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 60)];
    [self.button setTitle:@"筛选" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    self.button.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.button];
    self.recordViewModle=[[CYWAssetsRecordViewModel alloc]init];
    [self topView];
    [self tableView];
    [self refreshHome];
    
    
    
    
}

- (void)buttonClick:(UIButton *)sender{
    
    @weakify(self)
    CYWTransactView *view=[CYWTransactView sharedInstanceWithBlock:^(id object) {
        
        @strongify(self)
        self.selectBool=YES;
        //NSLog(@"ob:%@",object);
        self.recordViewModle.object=object;
        self.recordViewModle.refreshType=1;
        [self selectRefresh];
    }];
    [view show];
    
    
    
    
}

#pragma mark 懒加载
- (UIView *)topView{
    if (!_topView) {
        
        _topView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0)];
        _topView.hidden=YES;
        [self.view addSubview:_topView];
        
        self.toplabel=[UILabel new];
        self.toplabel.text=@"总计:2315元";
        self.toplabel.font=[UIFont systemFontOfSize:15];
        self.toplabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [_topView addSubview:self.toplabel];
        self.toplabel.sd_layout
        .leftSpaceToView(_topView, 15)
        .heightIs(15)
        .centerYEqualToView(_topView);
        [self.toplabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _topView;
}
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-getRectNavAndStatusHight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [_tableView registerClass:[CYWAssetsRecordTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        _tableView.rowHeight=60.0f;
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
            if (!self.selectBool) {
                
                [self refreshLoadData];
            }else{
                
                [self selectRefreshLoadMore];
            }
            
            
        }];
    }
    return _tableView;
}

//筛选后的加载
- (void)selectRefreshLoadMore{
    
    self.recordViewModle.refreshType=2;
    [self selectRefresh];
}
- (void)selectRefresh{
    
     @weakify(self)
    [[self.recordViewModle.refresSearchCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        
        
        @strongify(self)
        [self.refreshControl endRefreshing];
        [self.tableView.infiniteScrollingView stopAnimating];
        
        
        NSString *str=[NSString stringWithFormat:@"总计:%@元",x];
        self.topView.hidden=NO;
        
        self.topView.frame=CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, 40);
        self.tableView.frame=CGRectMake(0, getRectNavAndStatusHight+self.topView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT-getRectNavAndStatusHight-self.topView.frame.size.height);
        
        
        [self.toplabel setAttributedText:[NSMutableAttributedString withTitleString:str RangeString:x ormoreString:nil color:[UIColor redColor]]];
        [self.toplabel sizeToFit];
        
        
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
}


//正常的加载
- (void)refreshHome{
    
    self.topView.hidden=YES;
    self.tableView.frame=CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-getRectNavAndStatusHight);
   
    self.recordViewModle.refreshType=1;
    [self refresh];
}
- (void)refreshLoadData{
    self.recordViewModle.refreshType=2;
    [self refresh];
}


- (void)refresh{
    
    @weakify(self)
    [[self.recordViewModle.refresRecordCommand execute:nil] subscribeNext:^(id x) {
        
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



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.recordViewModle.monthArray.count;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.recordViewModle.dataArray[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactViewModel *model = (TransactViewModel *)((NSArray *)self.recordViewModle.dataArray[indexPath.section])[indexPath.row];
    CYWAssetsRecordTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.model=model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TransactViewModel *model = (TransactViewModel *)((NSArray *)self.recordViewModle.dataArray[indexPath.section])[indexPath.row];
    if ([NSObject isNotEmpty:model]) {
        
        [self pushViewController:@"CYWAssetsRecordDetailViewController" withParams:@{@"model":model}];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 20.0f;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 20)];
    UILabel *label=[UILabel new];
    label.font=[UIFont systemFontOfSize:15];
    label.textColor=[UIColor colorWithHexString:@"#888888"];
    label.text=[self.recordViewModle.monthArray objectAtIndex:section];
    [view addSubview:label];
    label.sd_layout
    .leftSpaceToView(view, 15)
    .heightIs(15)
    .centerYEqualToView(view);
    [label setSingleLineAutoResizeWithMaxWidth:200];
    
    return view;
}



- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"交易记录"];
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
    
    return [[NSAttributedString alloc] initWithString:@"没有任何记录" attributes:attributes];
}

- (void)dealloc{
    NSLog(@"交易记录销毁");
}
@end

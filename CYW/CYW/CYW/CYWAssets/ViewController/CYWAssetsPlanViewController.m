//
//  CYWAssetsPlanViewController.m
//  CYW
//
//  Created by jktz on 2017/10/16.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsPlanViewController.h"
#import "CYWAssetsInvestViewModel.h"
#import "CYWAssetsInvestHeadView.h"
#import "CYWAssetsPlansTableViewCell.h"
@interface CYWAssetsPlanViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) CYWAssetsInvestViewModel *investViewModel;
@property (nonatomic, retain) CYWAssetsInvestHeadView *investHeadView;
@end

@implementation CYWAssetsPlanViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //[self.investHeadView initSubView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"还款计划";
    self.view.backgroundColor=[UIColor whiteColor];
    self.investViewModel=[[CYWAssetsInvestViewModel alloc] init];
    
    [self tableView];
    [self refreshload];
}

- (void)refreshload{
    
    self.investViewModel.investId=self.params[@"id"];//接受Id
    @weakify(self)
    [[self.investViewModel.refresStateCommand execute:nil] subscribeNext:^(id x) {

        NSLog(@"刷新视图");
        @strongify(self)
        //[[NSNotificationCenter defaultCenter] postNotificationName:@"postInvestName" object:x];
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
//        @strongify(self)
//        [self.tableView reloadData];
    }];
}

#pragma mark 懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH,SCREEN_HEIGHT-getRectNavAndStatusHight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=NO;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        _tableView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        _tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[CYWAssetsPlansTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        _tableView.tableHeaderView=self.investHeadView;
        [self.view addSubview:_tableView];
        
        
    }
    return _tableView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 124.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.investViewModel.stateArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    InterestCompleteViewModel *model=self.investViewModel.stateArray[indexPath.row];
    CYWAssetsPlansTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.model=model;
    //cell.name=self.params[@"name"];
    cell.name=nil;
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
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
- (CYWAssetsInvestHeadView *)investHeadView{
    if (!_investHeadView) {

        _investHeadView=[CYWAssetsInvestHeadView new];
    }
    return _investHeadView;
}


- (void)dealloc{
    self.investHeadView=nil;
    NSLog(@"还款计划销毁");
}
@end

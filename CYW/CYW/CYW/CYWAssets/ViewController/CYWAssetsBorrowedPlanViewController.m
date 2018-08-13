//
//  CYWAssetsBorrowedPlanViewController.m
//  CYW
//
//  Created by jktz on 2017/10/26.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsBorrowedPlanViewController.h"
#import "CYWAssetsBorrowedPlanTableViewCell.h"
#import "CYWAssetsInvestViewModel.h"
#import <EAFeatureGuideView/UIView+EAFeatureGuideView.h>
@interface CYWAssetsBorrowedPlanViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) CYWAssetsInvestViewModel *investViewModel;

@end

@implementation CYWAssetsBorrowedPlanViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"还款计划";
    self.view.backgroundColor=[UIColor whiteColor];
    self.investViewModel=[[CYWAssetsInvestViewModel alloc] init];
    
    [self tableView];
    [self refreshload];
    
    [self showGuideView];
}

- (void)refreshload{
    
    self.investViewModel.borrowId=self.params[@"loadId"];//接受Id
    @weakify(self)
    [[self.investViewModel.refresBorrowedCommand execute:nil] subscribeNext:^(id x) {
        
        NSLog(@"刷新视图");
        @strongify(self)
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        
        [self.tableView reloadData];
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
        [_tableView registerClass:[CYWAssetsBorrowedPlanTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        [self.view addSubview:_tableView];
        
        
    }
    return _tableView;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 124.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.investViewModel.borrowedDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BorrowedPlanViewModel *model=self.investViewModel.borrowedDataArray[indexPath.row];
    CYWAssetsBorrowedPlanTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.model=model;
    cell.name=self.params[@"name"];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BorrowedPlanViewModel *model=self.investViewModel.borrowedDataArray[indexPath.row];
    if ([model.repaying isEqualToString:@"1"]) {
        
        if ([model.status isEqualToString:@"逾期"]&&
            [model.penalty floatValue] > 0.0) {
            
            @weakify(self)
            UIAlertView *alertView=[[UIAlertView alloc] bk_initWithTitle:@"提示" message:[NSString stringWithFormat:@"逾期还款罚息为:%.2f元,确定还款？",[model.penalty floatValue]]];
            [alertView bk_addButtonWithTitle:@"取消" handler:NULL];
            [alertView bk_addButtonWithTitle:@"还款" handler:^{
                
                @strongify(self)
                [self borrowedrepaymentsId:model.id];
                
            }];
            [alertView show];
            
        }
        else if ([model.status isEqualToString:@"repaying"]) {
            
            @weakify(self)
            UIAlertView *alertView=[[UIAlertView alloc] bk_initWithTitle:@"提示" message:@"确认还款吗?"];
            [alertView bk_addButtonWithTitle:@"取消" handler:NULL];
            [alertView bk_addButtonWithTitle:@"还款" handler:^{
                
                @strongify(self)
                [self borrowedrepaymentsId:model.id];
                
            }];
            [alertView show];
            
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
                                 NSFontAttributeName:[UIFont systemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#888888"],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:@"抱歉!加载失败了~~" attributes:attributes];
}



/**
 还款
 
 @param ids 模型的Id
 */
- (void)borrowedrepaymentsId:(NSString *)ids{
    
    [UIView showHUDLoading:nil];
    self.investViewModel.borrowId=ids;
    @weakify(self)
    [[self.investViewModel.refresRepaymentsCommand execute:nil] subscribeNext:^(id x) {
        
        NSLog(@"刷新视图");
        @strongify(self)
        [UIView showResultThenHide:x];
        [self bk_performBlock:^(id obj) {
            @strongify(self)
           [self refreshload];
            [self.tableView reloadData];
        } afterDelay:1.5];
        
    } error:^(NSError * _Nullable error) {
        [UIView showResultThenHide:(NSString *)error];
    }];
}

/**
 遮蔽
 */
- (void)showGuideView
{
    
        
        CGRect rect = CGRectMake(0, kDevice_Is_iPhoneX?88:64, SCREEN_WIDTH, 124.0);
        EAFeatureItem *item = [[EAFeatureItem alloc] initWithFocusRect:rect focusCornerRadius:0 focusInsets:UIEdgeInsetsZero];
        item.introduce = @"";
        item.actionTitle = @"选择即可还款";
        //当version不一致 代表不需要该提示
        [self.navigationController.view showWithFeatureItems:@[item] saveKeyName:@"cell22" inVersion:kGuideNormalVersion];//kGuideNormalVersion
    
    
}
@end

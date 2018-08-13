//
//  CYWAssetsCarManagermentViewController.m
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsCarManagermentViewController.h"
#import "CYWAssetsCarManagerViewModel.h"
#import "CYWAssetsCarManagerTableViewCell.h"
#import "CYWAssetsAddCarTableViewCell.h"
@interface CYWAssetsCarManagermentViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) CYWAssetsCarManagerViewModel *managerViewModel;
@end

@implementation CYWAssetsCarManagermentViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self refresh];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.managerViewModel=[[CYWAssetsCarManagerViewModel alloc] init];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"银行卡管理";
    [self tableView];
    
    
}

- (void)refresh{
    
    @weakify(self)
    [[self.managerViewModel.refreshDataCommand execute:nil] subscribeNext:^(id x) {
        
        NSLog(@"刷新视图");
        @strongify(self)
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}

- (void)loadBindCar{
    
     id object=[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserAuthentication];
    if ([NSObject isEmpty:object]) {
        
        [self pushViewController:@"CYWMoreUserCenterAuthenticationViewController"];
        return;
    }
    @weakify(self)
    [self showHUDLoading:nil];
    [[self.managerViewModel.refresBindCommand execute:nil] subscribeNext:^(id x) {
        
        @strongify(self)
        [self hideHUDLoading];
        [self pushViewController:@"CYWAssetsBindCarViewController" withParams:@{@"url":x,@"title":@"绑定银行卡"}];
    } error:^(NSError * _Nullable error) {
        
        [self showResultThenHide:(NSString *)error];
    }];
    NSLog(@"绑定");
}

- (void)loadDeleteCar{
    @weakify(self)
     [self showHUDLoading:nil];
    [[self.managerViewModel.refresDeleteCommand execute:nil] subscribeNext:^(id x) {
        
        @strongify(self)
        [self showResultThenHide:@"删除成功"];
        [self refresh];
    } error:^(NSError * _Nullable error) {
        [self.tableView reloadData];
        [self showResultThenHide:(NSString *)error];
    }];
}

#pragma mark 懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-getRectNavAndStatusHight) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=NO;
        _tableView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        _tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [_tableView registerClass:[CYWAssetsCarManagerTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        [_tableView registerClass:[CYWAssetsAddCarTableViewCell class] forCellReuseIdentifier:@"cells"];
        [self.view addSubview:_tableView];
        if (@available(ios 11.0,*)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
    }
    return _tableView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 130.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.managerViewModel.datassetslArray.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CYWAssetsCarManagerTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    CYWAssetsAddCarTableViewCell *cells=[tableView dequeueReusableCellWithIdentifier:@"cells"];
    @weakify(self)
    if (indexPath.row==self.managerViewModel.datassetslArray.count) {
        [cells setClickTableViewCell:^{
            
            @strongify(self)
            [self loadBindCar];
        }];
        return cells;
        
    }else{
        cell.indexPath=indexPath;
        CarManagerMentViewModel *model=self.managerViewModel.datassetslArray[indexPath.row];
        cell.model=model;
        [cell setCarmanagerTableViewCell:^(NSIndexPath *indexPath) {
            @strongify(self)
            [self deleteCarManager:indexPath];
        }];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)deleteCarManager:(NSIndexPath *)indexPath{
    
    CarManagerMentViewModel *model=self.managerViewModel.datassetslArray[indexPath.row];
    [self deleteCar:model.id];
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
}
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (editingStyle ==UITableViewCellEditingStyleDelete) {
        
        CarManagerMentViewModel *model=self.managerViewModel.datassetslArray[indexPath.row];
        [self deleteCar:model.id];
    }
    
}


//删除银行卡
- (void)deleteCar:(NSString *)carid{
    
    @weakify(self)
    self.managerViewModel.deleteCarId=carid;
    UIActionSheet *sheetView=[[UIActionSheet alloc] bk_initWithTitle:@"确定删除银行卡?"];
    [sheetView bk_addButtonWithTitle:@"确定" handler:^{
        @strongify(self)
        [self loadDeleteCar];
    }];
    [sheetView bk_setCancelButtonWithTitle:@"取消" handler:^{
        
    }];
    [sheetView showInView:self.view];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"icon_carbind"];
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
    
    return [[NSAttributedString alloc] initWithString:@"还没有银行卡!" attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *text = @"点击添加";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#888888"],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    
    [self loadBindCar];
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 0.0f;
}
- (void)dealloc{
    NSLog(@"银行卡管理销毁");
}
@end

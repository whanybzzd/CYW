//
//  CYWMoreUserCenterefereesViewController.m
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreUserCenterefereesViewController.h"
#import "CYWMoreUserCenterefereesTableViewCell.h"
#import "CYWMoreUserCenterefereesHeadView.h"
#import "CYWMoreUserCenterefereesFootView.h"
#import "CYWMoreUserCenterefereesViewModel.h"
@interface CYWMoreUserCenterefereesViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) CYWMoreUserCenterefereesHeadView *refereesHeadView;
@property (nonatomic, retain) CYWMoreUserCenterefereesFootView *refereesFootView;
@property (nonatomic, retain) CYWMoreUserCenterefereesViewModel *refereesViewModel;
@end

@implementation CYWMoreUserCenterefereesViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"推荐人";
    self.refereesViewModel=[[CYWMoreUserCenterefereesViewModel alloc] init];
    [self tableView];
     [self refresh];
}

- (void)refresh{
    
    @weakify(self)
    [[self.refereesViewModel.refreshrefereesCommand execute:nil] subscribeNext:^(id x) {
        
        NSLog(@"刷新视图");
        @strongify(self)
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.tableView reloadData];
    }];
}


- (UITableView *)tableView{
    
    
    if (!_tableView) {
        
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-getRectNavAndStatusHight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor colorWithHexString:@"#F5F5F9"];
        [_tableView registerClass:[CYWMoreUserCenterefereesTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        _tableView.tableHeaderView=self.refereesHeadView;
        //_tableView.tableFooterView=self.refereesFootView;
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.refereesViewModel.dataModelArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReferrerViewModel *model=self.refereesViewModel.dataModelArray[indexPath.row];
    CYWMoreUserCenterefereesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.model=model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0f;
}



- (CYWMoreUserCenterefereesHeadView *)refereesHeadView{
    if (!_refereesHeadView) {
        
        _refereesHeadView=[CYWMoreUserCenterefereesHeadView new];
    }
    return _refereesHeadView;
}
- (CYWMoreUserCenterefereesFootView *)refereesFootView{
    
    if (!_refereesFootView) {
        
        _refereesFootView=[CYWMoreUserCenterefereesFootView new];
    }
    return _refereesFootView;
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

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *text = @"重新加载";
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
    
    [self refresh];
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 0.0f;
}

- (void)dealloc{
    NSLog(@"我的推荐人销毁");
}
@end

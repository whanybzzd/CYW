//
//  CYWMoreUserCenterIntegralViewController.m
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreUserCenterIntegralViewController.h"
#import "CYWMoreUserCenterIntegralTableViewCell.h"
#import "CYWMoreUserCenterIntegralHeadView.h"
#import "CYWMoreIntegralViewModel.h"
#import "CYWArctileViewController.h"
@interface CYWMoreUserCenterIntegralViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) CYWMoreUserCenterIntegralHeadView *integralHeadView;
@property (nonatomic, retain) CYWMoreIntegralViewModel *integralViewModel;
@property (nonatomic, retain) UIButton *button;
@end

@implementation CYWMoreUserCenterIntegralViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadIntegeral];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.integralViewModel=[[CYWMoreIntegralViewModel alloc] init];
    
    self.navigationItem.title=@"我的积分";
    
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self.button setTitle:@"更多说明" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    self.button.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.button];
    
    [self tableView];
}

- (void)buttonClick:(UIButton *)sender{
    CYWArctileViewController *arctiVC=[[CYWArctileViewController alloc] init];
    NSString *loadUrl=[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,@"/mobile/vipIntro"];
    arctiVC.title=@"更多说明";
    [arctiVC loadWebURLSring:loadUrl];
    arctiVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:arctiVC animated:YES];
     //[self pushViewController:@"CYWMoreUserCenterInstructionViewController"];
}


- (void)loadIntegeral{
    
    @weakify(self)
    [[self.integralViewModel.refreshIntegralCommand execute:nil] subscribeNext:^(id x) {
        
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
        
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-getRectNavAndStatusHight-20) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [_tableView registerClass:[CYWMoreUserCenterIntegralTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        _tableView.tableHeaderView=self.integralHeadView;
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
    
    return self.integralViewModel.dataModelArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    IntegralViewModel *model=(IntegralViewModel *)self.integralViewModel.dataModelArray[indexPath.row];
    CYWMoreUserCenterIntegralTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.model=model;
    
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0f;
}



-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews {
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (CYWMoreUserCenterIntegralHeadView *)integralHeadView{
    if (!_integralHeadView) {
        
        _integralHeadView=[CYWMoreUserCenterIntegralHeadView new];
    }
    return _integralHeadView;
}
- (void)dealloc{
    NSLog(@"我的积分销毁");
}

@end

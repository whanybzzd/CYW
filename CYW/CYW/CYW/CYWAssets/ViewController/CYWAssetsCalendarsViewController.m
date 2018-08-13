//
//  CYWAssetsCalendarsViewController.m
//  CYW
//
//  Created by jktz on 2017/11/21.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsCalendarsViewController.h"
#import "CYWAssetsCalendarView.h"
#import "CYWAssetsCalendarTwoTableViewCell.h"
#import "CYWAssetsCalendarsTableViewCell.h"
#import "CYWAssetsCalendarViewModel.h"
@interface CYWAssetsCalendarsViewController ()<DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet CYWAssetsCalendarView *tableViewHeadView;
@property (strong, nonatomic) UIButton *button;
@property (strong, nonatomic) CYWAssetsCalendarViewModel *calendarViewModel;
@property  (strong, nonatomic) NSString *day;
@end

@implementation CYWAssetsCalendarsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"还款日历";
    self.view.backgroundColor=[UIColor whiteColor];
    self.tableView.tableHeaderView=self.tableViewHeadView;
    self.tableView.emptyDataSetSource = self;
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.separatorStyle=NO;
    [self.tableView registerClass:[CYWAssetsCalendarTwoTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    
    [self.tableView registerClass:[CYWAssetsCalendarsTableViewCell class] forCellReuseIdentifier:kItemCellIdentifier];
    self.tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self.button setTitle:@"关闭金额" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor colorWithHexString:@"#666666"] forState:UIControlStateNormal];
    self.button.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.button];
    
    
    self.calendarViewModel=[[CYWAssetsCalendarViewModel alloc] init];
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"load" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        
        
        //NSLog(@"选择的时间:%@",x.object[@"load"]);
        @strongify(self)
        [self refresh:x.object[@"load"]];
    }];
    
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"noti" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
      
        [self.calendarViewModel.dataModelArray removeAllObjects];
        [self.tableView reloadData];
    }];
}
- (void)buttonClick:(UIButton *)sender{
    sender.selected=!sender.selected;
    if (sender.selected) {
        
        [self.button setTitle:@"显示金额" forState:UIControlStateNormal];
    }else{
        
        [self.button setTitle:@"关闭金额" forState:UIControlStateNormal];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"show" object:@{@"selected":@(sender.selected)}];
}


- (void)refresh:(NSString *)day{
    
    [self showHUDLoading:nil];
    self.day=[day componentsSeparatedByString:@"-"][2];
    self.calendarViewModel.day=day;
    [[self.calendarViewModel.refreshCalendarCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        [self hideHUDLoading];
        [self.tableView reloadData];
    } error:^(NSError * _Nullable error) {
        
        [self hideHUDLoading];
        [self.calendarViewModel.dataModelArray removeAllObjects];
        [self.tableView reloadData];
    }];
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row==0) {
        
        return 100.0f;
    }else{
        
        return 124.0f;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([NSArray isNotEmpty:self.calendarViewModel.dataModelArray]) {
        
        return self.calendarViewModel.dataModelArray.count+1;
    }
    else{
        
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CYWAssetsCalendarTwoTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    CYWAssetsCalendarsTableViewCell *cells=[tableView dequeueReusableCellWithIdentifier:kItemCellIdentifier];
    
    if (indexPath.row==0) {
        cells.day=self.day;
        cells.mutableArray=self.calendarViewModel.moneyArray;
        return cells;
    }else{
        CalendarMonthDetailViewModel *model=self.calendarViewModel.dataModelArray[indexPath.row-1];
        cell.model=model;
        return cell;
    }
    return nil;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}

- (void)dealloc{
    NSLog(@"日历销毁");
}
@end

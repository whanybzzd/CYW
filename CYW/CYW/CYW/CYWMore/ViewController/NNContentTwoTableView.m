//
//  NNContentTwoTableView.m
//  CYW
//
//  Created by jktz on 2018/1/19.
//  Copyright © 2018年 jktz. All rights reserved.
//
#import "CYWFinanceTableViewCell.h"
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "CYWFinanceViewModel.h"
#import "NNContentTwoTableView.h"
@interface NNContentTwoTableView()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

@property (nonatomic, retain) CYWFinanceViewModel *financeViewModel;
@end
static NSString *NNContentTableViewCellID = @"NNContentTableView";
@implementation NNContentTwoTableView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = self;
        self.delegate=self;
        self.showsVerticalScrollIndicator = NO;
        self.financeViewModel=[[CYWFinanceViewModel alloc] init];
        
        self.emptyDataSetSource = self;
        self.emptyDataSetDelegate = self;
        self.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        self.backgroundColor=[UIColor colorWithHexString:@"#f4f4f4"];
        [self registerClass:[CYWFinanceTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        if (@available(ios 11.0,*)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            self.estimatedRowHeight = 0;
            self.estimatedSectionFooterHeight = 0;
            self.estimatedSectionHeaderHeight = 0;
        }
        //添加上拉刷新和下拉刷新
//        self.refreshControl=[[ODRefreshControl alloc] initInScrollView:_tableView];
//        [self.refreshControl addTarget:self action:@selector(refresh) forControlEvents:UIControlEventValueChanged];
        self.financeViewModel.type=@"new";//默认加载old数据
        //[self refresh];
    }
    return self;
}

- (void)didMoveToWindow {
    [super didMoveToWindow];
}

- (void)setContentOffset:(CGPoint)contentOffset {
    if (self.window) {
        [super setContentOffset:contentOffset];
    }
}

/**
 正常刷新
 */
- (void)refresh{
    
    @weakify(self)
    [[self.financeViewModel.refreshFinanceCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        [[NSNotificationCenter defaultCenter] postNotificationName:@"refresh" object:@{@"model":x}];
        [self.infiniteScrollingView stopAnimating];
        //[self.refreshControl endRefreshing];
        [self reloadData];
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        [self.infiniteScrollingView stopAnimating];
        //[self.refreshControl endRefreshing];
        [self reloadData];
    }];
}




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.financeViewModel.dataModelArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BankViewModel *model=self.financeViewModel.dataModelArray[indexPath.row];
    CYWFinanceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.indexPath=indexPath;
    if (indexPath.row<2) {
        cell.imageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"icon_finance_%zd",indexPath.row+1]];
    }else{
        
        cell.imageView.image=nil;
    }
    cell.model=model;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 62.0f;
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
    
    return [[NSAttributedString alloc] initWithString:@"抱歉!加载失败了~" attributes:attributes];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return (SCREEN_HEIGHT-320)/2;
}


- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    self.contentOffset = CGPointZero;
}
- (void)dealloc{
    
    NSLog(@"理财榜销毁");
}
@end

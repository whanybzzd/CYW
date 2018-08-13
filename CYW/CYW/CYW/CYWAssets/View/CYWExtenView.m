//
//  CYWExtenView.m
//  CYW
//
//  Created by jktz on 2018/7/25.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import "CYWExtenView.h"
#import "CYWExtenTableViewCell.h"
@interface CYWExtenView()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>


@end
@implementation CYWExtenView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        [self tableView];
        
    }
    return self;
}

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        //_tableView.separatorStyle=NO;
        _tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[CYWExtenTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [self addSubview:_tableView];
        if (@available(ios 11.0,*)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
        //添加上拉刷新和下拉刷新
        self.refreshControl=[[ODRefreshControl alloc] initInScrollView:_tableView];
    }
    return _tableView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ExtenViewModel *model=(ExtenViewModel *)self.dataArray[indexPath.row];
    
    CYWExtenTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.model=model;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    NSMutableArray * array = [NSMutableArray array];
    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , 45)];
    view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
    CGFloat width = view.bounds.size.width;
    CGFloat height = view.bounds.size.height;
    for (int i = 0; i < 5; i++) {
        UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i * width/5 + 15, 0, width/5 - 20, height)];
        
        label.tag = i;
        label.font=[UIFont systemFontOfSize:14];
        label.textColor=[UIColor colorWithHexString:@"#f52735"];
        [view addSubview:label];
        [array addObject:label];
    }
    for (UILabel *l in array) {
        switch (l.tag) {
            case 0:
                l.textAlignment = NSTextAlignmentCenter;
                l.text = @"期数";
                break;
            case 1:
                l.textAlignment = NSTextAlignmentCenter;
                l.text = @"本金";
                break;
            case 2:
                l.textAlignment = NSTextAlignmentCenter;
                l.text = @"利息";
                break;
            case 3:
                l.textAlignment = NSTextAlignmentCenter;
                l.text = @"还款日";
                break;
            case 4:
                l.textAlignment = NSTextAlignmentCenter;
                l.text = @"状态";
                break;
            default:
                break;
        }
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{



        return 45.0f;
   
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
    
    
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 0.0f;
}

@end

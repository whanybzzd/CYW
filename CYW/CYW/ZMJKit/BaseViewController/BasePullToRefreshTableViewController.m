//
//  BasePullToRefreshTableViewController.m
//  CYW
//
//  Created by jktz on 2017/8/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BasePullToRefreshTableViewController.h"

@interface BasePullToRefreshTableViewController ()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>
@property(nonatomic,assign)BOOL isAnimation;

@end

@implementation BasePullToRefreshTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableView];
}


- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        //_tableView.emptyDataSetSource = self;
        //_tableView.emptyDataSetDelegate = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

#pragma mark - 私有方法子类无需重写

- (void)reloadByAdding:(NSArray *)anArray {
    [super reloadByAdding:anArray];
    NSInteger displayedSectionIndex = [self.dataArray count];
    NSMutableArray *insertedIndexPaths = [NSMutableArray array];
    for (NSInteger insertedIndex = 0, insertedCount = [anArray count]; insertedIndex < insertedCount; insertedIndex ++) {
        [insertedIndexPaths addObject:[NSIndexPath indexPathForRow:displayedSectionIndex + insertedIndex inSection:0]];
    }
    NSIndexSet *insertedIndexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(displayedSectionIndex, [anArray count])];
    [self.tableView beginUpdates];
    [self.dataArray insertObjects:anArray atIndexes:insertedIndexSet];
    [self.tableView insertRowsAtIndexPaths:insertedIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
    [self.tableView endUpdates];
}

- (UIScrollView *)contentScrollView {
    return self.tableView;
}

- (void)reloadData {
    [self.tableView reloadData];
}


#pragma mark - 子类必须重写的方法

- (UIView *)layoutCellWithData:(id)object atIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    return cell;
}

#pragma mark - UITableView特有的方法

- (CGFloat)tableViewCellHeightForData:(id)object atIndexPath:(NSIndexPath *)indexPath {
    return 80.0f;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self cellCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id objectModel = nil;
    if (indexPath.row < [self.dataArray count]) {
        objectModel = [self.dataArray objectAtIndex:indexPath.row];
    }
    UITableViewCell *cell = (UITableViewCell *)[self layoutCellWithData:objectModel atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    id objectModel = nil;
    if (indexPath.row < [self.dataArray count]) {
        objectModel = [self.dataArray objectAtIndex:indexPath.row];
    }
    CGFloat rowHeight = [self tableViewCellHeightForData:objectModel atIndexPath:indexPath];
    return rowHeight;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id objectModel = nil;
    if (indexPath.row < [self.dataArray count]) {
        objectModel = [self.dataArray objectAtIndex:indexPath.row];
    }
    [self clickedCell:objectModel atIndexPath:indexPath];
}

#pragma mark - scrollViewDelegate


//该方法是列表的自带线条铺满
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
//    if (!_isAnimation)
//    {
//        return;
//    }
//    //添加cell慢动画
//    CGAffineTransform tran = CGAffineTransformMakeTranslation(cell.transform.tx, cell.transform.ty + 70);
//    cell.transform = tran;
//    [UIView animateWithDuration:0.8 animations:^{
//        cell.transform = CGAffineTransformMakeTranslation(cell.transform.tx, cell.transform.ty - 70);
//    }];
}

-(void)viewDidLayoutSubviews {
    
    if ([self.contentScrollView respondsToSelector:@selector(setSeparatorInset:)]) {
        
    }
    if ([self.contentScrollView respondsToSelector:@selector(setLayoutMargins:)])  {
        [self.contentScrollView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}


- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"cmview"];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#666666"],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:[self hitWhenEndData] attributes:attributes];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    NSString *text = @"点击刷新";
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:15.0f],
                                 NSForegroundColorAttributeName:[UIColor colorWithHexString:@"#0072d2"],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    
    [self refreshControlAction];
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 0.0f;
}


@end

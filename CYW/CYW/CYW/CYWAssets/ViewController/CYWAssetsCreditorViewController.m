//
//  CYWAssetsCreditorViewController.m
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsCreditorViewController.h"
#import "XTSegmentControl.h"
#import "CYWAssetsEnvelopeTableViewCell.h"
#import "CYWAssetsCreditorViewModel.h"
#import <ODRefreshControl/ODRefreshControl.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
#import "CYWAssetsCreditorTableViewCell.h"
#import "CYWAlertView.h"
#import <EAFeatureGuideView/UIView+EAFeatureGuideView.h>
@interface CYWAssetsCreditorViewController()<UITableViewDelegate,UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate,XTSegmentControlDelegate,CYWAssetsCreditorTableViewCellDelegate>
@property (retain, nonatomic) UIView *sectionHeaderView;
@property (nonatomic, retain) ODRefreshControl *refreshControl;
@property (retain, nonatomic) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *countArray;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger curpageIndex;
@property (nonatomic, retain) CYWAssetsCreditorViewModel *assetsCreditorViewModel;
@property (nonatomic, assign) NSInteger selectheadIndex;//选择的下标

@property (nonatomic, strong) NSArray *preferentialArray;
@end
@implementation CYWAssetsCreditorViewController
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"我的债权";
    self.curpageIndex=1;//默认为第一页
    self.selectheadIndex=0;
    [self saveIndex:0];//默认保存为0
    [self tableView];
    if (!_sectionHeaderView) {
        
        _sectionHeaderView=[[XTSegmentControl alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 54.0) Items:@[@"已转入", @"可转出",@"转让中",@"已转出",@"已展期"] delegate:self];
        _sectionHeaderView.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
    }
    [self initSubView];
}


- (void)initSubView{
    
    //初始化Model
    self.assetsCreditorViewModel=[[CYWAssetsCreditorViewModel alloc] init];
    
    //请求类型
    self.preferentialArray = @[@"transfered",@"canTransfer",@"transferIn",@"transferOut",@"extensioning"];
    
    @weakify(self)
    //点击头部选择框
    [[[[self rac_signalForSelector:@selector(segmentControl:selectedIndex:) fromProtocol:@protocol(XTSegmentControlDelegate)] doNext:^(RACTuple * _Nullable x) {
        
        @strongify(self)
        if ([NSArray isNotEmpty:self.dataArray]) {
            
            [self.dataArray removeAllObjects];
        }
        [self saveIndex:[x.second integerValue]];
        self.selectheadIndex=[x.second integerValue];
        self.curpageIndex=1;
        [self showHUDLoading:nil];
        
    }] flattenMap:^__kindof RACSignal * _Nullable(RACTuple * _Nullable value) {
        
        @strongify(self)
        return [[self.assetsCreditorViewModel refreshNormal:self.preferentialArray[self.selectheadIndex] curpage:self.curpageIndex]catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
            [self hideHUDLoading];
            self.dataArray=nil;
            [self.tableView reloadData];
            return [RACSignal empty];
            
        }];
    }] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        [self hideHUDLoading];
        self.dataArray=x;
        [self.tableView reloadData];
        [self loadGuide];
        
    }];
    
    
    //进入页面的时候加载数据
    
    [[[[self rac_signalForSelector:@selector(viewWillAppear:)] doNext:^(RACTuple * _Nullable x) {
        
    }] flattenMap:^__kindof RACSignal * _Nullable(RACTuple * _Nullable value) {
        @strongify(self)
        
        return [[self.assetsCreditorViewModel refreshNormal:self.preferentialArray[self.selectheadIndex] curpage:self.curpageIndex]catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
            
            [self.tableView.infiniteScrollingView stopAnimating];
            return [RACSignal empty];
            
        }];
        
    }] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        self.dataArray=x;
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
        [self loadGuide];
    }];
    
    
    //下来刷新
    [[[self.refreshControl rac_signalForControlEvents:UIControlEventValueChanged] flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
        
        @strongify(self)
        self.curpageIndex=1;
        return [[self.assetsCreditorViewModel refreshNormal:self.preferentialArray[self.selectheadIndex] curpage:self.curpageIndex]catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
            
            [self.refreshControl endRefreshing];
            [self.tableView.infiniteScrollingView stopAnimating];
            return [RACSignal empty];
            
        }];
        
    }] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        self.dataArray=x;
        [self.refreshControl endRefreshing];
        [self.tableView.infiniteScrollingView stopAnimating];
        [self.tableView reloadData];
    }];
    
    
    
    //加载更多
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        
        @strongify(self)
        self.curpageIndex++;
        [[[self.assetsCreditorViewModel refreshNormal:self.preferentialArray[self.selectheadIndex] curpage:self.curpageIndex]catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
            
            [self.refreshControl endRefreshing];
            [self.tableView.infiniteScrollingView stopAnimating];
            return [RACSignal empty];
            
        }] subscribeNext:^(id  _Nullable x) {
            
            
            @strongify(self)
            //添加更多数据
            for (id models in x) {
                CreditorViewModel *model=(CreditorViewModel *)models;
                [self.dataArray addObject:model];
            }
            [self.refreshControl endRefreshing];
            [self.tableView.infiniteScrollingView stopAnimating];
            [self.tableView reloadData];
        }];
    }];
    
    
    //cell协议处理方式
    [[self rac_signalForSelector:@selector(tableViewCellIdenti:indexPath:) fromProtocol:@protocol(CYWAssetsCreditorTableViewCellDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        
        NSIndexPath *indexPath=x.second;
        @strongify(self)
        if ([x.first isEqualToString:@"lookDetail"]) {
            
            CreditorViewModel *model=self.dataArray[indexPath.row];
            if ([NSObject isNotEmpty:model]) {
                
                [self pushViewController:@"CYWNowInvestmentViewController" withParams:@{@"id":model.loanId}];
            }
        }else{
            
            CreditorViewModel *model=self.dataArray[indexPath.row];
            //之前是要请求下面这个接口的，现在不用了，但是保留着
            [self showAlertView:5 action:@"transfer" withModel:model reBool:NO];
            /**
            //展期按钮
            [self showHUDLoading:nil];
            [[[self.assetsCreditorViewModel refreshInverstId:model.investId] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {

                @strongify(self)
                [self hideHUDLoading];
                return [RACSignal empty];

            }] subscribeNext:^(id  _Nullable x) {

                [self hideHUDLoading];
                //弹框
                [self showAlertView:[x integerValue] action:@"transfer" withModel:model reBool:NO];
            }];
             */
        }
        
        
    }];
    
    
    //cell点击事件
    [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
       
        NSIndexPath *indexPath=x.second;
        CreditorViewModel *model=self.dataArray[indexPath.row];
        
        if (1==self.selectheadIndex){
            
            //之前是要请求下面这个接口的，现在不用了，但是保留着
            [self showAlertView:5 action:@"transfer" withModel:model reBool:YES];
            
            /**
            [self showHUDLoading:nil];
            [[[self.assetsCreditorViewModel refreshInverstId:model.investId] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
                
                @strongify(self)
                [self hideHUDLoading];
                return [RACSignal empty];
                
            }] subscribeNext:^(id  _Nullable x) {
                
                @strongify(self)
                [self hideHUDLoading];
                //弹框
                [self showAlertView:[x integerValue] action:@"transfer" withModel:model reBool:YES];
                
            }];
             */
            
            
        }else if (2==self.selectheadIndex){
            
            UIAlertView *alertView=[[UIAlertView alloc]bk_initWithTitle:@"提示" message:@"是否取消转让?"];
            [alertView bk_addButtonWithTitle:@"确定" handler:^{
                
                @strongify(self)
                [self showHUDLoading:nil];
                [[[self.assetsCreditorViewModel cancelTransfer:model.id] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
                    
                    [self hideHUDLoading];
                    return [RACSignal empty];
                    
                }] subscribeNext:^(id  _Nullable x) {
                    
                    @strongify(self)
                    [self hideHUDLoading];
                    [self refreshloadData];
                    
                }];
            }];
            [alertView bk_addButtonWithTitle:@"取消" handler:^{
                
            }];
            [alertView show];
            
        }
        
        else if (4==self.selectheadIndex){
            
            //展期列表中区
            [self pushViewController:@"CYWExtenViewController" withParams:@{@"id":model.investExtensionId}];
        }
    }];
    
}






////TODO:很想改了，但是我不想动
- (void)saveIndex:(NSInteger)index{
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%zd",index] forKeyPath:@"keys"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


//重新刷新数据
- (void)refreshloadData{
    
    @weakify(self)
    self.curpageIndex=1;
    [[[self.assetsCreditorViewModel refreshNormal:self.preferentialArray[self.selectheadIndex] curpage:self.curpageIndex]catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        
        @strongify(self)
        [self hideHUDLoading];
        self.dataArray=nil;
        [self.tableView reloadData];
        return [RACSignal empty];
        
    }] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        [self hideHUDLoading];
        self.dataArray=x;
        [self.tableView reloadData];
    }];
}

/**
 遮蔽层  用于提示用户操作
 */
- (void)loadGuide{
    
    if (1==self.selectheadIndex) {
        if (self.dataArray.count>0) {
            
            [self showGuideView:@"选择即可转出" withIden:@"cell33"];
        }
        
    }else if(2==self.selectheadIndex){
        
        if (self.dataArray.count>0) {
            
            [self showGuideView:@"选择即可取消" withIden:@"cell44"];
        }
    }
}
#pragma mark 懒加载
- (UITableView *)tableView{
    
    if (!_tableView) {
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-getRectNavAndStatusHight-54) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.separatorStyle=NO;
        _tableView.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        [_tableView registerClass:[CYWAssetsCreditorTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        [self.view addSubview:_tableView];
        if (@available(ios 11.0,*)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
        //添加上拉刷新和下拉刷新
        self.refreshControl=[[ODRefreshControl alloc] initInScrollView:self.tableView];
    }
    return _tableView;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.sectionHeaderView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (4==self.selectheadIndex) {
        
        return 182.0f;
    }else{
        
        return 142.0f;
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CreditorViewModel *model=self.dataArray[indexPath.row];
    CYWAssetsCreditorTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.delegate=self;
    cell.model=model;
    cell.indexPath=indexPath;
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{}




/**
 弹出计算费率的对话框
 
 @param count 之前的规定是多少期限
 @param action 类型
 @param model 数据
 @param bo 区分是否需要传入参数
 */

- (void)showAlertView:(NSInteger)count action:(NSString *)action withModel:(CreditorViewModel *)model reBool:(BOOL)bo{
    
    WeakSelfType blockSelf=self;
    CYWAlertView *alertView=[[CYWAlertView alloc]
                             initWithAlertView:model action:action transSuccess:^{
                                 
                                 [blockSelf refreshloadData];
                             } transFailer:^{
                                 
                                 
                             } withCount:count reBool:bo];
    [alertView show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 54.0f;
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
    
    [self refreshloadData];
}


- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return 0.0f;
}
- (void)dealloc{
    NSLog(@"我的债权销毁");
}


/**
 遮蔽
 */
- (void)showGuideView:(NSString *)title withIden:(NSString *)iden
{
    
    
    CGRect rect = CGRectMake(0, kDevice_Is_iPhoneX?88+54:64+54, SCREEN_WIDTH, 142.0);
    EAFeatureItem *item = [[EAFeatureItem alloc] initWithFocusRect:rect focusCornerRadius:0 focusInsets:UIEdgeInsetsZero];
    item.introduce = @"";
    item.actionTitle = title;
    //当version不一致 代表不需要该提示
    [self.navigationController.view showWithFeatureItems:@[item] saveKeyName:iden inVersion:kGuideNormalVersion];//kGuideNormalVersion
    
    
}


@end

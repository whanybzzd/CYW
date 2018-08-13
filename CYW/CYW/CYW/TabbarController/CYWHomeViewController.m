//
//  CYWHomeViewController.m
//  CYW
//
//  Created by jktz on 2017/9/30.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWHomeViewController.h"
#import "CYWHomeViewModel.h"
#import "CYWHomeBannerViewModel.h"
#import "CYWHomeTableView.h"
@interface CYWHomeViewController ()

@property (nonatomic, retain) CYWHomeViewModel *homeViewModel;
@property (nonatomic, strong) CYWHomeTableView *homeView;
@end

@implementation CYWHomeViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    
    self.homeView=[CYWHomeTableView new];
    [self.view addSubview:self.homeView];
    self.homeView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    
    [self initSubView];
    
}

- (void)initSubView{
    
    CYWHomeBannerViewModel *bannerModel=[CYWHomeBannerViewModel new];
    CYWHomeViewModel *homeViewModel=[CYWHomeViewModel new];
    
    @weakify(self)
    [[[[self rac_signalForSelector:@selector(viewWillAppear:)] doNext:^(RACTuple * _Nullable x) {
        
        @strongify(self)
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        //去掉导航栏底部的黑线
        self.navigationController.navigationBar.shadowImage = [UIImage new];
        
    }] flattenMap:^__kindof RACSignal * _Nullable(RACTuple * _Nullable value) {
        
        @strongify(self)
        return [[bannerModel refreshNewData] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
            
            [self.homeView.tableView reloadData];
            return [RACSignal empty];
        }];
        
    }] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        self.homeView.bannerArray = bannerModel.imageArray;
        self.homeView.bannerTitleArray=bannerModel.titleArray;
        self.homeView.bannerUrlArray=bannerModel.urlArray;
        
        //跑马灯
        self.homeView.arcIdArray=bannerModel.articleIdArray;
        self.homeView.arcArray=bannerModel.articleArray;
        [self.homeView reloadData];
        [self.homeView.tableView reloadData];
    }];
    
    
    [[self rac_signalForSelector:@selector(viewWillDisappear:)] subscribeNext:^(RACTuple * _Nullable x) {
        
        @strongify(self)
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setShadowImage:nil];
    }];
    
    
    //MARK：下拉刷新事件
    [[[[self.homeView.refreshControl rac_signalForControlEvents:UIControlEventValueChanged]
       doNext:^(__kindof UIControl * _Nullable x) {
           
           
       }] flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
           
           @strongify(self)
           return [[homeViewModel refreshNewData] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
               
               @strongify(self)
               [self.homeView.refreshControl endRefreshing];
               return [RACSignal empty];
               
           }];
       }] subscribeNext:^(id  _Nullable x) {
           
           @strongify(self)
           self.homeView.projectArray=homeViewModel.dataModelArray;
           self.homeView.dataArray=homeViewModel.noviceArray;
           [self.homeView.refreshControl endRefreshing];
           [self.homeView.tableView reloadData];
       }];
    
    
    //MARK:进入页面请求 ---只请求一次
    [[[homeViewModel refreshNewData] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
        
        @strongify(self)
        [self.homeView.refreshControl endRefreshing];
        return [RACSignal empty];
        
    }] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        self.homeView.projectArray=homeViewModel.dataModelArray;
        self.homeView.dataArray=homeViewModel.noviceArray;
        [self.homeView.refreshControl endRefreshing];
        [self.homeView.tableView reloadData];
    }];
    
}



@end

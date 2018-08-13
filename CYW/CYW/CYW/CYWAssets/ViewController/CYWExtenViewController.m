//
//  CYWExtenViewController.m
//  CYW
//
//  Created by jktz on 2018/7/24.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import "CYWExtenViewController.h"
#import "CYWExtenView.h"
#import "CYWExtenViewModel.h"
@interface CYWExtenViewController ()
@property (nonatomic, strong) CYWExtenView *extenView;
@property (nonatomic, strong) CYWExtenViewModel *extenViewModel;

@end

@implementation CYWExtenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"展期计划";
    
    self.extenView=[[CYWExtenView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-getRectNavAndStatusHight)];
    [self.view addSubview:self.extenView];
    
    [self initSubView];
    
}

- (void)initSubView{
    
    //初始化Model
    self.extenViewModel=[CYWExtenViewModel new];
    
    @weakify(self)
    //进入页面的时候请求数据
    [[[[self rac_signalForSelector:@selector(viewWillAppear:)] doNext:^(RACTuple * _Nullable x) {
        
        @strongify(self)
        //[self.extenView.refreshControl beginRefreshing];
        [self showHUDLoading:nil];
        
    }] flattenMap:^__kindof RACSignal * _Nullable(RACTuple * _Nullable value) {
        
        @strongify(self)
        return [[self.extenViewModel extenId:self.params[@"id"]] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
           
            //[self.extenView.refreshControl endRefreshing];
            [self hideHUDLoading];
            [self.extenView.tableView reloadData];
            return  [RACSignal empty];
        }];
    }] subscribeNext:^(id  _Nullable x) {
      
        @strongify(self)
        self.extenView.dataArray=x;
        [self hideHUDLoading];
        [self.extenView.tableView reloadData];
         //[self.extenView.refreshControl endRefreshing];
    }];
    
    
//    //下拉刷新
//    [[[self.extenView.refreshControl rac_signalForControlEvents:UIControlEventValueChanged] flattenMap:^__kindof RACSignal * _Nullable(__kindof UIControl * _Nullable value) {
//
//        @strongify(self)
//        return [[self.extenViewModel extenId:self.params[@"id"]] catch:^RACSignal * _Nonnull(NSError * _Nonnull error) {
//
//            [self.extenView.refreshControl endRefreshing];
//            return  [RACSignal empty];
//        }];
//    }] subscribeNext:^(id  _Nullable x) {
//
//        @strongify(self)
//        self.extenView.dataArray=x;
//        [self.extenView.refreshControl endRefreshing];
//
//    }];
    
    
}

@end

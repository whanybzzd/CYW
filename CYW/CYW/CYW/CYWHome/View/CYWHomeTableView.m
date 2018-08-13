//
//  CYWHomeTableView.m
//  CYW
//
//  Created by jktz on 2018/5/22.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import "CYWHomeTableView.h"
#import <ODRefreshControl/ODRefreshControl.h>
#import "HomeBannerTableViewCell.h"
#import "HomeZoneTableViewCell.h"
#import "HomeNewStandTableViewCell.h"
#import "CYWHomeTableViewCell.h"
#import "TouchHomeView.h"
@interface CYWHomeTableView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) TouchHomeView *dragView;
@property (nonatomic, strong) HomeBannerTableViewCell *bannerView;

@end
@implementation CYWHomeTableView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        [self tableView];
        [self dragView];
    }
    return self;
}


- (UITableView *)tableView{
    
    if (!_tableView) {
        
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, kDevice_Is_iPhoneX?SCREEN_HEIGHT-68:SCREEN_HEIGHT-44) style:UITableViewStylePlain];
        _tableView.separatorStyle = NO;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [self addSubview:_tableView];
        if (@available(ios 11.0,*)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
        _tableView.tableHeaderView=self.bannerView;
        //        [_tableView registerClass:[HomeBannerTableViewCell class] forCellReuseIdentifier:HomeBannerItemCell];
        [_tableView registerClass:[HomeZoneTableViewCell class] forCellReuseIdentifier:HomeZoneItemCell];
        [_tableView registerClass:[HomeNewStandTableViewCell class] forCellReuseIdentifier:HomeNewStandItemCell];
        [_tableView registerClass:[CYWHomeTableViewCell class] forCellReuseIdentifier:HomeItemCell];
        //添加上拉刷新和下拉刷新
        self.refreshControl=[[ODRefreshControl alloc] initInScrollView:_tableView];
        
        
        
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 2+self.projectArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0==indexPath.row){
        
        HomeZoneTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:HomeZoneItemCell];
        cell.titleArray=@[@"活动专区",@"新手引导",@"资费说明"];
        return cell;
    }else if(1==indexPath.row){
        
        HomeNewStandTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:HomeNewStandItemCell];
        cell.dataArray=self.dataArray;
        [cell reloadData];
        return cell;
    }
    else{
        
        CYWHomeTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:HomeItemCell];
        ProjectViewModel *model=self.projectArray[indexPath.row-2];
        cell.model=model;
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0==indexPath.row){
        
        return 114.0f;
    }else if(1==indexPath.row){
        
        return [HomeNewStandTableViewCell cellHeight:self.dataArray];
    }else{
        
        return 130.0f;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BaseViewController *baseVC=(BaseViewController *)[UIView currentViewController];
    ProjectViewModel *model=(ProjectViewModel *)self.projectArray[indexPath.row-2];
    //NSLog(@"model:%@",model);
    [baseVC pushViewController:@"CYWNowInvestmentViewController" withParams:@{@"id":model.id}];
}

- (void)reloadData{
    
    self.bannerView.scrollView .imageURLStringsGroup = self.bannerArray;
    self.bannerView.urlArray=self.bannerUrlArray;
    self.bannerView.titleArray=self.bannerTitleArray;
    
    //跑马灯
    self.bannerView.arcIdArray=self.arcIdArray;
    self.bannerView.arcArray=self.arcArray;
    self.bannerView.lrScrollView.sourceArray = self.arcArray;
    [self.bannerView.lrScrollView scrollWithCallbackBlock:^(JhtVerticalMarquee *view, NSInteger currentIndex) {
        //NSLog(@"滚动到第 %ld 条数据", (long)currentIndex);
    }];
}

-(HomeBannerTableViewCell *)bannerView{
    if (!_bannerView) {
        
        _bannerView=[HomeBannerTableViewCell new];
        
    }
    return _bannerView;
}

- (TouchHomeView *)dragView{
    if (!_dragView) {
        
        //悬浮
        _dragView = [[TouchHomeView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-100, SCREEN_HEIGHT/2, 100, 90)];
        [self addSubview:_dragView];
    }
    return _dragView;
}
@end

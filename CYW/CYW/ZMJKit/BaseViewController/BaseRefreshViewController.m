//
//  BaseRefreshViewController.m
//  FrameWork
//
//  Created by ZMJ on 2017/3/25.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "BaseRefreshViewController.h"
#import <ODRefreshControl/ODRefreshControl.h>
#import <SVPullToRefresh/SVPullToRefresh.h>
// Unique key for cache array
#define KeyOfCachedArray      @"KeyOfCachedArray"
@interface BaseRefreshViewController ()

@property (nonatomic, retain) ODRefreshControl *refreshControl;
@end

@implementation BaseRefreshViewController

- (NSMutableArray *)dataArray{
    
    if (!_dataArray) {
        
        _dataArray=[NSMutableArray array];
    }
    return _dataArray;
}





- (void)viewDidLoad {
    [super viewDidLoad];
    //self.automaticallyAdjustsScrollViewInsets = NO;
    //self.edgesForExtendedLayout = UIRectEdgeNone;
    self.currentPageIndex = 1;
    WeakSelfType blockSelf=self;
    //Load local cache
    if ([self shouldCacheArray]) {
        NSArray *cacheArray = [self loadCacheArray];
        if ([NSObject isNotEmpty:cacheArray]) {
            [self.dataArray addObjectsFromArray:cacheArray];
        }
    }
    
    if ([self refreshEnable]) {
        
        self.refreshControl=[[ODRefreshControl alloc] initInScrollView:self.contentScrollView];
        //Add refresh method
        [self.refreshControl addTarget:self action:@selector(refreshControlAction) forControlEvents:UIControlEventValueChanged];
        //More refresh
        if ([self loadMoreEnable]) {
            
            [self.contentScrollView addInfiniteScrollingWithActionHandler:^{
                
                [blockSelf loadMoreRefreshBlocks:blockSelf.successBlock andRefreshFailer:blockSelf.failedBlock];
                
            }];
        }
    }
    
}





- (void)refreshControlAction{
    
    [self refreshBlocks:self.successBlock andRefreshFailer:self.failedBlock];
}


- (BOOL)refreshEnable{
    
    return NO;
}
- (BOOL)loadMoreEnable{
    
    return NO;
}

- (UIView *)layoutCellWithData:(id)object atIndexPath:(NSIndexPath *)indexPath{
    
    return nil;
}

- (void)clickedCell:(id)object atIndexPath:(NSIndexPath *)indexPath{
    
    
}


- (UIScrollView *)contentScrollView{
    
    return nil;
}

- (NSString *)methodWithPath{
    
    return @"";
}
- (NSDictionary *)dictParamWithPage:(NSInteger)page{
    
    return @{};
}
- (NSString *)hitWhenEndData{
    
    return @"";
}
- (BOOL)tipsViewEnable{
    
    return NO;
}
- (UIView *)tipsNoView{
    
    return nil;
}
- (BOOL)shouldCacheArray{
    
    return NO;
}

- (NSString *)modelOfName{
    
    return @"";
}
- (void)reloadData{
    
    
}

- (NSUInteger)cellCount{
    
    return self.dataArray.count;
}
/**
 The drop down refresh specific cache loading method is called by the loadCache method of the base class KeyOfCachedArray

 @return NSArray
 */
- (NSArray *)loadCacheArray {
    NSArray *cachedArray = [self cachedObjectForKey:KeyOfCachedArray];
    
    if ([cachedArray isKindOfClass:[NSArray class]] && [NSArray isNotEmpty:cachedArray]) {
        return cachedArray;
    }
    else { //There is no cache content
        return nil;
    }
    
}


- (void)reloadByReplacing:(NSArray *)anArray{
    
    [self.dataArray removeAllObjects];
    [self.dataArray addObjectsFromArray:anArray];
    
    //Agree to cache data
    if ([self shouldCacheArray]) {
        [self saveObject:anArray forKey:KeyOfCachedArray];
    }
    
    
}
- (void)reloadByAdding:(NSArray *)anArray{
    
    
}

- (NSArray *)preProcessData:(NSArray *)anArray{
    
    return anArray;
}

//More refresh
- (void)loadMoreRefreshBlocks:(PullToRefreshSuccessed) refreshSuccess andRefreshFailer:(PullToRefreshFailed) refreshFailer{
    [self loadMoreRefreshBlocks:refreshSuccess andRefreshFailer:refreshFailer withRequestType:RequestTypePOST];
}

- (void)loadMoreRefreshBlocks:(PullToRefreshSuccessed) refreshSuccess andRefreshFailer:(PullToRefreshFailed) refreshFailer withRequestType:(RequestType) requestType{
    WeakSelfType blockSelf=self;
    RequestSuccessed requestSuccessed=^(id responseObject){
        //Stop refresh
        [blockSelf.contentScrollView.infiniteScrollingView stopAnimating];
        [blockSelf hideHUDLoading];
        //Get results
        NSArray *dataArray=nil;
        if ([responseObject isKindOfClass:[NSArray class]]) {
            dataArray=(NSArray *)responseObject;
        }else if([responseObject isKindOfClass:[BaseDataModel class]]){
            dataArray=@[responseObject];
        }
        //2. Refresh list based on assembled array
        NSArray *newDataArray = nil;
        if ([dataArray count] > 0) {
            blockSelf.currentPageIndex++;//As long as the data is returned, the data will be added
            newDataArray = [blockSelf preProcessData:dataArray];
        }
        if ([newDataArray count] > 0) {
            [blockSelf reloadByAdding:newDataArray];
        }
        else {
            if ([blockSelf.dataArray count] == 0) {//Determines whether the total array is empty
            }
            //[blockSelf showResultThenHide:@"没有更多了"];
        }
        if (refreshSuccess) {
            refreshSuccess();
        }
    };
    
    RequestFailure requestFailureBlock = ^(NSInteger errorCode, NSString *errorMessage){
        [blockSelf.contentScrollView.infiniteScrollingView stopAnimating];
        if (refreshFailer) {
            refreshFailer();
        }
    };
    if (requestType==RequestTypeGET) {
        [AFNManager getDataWithAPI:[self methodWithPath]
                     withDictParam:[self dictParamWithPage:self.currentPageIndex+1]
                     withModelName:[self modelOfName]
                           isModel:YES
                  requestSuccessed:requestSuccessed
                     requestFailer:requestFailureBlock];
        
    }else if(requestType==RequestTypePOST){
        [AFNManager postDataWithAPI:[self methodWithPath]
                      withDictParam:[self dictParamWithPage:self.currentPageIndex+1]
                      withModelName:[self modelOfName]
                            isModel:YES
                   requestSuccessed:requestSuccessed
                      requestFailer:requestFailureBlock];
    }
}


//Normal refresh
- (void)refreshBlocks:(PullToRefreshSuccessed) refreshSuccess andRefreshFailer:(PullToRefreshFailed) refreshFailer{
    [self refreshBlocks:refreshSuccess andRefreshFailer:refreshFailer withRequestType:RequestTypePOST];
}
- (void)refreshBlocks:(PullToRefreshSuccessed) refreshSuccess andRefreshFailer:(PullToRefreshFailed) refreshFailer withRequestType:(RequestType) requestType{
    WeakSelfType blockSelf=self;
    RequestSuccessed requestSuccessed= ^(id responseObject){
        
        //Stop Refresh
        [blockSelf.refreshControl endRefreshing];
        [blockSelf hideHUDLoading];
        NSArray *dataArray=nil;
        if ([responseObject isKindOfClass:[NSArray class]]) {
            
            dataArray=(NSArray *)responseObject;
        }else if([responseObject isKindOfClass:[BaseDataModel class]]){
            dataArray = @[responseObject];
            
        }
        //2. Refresh list based on assembled array
        NSArray *newDataArray = nil;
        if ([dataArray count] > 0) {
            self.currentPageIndex=1;
            newDataArray = [blockSelf preProcessData:dataArray];
        }
        if ([newDataArray count] > 0) {
            [blockSelf reloadByReplacing:newDataArray];
        }
        else {
            //Empty existing data
            [blockSelf.dataArray removeAllObjects];
        }
        if (refreshSuccess) {
            refreshSuccess();
        }
        [blockSelf reloadData];
    };
    RequestFailure requestFailure=^(NSInteger index,NSString *errorMessage){
        [blockSelf.refreshControl endRefreshing];
    };
    if (requestType==RequestTypeGET) {
        [AFNManager getDataWithAPI:[self methodWithPath]
                     withDictParam:[self dictParamWithPage:1]
                     withModelName:[self modelOfName]
                           isModel:YES
                  requestSuccessed:requestSuccessed
                     requestFailer:requestFailure];
    }
    else if(requestType==RequestTypePOST){
        [AFNManager postDataWithAPI:[self methodWithPath]
                      withDictParam:[self dictParamWithPage:1]
                      withModelName:[self modelOfName]
                            isModel:YES
                   requestSuccessed:requestSuccessed
                      requestFailer:requestFailure];
    }
}


@end

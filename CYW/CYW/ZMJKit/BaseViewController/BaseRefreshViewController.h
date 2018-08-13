//
//  BaseRefreshViewController.h
//  FrameWork
//
//  Created by ZMJ on 2017/3/25.
//  Copyright © 2017年 ZMJ. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^PullToRefreshSuccessed)(void);
typedef void(^PullToRefreshFailed)(void);

@interface BaseRefreshViewController : BaseViewController
@property (nonatomic, retain) NSMutableArray *dataArray;//data source
@property (nonatomic, assign) NSInteger currentPageIndex;//Load more current pages
@property (nonatomic, copy) PullToRefreshFailed failedBlock;
@property (nonatomic, copy) PullToRefreshSuccessed successBlock;

- (void)refreshControlAction;
//Add new content refresh list
- (void)reloadByAdding:(NSArray *)anArray;
- (NSString *)methodWithPath;                                          //Interface method
- (NSDictionary *)dictParamWithPage:(NSInteger)page;
- (NSArray *)preProcessData:(NSArray *)anArray;              //Preprocess an array
- (UIView *)layoutCellWithData:(id)object atIndexPath:(NSIndexPath *)indexPath;     //Layout interfaces based on data
- (void)clickedCell:(id)object atIndexPath:(NSIndexPath *)indexPath;

- (BOOL)loadMoreEnable;                                                //Do you want to open more updates?
- (BOOL)refreshEnable;                                                  //Do you want to refresh?

- (NSUInteger)cellCount;                                                 //number of cell
- (NSString *)modelOfName;                                            //Name of entity class
- (void)reloadData;
- (NSString *)hitWhenEndData;                                        //When there is no data, a text prompt
- (UIScrollView *)contentScrollView;                                //Current uitableview
- (BOOL)shouldCacheArray;      //Cache
- (NSArray *)loadCacheArray;                        //Load cache array
@end

//
//  CYWHomeTableView.h
//  CYW
//
//  Created by jktz on 2018/5/22.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ODRefreshControl;
@interface CYWHomeTableView : UIView
@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *bannerArray;
@property (nonatomic, copy) NSArray *bannerTitleArray;
@property (nonatomic, copy) NSArray *bannerUrlArray;
@property (nonatomic, copy) NSArray *arcArray;
@property (nonatomic, copy) NSArray *arcIdArray;
@property (nonatomic, strong) NSArray *projectArray;
@property (nonatomic, strong) NSArray *dataArray;
- (void)reloadData;
@end

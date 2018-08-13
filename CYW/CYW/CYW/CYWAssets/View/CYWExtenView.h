//
//  CYWExtenView.h
//  CYW
//
//  Created by jktz on 2018/7/25.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYWExtenView : UIView
@property (nonatomic, strong) ODRefreshControl *refreshControl;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) UITableView *tableView;
@end

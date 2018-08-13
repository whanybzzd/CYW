//
//  BasePullToRefreshTableViewController.h
//  CYW
//
//  Created by jktz on 2017/8/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseRefreshViewController.h"

@interface BasePullToRefreshTableViewController : BaseRefreshViewController
@property (nonatomic, retain) UITableView *tableView;


- (CGFloat)tableViewCellHeightForData:(id)object atIndexPath:(NSIndexPath *)indexPath;
@end

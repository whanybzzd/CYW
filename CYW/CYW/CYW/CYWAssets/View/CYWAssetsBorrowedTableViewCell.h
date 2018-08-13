//
//  CYWAssetsBorrowedTableViewCell.h
//  CYW
//
//  Created by jktz on 2017/10/19.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BorrowedTableViewCellIndexPath)(NSIndexPath *indexPath);


@interface CYWAssetsBorrowedTableViewCell : UITableViewCell
@property (nonatomic, retain) ProjectViewModel *model;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, copy) BorrowedTableViewCellIndexPath borrowedTableViewcell;

@end

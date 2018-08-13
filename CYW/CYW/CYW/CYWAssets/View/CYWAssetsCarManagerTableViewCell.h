//
//  CYWAssetsCarManagerTableViewCell.h
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

typedef void (^AssetsCarManagerTableViewCell)(NSIndexPath *indexPath);

#import <UIKit/UIKit.h>

@interface CYWAssetsCarManagerTableViewCell : UITableViewCell
@property (nonatomic, retain) CarManagerMentViewModel *model;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, copy) AssetsCarManagerTableViewCell carmanagerTableViewCell;

@end

//
//  CYWAssetsInvestTableViewCell.h
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AssetsInvestTableViewCell)(NSIndexPath *indexPath);
@interface CYWAssetsInvestTableViewCell : UITableViewCell

@property (nonatomic, retain) InvestViewModel *model;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, copy) AssetsInvestTableViewCell clickCell;

@end

//
//  CYWFinanceTableViewCell.h
//  CYW
//
//  Created by jktz on 2017/11/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYWFinanceTableViewCell : UITableViewCell
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) BankViewModel *model;
@end

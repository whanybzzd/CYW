//
//  CYWAssetsTableViewCell.h
//  CYW
//
//  Created by jktz on 2017/10/12.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYWAssetsTableViewCell : UITableViewCell

@property (nonatomic, retain) UIImageView *iconImageView;
@property (nonatomic, retain) UILabel *iconlabel;
@property (nonatomic, retain) NSIndexPath *indexPath;
@property (nonatomic, retain) NSString *detailString;

@end

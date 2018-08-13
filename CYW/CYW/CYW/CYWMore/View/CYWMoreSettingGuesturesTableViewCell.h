//
//  CYWMoreSettingGuesturesTableViewCell.h
//  CYW
//
//  Created by jktz on 2017/10/25.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SwitchSelect)(BOOL select);
@interface CYWMoreSettingGuesturesTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) NSIndexPath *indexPath;

@property (nonatomic, copy) SwitchSelect switchSelect;
@end

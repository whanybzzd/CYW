//
//  CYWMoreAutomaticTableViewCell.h
//  CYW
//
//  Created by jktz on 2017/10/20.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SwitchSelect)(BOOL select);
@interface CYWMoreAutomaticTableViewCell : UITableViewCell
@property (nonatomic, retain) UISwitch *switchs;
@property (nonatomic, copy) SwitchSelect select;
@end

//
//  CYWAssetsAddCarTableViewCell.h
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^AddCarTableViewCell)();
@interface CYWAssetsAddCarTableViewCell : UITableViewCell

@property (nonatomic, copy) AddCarTableViewCell clickTableViewCell;

@end

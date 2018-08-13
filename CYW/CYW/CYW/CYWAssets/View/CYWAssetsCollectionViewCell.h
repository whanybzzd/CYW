//
//  CYWAssetsCollectionViewCell.h
//  CYW
//
//  Created by jktz on 2017/11/21.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYWAssetsCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic)  UILabel *timelabel;
@property (strong, nonatomic)  UIView *rightView;
@property (strong, nonatomic)  UILabel *pricelabel;
@property (strong, nonatomic)  UILabel *numberlabel;
@property (strong, nonatomic)NSDate *cellDate;
@property (strong, nonatomic)NSDate *curDate;//本地日期时间
@property (strong, nonatomic)NSDate *selectedDate;//当前选中的日期时间
@property (strong, nonatomic)NSArray *priceDateArr;
@property (strong, nonatomic)NSArray *priceArr;
@end

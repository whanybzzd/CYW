//
//  HomeNewStandTableViewCell.h
//  CYW
//
//  Created by jktz on 2018/5/22.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeNewStandTableViewCell : UITableViewCell
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) NSArray *dataArray;
- (void)reloadData;

+ (CGFloat)cellHeight:(NSArray *)dataArray;
@end

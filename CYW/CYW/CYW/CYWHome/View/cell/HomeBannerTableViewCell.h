//
//  HomeBannerTableViewCell.h
//  CYW
//
//  Created by jktz on 2018/5/22.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SDCycleScrollView/SDCycleScrollView.h>
//#import "LRSTextScrollView.h"
#import <JhtMarquee/JhtVerticalMarquee.h>
#import <JhtMarquee/JhtHorizontalMarquee.h>

@interface HomeBannerTableViewCell : UIView
@property (nonatomic, strong) SDCycleScrollView *scrollView;
@property (nonatomic, strong) JhtVerticalMarquee *lrScrollView;
@property (nonatomic, copy) NSArray *titleArray;
@property (nonatomic, copy) NSArray *urlArray;

//跑马灯
@property (nonatomic, copy) NSArray *arcArray;
@property (nonatomic, copy) NSArray *arcIdArray;

@end


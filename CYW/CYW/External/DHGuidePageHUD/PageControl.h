//
//  PageControl.h
//  CYW
//
//  Created by jktz on 2017/12/8.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageControl : UIView

@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger numberOfPages;
@property (nonatomic, retain) UIColor *pageIndicatorTintColor;
@property (nonatomic, retain) UIColor *currentPageIndicatorTintColor;
@end

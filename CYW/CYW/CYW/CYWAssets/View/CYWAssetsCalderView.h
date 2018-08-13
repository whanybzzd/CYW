//
//  CYWAssetsCalderView.h
//  CYW
//
//  Created by jktz on 2017/11/21.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CYWAssetsCalderView;

//#define UpdateCellSelectStatusNotification @"UpdateCellSelectStatusNotification"

@protocol CYWAssetsCalderViewDelegate <NSObject>

@optional
- (void)calendarCollectionViewDidSelectDate:(NSDate *)selectDate price:(NSString *)price curView:(CYWAssetsCalderView *)curView;

@end
@interface CYWAssetsCalderView : UIView
@property (strong, nonatomic)NSDate *curDate;
@property (strong, nonatomic)NSArray *priceDateArr;
@property (strong, nonatomic)NSArray *priceArr;

@property (strong, nonatomic)NSDate *sendSelectDate;//传过来需要选中的日期

@property (assign, nonatomic) BOOL   ischangeMonth;//选中了不同月份下的日期，需要将其他月份的日期取消选中

@property (assign, nonatomic)id<CYWAssetsCalderViewDelegate> delegate;



@end

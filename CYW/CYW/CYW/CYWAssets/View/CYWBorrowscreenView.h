//
//  CYWBorrowscreenView.h
//  CYW
//
//  Created by jktz on 2017/11/28.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^sheetAction)(id object);
@interface CYWBorrowscreenView : UIView

/**
 显示底部图层
 
 @param typeArray 类型的数组
 @param timeArray 时间数据
 @param bock 结果回调
 @return nil
 */
+ (instancetype)sharedInstanceViewBlock:(sheetAction)bock;


/**
 显示
 */
- (void)show;


/**
 隐藏
 */
- (void)hide;
@end

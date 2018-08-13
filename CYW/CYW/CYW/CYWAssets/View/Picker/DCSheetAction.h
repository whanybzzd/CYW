//
//  DCSheetAction.h
//  长运网
//
//  Created by jktz on 2017/9/15.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^sheetAction)(id object);
@interface DCSheetAction : UIView


/**
 显示底部图层

 @param typeArray 类型的数组
 @param timeArray 时间数据
 @param bock 结果回调
 @return nil
 */
+ (instancetype)sharedInstanceTypeArray:(NSArray *)typeArray
                          withTimeArray:(NSArray *)timeArray
                              withBlock:(sheetAction)bock;


/**
 显示
 */
- (void)show;


/**
 隐藏
 */
- (void)hide;
@end

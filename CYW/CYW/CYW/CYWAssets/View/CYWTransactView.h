//
//  CYWTransactView.h
//  CYW
//
//  Created by jktz on 2017/12/12.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^CYWTransactViewBlock)(id object);
@interface CYWTransactView : UIView

/**
 显示底部图层
 
 @param bock 结果回调
 @return nil
 */
+ (instancetype)sharedInstanceWithBlock:(CYWTransactViewBlock)bock;


/**
 显示
 */
- (void)show;


/**
 隐藏
 */
- (void)hide;

@end

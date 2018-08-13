//
//  DCVersionView.h
//  长运网
//
//  Created by jktz on 2017/9/11.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol DCVersionViewDelegate;
@interface DCVersionView : UIView
@property (nonatomic, assign) id<DCVersionViewDelegate>delegate;
+ (instancetype)showVersionView:(NSArray *)typeArray;
- (void)show;
@end

@protocol DCVersionViewDelegate <NSObject>


/**
 筛选条件

 @param codition 条件封装
 */
- (void)selectScreenCondition:(id)codition;
@end

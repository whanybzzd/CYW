//
//  DCDataPickerView.h
//  BRPickerViewDemo
//
//  Created by ZMJ on 2017/9/11.
//  Copyright © 2017年 renb. All rights reserved.
//

#import <BRPickerView/BRPickerView.h>
typedef void(^BRDateResultBlock)(NSString *selectValue);
@interface DCDataPickerView : UIView



+ (void)showDatePickerWithTitle:(NSString *)title resultBlock:(BRDateResultBlock)resultBlock;



+ (instancetype)showDatePickeresultBlock:(BRDateResultBlock)resultBlock;
@end

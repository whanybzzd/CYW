//
//  DCDateDayPickerView.h
//  长运网
//
//  Created by jktz on 2017/9/20.
//  Copyright © 2017年 J. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BRDateResultBlocks)(NSString *start,NSString *end);
@interface DCDateDayPickerView : UIView
+ (instancetype)showDatePickeresultBlock:(BRDateResultBlocks)resultBlock;
@end

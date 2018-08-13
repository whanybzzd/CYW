//
//  BankCardView.h
//  CYW
//
//  Created by jktz on 2017/10/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^BankCardViewResultBlock)(NSString *selectValue,NSString *carid);
@interface BankCardView : UIView

+ (instancetype)bankCarView:(BankCardViewResultBlock) resultBlock;
- (void)show;

- (void)hide;
@end

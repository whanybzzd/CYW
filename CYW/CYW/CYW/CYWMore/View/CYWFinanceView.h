//
//  CYWFinanceView.h
//  CYW
//
//  Created by jktz on 2017/11/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FinanceViewBlock)(NSInteger index);
@interface CYWFinanceView : UIView
@property (nonatomic, retain) BankViewModel *model;
@property (nonatomic, copy) FinanceViewBlock block;

- (instancetype) initWithFrame:(CGRect)frame withBlock:(FinanceViewBlock)block;
- (void) initSubView:(BankViewModel *)model;
@end

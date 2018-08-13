//
//  CYWAlertView.h
//  CYW
//
//  Created by jktz on 2017/10/27.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^transSuccess)();
typedef void (^transFailer)();

@interface CYWAlertView : UIView
@property (nonatomic, copy) transSuccess success;
@property (nonatomic, copy) transFailer failer;

- (id)initWithAlertView:(CreditorViewModel *)model action:(NSString *)action transSuccess:(transSuccess) success transFailer:(transFailer) failer withCount:(NSInteger)count reBool:(BOOL)bo;
- (void)show;
@end

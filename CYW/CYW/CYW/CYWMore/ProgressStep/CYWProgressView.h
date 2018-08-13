//
//  CYWProgressView.h
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CYWProgressView : UIView
@property (nonatomic, assign)NSInteger stepIndex;
- (void)setStepIndex:(NSInteger)stepIndex Animation:(BOOL)animation;
@end

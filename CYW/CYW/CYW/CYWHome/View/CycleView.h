//
//  CycleView.h
//  CYW
//
//  Created by jktz on 2017/10/11.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleView : UIView
@property(nonatomic,strong)CAShapeLayer * progressLayer;
@property(nonatomic,assign)float progress;
@property (nonatomic, retain) UIColor *progressColor;

@property(nonatomic,retain) UIButton *button;
@end

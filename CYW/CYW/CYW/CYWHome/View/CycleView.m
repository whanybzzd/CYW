//
//  CycleView.m
//  CYW
//
//  Created by jktz on 2017/10/11.
//  Copyright © 2017年 jktz. All rights reserved.
//
#define PROGRESS_LINE_WIDTH 1 //弧线的宽度
#import "CycleView.h"

@implementation CycleView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self=[super initWithFrame:frame])
    {
        
        self.button=[[UIButton alloc] initWithFrame:CGRectMake(5, 5, 40, 40)];
        self.button.layer.cornerRadius=20;
        self.button.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
        [self.button setTitle:@"投标" forState:UIControlStateNormal];
        self.button.titleLabel.font=[UIFont systemFontOfSize:14];
        [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.button];
        
        CGPoint arcCenter = CGPointMake(25, 25);
        CGFloat radius = 25;
        //圆形路径
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:arcCenter
                                                            radius:radius
                                                        startAngle:-M_PI_2
                                                          endAngle:M_PI*2+-M_PI_2
                                                         clockwise:YES];
        
        //CAShapeLayer
        CAShapeLayer *shapLayer = [CAShapeLayer layer];
        shapLayer.path = path.CGPath;
        shapLayer.fillColor = [UIColor clearColor].CGColor;//图形填充色/
        shapLayer.strokeColor =  [UIColor clearColor].CGColor;//边线颜色
        shapLayer.lineWidth = PROGRESS_LINE_WIDTH;
        [self.layer addSublayer:shapLayer];
        //进度layer
        _progressLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_progressLayer];
        _progressLayer.path = path.CGPath;
        //_progressLayer.strokeColor = [UIColor redColor].CGColor;
        _progressLayer.fillColor = [[UIColor clearColor] CGColor];
        _progressLayer.lineWidth = PROGRESS_LINE_WIDTH;
        _progressLayer.strokeEnd = 0.f;
        //grain.mask = _progressLayer;//设置遮盖层
        
    }
    return self;
}

-(void)setProgress:(float)progress
{
    [self startAninationWithPro:progress];
    //    _progressLab.text = [NSString stringWithFormat:@"进度：%.2f",progress];
}
- (void)setProgressColor:(UIColor *)progressColor{
    
    _progressLayer.strokeColor = progressColor.CGColor;
}
-(void)startAninationWithPro:(CGFloat)pro
{
    //增加动画
    CABasicAnimation *pathAnimation=[CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 3;
    pathAnimation.timingFunction=[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pathAnimation.fromValue=[NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue=[NSNumber numberWithFloat:pro];
    pathAnimation.autoreverses=NO;
    
    pathAnimation.fillMode = kCAFillModeForwards;
    pathAnimation.removedOnCompletion = NO;
    pathAnimation.repeatCount = 1;
    [_progressLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
}

@end

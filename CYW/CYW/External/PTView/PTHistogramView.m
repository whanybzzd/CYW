//
//  PTHistogramView.m
//  PTHistogramView
//
//  Created by 天蓝 on 2017/8/8.
//  Copyright © 2017年 PT. All rights reserved.
//

#import "PTHistogramView.h"
#import "UICountingLabel.h"
#import "UIView+Extend.h"

@interface PTHistogramView ()
@property (nonatomic, strong) NSArray *nameArray;
@property (nonatomic, strong) NSArray *countArray;

// 柱状图间隙
@property (nonatomic, assign) CGFloat itemSpace;
// 柱状图宽
@property (nonatomic, assign) CGFloat itemW;
// 柱状图高
@property (nonatomic, assign) CGFloat itemH;
// 左侧宽度
@property (nonatomic, assign) CGFloat leftSpace;
// 上侧间隙
@property (nonatomic, assign) CGFloat topSpace;
// 下侧高度
@property (nonatomic, assign) CGFloat bottomSpace;
// 纵向分的阶段
@property (nonatomic, assign) CGFloat stageCount;
// 阶段的间隔数量
@property (nonatomic, assign) CGFloat stageSpaceCount;
// 纵向的最大值
@property (nonatomic, assign) CGFloat maxYCount;
@end


@implementation PTHistogramView

- (instancetype)initWithFrame:(CGRect)frame
                    nameArray:(NSArray <NSString *>*)nameArray
                   countArray:(NSArray <NSString *>*)countArray
{
    self = [super initWithFrame:frame];
    if (self) {
        
        if (nameArray.count && nameArray.count == countArray.count)
        {
            self.nameArray = nameArray;
            self.countArray = countArray;
            self.backgroundColor=[UIColor whiteColor];
            self.leftSpace = 30;
            self.topSpace = 30;
            self.bottomSpace = 30;
            self.itemW = 14;
            self.itemH = self.height - self.bottomSpace - self.topSpace;
            self.itemSpace = (self.width - 2 * self.leftSpace)/self.nameArray.count - self.itemW;
            
            
            // 取数组中最大的值
            NSInteger max_number = [[countArray valueForKeyPath:@"@max.intValue"] integerValue];
            
            self.stageCount = 3.0;
            self.stageSpaceCount = max_number == 0 ? 1 : ceilf(max_number/self.stageCount);
            self.maxYCount = self.stageCount * self.stageSpaceCount;
            
            [self createBaseView];
            
            
            UILabel *label=[UILabel new];
            label.text=@"积分说明(单位:万)";
            label.textColor=[UIColor colorWithHexString:@"#333333"];
            label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
            [self addSubview:label];
            label.sd_layout
            .centerXEqualToView(self)
            .heightIs(14)
            .topSpaceToView(self, CGFloatIn320(37));
            [label setSingleLineAutoResizeWithMaxWidth:300];
        }
    }
    return self;
}

- (void)createBaseView
{
    //[self createGrayLineWihtFrame:CGRectMake(self.leftSpace, 0, 1, self.height - self.bottomSpace)];
    //[self createGrayLineWihtFrame:CGRectMake(self.leftSpace, self.height - self.bottomSpace, self.width - self.leftSpace, 1)];
    
    
    for (int i = 0; i < self.nameArray.count; i++)
    {
        UILabel *label = [self createLabelWithFrame:CGRectMake(0, 0, 40, self.bottomSpace) text:self.nameArray[i]];
        label.center = CGPointMake( (i+1) * (self.itemSpace + self.itemW) - self.itemW/2.0+(i+1)*5, self.height - self.bottomSpace/2.0);
        [self addSubview:label];
    }
    
    
    //左边刻度
    for (int i = 0; i <= self.stageCount; i++)
    {
        UILabel *label = [self createLabelWithFrame:CGRectMake(0, 0, self.leftSpace, 10) text:[NSString stringWithFormat:@"%.f",(self.stageCount - i)*self.stageSpaceCount]];
        label.center = CGPointMake(self.leftSpace/2.0, self.topSpace + i * (self.itemH/self.stageCount));
        //[self addSubview:label];
    }
}

- (UILabel *)createLabelWithFrame:(CGRect)frame text:(NSString *)text
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.font = [UIFont systemFontOfSize:10];
    label.textColor = [UIColor colorWithHexString:@"#333333"];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)createGrayLineWihtFrame:(CGRect)frame
{
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    layer.backgroundColor = [UIColor colorWithRed:0.80f green:0.80f blue:0.80f alpha:1.00f].CGColor;
    [self.layer addSublayer:layer];
}

- (void)drawRect:(CGRect)rect
{   
    for (int i = 0; i < self.countArray.count; i++)
    {
        CAShapeLayer *layer = [CAShapeLayer layer];
        layer.strokeColor = [UIColor colorWithHexString:@"#aeaec3"].CGColor;
        layer.lineWidth = self.itemW;
        
        // 贝塞尔二次曲线
        CGFloat centerX =  (i+1) * (self.itemSpace + self.itemW) - self.itemW/2.0+(i+1)*5;
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(centerX, self.height - self.bottomSpace)];
        [path addLineToPoint:CGPointMake(centerX, self.topSpace)];
        layer.path = path.CGPath;
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
        animation.duration = 1;
        animation.repeatCount = 1;
        animation.fromValue = @(0);
        animation.toValue = @([self.countArray[i] floatValue]/self.maxYCount);
        animation.removedOnCompletion = NO;
        animation.fillMode = kCAFillModeForwards;
        [layer addAnimation:animation forKey:nil];
        
        [self.layer addSublayer:layer];
        
        
        UICountingLabel *label = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, 0, 30, 16)];
        label.font = [UIFont systemFontOfSize:10];
        label.textColor = [UIColor colorWithHexString:@"#f53756"];
        label.textAlignment = NSTextAlignmentCenter;
        label.center = CGPointMake(centerX, self.height - self.bottomSpace - label.height/2.0);
        
        label.format = @"%zd";
        label.method = UILabelCountingMethodLinear;
        [label countFromZeroTo:[self.countArray[i] integerValue] withDuration:animation.duration];
        [self addSubview:label];
        
        
        [UIView animateWithDuration:animation.duration
                              delay:0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             label.centerY = self.topSpace + self.itemH * (1-[animation.toValue floatValue]) - label.height/2.0;
                         } completion:nil];
    }
}

@end

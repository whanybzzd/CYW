//
//  CYWProgressView.m
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWProgressView.h"
#import "CricleView.h"
#import "CricleSelectView.h"
@interface CYWProgressView()
@property (nonatomic, strong)UIView *lineUndo;
@property (nonatomic, strong)UIView *lineDone;
@property (nonatomic, retain)NSMutableArray *cricleMarks;
@property (nonatomic, strong)CricleSelectView *lblIndicator;
@end
@implementation CYWProgressView


- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        _stepIndex = 0;
        ParentModel *mo=(ParentModel *)[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserModel];
        if ([NSString isNotEmpty:mo.userLevel]) {
            
            _stepIndex=[[mo.userLevel substringFromIndex:mo.userLevel.length-1] integerValue];
        }else{
            
            _stepIndex=0;
        }
        
        _lineUndo = [[UIView alloc]init];
        _lineUndo.backgroundColor = [UIColor lightGrayColor];
        [self addSubview:_lineUndo];
        
        _lineDone = [[UIView alloc]init];
        _lineDone.backgroundColor = [UIColor whiteColor];
        [self addSubview:_lineDone];
        
        for (int i=0; i<9; i++) {
            
            CricleView *cricle = [[CricleView alloc]initWithFrame:CGRectMake(0, 0, 23, 23)];
            cricle.backgroundColor = [UIColor lightGrayColor];
            cricle.layer.cornerRadius = 23.f / 2;
            [self addSubview:cricle];
            [self.cricleMarks addObject:cricle];
        }
        
        _lblIndicator = [[CricleSelectView alloc]initWithFrame:CGRectMake(0, 0, 40, 47)];
        //_lblIndicator.textAlignment = NSTextAlignmentCenter;
        //_lblIndicator.textColor = [UIColor orangeColor];
        //_lblIndicator.backgroundColor = [UIColor blueColor];
        //_lblIndicator.layer.cornerRadius = 23.f / 2;
        //_lblIndicator.layer.borderColor = [[UIColor orangeColor] CGColor];
        //_lblIndicator.layer.borderWidth = 1;
        //_lblIndicator.layer.masksToBounds = YES;
        [self addSubview:_lblIndicator];
        
        
    }
    
    
    return self;
}


#pragma mark - method

- (void)layoutSubviews
{
    
    NSInteger perWidth = self.frame.size.width / 9;
    
    _lineUndo.frame = CGRectMake(0, 0, self.frame.size.width - perWidth, 3);
    _lineUndo.center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 4);
    CGFloat startX = _lineUndo.frame.origin.x;
    for (int i = 0; i < 9; i++)
    {
        CricleView *cricle = [_cricleMarks objectAtIndex:i];
        if (cricle != nil)
        {
            cricle.center = CGPointMake(i * perWidth + startX, _lineUndo.center.y);
        }
        
    }
    
    self.stepIndex = _stepIndex;
}


#pragma mark - public method

- (void)setStepIndex:(NSInteger)stepIndex
{
    if (stepIndex >= 0 && stepIndex < 9)
    {
        _stepIndex = stepIndex;
        
        CGFloat perWidth = self.frame.size.width / 9;
        
        //_lblIndicator.text = [NSString stringWithFormat:@"%d", _stepIndex + 1];
        _lblIndicator.center = ((CricleView *)[_cricleMarks objectAtIndex:_stepIndex]).center;
        
        _lineDone.frame = CGRectMake(_lineUndo.frame.origin.x, _lineUndo.frame.origin.y, perWidth * _stepIndex, _lineUndo.frame.size.height);
        
        for (int i = 0; i < 9; i++)
        {
            CricleView *cricle = [_cricleMarks objectAtIndex:i];
            if (cricle != nil)
            {
                if (i <= _stepIndex)
                {
                    cricle.imageView2.backgroundColor=[UIColor whiteColor];
                    cricle.centerImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"V%zd-副本.",i]];
                }
                else
                {
                    cricle.imageView2.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
                    cricle.centerImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"V%zd-副本-.",i]];
                }
            }
            
        }
    }
}

- (void)setStepIndex:(NSInteger)stepIndex Animation:(BOOL)animation
{
    if (stepIndex >= 0 && stepIndex < 9)
    {
        if (animation)
        {
            [UIView animateWithDuration:0.5 animations:^{
                self.stepIndex = stepIndex;
            }];
        }
        else
        {
            self.stepIndex = stepIndex;
        }
    }
}


- (NSMutableArray *)cricleMarks{
    
    if (!_cricleMarks) {
        
        _cricleMarks=[NSMutableArray array];
    }
    return _cricleMarks;
}

@end

//
//  PageControl.m
//  CYW
//
//  Created by jktz on 2017/12/8.
//  Copyright © 2017年 jktz. All rights reserved.
//
#define PageControlWidth 25
#define PageControlMargin 5
#define PageControlHeight 2
#import "PageControl.h"
@interface PageControl(){
    UIColor *currentColor;
}
@property (nonatomic, retain) NSMutableArray *lineViewArray;
@end
@implementation PageControl

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        
    }
    return self;
}


- (void)setNumberOfPages:(NSInteger)numberOfPages{
    
    CGFloat itemX=self.frame.size.width/2-numberOfPages*5*2.8;
    for (int i=0; i<numberOfPages; i++) {
        
        UIView *lineView=[[UIView alloc] initWithFrame:CGRectMake(itemX+i*(PageControlWidth+PageControlMargin), 0, PageControlWidth, PageControlHeight)];
        //lineView.backgroundColor=[UIColor redColor];
        [self addSubview:lineView];
        [self.lineViewArray addObject:lineView];
    }
}

- (NSMutableArray *)lineViewArray{
    if (!_lineViewArray) {
        
        _lineViewArray=[NSMutableArray array];
    }
    return _lineViewArray;
}

- (void)setPageIndicatorTintColor:(UIColor *)pageIndicatorTintColor{
    
    currentColor=pageIndicatorTintColor;
    for (UIView *lineView in self.lineViewArray) {
        
        lineView.backgroundColor=pageIndicatorTintColor;
    }
}

- (void)setCurrentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor{
    
    for (UIView *lineView in self.lineViewArray) {
        
        lineView.backgroundColor=currentColor;
    }
    UIView *lineView=self.lineViewArray[self.currentPage];
    lineView.backgroundColor=currentPageIndicatorTintColor;
}
@end

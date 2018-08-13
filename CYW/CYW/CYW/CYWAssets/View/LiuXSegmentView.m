//
//  LiuXSegmentView.m
//  LiuXSegment
//
//  Created by 刘鑫 on 16/3/18.
//  Copyright © 2016年 liuxin. All rights reserved.
//

#define windowContentWidth  ([[UIScreen mainScreen] bounds].size.width)
#define SFQRedColor [UIColor colorWithRed:255/255.0 green:92/255.0 blue:79/255.0 alpha:1]
#define MAX_TitleNumInWindow 5

#import "LiuXSegmentView.h"

@interface LiuXSegmentView()

@property (nonatomic,strong) NSMutableArray *btns;
@property (nonatomic,strong) NSArray *titles;
@property (nonatomic,strong) UIButton *titleBtn;
@property (nonatomic,strong) UIScrollView *bgScrollView;
@property (nonatomic,strong) UIView *selectLine;
@property (nonatomic,assign) CGFloat btn_w;

@end

@implementation LiuXSegmentView

- (void)awakeFromNib{
    
    
}

-(instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titleArray clickBlick:(btnClickBlock)block{
    self = [super initWithFrame:frame];
    if (self) {
        
  
        
    }
    
    return self;
}


- (void)titles:(NSArray *)titleArray clickBlick:(btnClickBlock)block{
    
    NSLog(@"bbb:%lf",self.frame.size.width);
        _btn_w=self.frame.size.width/MAX_TitleNumInWindow;
    
    _titles=titleArray;
    _defaultIndex=1;
    _titleFont=[UIFont systemFontOfSize:15];
    _btns=[[NSMutableArray alloc] initWithCapacity:0];
    _titleNomalColor=[UIColor blackColor];
    _titleSelectColor=SFQRedColor;
    _bgScrollView=[[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _bgScrollView.backgroundColor=[UIColor whiteColor];
    _bgScrollView.showsHorizontalScrollIndicator=NO;
    _bgScrollView.contentSize=CGSizeMake(_btn_w*titleArray.count, self.frame.size.height);
    [self addSubview:_bgScrollView];
    
    
    _selectLine=[[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2, _btn_w, 2)];
    _selectLine.backgroundColor=_titleSelectColor;
    [_bgScrollView addSubview:_selectLine];
    
    for (int i=0; i<titleArray.count; i++) {
        UIButton *btn=[UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame=CGRectMake(_btn_w*i, 0, _btn_w, self.frame.size.height-2);
        btn.tag=i+1;
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:_titleNomalColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        [btn setBackgroundColor:[UIColor whiteColor]];
        btn.titleLabel.font=_titleFont;
        [_bgScrollView addSubview:btn];
        [_btns addObject:btn];
        if (i==0) {
            _titleBtn=btn;
            btn.selected=YES;
        }
        self.block=block;
        
    }
}

- (void)scrollView:(NSInteger)index{
    NSLog(@"index:%zd",index);
    if(index>0){
    UIButton *btn=self.btns[index-1];
    _titleBtn.selected=!_titleBtn.selected;
    _titleBtn=btn;
    _titleBtn.selected=YES;
    CGFloat offsetX=btn.frame.origin.x - 2*_btn_w;
    if (offsetX<0) {
        offsetX=0;
    }
    CGFloat maxOffsetX= _bgScrollView.contentSize.width-self.frame.size.width;
    if (offsetX>maxOffsetX) {
        offsetX=maxOffsetX;
    }
    [UIView animateWithDuration:.2 animations:^{
        
        [_bgScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        _selectLine.frame=CGRectMake(btn.frame.origin.x, self.frame.size.height-2, btn.frame.size.width, 2);
        
    } completion:^(BOOL finished) {
        
    }];
        
    }
    //[self btnClick:btn];
}
-(void)btnClick:(UIButton *)btn{
    
    if (self.block) {
        self.block(btn.tag);
    }
    
   
        _titleBtn.selected=!_titleBtn.selected;
        _titleBtn=btn;
        _titleBtn.selected=YES;
    
    
    //计算偏移量
    CGFloat offsetX=btn.frame.origin.x - 2*_btn_w;
    if (offsetX<0) {
        offsetX=0;
    }
    CGFloat maxOffsetX= _bgScrollView.contentSize.width-self.frame.size.width;
    if (offsetX>maxOffsetX) {
        offsetX=maxOffsetX;
    }
    
    [UIView animateWithDuration:.2 animations:^{
        
        [_bgScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        _selectLine.frame=CGRectMake(btn.frame.origin.x, self.frame.size.height-2, btn.frame.size.width, 2);
        
    } completion:^(BOOL finished) {

    }];
    
}



//-(void)setTitleNomalColor:(UIColor *)titleNomalColor{
//    _titleNomalColor=titleNomalColor;
//    [self updateView];
//}
//
//-(void)setTitleSelectColor:(UIColor *)titleSelectColor{
//    _titleSelectColor=titleSelectColor;
//    [self updateView];
//}
//
//-(void)setTitleFont:(UIFont *)titleFont{
//    _titleFont=titleFont;
//    [self updateView];
//}

-(void)setDefaultIndex:(NSInteger)defaultIndex{
   // _defaultIndex=defaultIndex;
    UIButton *btn=self.btns[defaultIndex-1];
    
    
    
    //计算偏移量
    CGFloat offsetX=btn.frame.origin.x - 2*_btn_w;
    if (offsetX<0) {
        offsetX=0;
    }
    CGFloat maxOffsetX= _bgScrollView.contentSize.width-self.frame.size.width;
    if (offsetX>maxOffsetX) {
        offsetX=maxOffsetX;
    }
    
    //[UIView animateWithDuration:.2 animations:^{
        
        [_bgScrollView setContentOffset:CGPointMake(offsetX, 0) animated:YES];
        _selectLine.frame=CGRectMake(btn.frame.origin.x, self.frame.size.height-2, btn.frame.size.width, 2);
        
//    } completion:^(BOOL finished) {
//
//    }];
    
    
    [self updateView];
}

-(void)updateView{
//    for (UIButton *btn in _btns) {
//        [btn setTitleColor:_titleNomalColor forState:UIControlStateNormal];
//        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
//        btn.titleLabel.font=_titleFont;
//        _selectLine.backgroundColor=_titleSelectColor;
//
//        if (btn.tag-1==_defaultIndex-1) {
//            _titleBtn=btn;
//            btn.selected=YES;
//        }else{
//            btn.selected=NO;
//        }
//    }
}




@end

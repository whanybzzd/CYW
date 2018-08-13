//
//  CYWAssetsCalendarView.m
//  CYW
//
//  Created by jktz on 2017/11/21.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsCalendarView.h"
#import "LiuXSegmentView.h"
#import "CYWAssetsCalderView.h"
@interface CYWAssetsCalendarView()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet LiuXSegmentView *segmentController;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIScrollView *calendarScrollView;
@property (nonatomic, retain) CYWAssetsCalderView *calderView;
@property (nonatomic, retain) NSMutableArray *yearsArray;
@property (nonatomic, retain) NSMutableArray *mutable;
@property (nonatomic, retain) NSMutableArray *dateArray;
@end
@implementation CYWAssetsCalendarView

- (void)awakeFromNib{
    [super awakeFromNib];
    WeakSelfType blockSelf=self;
    [self.button setBackgroundColor:[UIColor whiteColor]];
    self.backgroundColor=[UIColor whiteColor];
    [self.button setTitleColor:[UIColor colorWithHexString:@"#eb4064"] forState:UIControlStateNormal];
    [self.segmentController titles:[self monthArray] clickBlick:^(NSInteger index) {
        
        //[blockSelf.calendarScrollView setContentOffset: CGPointMake(index*SCREEN_WIDTH, 0) animated:YES];
        blockSelf.calderView.curDate = self.dateArray[index-1];
        [blockSelf calanerIndex:index];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"noti" object:nil];
    }];
    self.segmentController.defaultIndex=[self currentMonthIndex]+1;
    [self calanerIndex:[self currentMonthIndex]+1];
    
    
    self.calendarScrollView.delegate = self;
   // self.calendarScrollView.contentSize = CGSizeMake(SCREEN_WIDTH*1, 0);//self.mutable.count
    self.calendarScrollView.contentOffset = CGPointZero;
    self.calendarScrollView.pagingEnabled = YES;
    self.calendarScrollView.showsHorizontalScrollIndicator = NO;
    //[self.calendarScrollView setContentOffset: CGPointMake(([self currentMonthIndex]+1)*SCREEN_WIDTH, 0) animated:YES];
    
    //[self.calendarScrollView setContentOffset: CGPointMake(SCREEN_WIDTH, 0) animated:YES];
    
    
    //for (int i=1; i<=self.dateArray.count; i++) {
        self.calderView = [[[NSBundle mainBundle] loadNibNamed:@"CYWAssetsCalderView" owner:nil options:nil] firstObject];
        self.calderView.frame = CGRectMake(0*SCREEN_WIDTH, 0, SCREEN_WIDTH, 400);
        self.calderView.curDate = self.dateArray[[self currentMonthIndex]];
        [self.calendarScrollView addSubview:self.calderView];
        
    //}
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger index = self.calendarScrollView.contentOffset.x/SCREEN_WIDTH;
    [self.segmentController scrollView:index];
    [self calanerIndex:index];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        
    }
    return self;
}


- (void)calanerIndex:(NSInteger)index{
    
    NSString *str=self.mutable[index-1];
    NSString *b=[[str componentsSeparatedByString:@"-"]firstObject];
    NSString *year=[NSString stringWithFormat:@"%@年",b];
    [self.button setTitle:year forState:UIControlStateNormal];
    [self.button.titleLabel setAttributedText:[NSMutableAttributedString withTitleString:year RangeString:@"年" ormoreString:nil color:[UIColor colorWithHexString:@"#333333"]]];
   
}
- (NSUInteger)currentMonthIndex{
    
    __block NSUInteger index;
    NSString *str=[NSString stringWithFormat:@"%zd-%zd",[self currentyear],[self currentmonth]];
    [self.mutable enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isEqualToString:str]) {
            
            index=idx;
        }
    }];
    return index;
}


- (NSMutableArray *)monthArray{
    
    self.yearsArray=[NSMutableArray array];
    
    //获取当前年份的前一年
    [self.yearsArray addObject:[NSString stringWithFormat:@"%zd",[self currentyear]-1]];
    [self.yearsArray addObject:[NSString stringWithFormat:@"%zd",[self currentyear]]];
    [self.yearsArray addObject:[NSString stringWithFormat:@"%zd",[self currentyear]+1]];
    
    
    self.mutable=[NSMutableArray array];
    for (int j=0; j<self.yearsArray.count; j++) {
        
        for (int i=1; i<=12; i++) {
            
            [self.mutable addObject:[NSString stringWithFormat:@"%@-%zd",self.yearsArray[j],i]];
        }
    }
    
    self.dateArray=[NSMutableArray array];
    for (int j=0; j<self.mutable.count; j++) {
        
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        
        format.dateFormat = @"yyyy-MM";
        
        NSDate *data = [format dateFromString:self.mutable[j]];
        [self.dateArray addObject:data];
    }
    
    NSMutableArray *monthArray=[NSMutableArray array];
    for (int k=0; k<self.mutable.count; k++) {
        
        NSString *str=[[self.mutable[k] componentsSeparatedByString:@"-"]lastObject];
        [monthArray addObject:[NSString stringWithFormat:@"%@月",str]];
    }
    
    return monthArray;
}



//获取当前年份
- (NSInteger)currentyear{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
                                         fromDate:[NSDate date]];
    NSInteger year = comp.year;
    return year;
}

//获取当前月份
- (NSInteger)currentmonth{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comp = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitDay
                                         fromDate:[NSDate date]];
    NSInteger month = comp.month;
    return month;
}
@end

//
//  DCDateDayPickerView.m
//  长运网
//
//  Created by jktz on 2017/9/20.
//  Copyright © 2017年 J. All rights reserved.
//


// Identifies for component views
#import "DCDateDayPickerView.h"
@interface DCDateDayPickerView ()<UIPickerViewDelegate, UIPickerViewDataSource>
{
    BRDateResultBlocks _resultBlock;
    
    NSInteger yearRange;
    NSInteger startYear;
    
    NSInteger selectedYear;
    NSInteger selectedMonth;
    NSInteger selectedDay;
    
    NSDate *_curDate;
    
    NSInteger currentYear;
    NSInteger currentMonth;
}
// 时间选择器(默认大小: 320px × 216px)
@property (nonatomic, strong) UIPickerView *datePicker;
@end
@implementation DCDateDayPickerView

+ (instancetype)showDatePickeresultBlock:(BRDateResultBlocks)resultBlock{
    
    return [[self alloc] initWithTitle:nil resultBlock:resultBlock];
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        [self initUI];
    }
    return self;
}
#pragma mark - 初始化时间选择器
- (instancetype)initWithTitle:(NSString *)title resultBlock:(BRDateResultBlocks)resultBlock {
    if (self = [super init]) {
        _resultBlock = resultBlock;
        
        
        [self initUI];
    }
    return self;
}


#pragma mark - 初始化子视图
- (void)initUI {
    // 添加时间选择器
    [self addSubview:self.datePicker];
}

- (UIPickerView *)datePicker{
    
    if (!_datePicker) {
        
        _datePicker = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 200)];
        _datePicker.backgroundColor = [UIColor whiteColor];
        _datePicker.delegate=self;
        _datePicker.dataSource=self;
        NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        comps = [calendar0 components:unitFlags fromDate:[NSDate date]];
        NSInteger year=[comps year];
        
        startYear=year-100;
        yearRange=120;
        selectedYear=2000;
        selectedMonth=1;
        selectedDay=1;
        
        [self bb:[NSDate date]];
    }
    return _datePicker;
}
- (NSDate *)curDate
{
    return _curDate;
}

//默认时间的处理
-(void)bb:(NSDate *)curDate
{
    
    
    //获取当前时间
    NSCalendar *calendar0 = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags =  NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    comps = [calendar0 components:unitFlags fromDate:curDate];
    NSInteger year=[comps year];
    NSInteger month=[comps month];
    NSInteger day=[comps month];
    
    currentYear = year;//当前年
    currentMonth = month;//当前月
    selectedYear=year; //选择年
    selectedMonth=month; //选择月
    selectedDay=day;
    
    [self.datePicker selectRow:year-startYear inComponent:0 animated:true];
    [self.datePicker selectRow:month-1 inComponent:1 animated:true];
    [self.datePicker selectRow:day-1 inComponent:2 animated:true];
    [self.datePicker reloadAllComponents];
}


-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    switch (component) {
        case 0:
        {
            return yearRange;
        }
            break;
        case 1:
        {
            return 12;
        }
            break;
        case 2:
        {
            return 12;
        }
            break;
            
        default:
            break;
    }
    return 0;
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
-(UIView*)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel*label=[[UILabel alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-30)*component/6.0, 0,(SCREEN_WIDTH-30)/6.0, 30)];
    
    label.font=[UIFont systemFontOfSize:20.0];
    label.tag=component*100+row;
    label.textAlignment=NSTextAlignmentCenter;
    switch (component) {
        case 0:
        {
            label.frame=CGRectMake(5, 0,(SCREEN_WIDTH-30)/4.0, 30);
            label.text=[NSString stringWithFormat:@"%ld年",(long)(startYear + row)];
            if (row > currentYear-startYear){//以后年
                label.textColor = [UIColor blackColor];
            }else {
                label.textColor = [UIColor blackColor];
            }
        }
            break;
        case 1:
        {
            label.frame=CGRectMake((SCREEN_WIDTH-30)/4.0, 0, (SCREEN_WIDTH-30)/8.0, 30);
            label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            if (selectedYear > currentYear) {//以后年
                label.textColor = [UIColor lightGrayColor];
            }else if (selectedYear == currentYear){// 现在年
                if (row > currentMonth-1) {//以后月
                    label.textColor = [UIColor blackColor];
                }else {
                    label.textColor = [UIColor blackColor];
                }
            }else {//以前年
                label.textColor = [UIColor blackColor];
            }
            
        }
            break;
        case 2:
        {
            label.frame=CGRectMake((SCREEN_WIDTH-30)/4.0, 0, (SCREEN_WIDTH-30)/8.0, 30);
            label.text=[NSString stringWithFormat:@"%ld月",(long)row+1];
            if (selectedYear > currentYear) {//以后年
                label.textColor = [UIColor lightGrayColor];
            }else if (selectedYear == currentYear){// 现在年
                if (row > currentMonth-1) {//以后月
                    label.textColor = [UIColor blackColor];
                }else {
                    label.textColor = [UIColor blackColor];
                }
            }else {//以前年
                label.textColor = [UIColor blackColor];
            }
            
        }
            break;
            
        default:
            break;
    }
    return label;
}
// 监听picker的滑动
- (void)pickerView:(UIPickerView *)pickerView
      didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
        {
            selectedYear=startYear + row;
            [self.datePicker reloadComponent:1];
            if (selectedYear >currentYear){//选择的是以后年份和当前年份时
                selectedYear = currentYear;
                selectedMonth = currentMonth;
                [self.datePicker selectRow:currentYear-startYear inComponent:0 animated:true];
                [self.datePicker selectRow:currentMonth-1 inComponent:1 animated:true];
            }
            [self.datePicker reloadComponent:1];
        }
            break;
        case 1:
        {
            selectedMonth=row+1;
            
            [self.datePicker reloadComponent:1];
            
        }
            break;
            
        case 2:
        {
            selectedDay=row+1;
            
            [self.datePicker reloadComponent:1];
            
            
            
        }
            break;
            
        default:
            break;
    }
    NSString*string =[NSString stringWithFormat:@"%ld-%.2ld",(long)selectedYear,(long)selectedMonth];
    
    NSString*string1 =[NSString stringWithFormat:@"%ld-%.2ld",(long)selectedYear,(long)selectedDay];
    
    if (_resultBlock) {
        _resultBlock(string,string1);
    }
    
}



@end

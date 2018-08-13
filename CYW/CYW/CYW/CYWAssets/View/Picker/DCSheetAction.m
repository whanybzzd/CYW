//
//  DCSheetAction.m
//  长运网
//
//  Created by jktz on 2017/9/15.
//  Copyright © 2017年 J. All rights reserved.
//

#import "DCSheetAction.h"
#import "DCDataPickerView.h"
#import "DCDatePickerView.h"
#import "DCDateDayPickerView.h"
@interface DCSheetAction()<UITextFieldDelegate>
@property (copy,nonatomic) sheetAction block;
@property (strong,nonatomic) UIView *tableView;
@property (strong,nonatomic) UIView *backgroundView;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UIView *lineView;

@property (nonatomic, retain) UIView *typeView;
@property (nonatomic, retain) UIView *timeView;

@property (nonatomic, retain) NSArray *typeArray;
@property (nonatomic, retain) NSArray *timeArray;

@property (nonatomic, retain) UIView *dayView;
@property (nonatomic, retain) UIButton *beginTimeTextField;
@property (nonatomic, retain) UIButton *endTimeTextField;


@property (nonatomic, retain) UIView *monthView;
@property (nonatomic, retain) UIButton *screenTextField;

@property (nonatomic, retain) UIView *doublemonthView;
@property (nonatomic, retain) UIButton *doubleTextField;
@property (nonatomic, retain) UIButton *doubleTextField1;
@property (nonatomic, retain) DCDataPickerView *dataPickerView;
@property (nonatomic, retain) DCDatePickerView *pickerView;
@property (nonatomic, retain) DCDateDayPickerView *dayPickerView;
@property (nonatomic, copy) NSString *selectValue;
@property (nonatomic, assign) NSInteger indexTag;

@property (nonatomic, assign) NSInteger screenIndex;//筛选的条件
@property (nonatomic, assign) NSInteger selectTag;

@property (nonatomic, retain) NSMutableArray *timeMutableArray;
@property (nonatomic, retain) NSMutableArray *typeMutableArray;

@end
@implementation DCSheetAction

+ (instancetype)sharedInstanceTypeArray:(NSArray *)typeArray withTimeArray:(NSArray *)timeArray withBlock:(sheetAction)block{
    
    return [[self alloc] initWithTypeArray:typeArray withTimeArray:timeArray withBlock:block];
}


- (instancetype)initWithTypeArray:(NSArray *)typeArray withTimeArray:(NSArray *)timeArray withBlock:(sheetAction)block{
    
    if (self=[super init]) {
        
        self.timeMutableArray=[NSMutableArray array];
        self.typeMutableArray=[NSMutableArray array];
        
        
        self.block=block;
        self.typeArray=[typeArray copy];
        self.timeArray=[timeArray copy];
        
        self.indexTag=11;//默认为开始时间
        self.selectTag=100;
        self.screenIndex=1000;
        
        [self installSubViews];
    }
    return self;
}




- (void)installSubViews {
    
    self.frame = [UIScreen mainScreen].bounds;
    
    // 初始化遮罩视图
    self.backgroundView = [[UIView alloc]initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.142 alpha:1.000];
    self.backgroundView.alpha = 0.4f;
    [self addSubview:_backgroundView];
    
    
    // 初始化TableView
    self.tableView = [[UIView alloc]initWithFrame:CGRectMake(0.0f,self.bounds.size.height, self.bounds.size.width, self.tableViewHeight)];
    self.tableView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_tableView];
    
    // 遮罩加上手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self.backgroundView addGestureRecognizer:tap];
    
    self.hidden = YES;
    self.tableView.hidden = YES;
    
    [self cancelButton];
    [self submitButton];
    [self lineView];
    [self typeView];
    [self timeView];
    
    //默认
    
    [self typeButtonClick:self.typeMutableArray[0]];
    [self.dataPickerView setHidden:YES];
    [self.pickerView setHidden:YES];
    [self.dayPickerView setHidden:YES];
    
    //取消按钮触发
    @weakify(self)
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
        [self hide];
        
    }];
    
    //提交按钮触发
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
        //1001  按照月来筛选  1000按照天来筛选
        
        //还款筛选条件
        if (100==[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectTag"] integerValue]) {
            
            
            
            if (self.screenIndex==1001) {
                
                //            if ([NSString isEmpty:self.screenTextField.text]) {
                //
                //                [UIView showResultThenHide:@"请选择月份日期"];
                //                return;
                //
                //            }
            }else if(self.screenIndex==1000){
                
                //            if ([NSString isEmpty:self.beginTimeTextField.text]) {
                //
                //                [UIView showResultThenHide:@"请选择开始日期"];
                //                return;
                //
                //            }
                //            if ([NSString isEmpty:self.endTimeTextField.text]) {
                //
                //                //[UIView showResultThenHide:@"请选择结束日期"];
                //                self.endTimeTextField.layer.borderWidth=0.5f;
                //                self.endTimeTextField.layer.borderColor=[UIColor colorWithHexString:@"#f52735"].CGColor;
                //                return;
                //
                //            }
                
            }else if(self.screenIndex==1002){
                
                //            if ([NSString isEmpty:self.doubleTextField.text]) {
                //
                //                [UIView showResultThenHide:@"请选择开始日期"];
                //                return;
                //
                //            }
                //            if ([NSString isEmpty:self.doubleTextField1.text]) {
                //
                //                //[UIView showResultThenHide:@"请选择结束日期"];
                //                self.doubleTextField1.layer.borderWidth=0.5f;
                //                self.doubleTextField1.layer.borderColor=[UIColor colorWithHexString:@"#f52735"].CGColor;
                //                return;
                //
                //            }
            }
        }
        NSDictionary *diction=[NSDictionary dictionary];
        NSString *st=nil;
        NSString *et=nil;
        
        if (1000==self.screenIndex) {//按照日查询
            st=self.beginTimeTextField.titleLabel.text;
            et=self.endTimeTextField.titleLabel.text;
        }else if (1001==self.screenIndex)//单月查询
        {
            st=self.screenTextField.titleLabel.text;
            et=@"";
        }else if (1002==self.screenIndex){//双月查询
            
            st=[NSString stringWithFormat:@"%@-01",self.doubleTextField.titleLabel.text];
            et=[NSString stringWithFormat:@"%@-%@",self.doubleTextField1.titleLabel.text,[self getMonthBeginAndEndWith:self.doubleTextField1.titleLabel.text]];
            
        }
        NSString *tag=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectTag"];
        
        NSInteger tags=[NSString isEmpty:tag]?100:[tag intValue];
        
        //NSLog(@"我曹:%zd===wocao:%zd===%@====:%@",tags,self.screenIndex,st,et);
        NSString *title=nil;
        if (tags==100) {
            
            title=@"还款中";
        }else if (tags==101){
            
            title=@"已结清";
        }else if (tags==102){
            
            title=@"投标中";
        }
        diction=@{@"startTime":st
                  ,@"endTime":et
                  ,@"tag":[NSString stringWithFormat:@"%zd",tags]
                  ,@"select":[NSString stringWithFormat:@"%zd",self.screenIndex],
                  @"title":title};
        NSLog(@"diction:%@",diction);
        if (self.block) {
            
            self.block(diction);
        }
        [self hide];
        
    }];
}

- (NSString *)getMonthBeginAndEndWith:(NSString *)dateStr{
    
    NSDateFormatter *format=[[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM"];
    NSDate *newDate=[format dateFromString:dateStr];
    double interval = 0;
    NSDate *beginDate = nil;
    NSDate *endDate = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    [calendar setFirstWeekday:2];//设定周一为周首日
    BOOL ok = [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&beginDate interval:&interval forDate:newDate];
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = [beginDate dateByAddingTimeInterval:interval-1];
    }else {
        return @"";
    }
    NSDateFormatter *myDateFormatter = [[NSDateFormatter alloc] init];
    [myDateFormatter setDateFormat:@"YYYY.MM.dd"];
    //NSString *beginString = [myDateFormatter stringFromDate:beginDate];
    NSString *endString = [myDateFormatter stringFromDate:endDate];
    NSString *s = [NSString stringWithFormat:@"%@",endString];
    NSArray *sCount=[s componentsSeparatedByString:@"."];
    return [sCount objectAtIndex:sCount.count-1];
}

-(CGFloat)tableViewHeight {
    
    return 425;
    
}


- (void)show{
    
    WeakSelfType blockSelf=self;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.hidden = NO;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = blockSelf.tableView.frame;
        CGSize screenSisze = [UIScreen mainScreen].bounds.size;
        frame.origin.y = screenSisze.height - self.tableViewHeight;
        
        blockSelf.tableView.frame = frame;
        
        blockSelf.tableView.hidden = NO;
        
    } completion:^(BOOL finished) {
        
        
        
    }];
}
- (void)hide{
    
    WeakSelfType blockSelf=self;
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = blockSelf.tableView.frame;
        CGSize screenSisze = [UIScreen mainScreen].bounds.size;
        frame.origin.y = screenSisze.height + self.tableViewHeight;
        
        blockSelf.tableView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        blockSelf.hidden = YES;
        blockSelf.tableView.hidden = YES;
        [blockSelf removeFromSuperview];
        
    }];
    
}


/**
 取消按钮
 
 @return nil
 */
- (UIButton *)cancelButton{
    
    if (!_cancelButton) {
        
        _cancelButton=[UIButton new];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _cancelButton.titleLabel.font=[UIFont systemFontOfSize:16];
        [_tableView addSubview:_cancelButton];
        _cancelButton.sd_layout
        .leftSpaceToView(_tableView, 20)
        .topSpaceToView(_tableView, 17)
        .widthIs(40)
        .heightIs(20);
    }
    return _cancelButton;
}


/**
 确定按钮
 
 @return nil
 */
- (UIButton *)submitButton{
    
    if (!_submitButton) {
        
        _submitButton=[UIButton new];
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor colorWithHexString:@"#ffa033"] forState:UIControlStateNormal];
        _submitButton.titleLabel.font=[UIFont systemFontOfSize:16];
        [_tableView addSubview:_submitButton];
        _submitButton.sd_layout
        .rightSpaceToView(_tableView, 20)
        .topSpaceToView(_tableView, 17)
        .widthIs(40)
        .heightIs(20);
    }
    return _submitButton;
}



/**
 取消下面的横线
 
 @return nil
 */
- (UIView *)lineView{
    
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"#f4f4f4"];
        [_tableView addSubview:_lineView];
        _lineView.sd_layout
        .leftSpaceToView(_tableView, 0)
        .rightSpaceToView(_tableView, 0)
        .heightIs(1)
        .topSpaceToView(_cancelButton, 14);
    }
    return _lineView;
    
}


/**
 类型View
 
 @return nil
 */
- (UIView *)typeView{
    
    if (!_typeView) {
        
        _typeView=[UIView new];
        _typeView.backgroundColor=[UIColor whiteColor];
        [_tableView addSubview:_typeView];
        _typeView.sd_layout
        .leftSpaceToView(_tableView, 0)
        .rightSpaceToView(_tableView, 0)
        .topSpaceToView(_lineView, 11)
        .heightIs(65);
        UILabel *label=[UILabel new];
        label.text=@"类型";
        label.font=[UIFont systemFontOfSize:15];
        [_typeView addSubview:label];
        label.sd_layout
        .leftSpaceToView(_typeView, 15)
        .heightIs(15)
        .topSpaceToView(_typeView, 0);
        [label setSingleLineAutoResizeWithMaxWidth:100];
        
        for (int i=0; i<self.typeArray.count; i++) {
            
            UIButton *button=[UIButton new];
            button.layer.borderWidth=1;
            button.layer.cornerRadius=5.0f;
            button.tag=5+i;
            
            //NSString *tag=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectTag"];
            NSString *color=i==0?@"#ffa033":@"#cccccc";
            
            button.layer.borderColor=[UIColor colorWithHexString:color].CGColor;
            [button setTitleColor:[UIColor colorWithHexString:color] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:self.typeArray[i] forState:UIControlStateNormal];
            [self.typeMutableArray addObject:button];
            [_typeView addSubview:button];
            button.sd_layout
            .widthIs(70)
            .heightIs(23)
            .topSpaceToView(label, 10)
            .leftSpaceToView(_typeView, 15+i*(70+15));
        }
        
    }
    return _typeView;
    
}


/**
 时间View
 
 @return nil
 */
- (UIView *)timeView{
    
    if (!_timeView) {
        
        _timeView=[UIView new];
        _timeView.backgroundColor=[UIColor whiteColor];
        [_tableView addSubview:_timeView];
        _timeView.sd_layout
        .leftSpaceToView(_tableView, 0)
        .rightSpaceToView(_tableView, 0)
        .topSpaceToView(_typeView, 0)
        .heightIs(65);
        UILabel *label=[UILabel new];
        label.text=@"时间";
        label.font=[UIFont systemFontOfSize:15];
        [_timeView addSubview:label];
        label.sd_layout
        .leftSpaceToView(_timeView, 15)
        .heightIs(15)
        .topSpaceToView(_timeView, 0);
        [label setSingleLineAutoResizeWithMaxWidth:100];
        for (int i=0; i<self.timeArray.count; i++) {
            
            UIButton *button=[UIButton new];
            button.layer.borderWidth=1;
            button.layer.cornerRadius=5.0f;
            button.tag=i;
            NSString *color=i==0?@"#ffa033":@"#cccccc";
            button.layer.borderColor=[UIColor colorWithHexString:color].CGColor;
            [button setTitleColor:[UIColor colorWithHexString:color] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont systemFontOfSize:15];
            [button addTarget:self action:@selector(timeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            [button setTitle:self.timeArray[i] forState:UIControlStateNormal];
            [self.timeMutableArray addObject:button];
            [_timeView addSubview:button];
            button.sd_layout
            .widthIs(83)
            .heightIs(23)
            .topSpaceToView(label, 10)
            .leftSpaceToView(_timeView, 15+i*(83+15));
        }
    }
    return _timeView;
}

//类型点击事件
- (void)typeButtonClick:(UIButton *)sender{
    
    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%zd",100+sender.tag-5] forKey:@"selectTag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self isTypeButton:sender];
    
    //当选择的是已结清和投标中的时候  需要隐藏
    if (sender.tag>5) {
        
        [self.screenTextField setTitle:@"" forState:UIControlStateNormal];
        [self.doubleTextField setTitle:@"" forState:UIControlStateNormal];
        [self.doubleTextField1 setTitle:@"" forState:UIControlStateNormal];
        
        [self.timeView setHidden:YES];
        
        
        [self.dataPickerView setHidden:YES];
        [self.pickerView setHidden:YES];
        [self.dayPickerView setHidden:YES];
        
        
        
        [self.monthView setHidden:YES];
        [self.dayView setHidden:YES];
        [self.doublemonthView setHidden:YES];
        
    }else{
        
        
        NSArray *array=[[self curent] componentsSeparatedByString:@"-"];
        NSString *bb=[NSString stringWithFormat:@"%@-%@",array[0],array[1]];
        [self.screenTextField setTitle:bb forState:UIControlStateNormal];
        [self.doubleTextField setTitle:bb forState:UIControlStateNormal];
        [self.doubleTextField1 setTitle:bb forState:UIControlStateNormal];
        
        [self.timeView setHidden:NO];
        
        
        [self.monthView setHidden:YES];
        [self.dayView setHidden:NO];
        [self.doublemonthView setHidden:YES];
        
        
        [self timeButtonClick:self.timeMutableArray[0]];
    }
    
}



//时间点击事件
- (void)timeButtonClick:(UIButton *)sender{
    
    [self isTypeButton:sender];
    //月 1001  日 1000  双月 1002
    //    BOOL bo=sender.tag==0?true:false;
    //    self.screenIndex=sender.tag==0?1000:1001;
    switch (sender.tag) {
        case 0:{
            
            self.screenIndex=1000;
            [self.monthView setHidden:YES];
            [self.dayView setHidden:NO];
            [self.doublemonthView setHidden:YES];
            
            [self.pickerView setHidden:YES];//日
            [self.dataPickerView setHidden:YES];//月
            [self.dayPickerView setHidden:YES];//双月
            
            
            self.beginTimeTextField.layer.borderWidth=0.5f;
            self.beginTimeTextField.layer.borderColor=[UIColor blackColor].CGColor;
            self.beginTimeTextField.titleLabel.text=[self curent];
            
            self.endTimeTextField.titleLabel.text=[self curent];
            
            self.endTimeTextField.layer.borderWidth=0.0f;
            self.endTimeTextField.layer.borderColor=[UIColor whiteColor].CGColor;
        }
            break;
            
        case 1:{
            
            self.screenIndex=1001;
            [self.monthView setHidden:NO];
            [self.dayView setHidden:YES];
            [self.doublemonthView setHidden:YES];
            
            [self.pickerView setHidden:YES];//日
            [self.dataPickerView setHidden:YES];//月
            [self.dayPickerView setHidden:YES];//双月
            
            
            
            self.screenTextField.layer.borderWidth=0.5f;
            self.screenTextField.layer.borderColor=[UIColor blackColor].CGColor;
            
            
            NSArray *array=[[self curent] componentsSeparatedByString:@"-"];
            self.screenTextField.titleLabel.text=[NSString stringWithFormat:@"%@-%@",array[0],array[1]];
        }
            break;
        case 2:{
            
            self.screenIndex=1002;
            [self.monthView setHidden:YES];
            [self.dayView setHidden:YES];
            [self.doublemonthView setHidden:NO];
            
            [self.pickerView setHidden:YES];//日
            [self.dataPickerView setHidden:YES];//月
            [self.dayPickerView setHidden:YES];//双月
            
            
            
            self.doubleTextField.layer.borderWidth=0.5f;
            self.doubleTextField.layer.borderColor=[UIColor blackColor].CGColor;
            
            
            NSArray *array=[[self curent] componentsSeparatedByString:@"-"];
            self.doubleTextField.titleLabel.text=[NSString stringWithFormat:@"%@-%@",array[0],array[1]];
            self.doubleTextField1.titleLabel.text=[NSString stringWithFormat:@"%@-%@",array[0],array[1]];
        }
            break;
        default:
            break;
    }
    
    
}


/**
 判断当前点击的按钮类型
 
 @param sender 按钮
 */
- (void)isTypeButton:(UIButton *)sender{
    
    UIView *view=sender.tag>=5?self.typeView:self.timeView;
    for (UIButton *button in view.subviews) {
        
        if ([button isKindOfClass:[UIButton class]]) {
            
            button.layer.borderColor=[UIColor colorWithHexString:@"#cccccc"].CGColor;
            [button setTitleColor:[UIColor colorWithHexString:@"#cccccc"] forState:UIControlStateNormal];
        }
    }
    sender.layer.borderColor=[UIColor colorWithHexString:@"#ffa033"].CGColor;
    [sender setTitleColor:[UIColor colorWithHexString:@"#ffa033"] forState:UIControlStateNormal];
}




/**
 按照日选择
 
 @return nil
 */
- (UIView *)dayView{
    
    if (!_dayView) {
        
        _dayView=[UIView new];
        _dayView.backgroundColor=[UIColor whiteColor];
        [_tableView addSubview:_dayView];
        _dayView.sd_layout
        .leftSpaceToView(_tableView, 0)
        .rightSpaceToView(_tableView, 0)
        .topSpaceToView(_timeView, 0)
        .heightIs(46);
        
        UILabel *label=[UILabel new];
        label.text=@"至";
        label.font=[UIFont systemFontOfSize:15];
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        [_dayView addSubview:label];
        label.sd_layout
        .centerXEqualToView(_dayView)
        .bottomSpaceToView(_dayView, 0)
        .heightIs(15);
        [label setSingleLineAutoResizeWithMaxWidth:50];
        
        UIView *lineView=[UIView new];
        lineView.backgroundColor=[UIColor colorWithHexString:@"#f4f4f4"];
        [_dayView addSubview:lineView];
        lineView.sd_layout
        .leftSpaceToView(_dayView, 15)
        .rightSpaceToView(label, 30)
        .heightIs(1)
        .bottomSpaceToView(_dayView, 0);
        
        UIView *lineView1=[UIView new];
        lineView1.backgroundColor=[UIColor colorWithHexString:@"#f4f4f4"];
        [_dayView addSubview:lineView1];
        lineView1.sd_layout
        .leftSpaceToView(label, 30)
        .rightSpaceToView(_dayView, 15)
        .heightIs(1)
        .bottomSpaceToView(_dayView, 0);
        
        self.beginTimeTextField=[UIButton new];
        self.beginTimeTextField.font=[UIFont systemFontOfSize:14];
        self.beginTimeTextField.tag=11;
        [self.beginTimeTextField setTitle:[self curent] forState:UIControlStateNormal];
        [self.beginTimeTextField setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.beginTimeTextField addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_dayView addSubview:self.beginTimeTextField];
        self.beginTimeTextField.sd_layout
        .leftSpaceToView(_dayView, 15)
        .heightIs(30)
        .rightSpaceToView(label, 30)
        .bottomSpaceToView(lineView, 0);
        
        
        self.endTimeTextField=[UIButton new];
        self.endTimeTextField.font=[UIFont systemFontOfSize:14];
        [self.endTimeTextField setTitle:[self curent] forState:UIControlStateNormal];
        [self.endTimeTextField setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.endTimeTextField addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.endTimeTextField.tag=12;
        [_dayView addSubview:self.endTimeTextField];
        self.endTimeTextField.sd_layout
        .leftSpaceToView(label, 30)
        .heightIs(30)
        .rightSpaceToView(_dayView, 15)
        .bottomSpaceToView(lineView1, 0);
    }
    return _dayView;
}

/**
 按照月选择
 
 @return nil
 */
- (UIView *)monthView{
    
    if (!_monthView) {
        
        _monthView=[UIView new];
        [_monthView setHidden:YES];
        _monthView.backgroundColor=[UIColor whiteColor];
        [_tableView addSubview:_monthView];
        _monthView.sd_layout
        .leftSpaceToView(_tableView, 0)
        .rightSpaceToView(_tableView, 0)
        .topSpaceToView(_timeView, 0)
        .heightIs(46);
        
        UIView *lineView=[UIView new];
        lineView.backgroundColor=[UIColor colorWithHexString:@"#f4f4f4"];
        [_monthView addSubview:lineView];
        lineView.sd_layout
        .leftSpaceToView(_monthView, 15)
        .rightSpaceToView(_monthView, 15)
        .heightIs(1)
        .bottomSpaceToView(_monthView, 0);
        
        
        NSArray *array=[[self curent] componentsSeparatedByString:@"-"];
        NSString *bb=[NSString stringWithFormat:@"%@-%@",array[0],array[1]];
        
        self.screenTextField=[UIButton new];
        self.screenTextField.font=[UIFont systemFontOfSize:14];
        [self.screenTextField setTitle:bb forState:UIControlStateNormal];
        [self.screenTextField setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.screenTextField addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.screenTextField.tag=13;
        [_monthView addSubview:self.screenTextField];
        self.screenTextField.sd_layout
        .leftSpaceToView(_monthView, 15)
        .heightIs(30)
        .rightSpaceToView(_monthView, 15)
        .bottomSpaceToView(lineView, 0);
    }
    return _monthView;
}


/**
 按照双月选择
 
 @return nil
 */
- (UIView *)doublemonthView{
    
    if (!_doublemonthView) {
        
        _doublemonthView=[UIView new];
        [_doublemonthView setHidden:YES];
        _doublemonthView.backgroundColor=[UIColor whiteColor];
        [_tableView addSubview:_doublemonthView];
        _doublemonthView.sd_layout
        .leftSpaceToView(_tableView, 0)
        .rightSpaceToView(_tableView, 0)
        .topSpaceToView(_timeView, 0)
        .heightIs(46);
        
        UILabel *label=[UILabel new];
        label.text=@"至";
        label.font=[UIFont systemFontOfSize:15];
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        [_doublemonthView addSubview:label];
        label.sd_layout
        .centerXEqualToView(_doublemonthView)
        .bottomSpaceToView(_doublemonthView, 0)
        .heightIs(15);
        [label setSingleLineAutoResizeWithMaxWidth:50];
        
        UIView *lineView=[UIView new];
        lineView.backgroundColor=[UIColor colorWithHexString:@"#f4f4f4"];
        [_doublemonthView addSubview:lineView];
        lineView.sd_layout
        .leftSpaceToView(_doublemonthView, 15)
        .rightSpaceToView(label, 30)
        .heightIs(1)
        .bottomSpaceToView(_doublemonthView, 0);
        
        UIView *lineView1=[UIView new];
        lineView1.backgroundColor=[UIColor colorWithHexString:@"#f4f4f4"];
        [_doublemonthView addSubview:lineView1];
        lineView1.sd_layout
        .leftSpaceToView(label, 30)
        .rightSpaceToView(_doublemonthView, 15)
        .heightIs(1)
        .bottomSpaceToView(_doublemonthView, 0);
        
        
        
        
        
        NSArray *array=[[self curent] componentsSeparatedByString:@"-"];
        NSString *bb=[NSString stringWithFormat:@"%@-%@",array[0],array[1]];
        
        self.doubleTextField=[UIButton new];
        self.doubleTextField.font=[UIFont systemFontOfSize:14];
        self.doubleTextField.tag=14;
        [self.doubleTextField setTitle:bb forState:UIControlStateNormal];
        [self.doubleTextField setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.doubleTextField addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_doublemonthView addSubview:self.doubleTextField];
        self.doubleTextField.sd_layout
        .leftSpaceToView(_doublemonthView, 15)
        .heightIs(30)
        .rightSpaceToView(label, 30)
        .bottomSpaceToView(lineView, 0);
        
        self.doubleTextField1=[UIButton new];
        self.doubleTextField1.font=[UIFont systemFontOfSize:14];
        [self.doubleTextField1 setTitle:bb forState:UIControlStateNormal];
        [self.doubleTextField1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.doubleTextField1 addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        self.doubleTextField1.tag=15;
        [_doublemonthView addSubview:self.doubleTextField1];
        self.doubleTextField1.sd_layout
        .leftSpaceToView(label, 30)
        .heightIs(30)
        .rightSpaceToView(_doublemonthView, 15)
        .bottomSpaceToView(lineView1, 0);
    }
    return _doublemonthView;
}

//双月查询
- (DCDateDayPickerView *)dayPickerView{
    
    if (!_dayPickerView) {
        
        WeakSelfType blockSelf=self;
        _dayPickerView=[DCDateDayPickerView showDatePickeresultBlock:^(NSString *start, NSString *end) {
            
            if (blockSelf.indexTag==14) {
                
                [blockSelf.doubleTextField setTitle:start forState:UIControlStateNormal];
            }else if(blockSelf.indexTag==15){
                
                [blockSelf.doubleTextField1 setTitle:end forState:UIControlStateNormal];
            }
            
            
        }];
        [_dayPickerView setHidden:YES];
        [_tableView addSubview:_dayPickerView];
        _dayPickerView.sd_layout
        .leftSpaceToView(_tableView, 15)
        .rightSpaceToView(_tableView, 15)
        .topSpaceToView(_doublemonthView, 15)
        .bottomSpaceToView(_tableView, 5);
    }
    return _dayPickerView;
}


/**
 月份的视图
 
 @return nil
 */
- (DCDataPickerView *)dataPickerView{
    
    if (!_dataPickerView) {
        
        WeakSelfType blockSelf=self;
        _dataPickerView=[DCDataPickerView showDatePickeresultBlock:^(NSString *selectValue) {
            
            [blockSelf.screenTextField setTitle:selectValue forState:UIControlStateNormal];
        }];
        [_dataPickerView setHidden:YES];
        [_tableView addSubview:_dataPickerView];
        _dataPickerView.sd_layout
        .leftSpaceToView(_tableView, 15)
        .rightSpaceToView(_tableView, 15)
        .topSpaceToView(_dayView, 15)
        .bottomSpaceToView(_tableView, 5);
    }
    return _dataPickerView;
}

/**
 日的视图
 
 @return nil
 */
- (DCDatePickerView *)pickerView{
    
    if (!_pickerView) {
        
        WeakSelfType blockSelf=self;//[NSDate currentDateString]
        _pickerView=[DCDatePickerView showDatePickerDateType:UIDatePickerModeDate defaultSelValue:@"" minDateStr:@"" maxDateStr:@"" isAutoSelect:YES resultBlock:^(NSString *selectValue) {
            
            blockSelf.selectValue=selectValue;
        }];
        [_tableView addSubview:_pickerView];
        _pickerView.sd_layout
        .leftSpaceToView(_tableView, 15)
        .rightSpaceToView(_tableView, 15)
        .topSpaceToView(_dayView, 15)
        .bottomSpaceToView(_tableView, 5);
        
    }
    return _pickerView;
}



- (void)setSelectValue:(NSString *)selectValue{
    
    if (self.indexTag==11) {
        
        [self.beginTimeTextField setTitle:selectValue forState:UIControlStateNormal];
        
    }else if(self.indexTag==12){
        
        [self.endTimeTextField setTitle:selectValue forState:UIControlStateNormal];
        
    }
    
    
}


- (NSString *)curent{
    
    NSDate *date =[NSDate date];//简书 FlyElephant
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    [formatter setDateFormat:@"dd"];
    NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
    
    NSString *str=[NSString stringWithFormat:@"%zd-%zd-%zd",currentYear,currentMonth,currentDay];
    return str;
}


- (void)buttonClick:(UIButton *)sender{
    self.indexTag=sender.tag;
    UIView *views=nil;
    if (sender.tag==11||sender.tag==12) {
        
        views=self.dayView;
    }
    else if (sender.tag==13){
        
        views=self.monthView;
    }
    else if (sender.tag==14||sender.tag==15){
        
        views=self.doublemonthView;
    }
    for (UIButton *view in views.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            view.layer.borderWidth=0.0f;
            view.layer.borderColor=[UIColor whiteColor].CGColor;
        }
    }
    sender.layer.borderWidth=0.5f;
    sender.layer.borderColor=[UIColor blackColor].CGColor;
    
    
    
    if (sender.tag==11||sender.tag==12) {
        
        [self.dayPickerView setHidden:YES];
        [self.pickerView setHidden:NO];
        [self.dataPickerView setHidden:YES];
    }
    else if (sender.tag==13){
        
        [self.dayPickerView setHidden:YES];
        [self.pickerView setHidden:YES];
        [self.dataPickerView setHidden:NO];
    }
    else if (sender.tag==14||sender.tag==15){
        
        [self.dayPickerView setHidden:NO];
        [self.pickerView setHidden:YES];
        [self.dataPickerView setHidden:YES];
    }
}
@end

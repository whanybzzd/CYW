//
//  CYWBorrowscreenView.m
//  CYW
//
//  Created by jktz on 2017/11/28.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWBorrowscreenView.h"
#import "DCDatePickerView.h"
@interface CYWBorrowscreenView()<UITextFieldDelegate>
@property (copy,nonatomic) sheetAction block;
@property (strong,nonatomic) UIView *tableView;
@property (strong,nonatomic) UIView *backgroundView;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) UIView *dayView;
@property (nonatomic, retain) UITextField *beginTimeTextField;
@property (nonatomic, retain) UITextField *endTimeTextField;
@property (nonatomic, retain) DCDatePickerView *pickerView;
@property (nonatomic, assign) NSInteger indexTag;
@end
@implementation CYWBorrowscreenView

+ (instancetype)sharedInstanceViewBlock:(sheetAction)bock{
    
    return [[self alloc] initWithBlock:bock];
}

- (instancetype)initWithBlock:(sheetAction)block{
    if (self=[super init]) {
        self.block =block;
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
    [self dayView];
    
    [self pickerView];
    //取消按钮触发
    @weakify(self)
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
        [self hide];
        
    }];
    
    //提交按钮触发
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
        
        NSDictionary *diction=[NSDictionary dictionary];
        NSString *start=[StringUtils trimString:self.beginTimeTextField.text];
        NSString *end=[StringUtils trimString:self.endTimeTextField.text];
        if ([ NSString isEmpty:start]) {
            
            self.endTimeTextField.layer.borderWidth=0.5f;
            self.endTimeTextField.layer.borderColor=[UIColor colorWithHexString:@"#f52735"].CGColor;
            return ;
        }
        if ([ NSString isEmpty:end]) {
            
            self.endTimeTextField.layer.borderWidth=0.5f;
            self.endTimeTextField.layer.borderColor=[UIColor colorWithHexString:@"#f52735"].CGColor;
            return ;
        }
        
        diction=@{@"startTime":start
                  ,@"endTime":end};
        if (self.block) {
            
            self.block(diction);
        }
        [self hide];
        
    }];
}
-(CGFloat)tableViewHeight {
    
    return 300;
    
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


- (UIView *)dayView{
    
    if (!_dayView) {
        
        _dayView=[UIView new];
        _dayView.backgroundColor=[UIColor whiteColor];
        [_tableView addSubview:_dayView];
        _dayView.sd_layout
        .leftSpaceToView(_tableView, 0)
        .rightSpaceToView(_tableView, 0)
        .topSpaceToView(_lineView, 0)
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
        
        self.beginTimeTextField=[UITextField new];
        self.beginTimeTextField.font=[UIFont systemFontOfSize:14];
        self.beginTimeTextField.placeholder=@"开始时间";
        self.beginTimeTextField.tag=11;
        self.beginTimeTextField.delegate=self;
        self.beginTimeTextField.text=[self curent];
        self.beginTimeTextField.textAlignment=NSTextAlignmentCenter;
        self.beginTimeTextField.layer.borderWidth=0.5f;
        self.beginTimeTextField.layer.borderColor=[UIColor blackColor].CGColor;
        [_dayView addSubview:self.beginTimeTextField];
        self.beginTimeTextField.sd_layout
        .leftSpaceToView(_dayView, 15)
        .heightIs(30)
        .rightSpaceToView(label, 30)
        .bottomSpaceToView(lineView, 0);
        
        self.endTimeTextField=[UITextField new];
        self.endTimeTextField.font=[UIFont systemFontOfSize:14];
        self.endTimeTextField.placeholder=@"结束时间";
        self.endTimeTextField.textAlignment=NSTextAlignmentCenter;
        self.endTimeTextField.delegate=self;
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

-(void)textFieldDidBeginEditing:(UITextField*)textField

{
    [textField resignFirstResponder];
    if (textField.tag==11) {
        
        self.beginTimeTextField.layer.borderWidth=0.5f;
        self.beginTimeTextField.layer.borderColor=[UIColor blackColor].CGColor;
    }else if (textField.tag==12){
        
        self.endTimeTextField.layer.borderWidth=0.5f;
        self.endTimeTextField.layer.borderColor=[UIColor blackColor].CGColor;
        self.endTimeTextField.text=[self curent];
    }
    
    self.indexTag=textField.tag;
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}
- (void)setSelectValue:(NSString *)selectValue{
    
    if (self.indexTag==11) {
        
        self.beginTimeTextField.text =selectValue;
    }else{
        
        self.endTimeTextField.text =selectValue;
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
@end

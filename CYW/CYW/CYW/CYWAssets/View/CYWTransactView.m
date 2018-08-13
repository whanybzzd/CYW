//
//  CYWTransactView.m
//  CYW
//
//  Created by jktz on 2017/12/12.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWTransactView.h"
#import "DCDatePickerView.h"
@interface CYWTransactView()<UITextFieldDelegate>
@property (copy,nonatomic) CYWTransactViewBlock block;
@property (nonatomic, retain) UIView *backgroundView;
@property (nonatomic, retain) UIView *tableView;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UIView *lineView;

@property (nonatomic, retain) UIView *typeView;
@property (nonatomic, retain) UIImageView *leftImageView;
@property (nonatomic, assign) BOOL agreetment;
@property (nonatomic, retain) UIView *typeDetailView;
@property (nonatomic, retain) UILabel *allabel;
@property (nonatomic, retain) NSArray *typeArray;
@property (nonatomic, retain) NSArray *typeArray1;


@property (nonatomic, retain) UILabel *timelabel;
@property (nonatomic, retain) UIView *dayView;
@property (nonatomic, retain) UITextField *beginTimeTextField;
@property (nonatomic, retain) UITextField *endTimeTextField;
@property (nonatomic, assign) NSInteger indexTag;
@property (nonatomic, retain) DCDatePickerView *pickerView;
@property (nonatomic, retain) NSString *typeDetail;

@end
@implementation CYWTransactView

+ (instancetype)sharedInstanceWithBlock:(CYWTransactViewBlock)bock{
    
    return [[self alloc] initWithBlock:bock];
}

- (instancetype)initWithBlock:(CYWTransactViewBlock)block{
    
    if (self=[super init]) {
        
        self.block=block;
        [self initSubView];
        
    }
    return self;
}

- (void)initSubView{
    
    self.typeArray=@[@"提现",@"充值",@"投资",@"正常还款",@"提前还款",@"逾期还款",@"购买债权",@"转让债权"];
    self.typeArray1=@[@"withdraw_success",@"recharge_success",@"invest_success",@"normal_repay",@"advance_repay",@"overdue_repay",@"transfer_buy",@"transfer"];
    
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
    [self typeDetailView];
    [self timelabel];
    [self dayView];
    [self pickerView];
    [self initSubViews];
    
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

- (UIView *)typeView{
    if (!_typeView) {
        
        _typeView=[UIView new];
        _typeView.userInteractionEnabled=YES;
        [_tableView addSubview:_typeView];
        _typeView.sd_layout
        .leftSpaceToView(_tableView, 0)
        .rightSpaceToView(_tableView, 0)
        .topSpaceToView(_lineView, 0)
        .heightIs(40);
        
        UILabel *label=[UILabel new];
        label.text=@"类型";
        label.textColor=[UIColor colorWithHexString:@"#333333"];
        label.font=[UIFont systemFontOfSize:15];
        [_typeView addSubview:label];
        label.sd_layout
        .leftSpaceToView(_typeView, 15)
        .heightIs(15)
        .centerYEqualToView(_typeView);
        [label setSingleLineAutoResizeWithMaxWidth:100];
        
        self.leftImageView=[UIImageView new];
        self.leftImageView.image=[UIImage imageNamed:@"icon_三角"];
        [_typeView addSubview:self.leftImageView];
        self.leftImageView.sd_layout
        .rightSpaceToView(_typeView, 10)
        .centerYEqualToView(_typeView)
        .widthIs(16)
        .heightIs(9);
        
        
        self.allabel=[UILabel new];
        self.allabel.text=@"提现";
        self.allabel.textColor=[UIColor colorWithHexString:@"#666666"];
        self.allabel.font=[UIFont systemFontOfSize:14];
        [_typeView addSubview:self.allabel];
        self.allabel.sd_layout
        .rightSpaceToView(self.leftImageView, 10)
        .heightIs(15)
        .centerYEqualToView(_typeView);
        [self.allabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
        
        UIView *lineView=[UIView new];
        lineView.backgroundColor=[UIColor colorWithHexString:@"#f4f4f4"];
        [_typeView addSubview:lineView];
        lineView.sd_layout
        .leftSpaceToView(_typeView, 0)
        .rightSpaceToView(_typeView, 0)
        .bottomSpaceToView(_typeView, 0)
        .heightIs(1.0);
        
    }
    return _typeView;
}

- (UIView *)typeDetailView{
    
    if (!_typeDetailView) {
        
        _typeDetailView=[UIView new];
        _typeDetailView.hidden=YES;
        [_tableView addSubview:_typeDetailView];
        _typeDetailView.sd_layout
        .leftSpaceToView(_tableView, 0)
        .rightSpaceToView(_tableView, 0)
        .topSpaceToView(_typeView, 0)
        .heightIs(0);
        
        UIView *lineView=[UIView new];
        lineView.backgroundColor=[UIColor colorWithHexString:@"#f4f4f4"];
        [_typeDetailView addSubview:lineView];
        lineView.sd_layout
        .leftSpaceToView(_typeDetailView, 0)
        .rightSpaceToView(_typeDetailView, 0)
        .bottomSpaceToView(_typeDetailView, 0)
        .heightIs(1.0);
        
        
        CGFloat margin=35.0f;//间距
        CGFloat itemW=(SCREEN_WIDTH-margin*4)/3;
        CGFloat itemH=30.0f;
        
        for (int i=0; i<self.typeArray.count; i++) {
            
            long columnIndex = i % 3;
            long rowIndex = i / 3;
            
            UIButton *button=[UIButton new];
            if (i==0) {
                [button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                button.layer.borderColor=[UIColor orangeColor].CGColor;
                
            }else{
                
                [button setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                button.layer.borderColor=[UIColor lightGrayColor].CGColor;
            }
            [button setTitle:self.typeArray[i] forState:UIControlStateNormal];
            button.layer.borderWidth=1.0f;
            button.tag=i;
            [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            button.backgroundColor=[UIColor whiteColor];
            button.titleLabel.font=[UIFont systemFontOfSize:14];
            [_typeDetailView addSubview:button];
            button.frame = CGRectMake(margin+columnIndex * (itemW + margin), 17+rowIndex * (itemH + 17), itemW, itemH);
            
        }
        
    }
    return _typeDetailView;
}

- (UILabel *)timelabel{
    if (!_timelabel) {
        
        _timelabel=[UILabel new];
        _timelabel.text=@"时间";
        _timelabel.textColor=[UIColor colorWithHexString:@"#333333"];
        _timelabel.font=[UIFont systemFontOfSize:15];
        [_tableView addSubview:_timelabel];
        _timelabel.sd_layout
        .leftSpaceToView(_tableView, 15)
        .heightIs(15)
        .topSpaceToView(_typeView, 15);
        [_timelabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _timelabel;
}


- (UIView *)dayView{
    
    if (!_dayView) {
        
        _dayView=[UIView new];
        //_dayView.backgroundColor=[UIColor redColor];
        [_tableView addSubview:_dayView];
        _dayView.sd_layout
        .leftSpaceToView(_tableView, 0)
        .rightSpaceToView(_tableView, 0)
        .topSpaceToView(_timelabel, 0)
        .heightIs(46);
        
        UILabel *label=[UILabel new];
        label.text=@"至";
        label.font=[UIFont systemFontOfSize:15];
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        [_dayView addSubview:label];
        label.sd_layout
        .centerXEqualToView(_dayView)
        .centerYEqualToView(_dayView)
        .heightIs(15);
        [label setSingleLineAutoResizeWithMaxWidth:50];
        
        
        self.beginTimeTextField=[UITextField new];
        self.beginTimeTextField.font=[UIFont systemFontOfSize:14];
        self.beginTimeTextField.tag=11;
        self.beginTimeTextField.textAlignment=NSTextAlignmentCenter;
        self.beginTimeTextField.layer.borderWidth=0.5f;
        self.beginTimeTextField.layer.borderColor=[UIColor colorWithHexString:@"#888888"].CGColor;
        self.beginTimeTextField.delegate=self;
        self.beginTimeTextField.text=[self curent];
        [_dayView addSubview:self.beginTimeTextField];
        self.beginTimeTextField.sd_layout
        .leftSpaceToView(_dayView, 15)
        .heightIs(30)
        .rightSpaceToView(label, 15)
        .centerYEqualToView(_dayView);
        
        
        self.endTimeTextField=[UITextField new];
        self.endTimeTextField.font=[UIFont systemFontOfSize:14];
        self.endTimeTextField.tag=12;
        self.endTimeTextField.textAlignment=NSTextAlignmentCenter;
        self.endTimeTextField.layer.borderWidth=0.5f;
        self.endTimeTextField.layer.borderColor=[UIColor colorWithHexString:@"#888888"].CGColor;
        self.endTimeTextField.delegate=self;
        [_dayView addSubview:self.endTimeTextField];
        self.endTimeTextField.sd_layout
        .leftSpaceToView(label, 15)
        .heightIs(30)
        .rightSpaceToView(_dayView, 15)
        .centerYEqualToView(_dayView);
    }
    return _dayView;
}


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
        .topSpaceToView(_dayView, 0)
        .bottomSpaceToView(_tableView, 0);
        
    }
    return _pickerView;
}

-(void)textFieldDidBeginEditing:(UITextField*)textField

{
    [textField resignFirstResponder];
    
    self.beginTimeTextField.layer.borderWidth=0.5f;
    self.beginTimeTextField.layer.borderColor=[UIColor colorWithHexString:@"#888888"].CGColor;
    self.endTimeTextField.layer.borderWidth=0.5f;
    self.endTimeTextField.layer.borderColor=[UIColor colorWithHexString:@"#888888"].CGColor;
    
    if (textField.tag==12){
        self.endTimeTextField.layer.borderWidth=0.5f;
        self.endTimeTextField.layer.borderColor=[UIColor orangeColor].CGColor;
        self.endTimeTextField.text=[self curent];
    }
    if (textField.tag==11){
        self.beginTimeTextField.layer.borderWidth=0.5f;
        self.beginTimeTextField.layer.borderColor=[UIColor orangeColor].CGColor;
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
#pragma mark --逻辑
- (void)initSubViews{
    
    self.agreetment=YES;
    self.typeDetail=self.typeArray1[0];//默认为提现
    @weakify(self)
    UITapGestureRecognizer *typeTap=[[UITapGestureRecognizer alloc] init];
    [[typeTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self)
        [self agreement:self.agreetment];
    }];
    [self.typeView addGestureRecognizer:typeTap];
    
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
       
        @strongify(self)
        
        NSString *start=[StringUtils trimString:self.beginTimeTextField.text];
        NSString *end=[StringUtils trimString:self.endTimeTextField.text];
        if ([NSString isEmpty:end]) {
            
            self.endTimeTextField.layer.borderColor=[UIColor redColor].CGColor;
            self.endTimeTextField.layer.borderWidth=1.0f;
            return ;
        }
        
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        [dict setValue:start forKey:@"start"];
        [dict setValue:end forKey:@"end"];
        [dict setValue:self.typeDetail forKey:@"type"];
        if (self.block) {
            
            self.block(dict);
        }
        
        [self hide];
    }];
}

- (void)agreement:(BOOL)boo{
    NSLog(@"boo:%zd",boo);
    if (boo) {
        self.agreetment=NO;
    }else{
        self.agreetment=YES;
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        if (!boo) {
            self.typeDetailView.hidden=YES;
            self.leftImageView.transform = CGAffineTransformIdentity;
            self.typeDetailView.sd_layout.heightIs(0);
            self.timelabel.sd_layout.topSpaceToView(self.typeView, 15);
            
        }else{
            self.typeDetailView.hidden=NO;
            self.leftImageView.transform = CGAffineTransformMakeRotation(M_PI);
            self.typeDetailView.sd_layout.heightIs(160);
            self.timelabel.sd_layout.topSpaceToView(self.typeDetailView, 15);
        }
        
    }];
    
    
}

- (void)buttonClick:(UIButton *)sender{
    
    for (UIView *view in self.typeDetailView.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            
            UIButton *button=(UIButton *)view;
            [button setTitleColor:[UIColor colorWithHexString:@"#888888"] forState:UIControlStateNormal];
            button.layer.borderColor=[UIColor colorWithHexString:@"#888888"].CGColor;
            button.layer.borderWidth=1.0f;
        }
        
    }
    
    [sender setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    sender.layer.borderColor=[UIColor orangeColor].CGColor;
    sender.layer.borderWidth=1.0f;
    
    self.allabel.text=self.typeArray[sender.tag];
    self.typeDetail=self.typeArray1[sender.tag];
    
    [self.allabel sizeToFit];
    [self agreement:NO];
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

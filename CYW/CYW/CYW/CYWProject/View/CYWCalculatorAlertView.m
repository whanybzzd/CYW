//
//  CYWCalculatorAlertView.m
//  CYW
//
//  Created by jktz on 2017/10/30.
//  Copyright © 2017年 jktz. All rights reserved.
//
#import "CYWCalculatorViewModel.h"
#import "CYWCalculatorAlertView.h"
@interface CYWCalculatorAlertView()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UIView *alertView;
@property (nonatomic, retain) UIView *gradeView;
@property (nonatomic, retain) UIImageView *gradeImageView;
@property (nonatomic, retain) UIImageView *closeImageView;
@property (nonatomic, retain) UILabel *calculatorlabel;

@property (nonatomic, retain) UIView *view1;
@property (nonatomic, retain) UITextField *calculatorTextField;

@property (nonatomic, retain) UIView *view2;
@property (nonatomic, retain) UIButton *leftButton;
@property (nonatomic, retain) UIImageView *leftImageView;

@property (nonatomic, retain) UIView *view3;
@property (nonatomic, retain) UITextField *limitTextField;
@property (nonatomic, retain) UITextField *annualTextField;

@property (nonatomic, retain) UIView *view4;
@property (nonatomic, retain) UILabel *label;

@property (nonatomic, retain) UIButton *submitButton;

@property (nonatomic, assign) BOOL agreetment;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) CYWCalculatorViewModel *calculatorViewModel;
@property (nonatomic, copy) NSArray *tableArray;
@property (nonatomic, copy) NSArray *tableTypeArray;

@end
@implementation CYWCalculatorAlertView
- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        self.tableArray=@[@"新手标",@"房宝保",@"转让通"];
        
        self.tableTypeArray = @[@"fipd",@"rfcl",@"cpm"];
        
        self.backgroundColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:0.7];
        [self addSubview:self.alertView];
        [self gradeView];
        [self gradeImageView];
        [self closeImageView];
        [self calculatorlabel];
        [self view1];
        [self view2];
        [self view3];
        [self view4];
        [self submitButton];
        [self tableView];
        
        [self initSubView];
        
    }
    return self;
}

//设置文本框只能输入数字
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    //如果是限制只能输入数字的文本框
    if (self.calculatorTextField==textField) {
        
        return [self validateNumber:string];
        
    }
    else if (self.annualTextField==textField){
        
        return [self validateNumber:string];
    }
    //否则返回yes,不限制其他textfield
    return YES;
    
}


- (BOOL)validateNumber:(NSString*)number {
    BOOL res =YES;
    NSCharacterSet* tmpSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    int i =0;
    while (i < number.length) {
        NSString * string = [number substringWithRange:NSMakeRange(i,1)];
        NSRange range = [string rangeOfCharacterFromSet:tmpSet];
        if (range.length ==0) {
            res =NO;
            break;
        }
        i++;
    }
    return res;
}


- (void)initSubView{
    
    self.agreetment=YES;
    self.calculatorViewModel=[[CYWCalculatorViewModel alloc] init];
    RAC(self.calculatorViewModel,cal)=self.calculatorTextField.rac_textSignal;
    RAC(self.calculatorViewModel,limit)=self.limitTextField.rac_textSignal;
    RAC(self.calculatorViewModel,ann)=self.annualTextField.rac_textSignal;
    self.calculatorViewModel.type=self.tableTypeArray[1];
    self.calculatorViewModel.name=self.tableArray[0];
    
    @weakify(self)
    UITapGestureRecognizer *forgetTap1=[[UITapGestureRecognizer alloc] init];
    [[forgetTap1 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self)
        [self hide];
    }];
    [self.closeImageView addGestureRecognizer:forgetTap1];
    
    
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
        NSString *cal=[StringUtils trimString:self.calculatorTextField.text];
        NSString *limit=[StringUtils trimString:self.limitTextField.text];
        NSString *an=[StringUtils trimString:self.annualTextField.text];
        if ([cal floatValue]<1) {
            
            [UIView showResultThenHide:@"投资金额不能小于1"];
            return ;
        }
        if ([limit floatValue]<1) {
            
            [UIView showResultThenHide:@"投资期限不能小于1"];
            return ;
        }
        if ([an floatValue]<0.01) {
            
            [UIView showResultThenHide:@"年化利率不能小于0.01"];
            return ;
        }
        [self endEditing:YES];
        
        [UIView showHUDLoading:nil];
        [[self.calculatorViewModel.refreshcomputationsCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            
            @strongify(self)
            [UIView hideHUDLoading];
            NSString *money=[NSString stringWithFormat:@"%@元",x];
            [self.label setAttributedText:[NSMutableAttributedString withTitleString:money RangeString:@"元" color:[UIColor colorWithHexString:@"#333333"] withFont:[UIFont systemFontOfSize:14]]];
            [self.label sizeToFit];
            
        } error:^(NSError * _Nullable error) {
            
            [UIView hideHUDLoading];
        }];
        
    }];
    
    
    
    
    [[self.leftButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
        [self agreement:self.agreetment];
        
    }];
    
    
    
    RAC(self.submitButton,backgroundColor)=[[RACSignal combineLatest:@[self.calculatorTextField.rac_textSignal,self.limitTextField.rac_textSignal,self.annualTextField.rac_textSignal] reduce:^(NSString *username,NSString *password,NSString *password1){
        
        return @([NSString isNotEmpty:username]&&[NSString isNotEmpty:password]&&[NSString isNotEmpty:password1]);
    }]map:^id _Nullable(id  _Nullable value) {
        @strongify(self)
        self.submitButton.userInteractionEnabled=[value boolValue]?YES:NO;
        return [value boolValue]?[UIColor colorWithHexString:@"#ff5978"]:[UIColor lightGrayColor];
    }];
    
    
    
}

- (void)agreement:(BOOL)boo{
    NSLog(@"boo:%zd",boo);
    if (boo) {
        self.agreetment=NO;
        _tableView.sd_layout
        .leftEqualToView(_leftButton)
        .rightEqualToView(_leftButton)
        .topSpaceToView(_view2, 0)
        .heightIs(40*3);
    }else{
        self.agreetment=YES;
        _tableView.sd_layout
        .leftEqualToView(_leftButton)
        .rightEqualToView(_leftButton)
        .topSpaceToView(_view2, 0)
        .heightIs(0);
    }
    
    [UIView animateWithDuration:0.25 animations:^{
        
        if (!boo) {
            
            self.leftImageView.transform = CGAffineTransformIdentity;
            
        }else{
            self.leftImageView.transform = CGAffineTransformMakeRotation(M_PI);
        }
        
    }];
    
    [self.tableView reloadData];
    
}


- (UITableView *)tableView{
    if (!_tableView) {
        
        _tableView=[UITableView new];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        _tableView.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        [_alertView addSubview:_tableView];
        _tableView.sd_layout
        .leftEqualToView(self.leftButton)
        .rightEqualToView(self.leftButton)
        .topSpaceToView(self.leftButton, 0)
        .heightIs(0);
    }
    return _tableView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.textLabel.text=[NSString stringWithFormat:@"%@",self.tableArray[indexPath.row]];
    cell.textLabel.font=[UIFont systemFontOfSize:12];
    cell.textLabel.textColor=[UIColor lightGrayColor];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 40.0f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self.leftButton setTitle:self.tableArray[indexPath.row] forState:UIControlStateNormal];
    //self.calculatorViewModel.type=self.tableTypeArray[indexPath.row];//后台固定了参数
    //self.calculatorViewModel.name=self.tableArray[indexPath.row];
    //self.agreetment=NO;
    [self agreement:self.agreetment];
}



-(UIButton *)submitButton{
    
    if (!_submitButton) {
        
        _submitButton=[UIButton new];
        [_submitButton setTitle:@"确定" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(15)];
        _submitButton.backgroundColor=[UIColor colorWithHexString:@"#ff5978"];
        _submitButton.layer.cornerRadius=CGFloatIn320(20);
        [_alertView addSubview:_submitButton];
        _submitButton.sd_layout
        .rightSpaceToView(_alertView, CGFloatIn320(40))
        .leftSpaceToView(_alertView, CGFloatIn320(40))
        .topSpaceToView(_view4, CGFloatIn320(31))
        .heightIs(CGFloatIn320(40));
    }
    return _submitButton;
}

- (UIView *)view4{
    
    if (!_view4) {
        
        _view4=[UIView new];
        _view4.backgroundColor=[UIColor whiteColor];
        [_alertView addSubview:_view4];
        _view4.sd_layout
        .leftSpaceToView(_alertView, 0)
        .rightSpaceToView(_alertView, 0)
        .topSpaceToView(_view3, 0)
        .heightIs(70);
        
        
        UIView *lineView1=[UIView new];
        lineView1.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [_view4 addSubview:lineView1];
        lineView1.sd_layout
        .leftSpaceToView(_view4, 0)
        .rightSpaceToView(_view4, 0)
        .bottomSpaceToView(_view4, 0)
        .heightIs(1);
        
        UILabel *label=[UILabel new];
        label.text=@"预计收益(元)";
        label.textColor=[UIColor colorWithHexString:@"#333333"];
        label.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_view4 addSubview:label];
        label.sd_layout
        .leftSpaceToView(_view4, CGFloatIn320(20))
        .heightIs(14)
        .centerYEqualToView(_view4);
        [label setSingleLineAutoResizeWithMaxWidth:200];
        
        
        self.label=[UILabel new];
        self.label.text=@"0.0元";
        self.label.textColor=[UIColor colorWithHexString:@"#f52735"];
        self.label.font=[UIFont systemFontOfSize:CGFloatIn320(18)];
        [_view4 addSubview:self.label];
        self.label.sd_layout
        .centerXEqualToView(_view4)
        .heightIs(18)
        .centerYEqualToView(_view4);
        [self.label setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _view4;
}


- (UIView *)view3{
    
    if (!_view3) {
        
        _view3=[UIView new];
        _view3.backgroundColor=[UIColor whiteColor];
        [_alertView addSubview:_view3];
        _view3.sd_layout
        .leftSpaceToView(_alertView, 0)
        .rightSpaceToView(_alertView, 0)
        .topSpaceToView(_view2, 0)
        .heightIs(50);
        
        
        UIView *lineView1=[UIView new];
        lineView1.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [_view3 addSubview:lineView1];
        lineView1.sd_layout
        .leftSpaceToView(_view3, 0)
        .rightSpaceToView(_view3, 0)
        .bottomSpaceToView(_view3, 0)
        .heightIs(1);
        
        UIView *lineView2=[UIView new];
        lineView2.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [_view3 addSubview:lineView2];
        lineView2.sd_layout
        .topSpaceToView(_view3, 0)
        .bottomSpaceToView(_view3, 0)
        .centerXEqualToView(_view3)
        .widthIs(1);
        
        
        UIImageView *imageView=[UIImageView new];
        imageView.image=[UIImage imageNamed:@"icon_期限"];
        [_view3 addSubview:imageView];
        imageView.sd_layout
        .leftSpaceToView(_view3, CGFloatIn320(20))
        .heightIs(CGFloatIn320(14))
        .widthIs(CGFloatIn320(16))
        .centerYEqualToView(_view3);
        
        UILabel *label=[UILabel new];
        label.text=@"期限";
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        label.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [_view3 addSubview:label];
        label.sd_layout
        .leftSpaceToView(imageView, CGFloatIn320(10))
        .heightIs(12)
        .centerYEqualToView(_view3);
        [label setSingleLineAutoResizeWithMaxWidth:200];
        
        
        
        UILabel *label1=[UILabel new];
        label1.text=@"年";
        label1.textColor=[UIColor colorWithHexString:@"#333333"];
        label1.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_view3 addSubview:label1];
        label1.sd_layout
        .rightSpaceToView(lineView2, CGFloatIn320(10))
        .heightIs(14)
        .centerYEqualToView(_view3);
        [label1 setSingleLineAutoResizeWithMaxWidth:200];
        
        
        
        
        self.limitTextField=[UITextField new];
        self.limitTextField.backgroundColor=[UIColor whiteColor];
        self.limitTextField.font=[UIFont systemFontOfSize:15];
        self.limitTextField.keyboardType=UIKeyboardTypeNumberPad;
        self.limitTextField.delegate=self;
        [_view3 addSubview:self.limitTextField];
        self.limitTextField.sd_layout
        .leftSpaceToView(label, 10)
        .rightSpaceToView(label1, 10)
        .centerYEqualToView(_view3)
        .heightIs(40);
        
        ////////////////////////////////
        
        UIImageView *imageView1=[UIImageView new];
        imageView1.image=[UIImage imageNamed:@"icon_年利率"];
        [_view3 addSubview:imageView1];
        imageView1.sd_layout
        .leftSpaceToView(lineView2, CGFloatIn320(8))
        .heightIs(CGFloatIn320(18))
        .widthIs(CGFloatIn320(20))
        .centerYEqualToView(_view3);
        
        UILabel *label3=[UILabel new];
        label3.text=@"年化率";
        label3.textColor=[UIColor colorWithHexString:@"#888888"];
        label3.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [_view3 addSubview:label3];
        label3.sd_layout
        .leftSpaceToView(imageView1, CGFloatIn320(10))
        .heightIs(12)
        .centerYEqualToView(_view3);
        [label3 setSingleLineAutoResizeWithMaxWidth:200];
        
        
        
        UILabel *label13=[UILabel new];
        label13.text=@"%";
        label13.textColor=[UIColor colorWithHexString:@"#333333"];
        label13.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_view3 addSubview:label13];
        label13.sd_layout
        .rightSpaceToView(_view3, CGFloatIn320(10))
        .heightIs(14)
        .centerYEqualToView(_view3);
        [label13 setSingleLineAutoResizeWithMaxWidth:200];
        
        self.annualTextField=[UITextField new];
        self.annualTextField.backgroundColor=[UIColor whiteColor];
        self.annualTextField.font=[UIFont systemFontOfSize:15];
        self.annualTextField.delegate=self;
        [_view3 addSubview:self.annualTextField];
        self.annualTextField.sd_layout
        .leftSpaceToView(label3, 10)
        .rightSpaceToView(label13, 10)
        .centerYEqualToView(_view3)
        .heightIs(40);
        
    }
    return _view3;
}


- (UIView *)view2{
    
    if (!_view2) {
        
        _view2=[UIView new];
        _view2.backgroundColor=[UIColor whiteColor];
        [_alertView addSubview:_view2];
        _view2.sd_layout
        .leftSpaceToView(_alertView, 0)
        .rightSpaceToView(_alertView, 0)
        .topSpaceToView(_view1, 0)
        .heightIs(50);
        
        
        UIView *lineView1=[UIView new];
        lineView1.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [_view2 addSubview:lineView1];
        lineView1.sd_layout
        .leftSpaceToView(_view2, 0)
        .rightSpaceToView(_view2, 0)
        .bottomSpaceToView(_view2, 0)
        .heightIs(1);
        
        
        
        UIImageView *imageView=[UIImageView new];
        imageView.image=[UIImage imageNamed:@"icon_投标类型"];
        [_view2 addSubview:imageView];
        imageView.sd_layout
        .leftSpaceToView(_view2, CGFloatIn320(20))
        .heightIs(CGFloatIn320(22))
        .widthIs(CGFloatIn320(20))
        .centerYEqualToView(_view2);
        
        UILabel *label=[UILabel new];
        label.text=@"投标类型";
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        label.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [_view2 addSubview:label];
        label.sd_layout
        .leftSpaceToView(imageView, CGFloatIn320(10))
        .heightIs(12)
        .centerYEqualToView(_view2);
        [label setSingleLineAutoResizeWithMaxWidth:200];
        
        self.leftImageView=[UIImageView new];
        self.leftImageView.image=[UIImage imageNamed:@"icon_三角"];
        [_view2 addSubview:self.leftImageView];
        self.leftImageView.sd_layout
        .rightSpaceToView(_view2, CGFloatIn320(10))
        .centerYEqualToView(_view2)
        .widthIs(CGFloatIn320(16))
        .heightIs(CGFloatIn320(9));
        
        self.leftButton=[UIButton new];
        self.leftButton.titleLabel.font=[UIFont systemFontOfSize:14];
        self.leftButton.backgroundColor=[UIColor whiteColor];
        [self.leftButton setTitle:self.tableArray[0] forState:UIControlStateNormal];
        [self.leftButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [_view2 addSubview:self.leftButton];
        self.leftButton.sd_layout
        .leftSpaceToView(label, CGFloatIn320(10))
        .rightSpaceToView(self.leftImageView, CGFloatIn320(10))
        .centerYEqualToView(_view2)
        .heightIs(40);
    }
    return _view2;
}



- (UIView *)view1{
    
    if (!_view1) {
        
        _view1=[UIView new];
        _view1.backgroundColor=[UIColor whiteColor];
        [_alertView addSubview:_view1];
        _view1.sd_layout
        .leftSpaceToView(_alertView, 0)
        .rightSpaceToView(_alertView, 0)
        .topSpaceToView(_calculatorlabel, CGFloatIn320(22))
        .heightIs(50);
        
        UIView *lineView=[UIView new];
        lineView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [_view1 addSubview:lineView];
        lineView.sd_layout
        .leftSpaceToView(_view1, 0)
        .rightSpaceToView(_view1, 0)
        .topSpaceToView(_view1, 0)
        .heightIs(1);
        
        UIView *lineView1=[UIView new];
        lineView1.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [_view1 addSubview:lineView1];
        lineView1.sd_layout
        .leftSpaceToView(_view1, 0)
        .rightSpaceToView(_view1, 0)
        .bottomSpaceToView(_view1, 0)
        .heightIs(1);
        
        UIImageView *imageView=[UIImageView new];
        imageView.image=[UIImage imageNamed:@"icon_投资金额"];
        [_view1 addSubview:imageView];
        imageView.sd_layout
        .leftSpaceToView(_view1, CGFloatIn320(20))
        .heightIs(CGFloatIn320(22))
        .widthIs(CGFloatIn320(20))
        .centerYEqualToView(_view1);
        
        UILabel *label=[UILabel new];
        label.text=@"投资金额";
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        label.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [_view1 addSubview:label];
        label.sd_layout
        .leftSpaceToView(imageView, CGFloatIn320(10))
        .heightIs(12)
        .centerYEqualToView(_view1);
        [label setSingleLineAutoResizeWithMaxWidth:200];
        
        
        
        UILabel *label1=[UILabel new];
        label1.text=@"元";
        label1.textColor=[UIColor colorWithHexString:@"#333333"];
        label1.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [_view1 addSubview:label1];
        label1.sd_layout
        .rightSpaceToView(_view1, CGFloatIn320(10))
        .heightIs(14)
        .centerYEqualToView(_view1);
        [label1 setSingleLineAutoResizeWithMaxWidth:200];
        
        
        self.calculatorTextField=[UITextField new];
        self.calculatorTextField.backgroundColor=[UIColor whiteColor];
        self.calculatorTextField.font=[UIFont systemFontOfSize:15];
        self.calculatorTextField.delegate=self;
        [_view1 addSubview:self.calculatorTextField];
        self.calculatorTextField.sd_layout
        .leftSpaceToView(label, 10)
        .rightSpaceToView(label1, 10)
        .centerYEqualToView(_view1)
        .heightIs(40);
    }
    return _view1;
}

- (UILabel *)calculatorlabel{
    if (!_calculatorlabel) {
        
        _calculatorlabel=[UILabel new];
        _calculatorlabel.text=@"计算收益";
        _calculatorlabel.textColor=[UIColor colorWithHexString:@"#333333"];
        _calculatorlabel.font=[UIFont systemFontOfSize:CGFloatIn320(16)];
        [_alertView addSubview:_calculatorlabel];
        _calculatorlabel.sd_layout
        .centerXEqualToView(_alertView)
        .topSpaceToView(_gradeView, 0)
        .heightIs(16);
        [_calculatorlabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
    }
    return _calculatorlabel;
}

- (UIImageView *)closeImageView{
    
    if (!_closeImageView) {
        
        _closeImageView=[UIImageView new];
        _closeImageView.userInteractionEnabled=YES;
        _closeImageView.image=[UIImage imageNamed:@"X"];
        [_alertView addSubview:_closeImageView];
        _closeImageView.sd_layout
        .rightSpaceToView(_alertView, CGFloatIn320(14))
        .topSpaceToView(_alertView, CGFloatIn320(9))
        .widthIs(15)
        .heightIs(14);
        
    }
    return _closeImageView;
}

- (UIImageView *)gradeImageView{
    
    if (!_gradeImageView) {
        
        _gradeImageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.gradeView.frame.size.width/2-16.5, self.gradeView.frame.size.height/2-15, 33, 30)];
        _gradeImageView.image=[UIImage imageNamed:@"利率计算机"];
        [_gradeView addSubview:_gradeImageView];
        
    }
    return _gradeImageView;
}

- (UIView *)gradeView{
    
    if (!_gradeView) {
        
        _gradeView=[[UIView alloc] initWithFrame:CGRectMake(self.alertView.frame.size.width/2-53, -53, 106, 95)];
        
        UIImageView *gradgeImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _gradeView.frame.size.width, _gradeView.frame.size.height)];
        gradgeImageView.image=[UIImage imageNamed:@"icon_usercenter_topimg"];
        [_gradeView addSubview:gradgeImageView];
        [_alertView addSubview:_gradeView];
    }
    return _gradeView;
}


- (UIView *)alertView{
    
    if (!_alertView) {
        
        _alertView=[[UIView alloc] initWithFrame:CGRectMake(17, ([UIScreen mainScreen].bounds.size.height-380)/2-7, [UIScreen mainScreen].bounds.size.width-17*2,380)];
        _alertView.layer.cornerRadius=10;
        _alertView.backgroundColor=[UIColor whiteColor];
        
    }
    return _alertView;
}

- (void)show{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alertView.alpha = 0.0;
    [UIView animateWithDuration:0.4 animations:^{
        self.alertView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end

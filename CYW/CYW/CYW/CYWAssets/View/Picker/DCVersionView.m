//
//  DCVersionView.m
//  长运网
//
//  Created by jktz on 2017/9/11.
//  Copyright © 2017年 J. All rights reserved.
//

#import "DCVersionView.h"
#import "DCDataPickerView.h"
@interface DCVersionView()<UITextFieldDelegate>
@property (nonatomic, strong) UIView *paymentAlert;
@property (nonatomic, retain) UITextField *beginTimeTextField;
@property (nonatomic, retain) UITextField *endTimeTextField;
@property (nonatomic, retain) UIView *typeClickView;
@property (nonatomic, retain) NSMutableArray *viewArray;
@property (nonatomic, retain) UILabel *l;


@property (nonatomic, retain) UIButton *screenButton;//筛选按钮
@property (nonatomic, retain) UITextField *screenTextField;
@property (nonatomic, assign) NSInteger screenIndex;//筛选的条件
@property (nonatomic, assign) NSInteger selectTag;

@end

@implementation DCVersionView

+ (instancetype)showVersionView:(NSArray *)typeArray{

    return [[self alloc] initArray:typeArray];
}

- (instancetype)initArray:(NSArray *)array{
    if (self=[super init]) {
        
        [self drawView:array];
        self.selectTag=100;
        self.screenIndex=1000;
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.3f];
        
//        UITapGestureRecognizer *tapRecognizer=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickTag:)];
//        [self addGestureRecognizer:tapRecognizer];
    }
    return self;
}



- (void)drawView:(NSArray *)array{
    if (!_paymentAlert) {
        _paymentAlert = [[UIView alloc]initWithFrame:CGRectMake(30, [UIScreen mainScreen].bounds.size.height/2-140, [UIScreen mainScreen].bounds.size.width-60, 280)];
        _paymentAlert.layer.cornerRadius = 5.f;
        _paymentAlert.layer.masksToBounds = YES;
        _paymentAlert.backgroundColor=[UIColor whiteColor];
        [self addSubview:_paymentAlert];
        
        //[UIColor colorWithHexString:@"#ffa033"]
        
        UIImageView *closeImageView=[UIImageView new];
        closeImageView.userInteractionEnabled=YES;
        UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [closeImageView addGestureRecognizer:tap];
        closeImageView.image=[UIImage imageNamed:@"关闭"];
        [_paymentAlert addSubview:closeImageView];
        closeImageView.sd_layout
        .widthIs(19)
        .heightIs(19)
        .rightSpaceToView(_paymentAlert, 20)
        .topSpaceToView(_paymentAlert, 15);
        
        
        
        //添加按照月还是天来筛选的按钮
        self.screenButton=[UIButton buttonWithType:UIButtonTypeCustom];
        [self.screenButton setTitle:@"按照天来筛选" forState:UIControlStateNormal];
        [self.screenButton setTitle:@"按照月来筛选" forState:UIControlStateSelected];
        [self.screenButton setBackgroundColor:[UIColor colorWithHexString:@"#ffa033"]];
        self.screenButton.titleLabel.font=[UIFont systemFontOfSize:15];
        [self.screenButton addTarget:self action:@selector(screenButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.screenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_paymentAlert addSubview:self.screenButton];
        self.screenButton.sd_layout
        .leftSpaceToView(_paymentAlert, 7)
        .topSpaceToView(_paymentAlert, 10)
        .heightIs(30)
        .widthIs(150);
        
        
        UILabel *label=[UILabel new];
        label.text=@"条件筛选";
        label.font=[UIFont systemFontOfSize:15];
        [_paymentAlert addSubview:label];
        label.sd_layout
        .leftSpaceToView(_paymentAlert, 7)
        .heightIs(15)
        .topSpaceToView(self.screenButton, 15);
        [label setSingleLineAutoResizeWithMaxWidth:100];
        
        UILabel *label1=[UILabel new];
        label1.text=@"(还款日期)";
        label1.textColor=[UIColor colorWithHexString:@"#ffa033"];
        label1.font=[UIFont systemFontOfSize:14];
        [_paymentAlert addSubview:label1];
        label1.sd_layout
        .leftSpaceToView(label, 0)
        .heightIs(14)
        .topSpaceToView(self.screenButton, 15);
        [label1 setSingleLineAutoResizeWithMaxWidth:100];
        
        
        UILabel *typelabel=[UILabel new];
        typelabel.textColor=[UIColor lightGrayColor];
        typelabel.text=@"类型:";
        typelabel.font=[UIFont systemFontOfSize:15];
        [_paymentAlert addSubview:typelabel];
        typelabel.sd_layout
        .leftEqualToView(label)
        .topSpaceToView(label, 20)
        .heightIs(15);
        [typelabel setSingleLineAutoResizeWithMaxWidth:100];
        
        
        
        self.typeClickView=[UIView new];
        [_paymentAlert addSubview:self.typeClickView];
        self.typeClickView.sd_layout
        .leftSpaceToView(_paymentAlert, 0)
        .rightSpaceToView(_paymentAlert, 0)
        .heightIs(24)
        .topSpaceToView(typelabel, 0);
        
        
        self.viewArray=[NSMutableArray array];
        CGFloat itemWidth=([UIScreen mainScreen].bounds.size.width-60)/array.count;
        for(int i=0;i<array.count;i++){
            UIView *typeView=[UIView new];
            typeView.tag=i;
            typeView.userInteractionEnabled=YES;
            UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(typeViewTap:)];
            [typeView addGestureRecognizer:tap];
            [self.typeClickView addSubview:typeView];
            typeView.sd_layout
            .leftSpaceToView(self.typeClickView, i * (itemWidth))
            .topSpaceToView(self.typeClickView, 0)
            .heightIs(24)
            .widthIs(itemWidth);
            
            UIImageView *imageView=[UIImageView new];
            NSString *tag=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectTag"];
            if ([NSString isEmpty:tag]) {
                
                if (i==0) {
                    
                    imageView.image=[UIImage imageNamed:@"选中"];
                }else{
                    
                    imageView.image=[UIImage imageNamed:@"未选中"];
                }
            }else{
            
                if (i==[tag intValue]-100) {
                    
                    imageView.image=[UIImage imageNamed:@"选中"];
                }else{
                    
                    imageView.image=[UIImage imageNamed:@"未选中"];
                }
            }
           
            
            [typeView addSubview:imageView];
            imageView.sd_layout
            .widthIs(17)
            .heightIs(17)
            .leftSpaceToView(typeView, 5)
            .centerYEqualToView(typeView);
            
            UILabel *label=[UILabel new];
            label.font=[UIFont systemFontOfSize:14];
            label.text=array[i];
            [typeView addSubview:label];
            label.sd_layout
            .leftSpaceToView(imageView, 2)
            .heightIs(14)
            .centerYEqualToView(typeView);
            [label setSingleLineAutoResizeWithMaxWidth:100];
            
            [self.viewArray addObject:typeView];
        }
        
        
        
        
        
        UILabel *timelabel=[UILabel new];
        timelabel.textColor=[UIColor lightGrayColor];
        timelabel.text=@"日期:";
        timelabel.font=[UIFont systemFontOfSize:15];
        [_paymentAlert addSubview:timelabel];
        timelabel.sd_layout
        .leftEqualToView(typelabel)
        .topSpaceToView(self.typeClickView, 40)
        .heightIs(15);
        [timelabel setSingleLineAutoResizeWithMaxWidth:100];
        CGFloat itemWidths=([UIScreen mainScreen].bounds.size.width-60-100)/2;
        
        
        
        self.screenTextField=[UITextField new];
        self.screenTextField.font=[UIFont systemFontOfSize:14];
        self.screenTextField.placeholder=@"请选择日期";
        self.screenTextField.tag=13;
        self.screenTextField.layer.borderWidth=1;
        self.screenTextField.delegate=self;
        [self.screenTextField setHidden:YES];
        self.screenTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [_paymentAlert addSubview:self.screenTextField];
        self.screenTextField.sd_layout
        .leftSpaceToView(timelabel, 5)
        .heightIs(30)
        .rightSpaceToView(_paymentAlert, 10)
        .topSpaceToView(self.typeClickView, 35);
        
        
        
        self.beginTimeTextField=[UITextField new];
        self.beginTimeTextField.font=[UIFont systemFontOfSize:14];
        self.beginTimeTextField.placeholder=@"请选择日期";
        self.beginTimeTextField.tag=11;
        self.beginTimeTextField.layer.borderWidth=1;
        self.beginTimeTextField.delegate=self;
        self.beginTimeTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [_paymentAlert addSubview:self.beginTimeTextField];
        self.beginTimeTextField.sd_layout
        .leftSpaceToView(timelabel, 5)
        .heightIs(30)
        .widthIs(itemWidths)
        .topSpaceToView(self.typeClickView, 35);
        
        self.l=[UILabel new];
        self.l.text=@"~";
        self.l.font=[UIFont systemFontOfSize:15];
        self.l.textColor=[UIColor lightGrayColor];
        [_paymentAlert addSubview:self.l];
        self.l.sd_layout
        .leftSpaceToView(self.beginTimeTextField, 14)
        .heightIs(15)
        .topSpaceToView(typelabel, 65);
        [self.l setSingleLineAutoResizeWithMaxWidth:100];
        
        
        self.endTimeTextField=[UITextField new];
        self.endTimeTextField.font=[UIFont systemFontOfSize:14];
        self.endTimeTextField.placeholder=@"请选择日期";
        self.endTimeTextField.delegate=self;
        self.endTimeTextField.tag=12;
        self.endTimeTextField.layer.borderWidth=1;
        self.endTimeTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
        [_paymentAlert addSubview:self.endTimeTextField];
        self.endTimeTextField.sd_layout
        .rightSpaceToView(_paymentAlert, 15)
        .heightIs(30)
        .widthIs(itemWidths)
        .topSpaceToView(self.typeClickView, 35);
        
        
        CGFloat buttonWidth=([UIScreen mainScreen].bounds.size.width-150)/2;
        UIButton *okButton=[UIButton new];
        [okButton setTitle:@"确定" forState:UIControlStateNormal];
        [okButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        okButton.titleLabel.font=[UIFont systemFontOfSize:15];
        [okButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];

        okButton.backgroundColor=[UIColor colorWithHexString:@"#ffa033"];
        [_paymentAlert addSubview:okButton];
        okButton.sd_layout
        .rightSpaceToView(_paymentAlert, 35)
        .heightIs(40)
        .widthIs(buttonWidth)
        .topSpaceToView(self.endTimeTextField, 30);
        
        
        UIButton *okButtons=[UIButton new];
        [okButtons setTitle:@"重置" forState:UIControlStateNormal];
        [okButtons addTarget:self action:@selector(resertButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [okButtons setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        okButtons.titleLabel.font=[UIFont systemFontOfSize:15];
        okButtons.backgroundColor=[UIColor lightGrayColor];
        [_paymentAlert addSubview:okButtons];
        okButtons.sd_layout
        .leftSpaceToView(_paymentAlert, 35)
        .heightIs(40)
        .widthIs(buttonWidth)
        .topSpaceToView(self.endTimeTextField, 30);
    }
    
    
}

//重置
- (void)resertButtonClick{

    self.beginTimeTextField.text=nil;
    self.endTimeTextField.text=nil;

}

//确定
- (void)submitButtonClick{
    //1  按照月来筛选  0按照天来筛选
    
    if (self.screenIndex==1001) {
    
        if ([NSString isEmpty:self.screenTextField.text]) {
            
            [UIView showResultThenHide:@"请选择月份日期"];
            return;
            
        }
    }else{
    
        if ([NSString isEmpty:self.beginTimeTextField.text]) {
            
            [UIView showResultThenHide:@"请选择开始日期"];
            return;
            
        }
        if ([NSString isEmpty:self.endTimeTextField.text]) {
            
             [UIView showResultThenHide:@"请选择结束日期"];
            return;
            
        }

    }
    
    
    NSDictionary *diction=[NSDictionary dictionary];
    NSString *st=self.screenIndex==1001?self.screenTextField.text:self.beginTimeTextField.text;
    NSString *et=self.screenIndex==1001?@"":self.endTimeTextField.text;
    
    NSString *tag=[[NSUserDefaults standardUserDefaults] objectForKey:@"selectTag"];
   
    NSInteger tags=[NSString isEmpty:tag]?100:[tag intValue];
    
    diction=@{@"startTime":st
              ,@"endTime":et
              ,@"tag":[NSString stringWithFormat:@"%zd",tags]
              ,@"select":[NSString stringWithFormat:@"%zd",self.screenIndex]};
    
    NSLog(@"diction:%@",diction);
    if ([self.delegate respondsToSelector:@selector(selectScreenCondition:)]) {
        
        [self.delegate selectScreenCondition:diction];
        [self dismiss];
        
    }
    
}

#pragma mark --事件点击
- (void)typeViewTap:(UITapGestureRecognizer *)tap{

    [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%zd",100+tap.view.tag] forKey:@"selectTag"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    for (int i=0; i<self.viewArray.count; i++) {
        
        UIView *vi=self.viewArray[i];
        NSArray *bb=vi.subviews;
        UIImageView *im=bb[0];
        im.image=[UIImage imageNamed:@"未选中"];
    }
    UIView *vi=self.viewArray[tap.view.tag];
    NSArray *bb=vi.subviews;
    UIImageView *im=bb[0];
    im.image=[UIImage imageNamed:@"选中"];
    
}


-(void)textFieldDidBeginEditing:(UITextField*)textField

{
    [textField resignFirstResponder];
    //1001  按照月来筛选  1000按照天来筛选
    
    WeakSelfType blockSelf=self;
    
    if (self.screenIndex==1001) {
        
        [DCDataPickerView showDatePickerWithTitle:@"选择日期" resultBlock:^(NSString *selectValue) {
           
            blockSelf.screenTextField.text = selectValue;
        }];
        
    }else{
    
        //[NSDate currentDateString]    不能大于当前天数
//        [BRDatePickerView showDatePickerWithTitle:@"选择日期" dateType:UIDatePickerModeDate defaultSelValue:blockSelf.beginTimeTextField.text minDateStr:@"" maxDateStr:@"" isAutoSelect:YES resultBlock:^(NSString *selectValue) {
//            if (textField.tag==11) {
//
//                blockSelf.beginTimeTextField.text = selectValue;
//            }else{
//
//                blockSelf.endTimeTextField.text = selectValue;
//            }
//
//        }];
        
        
        [BRDatePickerView showDatePickerWithTitle:@"选择日期" dateType:UIDatePickerModeDate defaultSelValue:blockSelf.beginTimeTextField.text minDate:nil maxDate:nil isAutoSelect:YES themeColor:[UIColor redColor] resultBlock:^(NSString *selectValue) {
            
            if (textField.tag==11) {
                
                blockSelf.beginTimeTextField.text = selectValue;
            }else{
                
                blockSelf.endTimeTextField.text = selectValue;
            }
        }];
    }
    
    
  
    
    
}


- (void)show {
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    
    _paymentAlert.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
    _paymentAlert.alpha = 0;
    
    
    [UIView animateWithDuration:.7f delay:0.f usingSpringWithDamping:.7f initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        _paymentAlert.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
        _paymentAlert.alpha = 1.0;
    } completion:nil];
}

- (void)dismiss {
    [UIView animateWithDuration:0.3f animations:^{
        _paymentAlert.transform = CGAffineTransformMakeScale(1.21f, 1.21f);
        _paymentAlert.alpha = 0;
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)viewClickTag:(UITapGestureRecognizer *)tap{
    
    [self dismiss];
}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}

//筛选条件
- (void)screenButtonClick:(UIButton *)sender{
    [sender setSelected:!sender.isSelected];
    NSLog(@"选择:%zd",self.screenIndex);
    if (sender.selected) {
        self.screenIndex=1001;
        [self.screenTextField setHidden:NO];
        [self.beginTimeTextField setHidden:YES];
        [self.endTimeTextField setHidden:YES];
        [self.l setHidden:YES];
    }else{
        self.screenIndex=1000;
        [self.screenTextField setHidden:YES];
        [self.beginTimeTextField setHidden:NO];
        [self.endTimeTextField setHidden:NO];
        [self.l setHidden:NO];
        
    }
}

@end

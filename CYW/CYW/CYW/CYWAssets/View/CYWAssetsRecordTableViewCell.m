//
//  CYWAssetsRecordTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/23.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsRecordTableViewCell.h"
@interface CYWAssetsRecordTableViewCell()
@property (nonatomic, retain) UILabel *weekslabel;
@property (nonatomic, retain) UILabel *weekslabel1;
@property (nonatomic, retain) UIImageView *iconImageView;
@property (nonatomic, retain) UILabel *iconlabel;
@property (nonatomic, retain) UILabel *moneylabel;
@property (nonatomic, retain) UILabel *statelabel;
@property (nonatomic, retain) NSDateFormatter* dateFormat;
@end
@implementation CYWAssetsRecordTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self weekslabel];
        [self weekslabel1];
        [self iconImageView];
        [self iconlabel];
        [self moneylabel];
        [self statelabel];
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(TransactViewModel *viewModel) {
        
        @strongify(self);
        
        //NSLog(@"type:%@",viewModel.type);
        
        self.statelabel.text=viewModel.type;
        [self.statelabel sizeToFit];
        
        
        
        NSDate *date=[self bb:viewModel.time];
        if ([NSObject isNotEmpty:date]) {
            
            self.weekslabel.text=[self weekdayStringFromDate:date];
            [self.weekslabel sizeToFit];
        }
        
        NSString *time=[self cTimestampFromString:viewModel.time];
        if ([NSString isNotEmpty:time]) {
            
            self.weekslabel1.text=[NSDate TimeStamp:time];
            [self.weekslabel1 sizeToFit];
        }
        
        
        self.iconlabel.text=viewModel.typeInfo;
        [self.iconlabel sizeToFit];
       
        
        
         self.iconImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@",viewModel.typeInfo]];
        
        if ([viewModel.typeInfo isEqualToString:@"transfer_buy"]) {
            
            self.iconlabel.text=@"债权转让";
            [self.iconlabel sizeToFit];
            
            self.iconImageView.image=[UIImage imageNamed:@"债权转让"];
        }
        if ([viewModel.typeInfo isEqualToString:@"use_coupon"]) {
            
            self.iconlabel.text=@"红包";
            [self.iconlabel sizeToFit];
            
            self.iconImageView.image=[UIImage imageNamed:@"现金红包"];
        }
        if ([viewModel.type isEqualToString:@"出账"]) {
            
            self.iconImageView.image=[UIImage imageNamed:@"出账记录"];
            
            
            self.moneylabel.text=[NSString stringWithFormat:@"-%@元",viewModel.moneyStr];
            [self.moneylabel sizeToFit];
            
            
            
        }else if ([viewModel.type isEqualToString:@"入账"]){
            
            
            
            self.moneylabel.text=[NSString stringWithFormat:@"+%@元",viewModel.moneyStr];
            [self.moneylabel sizeToFit];
            
            
        }else if ([viewModel.type isEqualToString:@"冻结"]){
            
            self.moneylabel.text=[NSString stringWithFormat:@"%@元",viewModel.moneyStr];
            [self.moneylabel sizeToFit];
            
            
        }
        else if ([viewModel.type isEqualToString:@"解冻"]){
            
            self.moneylabel.text=[NSString stringWithFormat:@"%@元",viewModel.moneyStr];
            [self.moneylabel sizeToFit];
            
        }
        else if ([viewModel.type isEqualToString:@"充值"]){
            
            self.moneylabel.text=[NSString stringWithFormat:@"+%@元",viewModel.moneyStr];
            [self.moneylabel sizeToFit];
            
            
        }
        else if ([viewModel.type isEqualToString:@"提现"]){
            
            self.moneylabel.text=[NSString stringWithFormat:@"-%@元",viewModel.moneyStr];
            [self.moneylabel sizeToFit];
            
        }
        else if ([viewModel.type isEqualToString:@"从余额转出"]){
            
            self.moneylabel.text=[NSString stringWithFormat:@"-%@元",viewModel.moneyStr];
            [self.moneylabel sizeToFit];
            
        }
        else if ([viewModel.type isEqualToString:@"转入到余额"]){
            
            self.moneylabel.text=[NSString stringWithFormat:@"+%@元",viewModel.moneyStr];
            [self.moneylabel sizeToFit];
            
        }
        
        else if ([viewModel.type isEqualToString:@"从冻结金额中转出"]){
            
            self.moneylabel.text=[NSString stringWithFormat:@"-%@元",viewModel.moneyStr];
            [self.moneylabel sizeToFit];
            
            
        }
        else if ([viewModel.type isEqualToString:@"transfer_buy"]){
            
            
            self.moneylabel.text=[NSString stringWithFormat:@"-%@元",viewModel.moneyStr];
            [self.moneylabel sizeToFit];
            
        }
    }];
    
}

- (UILabel *)weekslabel{
    if (!_weekslabel) {
        _weekslabel=[UILabel new];
        _weekslabel.text=@"星期一";
        _weekslabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _weekslabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [self.contentView addSubview:_weekslabel];
        _weekslabel.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(11))
        .topSpaceToView(self.contentView, CGFloatIn320(18))
        .heightIs(14);
        [_weekslabel setSingleLineAutoResizeWithMaxWidth:300];
        
    }
    return _weekslabel;
}
- (UILabel *)weekslabel1{
    if (!_weekslabel1) {
        _weekslabel1=[UILabel new];
        _weekslabel1.text=@"星期一";
        _weekslabel1.textColor=[UIColor colorWithHexString:@"#888888"];
        _weekslabel1.font=[UIFont systemFontOfSize:CGFloatIn320(10)];
        [self.contentView addSubview:_weekslabel1];
        _weekslabel1.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(11))
        .topSpaceToView(_weekslabel, CGFloatIn320(9))
        .heightIs(10);
        [_weekslabel1 setSingleLineAutoResizeWithMaxWidth:300];
        
    }
    return _weekslabel1;
}

- (UIImageView *)iconImageView{
    if (!_iconImageView) {
        
        _iconImageView=[UIImageView new];
        _iconImageView.layer.cornerRadius=CGFloatIn320(16);
        _iconImageView.layer.masksToBounds=YES;
        [self.contentView addSubview:_iconImageView];
        _iconImageView.sd_layout
        .leftSpaceToView(_weekslabel, CGFloatIn320(24))
        .centerYEqualToView(self.contentView)
        .widthIs(32)
        .heightIs(CGFloatIn320(32));
        
    }
    return _iconImageView;
}
- (UILabel *)iconlabel{
    if (!_iconlabel) {
        _iconlabel=[UILabel new];
        _iconlabel.text=@"正常还款";
        _iconlabel.textColor=[UIColor colorWithHexString:@"#333333"];
        _iconlabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        [self.contentView addSubview:_iconlabel];
        _iconlabel.sd_layout
        .leftSpaceToView(_iconImageView, CGFloatIn320(17))
        .centerYEqualToView(self.contentView)
        .heightIs(14);
        [_iconlabel setSingleLineAutoResizeWithMaxWidth:300];
        
    }
    return _iconlabel;
}

- (UILabel *)moneylabel{
    if (!_moneylabel) {
        _moneylabel=[UILabel new];
        _moneylabel.text=@"正常还款";
        _moneylabel.textColor=[UIColor colorWithHexString:@"#333333"];
        _moneylabel.font=[UIFont systemFontOfSize:CGFloatIn320(16)];
        [self.contentView addSubview:_moneylabel];
        _moneylabel.sd_layout
        .topSpaceToView(self.contentView, CGFloatIn320(18))
        .rightSpaceToView(self.contentView, CGFloatIn320(10))
        .heightIs(16);
        [_moneylabel setSingleLineAutoResizeWithMaxWidth:300];
        
    }
    return _moneylabel;
}

- (UILabel *)statelabel{
    if (!_statelabel) {
        _statelabel=[UILabel new];
        _statelabel.text=@"正常还款";
        _statelabel.textColor=[UIColor colorWithHexString:@"#333333"];
        _statelabel.font=[UIFont systemFontOfSize:CGFloatIn320(10)];
        [self.contentView addSubview:_statelabel];
        _statelabel.sd_layout
        .topSpaceToView(_moneylabel, CGFloatIn320(5))
        .rightSpaceToView(self.contentView, CGFloatIn320(10))
        .heightIs(10);
        [_statelabel setSingleLineAutoResizeWithMaxWidth:300];
        
    }
    return _statelabel;
}







-(NSString *)cTimestampFromString:(NSString *)theTime{
    //装换为时间戳
    //self.dateFormat = [[NSDateFormatter alloc] init];
    [self.dateFormat setDateStyle:NSDateFormatterMediumStyle];
    [self.dateFormat setTimeStyle:NSDateFormatterShortStyle];
    [self.dateFormat setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* dateTodo = [self.dateFormat dateFromString:theTime];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateTodo timeIntervalSince1970]];
    
    return timeSp;
}

- (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects:@"星期六",@"星期天", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五",@"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSCalendarUnitWeekday;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    //NSLog(@"wocao:%zd",theComponents.weekday);
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

- (NSDate *)bb:(NSString *)aa{
    
    //self.dateFormat = [[NSDateFormatter alloc] init];//实例化一个NSDateFormatter对象
    [self.dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSDate *date =[self.dateFormat dateFromString:aa];
    return date;
}

- (NSDateFormatter *)dateFormat{
    if (!_dateFormat) {
        
        _dateFormat=[[NSDateFormatter alloc] init];
    }
    return _dateFormat;
}
@end

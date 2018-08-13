//
//  CYWFinanceView.m
//  CYW
//
//  Created by jktz on 2017/11/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWFinanceView.h"
@interface CYWFinanceView()
@property (nonatomic, retain) UILabel *monthlabel;
@property (nonatomic, retain) UIImageView *backImageView;
@property (nonatomic, retain) UIImageView *auaterImageView;
@property (nonatomic, retain) UILabel *namelabel;
@property (nonatomic, retain) UILabel *phonelabel;
@property (nonatomic, retain) UILabel *moneylabel;
@property (nonatomic, retain) UILabel *yearlabel;


@end
@implementation CYWFinanceView

-(instancetype)initWithFrame:(CGRect)frame withBlock:(FinanceViewBlock)block{
    
    return [self initWithFrame:frame withBlocks:block];
}
- (instancetype)initWithFrame:(CGRect)frame withBlocks:(FinanceViewBlock)block{
    if (self=[super initWithFrame:frame]) {
        
        self.block = block;
        self.backgroundColor=[UIColor lightGrayColor];
        UIImageView *backImageView=[UIImageView new];
        backImageView.image=[[UIImage imageNamed:@"icon_finance_back"]stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        [self addSubview:backImageView];
        backImageView.sd_layout
        .widthIs(SCREEN_WIDTH)
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .bottomSpaceToView(self,45);
        [self monthlabel];
        [self backImageView];
        [self auaterImageView];
        [self namelabel];
        [self phonelabel];
        [self moneylabel];
        [self yearlabel];
        
        @weakify(self)
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"refresh" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
          
            
            @strongify(self)
            BankViewModel *model=(BankViewModel *)x.object[@"model"];
            self.phonelabel.text= [model.mobileNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
            
            self.moneylabel.text=[NSString strmethodComma:model.investByMonth];
            
            self.namelabel.text=[NSString stringWithFormat:@"%@%@",[model.realName substringToIndex:1],model.gender];
            [self.namelabel sizeToFit];
            
            
            [self.auaterImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,model.photo]] placeholder:[UIImage imageNamed:@"icon_avater"]];
            
        }];
    }
    return self;
}



- (UILabel *)monthlabel{
    
    if (!_monthlabel) {
        
        _monthlabel=[UILabel new];
        _monthlabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _monthlabel.textColor=[UIColor whiteColor];
        _monthlabel.text=[self month];
        [self addSubview:_monthlabel];
        _monthlabel.sd_layout
        .centerXEqualToView(self)
        .heightIs(14)
        .topSpaceToView(self, kDevice_Is_iPhoneX?CGFloatIn320(88+10):CGFloatIn320(64+10));
        [_monthlabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _monthlabel;
}

- (UIImageView *)backImageView{
    
    if (!_backImageView) {
        
        _backImageView=[UIImageView new];
        _backImageView.image=[UIImage imageNamed:@"icon_finance_backs"];
        [self addSubview:_backImageView];
        _backImageView.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(_monthlabel, 18)
        .widthIs(CGFloatIn320(215-50))
        .heightIs(CGFloatIn320(184-40));
    }
    return _backImageView;
}

- (UIImageView *)auaterImageView{
    
    if (!_auaterImageView) {
        
        _auaterImageView=[UIImageView new];
        _auaterImageView.layer.cornerRadius=50.0f;
        _auaterImageView.layer.masksToBounds=YES;
        _auaterImageView.layer.borderColor=[UIColor colorWithHexString:@"#666666"].CGColor;
        _auaterImageView.layer.borderWidth=2.0f;
        [self addSubview:_auaterImageView];
        _auaterImageView.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(_monthlabel, 22)
        .widthIs(100)
        .heightIs(100);
    }
    return _auaterImageView;
}
- (UILabel *)namelabel{
    
    if (!_namelabel) {
        
        _namelabel=[UILabel new];
        _namelabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _namelabel.textColor=[UIColor colorWithHexString:@"#ffc823"];
        _namelabel.text=@"xxxxx";
        [self addSubview:_namelabel];
        _namelabel.sd_layout
        .centerXEqualToView(self)
        .heightIs(12)
        .topSpaceToView(_backImageView, 13);
        [_namelabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _namelabel;
}

- (UILabel *)phonelabel{
    
    if (!_phonelabel) {
        
        _phonelabel=[UILabel new];
        _phonelabel.font=[UIFont systemFontOfSize:14];
        _phonelabel.textColor=[UIColor colorWithHexString:@"#ffc823"];
        _phonelabel.text=@"0";
        _phonelabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_phonelabel];
        _phonelabel.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .heightIs(14)
        .topSpaceToView(_namelabel, 10);
    }
    return _phonelabel;
}


- (UILabel *)moneylabel{
    
    if (!_moneylabel) {
        
        _moneylabel=[UILabel new];
        _moneylabel.font=[UIFont boldSystemFontOfSize:20];
        _moneylabel.textColor=[UIColor whiteColor];
        _moneylabel.text=@"0";
         _moneylabel.textAlignment=NSTextAlignmentCenter;
        [self addSubview:_moneylabel];
        _moneylabel.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_phonelabel, 20)
        .heightIs(25);
    }
    return _moneylabel;
}
- (UILabel *)yearlabel{
    
    if (!_yearlabel) {
        
        _yearlabel=[UILabel new];
        _yearlabel.font=[UIFont boldSystemFontOfSize:CGFloatIn320(11)];
        _yearlabel.textColor=[UIColor whiteColor];
        _yearlabel.text=@"在投本金";
        [self addSubview:_yearlabel];
        _yearlabel.sd_layout
        .centerXEqualToView(self)
        .heightIs(11)
        .topSpaceToView(_moneylabel, CGFloatIn320(10));
        [_yearlabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _yearlabel;
}




- (NSString *)month{
    
    NSDate *date =[NSDate date];//简书 FlyElephant
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"yyyy"];
    //NSInteger currentYear=[[formatter stringFromDate:date] integerValue];
    [formatter setDateFormat:@"MM"];
    NSInteger currentMonth=[[formatter stringFromDate:date]integerValue];
    [formatter setDateFormat:@"dd"];
    //NSInteger currentDay=[[formatter stringFromDate:date] integerValue];
    
    //NSLog(@"currentDate = %@ ,year = %ld ,month=%ld, day=%ld",date,currentYear,currentMonth,currentDay);
    return [NSString stringWithFormat:@"%zd月",currentMonth];
}

- (void)dealloc{
    NSLog(@"销毁");
}
@end

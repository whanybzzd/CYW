//
//  HomeNewStandCollectionViewCell.m
//  CYW
//
//  Created by jktz on 2018/5/22.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import "HomeNewStandCollectionViewCell.h"
#import "ZZCircleProgress.h"
@interface HomeNewStandCollectionViewCell()

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UILabel * sectionlabel;
@property (nonatomic, strong) UILabel *addresslabel;
@property (nonatomic, strong)  UIImageView *leftImageView;
@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) ZZCircleProgress *progress;
@property (nonatomic, strong) UILabel *timelabel;
@property (nonatomic, strong) UILabel *timelabel1;
@property (nonatomic, strong) UILabel *moneylabel;
@property (nonatomic, strong) UILabel *moneylabel1;
@property (nonatomic, strong) UILabel *progresslabel;
@property (nonatomic, strong) UILabel *progresslabel1;

@end
@implementation HomeNewStandCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        [self lineView];
        [self sectionlabel];
        [self addresslabel];
        [self leftImageView];
        [self button];
        [self progress];
        [self timelabel];
        [self timelabel1];
        [self moneylabel];
        [self moneylabel1];
        [self progresslabel];
        [self progresslabel1];
    }
    return self;
}

- (void)setModel:(ProjectViewModel *)model{
    
    
    _addresslabel.text=model.name;
    [_addresslabel sizeToFit];
    
    
    BaseViewController *currentView=(BaseViewController *)[UIView currentViewController];
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        [currentView pushViewController:@"CYWNowInvestmentViewController" withParams:@{@"id":model.id}];
        
        
    }];
    
    //[NSString stringWithFormat:@"%.2f%%",viewModel.jkRate *100.00];
    self.progress.progresslabel.text=[NSString stringWithFormat:@"%.1f%%",model.jkRate *100.00];//年化收益
    self.progress.progress = [model.jd floatValue]/100.0;//进度条
    UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc] init];
    [[tapView rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        [currentView pushViewController:@"CYWNowInvestmentViewController" withParams:@{@"id":model.id}];
        
    }];
    [self.progress addGestureRecognizer:tapView];
    
    
    NSString *str=[NSString stringWithFormat:@"%@%@",model.deadline,[model.repayTimeUnit isEqualToString:@"day"]?@"天":@"个月"];
    self.timelabel1.text=str;
    [self.timelabel1 sizeToFit];
    
    
    
    NSString *money= nil;
    if ([model.loanMoney floatValue]>10000) {
        
        money= [NSString stringWithFormat:@"%.0f万元",[model.loanMoney floatValue]/10000];//项目总额
    }else{
        
        money= [NSString stringWithFormat:@"%.0f元",[model.loanMoney floatValue]];//项目总额
    }
    self.moneylabel1.text=money;
    [self.moneylabel1 sizeToFit];
    
    
    NSString *progressl=[NSString stringWithFormat:@"%.1lf%%",[model.jd floatValue]];
    self.progresslabel1.text=progressl;
    [self.progresslabel1 sizeToFit];
    
}
- (UIView *)lineView{
    
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_lineView];
        _lineView.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .widthIs(1.0)
        .heightIs(16)
        .topSpaceToView(self.contentView, 10);
    }
    return _lineView;
}

- (UILabel *)sectionlabel{
    if (!_sectionlabel) {
        
        _sectionlabel=[UILabel new];
        _sectionlabel.text=@"新手标";
        _sectionlabel.font=[UIFont systemFontOfSize:16];
        _sectionlabel.textColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_sectionlabel];
        _sectionlabel.sd_layout
        .leftSpaceToView(_lineView, 5)
        .heightIs(16)
        .topSpaceToView(self.contentView, 10);
        [_sectionlabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _sectionlabel;
}

- (UILabel *)addresslabel{
    if (!_addresslabel) {
        
        _addresslabel=[UILabel new];
        
        _addresslabel.font=[UIFont systemFontOfSize:14];
        _addresslabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_addresslabel];
        _addresslabel.sd_layout
        .leftSpaceToView(_sectionlabel, 5)
        .heightIs(14)
        .topSpaceToView(self.contentView, 12);
        [_addresslabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH-115];
    }
    return _addresslabel;
}

- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        
        _leftImageView=[UIImageView new];
        _leftImageView.image=[UIImage imageNamed:@"icon_time"];
        [self.contentView addSubview:_leftImageView];
        _leftImageView.sd_layout
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .widthIs(44)
        .heightIs(44);
    }
    return _leftImageView;
}

- (UIButton *)button{
    if (!_button) {
        
        _button=[UIButton new];
        [_button setTitle:@"立即投标" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _button.titleLabel.font=[UIFont systemFontOfSize:15];
        [_button setBackgroundColor:[UIColor colorWithHexString:@"#f52735"]];
        [self.contentView addSubview:_button];
        _button.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .bottomSpaceToView(self.contentView, 10)
        .widthIs(SCREEN_WIDTH-30)
        .heightIs(40);
        
    }
    return _button;
}

- (ZZCircleProgress *)progress{
    
    if (!_progress) {
        
        _progress=[[ZZCircleProgress alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-100, 48,200,200) pathBackColor:nil pathFillColor:[UIColor redColor] startAngle:180 strokeWidth:10];
        _progress.userInteractionEnabled=YES;
        _progress.reduceValue = 180;
        _progress.increaseFromLast = YES;
        [self.contentView addSubview:_progress];
    }
    return _progress;
}


- (UILabel *)timelabel{
    if (!_timelabel) {
        
        _timelabel=[UILabel new];
        _timelabel.text=@"期限";
        _timelabel.font=[UIFont systemFontOfSize:14];
        _timelabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_timelabel];
        _timelabel.sd_layout
        .centerXEqualToView(self.contentView)
        .heightIs(14)
        .topSpaceToView(_progress, -90);
        [_timelabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _timelabel;
}

- (UILabel *)timelabel1{
    if (!_timelabel1) {
        
        _timelabel1=[UILabel new];
        _timelabel1.font=[UIFont systemFontOfSize:14];
        _timelabel1.textColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_timelabel1];
        _timelabel1.sd_layout
        .centerXEqualToView(self.contentView)
        .heightIs(14)
        .topSpaceToView(_timelabel, 10);
        [_timelabel1 setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _timelabel1;
}

- (UILabel *)moneylabel{
    
    if (!_moneylabel) {
        
        _moneylabel=[UILabel new];
        _moneylabel.text=@"借款金额";
        _moneylabel.font=[UIFont systemFontOfSize:14];
        _moneylabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_moneylabel];
        _moneylabel.sd_layout
        .leftSpaceToView(self.contentView, SCREEN_WIDTH/2-90)
        .heightIs(14)
        .topSpaceToView(_progress, -90);
        [_moneylabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _moneylabel;
}

- (UILabel *)moneylabel1{
    
    if (!_moneylabel1) {
        
        _moneylabel1=[UILabel new];
        _moneylabel1.font=[UIFont systemFontOfSize:14];
        _moneylabel1.textColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_moneylabel1];
        _moneylabel1.sd_layout
        .leftSpaceToView(self.contentView, SCREEN_WIDTH/2-95)
        .heightIs(14)
        .topSpaceToView(_moneylabel, 10);
        [_moneylabel1 setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _moneylabel1;
}

- (UILabel *)progresslabel{
    
    if (!_progresslabel) {
        
        _progresslabel=[UILabel new];
        _progresslabel.text=@"进度";
        _progresslabel.font=[UIFont systemFontOfSize:14];
        _progresslabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_progresslabel];
        _progresslabel.sd_layout
        .rightSpaceToView(self.contentView, 100)
        .heightIs(14)
        .topSpaceToView(_progress, -90);
        [_progresslabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _progresslabel;
}

- (UILabel *)progresslabel1{
    
    if (!_progresslabel1) {
        
        _progresslabel1=[UILabel new];
        _progresslabel1.font=[UIFont systemFontOfSize:14];
        _progresslabel1.textColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_progresslabel1];
        _progresslabel1.sd_layout
        .rightSpaceToView(self.contentView, 95)
        .heightIs(14)
        .topSpaceToView(_progresslabel, 10);
        [_progresslabel1 setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _progresslabel1;
}


@end

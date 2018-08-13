//
//  CYWAssetsEnvelopeTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/12.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsEnvelopeTableViewCell.h"
@interface CYWAssetsEnvelopeTableViewCell()
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) UIImageView *backImageView;
@property (nonatomic, retain) UILabel *investlabel;
@property (nonatomic, retain) UILabel *investlinelabel;
@property (nonatomic, retain) UILabel *investlineMoneylabel;

@property (nonatomic, retain) UILabel *investsourcelabel;
@property (nonatomic, retain) UILabel *investsourcelabel1;
@property (nonatomic, retain) UILabel *moneylabel1;
@property (nonatomic, retain) UILabel *nowlabel1;

@property (nonatomic, retain) UIImageView *timeImageView;
@property (nonatomic, retain) UILabel *timelabel;
@property (nonatomic, retain) UILabel *timedetailabel;

@property (nonatomic, retain) UIImageView *overdueImageView;

@end
@implementation CYWAssetsEnvelopeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self lineView];
        [self backImageView];
        [self investlabel];
        [self investlinelabel];
        [self investlineMoneylabel];
        [self investsourcelabel];
        [self investsourcelabel1];
        [self moneylabel1];
        [self nowlabel1];
        [self timeImageView];
        [self timelabel];
        [self timedetailabel];
        [self overdueImageView];
        [self setupSignal];
    }
    return self;
}

// 设置信号量，当cell的vm被重新赋值时，更新cell显示的数据
- (void)setupSignal {
    
    @weakify(self);
    [RACObserve(self, param) subscribeNext:^(NSDictionary *viewModel) {
        
        @strongify(self);
        
        
        self.timedetailabel.text = viewModel[@"deadline"];
        [self.timedetailabel sizeToFit];
        
        id object=viewModel[@"coupon"];
        id respon=[NSObject data:object modelName:@"EnvelopeViewModel"];
        EnvelopeViewModel *model=(EnvelopeViewModel *)respon;
        
        if ([model.type isEqualToString:@"discount"]) {//红包
            self.investlabel.text=@"投资红包";
            self.backImageView.image=[UIImage imageNamed:@"icon_assetsback"];
        }else{
            //加息
            self.investlabel.text=@"加息劵";
            self.backImageView.image=[UIImage imageNamed:@"icon_ gifted"];
        }
        
        
        
        self.investsourcelabel1.text=model.name;
        [self.investsourcelabel1 sizeToFit];
        
        NSString *money=nil;
        if (0==[model.lowerLimitMoney integerValue]) {
            
            money=@"无限";
        }else{
            money=model.lowerLimitMoney;
        }
        self.investlineMoneylabel.text=[NSString stringWithFormat:@">=%@",money];
        [self.investlineMoneylabel sizeToFit];
        
        if (2==[[[NSUserDefaults standardUserDefaults] objectForKey:@"key"] integerValue]) {
            
            [self.overdueImageView setHidden:NO];
            
            self.investlabel.textColor=[UIColor colorWithHexString:@"#cccccc"];
            self.moneylabel1.textColor=[UIColor colorWithHexString:@"#cccccc"];
            self.nowlabel1.textColor=[UIColor colorWithHexString:@"#cccccc"];
            self.investsourcelabel1.textColor=[UIColor colorWithHexString:@"#cccccc"];
            self.investlineMoneylabel.textColor=[UIColor colorWithHexString:@"#cccccc"];
            self.investlinelabel.textColor=[UIColor colorWithHexString:@"#cccccc"];
            self.investsourcelabel.textColor=[UIColor colorWithHexString:@"#cccccc"];
            self.timedetailabel.textColor=[UIColor colorWithHexString:@"#cccccc"];
            self.timelabel.textColor=[UIColor colorWithHexString:@"#cccccc"];
            
            if ([model.type isEqualToString:@"discount"]) {//红包
                
                self.moneylabel1.text= [NSString stringWithFormat:@"￥%@",model.money];
                [self.moneylabel1 sizeToFit];
                
            }else{
                
                self.moneylabel1.text= [NSString stringWithFormat:@"%@%%",model.money];
                [self.moneylabel1 sizeToFit];
            }
            
            
        }else if(1==[[[NSUserDefaults standardUserDefaults] objectForKey:@"key"] integerValue]) {
            
            [self.overdueImageView setHidden:YES];
            self.investlabel.textColor=[UIColor colorWithHexString:@"#888888"];
            self.moneylabel1.textColor=[UIColor colorWithHexString:@"#888888"];
            self.nowlabel1.textColor=[UIColor colorWithHexString:@"#888888"];
            self.investsourcelabel1.textColor=[UIColor colorWithHexString:@"#888888"];
            self.investlineMoneylabel.textColor=[UIColor colorWithHexString:@"#888888"];
            self.investlinelabel.textColor=[UIColor colorWithHexString:@"#888888"];
            self.investsourcelabel.textColor=[UIColor colorWithHexString:@"#888888"];
            self.timedetailabel.textColor=[UIColor colorWithHexString:@"#888888"];
            self.timelabel.textColor=[UIColor colorWithHexString:@"#888888"];
            
            if ([model.type isEqualToString:@"discount"]) {//红包
                
                self.moneylabel1.text= [NSString stringWithFormat:@"￥%@",model.money];
                [self.moneylabel1 sizeToFit];
                
            }else{
                
                self.moneylabel1.text= [NSString stringWithFormat:@"%@%%",model.money];
                [self.moneylabel1 sizeToFit];
            }
            
            
            
        }else{
            
            [self.overdueImageView setHidden:YES];
            
            
            
            self.investsourcelabel1.textColor=[UIColor colorWithHexString:@"#666666"];
            self.investlineMoneylabel.textColor=[UIColor colorWithHexString:@"#666666"];
            self.investlinelabel.textColor=[UIColor colorWithHexString:@"#666666"];
            self.investsourcelabel.textColor=[UIColor colorWithHexString:@"#666666"];
            self.timedetailabel.textColor=[UIColor colorWithHexString:@"#666666"];
            self.timelabel.textColor=[UIColor colorWithHexString:@"#666666"];
            
            
            if ([model.type isEqualToString:@"discount"]) {//红包
                
                self.investlabel.textColor=[UIColor colorWithHexString:@"#f52735"];
                self.nowlabel1.textColor=[UIColor colorWithHexString:@"#f52735"];
                
                
                self.moneylabel1.textColor=[UIColor colorWithHexString:@"#f52735"];
                
                
                self.moneylabel1.text= [NSString stringWithFormat:@"￥%@",model.money];
                [self.moneylabel1 sizeToFit];
                
            }else{
                
                self.investlabel.textColor=[UIColor colorWithHexString:@"#77a9fd"];
                self.nowlabel1.textColor=[UIColor colorWithHexString:@"#77a9fd"];
                
                self.moneylabel1.textColor=[UIColor colorWithHexString:@"#77a9fd"];
                
                
                NSString *str= [NSString stringWithFormat:@"%@%%",model.money];
               
                [self.moneylabel1 setAttributedText:[NSMutableAttributedString withTitleString:str RangeString:@"%" color:[UIColor colorWithHexString:@"#77a9fd"] withFont:[UIFont systemFontOfSize:CGFloatIn320(16)]]];
                
                 [self.moneylabel1 sizeToFit];
            }
        }
    }];
}




- (UIView *)lineView{
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self.contentView addSubview:_lineView];
        _lineView.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .heightIs(CGFloatIn320(10));
    }
    return _lineView;
}

- (UIImageView *)backImageView{
    
    if (!_backImageView) {
        
        _backImageView=[UIImageView new];
        _backImageView.image=[UIImage imageNamed:@"icon_assetsback"];
        [self.contentView addSubview:_backImageView];
        _backImageView.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(15))
        .rightSpaceToView(self.contentView, CGFloatIn320(15))
        .topSpaceToView(_lineView, 0)
        .bottomSpaceToView(self.contentView, 0);
    }
    return _backImageView;
}
- (UILabel *)investlabel{
    
    if (!_investlabel) {
        
        _investlabel=[UILabel new];
        _investlabel.text=@"投资红包";
        _investlabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _investlabel.textColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_investlabel];
        _investlabel.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(31))
        .topSpaceToView(_lineView, CGFloatIn320(17))
        .heightIs(17);
        [_investlabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _investlabel;
}

- (UILabel *)investlinelabel{
    
    if (!_investlinelabel) {
        
        _investlinelabel=[UILabel new];
        _investlinelabel.text=@"投资金额:";
        _investlinelabel.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        _investlinelabel.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_investlinelabel];
        _investlinelabel.sd_layout
        .leftEqualToView(_investlabel)
        .topSpaceToView(_investlabel, CGFloatIn320(8))
        .heightIs(11);
        [_investlinelabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _investlinelabel;
}
- (UILabel *)investlineMoneylabel{
    
    if (!_investlineMoneylabel) {
        
        _investlineMoneylabel=[UILabel new];
        _investlineMoneylabel.text=@">5000";
        _investlineMoneylabel.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        _investlineMoneylabel.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_investlineMoneylabel];
        _investlineMoneylabel.sd_layout
        .leftSpaceToView(_investlinelabel, CGFloatIn320(8))
        .topSpaceToView(_investlabel, CGFloatIn320(8))
        .heightIs(11);
        [_investlineMoneylabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _investlineMoneylabel;
}
- (UILabel *)investsourcelabel{
    
    if (!_investsourcelabel) {
        
        _investsourcelabel=[UILabel new];
        _investsourcelabel.text=@"描述:";
        _investsourcelabel.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        _investsourcelabel.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_investsourcelabel];
        _investsourcelabel.sd_layout
        .leftEqualToView(_investlabel)
        .topSpaceToView(_investlinelabel, CGFloatIn320(8))
        .heightIs(11);
        [_investsourcelabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _investsourcelabel;
}
- (UILabel *)investsourcelabel1{
    
    if (!_investsourcelabel1) {
        
        _investsourcelabel1=[UILabel new];
        _investsourcelabel1.text=@"描述十多万而违反斯蒂芬斯蒂芬";
        _investsourcelabel1.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        _investsourcelabel1.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_investsourcelabel1];
        _investsourcelabel1.sd_layout
        .leftSpaceToView(_investsourcelabel, CGFloatIn320(8))
        .topSpaceToView(_investlineMoneylabel, CGFloatIn320(8))
        .heightIs(11);
        [_investsourcelabel1 setSingleLineAutoResizeWithMaxWidth:220];
    }
    return _investsourcelabel1;
}
- (UILabel *)moneylabel1{
    
    if (!_moneylabel1) {
        
        _moneylabel1=[UILabel new];
        _moneylabel1.text=@"￥188";
        _moneylabel1.font=[UIFont systemFontOfSize:CGFloatIn320(20)];
        _moneylabel1.textColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_moneylabel1];
        _moneylabel1.sd_layout
        .rightSpaceToView(self.contentView, CGFloatIn320(50))
        .topSpaceToView(_lineView, CGFloatIn320(37))
        .heightIs(20);
        [_moneylabel1 setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _moneylabel1;
}

- (UILabel *)nowlabel1{
    
    if (!_nowlabel1) {
        
        _nowlabel1=[UILabel new];
        _nowlabel1.text=@"立即使用 >";
        _nowlabel1.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _nowlabel1.textColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_nowlabel1];
        _nowlabel1.sd_layout
        .rightSpaceToView(self.contentView, CGFloatIn320(27))
        .bottomSpaceToView(self.contentView, CGFloatIn320(15))
        .heightIs(14);
        [_nowlabel1 setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _nowlabel1;
}

- (UIImageView *)timeImageView{
    if (!_timeImageView) {
        
        _timeImageView=[UIImageView new];
        _timeImageView.image=[UIImage imageNamed:@"icon_timeinverst"];
        [self.contentView addSubview:_timeImageView];
        _timeImageView.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(24))
        .bottomSpaceToView(self.contentView, CGFloatIn320(16))
        .widthIs(CGFloatIn320(14))
        .heightIs(CGFloatIn320(14));
    }
    return _timeImageView;
}

- (UILabel *)timelabel{
    
    if (!_timelabel) {
        
        _timelabel=[UILabel new];
        _timelabel.text=@"有效期:";
        _timelabel.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        _timelabel.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_timelabel];
        _timelabel.sd_layout
        .leftSpaceToView(_timeImageView, CGFloatIn320(7))
        .bottomSpaceToView(self.contentView, CGFloatIn320(17))
        .heightIs(11);
        [_timelabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _timelabel;
}

- (UILabel *)timedetailabel{
    
    if (!_timedetailabel) {
        
        _timedetailabel=[UILabel new];
        _timedetailabel.text=@"2017-02-15~2018-06-22";
        _timedetailabel.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        _timedetailabel.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_timedetailabel];
        _timedetailabel.sd_layout
        .leftSpaceToView(_timelabel, CGFloatIn320(7))
        .bottomSpaceToView(self.contentView, CGFloatIn320(17))
        .heightIs(11);
        [_timedetailabel setSingleLineAutoResizeWithMaxWidth:220];
    }
    return _timedetailabel;
}

- (UIImageView *)overdueImageView{
    if (!_overdueImageView) {
        
        _overdueImageView=[UIImageView new];
        [_overdueImageView setHidden:YES];
        _overdueImageView.image=[UIImage imageNamed:@"icon_expired"];
        [self.contentView addSubview:_overdueImageView];
        _overdueImageView.sd_layout
        .rightSpaceToView(_moneylabel1, 0)
        .topSpaceToView(_lineView, 0)
        .widthIs(CGFloatIn320(117))
        .heightIs(CGFloatIn320(90));
    }
    return _overdueImageView;
}
@end

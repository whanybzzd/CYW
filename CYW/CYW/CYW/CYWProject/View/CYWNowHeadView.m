//
//  CYWNowHeadView.m
//  CYW
//
//  Created by jktz on 2017/10/30.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWNowHeadView.h"
#import "XTSegmentControl.h"
#import "PICircularProgressView.h"
@interface CYWNowHeadView()
@property (retain, nonatomic) UIView *sectionHeaderView;
@property (retain, nonatomic) PICircularProgressView * picView;
@property (retain, nonatomic) UILabel *timelabel;
@property (retain, nonatomic) UILabel *annualabel;
@property (retain, nonatomic) UIImageView *leftImageView;
@property (retain, nonatomic) UIImageView *rightImageView;

@property (retain, nonatomic) UILabel *borrowingmoneylabel;
@property (retain, nonatomic) UILabel *borrowinglabel;


@property (retain, nonatomic) UILabel *castmoneylabel;
@property (retain, nonatomic) UILabel *castlabel;
@end
@implementation CYWNowHeadView



- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        //self.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
        UIImageView *imageView=[UIImageView new];
        imageView.image=[UIImage imageNamed:@"项目详情1"];
        [self addSubview:imageView];
        imageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        self.height=CGFloatIn320(227);
        [self sectionHeaderView];
        [self picView];
        [self timelabel];
        [self annualabel];
        [self leftImageView];
        [self rightImageView];
        [self borrowingmoneylabel];
        [self borrowinglabel];
        [self castmoneylabel];
        [self castlabel];
        
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
    
}

- (void)withModel:(ProjectViewModel *)model{
    self.borrowinglabel.text=@"借款金额(元)";
    self.picView.progress=[model.jd floatValue]/100;
    
    
    self.borrowingmoneylabel.text=[NSString stringWithFormat:@"%.2lf",[model.loanMoney floatValue]];
    [self.borrowingmoneylabel sizeToFit];
    
    self.castmoneylabel.text=[NSString stringWithFormat:@"%.2lf",[model.sybj floatValue]];
    [self.castmoneylabel sizeToFit];
    
    NSString *day=[model.repayTimeUnit isEqualToString:@"day"]?@"天":@"个月";
    NSString *time=[NSString stringWithFormat:@"项目期限:%@%@",model.deadline,day];
    
    [self.timelabel setAttributedText:[NSMutableAttributedString withTitleString:time RangeString:day color:[UIColor whiteColor] withFont:[UIFont systemFontOfSize:CGFloatIn320(11)]]];
    [self.timelabel sizeToFit];
    
    NSString *an=[NSString stringWithFormat:@"预期年化:%.2f%%",model.jkRate * 100];
    
    [self.annualabel setAttributedText:[NSMutableAttributedString withTitleString:an RangeString:@"%" color:[UIColor whiteColor] withFont:[UIFont systemFontOfSize:CGFloatIn320(11)]]];
    [self.annualabel sizeToFit];
    
    
}

- (void)TransformModel:(TransferRepayViewModel *)model{
     self.borrowinglabel.text=@"债权金额(元)";
    self.picView.progress=[model.progress floatValue]/100;
    
    
    self.borrowingmoneylabel.text=[NSString stringWithFormat:@"%.2lf",[model.corpus floatValue]];
    [self.borrowingmoneylabel sizeToFit];
    
    self.castmoneylabel.text=[NSString stringWithFormat:@"%.2lf",[model.remainCorpus floatValue]];
    [self.castmoneylabel sizeToFit];
    
    NSString *day=[model.unit isEqualToString:@"天"]?@"天":@"个月";
    NSString *time=[NSString stringWithFormat:@"项目期限:%@%@",model.length,day];
    
    [self.timelabel setAttributedText:[NSMutableAttributedString withTitleString:time RangeString:day color:[UIColor whiteColor] withFont:[UIFont systemFontOfSize:CGFloatIn320(11)]]];
    [self.timelabel sizeToFit];
    
    NSString *an=[NSString stringWithFormat:@"预期年化:%.2f%%",[model.rate floatValue] * 100];
    
    [self.annualabel setAttributedText:[NSMutableAttributedString withTitleString:an RangeString:@"%" color:[UIColor whiteColor] withFont:[UIFont systemFontOfSize:CGFloatIn320(11)]]];
    [self.annualabel sizeToFit];
}


- (UILabel *)castmoneylabel{
    
    if (!_castmoneylabel) {
        
        _castmoneylabel=[UILabel new];
        _castmoneylabel.text=@"0.0";
        _castmoneylabel.textColor=[UIColor whiteColor];
        _castmoneylabel.font=[UIFont systemFontOfSize:CGFloatIn320(18)];
        [self addSubview:_castmoneylabel];
        _castmoneylabel.sd_layout
        .rightSpaceToView(self, CGFloatIn320(35))
        .bottomSpaceToView(_rightImageView, CGFloatIn320(10))
        .heightIs(18);
        [_castmoneylabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    
    return _castmoneylabel;
}

- (UILabel *)castlabel{
    
    if (!_castlabel) {
        
        _castlabel=[UILabel new];
        _castlabel.text=@"可投金额(元)";
        _castlabel.textColor=[UIColor whiteColor];
        _castlabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [self addSubview:_castlabel];
        _castlabel.sd_layout
        .rightSpaceToView(self, CGFloatIn320(35))
        .topSpaceToView(_castmoneylabel, CGFloatIn320(5))
        .heightIs(12);
        [_castlabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    
    return _castlabel;
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        
        _rightImageView=[UIImageView new];
        _rightImageView.image=[UIImage imageNamed:@"形状2副本"];
        [self addSubview:_rightImageView];
        _rightImageView.sd_layout
        .rightSpaceToView(self, CGFloatIn320(34))
        .leftSpaceToView(_picView, 0)
        .topSpaceToView(self, CGFloatIn320(105))
        .heightIs(CGFloatIn320(20));
    }
    return _rightImageView;
}


- (UILabel *)borrowingmoneylabel{
    
    if (!_borrowingmoneylabel) {
        
        _borrowingmoneylabel=[UILabel new];
        _borrowingmoneylabel.text=@"0.0";
        _borrowingmoneylabel.textColor=[UIColor whiteColor];
        _borrowingmoneylabel.font=[UIFont systemFontOfSize:CGFloatIn320(18)];
        [self addSubview:_borrowingmoneylabel];
        _borrowingmoneylabel.sd_layout
        .leftSpaceToView(self, CGFloatIn320(35))
        .bottomSpaceToView(_leftImageView, CGFloatIn320(10))
        .heightIs(18);
        [_borrowingmoneylabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    
    return _borrowingmoneylabel;
}
- (UILabel *)borrowinglabel{
    
    if (!_borrowinglabel) {
        
        _borrowinglabel=[UILabel new];
        _borrowinglabel.text=@"借款金额(元)";
        _borrowinglabel.textColor=[UIColor whiteColor];
        _borrowinglabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [self addSubview:_borrowinglabel];
        _borrowinglabel.sd_layout
        .leftSpaceToView(self, CGFloatIn320(35))
        .topSpaceToView(_borrowingmoneylabel, CGFloatIn320(5))
        .heightIs(12);
        [_borrowinglabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    
    return _borrowinglabel;
}

- (UIImageView *)leftImageView{
    if (!_leftImageView) {
        
        _leftImageView=[UIImageView new];
        _leftImageView.image=[UIImage imageNamed:@"形状2"];
        [self addSubview:_leftImageView];
        _leftImageView.sd_layout
        .leftSpaceToView(self, CGFloatIn320(34))
        .rightSpaceToView(_picView, 0)
        .topSpaceToView(self, CGFloatIn320(105))
        .heightIs(CGFloatIn320(20));
    }
    return _leftImageView;
}

- (UILabel *)annualabel{
    
    if (!_annualabel) {
        
        _annualabel=[UILabel new];
        _annualabel.text=@"期限:0.0%";
        _annualabel.textColor=[UIColor whiteColor];
        _annualabel.font=[UIFont systemFontOfSize:CGFloatIn320(13)];
        [self addSubview:_annualabel];
        _annualabel.sd_layout
        .rightSpaceToView(self, CGFloatIn320(80))
        .bottomSpaceToView(self, CGFloatIn320(65))
        .heightIs(13);
        [_annualabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    
    return _annualabel;
}

- (UILabel *)timelabel{
    
    if (!_timelabel) {
        
        _timelabel=[UILabel new];
        _timelabel.text=@"期限:0天";
        _timelabel.textColor=[UIColor whiteColor];
        _timelabel.font=[UIFont systemFontOfSize:CGFloatIn320(13)];
        [self addSubview:_timelabel];
        _timelabel.sd_layout
        .leftSpaceToView(self, CGFloatIn320(80))
        .bottomSpaceToView(self, CGFloatIn320(65))
        .heightIs(13);
        [_timelabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    
    return _timelabel;
}

- (PICircularProgressView *)picView{
    
    if (!_picView) {
        
        _picView=[[PICircularProgressView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-CGFloatIn320(55), CGFloatIn320(227)/2-CGFloatIn320(55)-40, CGFloatIn320(110), CGFloatIn320(110))];
        _picView.innerBackgroundColor = [UIColor clearColor];
        _picView.roundedHead = YES;
        _picView.textColor = [UIColor whiteColor];
        _picView.outerBackgroundColor = [UIColor lightTextColor];
        _picView.progressFillColor = [UIColor whiteColor];
        _picView.thicknessRatio = 0.05;
        _picView.progress = 0.0;
        _picView.textContentOff = 1.5;
        [self addSubview:_picView];
    }
    return _picView;
}

- (UIView *)sectionHeaderView{
    
    if (!_sectionHeaderView) {
        _sectionHeaderView = [[XTSegmentControl alloc] initWithFrame:CGRectMake(0, CGFloatIn320(227)-54, SCREEN_WIDTH, 54.0) Items:@[@"项目详情", @"投资记录"] selectedBlock:^(NSInteger index) {
            NSLog(@"index:%zd",index);
            
            BOOL section=index==0?NO:YES;
            if (self.nowHeadViewBook) {
                
                self.nowHeadViewBook(section);
            }
            
        }];
        [self addSubview:_sectionHeaderView];
        _sectionHeaderView.backgroundColor = [UIColor colorWithHexString:@"0xFFFFFF"];
    }
    return _sectionHeaderView;
}


@end

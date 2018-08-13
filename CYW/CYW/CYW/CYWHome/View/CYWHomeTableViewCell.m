//
//  CYWHomeTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/10.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWHomeTableViewCell.h"
#import "CycleView.h"
@interface CYWHomeTableViewCell()
@property (nonatomic, retain) UIView *topView;
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) UILabel *sectionlabel;
@property (nonatomic, retain) UILabel *addresslabel;
@property (nonatomic, retain) NSMutableArray *viewArray;
@property (nonatomic, retain) UILabel *earninglabel;//年收益
@property (nonatomic, retain) UILabel *termlabel;//期限
@property (nonatomic, retain) UILabel *interestlabel;//利率
@property (nonatomic, retain) CycleView *cycleView;
@property (nonatomic, retain) UILabel *pricelabel;
@end
@implementation CYWHomeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        self.viewArray=[NSMutableArray array];
        [self topView];
        [self lineView];
        [self sectionlabel];
        [self addresslabel];
        [self equial];
        [self earninglabel];
        [self termlabel];
        [self interestlabel];
        [self cycleView];
        [self setupSignal];
    }
    return self;
}

// 设置信号量，当cell的vm被重新赋值时，更新cell显示的数据
- (void)setupSignal {
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(ProjectViewModel *viewModel) {
        
        //NSLog(@"状态:%@",viewModel.status);
        @strongify(self);
        NSString *day=[viewModel.repayTimeUnit isEqualToString:@"day"]?@"天":@"个月";
        NSString *days=[NSString stringWithFormat:@"%@%@",viewModel.deadline,[viewModel.repayTimeUnit isEqualToString:@"day"]?@"天":@"个月"];
        
        
        [self.termlabel setAttributedText:[NSMutableAttributedString withTitleString:days RangeString:day color:[UIColor colorWithHexString:@"#333333"] withFont:[UIFont systemFontOfSize:CGFloatIn320(11)]]];
        [self.termlabel sizeToFit];
        
        self.addresslabel.text = viewModel.name;//名称
        [self.addresslabel sizeToFit];
        
        
        //项目收益
        NSString *money=nil;
        if ([viewModel.loanMoney floatValue]>10000) {
            
            money=[NSString stringWithFormat:@"%.0f万元",[viewModel.loanMoney floatValue]/10000];
            [self.earninglabel setAttributedText:[NSMutableAttributedString withTitleString:money RangeString:@"万元" color:[UIColor colorWithHexString:@"#f52735"] withFont:[UIFont systemFontOfSize:CGFloatIn320(11)]]];
        }else{
            
            money=[NSString stringWithFormat:@"%.0f元",[viewModel.loanMoney floatValue]];
            [self.earninglabel setAttributedText:[NSMutableAttributedString withTitleString:money RangeString:@"元" color:[UIColor colorWithHexString:@"#f52735"] withFont:[UIFont systemFontOfSize:CGFloatIn320(11)]]];
        }
        //self.earninglabel.text=money;
        [self.earninglabel sizeToFit];
        
        self.cycleView.progress=[viewModel.jd floatValue]/100.0;//进度条
        
        //价格
        NSString *sybjmoney=nil;
        if ([viewModel.sybj floatValue]>10000) {
            
            sybjmoney=[NSString stringWithFormat:@"剩余金额: %.2f万元",[viewModel.sybj floatValue]/10000];
        }else{
            
            sybjmoney=[NSString stringWithFormat:@"剩余金额: %.2f元",[viewModel.sybj floatValue]];
        }
        [self.pricelabel setAttributedText:[NSMutableAttributedString withTitleString:sybjmoney RangeString:@"剩余金额: " ormoreString:nil color:[UIColor colorWithHexString:@"888888"]]];
        [self.pricelabel sizeToFit];
        
        [self.interestlabel setAttributedText:[NSMutableAttributedString withTitleString:[NSString stringWithFormat:@"%.1f%%",viewModel.jkRate *100.00] RangeString:@"%" color:[UIColor colorWithHexString:@"#333333"] withFont:[UIFont systemFontOfSize:CGFloatIn320(11)]]];
        [self.interestlabel sizeToFit];
        

        
        NSString *states=nil;
        if ([viewModel.status isEqualToString:@"筹款中"]) {
            
            states=@"投标";
            [self.cycleView.button setTitle:states forState:UIControlStateNormal];
            self.cycleView.button.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
            self.cycleView.progressColor=[UIColor colorWithHexString:@"#f52735"];
            
        }
       else if ([viewModel.status isEqualToString:@"等待复核"]) {
            
            states=@"复核";
           self.cycleView.button.backgroundColor=[UIColor lightGrayColor];
           self.cycleView.progressColor=[UIColor whiteColor];
           [self.cycleView.button setTitle:states forState:UIControlStateNormal];
            
        }
       else if ([viewModel.status isEqualToString:@"已完结"]) {
            
            states=@"完结";
           self.cycleView.button.backgroundColor=[UIColor lightGrayColor];
           self.cycleView.progressColor=[UIColor whiteColor];
           [self.cycleView.button setTitle:states forState:UIControlStateNormal];
            
        }
       else if ([viewModel.status isEqualToString:@"还款中"]) {
            
            states=@"还款";
           self.cycleView.button.backgroundColor=[UIColor lightGrayColor];
           self.cycleView.progressColor=[UIColor whiteColor];
           [self.cycleView.button setTitle:states forState:UIControlStateNormal];
            
        }
        
        
        
    }];
    
    
}

//- (void)setTypeIndex:(NSInteger)typeIndex{
//    _typeIndex=typeIndex;
//   // NSLog(@"typeIndex:%zd",typeIndex);
//    if (0==typeIndex) {
//
//        self.sectionlabel.text=@"新手标";
//
//    }else if (1==typeIndex){
//
//        self.sectionlabel.text=@"房宝保";
//    }
//
//    [self.sectionlabel sizeToFit];
//}
#pragma mark --懒加载
- (UIView *)topView{
    if (!_topView) {
        
        _topView=[UIView new];
        _topView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self.contentView addSubview:_topView];
        _topView.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .heightIs(CGFloatIn320(10))
        .bottomSpaceToView(self.contentView, 0);
    }
    return _topView;
}

- (UIView *)lineView{
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_lineView];
        _lineView.sd_layout
        .leftSpaceToView(self.contentView, CGFloatIn320(15))
        .widthIs(1.0)
        .heightIs(16)
        .topSpaceToView(self.contentView, CGFloatIn320(10));
    }
    return _lineView;
}
- (UILabel *)sectionlabel{
    if (!_sectionlabel) {
        
        _sectionlabel=[UILabel new];
        _sectionlabel.text=@"房宝保";
        _sectionlabel.font=[UIFont systemFontOfSize:CGFloatIn320(16)];
        _sectionlabel.textColor=[UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_sectionlabel];
        _sectionlabel.sd_layout
        .leftSpaceToView(_lineView, CGFloatIn320(5))
        .heightIs(16)
        .topSpaceToView(self.contentView, CGFloatIn320(10));
        [_sectionlabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _sectionlabel;
}

- (UILabel *)addresslabel{
    if (!_addresslabel) {
        
        _addresslabel=[UILabel new];
        _addresslabel.text=@"色人生的范德萨发生大娃儿斯蒂芬斯蒂芬是的废物";
        _addresslabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _addresslabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_addresslabel];
        _addresslabel.sd_layout
        .leftSpaceToView(_sectionlabel, CGFloatIn320(5))
        .heightIs(14)
        .topSpaceToView(self.contentView, CGFloatIn320(12));
        [_addresslabel setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH-70];
    }
    return _addresslabel;
}

//画4个View 平等分
- (void)equial{
    
    CGFloat itemW=SCREEN_WIDTH/4;
    for (int i=0; i<4; i++) {
        
        UIView *view=[UIView new];
        [self.contentView addSubview:view];
        view.sd_layout
        .leftSpaceToView(self.contentView, i*itemW)
        .widthIs(itemW)
        .bottomSpaceToView(self.contentView, 20)
        .topSpaceToView(_addresslabel, 0);
        [self.viewArray addObject:view];
        
        //添加线条
        UIView *lineView=[UIView new];
        lineView.backgroundColor=[UIColor colorWithHexString:@"#dfdfdf"];
        [view addSubview:lineView];
        lineView.sd_layout
        .rightSpaceToView(view, 0)
        .topSpaceToView(view, CGFloatIn320(25))
        .bottomSpaceToView(view, CGFloatIn320(25))
        .widthIs(1);
        if (i==3) {
            
            [lineView setHidden:YES];
        }
    }
}

- (UILabel *)earninglabel{
    if (!_earninglabel) {
        
        UIView *view=self.viewArray[0];
        _earninglabel=[UILabel new];
        _earninglabel.text=@"17.5%";
        _earninglabel.font=[UIFont systemFontOfSize:CGFloatIn320(16)];
        _earninglabel.textColor=[UIColor colorWithHexString:@"#f52735"];
        [view addSubview:_earninglabel];
        _earninglabel.sd_layout
        .centerXEqualToView(view)
        .centerYEqualToView(view)
        .heightIs(CGFloatIn320(16));
        [_earninglabel setSingleLineAutoResizeWithMaxWidth:100];
        
        UILabel *label=[UILabel new];
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        label.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        label.text=@"借款金额";
        [view addSubview:label];
        label.sd_layout
        .centerXEqualToView(view)
        .topSpaceToView(_earninglabel, CGFloatIn320(10))
        .heightIs(12);
        [label setSingleLineAutoResizeWithMaxWidth:150];
    }
    return _earninglabel;
}

- (UILabel *)termlabel{
    if (!_termlabel) {
        
        UIView *view=self.viewArray[1];
        _termlabel=[UILabel new];
        _termlabel.text=@"30天";
        _termlabel.font=[UIFont systemFontOfSize:CGFloatIn320(16)];
        _termlabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [view addSubview:_termlabel];
        _termlabel.sd_layout
        .centerXEqualToView(view)
        .centerYEqualToView(view)
        .heightIs(CGFloatIn320(20));
        [_termlabel setSingleLineAutoResizeWithMaxWidth:100];
        
        UILabel *label=[UILabel new];
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        label.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        label.text=@"期限";
        [view addSubview:label];
        label.sd_layout
        .centerXEqualToView(view)
        .topSpaceToView(_termlabel, CGFloatIn320(10))
        .heightIs(12);
        [label setSingleLineAutoResizeWithMaxWidth:150];
    }
    return _termlabel;
}

- (UILabel *)interestlabel{
    if (!_interestlabel) {
        
        UIView *view=self.viewArray[2];
        _interestlabel=[UILabel new];
        _interestlabel.text=@"16.5%";
        _interestlabel.font=[UIFont systemFontOfSize:CGFloatIn320(16)];
        _interestlabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [view addSubview:_interestlabel];
        _interestlabel.sd_layout
        .centerXEqualToView(view)
        .centerYEqualToView(view)
        .heightIs(CGFloatIn320(20));
        [_interestlabel setSingleLineAutoResizeWithMaxWidth:100];
        
        UILabel *label=[UILabel new];
        label.textColor=[UIColor colorWithHexString:@"#888888"];
        label.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        label.text=@"预期年化";
        [view addSubview:label];
        label.sd_layout
        .centerXEqualToView(view)
        .topSpaceToView(_interestlabel, CGFloatIn320(10))
        .heightIs(12);
        [label setSingleLineAutoResizeWithMaxWidth:150];
    }
    return _interestlabel;
}
- (CycleView *)cycleView{
    if (!_cycleView) {
        
        UIView *view=self.viewArray[3];
        _cycleView=[CycleView new];
        _cycleView.progress=0.5;
        [view addSubview:_cycleView];
        _cycleView.sd_layout
        .centerXEqualToView(view)
        .widthIs(CGFloatIn320(50))
        .heightIs(CGFloatIn320(50))
        .centerYEqualToView(view);
        
        
    }
    return _cycleView;
}
- (UILabel *)pricelabel{
    
    if (!_pricelabel) {
        
        _pricelabel=[UILabel new];
        _pricelabel.textColor=[UIColor colorWithHexString:@"#f52735"];
        _pricelabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _pricelabel.text=@"3500元";
        [self.contentView addSubview:_pricelabel];
        _pricelabel.sd_layout
        .bottomSpaceToView(self.contentView, CGFloatIn320(15))
        .heightIs(12)
        .rightSpaceToView(self.contentView, CGFloatIn320(20));
        [_pricelabel setSingleLineAutoResizeWithMaxWidth:150];
    }
    return _pricelabel;
}
@end

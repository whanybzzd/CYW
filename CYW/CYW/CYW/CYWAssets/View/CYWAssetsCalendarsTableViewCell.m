//
//  CYWAssetsCalendarsTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/11/22.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsCalendarsTableViewCell.h"
@interface CYWAssetsCalendarsTableViewCell()
@property (retain, nonatomic)  UIView *lineView;
@property (retain, nonatomic)  UIView *lineView1;
@property (retain, nonatomic) UILabel *timelabel;
@property (retain, nonatomic) UILabel *moneylabel;
@property (retain, nonatomic) UILabel *dhmoneylabel;
@property (retain, nonatomic) UILabel *yhmoneylabel;

@property (retain, nonatomic) UILabel *dhinterestlabel;
@property (retain, nonatomic) UILabel *yhinterestlabel;

@property (retain, nonatomic)  UIView *lineView2;
@property (retain, nonatomic)  UIView *lineView3;

@end
@implementation CYWAssetsCalendarsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self lineView];
        [self lineView1];
        [self timelabel];
        [self moneylabel];
        [self dhmoneylabel];
        [self yhmoneylabel];
        [self dhinterestlabel];
        [self yhinterestlabel];
        
        [self lineView2];
        [self lineView3];
        
    }
    return self;
}

- (void)setDay:(NSString *)day{
    
    NSString *str=[NSString stringWithFormat:@"%@日还款(元):",day];
    [self.timelabel setAttributedText:[NSMutableAttributedString withTitleString:str RangeString:day ormoreString:nil color:[UIColor colorWithHexString:@"#eb4064"]]];
    
    [self.timelabel sizeToFit];
}


- (void)setMutableArray:(NSMutableArray *)mutableArray{
    
    
    NSString *dhmonty=[mutableArray firstObject][@"dymoney"];
    [self.dhmoneylabel setAttributedText:[NSMutableAttributedString withTitleString:[NSString stringWithFormat:@"待还本金(元):%@",dhmonty] RangeString:dhmonty ormoreString:nil color:[UIColor colorWithHexString:@"#333333"]]];
    
    [self.dhmoneylabel sizeToFit];
    
    
     NSString *yhmonty=[mutableArray firstObject][@"yhmonty"];
    [self.yhmoneylabel setAttributedText:[NSMutableAttributedString withTitleString:[NSString stringWithFormat:@"已还本金(元):%@",yhmonty] RangeString:yhmonty ormoreString:nil color:[UIColor colorWithHexString:@"#333333"]]];
    
    [self.yhmoneylabel sizeToFit];
    
    NSString *dyinster=[mutableArray firstObject][@"dyinster"];
    [self.dhinterestlabel setAttributedText:[NSMutableAttributedString withTitleString:[NSString stringWithFormat:@"待还利息(元):%@",dyinster] RangeString:dyinster ormoreString:nil color:[UIColor colorWithHexString:@"#333333"]]];
    
    [self.dhinterestlabel sizeToFit];
    
    
    NSString *yhinster=[mutableArray firstObject][@"yhinster"];
    [self.yhinterestlabel setAttributedText:[NSMutableAttributedString withTitleString:[NSString stringWithFormat:@"已还利息(元):%@",yhinster] RangeString:yhinster ormoreString:nil color:[UIColor colorWithHexString:@"#333333"]]];
    
    [self.yhinterestlabel sizeToFit];
    
    self.moneylabel.text=[[NSUserDefaults standardUserDefaults] objectForKey:@"money"];
    [self.moneylabel sizeToFit];
}


- (UIView *)lineView{
    
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor lightGrayColor];
        [self.contentView addSubview:_lineView];
        _lineView.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .heightIs(1);
    }
    return _lineView;
}
- (UIView *)lineView1{
    
    if (!_lineView1) {
        
        _lineView1=[UIView new];
        _lineView1.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self.contentView addSubview:_lineView1];
        _lineView1.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0)
        .heightIs(10);
    }
    return _lineView1;
}

- (UILabel *)timelabel{
    if (!_timelabel) {
        
        _timelabel=[UILabel new];
        _timelabel.font=[UIFont systemFontOfSize:14];
        _timelabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_timelabel];
        _timelabel.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 10)
        .heightIs(14);
        [_timelabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _timelabel;
}
- (UILabel *)moneylabel{
    if (!_moneylabel) {
        
        _moneylabel=[UILabel new];
        _moneylabel.font=[UIFont systemFontOfSize:20];
        _moneylabel.textColor=[UIColor colorWithHexString:@"#eb4064"];
        _moneylabel.text=@"42.55";
        [self.contentView addSubview:_moneylabel];
        _moneylabel.sd_layout
        .leftSpaceToView(_timelabel, 10)
        .topSpaceToView(self.contentView, 8)
        .heightIs(20);
        [_moneylabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _moneylabel;
}

- (UILabel *)dhmoneylabel{
    if (!_dhmoneylabel) {
        
        _dhmoneylabel=[UILabel new];
        _dhmoneylabel.font=[UIFont systemFontOfSize:12];
        _dhmoneylabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _dhmoneylabel.text=@"待还本金(元):0.00";
        [self.contentView addSubview:_dhmoneylabel];
        _dhmoneylabel.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .topSpaceToView(_timelabel, 21)
        .heightIs(12);
        [_dhmoneylabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _dhmoneylabel;
}
- (UILabel *)yhmoneylabel{
    if (!_yhmoneylabel) {
        
        _yhmoneylabel=[UILabel new];
        _yhmoneylabel.font=[UIFont systemFontOfSize:12];
        _yhmoneylabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _yhmoneylabel.text=@"已还本金(元):0.00";
        [self.contentView addSubview:_yhmoneylabel];
        _yhmoneylabel.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .topSpaceToView(_dhmoneylabel, 14)
        .heightIs(12);
        [_yhmoneylabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _yhmoneylabel;
}



- (UILabel *)dhinterestlabel{
    if (!_dhinterestlabel) {
        
        _dhinterestlabel=[UILabel new];
        _dhinterestlabel.font=[UIFont systemFontOfSize:12];
        _dhinterestlabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _dhinterestlabel.text=@"待还利息(元):0.00";
        [self.contentView addSubview:_dhinterestlabel];
        _dhinterestlabel.sd_layout
        .rightSpaceToView(self.contentView, 10)
        .topSpaceToView(_timelabel, 21)
        .heightIs(12);
        [_dhinterestlabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _dhinterestlabel;
}
- (UILabel *)yhinterestlabel{
    if (!_yhinterestlabel) {
        
        _yhinterestlabel=[UILabel new];
        _yhinterestlabel.font=[UIFont systemFontOfSize:12];
        _yhinterestlabel.textColor=[UIColor colorWithHexString:@"#888888"];
        _yhinterestlabel.text=@"已还利息(元):0.00";
        [self.contentView addSubview:_yhinterestlabel];
        _yhinterestlabel.sd_layout
        .rightSpaceToView(self.contentView, 10)
        .topSpaceToView(_dhinterestlabel, 14)
        .heightIs(12);
        [_yhinterestlabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _yhinterestlabel;
}


- (UIView *)lineView2{
    
    if (!_lineView2) {
        
        _lineView2=[UIView new];
        _lineView2.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self.contentView addSubview:_lineView2];
        _lineView2.sd_layout
        .centerXEqualToView(self.contentView)
        .topSpaceToView(_timelabel, 21)
        .widthIs(1)
        .heightIs(14);
    }
    return _lineView2;
}
- (UIView *)lineView3{
    
    if (!_lineView3) {
        
        _lineView3=[UIView new];
        _lineView3.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self.contentView addSubview:_lineView3];
        _lineView3.sd_layout
        .centerXEqualToView(self.contentView)
        .topSpaceToView(_dhinterestlabel, 14)
        .widthIs(1)
        .heightIs(14);
    }
    return _lineView3;
}
@end

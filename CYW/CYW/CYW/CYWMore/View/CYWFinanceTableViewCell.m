//
//  CYWFinanceTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/11/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWFinanceTableViewCell.h"
@interface CYWFinanceTableViewCell()
@property (nonatomic, retain) UILabel *numberlabel;
@property (nonatomic, retain) UIImageView *avaterImageView;
@property (nonatomic, retain) UILabel *phoneNumberlabel;
@property (nonatomic, retain) UILabel *numberlabels;
@property (nonatomic, retain) UILabel *moneylabel;
@property (nonatomic, retain) UILabel *statelabel;

@end
@implementation CYWFinanceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        
        [self numberlabel];
        [self avaterImageView];
        [self phoneNumberlabel];
        [self numberlabels];
        [self moneylabel];
        [self statelabel];
        [self initSubView];
    }
    return self;
    
}
- (void)initSubView{
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(BankViewModel *viewModel) {
        
        @strongify(self);
        
        [self.avaterImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,viewModel.photo]] placeholder:[UIImage imageNamed:@"icon_avater"]];
        
        
        self.phoneNumberlabel.text=[NSString stringWithFormat:@"%@%@",[viewModel.realName substringToIndex:1],viewModel.gender];
        [self.phoneNumberlabel sizeToFit];
        
        self.numberlabels.text=[NSString stringWithFormat:@"(%@)",[viewModel.mobileNumber stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"]];
        [self.numberlabels sizeToFit];
        
        self.moneylabel.text=[NSString strmethodComma:viewModel.investByMonth];
        [self.moneylabel sizeToFit];
        
    }];
    
    
    
}
- (void)setIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row>1) {
        self.numberlabel.text=[NSString stringWithFormat:@"%zd",indexPath.row+2];
        [self.numberlabel setHidden:NO];
    }else{
        
        [self.numberlabel setHidden:YES];
    }
}

- (UILabel *)numberlabel{
    
    if (!_numberlabel) {
        
        _numberlabel=[UILabel new];
        [_numberlabel setHidden:YES];
        _numberlabel.font=[UIFont systemFontOfSize:14];
        _numberlabel.textColor=[UIColor colorWithHexString:@"#333333"];
        _numberlabel.text=@"4";
        [self.contentView addSubview:_numberlabel];
        _numberlabel.sd_layout
        .leftSpaceToView(self.contentView, 15)
        .heightIs(14)
        .centerYEqualToView(self.contentView);
        [_numberlabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _numberlabel;
}

- (UIImageView *)avaterImageView{
    
    if (!_avaterImageView) {
        
        _avaterImageView=[UIImageView new];
        _avaterImageView.layer.cornerRadius=17.5f;
        _avaterImageView.layer.masksToBounds=YES;
        [self.contentView addSubview:_avaterImageView];
        _avaterImageView.sd_layout
        .centerYEqualToView(self.contentView)
        .leftSpaceToView(_numberlabel, 15)
        .widthIs(CGFloatIn320(35))
        .heightIs(CGFloatIn320(35));
    }
    return _avaterImageView;
}

- (UILabel *)phoneNumberlabel{
    
    if (!_phoneNumberlabel) {
        
        _phoneNumberlabel=[UILabel new];
        _phoneNumberlabel.font=[UIFont systemFontOfSize:14];
        _phoneNumberlabel.textColor=[UIColor colorWithHexString:@"#333333"];
        _phoneNumberlabel.text=@"王先森(177****8621)";
        [self.contentView addSubview:_phoneNumberlabel];
        _phoneNumberlabel.sd_layout
        .leftSpaceToView(_avaterImageView, 15)
        .heightIs(14)
        .centerYEqualToView(self.contentView);
        [_phoneNumberlabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _phoneNumberlabel;
}
- (UILabel *)numberlabels{
    
    if (!_numberlabels) {
        
        _numberlabels=[UILabel new];
        _numberlabels.font=[UIFont systemFontOfSize:14];
        _numberlabels.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_numberlabels];
        _numberlabels.sd_layout
        .leftSpaceToView(_phoneNumberlabel, 0)
        .heightIs(14)
        .centerYEqualToView(self.contentView);
        [_numberlabels setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _numberlabels;
}
- (UILabel *)moneylabel{
    
    if (!_moneylabel) {
        
        _moneylabel=[UILabel new];
        _moneylabel.font=[UIFont systemFontOfSize:14];
        _moneylabel.textColor=[UIColor colorWithHexString:@"#f3365e"];
        _moneylabel.text=@"20332001";
        [self.contentView addSubview:_moneylabel];
        _moneylabel.sd_layout
        .rightSpaceToView(self.contentView, 15)
        .heightIs(14)
        .topSpaceToView(self.contentView, 15);
        [_moneylabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _moneylabel;
}

- (UILabel *)statelabel{
    
    if (!_statelabel) {
        
        _statelabel=[UILabel new];
        _statelabel.font=[UIFont systemFontOfSize:12];
        _statelabel.textColor=[UIColor colorWithHexString:@"#999999"];
        _statelabel.text=@"在投本金";
        [self.contentView addSubview:_statelabel];
        _statelabel.sd_layout
        .rightSpaceToView(self.contentView, 15)
        .heightIs(12)
        .topSpaceToView(_moneylabel, 7);
        [_statelabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _statelabel;
}
@end

//
//  BankCarTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BankCarTableViewCell.h"
@interface BankCarTableViewCell()
@property (nonatomic, retain) UIImageView *carImageView;
@property (nonatomic, retain) UILabel *carlabel;

@end
@implementation BankCarTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self carImageView];
        [self carlabel];
        [self rightImageView];
        [self selectBtn];
        [self initSubView];
    }
    return self;
}

- (void)initSubView{
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(CarManagerMentViewModel *viewModel) {
        @strongify(self);
        
        NSString *bankNo = [viewModel.cardNo substringFromIndex:viewModel.cardNo.length - 4];
        self.carlabel.text = [NSString stringWithFormat:@"%@储蓄卡(** %@)",viewModel.bank,bankNo];
        [self.carlabel sizeToFit];
        
        
        self.carImageView.image = [UIImage imageNamed:viewModel.bankNo];
        if (!self.carImageView.image) {
            
            self.carImageView.image=[UIImage imageNamed:@"通用2"];
        }
        
    }];
    
    [[self.selectBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
      @strongify(self);
        self.isSelect = !self.isSelect;
        if (self.qhxSelectBlock) {
            self.qhxSelectBlock(self.isSelect,x.tag);
        }
        
        if (self.resultBlock) {
            
            self.resultBlock(self.indexPath);
        }
    }];
}

- (UIButton *)selectBtn{
    if (!_selectBtn) {
        
        _selectBtn=[UIButton new];
        _selectBtn.backgroundColor=[UIColor clearColor];
        [self.contentView addSubview:_selectBtn];
        _selectBtn.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 0);
    }
    return _selectBtn;
}


- (UIImageView *)carImageView{
    if (!_carImageView) {
        
        _carImageView=[UIImageView new];
        [self.contentView addSubview:_carImageView];
        _carImageView.layer.cornerRadius=CGFloatIn320(11.5);
        _carImageView.sd_layout
        .centerYEqualToView(self.contentView)
        .leftSpaceToView(self.contentView, CGFloatIn320(15))
        .widthIs(CGFloatIn320(22))
        .heightIs(CGFloatIn320(23));
    }
    return _carImageView;
}
- (UILabel *)carlabel{
    
    if (!_carlabel) {
        
        _carlabel=[UILabel new];
        _carlabel.text=@"中国建设银行卡(******369)";
        _carlabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _carlabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.contentView addSubview:_carlabel];
        _carlabel.sd_layout
        .heightIs(12)
        .centerYEqualToView(self.contentView)
        .leftSpaceToView(_carImageView, CGFloatIn320(10));
        [_carlabel setSingleLineAutoResizeWithMaxWidth:250];
    }
    return _carlabel;
}

- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        
        _rightImageView=[UIImageView new];
        [self.contentView addSubview:_rightImageView];
        _rightImageView.sd_layout
        .centerYEqualToView(self.contentView)
        .rightSpaceToView(self.contentView, CGFloatIn320(15))
        .widthIs(CGFloatIn320(19))
        .heightIs(CGFloatIn320(13));
    }
    return _rightImageView;
}
@end

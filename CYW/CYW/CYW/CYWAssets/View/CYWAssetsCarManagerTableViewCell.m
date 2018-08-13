//
//  CYWAssetsCarManagerTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsCarManagerTableViewCell.h"
@interface CYWAssetsCarManagerTableViewCell()
@property (nonatomic, retain) UIImageView *carmanagerImageView;
@property (nonatomic, retain) UILabel *carmanagerlabel;
@property (nonatomic, retain) UIImageView *carlogBackImageView;
@property (nonatomic, retain) UIImageView *carlogImageView;
@property (nonatomic, retain) UILabel *carlabel;
@property (nonatomic, retain) UILabel *savinglabel;
@property (nonatomic, retain) UIButton *deleteButton;
@end
@implementation CYWAssetsCarManagerTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self carmanagerImageView];
        [self carlogBackImageView];
        [self carlogImageView];
        [self carlabel];
        [self savinglabel];
        [self carmanagerlabel];
        [self deleteButton];
        
        [self initSubView];
    }
    return self;
    
}

- (void)initSubView{
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(CarManagerMentViewModel *viewModel) {
        
        @strongify(self);
        
        NSString *bankNo = [viewModel.cardNo substringFromIndex:viewModel.cardNo.length - 4];
        self.carmanagerlabel.text = [NSString stringWithFormat:@"**** **** **** %@",bankNo];
        [self.carmanagerlabel sizeToFit];
        
        
        self.carlabel.text = viewModel.bank;
        [self.carlabel sizeToFit];
        
        self.carlogImageView.image = [UIImage imageNamed:viewModel.bankNo];
        
        self.carmanagerImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_1",viewModel.bankNo]];
        
        if (!self.carmanagerImageView.image) {
            
            self.carmanagerImageView.image=[UIImage imageNamed:@"icon_tongyong"];
        }
        
        if (!self.carlogImageView.image) {
            
            self.carlogImageView.image=[UIImage imageNamed:@"通用2"];
        }
    }];
    
    
    [[self.deleteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
       @strongify(self)
        if (self.carmanagerTableViewCell) {
            
            self.carmanagerTableViewCell(self.indexPath);
        }
        
    }];
    
}

- (UIImageView *)carmanagerImageView{
    if (!_carmanagerImageView) {
        
        _carmanagerImageView=[UIImageView new];
        _carmanagerImageView.layer.cornerRadius=10.0f;
        [self.contentView addSubview:_carmanagerImageView];
        _carmanagerImageView.sd_layout
        .leftSpaceToView(self.contentView, 10)
        .rightSpaceToView(self.contentView, 10)
        .topSpaceToView(self.contentView, 10)
        .bottomSpaceToView(self.contentView, 10);
    }
    return _carmanagerImageView;
}


- (UIImageView *)carlogBackImageView{
    if (!_carlogBackImageView) {
        
        _carlogBackImageView=[UIImageView new];
        _carlogBackImageView.layer.cornerRadius=23.0f;
        _carlogBackImageView.backgroundColor=[UIColor whiteColor];
        [self.contentView addSubview:_carlogBackImageView];
        _carlogBackImageView.sd_layout
        .widthIs(CGFloatIn320(46))
        .heightIs(CGFloatIn320(46))
        .topSpaceToView(self.contentView, CGFloatIn320(16))
        .leftSpaceToView(self.contentView, CGFloatIn320(19));
    }
    return _carlogBackImageView;
}

- (UIImageView *)carlogImageView{
    if (!_carlogImageView) {
        
        _carlogImageView=[UIImageView new];
        _carlogImageView.layer.cornerRadius=21.0f;
        [self.contentView addSubview:_carlogImageView];
        _carlogImageView.sd_layout
        .widthIs(CGFloatIn320(42))
        .heightIs(CGFloatIn320(42))
        .topSpaceToView(self.contentView, CGFloatIn320(18))
        .leftSpaceToView(self.contentView, CGFloatIn320(21));
    }
    return _carlogImageView;
}

- (UILabel *)carlabel{
    
    if (!_carlabel) {
        
        _carlabel=[UILabel new];
        _carlabel.text=@"兴业银行";
        _carlabel.font=[UIFont systemFontOfSize:CGFloatIn320(18)];
        _carlabel.textColor=[UIColor whiteColor];
        [self.contentView addSubview:_carlabel];
        _carlabel.sd_layout
        .topSpaceToView(self.contentView, CGFloatIn320(28))
        .leftSpaceToView(_carlogImageView, CGFloatIn320(10))
        .heightIs(18);
        [_carlabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _carlabel;
}
- (UILabel *)savinglabel{
    
    if (!_savinglabel) {
        
        _savinglabel=[UILabel new];
        _savinglabel.text=@"储蓄卡";
        _savinglabel.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        _savinglabel.textColor=[UIColor whiteColor];
        [self.contentView addSubview:_savinglabel];
        _savinglabel.sd_layout
        .topSpaceToView(_carlabel, CGFloatIn320(8))
        .leftEqualToView(_carlabel)
        .heightIs(11);
        [_savinglabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _savinglabel;
}


- (UILabel *)carmanagerlabel{
    
    if (!_carmanagerlabel) {
        
        _carmanagerlabel=[UILabel new];
        _carmanagerlabel.text=@"**** **** **** 369";
        _carmanagerlabel.font=[UIFont systemFontOfSize:CGFloatIn320(18)];
        _carmanagerlabel.textColor=[UIColor colorWithHexString:@"#f1f1f1"];
        [self.contentView addSubview:_carmanagerlabel];
        _carmanagerlabel.sd_layout
        .topSpaceToView(_savinglabel, CGFloatIn320(15))
        .leftEqualToView(_savinglabel)
        .heightIs(18);
        [_carmanagerlabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _carmanagerlabel;
}


- (UIButton *)deleteButton{
    
    if (!_deleteButton) {
        
        _deleteButton=[UIButton new];
        [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        _deleteButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _deleteButton.backgroundColor=[UIColor clearColor];
        [_deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_deleteButton];
        _deleteButton.sd_layout
        .rightSpaceToView(self.contentView, CGFloatIn320(25))
        .bottomSpaceToView(self.contentView, CGFloatIn320(15))
        .widthIs(40)
        .heightIs(30);
    }
    return _deleteButton;
}
@end

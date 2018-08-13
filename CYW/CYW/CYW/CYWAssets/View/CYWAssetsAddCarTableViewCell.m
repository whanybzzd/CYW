//
//  CYWAssetsAddCarTableViewCell.m
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsAddCarTableViewCell.h"
@interface CYWAssetsAddCarTableViewCell()
@property (nonatomic, retain) UIImageView *carmanagerImageView;
@property (nonatomic, retain) UIImageView *caraddImageView;
@property (nonatomic, retain) UILabel *carmanagerlabel;
@end
@implementation CYWAssetsAddCarTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self carmanagerImageView];
        [self caraddImageView];
        [self carmanagerlabel];
        
        @weakify(self)
        UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc] init];
        [[tapView rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            @strongify(self)
            if (self.clickTableViewCell) {
                
                self.clickTableViewCell();
            }
        }];
        [self.caraddImageView addGestureRecognizer:tapView];
    }
    return self;
    
}
- (UIImageView *)carmanagerImageView{
    if (!_carmanagerImageView) {
        
        _carmanagerImageView=[UIImageView new];
        _carmanagerImageView.backgroundColor=[UIColor whiteColor];
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

- (UIImageView *)caraddImageView{
    if (!_caraddImageView) {
        
        _caraddImageView=[UIImageView new];
        _caraddImageView.userInteractionEnabled=YES;
        _caraddImageView.image=[UIImage imageNamed:@"icon_addmanager"];
        _caraddImageView.layer.cornerRadius=10.0f;
        [self.contentView addSubview:_caraddImageView];
        _caraddImageView.sd_layout
        .widthIs(CGFloatIn320(53))
        .heightIs(CGFloatIn320(53))
        .topSpaceToView(self.contentView, CGFloatIn320(15))
        .centerXEqualToView(self.contentView);
    }
    return _caraddImageView;
}


- (UILabel *)carmanagerlabel{
    
    if (!_carmanagerlabel) {
        
        _carmanagerlabel=[UILabel new];
        _carmanagerlabel.text=@"添加银行卡";
        _carmanagerlabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _carmanagerlabel.textColor=[UIColor colorWithHexString:@"#666666"];
        [self.contentView addSubview:_carmanagerlabel];
        _carmanagerlabel.sd_layout
        .centerXEqualToView(self.contentView)
        .topSpaceToView(_caraddImageView, CGFloatIn320(15))
        .heightIs(14);
        [_carmanagerlabel setSingleLineAutoResizeWithMaxWidth:100];
    }
    return _carmanagerlabel;
}
@end

//
//  CYWMoreUserCenterHeadView.m
//  CYW
//
//  Created by jktz on 2017/10/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreUserCenterHeadView.h"
@interface CYWMoreUserCenterHeadView()
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) UIImageView *backImageView;
@property (nonatomic, retain) UIImageView *avaterImageView;
@property (nonatomic, retain) UILabel *avaterlabel;
@property (nonatomic, retain) UIImageView *levImageView;
@property (nonatomic, retain) UIButton *editerButton;
@end
@implementation CYWMoreUserCenterHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.height=CGFloatIn320(190);
        [self lineView];
        [self backImageView];
        [self avaterImageView];
        [self avaterlabel];
        [self levImageView];
        [self editerButton];
        
        //[self initSubView];
    }
    return self;
}


- (void)initSubView{
    ParentModel *mo=(ParentModel *)[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserModel];
    if ([NSObject isNotEmpty:mo]) {
        
        self.levImageView.image=[UIImage imageNamed:mo.userLevel];//等级nickname
        
        self.avaterlabel.text=[NSString isEmpty:mo.username]?@"":mo.username;
        [self.avaterlabel sizeToFit];//photo
        
        [self.avaterImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,mo.photo]] placeholder:[UIImage imageNamed:@"icon_avater"]];
        
        
        UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc] init];
        [[tapView rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
            BaseViewController *viewController=(BaseViewController *)[UIView currentViewController];
            [viewController pushViewController:@"CYWMoreUserCenSetAutoViewController"];
        }];
        [self.avaterImageView addGestureRecognizer:tapView];
    }
    
    
    
}

- (UIView *)lineView{
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self addSubview:_lineView];
        _lineView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .bottomSpaceToView(self, 0)
        .heightIs(10);
    }
    return _lineView;
}

- (UIImageView *)backImageView{
    if (!_backImageView) {
        
        _backImageView=[UIImageView new];
        _backImageView.image=[UIImage imageNamed:@"icon_user_back"];
        [self addSubview:_backImageView];
        _backImageView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .bottomSpaceToView(_lineView, 0);
    }
    return _backImageView;
}

- (UIImageView *)avaterImageView{
    if (!_avaterImageView) {
        
        _avaterImageView=[UIImageView new];
        _avaterImageView.clipsToBounds=YES;
        _avaterImageView.userInteractionEnabled=YES;
        _avaterImageView.layer.cornerRadius=CGFloatIn320(40);
        [self addSubview:_avaterImageView];
        _avaterImageView.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(self, CGFloatIn320(44))
        .heightIs(CGFloatIn320(80))
        .widthIs(CGFloatIn320(80));
    }
    return _avaterImageView;
}

- (UILabel *)avaterlabel{
    if (!_avaterlabel) {
        
        _avaterlabel=[UILabel new];
        _avaterlabel.text=@"张先森";
        _avaterlabel.font=[UIFont systemFontOfSize:CGFloatIn320(16)];
        _avaterlabel.textColor=[UIColor whiteColor];
        [self addSubview:_avaterlabel];
        _avaterlabel.sd_layout
        .heightIs(16)
        .topSpaceToView(_avaterImageView, CGFloatIn320(9))
        .centerXEqualToView(self);
        [_avaterlabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _avaterlabel;
}

- (UIImageView *)levImageView{
    if (!_levImageView) {
        
        _levImageView=[UIImageView new];
        _levImageView.image=[UIImage imageNamed:@"V0"];
        [self addSubview:_levImageView];
        _levImageView.sd_layout
        .leftSpaceToView(_avaterlabel, CGFloatIn320(2))
        .topEqualToView(_avaterlabel)
        .widthIs(CGFloatIn320(15))
        .heightIs(CGFloatIn320(15));
    }
    return _levImageView;
}

- (UIButton *)editerButton{
    
    if (!_editerButton) {
        
        _editerButton=[UIButton new];
        [_editerButton setTitle:@"编辑" forState:UIControlStateNormal];
        _editerButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(10)];
        _editerButton.layer.borderColor=[UIColor whiteColor].CGColor;
        _editerButton.layer.borderWidth=1.0f;
        [_editerButton setHidden:YES];
        _editerButton.backgroundColor=[UIColor clearColor];
        _editerButton.layer.cornerRadius=CGFloatIn320(6.5);
        [self addSubview:_editerButton];
        _editerButton.sd_layout
        .centerXEqualToView(self)
        .topSpaceToView(_avaterlabel, CGFloatIn320(9))
        .widthIs(CGFloatIn320(41))
        .heightIs(CGFloatIn320(13));
    }
    return _editerButton;
}

@end

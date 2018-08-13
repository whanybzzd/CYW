//
//  CYWIntegralView.m
//  QHXPasswordTextField
//
//  Created by ZMJ on 2017/10/21.
//  Copyright © 2017年 com.yitong.cn. All rights reserved.
//

#import "CYWIntegralView.h"
@interface CYWIntegralView()
@property (nonatomic, retain) UIView *alertView;//65 57
@property (nonatomic, retain) UIView *gradeView;
@property (nonatomic, retain) UIImageView *gradeImageView;
@property (nonatomic, retain) UIImageView *rightImageView;

@property (nonatomic, retain) UILabel *congratulationslabel;//恭喜你
@property (nonatomic, retain) UILabel *mmbershiplabel;
@property (nonatomic, retain) UIImageView *shineView;
@property (nonatomic, retain) UILabel *privilegeslabel;
@property (nonatomic, retain) UILabel *managerlabel;
@property (nonatomic, retain) UILabel *embodimentlabel;
@property (nonatomic, retain) UILabel *velocitylabel;

@property (nonatomic, retain) UIButton *detailButton;
@property (nonatomic, retain) UIButton *submitButton;



@end
@implementation CYWIntegralView

- (id)initWithIntegralManagermentFree:(NSString *)free embodimentnumber:(NSString *)number velocity:(NSString *)velocity{
    if (self=[super init]) {
        
        
        self.backgroundColor = [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:0.3];
        [self addSubview:self.alertView];
        [self initSubView];
        
    }
    return self;
}

- (void)initSubView{
    
    ParentModel *mo=(ParentModel *)[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserModel];
    self.gradeImageView.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@副本",mo.userLevel]];//等级nickname
    
    [self.mmbershiplabel setAttributedText:[NSMutableAttributedString withTitleString:[NSString stringWithFormat:@"会有积分达到了%@分",mo.userPoint] RangeString:[NSString stringWithFormat:@"%@",mo.userPoint] ormoreString:nil color:[UIColor colorWithHexString:@"#f52735"]]];
    [self.mmbershiplabel sizeToFit];
    
    [self.managerlabel setAttributedText:[NSMutableAttributedString withTitleString:[NSString stringWithFormat:@"利息管理费:%@%%",mo.feeRateCut] RangeString:[NSString stringWithFormat:@"%@%%",mo.feeRateCut] ormoreString:nil color:[UIColor colorWithHexString:@"#f52735"]]];
    [self.managerlabel sizeToFit];
    
    
    [self.embodimentlabel setAttributedText:[NSMutableAttributedString withTitleString:[NSString stringWithFormat:@"当月免费提现次数:%@次",mo.withDrawFreeCount] RangeString:[NSString stringWithFormat:@"%@次",mo.withDrawFreeCount] ormoreString:nil color:[UIColor colorWithHexString:@"#f52735"]]];
     [self.embodimentlabel sizeToFit];
    
    
    [self.velocitylabel setAttributedText:[NSMutableAttributedString withTitleString:[NSString stringWithFormat:@"投资积分累计速度:%@倍",mo.acceleration] RangeString:[NSString stringWithFormat:@"%@倍",mo.acceleration] ormoreString:nil color:[UIColor colorWithHexString:@"#f52735"]]];
    [self.velocitylabel sizeToFit];
    
    
}
//知道了
- (UIButton *)submitButton{
    if (!_submitButton) {
        
        _submitButton=[[UIButton alloc] initWithFrame:CGRectMake(self.detailButton.frame.size.width+self.detailButton.frame.origin.x+16, self.alertView.frame.size.height-30-8, self.alertView.frame.size.width/2-16, 30)];
        [_submitButton setTitle:@"我知道了" forState:UIControlStateNormal];
        [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _submitButton.titleLabel.font=[UIFont systemFontOfSize:14];
        _submitButton.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
        [_submitButton addTarget:self action:@selector(submitButtonClick) forControlEvents:UIControlEventTouchUpInside];
        _submitButton.layer.cornerRadius=15;
        
    }
    return _submitButton;
}

//查看详情
- (UIButton *)detailButton{
    if (!_detailButton) {
        
        _detailButton=[[UIButton alloc] initWithFrame:CGRectMake(8, self.alertView.frame.size.height-30-8, self.alertView.frame.size.width/2-16, 30)];
        [_detailButton setTitle:@"查看积分详情" forState:UIControlStateNormal];
        [_detailButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        _detailButton.titleLabel.font=[UIFont systemFontOfSize:14];
        _detailButton.layer.borderColor=[UIColor lightGrayColor].CGColor;
        _detailButton.layer.borderWidth=1.0;
        _detailButton.layer.cornerRadius=15;
        [_detailButton addTarget:self action:@selector(detailButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _detailButton;
}

//投资积分累计速度

- (UILabel *)velocitylabel{
    if (!_velocitylabel) {
        
        CGSize size = [@"投资积分累计速度:1.4倍" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,nil]];
        _velocitylabel=[[UILabel alloc] initWithFrame:CGRectMake(self.alertView.frame.size.width/2-size.width/2, self.embodimentlabel.frame.origin.y+self.embodimentlabel.frame.size.height+10, size.width, 14  )];
        _velocitylabel.text=@"投资积分累计速度:1.4倍";
        _velocitylabel.font=[UIFont systemFontOfSize:14];
        _velocitylabel.textColor=[UIColor lightGrayColor];
    }
    return _velocitylabel;
}

//当月免费体现次数

- (UILabel *)embodimentlabel{
    if (!_embodimentlabel) {
        
        CGSize size = [@"当月免费体现次数:20次" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,nil]];
        _embodimentlabel=[[UILabel alloc] initWithFrame:CGRectMake(self.alertView.frame.size.width/2-size.width/2, self.managerlabel.frame.origin.y+self.managerlabel.frame.size.height+10, size.width, 14  )];
        _embodimentlabel.text=@"当月免费体现次数:20次";
        _embodimentlabel.font=[UIFont systemFontOfSize:14];
        _embodimentlabel.textColor=[UIColor lightGrayColor];
    }
    return _embodimentlabel;
}
//利息管理费

- (UILabel *)managerlabel{
    if (!_managerlabel) {
        
        CGSize size = [@"利息管理费:2%" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,nil]];
        _managerlabel=[[UILabel alloc] initWithFrame:CGRectMake(self.alertView.frame.size.width/2-size.width/2, self.privilegeslabel.frame.origin.y+self.privilegeslabel.frame.size.height+10, size.width, 14  )];
        _managerlabel.text=@"利息管理费:2%";
        _managerlabel.font=[UIFont systemFontOfSize:14];
        _managerlabel.textColor=[UIColor lightGrayColor];
    }
    return _managerlabel;
}



//会员特权
- (UILabel *)privilegeslabel{
    if (!_privilegeslabel) {
        
        CGSize size = [@"会员特权" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,nil]];
        _privilegeslabel=[[UILabel alloc] initWithFrame:CGRectMake(self.alertView.frame.size.width/2-size.width/2, self.shineView.frame.origin.y+self.shineView.frame.size.height, size.width, 14  )];
        _privilegeslabel.text=@"会员特权";
        _privilegeslabel.font=[UIFont systemFontOfSize:14];
        _privilegeslabel.textColor=[UIColor blackColor];
    }
    return _privilegeslabel;
}

//中间闪耀部分的View
- (UIImageView *)shineView{
    if (!_shineView) {
        
        _shineView=[[UIImageView alloc] initWithFrame:CGRectMake(self.alertView.frame.size.width/2-75, self.gradeView.frame.origin.y+10+self.gradeView.frame.size.height, 150, self.congratulationslabel.frame.size.height+self.mmbershiplabel.frame.size.height+40)];
        _shineView.image=[UIImage imageNamed:@"icon_ fireworks"];
        
    }
    return _shineView;
}
//会员积分达到了
- (UILabel *)mmbershiplabel{
    if (!_mmbershiplabel) {
        
        CGSize size = [@"会员积分达到了1999分" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,nil]];
        _mmbershiplabel=[[UILabel alloc] initWithFrame:CGRectMake(self.alertView.frame.size.width/2-size.width/2, self.congratulationslabel.frame.origin.y+10+self.congratulationslabel.frame.size.height, size.width, 14)];
        _mmbershiplabel.text=@"会员积分达到了1999分";
        _mmbershiplabel.font=[UIFont systemFontOfSize:14];
        _mmbershiplabel.textColor=[UIColor lightGrayColor];
    }
    return _mmbershiplabel;
}


//恭喜你
- (UILabel *)congratulationslabel{
    if (!_congratulationslabel) {
        
         CGSize size = [@"恭喜你!" sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16],NSFontAttributeName,nil]];
        _congratulationslabel=[[UILabel alloc] initWithFrame:CGRectMake(self.alertView.frame.size.width/2-size.width/2, self.gradeView.frame.origin.y+10+self.gradeView.frame.size.height, size.width, 16  )];
        _congratulationslabel.text=@"恭喜你!";
        _congratulationslabel.font=[UIFont systemFontOfSize:16];
        _congratulationslabel.textColor=[UIColor blackColor];
    }
    return _congratulationslabel;
}

//等级V6图片
- (UIImageView *)gradeImageView{
    
    if (!_gradeImageView) {
        
        _gradeImageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.gradeView.frame.size.width/2-16.5, self.gradeView.frame.size.height/2-15, 33, 30)];
//        /_gradeImageView.image;
        
    }
    return _gradeImageView;
}

//右边皇冠头像
- (UIImageView *)rightImageView{
    if (!_rightImageView) {
        
        _rightImageView=[[UIImageView alloc] initWithFrame:CGRectMake(self.alertView.frame.size.width-22, -20, 44, 41)];
        _rightImageView.image=[UIImage imageNamed:@"皇冠"];
    }
    return _rightImageView;
}

- (UIView *)gradeView{
    
    if (!_gradeView) {
        
        _gradeView=[[UIView alloc] initWithFrame:CGRectMake(self.alertView.frame.size.width/2-53, -53, 106, 95)];
        
        UIImageView *gradgeImageView=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _gradeView.frame.size.width, _gradeView.frame.size.height)];
        gradgeImageView.image=[UIImage imageNamed:@"icon_usercenter_topimg"];
        [_gradeView addSubview:gradgeImageView];
        
        [_gradeView addSubview:self.gradeImageView];
    }
    return _gradeView;
}

- (UIView *)alertView{
    
    if (!_alertView) {
        
        _alertView=[[UIView alloc] initWithFrame:CGRectMake(50, ([UIScreen mainScreen].bounds.size.height-260)/2-30, [UIScreen mainScreen].bounds.size.width-50*2,260)];
        _alertView.layer.cornerRadius=10;
        _alertView.backgroundColor=[UIColor whiteColor];
        [_alertView addSubview:self.gradeView];
        [_alertView addSubview:self.rightImageView];
        [_alertView addSubview:self.congratulationslabel];
        [_alertView addSubview:self.mmbershiplabel];
        [_alertView addSubview:self.shineView];
        [_alertView addSubview:self.privilegeslabel];
        [_alertView addSubview:self.managerlabel];
        [_alertView addSubview:self.embodimentlabel];
        [_alertView addSubview:self.velocitylabel];
        [_alertView addSubview:self.detailButton];
        [_alertView addSubview:self.submitButton];
        
    }
    return _alertView;
}

- (void)show{
    self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.alertView.alpha = 0.0;
    [UIView animateWithDuration:0.4 animations:^{
        self.alertView.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)hide{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)submitButtonClick{
    
    [self hide];
}

- (void)detailButtonClick{
    
    BaseViewController *baseViewController=(BaseViewController *)[UIView currentViewController];
    [baseViewController pushViewController:@"CYWMoreUserCenterIntegralViewController"];
    [self hide];
}
@end

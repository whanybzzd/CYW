//
//  CYWAssetsTableHeadView.m
//  CYW
//
//  Created by jktz on 2017/10/12.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsTableHeadView.h"
@interface CYWAssetsTableHeadView(){
    
    NSTimer *_balanceLabelAnimationTimer;
}
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *avaterImageView;
@property (nonatomic, strong) UIImageView *levImageView;
@property (nonatomic, strong) UILabel *namelabel;
@property (nonatomic, strong) UILabel *totalabel;
@property (nonatomic, strong) UILabel *totalabel1;
@property (nonatomic, strong) UILabel *totamoneylabel1;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UILabel *cumulativelabel;
@property (nonatomic, strong) UILabel *cumulativelabel1;
@property (nonatomic, strong) UILabel *cumulativelabel2;

@property (nonatomic, strong) UILabel *collectionlabel;
@property (nonatomic, strong) UILabel *collectionlabel1;
@property (nonatomic, strong) UILabel *collectionlabel2;

@property (nonatomic, strong) UILabel *available;
@property (nonatomic, strong) UILabel *available1;
@property (nonatomic, strong) UIButton *cashButton;//提现
@property (nonatomic, strong) UIButton *rechargeButton;//提现
@property (nonatomic, strong) UIView *lineView2;

@end
@implementation CYWAssetsTableHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        
        self.backgroundColor=[UIColor whiteColor];
        self.height=CGFloatIn320(334);
        [self topView];
        [self avaterImageView];
        [self namelabel];
        [self levImageView];
        [self totalabel];
        [self totalabel1];
        [self totamoneylabel1];
        [self lineView];
        [self leftView];
        [self rightView];
        [self cumulativelabel];
        [self cumulativelabel1];
        [self cumulativelabel2];
        
        [self collectionlabel];
        [self collectionlabel1];
        [self collectionlabel2];
        
        [self available];
        [self available1];
        
        [self rechargeButton];
        [self cashButton];
        
        [self lineView2];
        [self initSubView];
        
    }
    return self;
}
- (void)initSubViews{
    
    NSObject *centerModel= [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserCenterInfoModel];
    if ([NSObject isNotEmpty:centerModel]) {
        
        UserCenterInfoViewModel *model=(UserCenterInfoViewModel *)centerModel;
        //self.totamoneylabel1.text=model.mySum;//总投资
        //[self.totamoneylabel1 sizeToFit];
        [self setNumberTextOfLabel:self.totamoneylabel1 WithAnimationForValueContent:[model.mySum floatValue]];
        
        self.cumulativelabel2.text=model.myInvestsInterest;//累计收益
        [self.cumulativelabel2 sizeToFit];
        
        self.collectionlabel2.text=model.dsje;//代收金额
        [self.collectionlabel2 sizeToFit];
        
        self.available.text=model.balcance;//可用金额
        [self.available sizeToFit];
        
        ParentModel *mo=(ParentModel *)[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserModel];
        
        self.levImageView.image=[UIImage imageNamed:mo.userLevel];//等级nickname
        self.namelabel.text=[NSString isEmpty:mo.username]?@"":mo.username;
        [self.namelabel sizeToFit];//photo
        
        [self.avaterImageView yy_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,mo.photo]] placeholder:[UIImage imageNamed:@"icon_avater"]];
        
    }
}


- (void)initSubView{

    
    
    BaseViewController *viewController=(BaseViewController *)[UIView currentViewController];
    [[self.rechargeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        //当用户如果没有实名认证  先去实名认证
        id object=[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserAuthentication];
        if ([NSObject isEmpty:object]) {
            
            [viewController pushViewController:@"CYWMoreUserCenterAuthenticationViewController"];
        }else{
            
            //充值
            [viewController pushViewController:@"CYWAssetsWithdrawalsViewController" withParams:@{@"type":@"1"}];
        }
        
    }];
    
    [[self.cashButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        //当用户如果没有实名认证  先去实名认证
        id object=[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserAuthentication];
        if ([NSObject isEmpty:object]) {
            
            [viewController pushViewController:@"CYWMoreUserCenterAuthenticationViewController"];
        }else{
            
            //提现
            [viewController pushViewController:@"CYWAssetsWithdrawalsViewController" withParams:@{@"type":@"2"}];
        }
        
    }];
    
}


#pragma mark -- 添加支付数字动画
- (void)setNumberTextOfLabel:(UILabel *)label WithAnimationForValueContent:(CGFloat)value
{
    
    CGFloat lastValue = [label.text floatValue];
    CGFloat delta = value - lastValue;
    if (delta == 0) {
        
        return;
    }
    
    if (delta > 0) {
        
        CGFloat ratio = value / 60.0;
        
        NSDictionary *userInfo = @{@"label" : label,
                                   @"value" : @(value),
                                   @"ratio" : @(ratio)
                                   };
        _balanceLabelAnimationTimer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:self selector:@selector(setupLabel:) userInfo:userInfo repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:_balanceLabelAnimationTimer forMode:NSRunLoopCommonModes];
    }
}

- (void)setupLabel:(NSTimer *)timer
{
    
    NSDictionary *userInfo = timer.userInfo;
    UILabel *label = userInfo[@"label"];
    CGFloat value = [userInfo[@"value"] floatValue];
    CGFloat ratio = [userInfo[@"ratio"] floatValue];
    static int flag = 1;
    CGFloat lastValue = [label.text floatValue];
    CGFloat randomDelta = (arc4random_uniform(2) + 1) * ratio;
    CGFloat resValue = lastValue + randomDelta;
    
    if ((resValue >= value) || (flag == 50)) {
        label.text = [NSString stringWithFormat:@"%.2f", value];
        flag = 1;
        [timer invalidate];
        timer = nil;
        return;
    } else {
        label.text = [NSString stringWithFormat:@"%.2f", resValue];
    }
    
    flag++;
}


#pragma mark --懒加载
- (UIView *)topView{
    if (!_topView) {
        
        _topView=[UIView new];
        //_topView.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
        [self addSubview:_topView];
        _topView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .heightIs(CGFloatIn320(260));
        
        UIImageView *imageView=[UIImageView new];
        imageView.image=[UIImage imageNamed:@"个人资产1"];
        [_topView addSubview:imageView];
        imageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }
    return _topView;
}

- (UIImageView *)avaterImageView{
    if (!_avaterImageView) {
        
        _avaterImageView=[UIImageView new];
        _avaterImageView.image=[UIImage imageNamed:@"icon_avater"];
        _avaterImageView.clipsToBounds=YES;
        _avaterImageView.userInteractionEnabled=YES;
        _avaterImageView.layer.cornerRadius=CGFloatIn320(15.5);
        [_topView addSubview:_avaterImageView];
        _avaterImageView.sd_layout
        .leftSpaceToView(_topView, CGFloatIn320(15))
        .topSpaceToView(_topView, CGFloatIn320(kDevice_Is_iPhoneX?55:27))
        .widthIs(CGFloatIn320(31))
        .heightIs(CGFloatIn320(31));
    }
    return _avaterImageView;
}

- (UILabel *)namelabel{
    if (!_namelabel) {
        
        _namelabel=[UILabel new];
        _namelabel.text=@"张先森";
        _namelabel.font=[UIFont systemFontOfSize:CGFloatIn320(16)];
        _namelabel.textColor=[UIColor whiteColor];
        [_topView addSubview:_namelabel];
        _namelabel.sd_layout
        .leftSpaceToView(_avaterImageView, CGFloatIn320(7))
        .heightIs(16)
        .topSpaceToView(_topView, CGFloatIn320(kDevice_Is_iPhoneX?62:34));
        [_namelabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _namelabel;
}

- (UIImageView *)levImageView{
    if (!_levImageView) {
        
        _levImageView=[UIImageView new];
        _levImageView.image=[UIImage imageNamed:@"V0"];
        [_topView addSubview:_levImageView];
        _levImageView.sd_layout
        .leftSpaceToView(_namelabel, CGFloatIn320(15))
        .topEqualToView(_namelabel)
        .widthIs(CGFloatIn320(15))
        .heightIs(CGFloatIn320(15));
    }
    return _levImageView;
}

- (UILabel *)totalabel{
    if (!_totalabel) {
        
        _totalabel=[UILabel new];
        _totalabel.text=@"总资产";
        _totalabel.font=[UIFont systemFontOfSize:CGFloatIn320(18)];
        _totalabel.textColor=[UIColor whiteColor];
        [_topView addSubview:_totalabel];
        _totalabel.sd_layout
        .centerXEqualToView(_topView)
        .heightIs(18)
        .topSpaceToView(_topView, CGFloatIn320(88));
        [_totalabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _totalabel;
}
- (UILabel *)totalabel1{
    if (!_totalabel1) {
        
        _totalabel1=[UILabel new];
        _totalabel1.text=@"(元)";
        _totalabel1.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _totalabel1.textColor=[UIColor whiteColor];
        [_topView addSubview:_totalabel1];
        _totalabel1.sd_layout
        .leftSpaceToView(_totalabel, 3)
        .heightIs(12)
        .topSpaceToView(_topView, CGFloatIn320(90));
        [_totalabel1 setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _totalabel1;
}

- (UILabel *)totamoneylabel1{
    if (!_totamoneylabel1) {
        
        _totamoneylabel1=[UILabel new];
        _totamoneylabel1.text=@"0.0";
        _totamoneylabel1.font=[UIFont systemFontOfSize:CGFloatIn320(34)];
        _totamoneylabel1.textColor=[UIColor whiteColor];
        [_topView addSubview:_totamoneylabel1];
        _totamoneylabel1.sd_layout
        .centerXEqualToView(_topView)
        .heightIs(34)
        .topSpaceToView(_totalabel, CGFloatIn320(13));
        [_totamoneylabel1 setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _totamoneylabel1;
}
- (UIView *)lineView{
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
        [_topView addSubview:_lineView];
        _lineView.sd_layout
        .centerXEqualToView(_topView)
        .bottomSpaceToView(_topView, CGFloatIn320(27))
        .topSpaceToView(_totamoneylabel1, CGFloatIn320(27))
        .widthIs(1.0);
        
    }
    return _lineView;
}

- (UIView *)leftView{
    if (!_leftView) {
        
        _leftView=[UIView new];
        [_topView addSubview:_leftView];
        _leftView.sd_layout
        .bottomSpaceToView(_topView, CGFloatIn320(27))
        .topSpaceToView(_totamoneylabel1, CGFloatIn320(27))
        .leftSpaceToView(_topView, 0)
        .rightSpaceToView(_lineView, 0);
        
    }
    return _leftView;
}

- (UIView *)rightView{
    if (!_rightView) {
        
        _rightView=[UIView new];
        [_topView addSubview:_rightView];
        _rightView.sd_layout
        .bottomSpaceToView(_topView, CGFloatIn320(27))
        .topSpaceToView(_totamoneylabel1, CGFloatIn320(27))
        .leftSpaceToView(_lineView, 0)
        .rightSpaceToView(_topView, 0);
        
    }
    return _rightView;
}

- (UILabel *)cumulativelabel{
    if (!_cumulativelabel) {
        
        _cumulativelabel=[UILabel new];
        _cumulativelabel.textColor=[UIColor whiteColor];
        _cumulativelabel.text=@"累计收益";
        _cumulativelabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [_leftView addSubview:_cumulativelabel];
        _cumulativelabel.sd_layout
        .centerXEqualToView(_leftView)
        .heightIs(12)
        .topSpaceToView(_leftView, CGFloatIn320(5));
        [_cumulativelabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _cumulativelabel;
}

- (UILabel *)cumulativelabel1{
    if (!_cumulativelabel1) {
        
        _cumulativelabel1=[UILabel new];
        _cumulativelabel1.textColor=[UIColor whiteColor];
        _cumulativelabel1.text=@"(元)";
        _cumulativelabel1.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        [_leftView addSubview:_cumulativelabel1];
        _cumulativelabel1.sd_layout
        .leftSpaceToView(_cumulativelabel, 0)
        .heightIs(11)
        .topSpaceToView(_leftView, CGFloatIn320(6));
        [_cumulativelabel1 setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _cumulativelabel1;
}

- (UILabel *)cumulativelabel2{
    if (!_cumulativelabel2) {
        
        _cumulativelabel2=[UILabel new];
        _cumulativelabel2.textColor=[UIColor whiteColor];
        _cumulativelabel2.text=@"0.00";
        _cumulativelabel2.font=[UIFont systemFontOfSize:CGFloatIn320(21)];
        [_leftView addSubview:_cumulativelabel2];
        _cumulativelabel2.sd_layout
        .centerXEqualToView(_leftView)
        .heightIs(21)
        .topSpaceToView(_cumulativelabel, CGFloatIn320(10));
        [_cumulativelabel2 setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _cumulativelabel2;
}

/////////////////////////
- (UILabel *)collectionlabel{
    if (!_collectionlabel) {
        
        _collectionlabel=[UILabel new];
        _collectionlabel.textColor=[UIColor whiteColor];
        _collectionlabel.text=@"待收合计";
        _collectionlabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [_rightView addSubview:_collectionlabel];
        _collectionlabel.sd_layout
        .centerXEqualToView(_rightView)
        .heightIs(12)
        .topSpaceToView(_rightView, CGFloatIn320(5));
        [_collectionlabel setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _collectionlabel;
}

- (UILabel *)collectionlabel1{
    if (!_collectionlabel1) {
        
        _collectionlabel1=[UILabel new];
        _collectionlabel1.textColor=[UIColor whiteColor];
        _collectionlabel1.text=@"(元)";
        _collectionlabel1.font=[UIFont systemFontOfSize:CGFloatIn320(11)];
        [_rightView addSubview:_collectionlabel1];
        _collectionlabel1.sd_layout
        .leftSpaceToView(_collectionlabel, 0)
        .heightIs(11)
        .topSpaceToView(_rightView, CGFloatIn320(6));
        [_collectionlabel1 setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _collectionlabel1;
}

- (UILabel *)collectionlabel2{
    if (!_collectionlabel2) {
        
        _collectionlabel2=[UILabel new];
        _collectionlabel2.textColor=[UIColor whiteColor];
        _collectionlabel2.text=@"0.00";
        _collectionlabel2.font=[UIFont systemFontOfSize:CGFloatIn320(21)];
        [_rightView addSubview:_collectionlabel2];
        _collectionlabel2.sd_layout
        .centerXEqualToView(_rightView)
        .heightIs(21)
        .topSpaceToView(_collectionlabel, CGFloatIn320(10));
        [_collectionlabel2 setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _collectionlabel2;
}


- (UILabel *)available{
    if (!_available) {
        
        _available=[UILabel new];
        _available.textColor=[UIColor colorWithHexString:@"#f52735"];
        _available.text=@"0.00";
        _available.font=[UIFont systemFontOfSize:CGFloatIn320(21)];
        [self addSubview:_available];
        _available.sd_layout
        .leftSpaceToView(self, CGFloatIn320(20))
        .heightIs(21)
        .topSpaceToView(_topView, CGFloatIn320(17));
        [_available setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _available;
}

- (UILabel *)available1{
    if (!_available1) {
        
        _available1=[UILabel new];
        _available1.textColor=[UIColor colorWithHexString:@"#888888"];
        _available1.text=@"可用金额(元)";
        _available1.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        [self addSubview:_available1];
        _available1.sd_layout
        .leftSpaceToView(self, CGFloatIn320(10))
        .heightIs(12)
        .topSpaceToView(_available, CGFloatIn320(10));
        [_available1 setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _available1;
}

- (UIView *)lineView2{
    
    if (!_lineView2) {
        _lineView2=[UIView new];
        _lineView2.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self addSubview:_lineView2];
        _lineView2.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .bottomSpaceToView(self, 0)
        .heightIs(CGFloatIn320(10));
    }
    return _lineView2;
}


- (UIButton *)rechargeButton{
    if (!_rechargeButton) {
        
        _rechargeButton=[UIButton new];
        [_rechargeButton setTitle:@"充值" forState:UIControlStateNormal];
        _rechargeButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _rechargeButton.layer.cornerRadius=5.0f;
        [_rechargeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rechargeButton.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
        [self addSubview:_rechargeButton];
        _rechargeButton.sd_layout
        .rightSpaceToView(self, CGFloatIn320(25))
        .heightIs(CGFloatIn320(30))
        .widthIs(CGFloatIn320(69))
        .topSpaceToView(_topView, CGFloatIn320(22));
    }
    return _rechargeButton;
}

- (UIButton *)cashButton{
    if (!_cashButton) {
        
        _cashButton=[UIButton new];
        [_cashButton setTitle:@"提现" forState:UIControlStateNormal];
        _cashButton.titleLabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _cashButton.layer.cornerRadius=5.0f;
        _cashButton.backgroundColor=[UIColor whiteColor];
        _cashButton.layer.borderWidth=1.0f;
        _cashButton.layer.borderColor=[UIColor colorWithHexString:@"#f52735"].CGColor;
        [_cashButton setTitleColor:[UIColor colorWithHexString:@"#f52735"] forState:UIControlStateNormal];
        [self addSubview:_cashButton];
        _cashButton.sd_layout
        .rightSpaceToView(_rechargeButton, CGFloatIn320(25))
        .heightIs(CGFloatIn320(30))
        .widthIs(CGFloatIn320(69))
        .topSpaceToView(_topView, CGFloatIn320(22));
    }
    return _cashButton;
}
@end

//
//  CYWMoreUserCenterIntegralHeadView.m
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreUserCenterIntegralHeadView.h"
#import "WaveProgressView.h"
#import "CYWProgressView.h"
#import "PTHistogramView.h"
@interface CYWMoreUserCenterIntegralHeadView()
@property (nonatomic, retain) UIView *topView;
@property (nonatomic, retain) UILabel *avaterlabel;
@property (nonatomic, retain) UIImageView *levImageView;
@property (nonatomic, retain) WaveProgressView *progressView;
@property (nonatomic, retain) UILabel *nowlabel;
@property (nonatomic, retain) CYWProgressView *progressView1;
@property (nonatomic, retain) UIView *xView;
@property (nonatomic, retain) UIView *lineView;
@property (nonatomic, retain) UIView *vipwView;
@property (nonatomic, retain) UIView *bottomView;
@property (nonatomic, strong) PTHistogramView *ptView;

@end
@implementation CYWMoreUserCenterIntegralHeadView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        self.height=CGFloatIn320(600);
        
        
        [self topView];
        [self avaterlabel];
        [self levImageView];
        [self progressView];
        [self nowlabel];
        [self progressView1];
        [self xView];
        [self lineView];
        [self vipwView];
        [self bottomView];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    ParentModel *mo=(ParentModel *)[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserModel];
    if ([NSObject isNotEmpty:mo]) {
        self.levImageView.image=[UIImage imageNamed:mo.userLevel];//等级nickname
        NSLog(@"用户积分:%@",mo.userPoint);
        self.avaterlabel.text=[NSString stringWithFormat:@"尊敬的VIP用户:%@",[NSString isEmpty:mo.username]?@"":mo.username];
        [self.avaterlabel sizeToFit];
        
        
        if ([mo.userPoint floatValue]>=1000) {
            
            self.progressView.centerLabel.text = [NSString stringWithFormat:@"%.2lf", [mo.userPoint floatValue]/10000];
            self.progressView.label.text = @"万";
        }else if ([mo.userPoint floatValue]>=1000&&[mo.userPoint floatValue]<1000) {
            
            self.progressView.centerLabel.text = [NSString stringWithFormat:@"%.2lf", [mo.userPoint floatValue]/1000];
            self.progressView.label.text = @"分";
        }else{
            
            self.progressView.centerLabel.text = [NSString stringWithFormat:@"%@", mo.userPoint];
            self.progressView.label.text = @"分";
        }
    }
}


//积分顶部
- (UIView *)topView{
    
    if (!_topView) {
        
        _topView=[UIView new];
        //_topView.backgroundColor=[UIColor colorWithHexString:@"#66A6E5"];
        [self addSubview:_topView];
        _topView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(self, 0)
        .heightIs(CGFloatIn320(227));
        
        UIImageView *imageView=[UIImageView new];
        imageView.image=[UIImage imageNamed:@"积分动图"];
        [_topView addSubview:imageView];
        imageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
    }
    return _topView;
}

- (UILabel *)avaterlabel{
    if (!_avaterlabel) {
        
        _avaterlabel=[UILabel new];
        _avaterlabel.text=@"张先森";
        _avaterlabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        _avaterlabel.textColor=[UIColor whiteColor];
        [_topView addSubview:_avaterlabel];
        _avaterlabel.sd_layout
        .heightIs(12)
        .topSpaceToView(_topView, CGFloatIn320(5))
        .leftSpaceToView(_topView, CGFloatIn320(8));
        [_avaterlabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _avaterlabel;
}

- (UIImageView *)levImageView{
    if (!_levImageView) {
        
        _levImageView=[UIImageView new];
        _levImageView.image=[UIImage imageNamed:@"V0"];
        [_topView addSubview:_levImageView];
        _levImageView.sd_layout
        .leftSpaceToView(_avaterlabel, CGFloatIn320(2))
        .topEqualToView(_avaterlabel)
        .widthIs(CGFloatIn320(15))
        .heightIs(CGFloatIn320(15));
    }
    return _levImageView;
}

- (WaveProgressView *)progressView{
    if (!_progressView) {
        
        _progressView=[[WaveProgressView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-CGFloatIn320(45), CGFloatIn320(25), CGFloatIn320(90), CGFloatIn320(90))];
        _progressView.textFont=[UIFont systemFontOfSize:CGFloatIn320(30)];
        _progressView.textColor=[UIColor whiteColor];
        _progressView.percent=0.3;
        _progressView.firstWaveColor=[UIColor colorWithHexString:@"#8FC1EC"];
        _progressView.secondWaveColor=[UIColor colorWithHexString:@"#8FC1EC"];
        [_topView addSubview:_progressView];
    }
    return _progressView;
}


- (UILabel *)nowlabel{
    if (!_nowlabel) {
        
        _nowlabel=[UILabel new];
        _nowlabel.text=@"您的当前积分";
        _nowlabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _nowlabel.textColor=[UIColor whiteColor];
        [_topView addSubview:_nowlabel];
        _nowlabel.sd_layout
        .heightIs(14)
        .topSpaceToView(_progressView, CGFloatIn320(10))
        .centerXEqualToView(_topView);
        [_nowlabel setSingleLineAutoResizeWithMaxWidth:300];
    }
    return _nowlabel;
}

- (CYWProgressView *)progressView1{
    
    if (!_progressView1) {
        
        _progressView1=[[CYWProgressView alloc] initWithFrame:CGRectMake(0, CGFloatIn320(181), SCREEN_WIDTH, CGFloatIn320(48))];
        [_topView addSubview:_progressView1];
    }
    return _progressView1;
}


//中间折现部分
- (UIView *)xView{
    
    if (!_xView) {
        
        _xView=[UIView new];
        _xView.backgroundColor=[UIColor redColor];
        [self addSubview:_xView];
        _xView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_topView, 0)
        .heightIs(CGFloatIn320(270));
        _ptView = [[PTHistogramView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CGFloatIn320(270))
                                               nameArray:@[@"VIP1",@"VIP2",@"VIP3",@"VIP4",@"VIP5",@"VIP6",@"VIP7",@"VIP8"]
                                              countArray:@[@"3",@"20",@"50",@"200",@"500",@"1000",@"2000",@"5000"]];
        [_xView addSubview:_ptView];
    }
    return _xView;
}

- (UIView *)lineView{
    
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self addSubview:_lineView];
        _lineView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_xView, 0)
        .heightIs(10);
    }
    return _lineView;
}

- (UIView *)vipwView{
    
    if (!_vipwView) {
        
        _vipwView=[UIView new];
        _vipwView.backgroundColor=[UIColor whiteColor];
        [self addSubview:_vipwView];
        _vipwView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_lineView, 0)
        .heightIs(CGFloatIn320(58));
        
        UILabel *viplabel=[UILabel new];
        viplabel.text=@"VIP特权";
        viplabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        viplabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [_vipwView addSubview:viplabel];
        viplabel.sd_layout
        .centerXEqualToView(_vipwView)
        .centerYEqualToView(_vipwView)
        .heightIs(14);
        [viplabel setSingleLineAutoResizeWithMaxWidth:200];
        
    }
    return _vipwView;
}


- (UIView *)bottomView{
    
    if (!_bottomView) {
        
        _bottomView=[UIView new];
        _bottomView.backgroundColor=[UIColor colorWithHexString:@"#F5F5F9"];
        [self addSubview:_bottomView];
        _bottomView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_vipwView, 0)
        .bottomSpaceToView(self, 0);
        
        
        UILabel *viplabel=[UILabel new];
        viplabel.text=@"等级";
        viplabel.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        viplabel.textColor=[UIColor colorWithHexString:@"#333333"];
        [_bottomView addSubview:viplabel];
        viplabel.sd_layout
        .centerYEqualToView(_bottomView)
        .heightIs(12)
        .leftSpaceToView(_bottomView, CGFloatIn320(16));
        [viplabel setSingleLineAutoResizeWithMaxWidth:200];
        
        
        UILabel *viplabel1=[UILabel new];
        viplabel1.text=@"利息管理费";
        viplabel1.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        viplabel1.textColor=[UIColor colorWithHexString:@"#333333"];
        [_bottomView addSubview:viplabel1];
        viplabel1.sd_layout
        .centerYEqualToView(_bottomView)
        .heightIs(12)
        .leftSpaceToView(viplabel, CGFloatIn320(40));
        [viplabel1 setSingleLineAutoResizeWithMaxWidth:200];
        
        
        UILabel *viplabel2=[UILabel new];
        viplabel2.text=@"当月免费提现次数";
        viplabel2.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        viplabel2.textColor=[UIColor colorWithHexString:@"#333333"];
        [_bottomView addSubview:viplabel2];
        viplabel2.sd_layout
        .centerYEqualToView(_bottomView)
        .heightIs(12)
        .leftSpaceToView(viplabel1, CGFloatIn320(32));
        [viplabel2 setSingleLineAutoResizeWithMaxWidth:200];
        
        
        UILabel *viplabel3=[UILabel new];
        viplabel3.text=@"积分累计速度";
        viplabel3.font=[UIFont systemFontOfSize:CGFloatIn320(12)];
        viplabel3.textColor=[UIColor colorWithHexString:@"#333333"];
        [_bottomView addSubview:viplabel3];
        viplabel3.sd_layout
        .centerYEqualToView(_bottomView)
        .heightIs(12)
        .leftSpaceToView(viplabel2, CGFloatIn320(32));
        [viplabel3 setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _bottomView;
}

@end

//
//  HomeBannerTableViewCell.m
//  CYW
//
//  Created by jktz on 2018/5/22.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import "HomeBannerTableViewCell.h"
#import "CYWArctileViewController.h"

@interface HomeBannerTableViewCell()<SDCycleScrollViewDelegate>


@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *adView;

@property (nonatomic, strong) UIView *lineView1;

@end
@implementation HomeBannerTableViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self=[super initWithFrame:frame]) {
        self.height=233.0f;
        [self scrollView];
        [self lineView];
        [self adView];
        [self lrScrollView];
        [self lineView1];
        
        [self initSubView];
        
    }
    return self;
}


- (void)initSubView{
    
    @weakify(self);
    [[self rac_signalForSelector:@selector(cycleScrollView:didSelectItemAtIndex:) fromProtocol:@protocol(SDCycleScrollViewDelegate)] subscribeNext:^(RACTuple * _Nullable x) {
        @strongify(self)
        NSInteger index= [x.second integerValue];
        __weak BaseViewController *currentView=(BaseViewController *)[UIView currentViewController];
        [currentView pushViewController:@"CYWBannerDetailViewController" withParams:@{@"title":self.titleArray[index],
                                                                                      @"url":self.urlArray[index]}];
    }];
    
    
    UITapGestureRecognizer *forgetTap=[[UITapGestureRecognizer alloc] init];
    [[forgetTap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self)
        NSInteger index= self.lrScrollView.currentIndex;
        __weak BaseViewController *currentView=(BaseViewController *)[UIView currentViewController];
        
        [AFNManager postDataWithAPI:@"articleOneHandler"
                      withDictParam:@{@"nodeId":self.arcIdArray[index]}
                      withModelName:@"ArticleViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       //NSLog(@"公告详情:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]) {
                           
                           ArticleViewModel *model=(ArticleViewModel *)responseObject;
                           
                           CYWArctileViewController *arctiVC=[[CYWArctileViewController alloc] init];
                           arctiVC.hidesBottomBarWhenPushed=YES;
                           arctiVC.title=@"最新公告";
                           NSString *loadUrl=[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,model.nodeLink];
                           [arctiVC loadWebURLSring:loadUrl];
                           [currentView.navigationController pushViewController:arctiVC animated:YES];
                       }
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       
                       
                   }];
        
    }];
    [self.lrScrollView addGestureRecognizer:forgetTap];
}



#pragma mark --懒加载
- (SDCycleScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0,0, SCREEN_WIDTH, 185) delegate:self placeholderImage:[UIImage imageNamed:@"placeholder"]];
        _scrollView.backgroundColor=[UIColor whiteColor];
        _scrollView.currentPageDotColor=[UIColor redColor];
        _scrollView .pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIView *)lineView{
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
        [self addSubview:_lineView];
        _lineView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_scrollView, 0)
        .heightIs(10);
    }
    return _lineView;
}

- (UIView *)adView{
    if (!_adView) {
        
        _adView=[UIView new];
        _adView.backgroundColor=[UIColor whiteColor];
        _adView.userInteractionEnabled=YES;
        [self addSubview:_adView];
        _adView.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_lineView, 0)
        .heightIs(28);
        UIImageView *horn=[UIImageView new];
        horn.image=[UIImage imageNamed:@"icon_horn"];
        [_adView addSubview:horn];
        horn.sd_layout
        .leftSpaceToView(_adView, 10)
        .widthIs(12)
        .heightIs(12)
        .centerYEqualToView(_adView);
        
        UILabel *hornlabel=[UILabel new];
        hornlabel.text=@"最新公告:";
        hornlabel.textColor=[UIColor colorWithHexString:@"#888888"];
        hornlabel.font=[UIFont systemFontOfSize:14];
        [_adView addSubview:hornlabel];
        hornlabel.sd_layout
        .leftSpaceToView(horn, 8)
        .heightIs(14)
        .centerYEqualToView(_adView);
        [hornlabel setSingleLineAutoResizeWithMaxWidth:100];
        
        //跑马灯
        self.lrScrollView=[[JhtVerticalMarquee alloc] initWithFrame:CGRectMake(100, 0, SCREEN_WIDTH-70-60, 28)];
        self.lrScrollView.backgroundColor=[UIColor whiteColor];
        //self.lrScrollView.titleFont = 14;
        //self.lrScrollView.delegate=self;
        self.lrScrollView.verticalTextColor = [UIColor colorWithHexString:@"#888888"];
        //self.lrScrollView.isCanManualScroll = YES;
        [self.lrScrollView marqueeOfSettingWithState:MarqueeStart_V];
        [_adView addSubview:self.lrScrollView];
        
        
        //左边箭头
        UIImageView *leftImageView=[UIImageView new];
        leftImageView.image=[UIImage imageNamed:@"icon_left"];
        [_adView addSubview:leftImageView];
        leftImageView.sd_layout
        .rightSpaceToView(_adView, 8)
        .widthIs(7)
        .heightIs(11)
        .centerYEqualToView(_adView);
    }
    return _adView;
}

- (UIView *)lineView1{
    if (!_lineView1) {
        
        _lineView1=[UIView new];
        _lineView1.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
        [self addSubview:_lineView1];
        _lineView1.sd_layout
        .leftSpaceToView(self, 0)
        .rightSpaceToView(self, 0)
        .topSpaceToView(_adView, 0)
        .heightIs(10);
    }
    return _lineView1;
}
@end

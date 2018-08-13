//
//  CYWFinanceViewController.m
//  CYW
//
//  Created by jktz on 2017/11/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#define NNTitleHeight 45
const CGFloat headerH = 390;
const CGFloat headerHs = 300;
#import "NNContentScrollView.h"
#import "NNPersonalHomePageTitleView.h"
#import "NNContentTableView.h"
#import <Masonry/Masonry.h>
#import "NNContentTwoTableView.h"



#import "CYWFinanceViewController.h"
#import "CYWFinanceView.h"
#import "CYWComputationsView.h"
#import "CYWFinanceViewModel.h"
#import "JohnTopTitleView.h"

@interface CYWFinanceViewController ()<JohnTopTitleViewDelegate,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, retain) CYWFinanceView *financeView;
@property (nonatomic, retain) UIView *bottomView;
@property (nonatomic, retain) UILabel *label;
@property (nonatomic, retain) CYWFinanceViewModel *financeViewModel;
@property (nonatomic, retain) UIButton *button;


@property (nonatomic, weak) NNContentScrollView *contentScrollView;
@property (nonatomic, weak) UIView *tableViewHeadView;
@property (nonatomic, weak) UIView *headerView;
@property (nonatomic, weak) NNPersonalHomePageTitleView *titleView;
@property (nonatomic, weak) NNContentTableView *dynamicTableView;
@property (nonatomic, weak) NNContentTwoTableView *articleTableView;
@end

@implementation CYWFinanceViewController

- (void) viewWillAppear: (BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    self.financeViewModel=[[CYWFinanceViewModel alloc] init];
    self.navigationItem.title=@"本月理财达人榜";
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor whiteColor]];
    
    self.button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    [self.button setTitle:@"计算规则" forState:UIControlStateNormal];
    [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.button.titleLabel.font=[UIFont systemFontOfSize:14];
    [self.button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.button];
    
    [self refreshCenter];
    
    [self setupContentView];
    [self setupHeaderView];
    [self bottomView];
    [self initSubView];
    
}
- (void)buttonClick:(UIButton *)sender{

    CYWComputationsView *alertView=[[CYWComputationsView alloc] initWithFrame:CGRectZero];
    [alertView show];
}

- (void)initSubView{
    
    @weakify(self)
    UITapGestureRecognizer *forgetTap1=[[UITapGestureRecognizer alloc] init];
    [[forgetTap1 rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self)
        [self bk_performBlock:^(id obj) {
            
            [self backViewControllerIndex:0];
        } afterDelay:1];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarClick" object:nil];
    }];
    [self.label addGestureRecognizer:forgetTap1];
}



/**
 该方法是请求个人排名
 */
- (void)refreshCenter{
    
    @weakify(self)
    [[self.financeViewModel.refreshCenterCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        
        self.label.userInteractionEnabled=NO;
        
        [self.label setAttributedText:[NSMutableAttributedString withTitleString:[NSString stringWithFormat:@"您本月排名是:%@",x] RangeString:[NSString stringWithFormat:@"%@",x] ormoreString:nil color:[UIColor colorWithHexString:@"#3498ec"]]];
        [self.label sizeToFit];
        
    } error:^(NSError * _Nullable error) {
        @strongify(self)
        self.label.text=[self detailstring];
        self.label.userInteractionEnabled=YES;
        [self.label sizeToFit];
    }];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView) {
        CGFloat contentOffsetX       = scrollView.contentOffset.x;
        NSInteger pageNum            = contentOffsetX / SCREEN_WIDTH + 0.5;
        self.titleView.selectedIndex = pageNum;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.contentScrollView || !scrollView.window) {
        return;
    }
    CGFloat offsetY      = scrollView.contentOffset.y;
    CGFloat originY      = 0;
    CGFloat otherOffsetY = 0;
    if (offsetY <= NNHeadViewHeight) {
        originY              = -offsetY;
        if (offsetY < 0) {
            otherOffsetY         = 0;
        } else {
            otherOffsetY         = offsetY;
        }
    }
    else {
        originY              = -NNHeadViewHeight;
        otherOffsetY         = NNHeadViewHeight;
    }
    self.headerView.frame = CGRectMake(0, originY, SCREEN_WIDTH, NNHeadViewHeight + NNTitleHeight);
    for ( int i = 0; i < self.titleView.titles.count; i++ ) {
        // 解决 UITableView 高度问题
        UITableView *contentView = self.contentScrollView.subviews[i];
        if (contentView.contentSize.height < SCREEN_HEIGHT + NNHeadViewHeight - NNTitleHeight) {
            contentView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + NNHeadViewHeight - NNTitleHeight);
        }
        if (i != self.titleView.selectedIndex) {
            CGPoint offset = CGPointMake(0, otherOffsetY);
            if ([contentView isKindOfClass:[UITableView class]]) {
                if (contentView.contentOffset.y < NNHeadViewHeight || offset.y < NNHeadViewHeight) {
                    [contentView setContentOffset:offset animated:NO];
                    self.contentScrollView.offset = offset;
                }
            }
        }
    }
}


/// 主要内容
- (void)setupContentView {
    NNContentScrollView *scrollView           = [[NNContentScrollView alloc] init];
    scrollView.delaysContentTouches           = NO;
    [self.view addSubview:scrollView];
    self.contentScrollView                           = scrollView;
    scrollView.pagingEnabled                  = YES;
    scrollView.showsVerticalScrollIndicator   = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.delegate                       = self;
    scrollView.contentSize                    = CGSizeMake(SCREEN_WIDTH * 2, 0);
    
    
    UIView *headView                          = [[UIView alloc] init];
    headView.frame                            = CGRectMake(0, 0, 0, NNHeadViewHeight + NNTitleHeight);
    self.tableViewHeadView = headView;
    
    NNContentTableView *dynamicTableView = [[NNContentTableView alloc] init];
    dynamicTableView.delegate            = self;
    dynamicTableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
    self.dynamicTableView                = dynamicTableView;
    dynamicTableView.tableHeaderView     = headView;
    [scrollView addSubview:dynamicTableView];
    [dynamicTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView);
        make.width.mas_equalTo(SCREEN_WIDTH);
        make.top.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    
    NNContentTwoTableView *articleTableView = [[NNContentTwoTableView alloc] init];
    articleTableView.delegate            = self;
    articleTableView.separatorStyle      = UITableViewCellSeparatorStyleNone;
    self.articleTableView                = articleTableView;
    articleTableView.tableHeaderView     = headView;
    [scrollView addSubview:articleTableView];
    [articleTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(scrollView).offset(SCREEN_WIDTH);
        make.width.equalTo(dynamicTableView);
        make.top.bottom.equalTo(dynamicTableView);
    }];
    
    
    
    
}
- (void)setupHeaderView {
   UIView *headerView=[[CYWFinanceView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 435+45) withBlock:^(NSInteger index) {
        
        }];
    //headerView.backgroundColor=[UIColor blueColor];
    [self.view addSubview:headerView];
    self.headerView                        = headerView;
    NNPersonalHomePageTitleView *titleView = [[NNPersonalHomePageTitleView alloc] init];
    [headerView addSubview:titleView];
    self.titleView                         = titleView;
    titleView.backgroundColor              = [UIColor whiteColor];
    [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(headerView);
        make.bottom.equalTo(headerView.mas_bottom);
        make.height.mas_equalTo(NNTitleHeight);
    }];
    [self.contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.mas_equalTo(headerView.top);
    }];
    
    WeakSelfType blockSelf=self;
    titleView.titles             = @[@"本月理财达人榜",@"本月理财新人榜"];
    titleView.selectedIndex      = 0;
    titleView.buttonSelected     = ^(NSInteger index){
        if (0==index) {
            
            [blockSelf.dynamicTableView refresh];//本月理财达人榜
        }else{
            
            [blockSelf.articleTableView refresh];//本月理财新人榜
        }
        blockSelf.navigationItem.title=blockSelf.titleView.titles[index];
        [blockSelf.contentScrollView setContentOffset:CGPointMake(SCREEN_WIDTH * index, 0) animated:YES];
    };
    
    
}





- (UIView *)bottomView{
    
    if (!_bottomView) {
        
        _bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT-47, SCREEN_WIDTH, 47)];
        _bottomView.backgroundColor=[UIColor clearColor];
        UIImageView *backImageView=[UIImageView new];
        backImageView.image=[UIImage imageNamed:@"立即购买"];
        [_bottomView addSubview:backImageView];
        backImageView.sd_layout.spaceToSuperView(UIEdgeInsetsMake(0, 0, 0, 0));
        [self.view addSubview:_bottomView];
        [self.view bringSubviewToFront:_bottomView];
        [self label];
        [self.label setAttributedText:[NSMutableAttributedString withTitleString:[self detailstring] RangeString:@"立即投资>>" ormoreString:nil color:[UIColor colorWithHexString:@"#3498ec"]]];
        [self.label sizeToFit];
    }
    return _bottomView;
}

- (UILabel *)label{
    if (!_label) {
        
        _label=[UILabel new];
        _label.text=[self detailstring];
        _label.font=[UIFont systemFontOfSize:14];
        _label.userInteractionEnabled=YES;
        _label.textColor=[UIColor colorWithHexString:@"#3c3b4f"];
        [_bottomView addSubview:_label];
        _label.sd_layout
        .centerXEqualToView(_bottomView)
        .centerYEqualToView(_bottomView)
        .heightIs(14);
        [_label setSingleLineAutoResizeWithMaxWidth:SCREEN_WIDTH];
    }
    return _label;
}

- (NSString *)detailstring{
    
    return @"您本月未投资额!立即投资>>";
}
@end

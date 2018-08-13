//
//  CYWNowInvestmentViewController.m
//  CYW
//
//  Created by jktz on 2017/10/11.
//  Copyright © 2017年 jktz. All rights reserved.
//
@interface CYWNowInvestmentItemModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *viewController;

@end
@implementation CYWNowInvestmentItemModel @end
#import "CYWNowInvestmentViewController.h"
#import "CYWCalculatorAlertView.h"
#import "CYWNowInvestmentTableViewCell.h"
#import "CYWNowHeadView.h"
#import "CYWNowInvestmentViewModel.h"
#import "CYWNowInvestmentTwoTableViewCell.h"
#import "CYWArctileViewController.h"
#import "ZXVideo.h"
#import "CYWPlayVideoViewController.h"
@interface CYWNowInvestmentViewController ()<UITableViewDelegate,UITableViewDataSource>{
    
    NSString *loadUrl;
    NSString *loadId;
}
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *userCenterItemArray;
@property (nonatomic, retain) NSString *money;
@property (nonatomic, retain) UIButton *submitButton;
@property (nonatomic, retain) UIButton *cancelButton;
@property (nonatomic, retain) UIView *bottomView;
@property (nonatomic, retain) UIView *cancelView;
@property (nonatomic, retain) CYWNowHeadView *nowHeadView;
@property (nonatomic, assign) BOOL isSection;
@property (nonatomic, retain)CYWNowInvestmentViewModel *nowViewModel;


@end

@implementation CYWNowInvestmentViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.tableView reloadData];
    [self updateconstraints];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //移除掉选择的红包名称和Id
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"envelopeid"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"envelopename"];
    
    
    
    self.nowViewModel=[[CYWNowInvestmentViewModel alloc] init];
    
   
    self.isSection=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"项目详情";
    WeakSelfType blockSelf=self;
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] bk_initWithImage:[UIImage imageNamed:@"icon_计算器"] style:UIBarButtonItemStyleDone handler:^(id sender) {
        
        [blockSelf show];
    }];
    
    [self tableView];
    
    [self refresh];
    [self addbottomView];
    
}

- (void)show{
    
    CYWCalculatorAlertView *alertView=[[CYWCalculatorAlertView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    [alertView show];
}


- (void)refresh{
    
    self.nowViewModel.loanId=self.params[@"id"];
    //判断项目类型
    if ([self.params[@"load"] isEqualToString:@"transferInvest"]) {
        
        @weakify(self)
        [[self.nowViewModel.refreshTransferRepayCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            
            @strongify(self)
            [self loadData:x];
        } error:^(NSError * _Nullable error) {
            
            
        }];
    }else{
        
        @weakify(self)
        [[self.nowViewModel.refreshNowInvestCommand execute:nil] subscribeNext:^(id  _Nullable x) {
            
            @strongify(self)
            [self loadData:x];
        } error:^(NSError * _Nullable error) {
            
            
        }];
    }
    
    
    
}

- (void)loadData:(id)x{
    //NSLog(@"xxx:%@",x);
    ParentModel *modelss=(ParentModel *)[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserModel];
    
    if ([self.params[@"load"] isEqualToString:@"transferInvest"]) {
        
        TransferRepayViewModel *model=(TransferRepayViewModel *)x;
        //NSLog(@"model:%@",model);
        if ([NSString isNotEmpty:model.loanId]) {
            
            loadId=model.loanId;
            loadUrl=[NSString stringWithFormat:@"/mobile/loanDetailMoreSingle/%@",model.loanId];
            [self initSubView:nil withModel:model];
            [self.nowHeadView TransformModel:model];
            
            
            //NSLog(@"model==:%@,models:%@",model,modelss);
            if ([model.progress floatValue]<100) {
                
                self.submitButton.userInteractionEnabled=YES;
                self.submitButton.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
            }else{
                
                self.submitButton.userInteractionEnabled=NO;
                self.submitButton.backgroundColor=[UIColor lightGrayColor];
            }
            
            //先判断investAmountXS是否为空  如果是空，就不让点击
            if ([NSString isEmpty:modelss.investAmountXS]) {
                
                self.submitButton.userInteractionEnabled=NO;
                self.submitButton.backgroundColor=[UIColor lightGrayColor];
            }else{
                
                if ([modelss.investAmountXS intValue]==0) {
                    
                    self.submitButton.userInteractionEnabled=YES;
                    self.submitButton.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
                }else{
                    
                    self.submitButton.userInteractionEnabled=NO;
                    self.submitButton.backgroundColor=[UIColor lightGrayColor];
                }
            }
           
            
            [self.tableView reloadData];
        }
        
    }else{
        
        
        
        //重新赋值
        ProjectViewModel *model=(ProjectViewModel *)x;
        
        if ([NSString isNotEmpty:model.id]) {
            
            loadId=model.id;
            [self initSubView:model withModel:nil];
            [self.nowHeadView withModel:model];
            
            loadUrl=[NSString stringWithFormat:@"/mobile/loanDetailMoreSingle/%@",model.id];
            
            //NSLog(@"model==:%@,models:%@",model,modelss);
            if ([model.status isEqualToString:@"筹款中"]) {
                
                self.submitButton.userInteractionEnabled=YES;
                self.submitButton.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
            }else{
                
                
                //用来判断是不是新手
                if ([model.loanActivityType isEqualToString:@"xs"]) {
                    
                    
                    if ([NSString isEmpty:modelss.investAmountXS]) {
                        
                        self.submitButton.userInteractionEnabled=NO;
                        self.submitButton.backgroundColor=[UIColor lightGrayColor];
                        
                    }else{
                        
                        if ([modelss.investAmountXS intValue]==0) {
                            
                            self.submitButton.userInteractionEnabled=YES;
                            self.submitButton.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
                        }else{
                            
                            self.submitButton.userInteractionEnabled=NO;
                            self.submitButton.backgroundColor=[UIColor lightGrayColor];
                        }
                    }
                  
                }
            }
            if([model.lastStrTime isEqualToString:@"已到期"]||
               [model.lastStrTime isEqualToString:@"已结束"]){
                self.submitButton.userInteractionEnabled=NO;
                self.submitButton.backgroundColor=[UIColor lightGrayColor];
            }
            else{
                
                self.submitButton.userInteractionEnabled=YES;
                self.submitButton.backgroundColor=[UIColor colorWithHexString:@"#f52735"];
            }
            
            [self.tableView reloadData];
            
            
        }
    }
}


- (void)investloadData{
    
    @weakify(self)
    self.nowViewModel.loanId=loadId;
    self.nowViewModel.money=self.money;
    [UIView showHUDLoading:nil];
    
    [[self.nowViewModel.refreshinvestCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        
        @strongify(self)
        [UIView hideHUDLoading];
        [self pushViewController:@"CYWAssetsBindCarViewController" withParams:@{@"url":x,@"title":@"投资"}];
        
    } error:^(NSError * _Nullable error) {
        
        [UIView showResultThenHide:(NSString *)error];
        
    }];
}

- (void)initSubView:(ProjectViewModel *)model withModel:(TransferRepayViewModel *)models{
    
    //NSLog(@"model:%@==model2:%@",model,models);
    
    [self.userCenterItemArray removeAllObjects];
    NSString *name=nil;
    NSString *type=nil;
    NSString *repayType=nil;
    NSString *time=nil;
    NSString *labell=nil;
    if ([NSObject isNotEmpty:model]) {
        
        labell=@"剩余时间";
        name=model.name;
        type=model.businessType;
        repayType=model.repayType;
        time=model.lastStrTime;
    }else{
        labell=@"截止时间";
        name=models.loanName;
        type=@"债权转让";
        repayType=models.repayType;
        time=models.applyTime;
    }
    
    NSArray *section2=@[[self itemNameString:@"项目名称" withIcon:@"" withValue:name withitemController:@""],
                        [self itemNameString:@"项目类型" withIcon:@"" withValue:type withitemController:@""],
                        [self itemNameString:@"还款方式" withIcon:@"" withValue:repayType withitemController:@""],
                        [self itemNameString:labell withIcon:@"" withValue:time withitemController:@""],
                        [self itemNameString:@"查看更多详情" withIcon:@"" withValue:nil withitemController:@""],
                        [self itemNameString:@"签约视频" withIcon:@"" withValue:nil withitemController:[[VIDEO_URL stringByAppendingString:[NSString stringWithFormat:@"%@",model.loanMasterId]] stringByAppendingString:[NSString stringWithFormat:@"a.mp4"]]],
                        [self itemNameString:@"抵押视频" withIcon:@"" withValue:nil withitemController:[[VIDEO_URL stringByAppendingString:[NSString stringWithFormat:@"%@",model.loanMasterId]] stringByAppendingString:[NSString stringWithFormat:@"b.mp4"]]]];
    [self.userCenterItemArray addObject:section2];
    
    
    NSArray *section=@[[self itemNameString:@"我的红包" withIcon:@"" withValue:nil withitemController:@""]];
    [self.userCenterItemArray addObject:section];
    
    NSArray *section1=@[[self itemNameString:@"" withIcon:@"" withValue:nil withitemController:@""]];
    [self.userCenterItemArray addObject:section1];
    
}





- (UITableView *)tableView{
    
    
    if (!_tableView) {
        
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-getRectNavAndStatusHight-100) style:self.isSection?UITableViewStylePlain:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor colorWithHexString:@"#f4f4f4"];
        [_tableView registerClass:[CYWNowInvestmentTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        [_tableView registerClass:[CYWNowInvestmentTwoTableViewCell class] forCellReuseIdentifier:@"cells"];
        _tableView.tableHeaderView=self.nowHeadView;
        [self.view addSubview:_tableView];
        if (@available(ios 11.0,*)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
        [self initSubView:nil withModel:nil];
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.isSection?self.nowViewModel.investsArray.count: [self.userCenterItemArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.isSection?1: [self.userCenterItemArray count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (self.isSection) {
        NowProjectDetailViewModel *model=self.nowViewModel.investsArray[indexPath.row];
        
        CYWNowInvestmentTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cells"];
        cell.model=model;
        return cell;
    }else{
        
        CYWNowInvestmentItemModel *item = ((NSArray *)self.userCenterItemArray[indexPath.section])[indexPath.row];
        CYWNowInvestmentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        cell.textLabel.text=item.title;
        cell.detailabel.text=item.value;
        cell.textLabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        cell.textLabel.textColor=[UIColor colorWithHexString:@"#888888"];
        cell.indexPath=indexPath;
        cell.textField.tag=indexPath.section*10+indexPath.row;
        [cell.textField addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        return cell;
    }
    return nil;
}


- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 20:
            self.money = textField.text;
            break;
        default:
            break;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        
        CYWNowInvestmentItemModel *item = ((NSArray *)self.userCenterItemArray[indexPath.section])[indexPath.row];
        if (indexPath.row==4) {
            
            CYWArctileViewController *arctiVC=[[CYWArctileViewController alloc] init];
            arctiVC.title=@"项目详情";
            NSString *str=[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,loadUrl];
            [arctiVC loadWebURLSring:str];
            arctiVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:arctiVC animated:YES];
        }
        //签约视频
        else if (indexPath.row==5){
            
            //NSLog(@"签约视频:%@",item.viewController)
            ZXVideo *video = [[ZXVideo alloc] init];
            video.playUrl = item.viewController;
            video.title=@"签约视频";
            CYWPlayVideoViewController *vc = [[CYWPlayVideoViewController alloc] init];
            vc.video = video;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        //抵押视频
        else if (indexPath.row==6){
            
            //NSLog(@"抵押视频:%@",item.viewController)
            ZXVideo *video = [[ZXVideo alloc] init];
            video.playUrl = item.viewController;
            video.title=@"抵押视频";
            CYWPlayVideoViewController *vc = [[CYWPlayVideoViewController alloc] init];
            vc.video = video;
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }
        
        
    }else if(indexPath.section==1){
        
        //我的红包
        if([NSString isNotEmpty:loadId]){
            [self pushViewController:@"CYWAssetsEnvelopeViewController" withParams:@{@"loadId":loadId}];
            
        }else{
            
            [self showResultThenHide:@"标段Id为空"];
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    if (self.isSection) {
        
        return 45.0f;
    }else{
        return 0.01f;
    }
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (self.isSection) {
        
        return 0.0f;
    }else{
        
        if (section==2) {
            
            return 100.0f;
        }
        return 10.0f;
    }
    
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (self.isSection) {
        
        NSMutableArray * array = [NSMutableArray array];
        UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH , 45)];
        view.backgroundColor = [UIColor colorWithHexString:@"#efefef"];
        CGFloat width = view.bounds.size.width;
        CGFloat height = view.bounds.size.height;
        for (int i = 0; i < 3; i++) {
            UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(i * width/3 + 15, 0, width/3 - 20, height)];
            
            label.tag = i;
            label.font=[UIFont systemFontOfSize:14];
            label.textColor=[UIColor colorWithHexString:@"#666666"];
            [view addSubview:label];
            [array addObject:label];
        }
        for (UILabel *l in array) {
            switch (l.tag) {
                case 0:
                    l.textAlignment = NSTextAlignmentCenter;
                    l.text = @"投资用户";
                    break;
                case 1:
                    l.textAlignment = NSTextAlignmentCenter;
                    l.text = @"投资金额";
                    break;
                case 2:
                    l.textAlignment = NSTextAlignmentCenter;
                    l.text = @"投资时间";
                    break;
                default:
                    break;
            }
        }
        return view;
    }else{
        return nil;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    
    return nil;
}

- (void)addbottomView{
    
    self.cancelView=[UIView new];
    self.cancelView.layer.borderColor=[UIColor colorWithHexString:@"#f52735"].CGColor;
    self.cancelView.layer.borderWidth=1.0f;
    [self.bottomView addSubview:self.cancelView];
    
    UIImageView *imageView=[UIImageView new];
    imageView.image=[UIImage imageNamed:@"取消红包"];
    [self.cancelView addSubview:imageView];
    imageView.sd_layout
    .leftSpaceToView(self.cancelView, 5)
    .widthIs(24)
    .heightIs(28)
    .centerYEqualToView(self.cancelView);
    
    
    
    
    self.cancelButton=[UIButton new];
    [self.cancelButton setTitle:@"取消红包" forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[UIColor colorWithHexString:@"#f52735"] forState:UIControlStateNormal];
    self.cancelButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.cancelView addSubview:self.cancelButton];
    
    self.cancelButton.sd_layout
    .leftSpaceToView(imageView, 10)
    .heightIs(40)
    .rightSpaceToView(self.cancelView, 10);
    
    
    self.submitButton=[UIButton new];
    [self.submitButton setTitle:@"立即投资" forState:UIControlStateNormal];
    [self.submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.submitButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.submitButton setBackgroundColor:[UIColor lightGrayColor]];
    self.submitButton.userInteractionEnabled=NO;
    [self.bottomView addSubview:self.submitButton];
    
    //读取账户信息
    NSObject *centerModel= [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserCenterInfoModel];
    UserCenterInfoViewModel *model=(UserCenterInfoViewModel *)centerModel;
    
    @weakify(self)
    [[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        
        @strongify(self)
        
        //没有实名认证就去认证
        id object=[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserAuthentication];
        if ([NSObject isEmpty:object]) {
            
            [self pushViewController:@"CYWMoreUserCenterAuthenticationViewController"];
            return ;
        }
        if ([NSString isEmpty:self.money]) {
            
            [UIView showResultThenHide:@"请输入金额"];
            return ;
        }
        if ([model.balcance floatValue]<[self.money floatValue]) {
            
            [UIView showResultThenHide:@"余额不足"];
            return ;
        }
        
        [self hideKeyboard];
        
        [self investloadData];
        
    } error:^(NSError * _Nullable error) {
        
        
    }];
    
    [[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self)
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"envelopeid"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"envelopename"];
        [self.tableView reloadData];
        [self updateconstraints];
    } error:^(NSError * _Nullable error) {
        
        
    }];
    
    
}

- (void)updateconstraints{
    
    
    if ([NSString isNotEmpty:[[NSUserDefaults standardUserDefaults] objectForKey:@"envelopename"]]) {
        [self.cancelView setHidden:NO];
        self.cancelView.sd_layout
        .leftSpaceToView(_bottomView, 15)
        .heightIs(40)
        .widthIs(116);
        
        self.submitButton.sd_resetLayout
        .leftSpaceToView(self.cancelView, 18)
        .heightIs(40)
        .rightSpaceToView(_bottomView, 0);
        
        
    }else{
        
        [self.cancelView setHidden:YES];
        
        self.submitButton.sd_resetLayout
        .rightSpaceToView(self.bottomView, 0)
        .leftSpaceToView(self.bottomView, 0)
        .centerYEqualToView(self.bottomView)
        .heightIs(40);
        
        
        
    }
}


- (UIView *)bottomView{
    
    if (!_bottomView) {
        
        
        _bottomView=[[UIView alloc] initWithFrame:CGRectMake(0, kDevice_Is_iPhoneX?SCREEN_HEIGHT-65:SCREEN_HEIGHT-45, SCREEN_WIDTH, 45)];
        _bottomView.backgroundColor=[UIColor clearColor];
        [self.view addSubview:_bottomView];
        [self.view bringSubviewToFront:_bottomView];
    }
    return _bottomView;
}


- (NSMutableArray *)userCenterItemArray{
    
    if (!_userCenterItemArray) {
        
        _userCenterItemArray=[NSMutableArray array];
    }
    return _userCenterItemArray;
}

- (CYWNowHeadView *)nowHeadView{
    if (!_nowHeadView) {
        
        @weakify(self)
        _nowHeadView=[CYWNowHeadView new];
        [_nowHeadView setNowHeadViewBook:^(BOOL section) {
            
            @strongify(self)
            self.isSection=section;
            [self.tableView reloadData];
        }];
    }
    return _nowHeadView;
}

- (CYWNowInvestmentItemModel *)itemNameString:(NSString *)name withIcon:(NSString *)icon withValue:(NSString *)value withitemController:(NSString *)controller{
    
    CYWNowInvestmentItemModel *items=[CYWNowInvestmentItemModel new];
    items.title=name;
    items.icon=icon;
    items.value=value;
    items.viewController=controller;
    return items;
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPat{
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]){
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews {
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
}

- (void)dealloc{
    
    NSLog(@"项目详情销毁");
}
@end

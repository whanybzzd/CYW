//
//  CYWMoreUserCenterViewController.m
//  CYW
//
//  Created by jktz on 2017/10/17.
//  Copyright © 2017年 jktz. All rights reserved.
//
//-----------临时创建一个模型用来描述个人中心的入口参数-----------
@interface CYWUserCenterItemModels : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *viewController;

@end
@implementation CYWUserCenterItemModels @end
#import "CYWMoreUserCenterViewController.h"
#import "CYWMoreUserCenterHeadView.h"
#import "CYWMoreUserCenterTableViewCell.h"
#import "CYWIntegralView.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "CYWArctileViewController.h"
@interface CYWMoreUserCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *userCenterItemArray;
@property (nonatomic, retain) CYWMoreUserCenterHeadView *centerView;
@property (nonatomic, retain) CYWIntegralView *integralView;

@end

@implementation CYWMoreUserCenterViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
    [self initBarManager];
    [self initSubView];
    [self.centerView initSubView];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.tableView.delegate = nil;
    [MXNavigationBarManager reStoreToSystemNavigationBar];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    [self tableView];
}
- (void)initBarManager {
    //optional, save navigationBar status
    
    //required
    [MXNavigationBarManager managerWithController:self];
    [MXNavigationBarManager setBarColor:[UIColor clearColor]];
    
    //optional
    [MXNavigationBarManager setTintColor:[UIColor blackColor]];
    [MXNavigationBarManager setStatusBarStyle:UIStatusBarStyleDefault];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offsetY = scrollView.contentOffset.y;
    if (offsetY <= 0) {
        self.tableView.bounces = NO;
        
    }
    else
        if (offsetY >= 0){
            self.tableView.bounces = YES;
            
        }
}
- (void)initSubView{
    
    //个人信息
    ParentModel *mo=(ParentModel *)[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserModel];
    
    
    
    //实名认证
    NSObject *object=[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserAuthentication];
    
    [self.userCenterItemArray removeAllObjects];
    
    NSArray *section3=@[[self itemNameString:@"推荐有礼" withIcon:@"推荐有礼" withValue:@"" withitemController:@""]];
    [self.userCenterItemArray addObject:section3];
    
    
    NSArray *section=@[[self itemNameString:@"用户名" withIcon:@"icon_user_name" withValue:[NSString isEmpty:mo.nickname]?@"":mo.nickname withitemController:@""],
                       [self itemNameString:@"手机号" withIcon:@"icon_user_phone" withValue:[NSString isEmpty:mo.mobileNumber]?@"":mo.mobileNumber withitemController:@"CYWMoreUpdatePhoneViewController"]];
    [self.userCenterItemArray addObject:section];
    
    NSArray *section1=@[[self itemNameString:@"我的积分" withIcon:@"icon_user_integral" withValue:[NSString isEmpty:mo.userPoint]?@"":mo.userPoint withitemController:@"CYWMoreUserCenterIntegralViewController"],
                        [self itemNameString:@"我的推荐人" withIcon:@"icon_user_referrer" withValue:nil withitemController:@"CYWMoreUserCenterefereesViewController"],
                        [self itemNameString:@"我的排名" withIcon:@"奖杯拷贝" withValue:nil withitemController:@"CYWFinanceViewController"],
                        [self itemNameString:@"风险评估" withIcon:@"icon_user_fx" withValue:nil withitemController:@""]];
    [self.userCenterItemArray addObject:section1];
    
    NSArray *section2=@[[self itemNameString:@"实名认证" withIcon:@"icon_user_authentication" withValue:[NSObject isEmpty:object]?@"未实名认证":@"已认证" withitemController:@"CYWMoreUserCenterAuthenticationViewController"]];
    [self.userCenterItemArray addObject:section2];
    
    
}

- (UITableView *)tableView{
    
    
    if (!_tableView) {
        
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor colorWithHexString:@"#f4f4f4"];
        [_tableView registerClass:[CYWMoreUserCenterTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        _tableView.tableHeaderView=self.centerView;
        [self.view addSubview:_tableView];
        if (@available(ios 11.0,*)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
        
       // [self initSubView];
        
        [self isAlertView];
    }
    return _tableView;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [self.userCenterItemArray[section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return [self.userCenterItemArray count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CYWUserCenterItemModels *item = ((NSArray *)self.userCenterItemArray[indexPath.section])[indexPath.row];
    CYWMoreUserCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.imageView.image=[UIImage imageNamed:item.icon];
    cell.textLabel.text=item.title;
    cell.textLabel.textColor=[UIColor colorWithHexString:@"#666666"];
    cell.textLabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
    cell.indexPath=indexPath;
    cell.detailString=item.value;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CYWUserCenterItemModels *item = ((NSArray *)self.userCenterItemArray[indexPath.section])[indexPath.row];
    if (indexPath.section==1&&indexPath.row==1) {
        
        [self pushViewController:item.viewController withParams:@{@"phone":item.value}];
    }else if(indexPath.section==2&&indexPath.row==3){
        
        CYWArctileViewController *arctiVC=[[CYWArctileViewController alloc] init];
        arctiVC.title=@"风险评估";
        NSString *loadUrl=[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,@"/mobile/fengxianceping"];
        [arctiVC loadWebURLSring:loadUrl];
        arctiVC.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:arctiVC animated:YES];
        
    }else if(indexPath.section==0){
        
        [self shareAlertView];
        
    }
    else{
        
        [self pushViewController:item.viewController];
    }
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    
    return 0.01f;
}

//section底部间距
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}


- (NSMutableArray *)userCenterItemArray{
    
    if (!_userCenterItemArray) {
        
        _userCenterItemArray=[NSMutableArray array];
    }
    return _userCenterItemArray;
}
- (CYWMoreUserCenterHeadView *)centerView{
    
    if (!_centerView) {
        
        _centerView=[CYWMoreUserCenterHeadView new];
    }
    return _centerView;
}

- (CYWUserCenterItemModels *)itemNameString:(NSString *)name withIcon:(NSString *)icon withValue:(NSString *)value withitemController:(NSString *)controller{
    
    CYWUserCenterItemModels *items=[CYWUserCenterItemModels new];
    items.title=name;
    items.icon=icon;
    items.value=value;
    items.viewController=controller;
    return items;
}


//是否需要弹动画框框
-(void)isAlertView{
    
    ParentModel *mo=(ParentModel *)[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserModel];
    
    //判断当前的用户等级和保存的不一致并且等级不是VIP0
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"level"] isEqualToString:mo.userLevel]&&
        ![mo.userLevel isEqualToString:@"VIP0"]) {
        
        [self integralView];
        [[NSUserDefaults standardUserDefaults] setValue:mo.userLevel forKey:@"level"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }else{
        
        [[NSUserDefaults standardUserDefaults] setValue:mo.userLevel forKey:@"level"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}


- (CYWIntegralView *)integralView{
    if (!_integralView) {
        
        _integralView=[[CYWIntegralView alloc] initWithIntegralManagermentFree:@"" embodimentnumber:@"" velocity:@""];
        [_integralView show];
    }
    return _integralView;
}


/**
 调用分享
 */
- (void)shareAlertView{
    
    
    //标记当时分享的时候，不清空缓存信息
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"share"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    //1、创建分享参数
    NSArray* imageArray = @[[UIImage imageNamed:@"180.png"]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageArray) {
        NSObject *userModel = [[StorageManager sharedInstance] userConfigValueForKey:kCachedUserModel];
        ParentModel *model=(ParentModel *)userModel;
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:@"快来长运网领取1200元现金红包"
                                         images:imageArray
                                            url:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[kResPathAppImageUrl stringByAppendingString:[NSString stringWithFormat:@"/mobile/apprecommend/tuijianzhuce?referrer=%@",model.username]]]]
                                          title:@"邀请有礼"
                                           type:SSDKContentTypeAuto];
        //有的平台要客户端分享需要加此方法，例如微博
        [shareParams SSDKEnableUseClientShare];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
                                 items:nil
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                       
                       
                       switch (state) {
                           case SSDKResponseStateSuccess:
                           {
                               [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"share"];
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                               break;
                           }
                           case SSDKResponseStateFail:
                           {
                               [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"share"];
                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                               message:[NSString stringWithFormat:@"%@",error]
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"OK"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }
         ];}
}


- (void)dealloc{
    
    NSLog(@"个人中心销毁");
}
@end

//
//  CYWMoreViewController.m
//  CYW
//
//  Created by jktz on 2017/9/30.
//  Copyright © 2017年 jktz. All rights reserved.
//
@interface CYWMoreItemModel : NSObject

@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *viewController;

@end
@implementation CYWMoreItemModel @end
#import "CYWMoreViewController.h"
#import "CYWMoreTableViewCell.h"
#import "CYWMoreBottomView.h"
#import "CYWArctileViewController.h"
@interface CYWMoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *userCenterItemArray;
@property (nonatomic, retain) CYWMoreBottomView *moreBottomView;

@end

@implementation CYWMoreViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initSubView];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"更多";
    self.view.backgroundColor=[UIColor whiteColor];
    [self tableView];
    
   
}

- (void)initSubView{
    
    NSObject *jec=[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserAuto];
    [self.userCenterItemArray removeAllObjects];
    
    NSArray *section=@[[self itemNameString:@"自动投标" withIcon:@"icon_more_automaticity" withValue:[NSObject isEmpty:jec]?@"关闭":@"开启" withitemController:@"CYWMoreAutomaticViewController"]];
    [self.userCenterItemArray addObject:section];
    
    NSArray *section1=@[[self itemNameString:@"登录密码" withIcon:@"icon_more_password" withValue:nil withitemController:@"CYWForgetViewController"],
                        [self itemNameString:@"手势密码" withIcon:@"icon_more_gestures" withValue:nil withitemController:@"CYWMoreGestureViewController"]];
    [self.userCenterItemArray addObject:section1];
    
    NSArray *section2=@[[self itemNameString:@"关于我们" withIcon:@"icon_more_about" withValue:nil withitemController:@"CYWMoreAboutViewController"],
                        [self itemNameString:@"意见反馈" withIcon:@"icon_more_fack" withValue:nil withitemController:@"CYWMoreFeedBackViewController"],
                        [self itemNameString:@"客服中心" withIcon:@"icon_more_ service" withValue:@"400-863-9333" withitemController:@""],
                        [self itemNameString:@"官方QQ群" withIcon:@"icon_more_qq" withValue:@"530543704" withitemController:@""],
                        [self itemNameString:@"当前版本" withIcon:@"版本" withValue:VersionNumber withitemController:@""],
                        [self itemNameString:@"关注微信" withIcon:@"icon_user_wx" withValue:nil withitemController:@""]];
    [self.userCenterItemArray addObject:section2];
    
}

- (UITableView *)tableView{
    
    
    if (!_tableView) {
        
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-getRectNavAndStatusHight) style:UITableViewStyleGrouped];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.rowHeight=50.0f;
        _tableView.backgroundColor=[UIColor colorWithHexString:@"#f4f4f4"];
        [_tableView registerClass:[CYWMoreTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        _tableView.tableFooterView=self.moreBottomView;
        [self.view addSubview:_tableView];
        if (@available(ios 11.0,*)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
        }
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
    CYWMoreItemModel *item = ((NSArray *)self.userCenterItemArray[indexPath.section])[indexPath.row];
    CYWMoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.imageView.image=[UIImage imageNamed:item.icon];
    cell.textLabel.text=item.title;
    cell.textLabel.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
    cell.textLabel.textColor=[UIColor colorWithHexString:@"#666666"];
    cell.valueString=item.value;
    cell.indexPath=indexPath;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0==indexPath.section) {
        
        [self pushViewController:@"CYWMoreAutomaticViewController"];
    }else if (1==indexPath.section){
        
        if (0==indexPath.row) {
            
            [self pushViewController:@"CYWForgetViewController" withParams:@{@"title":@"修改密码"}];
        }else if (1==indexPath.row){
            
            [self pushViewController:@"CYWMoreSettingGesturesViewController"];
        }
        
    }else if (2==indexPath.section){
        
        
        if (0==indexPath.row) {
            
            CYWArctileViewController *arctiVC=[[CYWArctileViewController alloc] init];
            NSString *loadUrl=[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,@"/mobile/guanyuwomen"];
            arctiVC.title=@"关于我们";
            [arctiVC loadWebURLSring:loadUrl];
            arctiVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:arctiVC animated:YES];
            
            
        }else if (1==indexPath.row){
            [self pushViewController:@"CYWMoreFeedBackViewController"];
            
        }else if (2==indexPath.row){
            
            CallPhone(@"400-863-9333");
        }
        else if (3==indexPath.row){
            
            [self joinGroup:@"530543704" key:@"c93c215e50519b29755eed13cfb1329bee44a99eeb1c61b34c712110d1404a89"];

        }
        else if (4==indexPath.row){
            
            [self pushViewController:@"CYWVersionViewController"];
            
        }
        else if (5==indexPath.row){
            CYWArctileViewController *arctiVC=[[CYWArctileViewController alloc] init];
            NSString *loadUrl=[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,@"/mobile/weixingongzhonghao"];
            arctiVC.title=@"微信公众号";
            [arctiVC loadWebURLSring:loadUrl];
            arctiVC.hidesBottomBarWhenPushed=YES;
            [self.navigationController pushViewController:arctiVC animated:YES];
            
        }
    }
    
    
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//
//    return 50.0f;
//}
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


- (CYWMoreItemModel *)itemNameString:(NSString *)name withIcon:(NSString *)icon withValue:(NSString *)value withitemController:(NSString *)controller{
    
    CYWMoreItemModel *items=[CYWMoreItemModel new];
    items.title=name;
    items.icon=icon;
    items.value=value;
    items.viewController=controller;
    return items;
}



- (CYWMoreBottomView *)moreBottomView{
    if (!_moreBottomView) {
        
        _moreBottomView=[CYWMoreBottomView new];
        _moreBottomView.backgroundColor=[UIColor colorWithHexString:@"#f4f4f4"];
    }
    return _moreBottomView;
}


/**
 添加群号
 
 @param groupUin 群号码
 @param key key
 @return Bool
 */


- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", groupUin,key];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [[UIApplication sharedApplication] openURL:url];
        return YES;
    }
    else return NO;
}
@end

//
//  CYWMoreAutomaticViewController.m
//  CYW
//
//  Created by jktz on 2017/10/20.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreAutomaticViewController.h"
#import "CYWMoreAutomaticTableViewCell.h"
#import "CYWMoreAutomaticOneTableViewCell.h"
#import "CYWMoreAutomaticTwoTableViewCell.h"
@interface CYWMoreAutomaticViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, assign) BOOL automication;
@end

@implementation CYWMoreAutomaticViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"自动投标";
    self.view.backgroundColor=[UIColor whiteColor];
    self.automication=[NSObject isEmpty:[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserAuto]]?NO:YES;
    [self tableView];
}
- (UITableView *)tableView{
    
    
    if (!_tableView) {
        
        
        _tableView=[[UITableView alloc] initWithFrame:CGRectMake(0, getRectNavAndStatusHight, SCREEN_WIDTH, SCREEN_HEIGHT-getRectNavAndStatusHight-20) style:UITableViewStylePlain];
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [_tableView registerClass:[CYWMoreAutomaticTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        [_tableView registerClass:[CYWMoreAutomaticOneTableViewCell class] forCellReuseIdentifier:@"automaticone"];
        [_tableView registerClass:[CYWMoreAutomaticTwoTableViewCell class] forCellReuseIdentifier:@"automaticTwo"];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
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
    
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weakify(self)
    
    if (0==indexPath.row) {
        CYWMoreAutomaticTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
        [cell setSelect:^(BOOL select) {
            
            @strongify(self)
            [self selectSwitch:select];
        }];
        return cell;
    }else if (1==indexPath.row){
        CYWMoreAutomaticOneTableViewCell *autocell = [tableView dequeueReusableCellWithIdentifier:@"automaticone"];
        
        CYWMoreAutomaticTwoTableViewCell *autocells = [tableView dequeueReusableCellWithIdentifier:@"automaticTwo"];
        autocell.separatorInset = UIEdgeInsetsMake(0, 0, 0, autocell.bounds.size.width);
        autocells.separatorInset = UIEdgeInsetsMake(0, 0, 0, autocells.bounds.size.width);
        if (self.automication) {
            
            return autocells;
        }else{
            
            return autocell;
        }
        
    }
    return nil;
}

- (void)selectSwitch:(BOOL)select{
    
    self.automication=select;
    [self.tableView reloadData];
    NSLog(@"select:%zd",select);
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (0==indexPath.row) {
        
        return 50.0f;
    }else{
        
        if (self.automication) {
            
            return 800.0f;
        }else{
            
            return 200.0f;
        }
    }
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
    NSLog(@"自动投标销毁");
}
@end

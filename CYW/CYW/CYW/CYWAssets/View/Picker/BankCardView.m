//
//  BankCardView.m
//  CYW
//
//  Created by jktz on 2017/10/17.
//  Copyright © 2017年 jktz. All rights reserved.
//
#define defaultTag 1990
#import "BankCardView.h"
#import "BankCarTableViewCell.h"
#import "CYWAssetsCarManagerViewModel.h"
@interface BankCardView()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, copy) BankCardViewResultBlock resultBlocks;
@property (strong,nonatomic) UIView *tableView;
@property (strong,nonatomic) UIView *backgroundView;
@property (retain, nonatomic) UILabel *title;
@property (retain, nonatomic) UIView *lineView;
@property (retain, nonatomic) UIImageView *closeImageView;
@property (retain, nonatomic) UITableView *tableViews;
@property (retain, nonatomic) NSMutableArray *carManagerArray;
@property (nonatomic, assign) NSInteger btnTag;//默认选中的Tag
@property (nonatomic, retain) UIImageView *caraddImageView;

@property (nonatomic, retain) CYWAssetsCarManagerViewModel *managerViewModel;
@end
@implementation BankCardView

+ (instancetype)bankCarView:(BankCardViewResultBlock)resultBlock{
    
    
    return [[self alloc] initWbankView:resultBlock];
}
- (instancetype)initWbankView:(BankCardViewResultBlock)result{

    if (self=[super init]) {
        self.resultBlocks =result;
        [self installSubViews];
        [self initSubView];
    }
    return self;
}



- (void)installSubViews {
    
    self.managerViewModel=[[CYWAssetsCarManagerViewModel alloc] init];
    
    self.frame = [UIScreen mainScreen].bounds;
    
    // 初始化遮罩视图
    self.backgroundView = [[UIView alloc]initWithFrame:self.bounds];
    self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.142 alpha:1.000];
    self.backgroundView.alpha = 0.4f;
    [self addSubview:_backgroundView];
    
    
    // 初始化TableView
    self.tableView = [[UIView alloc]initWithFrame:CGRectMake(0.0f,self.bounds.size.height, self.bounds.size.width, self.tableViewHeight)];
    self.tableView.backgroundColor=[UIColor whiteColor];
    [self addSubview:_tableView];
    
    // 遮罩加上手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hide)];
    [self.backgroundView addGestureRecognizer:tap];
    
    self.hidden = YES;
    self.tableView.hidden = YES;
    @weakify(self)
    UITapGestureRecognizer *tapView=[[UITapGestureRecognizer alloc] init];
    [[tapView rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        
        @strongify(self)
        [self hide];
        BaseViewController *curentView=(BaseViewController *)[UIView currentViewController];
        [UIView showHUDLoading:nil];
        [[self.managerViewModel.refresBindCommand execute:nil] subscribeNext:^(id x) {
            
            [UIView hideHUDLoading];
            [curentView pushViewController:@"CYWAssetsBindCarViewController" withParams:@{@"url":x,@"title":@"绑定银行卡"}];
        } error:^(NSError * _Nullable error) {
            
            [UIView hideHUDLoading];
        }];
    }];
    [self.caraddImageView addGestureRecognizer:tapView];
    
}

- (void)initSubView{
    
    NSString *index=[[NSUserDefaults standardUserDefaults] objectForKey:@"carNo"];
     //self.btnTag = defaultTag+1  表示默认选择第二个，依次类推
    if ([NSString isNotEmpty:index]) {
        
        self.btnTag=defaultTag+[index integerValue];
    }else{
        
        self.btnTag=defaultTag+0;
    }
    
    
    self.carManagerArray=[NSMutableArray array];
    self.carManagerArray =[[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserCarManager] copy];
    
    //NSLog(@"银行卡:%@",self.carManagerArray);
    if ([NSArray isEmpty:self.carManagerArray]) {//如果没有银行卡  就提示添加银行卡
        [self.tableViews addSubview:self.caraddImageView];
    }
    
    
}

- (UIImageView *)caraddImageView{
    if (!_caraddImageView) {
        
        _caraddImageView=[[UIImageView alloc] initWithFrame:CGRectMake(CGFloatIn320(SCREEN_WIDTH/2-53/2), CGFloatIn320(80-53/2), CGFloatIn320(53), CGFloatIn320(53))];
        _caraddImageView.userInteractionEnabled=YES;
        _caraddImageView.image=[UIImage imageNamed:@"icon_addmanager"];
        _caraddImageView.layer.cornerRadius=10.0f;
        
    }
    return _caraddImageView;
}


-(CGFloat)tableViewHeight {
    
    return 200;
    
}


- (void)show{
    
    [self title];
    [self lineView];
    [self closeImageView];
    [self tableViews];
    
    WeakSelfType blockSelf=self;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    self.hidden = NO;
    
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = blockSelf.tableView.frame;
        CGSize screenSisze = [UIScreen mainScreen].bounds.size;
        frame.origin.y = screenSisze.height - self.tableViewHeight;
        
        blockSelf.tableView.frame = frame;
        
        blockSelf.tableView.hidden = NO;
        
    } completion:^(BOOL finished) {
        
        
        
    }];
}
- (void)hide{
    
    WeakSelfType blockSelf=self;
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect frame = blockSelf.tableView.frame;
        CGSize screenSisze = [UIScreen mainScreen].bounds.size;
        frame.origin.y = screenSisze.height + self.tableViewHeight;
        
        blockSelf.tableView.frame = frame;
        
    } completion:^(BOOL finished) {
        
        blockSelf.hidden = YES;
        blockSelf.tableView.hidden = YES;
        [blockSelf removeFromSuperview];
        
    }];
    
}


- (UILabel *)title{
    
    if (!_title) {
        
        _title=[UILabel new];
        _title.text=@"选择银行卡";
        _title.font=[UIFont systemFontOfSize:CGFloatIn320(14)];
        _title.textColor=[UIColor colorWithHexString:@"#333333"];
        [self.tableView addSubview:_title];
        _title.sd_layout
        .topSpaceToView(self.tableView, CGFloatIn320(13))
        .heightIs(14)
        .centerXEqualToView(self.tableView);
        [_title setSingleLineAutoResizeWithMaxWidth:200];
    }
    return _title;
}

- (UIView *)lineView{
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"#efefef"];
        [self.tableView addSubview:_lineView];
        _lineView.sd_layout
        .leftSpaceToView(self.tableView, 0)
        .rightSpaceToView(self.tableView, 0)
        .topSpaceToView(_title, CGFloatIn320(10))
        .heightIs(1);
    }
    return _lineView;
}



- (UITableView *)tableViews{
    
    if (!_tableViews) {
        
        _tableViews=[[UITableView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, self.tableViewHeight-40) style:UITableViewStylePlain];
        _tableViews.backgroundColor=[UIColor whiteColor];
        _tableViews.delegate=self;
        _tableViews.dataSource=self;
        _tableViews.showsVerticalScrollIndicator = NO;
        _tableViews.tableHeaderView=[[UIView alloc] initWithFrame:CGRectZero];
        _tableViews.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
        [_tableViews registerClass:[BankCarTableViewCell class] forCellReuseIdentifier:kCellIdentifier];
        [_tableView addSubview:_tableViews];
    }
    return _tableViews;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [NSArray isEmpty:self.carManagerArray]?0:self.carManagerArray.count;
    //return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CarManagerMentViewModel *model=self.carManagerArray[indexPath.row];
    BankCarTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    cell.indexPath=indexPath;
    cell.model=model;
    @weakify(self)
    [cell setResultBlock:^(NSIndexPath *indexPath) {
       @strongify(self)
        [self didSelectRowAtIndexPath:indexPath];
    }];
    cell.selectBtn.tag = defaultTag+indexPath.row;
    if (cell.selectBtn.tag == self.btnTag) {
        cell.isSelect = YES;
        cell.rightImageView.image=[UIImage imageNamed:@"对勾"];
    }else{
        cell.isSelect = NO;
        cell.rightImageView.image=[UIImage imageNamed:@"bg_navigationbar"];
    }
    __weak BankCarTableViewCell *weakCell = cell;
    [cell setQhxSelectBlock:^(BOOL choice,NSInteger btnTag){
        if (choice) {
            @strongify(self)
            weakCell.rightImageView.image=[UIImage imageNamed:@"对勾"];
            self.btnTag = btnTag;
            [self.tableViews reloadData];
        }
        else{
            @strongify(self)
            //选中一个之后，再次点击，是未选中状态，图片仍然设置为选中的图片，记录下tag，刷新tableView，这个else 也可以注释不用，tag只记录选中的就可以
            weakCell.rightImageView.image=[UIImage imageNamed:@"对勾"];
            self.btnTag = btnTag;
            [self.tableViews reloadData];
        }
    }];
    
    return cell;
    
}

- (void)didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CarManagerMentViewModel *model=(CarManagerMentViewModel *)self.carManagerArray[indexPath.row];
    if (self.resultBlocks) {
        [self hide];
        self.resultBlocks(model.cardNo,model.id);
        
        //把选择的银行卡用临时变量存储（做默认选择）
        [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%zd",indexPath.row] forKey:@"carNo"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    //NSLog(@"model:%@",model);
}

@end

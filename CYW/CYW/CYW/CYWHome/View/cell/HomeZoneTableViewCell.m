//
//  HomeZoneTableViewCell.m
//  CYW
//
//  Created by jktz on 2018/5/22.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import "HomeZoneTableViewCell.h"
#import "HomeZoneCollectionViewCell.h"
#import "CYWArctileViewController.h"
@interface HomeZoneTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *lineView;
@end
@implementation HomeZoneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self collectionView];
        [self lineView];
    }
    return self;
}

- (UIView *)lineView{
    if (!_lineView) {
        
        _lineView=[UIView new];
        _lineView.backgroundColor=[UIColor colorWithHexString:@"#EFEFEF"];
        [self.contentView addSubview:_lineView];
        _lineView.sd_layout
        .leftSpaceToView(self.contentView, 0)
        .rightSpaceToView(self.contentView, 0)
        .topSpaceToView(self.collectionView, 0)
        .heightIs(10);
    }
    return _lineView;
}
- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 0);
        
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 104) collectionViewLayout:layout];
        _collectionView.showsHorizontalScrollIndicator = NO;        //TODO:以后这里可以扩展
        _collectionView.showsVerticalScrollIndicator = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.scrollEnabled=NO;
        [_collectionView registerClass:[HomeZoneCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.alwaysBounceVertical = YES;
        [self.contentView addSubview:_collectionView];
        
    }
    return _collectionView;
}



#pragma mark - UICollectionView特有的方法

- (CGSize)itemSize {
    return CGSizeMake(SCREEN_WIDTH/3, 104);
    
}

- (UIEdgeInsets)itemEdgeInsets {//top left bottom right
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
//cell的最小行间距
- (CGFloat)minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
//cell的最小列间距
- (CGFloat)minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < [self.titleArray count]) {
        
        HomeZoneCollectionViewCell *cell = (HomeZoneCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
        cell.iconImageView.image=[UIImage imageNamed:self.titleArray[indexPath.row]];
        cell.detaillabel.text=self.titleArray[indexPath.row];
        
        return cell;
    }
    return nil;
    
}



#pragma mark - UICollectionFlowLayout
//item大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self itemSize];
}
//item边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return [self itemEdgeInsets];
}

//cell的最小行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return [self minimumLineSpacingForSectionAtIndex:section];
}

//cell的最小列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return [self minimumInteritemSpacingForSectionAtIndex:section];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //[self loadWebURLSring:loadUrl];
    BaseViewController *currentView=(BaseViewController *)[UIView currentViewController];
    CYWArctileViewController *ArctileVC=[[CYWArctileViewController alloc] init];
    switch (indexPath.row) {
        case 0:
        {
            //当用户如果没有实名认证  先去实名认证
            id object=[[StorageManager sharedInstance] userConfigValueForKey:kCachedUserAuthentication];
            if ([NSObject isEmpty:object]) {
                
                [currentView pushViewController:@"CYWMoreUserCenterAuthenticationViewController"];
            }else{
                
                //活动专区
                
                NSString *loadUrl=[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,@"/mobile/huodongzhuanqu_app"];
                ArctileVC.title=@"活动专区";
                [ArctileVC loadWebURLSring:loadUrl];
                ArctileVC.hidesBottomBarWhenPushed=YES;
                [currentView.navigationController pushViewController:ArctileVC animated:YES];
            }
            
        }
            break;
        case 1:
        {
            
            NSString *loadUrl=[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,@"/mobile/xinshouzhiyin_app"];
            ArctileVC.title=@"新手引导";
            [ArctileVC loadWebURLSring:loadUrl];
            ArctileVC.hidesBottomBarWhenPushed=YES;
            [currentView.navigationController pushViewController:ArctileVC animated:YES];
        }
            break;
        case 2:
        {
            NSString *loadUrl=[NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,@"/mobile/zifeishuoming_app"];
            ArctileVC.title=@"资费说明";
            [ArctileVC loadWebURLSring:loadUrl];
            ArctileVC.hidesBottomBarWhenPushed=YES;
            [currentView.navigationController pushViewController:ArctileVC animated:YES];
        }
            break;
        default:
            break;
    }
}
@end

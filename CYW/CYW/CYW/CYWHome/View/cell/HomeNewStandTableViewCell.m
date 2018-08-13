//
//  HomeNewStandTableViewCell.m
//  CYW
//
//  Created by jktz on 2018/5/22.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import "HomeNewStandTableViewCell.h"
#import "HomeNewStandCollectionViewCell.h"
@interface HomeNewStandTableViewCell()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UIView *lineView;



@end
@implementation HomeNewStandTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle=UITableViewCellSelectionStyleNone;
        [self collectionView];
        [self lineView];
        [self pageControl];
    }
    return self;
}

- (void)reloadData{
    
    CGRect newFrame = self.collectionView.frame;
    self.pageControl.numberOfPages=self.dataArray.count;
    if ([NSArray isNotEmpty:self.dataArray]) {
        newFrame.size.height = 263.0f;//固定
        self.lineView.sd_resetLayout.heightIs(10);
        self.collectionView.frame = newFrame;
    }else{
        
        newFrame.size.height = newFrame.size.height;
        self.lineView.sd_resetLayout.heightIs(0);
        self.collectionView.frame = newFrame;
    }
    [self.collectionView reloadData];
}

+ (CGFloat)cellHeight:(NSArray *)dataArray{
    
    if ([NSArray isNotEmpty:dataArray]) {
        return 273.0f;
    }else{
        
        return 0.0;
    }
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

- (UIPageControl *)pageControl{
    
    if (!_pageControl) {
        
        _pageControl = [UIPageControl new];
        _pageControl.currentPage = 0;
        _pageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor colorWithHexString:@"#f52735"];
        [self.contentView addSubview:_pageControl];
        _pageControl.sd_layout
        .widthIs(SCREEN_WIDTH)
        .heightIs(15)
        .leftSpaceToView(self.contentView, 0)
        .bottomSpaceToView(self.contentView, 8);
    }
    return _pageControl;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollview {
    int page = self.collectionView.contentOffset.x / SCREEN_WIDTH;
    [_pageControl setCurrentPage:page];
    
}
- (UICollectionView *)collectionView{
    
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 0.0) collectionViewLayout:layout];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.pagingEnabled=YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerClass:[HomeNewStandCollectionViewCell class] forCellWithReuseIdentifier:kCellIdentifier];
        _collectionView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_collectionView];
        
    }
    return _collectionView;
}



#pragma mark - UICollectionView特有的方法

- (CGSize)itemSize {
    return CGSizeMake(SCREEN_WIDTH, 253);
    
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
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row < [self.dataArray count]) {
        ProjectViewModel *model=(ProjectViewModel *)self.dataArray[indexPath.row];
        HomeNewStandCollectionViewCell *cell = (HomeNewStandCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
        cell.model=model;
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
    
}
@end

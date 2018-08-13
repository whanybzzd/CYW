//
//  CYWAssetsCalderView.m
//  CYW
//
//  Created by jktz on 2017/11/21.
//  Copyright © 2017年 jktz. All rights reserved.
//

#define cellW ((SCREEN_WIDTH-20)/7)
#define cellCount 30

#import "CYWAssetsCalderView.h"
#import "DCHDateHelper.h"
#import "CYWAssetsCollectionViewCell.h"
#import "CYWAssetsCalendarViewModel.h"
@interface CYWAssetsCalderView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *layout;
@property (weak, nonatomic) IBOutlet UICollectionView *calendarCollect;
@property (strong, nonatomic)NSDate *selectDate;

@property (strong, nonatomic)NSMutableDictionary *cellDict;
@property (strong, nonatomic) CYWAssetsCalendarViewModel *calendarViewModel;
@property (assign, nonatomic) NSInteger numberOfDaysInMonth;
@property (strong, nonatomic) NSMutableArray *signArray;
@end
@implementation CYWAssetsCalderView

- (NSMutableDictionary *)cellDict
{
    if (!_cellDict) {
        _cellDict = [NSMutableDictionary dictionary];
    }
    return _cellDict;
}


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    
    self.calendarViewModel=[[CYWAssetsCalendarViewModel alloc] init];
    self.backgroundColor=[UIColor whiteColor];
    
    self.layout.itemSize = CGSizeMake(cellW, cellW+15);
    self.layout.minimumLineSpacing = 0;
    self.layout.minimumInteritemSpacing = 0;
    
    self.calendarCollect.scrollEnabled = NO;
    self.calendarCollect.delegate = self;
    self.calendarCollect.dataSource = self;
    [self.calendarCollect registerClass:[CYWAssetsCollectionViewCell class] forCellWithReuseIdentifier:@"CYWAssetsCollectionViewCell"];
    
    @weakify(self)
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"show" object:nil] subscribeNext:^(NSNotification * _Nullable x) {
        @strongify(self)
        
        //NSLog(@"%@",x.object[@"selected"]);
        NSArray *cells = [self.calendarCollect visibleCells];
        if (1==[x.object[@"selected"] integerValue]) {
            
            //隐藏
            for (CYWAssetsCollectionViewCell *cell in cells) {
                
                
                cell.pricelabel.hidden=YES;
                if (cell.tag==[self monthOf:cell.tag]) {
                    cell.rightView.hidden=NO;
                }
            }
        }else{
            //显示
            for (CYWAssetsCollectionViewCell *cell in cells) {
                
                if (cell.tag==[self monthOf:cell.tag]) {
                    cell.rightView.hidden=YES;
                    cell.pricelabel.hidden=NO;
                }
                else{
                    
                    cell.pricelabel.hidden=YES;
                }
                
            }
    
        }
        
    }];
}

- (void)setCurDate:(NSDate *)curDate
{
    _curDate = curDate;
    [self month:[DCHDateHelper getStrFromDateFormat:@"yyyy-MM" Date:curDate]];
    [self.calendarCollect reloadData];
}

- (void)month:(NSString *)month{
    
    @weakify(self)
    
    self.signArray=[NSMutableArray array];
    self.calendarViewModel.day=month;
    [[self.calendarViewModel.refreshCalendarMonthCommand execute:nil] subscribeNext:^(id  _Nullable x) {
        @strongify(self)
         [self.signArray removeAllObjects];
        [self.signArray addObject:x];
        [self.calendarCollect reloadData];
        
    } error:^(NSError * _Nullable error) {
        
        
    }];
    
}

#pragma  mark - UICollectionViewDelegate,UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSInteger count = [DCHDateHelper getRows:self.curDate] * 7;
    return count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CYWAssetsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CYWAssetsCollectionViewCell" forIndexPath:indexPath];
    cell.tag=indexPath.item;
    NSDate *celldate = [self dateForCellAtIndexPath:indexPath];
    cell.curDate = self.curDate;
    cell.cellDate = celldate;
   NSString *day= [DCHDateHelper getStrFromDateFormat:@"yyyy-MM-dd" Date:celldate];//获取当月的具体日期
   
    cell.tag=[[DCHDateHelper getStrFromDateFormat:@"d" Date:celldate] integerValue];
    
    CalendarMonthViewModel *model=[self dayOf:day];
    if ([day isEqualToString:model.repayDate]) {//时间相同
        
        cell.rightView.hidden=NO;
        cell.pricelabel.hidden=NO;
        cell.numberlabel.text=model.counts;
        if ([model.sumMoney floatValue]>=10000) {
            
             cell.pricelabel.text=[NSString stringWithFormat:@"%.2lf万",[model.sumMoney floatValue]/10000];
        }else{
            
             cell.pricelabel.text=[NSString stringWithFormat:@"%.2lf",[model.sumMoney floatValue]];
        }
        [cell.pricelabel sizeToFit];
    }else{
        
        cell.rightView.hidden=YES;
        cell.pricelabel.hidden=YES;
    }
    [self.cellDict setObject:cell forKey:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDate *celldate = [self dateForCellAtIndexPath:indexPath];
    NSString *currentDate = [DCHDateHelper getStrFromDateFormat:@"yyyy-MM-dd" Date:celldate];
    
    //用通知的原因是过渡了好几个界面了
    [[NSNotificationCenter defaultCenter] postNotificationName:@"load" object:@{@"load":currentDate}];
    
    
    CYWAssetsCollectionViewCell *curCell = [self.cellDict objectForKey:indexPath];
    [[NSUserDefaults standardUserDefaults] setValue:curCell.pricelabel.text forKey:@"money"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}




//获取cell的日期 (日 -> 六   格式,如需修改星期排序只需修改该函数即可)
- (NSDate *)dateForCellAtIndexPath:(NSIndexPath *)indexPath {
    
    NSCalendar *myCalendar = [NSCalendar currentCalendar];
    NSDate *firstOfMonth = [DCHDateHelper GetFirstDayOfMonth:self.curDate];
    NSInteger ordinalityOfFirstDay = [myCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekOfMonth forDate:firstOfMonth];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = (1 - ordinalityOfFirstDay) + indexPath.item;
    return [myCalendar dateByAddingComponents:dateComponents toDate:firstOfMonth options:0];
    
}

- (void)dealloc{
    NSLog(@"日历销毁");
}

/**
 判断天数中是否相等
 
 @return 天数
 */
- (CalendarMonthViewModel *)dayOf:(NSString *)day{
    
    CalendarMonthViewModel *models;
    for (CalendarMonthViewModel *dates in [self.signArray firstObject]) {
        
        if ([day isEqualToString:dates.repayDate]) {
            models=dates;
            return models;
        }else{
            
            continue;
        }
    }
    
    return models;
}



- (NSInteger )monthOf:(NSInteger)day{
    
    NSInteger days=0;
    for (CalendarMonthViewModel *dates in [self.signArray firstObject]) {
        
        NSInteger str=[[dates.repayDate componentsSeparatedByString:@"-"][2] integerValue];
        if (day==str) {
            days=str;
            return days;
        }else{
            
            continue;
        }
    }
    
    return days;
}
@end

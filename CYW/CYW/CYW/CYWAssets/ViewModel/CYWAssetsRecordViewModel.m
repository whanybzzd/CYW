//
//  CYWAssetsRecordViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/23.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsRecordViewModel.h"
@interface CYWAssetsRecordViewModel()
@property (nonatomic, assign) NSInteger curePage;
@property (nonatomic, retain) NSMutableArray *typeArray;

@end
@implementation CYWAssetsRecordViewModel
- (instancetype)init{
    if (self=[super init]) {
        self.curePage=1;
        self.dataModelArray=[NSMutableArray array];
        self.monthArray=[NSMutableArray array];
        self.typeArray=[NSMutableArray array];
        self.dataArray=[NSMutableArray array];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    _refresRecordCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
         @strongify(self)
        return [self refreRecorddData];
    }];
    
    
    _refresSearchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refreSearchData];
    }];
    
}

//交易记录
- (RACSignal *)refreSearchData{
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        if (1==self.refreshType) {
            self.curePage=1;
        }else{
            
            self.curePage++;
        }
        [AFNManager postDataWithAPI:@"cashFlowRequestHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"typeInfo":self.object[@"type"],
                                      @"startTime":self.object[@"start"],
                                      @"endTime":self.object[@"end"],
                                      @"curPage":@(self.curePage),
                                      @"size":@"10",
                                      @"type":@""}
                      withModelName:@""
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       //NSLog(@"交易记录筛选:%@",responseObject);
                       if (1==self.refreshType) {
                           
                           [self.dataModelArray removeAllObjects];
                           [self.monthArray removeAllObjects];
                           [self.typeArray removeAllObjects];
                           [self.dataArray removeAllObjects];
                       }
                      
                       
                       id object=[NSObject data:responseObject[@"data"] modelName:@"TransactViewModel"];
                       
                       CGFloat moneytotal=0.0f;
                       //NSLog(@"请求到的数据积累:%@",object);
                       for (id models in object) {
                           
                           TransactViewModel *model=(TransactViewModel *)models;
                           
                           moneytotal+=[model.money integerValue];
                           //NSString *time=[self timeStringWithTimeInterval:[self cTimestampFromString:model.time]];
                           
                           NSArray *timeArray=[[NSDate TimeStamps:[self cTimestampFromString:model.time]] componentsSeparatedByString:@"-"];
                           
                           NSString *year=timeArray[0];//获取年
                           NSString *month=timeArray[1];//获取月
                           
                           
                           //得到当前的年份
                           NSArray *currentArray=[[self getCurrentYearsOrMonth] componentsSeparatedByString:@"-"];
                           NSString *currentYear=currentArray[0];//获取当前的年份
                           NSString *currentMonth=currentArray[1];//获取当前的月份
                           
                           //判断是否为本年
                           if ([year isEqualToString:currentYear]) {
                               
                               [self.typeArray addObject:[NSString stringWithFormat:@"%@月",month]];
                           }else{
                               
                               [self.typeArray addObject:[NSString stringWithFormat:@"%@-%@",currentYear,currentMonth]];
                           }
                           
                           
                           [self.dataModelArray addObject:model];
                           
                       }
                       
                       [self.dataArray removeAllObjects];
                       for (NSString *str in self.typeArray) {
                           
                           //制作分组的头   当如果有相同的头文字后，就不添加了   就添加分组
                           if (![self.monthArray containsObject:str]) {
                               
                               [self.monthArray addObject:str];
                           }
                       }
                       
                       // NSLog(@"monthArray:%@",self.monthArray);
                       for (NSString *time in self.monthArray) {
                           
                           NSMutableArray *arr = [[NSMutableArray alloc] init];
                           
                           for (TransactViewModel *model in self.dataModelArray) {
                               
                               NSString *times=[[NSDate TimeStamps:[self cTimestampFromString:model.time]] componentsSeparatedByString:@"-"][1];
                               //NSString *times=[self timeStringWithTimeInterval:[self cTimestampFromString:model.time]];
                               // NSLog(@"time---:%@, times---:%@",time,times);
                               if ([time isEqualToString:[NSString stringWithFormat:@"%@月",times]]) {
                                   
                                   [arr addObject:model];
                                   
                               }
                               
                           }
                           [self.dataArray addObject:arr];
                       }
                       
                       NSString *str=[NSString stringWithFormat:@"%.2lf",moneytotal];
                       [subscriber sendNext:str];
                       [subscriber sendCompleted];
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       [subscriber sendError:nil];
                   }];
        
        return nil;
    }] doNext:^(id x) {
        
        
    }] doError:^(NSError * _Nonnull error) {
        
    }];
}

//交易记录
- (RACSignal *)refreRecorddData{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
         @strongify(self)
        if (1==self.refreshType) {
            self.curePage=1;
        }else{
            
            self.curePage++;
        }
        [AFNManager postDataWithAPI:@"cashFlowRequestHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"curPage":@(self.curePage),
                                      @"size":@"10",
                                      @"type":@"",
                                      @"typeInfo":@""}
                      withModelName:@""
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       if ([NSObject isNotEmpty:responseObject]&&[NSObject isNotEmpty:responseObject[@"data"]]) {
                            @strongify(self)
                           
                           if (1==self.refreshType) {
                               
                               [self.dataModelArray removeAllObjects];
                               [self.monthArray removeAllObjects];
                               [self.typeArray removeAllObjects];
                               [self.dataArray removeAllObjects];
                           }
                           id object=[NSObject data:responseObject[@"data"] modelName:@"TransactViewModel"];
                           
                           //NSLog(@"请求到的数据积累:%@",object);
                           for (id models in object) {
                               
                               TransactViewModel *model=(TransactViewModel *)models;
                               
                               //NSString *time=[self timeStringWithTimeInterval:[self cTimestampFromString:model.time]];
                               
                               NSArray *timeArray=[[NSDate TimeStamps:[self cTimestampFromString:model.time]] componentsSeparatedByString:@"-"];
                               
                               NSString *year=timeArray[0];//获取年
                               NSString *month=timeArray[1];//获取月
                               
                               
                               //得到当前的年份
                               NSArray *currentArray=[[self getCurrentYearsOrMonth] componentsSeparatedByString:@"-"];
                               NSString *currentYear=currentArray[0];//获取当前的年份
                               NSString *currentMonth=currentArray[1];//获取当前的月份
                               
                               //判断是否为本年
                               if ([year isEqualToString:currentYear]) {
                                   
                                   [self.typeArray addObject:[NSString stringWithFormat:@"%@月",month]];
                               }else{
                                   
                                   [self.typeArray addObject:[NSString stringWithFormat:@"%@-%@",currentYear,currentMonth]];
                               }
                               
                               
                               [self.dataModelArray addObject:model];
                               
                           }
                           
                           [self.dataArray removeAllObjects];
                           for (NSString *str in self.typeArray) {
                               
                               //制作分组的头   当如果有相同的头文字后，就不添加了   就添加分组
                               if (![self.monthArray containsObject:str]) {
                                   
                                   [self.monthArray addObject:str];
                               }
                           }
                           
                          // NSLog(@"monthArray:%@",self.monthArray);
                           for (NSString *time in self.monthArray) {
                               
                               NSMutableArray *arr = [[NSMutableArray alloc] init];
                               
                               for (TransactViewModel *model in self.dataModelArray) {
                                   
                                   NSString *times=[[NSDate TimeStamps:[self cTimestampFromString:model.time]] componentsSeparatedByString:@"-"][1];
                                   //NSString *times=[self timeStringWithTimeInterval:[self cTimestampFromString:model.time]];
                                  // NSLog(@"time---:%@, times---:%@",time,times);
                                   if ([time isEqualToString:[NSString stringWithFormat:@"%@月",times]]) {
                                       
                                       [arr addObject:model];
                                       
                                   }
                                   
                               }
                               [self.dataArray addObject:arr];
                           }
                           
                           //NSLog(@"这里是不是已经先执行了：%@",self.dataArray);
                           [subscriber sendNext:self.dataArray];
                           [subscriber sendCompleted];
                       }else{
                           
                           [subscriber sendError:nil];
                       }
                       
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       
                       [subscriber sendError:nil];
                       
                   }];
        
        return nil;
    }] doNext:^(id x) {
        
        
    }] doError:^(NSError * _Nonnull error) {
        
    }];
}

-(NSString *)cTimestampFromString:(NSString *)theTime{
    //装换为时间戳
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //[formatter setDateStyle:NSDateFormatterMediumStyle];
    //[formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    NSDate* dateTodo = [formatter dateFromString:theTime];
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[dateTodo timeIntervalSince1970]];
    
    return timeSp;
}


- (NSString *)getCurrentYearsOrMonth{
    
    // 获取代表公历的NSCalendar对象
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate* dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear |
    NSCalendarUnitMonth |  NSCalendarUnitDay |
    NSCalendarUnitHour |  NSCalendarUnitMinute |
    NSCalendarUnitSecond | NSCalendarUnitWeekday;
    // 获取不同时间字段的信息
    NSDateComponents* comp = [gregorian components: unitFlags
                                          fromDate:dt];
    NSString *str=[NSString stringWithFormat:@"%zd-%zd",comp.year,comp.month];
    return str;
}


@end

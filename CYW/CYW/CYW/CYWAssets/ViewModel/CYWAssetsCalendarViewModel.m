//
//  CYWAssetsCalendarViewModel.m
//  CYW
//
//  Created by jktz on 2017/11/23.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsCalendarViewModel.h"

@implementation CYWAssetsCalendarViewModel
- (instancetype)init{
    if (self=[super init]) {
        self.dataModelArray=[NSMutableArray array];
        self.monthlArray=[NSMutableArray array];
        self.moneyArray=[NSMutableArray array];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    _refreshCalendarCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refreshMessageData];
    }];
    
    _refreshCalendarMonthCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refreshMonthData];
    }];
    
}
- (RACSignal *)refreshMonthData{
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [AFNManager postDataWithAPI:@"investRepayCalendarHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"op":@"summary",
                                      @"repayMonth":self.day}
                      withModelName:@"CalendarMonthViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       //NSLog(@"明细:%@",responseObject);
                       [self.monthlArray removeAllObjects];
                       if ([NSObject isNotEmpty:responseObject]) {
                           
                           for (id models in responseObject) {
                               
                               CalendarMonthViewModel *model=(CalendarMonthViewModel *)models;
                               [self.monthlArray addObject:model];
                           }
                       }
                       [subscriber sendNext:self.monthlArray];
                       [subscriber sendCompleted];
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       
                       [subscriber sendError:nil];
                       
                   }];
        
        return nil;
    }] doNext:^(id x) {
        
        
    }] doError:^(NSError * _Nonnull error) {
        
    }];
}

- (RACSignal *)refreshMessageData{
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [AFNManager postDataWithAPI:@"investRepayCalendarHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"op":@"detail",
                                      @"repayDay":self.day}
                      withModelName:@"CalendarMonthDetailViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                      // NSLog(@"明细:%@",responseObject);
                       [self.dataModelArray removeAllObjects];
                       [self.moneyArray removeAllObjects];
                       
                       if ([NSObject isNotEmpty:responseObject]) {
                           
                           CGFloat dymoney=0.0f;//待还本金
                           CGFloat yhmonty=0.0f;//已还本金
                           CGFloat dyinster=0.0f;//待还利息
                           CGFloat yhinster=0.0f;//已还利息
                           
                           for (id models in responseObject) {
                               
                               CalendarMonthDetailViewModel *model=(CalendarMonthDetailViewModel *)models;
                               [self.dataModelArray addObject:model];
                               
                               
                               
                               
                               //已经还了
                               if ([model.status isEqualToString:@"complete"]) {//已经完成
                                   
                                   yhmonty=[model.corpus floatValue];
                                   yhinster=[model.interest floatValue]+[model.defaultInterest floatValue]-[model.fee floatValue];
                               }else{
                                   
                                   dymoney=[model.corpus floatValue];
                                   dyinster=[model.interest floatValue]+[model.defaultInterest floatValue]-[model.fee floatValue];
                               }
                           }
                           
                           NSMutableDictionary *dict=[NSMutableDictionary dictionary];
                           [dict setValue:[NSString stringWithFormat:@"%.2lf",dymoney] forKey:@"dymoney"];
                           [dict setValue:[NSString stringWithFormat:@"%.2lf",yhmonty] forKey:@"yhmonty"];
                           [dict setValue:[NSString stringWithFormat:@"%.2lf",dyinster] forKey:@"dyinster"];
                           [dict setValue:[NSString stringWithFormat:@"%.2lf",yhinster] forKey:@"yhinster"];
                           [self.moneyArray addObject:dict];
                           
                           
                           [subscriber sendNext:nil];
                           [subscriber sendCompleted];
                       }
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       
                       [subscriber sendError:nil];
                       
                   }];
        
        return nil;
    }] doNext:^(id x) {
        
        
    }] doError:^(NSError * _Nonnull error) {
        
    }];
}
@end

//
//  CYWCalculatorViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/30.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWCalculatorViewModel.h"

@implementation CYWCalculatorViewModel
- (instancetype)init{
    if (self=[super init]) {
        
        self.dataModelArray=[NSMutableArray array];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    _refreshcomputationsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refrescomputationsData];
    }];
    
    
}


//计算收益
- (RACSignal *)refrescomputationsData{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
       @strongify(self)
        NSDictionary *dicParam=@{@"investAmount":self.cal,
                                 @"investTerms":self.limit,
                                 @"investRate":self.ann,
                                 @"loanType":@"rfcl",
                                 @"repayName":@"先付利息后还本金，按天计息，即投即生息"};
        
        
        [AFNManager postDataWithAPI:@"incomeCalculatorHandler"
                      withDictParam:dicParam
                      withModelName:@""
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       
                       //NSLog(@"计算收益:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]) {
                           
                           [subscriber sendNext:responseObject[@"allProfit"]];
                           [subscriber sendCompleted];
                       }else{
                           
                           [subscriber sendError:nil];
                       }
                      
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       
                       [subscriber sendError:(NSError *)errorMessage];
                   }];
        
        return nil;
    }] doNext:^(id x) {
        
        
    }] doError:^(NSError * _Nonnull error) {
        
    }];
}

@end

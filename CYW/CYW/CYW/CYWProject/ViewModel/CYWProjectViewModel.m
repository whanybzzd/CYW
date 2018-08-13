//
//  CYWProjectViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWProjectViewModel.h"

@implementation CYWProjectViewModel
- (instancetype)init{
    if (self=[super init]) {
        self.curpageIndex=1;
        self.dataModelArray=[NSMutableArray array];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    
    _refresProjectCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refreshNewData];
    }];
    
    _refreshCreditorsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refresCreditorsData];
    }];
    
    
}
//债权列表
- (RACSignal *)refresCreditorsData{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        if (1==self.refreshIndex) {
            self.curpageIndex=1;
        }else{
            self.curpageIndex++;
        }
        
        
        NSDictionary *dicParam=@{@"curPage":@(self.curpageIndex),
                                 @"size":@"10"};
        
        
        [AFNManager postDataWithAPI:@"transferApplyListRequestHandlerImpl"
                      withDictParam:dicParam
                      withModelName:@""
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       @strongify(self)
                       //NSLog(@"债权列表:%@",responseObject);
                       if (1==self.refreshIndex) {
                           [self.dataModelArray removeAllObjects];
                       }
                       if ([NSObject isNotEmpty:responseObject]) {
                           id respon=[NSObject data:responseObject[@"data"] modelName:@"ProjectRightsViewModel"];

                           for (id models in respon) {

                               ProjectRightsViewModel *model=(ProjectRightsViewModel *)models;

                               [self.dataModelArray addObject:model];

                           }
                           [subscriber sendNext:self.dataModelArray];
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
//项目列表
- (RACSignal *)refreshNewData{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        if (1==self.refreshIndex) {
            self.curpageIndex=1;
            
        }else{
            self.curpageIndex++;
        }
        
        
        NSDictionary *dicParam=@{@"isRecommend":@"",
                                 @"loanActivityType":self.type,
                                 @"status":@"全部",
                                 @"curPage":@(self.curpageIndex),
                                 @"size":@"10",
                                 @"businessType":@"",
                                 @"minDeadline":@"0",
                                 @"maxDeadline":@"0",
                                 @"minRate":@"0",
                                 @"maxRate":@"0",
                                 @"minLoanMoney":@"0",
                                 @"maxLoanMoney":@"0"};
        
        
        [AFNManager postDataWithAPI:@"loanRequestHandler"
                      withDictParam:dicParam
                      withModelName:@""
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       @strongify(self)
                       //NSLog(@"项目列表:%@",responseObject);
                       if (1==self.refreshIndex) {
                           
                           [self.dataModelArray removeAllObjects];
                       }
                       if ([NSObject isNotEmpty:responseObject]) {
                           id respon=[NSObject data:responseObject[@"data"] modelName:@"ProjectViewModel"];
                           
                           for (id models in respon) {
                               
                               ProjectViewModel *model=(ProjectViewModel *)models;
                               
                               [self.dataModelArray addObject:model];
                               
                           }
                           [subscriber sendNext:self.dataModelArray];
                           [subscriber sendCompleted];
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

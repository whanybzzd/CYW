//
//  CYWFinanceViewModel.m
//  CYW
//
//  Created by jktz on 2017/11/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWFinanceViewModel.h"

@implementation CYWFinanceViewModel
- (instancetype)init{
    if (self=[super init]) {
        self.dataModelArray=[NSMutableArray array];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    _refreshFinanceCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refresIntegral];
    }];
    
    _refreshCenterCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refresCenter];
    }];
    
    
}

//获取本月排名
- (RACSignal *)refresCenter{
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [AFNManager postDataWithAPI:@"investRankRequestHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"op":@"personal"}
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       if ([NSObject isNotEmpty:responseObject]&&
                           [responseObject[@"resultCode"] isEqualToString:@"SUCCESS"]) {
                           
                           NSObject *dataModel=[NSDictionary dictionaryWithJsonString:[NSString TripleDES:responseObject[@"result"] encryptOrDecrypt:kCCDecrypt key:K3DESKey]];
                           //NSLog(@"dataModel:%@",dataModel);
                           //没有必要这样的写法
                           //id models=[NSObject data:responseObject[@"result"] modelName:@"RankViewModel"];
                           //RankViewModel *model=(RankViewModel *)models;
                           
                           NSArray *array=(NSArray *)dataModel;
                           NSString *str=[array firstObject][@"investor"];
                           [subscriber sendNext:str];
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


- (RACSignal *)refresIntegral{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        
        [AFNManager postDataWithAPI:@"investRankRequestHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"op":@"investList",
                                      @"investType":self.type}
                      withModelName:@"BankViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       @strongify(self)
                       [self.dataModelArray removeAllObjects];
                       if ([NSObject isNotEmpty:responseObject]) {
                           
                           
                           //因为要取得第一名的数据  所以这样写
                           NSArray *array=(NSArray *)responseObject;
                           if ([NSArray isNotEmpty:array]) {
                               
                               for (int i=1; i<array.count; i++) {
                                   
                                   BankViewModel *model=(BankViewModel *)array[i];
                                   [self.dataModelArray addObject:model];
                               }
                           }
                           
                           [subscriber sendNext:array[0]];
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

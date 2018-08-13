//
//  CYWMoreIntegralViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/24.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreIntegralViewModel.h"

@implementation CYWMoreIntegralViewModel
- (instancetype)init{
    if (self=[super init]) {
        self.dataModelArray=[NSMutableArray array];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    _refreshIntegralCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refresIntegral];
    }];
    
    
}
- (RACSignal *)refresIntegral{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        [AFNManager postDataWithAPI:@"userLevelRequestHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token}
                      withModelName:@"IntegralViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       @strongify(self)
                       [self.dataModelArray removeAllObjects];
                       //NSLog(@"所有积分:%@",responseObject);
                       if([NSObject isNotEmpty:responseObject]){
                           for (id models in responseObject) {

                               IntegralViewModel *model=(IntegralViewModel *)models;
                               [self.dataModelArray addObject:model];
                           }

                           [subscriber sendNext:self.dataModelArray];
                           [subscriber sendCompleted];
                       }else{
                           
                           [subscriber sendError:nil];
                       }
                       
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       [UIView showResultThenHide:@"请求错误"];
                       [subscriber sendError:nil];
                   }];
        
        
        return nil;
    }] doNext:^(id x) {
        
        
    }] doError:^(NSError * _Nonnull error) {
        
    }];
}
@end

//
//  CYWMoreUserCenterefereesViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreUserCenterefereesViewModel.h"

@implementation CYWMoreUserCenterefereesViewModel
- (instancetype)init{
    if (self=[super init]) {
        self.dataModelArray=[NSMutableArray array];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    _refreshrefereesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refresAvaterData];
    }];
    
    
}
- (RACSignal *)refresAvaterData{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [AFNManager postDataWithAPI:@"referrerRequestHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"op":@"query"}
                      withModelName:@"ReferrerViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       @strongify(self)
                       //NSLog(@"推荐人:%@",responseObject);
                       if([NSObject isNotEmpty:responseObject]){
                           for (id models in responseObject) {

                               ReferrerViewModel *model=(ReferrerViewModel *)models;
                               [self.dataModelArray addObject:model];
                           }

                           [subscriber sendNext:self.dataModelArray];
                           [subscriber sendCompleted];
                       }else{


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

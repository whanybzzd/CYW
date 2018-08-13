//
//  CYWAssetsCarManagerViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsCarManagerViewModel.h"

@implementation CYWAssetsCarManagerViewModel
- (instancetype)init{
    if (self=[super init]) {
        
        self.datassetslArray=[NSMutableArray array];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    RAC(self, dataSource) = [self.refreshDataCommand.executionSignals.switchToLatest map:^id(NSArray *recommends) {
        
        
        return [recommends.rac_sequence map:^id _Nullable(id  _Nullable value) {
            
            return value;
        }].array;
    }];
    
    _refresBindCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[self refreshBindCarData] takeUntil:self.rac_willDeallocSignal];
    }];
    
    _refresDeleteCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
         @strongify(self)
        return [[self refreshDeleteCarData] takeUntil:self.rac_willDeallocSignal];
    }];
    
}

- (RACSignal *)refreshDeleteCarData{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
         @strongify(self)
        NSDictionary *dicParam=@{@"userId":[Login sharedInstance].token,
                                 @"bankCardId":self.deleteCarId,
                                 @"op":@"deleted"};
        [AFNManager postDataWithAPI:@"mmmpayBankCardRequestHandler"
                      withDictParam:dicParam
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                      // NSLog(@"删除银行卡:%@",responseObject);
                       
                       if ([NSObject isNotEmpty:responseObject]) {
                           [subscriber sendNext:nil];
                           [subscriber sendCompleted];
                       }else{
                           NSString *str=[NSString TripleDES:responseObject[@"result"] encryptOrDecrypt:kCCDecrypt key:K3DESKey];
                           [subscriber sendError:(NSError *)str];
                       }
                       
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       [subscriber sendError:(NSError *)errorMessage];
                   }];
        
        return nil;
    }] doNext:^(id x) {
        
        
    }] doError:^(NSError * _Nonnull error) {
        
    }];
}

- (RACSignal *)refreshBindCarData{
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        NSDictionary *dicParam=@{@"userId":[Login sharedInstance].token};
        [AFNManager postDataWithAPI:@"mmmpayBindBankCardHandler"
                      withDictParam:dicParam
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       //NSLog(@"绑定银行卡:%@",responseObject);
                       
                       if ([NSObject isNotEmpty:responseObject]&&
                           [NSString isNotEmpty:responseObject[@"result"]]) {
                           
                           
                           NSString *str=[NSString TripleDES:responseObject[@"result"] encryptOrDecrypt:kCCDecrypt key:K3DESKey];
                           //NSLog(@"绑定银行卡:%@",str);
                           [subscriber sendNext:str];
                           [subscriber sendCompleted];
                       }else{
                           NSString *str=[NSString TripleDES:responseObject[@"resultMsg"] encryptOrDecrypt:kCCDecrypt key:K3DESKey];
                           [subscriber sendError:(NSError *)str];
                       }
                       
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       [subscriber sendError:(NSError *)errorMessage];
                   }];
        
        return nil;
    }] doNext:^(id x) {
        
        
    }] doError:^(NSError * _Nonnull error) {
        
    }];
}

- (RACSignal *)refreshNewData{
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
     @strongify(self)
        
      
        NSDictionary *dicParam=@{@"op":@"query",
                                 @"userId":[Login sharedInstance].token};
        
        [AFNManager postDataWithAPI:@"mmmpayBankCardRequestHandler"
                      withDictParam:dicParam
                      withModelName:@"CarManagerMentViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       //NSLog(@"我的银行卡:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]) {
                            @strongify(self)
                           [self.datassetslArray removeAllObjects];
                           for (id models in responseObject) {
                               CarManagerMentViewModel *model=(CarManagerMentViewModel *)models;
                               [self.datassetslArray addObject:model];
                               
                           }
                            [[StorageManager sharedInstance] setUserConfigValue:self.datassetslArray forKey:kCachedUserCarManager];
                           [subscriber sendNext:self.datassetslArray];
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
@end

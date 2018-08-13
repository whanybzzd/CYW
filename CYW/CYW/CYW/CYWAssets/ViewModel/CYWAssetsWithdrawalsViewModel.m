//
//  CYWAssetsWithdrawalsViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsWithdrawalsViewModel.h"

@implementation CYWAssetsWithdrawalsViewModel
- (instancetype)init{
    if (self=[super init]) {
        
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    @weakify(self)
    _refresWithdrawalsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
         @strongify(self)
        return [self refreshWithdrawalsData];
    }];
    
    _refresrechargeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
         @strongify(self)
        return [self refreshrecharge];
    }];
    
    _refresrewithdrawalCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
         @strongify(self)
        return [self refrewithdrawal];
    }];
    
}

//提现
- (RACSignal *)refrewithdrawal{
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
         @strongify(self)
        [AFNManager postDataWithAPI:@"mmmpayWithdrawRequestHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"money":self.price,
                                      @"fee":self.free,
                                      @"bankCardId":self.carId}
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       NSLog(@"提现:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]&&
                           [NSString isNotEmpty:responseObject[@"result"]]) {
                           NSString *str=[NSString TripleDES:responseObject[@"result"] encryptOrDecrypt:kCCDecrypt key:K3DESKey];
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

//充值
- (RACSignal *)refreshrecharge{
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
         @strongify(self)
        //[UIView showHUDLoading:nil];
        [AFNManager postDataWithAPI:@"mmmpayRechargeRequestHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"actualMoney":self.price,
                                      @"fee":self.free,
                                      @"rechargeWay":@"pnrpay"}
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       NSLog(@"充值:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]&&
                           [NSString isNotEmpty:responseObject[@"result"]]) {
                           //[UIView hideHUDLoading];
                            NSString *str=[NSString TripleDES:responseObject[@"result"] encryptOrDecrypt:kCCDecrypt key:K3DESKey];
                               
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


- (RACSignal *)refreshWithdrawalsData{
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
         //@strongify(self)
        [AFNManager postDataWithAPI:@"calculateFeeRequestHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"money":self.value,
                                      @"op":self.type}
                      withModelName:@"FreeViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                        //@strongify(self)
                       //NSLog(@"提现还是充值:%@====:%@",responseObject,self.type);
                       if ([NSObject isNotEmpty:responseObject]) {
                           FreeViewModel *model=(FreeViewModel *)responseObject;
                           [subscriber sendNext:model];
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

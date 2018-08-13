//
//  CYWAssetsCreditorViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/13.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsCreditorViewModel.h"
@interface CYWAssetsCreditorViewModel()
@property (nonatomic, retain) NSMutableArray *datassetslArray;
@end
@implementation CYWAssetsCreditorViewModel
- (instancetype)init{
    if (self=[super init]) {
        
        self.datassetslArray=[NSMutableArray array];
    }
    return self;
}



- (RACSignal *)cancelTransfer:(NSString *)inverstId{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [AFNManager postDataWithAPI:@"transferApplyCancelRequestHandler"
                      withDictParam:@{@"transferApplyId":inverstId}
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       //NSLog(@"取消转让:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]&&[responseObject[@"resultCode"] isEqualToString:@"SUCCESS"]) {
                           [subscriber sendNext:nil];
                           [subscriber sendCompleted];
                           
                       }else{
                           
                           [subscriber sendError:nil];
                       }
                       
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       
                       [subscriber sendError:nil];
                       
                   }];
        
        return [RACDisposable disposableWithBlock:^{
            
            
        }];
        
    }];
    
}


- (RACSignal *)transfer:(NSString *)investId extensionId:(NSString *)extensionId trans:(NSString *)trans perium:(NSString *)perium action:(NSString *)action{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [AFNManager postDataWithAPI:@"transferApplyInvestHandlerImpl"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"investId":investId,
                                      @"extensionId":extensionId,
                                      @"transferMoney":trans,
                                      @"premium":perium,
                                      @"action":@"transfer"}
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       NSLog(@"转让:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]&&[responseObject[@"resultCode"] isEqualToString:@"SUCCESS"]) {
                           [subscriber sendNext:nil];
                           [subscriber sendCompleted];
                           
                       }else{
                           
                           NSString *str=[NSString TripleDES:responseObject[@"resultMsg"] encryptOrDecrypt:kCCDecrypt key:K3DESKey];
                           NSLog(@"错误:%@",str);
                           [subscriber sendError:(NSError *)str];
                       }
                       
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       
                       [subscriber sendError:nil];
                       
                   }];
        
        return [RACDisposable disposableWithBlock:^{
            
            
        }];
        
    }];
    
}


- (RACSignal *)refreshNormal:(NSString *)type curpage:(NSInteger)page{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [AFNManager postDataWithAPI:@"transferApplyRequestHandler"
                      withDictParam:@{@"size":@"10",
                                      @"op":type,
                                      @"curPage":@(page),
                                      @"userId":[Login sharedInstance].token}
                      withModelName:@""
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       //NSLog(@"我的债权:%@",responseObject);
                       
                       if ([NSObject isNotEmpty:responseObject]&&
                           [NSObject isNotEmpty:responseObject[@"data"]]) {
                           
                           id resp=[NSObject data:responseObject[@"data"] modelName:@"CreditorViewModel"];

                           
                           [subscriber sendNext:resp];
                           [subscriber sendCompleted];
                       }else{
                           [subscriber sendError:nil];
                       }
                       
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       [subscriber sendError:nil];
                   }];
        
        return [RACDisposable disposableWithBlock:^{
            
            
        }];
        
    }];
}


- (RACSignal *)refreshInverstId:(NSString *)inverstId{
    
    
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [AFNManager postDataWithAPI:@"investRepaysHandler"
                      withDictParam:@{@"investId":inverstId}
                      withModelName:@"InterestCompleteViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       
                       if ([NSObject isNotEmpty:responseObject]) {
                           
                           for (id models in responseObject) {
                               
                               InterestCompleteViewModel *model=(InterestCompleteViewModel *)models;
                               
                               [self.datassetslArray addObject:model];
                           }
                           
                           [subscriber sendNext:[NSString stringWithFormat:@"%zd",self.datassetslArray.count]];
                           [subscriber sendCompleted];
                       }
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       
                       
                   }];
        
        return [RACDisposable disposableWithBlock:^{
            
            
        }];
        
    }];
    
    
    
}


@end

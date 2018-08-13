//
//  CYWMoreUserCenterAuthenticationViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreUserCenterAuthenticationViewModel.h"

@implementation CYWMoreUserCenterAuthenticationViewModel
- (instancetype)init{
    if (self=[super init]) {
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
       @weakify(self)
    _refreshAuthenticationCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refresAuthenticationData];
    }];
    
    //查询实名认证
    _refreshRealCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refresAuthenticationDatas];
    }];
    
    
}

- (RACSignal *)refresAuthenticationDatas{
    
 
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [AFNManager postDataWithAPI:@"investorPermissionRequestHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token}
                      withModelName:@"AuthenticationViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       NSLog(@"实名认证:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]) {
                           AuthenticationViewModel *model=(AuthenticationViewModel *)responseObject;
                           [[StorageManager sharedInstance] setUserConfigValue:model forKey:kCachedUserAuthentication];
                           [subscriber sendNext:nil];
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


- (RACSignal *)refresAuthenticationData{
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [AFNManager postDataWithAPI:@"mmmpayRegisterRequestHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"idCard":self.idCar,
                                      @"realname":self.name}
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       
                       NSLog(@"实名认证:%@",responseObject);
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
@end

//
//  LoginViewModel.m
//  CYW
//
//  Created by jktz on 2017/11/7.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "LoginViewModel.h"

@implementation LoginViewModel
- (instancetype)init{
    
    if (self=[super init]) {
        
        [self initObject];
    }
    return self;
}
- (void)initObject{
    
    self.loginViewCommand           = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [AFNManager postDataWithAPI:@"centerHandler"
                          withDictParam:@{@"userId":[Login sharedInstance].token}
                          withModelName:@"UserCenterInfoViewModel"
                                isModel:YES
                       requestSuccessed:^(id responseObject) {
                           
                           if ([NSObject isNotEmpty:responseObject]) {
                               
                               UserCenterInfoViewModel *model=(UserCenterInfoViewModel *)responseObject;
                               [[StorageManager sharedInstance] setUserConfigValue:model forKey:kCachedUserCenterInfoModel];
                               
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
        
        
    }];
    
}
@end

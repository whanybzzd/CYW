//
//  CYWRegisterOverViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/9.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWRegisterOverViewModel.h"
#import "AppDelegate.h"
@implementation CYWRegisterOverViewModel
- (instancetype)init{
    
    if (self=[super init]) {
        
        [self initObject];
    }
    return self;
}
- (void)initObject{
    
    
    @weakify(self)
    self.submitCommand=[[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
        [AFNManager postDataWithAPI:@"registRequestHandler"
                      withDictParam:@{@"username":self.username,
                                      @"password":self.password,
                                      @"mobileNumber":self.phonenumber,
                                      @"authCode":self.code,
                                      @"referrerid":self.recommend}
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       
                       NSLog(@"注册是否成功:%@",responseObject)
                       if ([NSObject isNotEmpty:responseObject]&&
                           [responseObject[@"resultCode"] isEqualToString:@"SUCCESS"]) {
                           
                           [subscriber sendNext:nil];
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
    }];
    
}

@end

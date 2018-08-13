//
//  CYWExtenViewModel.m
//  CYW
//
//  Created by jktz on 2018/7/25.
//  Copyright © 2018年 jktz. All rights reserved.
//

#import "CYWExtenViewModel.h"

@implementation CYWExtenViewModel
- (RACSignal *)extenId:(NSString *)iden{
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [AFNManager postDataWithAPI:@"extensionRequestHandler"
                      withDictParam:@{@"id":iden}
                      withModelName:@"ExtenViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       //NSLog(@"responseObject:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]) {
                           
                           ExtenViewModel *model=(ExtenViewModel *)responseObject;
                           [subscriber sendNext:model];
                           [subscriber sendCompleted];
                       }else{
                           
                           [subscriber sendError:nil];
                       }
                       
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       
                       
                       [subscriber sendError:(NSError *)errorMessage];
                   }];
        
        return [RACDisposable disposableWithBlock:^{
            
            
        }];
        
    }];
}
@end

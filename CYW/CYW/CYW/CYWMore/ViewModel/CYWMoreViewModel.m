//
//  CYWMoreViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/20.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreViewModel.h"

@implementation CYWMoreViewModel
- (instancetype)init{
    if (self=[super init]) {
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    self.refreshAboutCommand           = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [AFNManager postDataWithAPI:@"feedbackRequestHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"content":self.text}
                      withModelName:@"BaseModel"
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       
                       //NSLog(@"反馈:%@",responseObject);
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

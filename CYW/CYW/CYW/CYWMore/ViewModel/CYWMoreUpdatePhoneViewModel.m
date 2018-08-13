//
//  CYWMoreUpdatePhoneViewModel.m
//  CYW
//
//  Created by jktz on 2017/11/9.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreUpdatePhoneViewModel.h"

@implementation CYWMoreUpdatePhoneViewModel
- (instancetype)init{
    if (self=[super init]) {
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    _refreshSendCodeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        
        UIButton *button=(UIButton *)input;
        __block NSInteger seconds=60;//block语句块中修改值
        
        return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            
            [AFNManager postDataWithAPI:@"smsRequestHandler"
                          withDictParam:@{@"userId":[Login sharedInstance].token,
                                          @"phone":self.phone,
                                          @"op":self.type}
                          withModelName:@""
                                isModel:NO
                       requestSuccessed:^(id responseObject) {
                           
                           if ([NSObject isNotEmpty:responseObject]&&
                               [responseObject[@"resultCode"] isEqualToString:@"SUCCESS"]) {
                               button.userInteractionEnabled=NO;
                               
                               [NSTimer bk_scheduledTimerWithTimeInterval:1.0 block:^(NSTimer *timer) {
                                   
                                   seconds--;
                                   [button setTitle:[NSString stringWithFormat:@"%zd后获取",seconds] forState:UIControlStateNormal];
                                   if (seconds<=0) {
                                       [button setTitle:@"获取验证码" forState:UIControlStateNormal];
                                       [timer invalidate];
                                       timer=nil;
                                       button.userInteractionEnabled=YES;
                                   }
                               }repeats:YES];
                               [subscriber sendNext:@"获取成功"];
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
    
    
    
    
    
    
    
    
    
    _refreshsubmitCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        
        return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            
            [AFNManager postDataWithAPI:@"phoneUpdateHandler"
                          withDictParam:@{@"userId":[Login sharedInstance].token,
                                          @"phone":self.phone,
                                          @"op":self.op,
                                          @"code":self.code}
                          withModelName:@""
                                isModel:NO
                       requestSuccessed:^(id responseObject) {
                           
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

//
//  CYWRegisteViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/9.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWRegisteViewModel.h"

@implementation CYWRegisteViewModel
- (instancetype)init{
    
    if (self=[super init]) {
        
        [self initObject];
    }
    return self;
}
- (void)initObject{
    
    
    @weakify(self)
    self.codeCommand=[[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        
        return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
        
        
        UIButton *button=(UIButton *)input;
        __block NSInteger seconds=60;//block语句块中修改值
        
        
        
        //[UIView showHUDLoading:nil];
        [AFNManager postDataWithAPI:@"smsRequestHandler"
                      withDictParam:@{@"phone":self.password,
                                      @"op":@"zhuce",
                                      @"userId":self.username}
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       
                       
                       NSLog(@"获取验证码:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]&&
                           [responseObject[@"resultCode"] isEqualToString:@"SUCCESS"]) {
                           [UIView showResultThenHide:@"获取成功"];
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
    
    
}

@end

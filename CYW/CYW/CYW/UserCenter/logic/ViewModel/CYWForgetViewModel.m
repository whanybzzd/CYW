//
//  CYWForgetViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/10.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWForgetViewModel.h"
#import "AppDelegate.h"
@implementation CYWForgetViewModel
- (instancetype)init{
    
    if (self=[super init]) {
        
        [self initObject];
    }
    return self;
}


- (void)initObject{
    
    @weakify(self)
    self.forgetCommand=[[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        UIButton *button=(UIButton *)input;
        __block NSInteger seconds=60;//block语句块中修改值
        
        
        @strongify(self)
        [AFNManager postDataWithAPI:@"smsRequestHandler"
                      withDictParam:@{@"phone":self.phonenumber,
                                      @"op":@"zhaohui",
                                      @"userId":@""}
                      withModelName:@"UserViewModel"
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       
                       
                       //NSLog(@"找回密码:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]&&
                            [NSObject isNotEmpty:responseObject[@"result"]]) {
                           
                          NSObject *ob= [NSDictionary dictionaryWithJsonString:[NSString TripleDES:responseObject[@"result"] encryptOrDecrypt:kCCDecrypt key:K3DESKey]];
                          
                           id object=[NSObject data:ob modelName:@"UserViewModel"];
                           UserViewModel *model=(UserViewModel *)object;
                           
                           self.userId=model.userId;
                           [[NSUserDefaults standardUserDefaults] setValue:model.userId forKey:@"userId"];
                           [[NSUserDefaults standardUserDefaults] synchronize];
                           
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
    
    
    
    self.nextCommand=[[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        //NSLog(@"phone:%@===code:%@:====userId:%@",self.phonenumber,self.code,self.userId);
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            [AFNManager postDataWithAPI:@"pwdFindHandler"
                          withDictParam:@{@"phone":self.phonenumber,
                                          @"code":self.code,
                                          @"userId":self.userId}
                          withModelName:@""
                                isModel:NO
                       requestSuccessed:^(id responseObject) {
                           
                           
                           //NSLog(@"下一步找回密码:%@===userId:%@",responseObject,self.userId);
                           if ([NSObject isNotEmpty:responseObject]&&
                               [responseObject[@"resultCode"] isEqualToString:@"SUCCESS"]) {
                               [subscriber sendNext:@100];
                               [subscriber sendCompleted];
                           }else{
                               NSString *str=[NSString TripleDES:responseObject[@"resultMsg"] encryptOrDecrypt:kCCDecrypt key:K3DESKey];
                               [UIView showResultThenHide:str];
                               [subscriber sendError:(NSError *)str];
                           }
                       } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                           [subscriber sendError:(NSError *)errorMessage];
                       }];
            
            return [RACDisposable disposableWithBlock:^{
                NSLog(@"信号被销毁");
            }];
        }];
        
    }];
    
    
    self.submitCommand=[[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        
        //NSLog(@"提交找回密码1111:%@===提交找回密码2222:%@====userId:%@",self.newpassword,self.againpassword,self.userId);
        return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [AFNManager postDataWithAPI:@"pwdFind2Handler"
                      withDictParam:@{@"newPwd":self.newpassword,
                                      @"newPwd1":self.againpassword,
                                      @"userId":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]}
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                      // NSLog(@"提交找回密码:%@===userId:%@",responseObject,[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
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

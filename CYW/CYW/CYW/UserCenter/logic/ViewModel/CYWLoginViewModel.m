//
//  CYWLoginViewModel.m
//  CYW
//
//  Created by jktz on 2017/9/28.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWLoginViewModel.h"
#import "AppDelegate.h"
@implementation CYWLoginViewModel

- (instancetype)init{
    
    if (self=[super init]) {
        
        [self initObject];
    }
    return self;
}
- (void)initObject{
    
    @weakify(self);
    self.loginCommand           = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self)
            [AFNManager postDataWithAPI:@"loginRequestHandler"
                          withDictParam:@{@"username":self.username,
                                          @"password":self.password,
                                          @"isNewVersion":@"yes"}//提示用户更新
                          withModelName:@"ParentModel"//ParentModel
                                isModel:NO
                       requestSuccessed:^(id responseObject) {
                           //NSLog(@"登录:%@",responseObject);
                           if ([NSObject isNotEmpty:responseObject[@"result"]]) {
                               
                               
                               id obje=[NSObject data:[NSDictionary dictionaryWithJsonString:[NSString TripleDES:responseObject[@"result"] encryptOrDecrypt:kCCDecrypt key:K3DESKey]] modelName:@"ParentModel"];
                               
                               ParentModel *model=(ParentModel *)obje;
                               [subscriber sendNext:nil];
                               [subscriber sendCompleted];
                               
                               [[StorageManager sharedInstance] setUserConfigValue:model forKey:kCachedUserModel];
                               [[Login sharedInstance] refreshUserInfo];
                               [[Login sharedInstance] refreshAuthentication];
                               [[Login sharedInstance] autoTender];
                               @strongify(self)
                               [self bk_performBlock:^(id obj) {
                                   
                                   //Change to user login information
                                   [((AppDelegate *)[UIApplication sharedApplication].delegate) setTabbarController];
                                   
                               } afterDelay:1.5];
                               
                           }else{
                               
                               NSString *str=[NSString TripleDES:responseObject[@"resultMsg"] encryptOrDecrypt:kCCDecrypt key:K3DESKey];
                               [subscriber sendError:(NSError *)str];
                           }
                           
                           
                           //NSLog(@"登录:%@",responseObject);
//                           ParentModel *model=(ParentModel *)responseObject;
//                           if ([NSObject isNotEmpty:model]) {
//
//                               [subscriber sendNext:nil];
//                               [subscriber sendCompleted];
//
//                               [[StorageManager sharedInstance] setUserConfigValue:model forKey:kCachedUserModel];
//                               [[Login sharedInstance] refreshUserInfo];
//                               [[Login sharedInstance] refreshAuthentication];
//                               [[Login sharedInstance] autoTender];
//                               @strongify(self)
//                               [self bk_performBlock:^(id obj) {
//
//                                   //Change to user login information
//                                   [((AppDelegate *)[UIApplication sharedApplication].delegate) setTabbarController];
//
//                               } afterDelay:1.5];
//
//
//                           }else{
//                               [subscriber sendError:(NSError *)@"用户名或者密码错误"];
//                           }
                           //NSLog(@"登录:%@",model);
                           
                       } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                           [subscriber sendError:(NSError *)errorMessage];
                       }];
            
            return nil;
        }] doNext:^(id x) {
            
            
        }] doError:^(NSError * _Nonnull error) {
            
        }];
        
        
    }];
    
    
    
    
    
    
    self.guestCommand           = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            @strongify(self)
            [AFNManager postDataWithAPI:@"loginRequestHandler"
                          withDictParam:@{@"username":self.username,
                                          @"password":self.password,
                                          @"isNewVersion":@"yes"}//提示用户更新
                          withModelName:@"ParentModel"//ParentModel
                                isModel:YES
                       requestSuccessed:^(id responseObject) {
                           ParentModel *model=(ParentModel *)responseObject;
                           if ([NSObject isNotEmpty:model]) {
                               [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"switch"];
                               [[NSUserDefaults standardUserDefaults] synchronize];
                               
                               [[NSNotificationCenter defaultCenter] postNotificationName:@"switch" object:nil];
                               
                               [subscriber sendNext:nil];
                               [subscriber sendCompleted];
                               
                               
                           }else{
                               [subscriber sendError:(NSError *)@"用户名或者密码错误"];
                           }
                           
                       } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                           [subscriber sendError:(NSError *)@"用户名或者密码错误"];
                       }];
            
            return nil;
        }] doNext:^(id x) {
            
            
        }] doError:^(NSError * _Nonnull error) {
            
        }];
        
        
    }];
    
    
}

@end

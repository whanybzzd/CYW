//
//  CYWMoreAutomaticViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/23.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreAutomaticViewModel.h"

@implementation CYWMoreAutomaticViewModel
- (instancetype)init{
    
    if (self=[super init]) {
        
        [self initObject];
    }
    return self;
}
- (void)initObject{
    
    @weakify(self);
    self.autoCommand           = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
         return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        [AFNManager postDataWithAPI:@"mmmpayAutoInvestHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"investMoney":self.investMoney,
                                      @"remainMoney":self.remainMoney,
                                      @"minInvestMoney":self.save,
                                      @"minRate":self.minRate,
                                      @"maxRate":self.maxRate,
                                      @"minDeadline":self.minDeadline,
                                      @"maxDeadline":self.maxDeadline,
                                      @"op":@"1",
                                      @"type":self.type}
                      withModelName:@"AutomaticallySaveViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       if ([NSObject isNotEmpty:responseObject]) {

                           AutomaticallySaveViewModel *model=(AutomaticallySaveViewModel *)responseObject;
                           [[StorageManager sharedInstance] setUserConfigValue:model forKey:kCachedUserAuto];
                           [subscriber sendNext:nil];
                           [subscriber sendCompleted];
                       }else{
                           [subscriber sendError:(NSError *)@"保存失败"];
                           
                       }
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       
                       [subscriber sendError:(NSError *)errorMessage];
                   }];
             return nil;
             
         }] doNext:^(id x) {
             
             
         }] doError:^(NSError * _Nonnull error) {
             
         }];
    }];
    

    
    
    
    
    self.autoCloseCommand           = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        [AFNManager postDataWithAPI:@"mmmpayAutoInvestHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"op":@"0"}
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       
                       
                       if ([NSObject isNotEmpty:responseObject]&&
                           [responseObject[@"resultCode"] isEqualToString:@"SUCCESS"]) {
                           NSLog(@"关闭成功");
                           [[StorageManager sharedInstance] setUserConfigValue:@"" forKey:kCachedUserAuto];
                       }else{
                           NSLog(@"关闭失败");
                       }
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       NSLog(@"网络错误");
                   }];
        return [RACSignal empty];
        
    }];
    
    
    
    self.autoSuccessCommand           = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            [AFNManager postDataWithAPI:@"mmmpayAutoInvestHandler"
                          withDictParam:@{@"userId":[Login sharedInstance].token,
                                          @"op":@"2"}
                          withModelName:@""
                                isModel:NO
                       requestSuccessed:^(id responseObject) {
                           
                           
                           if ([NSObject isNotEmpty:responseObject]&&
                               [responseObject[@"resultCode"] isEqualToString:@"SUCCESS"]) {
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

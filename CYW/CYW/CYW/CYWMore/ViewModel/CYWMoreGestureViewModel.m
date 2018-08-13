//
//  CYWMoreGestureViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/20.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreGestureViewModel.h"
#import "AppDelegate.h"
@implementation CYWMoreGestureViewModel
- (instancetype)init{
    if (self=[super init]) {
        @weakify(self)
        _refreshUnlockCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [self refresUnlockData];
        }];
        
        
        _refreshUnlockloginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            return [self refresUnlockDatalogin];
        }];
        
        
        _refreshforgetCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
           @strongify(self)
            return [self refresforgetData];
        }];
        
        _refreshvalidationCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
           @strongify(self)
            return [self refresvalidation];
        }];
    }
    return self;
}



//忘记手势密码
- (RACSignal *)refresforgetData{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        //[UIView showHUDLoading:@"正在验证"];
        [AFNManager postDataWithAPI:@"loginPatternUnlockRequestHandler"
                      withDictParam:@{@"username":[Login sharedInstance].token,
                                      @"patternUnlockStr":self.password,
                                      @"op":@"update"}
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       
                       //[UIView hideHUDLoading];
                       //NSLog(@"忘记手势密码:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]&&
                           [responseObject[@"resultCode"] isEqualToString:@"SUCCESS"]) {
                           //[UIView showResultThenHide:@"验证成功,请重新登录"];
                          
                           [subscriber sendNext:nil];
                           [subscriber sendCompleted];
                           
                       }else{
                           [subscriber sendError:nil];
                       }
                       [[NSUserDefaults standardUserDefaults] synchronize];
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       [subscriber sendError:nil];
                   }];
        
        
        return nil;
    }] doNext:^(id x) {
        
        
    }] doError:^(NSError * _Nonnull error) {
        
    }];
}



//手势密码登录
- (RACSignal *)refresUnlockDatalogin{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [AFNManager postDataWithAPI:@"loginPatternUnlockRequestHandler"
                      withDictParam:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"kCachedUserName"],
                                      @"patternUnlockStr":self.password,
                                      @"op":@"login"}
                      withModelName:@"ParentModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       @strongify(self)
                       //NSLog(@"手势密码登录:%@",responseObject);
                       ParentModel *model=(ParentModel *)responseObject;
                       if ([NSObject isNotEmpty:model]) {
                           
                           //[UIView showResultThenHide:@"登陆成功"];
                           [[StorageManager sharedInstance] setUserConfigValue:model forKey:kCachedUserModel];
                           [[Login sharedInstance] refreshUserInfo];
                           [[Login sharedInstance] refreshAuthentication];
                           
                           [self bk_performBlock:^(id obj) {
                               
                               //Change to user login information
                               [((AppDelegate *)[UIApplication sharedApplication].delegate) setTabbarController];
                              
                               
                           } afterDelay:2.5];
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

//开启手势密码
- (RACSignal *)refresUnlockData{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [AFNManager postDataWithAPI:@"loginPatternUnlockRequestHandler"
                      withDictParam:@{@"username":[Login sharedInstance].token,
                                      @"patternUnlockStr":self.password,
                                      @"op":@"update"}
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       
                       //NSLog(@"开启手势密码:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]&&
                           [responseObject[@"resultCode"] isEqualToString:@"SUCCESS"]) {
                           //[UIView showResultThenHide:@"开启手势密码成功"];
                           [[NSUserDefaults standardUserDefaults] setValue:@"1" forKey:@"switch"];
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"switch" object:nil];
                           
                           [subscriber sendNext:nil];
                           [subscriber sendCompleted];
                           
                       }else{
                           [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"switch"];
                           [subscriber sendError:nil];
                       }
                       [[NSUserDefaults standardUserDefaults] synchronize];
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       [subscriber sendError:nil];
                   }];
        
        
        return nil;
    }] doNext:^(id x) {
        
        
    }] doError:^(NSError * _Nonnull error) {
        
    }];
}



//验证手势密码
- (RACSignal *)refresvalidation{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [AFNManager postDataWithAPI:@"loginPatternUnlockRequestHandler"
                      withDictParam:@{@"username":[[NSUserDefaults standardUserDefaults] objectForKey:@"kCachedUserName"],
                                      @"patternUnlockStr":self.password,
                                      @"op":@"login"}
                      withModelName:@"ParentModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       
                       //NSLog(@"手势密码登录:%@",responseObject);
                       ParentModel *model=(ParentModel *)responseObject;
                       if ([NSObject isNotEmpty:model]) {
                           
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


@end

//
//  CYWMoreUserCenterViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/18.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWMoreUserCenterViewModel.h"

@implementation CYWMoreUserCenterViewModel
- (instancetype)init{
    if (self=[super init]) {
        
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    _refreshCenterAvaterCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refresAvaterData];
    }];
    
    
}

//上传头像
- (RACSignal *)refresAvaterData{
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
      
        [AFNManager postDataWithAPI:@"uploadImageHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"photo":self.photo}
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       //NSLog(@"上传头像:%@",responseObject);
                       if([NSObject isNotEmpty:responseObject]){

                           [[Login sharedInstance] refreshUserInfos];
                           
                           [subscriber sendNext:nil];
                           [subscriber sendCompleted];
                       }else{

                           NSString *str=[NSString TripleDES:responseObject[@"resultMsg"] encryptOrDecrypt:kCCDecrypt key:K3DESKey];
                           //[UIView showResultThenHide:str];
                           [subscriber sendError:(NSError *)str];
                       }
                       
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       [subscriber sendError:(NSError *)errorMessage];
                   }];
        
        
        return nil;
    }] doNext:^(id x) {
        
        
    }] doError:^(NSError * _Nonnull error) {
        
    }];
}

@end

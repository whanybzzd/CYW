//
//  CYWVersionViewModel.m
//  CYW
//
//  Created by jktz on 2017/11/16.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWVersionViewModel.h"

@implementation CYWVersionViewModel
- (instancetype)init{
    if (self=[super init]) {
        self.dataModelArray=[NSMutableArray array];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    _refreshVersionCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refresVersionData];
    }];
    
    
}


- (RACSignal *)refresVersionData{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        //@strongify(self)
        [AFNManager postDataWithAPI:@"loginPatternUnlockRequestHandler"
                      withDictParam:nil
                      withModelName:@""
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       
                       NSLog(@"所有版本信息:%@",responseObject);
                      
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       [subscriber sendError:nil];
                   }];
        
        
        return nil;
    }] doNext:^(id x) {
        
        
    }] doError:^(NSError * _Nonnull error) {
        
    }];
}

@end

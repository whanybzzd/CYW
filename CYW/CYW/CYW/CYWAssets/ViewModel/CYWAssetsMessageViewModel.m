//
//  CYWAssetsMessageViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/24.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsMessageViewModel.h"
@interface CYWAssetsMessageViewModel()
@property (nonatomic, assign) NSInteger curePage;
@end
@implementation CYWAssetsMessageViewModel
- (instancetype)init{
    if (self=[super init]) {
        self.dataModelArray=[NSMutableArray array];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    _refreshMessageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refreshMessageData];
    }];
    
}


//我的借款
- (RACSignal *)refreshMessageData{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [AFNManager postDataWithAPI:@"pushAllRequestHandler"
                      withDictParam:nil
                      withModelName:@"JpushViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       //NSLog(@"推送消息:%@",responseObject);
                       [self.dataModelArray removeAllObjects];
                       if ([NSObject isNotEmpty:responseObject]) {
                           @strongify(self)
                           for (id models in responseObject) {
                               
                               JpushViewModel *model=(JpushViewModel *)models;
                               [self.dataModelArray addObject:model];
                           }
                           [subscriber sendNext:self.dataModelArray];
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

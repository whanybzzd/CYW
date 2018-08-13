//
//  CYWHomeBannerViewModel.m
//  CYW
//
//  Created by jktz on 2017/11/6.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWHomeBannerViewModel.h"

@implementation CYWHomeBannerViewModel
- (instancetype)init{
    if (self=[super init]) {
        self.imageArray=[NSMutableArray array];
        self.titleArray=[NSMutableArray array];
        self.urlArray=[NSMutableArray array];
        
        self.articleArray=[NSMutableArray array];
        self.articleIdArray=[NSMutableArray array];
        
        //[self initSubView];
    }
    return self;
}
//- (void)initSubView{
//    
//    
//    @weakify(self)
//    _refreshBannerCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        @strongify(self)
//        return [self refreshNewData];
//    }];
//    
//    
//    
//    _refreshArticCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        @strongify(self)
//        return [self refreshArticNewData];
//    }];
//    
//}
//
//- (RACSignal *)refreshArticNewData{
//    @weakify(self)
//    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        @strongify(self)
//        
//        [AFNManager postDataWithAPI:@"articleNodesHandler"
//                      withDictParam:@{@"termId":@"wangzhangonggao"}
//                      withModelName:@"ArticleViewModel"
//                            isModel:YES
//                   requestSuccessed:^(id responseObject) {
//                       
//                       //NSLog(@"请求公告L:%@",responseObject);
//                       @strongify(self)
//                       [self.articleArray removeAllObjects];
//                       [self.articleIdArray removeAllObjects];
//                       
//                       if ([NSObject isNotEmpty:responseObject]) {
//                           for (id model in responseObject) {
//                               
//                               ArticleViewModel *viewModel=(ArticleViewModel *)model;
//                               [self.articleArray addObject:viewModel.title];
//                               [self.articleIdArray addObject:viewModel.id];
//                           }
//                           [subscriber sendNext:nil];
//                           [subscriber sendCompleted];
//                       }else{
//                           
//                           [subscriber sendError:nil];
//                           
//                       }
//                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
//                       
//                        [subscriber sendError:nil];
//                   }];
//        
//        return nil;
//    }] doNext:^(id x) {
//        
//        
//    }] doError:^(NSError * _Nonnull error) {
//        
//    }];
//}



- (RACSignal *)refreshNewData{
    @weakify(self)
    return [[[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
       
        [AFNManager postDataWithAPI:@"bannerRequestHandler"
                      withDictParam:nil
                      withModelName:@"BannerViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       @strongify(self)
                       
                       //NSLog(@"bannerresponseObject:%@",responseObject);
                           [self.imageArray removeAllObjects];
                           [self.titleArray removeAllObjects];
                           [self.urlArray removeAllObjects];
                       
                       if ([NSObject isNotEmpty:responseObject]) {
                           for (id model in responseObject) {
                               
                               BannerViewModel *viewModel=(BannerViewModel *)model;
                               NSString *imageUrl = [NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,viewModel.picture];
                               [self.imageArray addObject:imageUrl];
                               
                               NSString *titleUrl = [NSString stringWithFormat:@"%@%@",kResPathAppImageUrl,viewModel.url];
                               [self.urlArray addObject:titleUrl];
                               
                               [self.titleArray addObject:viewModel.title];
                           }
                           //[subscriber sendNext:nil];
                           [subscriber sendCompleted];
                       }else{
                           
                           [subscriber sendError:nil];
                       }
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       
                       [subscriber sendError:(NSError *)errorMessage];
                   }];
        
        return nil;
    }] doNext:^(id x) {
        
        
    }] doError:^(NSError * _Nonnull error) {
        
    }] then:^RACSignal * _Nonnull{
        
        
        
        return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            
            [AFNManager postDataWithAPI:@"articleNodesHandler"
                          withDictParam:@{@"termId":@"wangzhangonggao"}
                          withModelName:@"ArticleViewModel"
                                isModel:YES
                       requestSuccessed:^(id responseObject) {
                           
                           //NSLog(@"请求公告L:%@",responseObject);
                           @strongify(self)
                           [self.articleArray removeAllObjects];
                           [self.articleIdArray removeAllObjects];
                           
                           if ([NSObject isNotEmpty:responseObject]) {
                               for (id model in responseObject) {
                                   
                                   ArticleViewModel *viewModel=(ArticleViewModel *)model;
                                   [self.articleArray addObject:viewModel.title];
                                   [self.articleIdArray addObject:viewModel.id];
                               }
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

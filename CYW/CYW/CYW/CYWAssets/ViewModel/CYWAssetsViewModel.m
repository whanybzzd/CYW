//
//  CYWAssetsViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/12.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsViewModel.h"

@implementation CYWAssetsViewModel
- (instancetype)init{
    if (self=[super init]) {
        
        self.datassetslArray=[NSMutableArray array];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    RAC(self, dataSource) = [self.refreshDataCommand.executionSignals.switchToLatest map:^id(NSArray *recommends) {
        
        
        return [recommends.rac_sequence map:^id _Nullable(id  _Nullable value) {
            
            return value;
        }].array;
    }];
    
    
    
    _refreshEnvelopeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refreshEnvelopeData];
    }];
}

//请求红包
- (RACSignal *)refreshEnvelopeData{
    
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [AFNManager postDataWithAPI:@"myUserCouponUnusedRequestHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token}
                      withModelName:@""
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       //NSLog(@"我的红包sss:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]) {
                           
                           NSArray *envelopeArray=(NSArray *)responseObject;
                           
                           // NSLog(@"count:%zd",envelopeArray.count);
                           
                           //记录有多少个红包可以用
                           [[NSUserDefaults standardUserDefaults] setValue:[NSString stringWithFormat:@"%zd",envelopeArray.count] forKey:@"envelope"];
                           [[NSUserDefaults standardUserDefaults] synchronize];
                           
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

//- (RACSignal *)refreshNewData{
//
//    @weakify(self)
//    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        @strongify(self)
//        if (1==self.refreshIndex) {
//            self.curpageIndex=1;
//
//        }else{
//            self.curpageIndex++;
//        }
//
//
//        NSDictionary *dicParam=nil;
//        if ([NSString isNotEmpty:self.loadId]) {
//
//            dicParam=@{@"size":@"5",
//                       @"status":self.refreshType,
//                       @"curPage":@(self.curpageIndex),
//                       @"userId":[Login sharedInstance].token,
//                       @"loadId":self.loadId};
//        }else{
//
//            dicParam=@{@"size":@"5",
//                       @"status":self.refreshType,
//                       @"curPage":@(self.curpageIndex),
//                       @"userId":[Login sharedInstance].token};
//        }
//
//        //NSLog(@"红包参数:%@",dicParam);
//        [AFNManager postDataWithAPI:@"myUserCouponRequestHandler"
//                      withDictParam:dicParam
//                      withModelName:@""
//                            isModel:YES
//                   requestSuccessed:^(id responseObject) {// type interest  加息  discount  红包
//                       //NSLog(@"我的红包:%@",responseObject);
//                       if ([NSObject isNotEmpty:responseObject]&&[NSObject isNotEmpty:responseObject[@"data"]]) {
//                           @strongify(self)
//                           if (1==self.refreshIndex) {
//
//                               [self.datassetslArray removeAllObjects];
//                           }
//                           for (id models in responseObject[@"data"]) {
//
//                               [self.datassetslArray addObject:models];
//
//                           }
//                           [subscriber sendNext:self.datassetslArray];
//                           [subscriber sendCompleted];
//                       }else{
//                           [subscriber sendError:nil];
//                       }
//
//
//                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
//                       [subscriber sendError:nil];
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



- (RACSignal *)loadRefreshDataType:(RefreshType)type{
    
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
         @strongify(self)
        if (Refreshload==type) {//正常刷新
            self.curpageIndex=1;
            
        }else{
            self.curpageIndex++;
            
        }
        NSDictionary *dicParam=nil;
        if ([NSString isNotEmpty:self.loadId]) {
            
            dicParam=@{@"size":@"5",
                       @"status":self.refreshType,
                       @"curPage":@(self.curpageIndex),
                       @"userId":[Login sharedInstance].token,
                       @"loadId":self.loadId};
        }else{
            
            dicParam=@{@"size":@"5",
                       @"status":self.refreshType,
                       @"curPage":@(self.curpageIndex),
                       @"userId":[Login sharedInstance].token};
        }
        
        
        [AFNManager postDataWithAPI:@"myUserCouponRequestHandler"
                      withDictParam:dicParam
                      withModelName:@""
                            isModel:YES
                   requestSuccessed:^(id responseObject) {// type interest  加息  discount  红包
                       //NSLog(@"我的红包:%i",type);
                       if ([NSObject isNotEmpty:responseObject]&&[NSObject isNotEmpty:responseObject[@"data"]]) {
                           @strongify(self)
                           if (Refreshload==type) {
                               
                               [self.datassetslArray removeAllObjects];
                           }
                           for (id models in responseObject[@"data"]) {
                               
                               [self.datassetslArray addObject:models];
                               
                           }
                           [subscriber sendNext:nil];
                           [subscriber sendCompleted];
                       }else{
                           if (Refreshload==type) {
                               
                               [self.datassetslArray removeAllObjects];
                           }
                           [subscriber sendError:nil];
                       }
                       
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                      
                       [subscriber sendError:nil];
                   }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
        
        
    }];
}
@end

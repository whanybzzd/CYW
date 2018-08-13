//
//  CYWAssetsBorrowedViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/19.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsBorrowedViewModel.h"
@interface CYWAssetsBorrowedViewModel()
@property (nonatomic, assign) NSInteger curePage;
@end
@implementation CYWAssetsBorrowedViewModel
- (instancetype)init{
    if (self=[super init]) {
        self.dataModelArray=[NSMutableArray array];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    _refresBorrowedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
         @strongify(self)
        return [self refreBorrowedData];
    }];
    
}

//我的借款
- (RACSignal *)refreBorrowedData{
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
         @strongify(self)
        if (1==self.refreshType) {
            self.curePage=1;
        }else{
            
            self.curePage++;
        }
        [AFNManager postDataWithAPI:@"myLoanRequestHandler"
                      withDictParam:@{@"userId":[Login sharedInstance].token,
                                      @"op":self.refreshDataType,
                                      @"curPage":@(self.curePage),
                                      @"size":@"10",
                                      @"startTime":[NSObject isEmpty:self.object]?@"":self.object[@"startTime"],
                                      @"endTime":[NSObject isEmpty:self.object]?@"":self.object[@"endTime"],
                                      @"month":@""}
                      withModelName:@""
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       //NSLog(@"我的借款:%@",responseObject);
                       @strongify(self)
                       if (1==self.refreshType) {
                           [self.dataModelArray removeAllObjects];
                       }
                       if ([NSObject isNotEmpty:responseObject]&&[NSObject isNotEmpty:responseObject[@"data"]]) {
                           
                           
                           id object=[NSObject data:responseObject[@"data"] modelName:@"ProjectViewModel"];
                           for (id models in object) {
                               
                               ProjectViewModel *model=(ProjectViewModel *)models;
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

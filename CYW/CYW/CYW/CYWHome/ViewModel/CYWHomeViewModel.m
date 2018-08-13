//
//  CYWHomeViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/10.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWHomeViewModel.h"
//@interface CYWHomeViewModel()
//@property (nonatomic, assign) NSInteger curpageIndex;
//
//@end
@implementation CYWHomeViewModel
- (instancetype)init{
    if (self=[super init]) {
        //self.curpageIndex=1;
        self.dataModelArray=[NSMutableArray array];
        self.noviceArray=[NSMutableArray array];
        //[self initSubView];
    }
    return self;
}
//- (void)initSubView{
//
//
//    @weakify(self)
//    _refreshHomeCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
//        @strongify(self)
//        return [self refreshNewData];
//    }];
//
//
//}


- (RACSignal *)refreshNewData{
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        
        
        
        NSDictionary *dicParam=@{@"isRecommend":@"1",//表示推荐项目
                                 @"status":@"全部",
                                 @"curPage":@(1),
                                 @"size":@"10",
                                 @"businessType":@"",
                                 @"minDeadline":@"0",
                                 @"maxDeadline":@"0",
                                 @"minRate":@"0",
                                 @"maxRate":@"0",
                                 @"minLoanMoney":@"0",
                                 @"maxLoanMoney":@"0"};
        
        
        [AFNManager postDataWithAPI:@"loanRequestHandler"
                      withDictParam:dicParam
                      withModelName:@""
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       @strongify(self)
                       //只能在这里清空
                       
                       [self.dataModelArray removeAllObjects];
                       [self.noviceArray removeAllObjects];
                       
                       
                       if ([NSObject isNotEmpty:responseObject]) {
                           id respon=[NSObject data:responseObject[@"data"] modelName:@"ProjectViewModel"];
                           
                           for (id models in respon) {
                               
                               ProjectViewModel *model=(ProjectViewModel *)models;
                               if ([model.loanActivityType isEqualToString:@"xs"]) {//判断是否为新手标段
                                   [self.noviceArray addObject:model];
                                   
                               }else{
                                   
                                   [self.dataModelArray addObject:model];
                               }
                               
                           }
                           [subscriber sendNext:nil];
                           [subscriber sendCompleted];
                       }else{
                           
                           [subscriber sendError:nil];
                       }
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       
                       [subscriber sendError:(NSError *)errorMessage];
                   }];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }] doNext:^(id x) {
        
        
    }] doError:^(NSError * _Nonnull error) {
        
    }];
}


@end

//
//  CYWAssetsInvestViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/16.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsInvestViewModel.h"

@implementation CYWAssetsInvestViewModel
- (instancetype)init{
    if (self=[super init]) {
        self.curpageIndex=1;
        self.datassetslArray=[NSMutableArray array];
        self.stateArray=[NSMutableArray array];
        self.borrowedDataArray=[NSMutableArray array];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    _refresInvestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[self refreshloadInvestData] takeUntil:self.rac_willDeallocSignal];
    }];
    
    _refresStateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[self refreshStateInvestData] takeUntil:self.rac_willDeallocSignal];
    }];
    
    
    //我的借款还款计划
    _refresBorrowedCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[self refreshBorrowedData] takeUntil:self.rac_willDeallocSignal];
    }];
    
    
    _refresRepaymentsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[self refreshRepaymentsBorrowedData] takeUntil:self.rac_willDeallocSignal];
    }];
    
}

//还款
- (RACSignal *)refreshRepaymentsBorrowedData{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [AFNManager postDataWithAPI:@"mmmpayRepayRequestHandler"
                      withDictParam:@{@"loanRepayId":self.borrowId}
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       //NSLog(@"responseObject:%@",responseObject);
                       
                       
                       if ([NSObject isNotEmpty:responseObject]&&
                           [responseObject[@"resultCode"] isEqualToString:@"SUCCESS"]) {
                           NSString *str=[NSString TripleDES:responseObject[@"resultMsg"] encryptOrDecrypt:kCCDecrypt key:K3DESKey];
                           [subscriber sendNext:str];
                           [subscriber sendCompleted];
                       }else{
                           
                           NSString *str=[NSString TripleDES:responseObject[@"resultMsg"] encryptOrDecrypt:kCCDecrypt key:K3DESKey];
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







//我的借款还款计划
- (RACSignal *)refreshBorrowedData{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [AFNManager postDataWithAPI:@"loanRepaysHandler"
                      withDictParam:@{@"loanId":self.borrowId}
                      withModelName:@"BorrowedPlanViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       //NSLog(@"我的借款还款计划:%@",responseObject);
                       [self.borrowedDataArray removeAllObjects];
                       if ([NSObject isNotEmpty:responseObject]) {
                           @strongify(self)
                           for (id models in responseObject) {
                               
                               BorrowedPlanViewModel *model=(BorrowedPlanViewModel *)models;
                               [self.borrowedDataArray addObject:model];
                           }
                           
                           [subscriber sendNext:nil];
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
        
    }];
}




- (RACSignal *)refreshloadInvestData{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        if (1==self.refreshIndex) {
            self.curpageIndex=1;
        }else{
            self.curpageIndex++;
        }
        NSDictionary *dicParam=@{@"userId":[Login sharedInstance].token,
                                 @"op":@"all",
                                 @"curPage":@(self.curpageIndex),
                                 @"size":@"10",
                                 @"startTime":@"",
                                 @"endTime":@"",
                                 @"month":@""};
        
        
        //[UIView showHUDLoading:nil];
        [AFNManager postDataWithAPI:@"myInvestRequestHandler"
                      withDictParam:dicParam
                      withModelName:@""
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       @strongify(self)
                       if (1==self.refreshIndex) {
                           [self.datassetslArray removeAllObjects];
                       }
                       if ([NSObject isNotEmpty:responseObject]&&[NSObject isNotEmpty:responseObject[@"data"]]) {
                           //[UIView hideHUDLoading];
                           
                           //计算总的合计
                           CGFloat investTotal=0.0f;//投资金额合计
                           CGFloat reimbursementTotal=0.0f;//还款金额合计
                           CGFloat onlyTotal=0.0f;//已经收的利息
                           CGFloat whTotal=0.0f;//未收合计
                           CGFloat hkTotal=0.0;
                           
                           id object=[NSObject data:responseObject[@"data"] modelName:@"InvestViewModel"];
                           //NSLog(@"object:%@",object);
                           for (id models in object) {
                               
                               InvestViewModel *model=(InvestViewModel *)models;
                               InvestRepayRoadmapViewModel *roadModel=(InvestRepayRoadmapViewModel *)model.repayRoadmap;
                               
                               //NSLog(@"我的投资:%@",model);
                               
                               [self.datassetslArray addObject:model];
                               
                               
                               if ([model.status isEqualToString:@"repaying"]||
                                   [model.status isEqualToString:@"overdue"]) {
                                   
                                   hkTotal+=[model.investMoney floatValue];
                                   
                               }
                               //未收合计==未收的本金+未收的利息
                               whTotal+=[roadModel.unPaidCorpus floatValue]+[roadModel.unPaidInterest floatValue];
                               
                               //计算总的合计
                               investTotal+=[model.investMoney floatValue];
                               //没有收的利息等于   没有收的本金+没有收的利息
                                                                  reimbursementTotal+=[roadModel.paidInterest floatValue]+[roadModel.unPaidInterest floatValue];
                               
                               //已经收的利息等于   已经收的本金+已经收的利息
                               onlyTotal+=+[roadModel.paidInterest floatValue];
                               //whTotal
                               
                           }
                           
                           
                           
                           
                           
                           NSDictionary *dict=@{@"investTotal":[NSString stringWithFormat:@"%.2lf",investTotal],
                                                @"reimbursementTotal":[NSString stringWithFormat:@"%.2lf",reimbursementTotal],
                                                @"hkTotal":[NSString stringWithFormat:@"%.2lf",hkTotal],
                                                @"total":[NSString stringWithFormat:@"%.2lf",onlyTotal],
                                                @"whTotal":[NSString stringWithFormat:@"%.2lf",whTotal]};
                           
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"postInvestName" object:dict];
                           [subscriber sendNext:self.datassetslArray];
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


//我的投资还款计划
- (RACSignal *)refreshStateInvestData{
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        [AFNManager postDataWithAPI:@"investRepaysHandler"
                      withDictParam:@{@"investId":self.investId}
                      withModelName:@"InterestCompleteViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       @strongify(self)
                       //NSLog(@"我的投资还款计划:%@",responseObject);
                       
                       CGFloat investTotal=0.0f;//投资金额合计
                       CGFloat reimbursementTotal=0.0f;//还款金额合计
                       CGFloat onlyTotal=0.0f;//已经收的利息
                       CGFloat whTotal=0.0f;//未收合计
                       CGFloat hkTotal=0.0f;
                       if ([NSObject isNotEmpty:responseObject]) {
                           
                           for (id models in responseObject) {

                               InterestCompleteViewModel *model=(InterestCompleteViewModel *)models;
                               [self.stateArray addObject:model];

                               //计算总的合计
                               investTotal+=[model.corpus floatValue];
                               hkTotal+=[model.corpus floatValue];
                               //没有收的利息等于   没有收的本金+没有收的利息
                               reimbursementTotal+=[model.interest floatValue]+[model.defaultInterest floatValue];

                               if ([model.status isEqualToString:@"repaying"]||
                                   [model.status isEqualToString:@"overdue"]) {

                                   whTotal+=[model.corpus floatValue]+[model.interest floatValue]+[model.defaultInterest floatValue];


                               }


                               if ([model.status isEqualToString:@"complete"]) {

                                   //已经收的利息等于   已经收的本金+已经收的利息
                                   onlyTotal+=[model.interest floatValue]+[model.corpus floatValue];
                               }



                           }
                           
                           
                           
                           NSDictionary *dict=@{@"investTotal":[NSString stringWithFormat:@"%.2lf",investTotal],
                                                @"reimbursementTotal":[NSString stringWithFormat:@"%.2lf",reimbursementTotal],
                                                @"hkTotal":[NSString stringWithFormat:@"%.2lf",hkTotal],
                                                @"total":[NSString stringWithFormat:@"%.2lf",onlyTotal],
                                                @"whTotal":[NSString stringWithFormat:@"%.2lf",whTotal]};
                           
                           [[NSNotificationCenter defaultCenter] postNotificationName:@"postInvestName" object:dict];
                           
                           
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

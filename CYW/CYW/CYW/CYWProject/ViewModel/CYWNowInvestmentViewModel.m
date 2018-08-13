//
//  CYWNowInvestmentViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/31.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWNowInvestmentViewModel.h"

@implementation CYWNowInvestmentViewModel
- (instancetype)init{
    if (self=[super init]) {
        
        self.dataModelArray=[NSMutableArray array];
        self.investsArray=[NSMutableArray array];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    _refreshNowInvestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refresNowInvestmentData];
    }];
    
    _refreshinvestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refresNowInvestmentDatas];
    }];
    
    
    _refreshTransferRepayCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [self refresTransferRepayDatas];
    }];
    
    
}

- (RACSignal *)refresNowInvestmentDatas{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        NSDictionary *dicParam=@{@"loanId":self.loanId,
                                 @"userId":[Login sharedInstance].token,
                                 @"investMoney":self.money,
                                 @"couponId":[NSString isEmpty:[[NSUserDefaults standardUserDefaults] objectForKey:@"envelopeid"]]?@"":[[NSUserDefaults standardUserDefaults] objectForKey:@"envelopeid"],
                                 @"platform":@"ios",
                                 @"versionCode":VersionNumber};
        
        [AFNManager postDataWithAPI:@"mmmpayInvestRequestHandler"
                      withDictParam:dicParam
                      withModelName:@""
                            isModel:NO
                   requestSuccessed:^(id responseObject) {
                       
                       //NSLog(@"投资详情ss:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]&&
                           [NSString isNotEmpty:responseObject[@"result"]]) {
                           NSString *str=[NSString TripleDES:responseObject[@"result"] encryptOrDecrypt:kCCDecrypt key:K3DESKey];
                           
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




//项目详情
- (RACSignal *)refresNowInvestmentData{
    //ProjectViewModel
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        NSDictionary *dicParam=@{@"loanId":self.loanId,
                                 @"objName":@"loanInfoPics,guaranteeInfoPics,loan,invests",
                                 @"loan":@"",
                                 @"invests":@"",
                                 @"loanRepays":@"",
                                 @"loanAttrs":@"",
                                 @"verifyUser":@"",
                                 @"loanInfoPics":@"",
                                 @"guaranteeInfoPics":@"",
                                 @"user":@"",
                                 @"type":@""};
        
        
        [AFNManager postDataWithAPI:@"loanIdFindRequestHandler"
                      withDictParam:dicParam
                      withModelName:@""
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       [self.investsArray removeAllObjects];
                       //NSLog(@"项目详情:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]&&
                           [NSObject isNotEmpty:responseObject[@"loan"]]) {//必须这样判断
                           
                           ProjectViewModel *model=(ProjectViewModel *)[NSObject data:responseObject[@"loan"] modelName:@"ProjectViewModel"];
                           
                           //NowProjectDetailViewModel
                           id resp= [NSObject data:responseObject[@"invests"] modelName:@"NowProjectDetailViewModel"];//这里是个数组
                           for (id models in resp) {
                               
                               NowProjectDetailViewModel *model=(NowProjectDetailViewModel *)models;
                               [self.investsArray addObject:model];
                           }
                           [subscriber sendNext:model];
                           [subscriber sendCompleted];
                       }
                       
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       
                       [subscriber sendError:(NSError *)errorMessage];
                   }];
        
        return nil;
    }] doNext:^(id x) {
        
        
    }] doError:^(NSError * _Nonnull error) {
        
    }];
}


//债权列表详情
- (RACSignal *)refresTransferRepayDatas{
    
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        
        [AFNManager postDataWithAPI:@"transferApplyFindByIdHandlerImpl"
                      withDictParam:@{@"transferId":self.loanId,
                                      @"action":@"transferDetial"}
                      withModelName:@"TransferRepayViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       //NSLog(@"债权列表详情:%@",responseObject);
                       if ([NSObject isNotEmpty:responseObject]) {
                           
                           TransferRepayViewModel *model=(TransferRepayViewModel *)responseObject;
                           [subscriber sendNext:model];
                           [subscriber sendCompleted];
                       }else{
                           
                           [subscriber sendError:nil];
                       }
                       
                       
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       
                       [subscriber sendError:(NSError *)errorMessage];
                   }];
        
        
        //请求债权投资记录详情
        [AFNManager postDataWithAPI:@"transferApplyFindByIdHandlerImpl"
                      withDictParam:@{@"transferId":self.loanId,
                                      @"action":@"transferInvest"}
                      withModelName:@"NowProjectDetailViewModel"
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       [self.investsArray removeAllObjects];
                       //NSLog(@"债权列表详情:%@===loanId:%@",responseObject,self.loanId);
                       if ([NSObject isNotEmpty:responseObject]) {

                           for (id models in responseObject) {

                               NowProjectDetailViewModel *model=(NowProjectDetailViewModel *)models;
                               [self.investsArray addObject:model];
                           }
                       }
                       
                       
                       
                   } requestFailer:^(NSInteger errorCode, NSString *errorMessage) {
                       
                   }];
        
        return nil;
    }] doNext:^(id x) {
        
        
    }] doError:^(NSError * _Nonnull error) {
        
    }];
}


@end

//
//  CYWAssetsPlanViewModel.m
//  CYW
//
//  Created by jktz on 2017/10/16.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "CYWAssetsPlanViewModel.h"
@interface CYWAssetsPlanViewModel()
@property (nonatomic, retain) NSArray *selectType;
@end
@implementation CYWAssetsPlanViewModel
- (instancetype)init{
    if (self=[super init]) {
        
        self.datassetslArray=[NSMutableArray array];
        self.selectType=@[@"hk",@"jq",@"tb"];
        [self initSubView];
    }
    return self;
}
- (void)initSubView{
    
    @weakify(self)
    _refresPlanCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self)
        return [[self refreshPlantData] takeUntil:self.rac_willDeallocSignal];
    }];
    
}


- (RACSignal *)refreshPlantData{
    @weakify(self)
    return [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        if (1==self.refreshIndex) {
            self.curpageIndex=1;
        }else{
            self.curpageIndex++;
        }
        
        NSDictionary *dict=[NSDictionary dictionary];
        //还款中的数据 按照日查询
        if (100==[self.object[@"tag"] integerValue]&&
            1000==[self.object[@"select"] integerValue]) {
            
            
            dict=@{@"userId":[Login sharedInstance].token,
                   @"curPage":@(self.curpageIndex),
                   @"size":@"10",
                   @"op":[NSString stringWithFormat:@"%@",self.selectType[[self.object[@"tag"] integerValue]-100]],
                   @"month":@"",
                   @"startTime":self.object[@"startTime"],
                   @"endTime":self.object[@"endTime"]};
        }
        //还款中  按照单月查询
        else  if (100==[self.object[@"tag"] integerValue]&&
                  1001==[self.object[@"select"] integerValue]) {
            
            
            dict=@{@"userId":[Login sharedInstance].token,
                   @"curPage":@(self.curpageIndex),
                   @"size":@"10",
                   @"op":[NSString stringWithFormat:@"%@",self.selectType[[self.object[@"tag"] integerValue]-100]],
                   @"month":self.object[@"startTime"],
                   @"startTime":@"",
                   @"endTime":@""};
        }  //还款中  按照双月月查询
        else  if (100==[self.object[@"tag"] integerValue]&&
                  1002==[self.object[@"select"] integerValue]) {
            
            
            dict=@{@"userId":[Login sharedInstance].token,
                   @"curPage":@(self.curpageIndex),
                   @"size":@"10",
                   @"op":[NSString stringWithFormat:@"%@",self.selectType[[self.object[@"tag"] integerValue]-100]],
                   @"month":@"",
                   @"startTime":self.object[@"startTime"],
                   @"endTime":self.object[@"endTime"]};
        }else{
            
            dict=@{@"userId":[Login sharedInstance].token,
                   @"curPage":@(self.curpageIndex),
                   @"size":@"10",
                   @"op":[NSString stringWithFormat:@"%@",self.selectType[[self.object[@"tag"] integerValue]-100]],
                   @"month":@"",
                   @"startTime":@"",
                   @"endTime":@""};
        }
        
        
        //NSLog(@"dict:%@",dict);
        [AFNManager postDataWithAPI:@"myInvestRequestHandler"
                      withDictParam:dict
                      withModelName:@""
                            isModel:YES
                   requestSuccessed:^(id responseObject) {
                       // NSLog(@"我的还款计划:%@",responseObject);
                       @strongify(self)
                       if (1==self.refreshIndex) {
                           [self.datassetslArray removeAllObjects];
                       }
                       CGFloat investTotal=0.0f;
                       CGFloat reimbursementTotal=0.0f;
                       CGFloat onlyTotal=0.0f;
                       CGFloat hkTotal=0.0f;
                       CGFloat whTotal=0.0f;
                       if ([NSObject isNotEmpty:responseObject]&&[NSObject isNotEmpty:responseObject[@"data"]]) {
                           
                           id object=[NSObject data:responseObject[@"data"] modelName:@"ConditionViewModel"];
                           for (id models in object) {
                               
                               ConditionViewModel *model=(ConditionViewModel *)models;
                               ConditionViewModels *viewmodels=(ConditionViewModels *)model.repayRoadmap;
                               
                               if ([model.status isEqualToString:@"repaying"]||[model.status isEqualToString:@"overdue"]) {
                                   
                                   hkTotal+=[model.investMoney floatValue];
                                   whTotal+=[viewmodels.unPaidCorpus floatValue]+[viewmodels.unPaidInterest floatValue];
                               }
                               
                               //计算总的合计
//                               investTotal+=[viewmodels.paidCorpus floatValue]+[viewmodels.paidInterest floatValue]+[viewmodels.unPaidCorpus floatValue]+[viewmodels.unPaidInterest floatValue];
                               investTotal+=[model.investMoney floatValue];
                               
                               //没有收的利息等于
                               reimbursementTotal+=[viewmodels.unPaidInterest floatValue]+[viewmodels.paidInterest floatValue];
                               
                               //已经收的利息等于   已经收的本金+已经收的利息
                               onlyTotal+=[viewmodels.paidInterest floatValue];
                               //}
                               
                               [self.datassetslArray addObject:model];
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
@end

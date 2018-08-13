//
//  CYWMoreAutomaticViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/23.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@interface CYWMoreAutomaticViewModel : BaseViewModel
@property (nonatomic, copy) NSString *investMoney;//投标金额
@property (nonatomic, copy) NSString *remainMoney;//保留金额
@property (nonatomic, copy) NSString *save;//最小投资金额
@property (nonatomic, copy) NSString *minRate;//最小利率
@property (nonatomic, copy) NSString *maxRate;//最大利率
@property (nonatomic, copy) NSString *minDeadline;//最小期限
@property (nonatomic, copy) NSString *maxDeadline;//最大期限
@property (nonatomic, copy) NSString *type;//类型

@property (nonatomic, retain) RACCommand *autoCommand;

@property (nonatomic, retain) RACCommand *autoCloseCommand;

@property (nonatomic, retain) RACCommand *autoSuccessCommand;

@end



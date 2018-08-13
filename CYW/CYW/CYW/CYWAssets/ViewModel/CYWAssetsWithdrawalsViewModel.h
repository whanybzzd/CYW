//
//  CYWAssetsWithdrawalsViewModel.h
//  CYW
//
//  Created by jktz on 2017/10/17.
//  Copyright © 2017年 jktz. All rights reserved.
//

#import "BaseViewModel.h"

@interface CYWAssetsWithdrawalsViewModel : BaseViewModel
@property (nonatomic, copy) NSString *value;
@property (nonatomic, copy) NSString *type;
@property (nonatomic) RACCommand *refresWithdrawalsCommand;
@property (nonatomic) RACCommand *refresrechargeCommand;
@property (nonatomic) RACCommand *refresrewithdrawalCommand;

@property (nonatomic, copy) NSString *price;
@property (nonatomic, copy) NSString *free;
@property (nonatomic, copy) NSString *carId;

@end
